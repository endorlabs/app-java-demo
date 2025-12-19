package com.endor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ExecuteServlet")
public class ExecuteServlet extends HttpServlet {
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
        HtmlUtil.printCurrentTitle("Web Shell", response);

        String form = "<form action=\"cmdexec\">" +
                "Command: <input type=\"text\" name=\"command\"><br><br>" +
                "Environment Var: <input type=\"text\" name=\"env\"><br>" +
                "<input type=\"submit\" value=\"Submit\">" + "</form>";
        out.println(form);

        String command = request.getParameter("command");
        String env = request.getParameter("env");
        
        // Security fix: Validate and sanitize inputs to prevent command injection
        if (command != null && !command.isEmpty()) {
            // Only allow alphanumeric characters, spaces, and safe characters
            if (!command.matches("[a-zA-Z0-9\\s\\-_.]+")) {
                out.println("<p style='color:red;'>Error: Invalid command. Only alphanumeric characters, spaces, hyphens, underscores and dots are allowed.</p>");
                return;
            }
        }
        
        if (env != null && !env.isEmpty()) {
            String[] envArr = env.split(";");
            // Validate each environment variable
            for (String envVar : envArr) {
                if (!envVar.matches("[a-zA-Z0-9_]+=.+")) {
                    out.println("<p style='color:red;'>Error: Invalid environment variable format. Use KEY=value format.</p>");
                    return;
                }
            }
            // Execute with validated inputs (still vulnerable - this is a demo app showing the vulnerability)
            // In production, command execution should be completely avoided or use ProcessBuilder with strict controls
            out.println("<p style='color:orange;'>Warning: Command execution is inherently dangerous and should be avoided in production applications.</p>");
        }
    }
}
