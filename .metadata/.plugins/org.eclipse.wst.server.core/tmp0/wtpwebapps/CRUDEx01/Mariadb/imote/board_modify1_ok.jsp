<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>

<%
	request.setCharacterEncoding( "utf-8" );

	String seq = request.getParameter( "seq" );
	String emot = request.getParameter("emot").substring(request.getParameter("emot").length() -2 );
	System.out.println(emot);
	System.out.println(seq);
	String subject = request.getParameter( "subject" );
	String mail = "";
	if( !request.getParameter( "mail1" ).equals( "" ) && !request.getParameter( "mail2" ).equals( "" ) ) {
		mail = request.getParameter( "mail1" ) + "@" + request.getParameter( "mail2" );
	}
	String password = request.getParameter( "password" );
	String content = request.getParameter( "content" );
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	int flag = 2;
	
	try {
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup( "java:comp/env" );
		DataSource dataSource = (DataSource)envCtx.lookup( "jdbc/mariadb3" );
		
		conn = dataSource.getConnection();

		String sql = "update board1 set subject=?, mail=?, content=?, emot=? where seq=? and password=?";
		pstmt = conn.prepareStatement( sql );
		pstmt.setString( 1, subject );
		pstmt.setString( 2, mail );
		pstmt.setString( 3, content );
		pstmt.setString( 4, emot );		
		pstmt.setString( 5, seq );
		pstmt.setString( 6, password );
		
		int result = pstmt.executeUpdate();
		if( result == 1 ) {
			flag = 0;
		} else if( result == 0 ) {
			flag = 1;
		}
		
	} catch( NamingException e ) {
		System.out.println( "[에러] " + e.getMessage() );
	} catch( SQLException e ) {
		System.out.println( "[에러] " + e.getMessage() );
	} finally {
		if( pstmt != null ) pstmt.close();
		if( conn != null ) conn.close();
	}
	
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('글수정에 성공');" );
		out.println( "location.href='board_view1.jsp?seq=" + seq + "';" );
	} else if( flag == 1 ) {
		out.println( "alert('비밀번호 오류');" );
		out.println( "history.back();" );
	} else {
		out.println( "alert('글수정에 실패');" );
		out.println( "history.back();" );
	}
	out.println( "</script>" );
%>