package com.endor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
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
        // Sanitize command input to prevent command injection
        if (command != null && !command.isEmpty()) {
            // Only allow alphanumeric characters, dots, slashes, hyphens, and underscores
            if (!command.matches("[a-zA-Z0-9./\\-_]+")) {
                out.println("<p style='color:red;'>Invalid characters in command. Only alphanumeric, dots, slashes, hyphens, and underscores are allowed.</p>");
                return;
            }
            // Use ProcessBuilder for safer command execution
            try {
                ProcessBuilder pb = new ProcessBuilder("find", command);
                pb.redirectErrorStream(true);
                Process process = pb.start();
                
                // Read output
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                    String line;
                    out.println("<h3>Results:</h3><pre>");
                    while ((line = reader.readLine()) != null) {
                        out.println(line);
                    }
                    out.println("</pre>");
                }
                process.waitFor();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error executing command: " + e.getMessage() + "</p>");
            }
        }
    }
}
