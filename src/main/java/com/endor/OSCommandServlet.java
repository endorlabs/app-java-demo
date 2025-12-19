package com.endor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ExecuteServlet")
public class OSCommandServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = null;
        try {
            out = response.getWriter();
        } catch (Exception e) {
            e.printStackTrace();
        }
        HtmlUtil.printHtmlHeader(response);
        HtmlUtil.startBody(response);
        HtmlUtil.printMenu(response);
        HtmlUtil.printCurrentTitle("OS Command", response);

        String form = "<form action=\"oscmd\">" +
                "Find file: <input type=\"text\" name=\"command\"><br><br>" +
                "<input type=\"submit\" value=\"Submit\">" + "</form>";
        out.println(form);

        String command = request.getParameter("command");
        
        // Security fix: Validate and sanitize input to prevent command injection
        if (command != null && !command.isEmpty()) {
            // Only allow alphanumeric characters, spaces, dots, slashes and hyphens for file paths
            if (!command.matches("[a-zA-Z0-9\\s\\-_./]+")) {
                out.println("<p style='color:red;'>Error: Invalid file path. Only alphanumeric characters, spaces, dots, slashes, hyphens and underscores are allowed.</p>");
                return;
            }
            
            // Use ProcessBuilder for safer command execution with explicit arguments
            try {
                ProcessBuilder pb = new ProcessBuilder("find", command);
                pb.redirectErrorStream(true);
                Process process = pb.start();
                out.println("<p style='color:orange;'>Warning: Command execution is inherently dangerous and should be avoided in production applications.</p>");
                out.println("<p>Command executed (with validation)</p>");
            } catch (Exception e) {
                // Security fix: Don't expose detailed error messages to users
                out.println("<p style='color:red;'>Error executing command. Please contact system administrator.</p>");
                System.err.println("Command execution error: " + e.getMessage());
            }
        }
    }
}
