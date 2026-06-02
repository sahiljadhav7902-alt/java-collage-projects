<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pathology Lab System | Precision Diagnostics</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #0561FC;
            --secondary-teal: #00d2ff;
            --dark-blue: #1e293b;
            --soft-bg: #f8fafc;
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--soft-bg);
            color: var(--dark-blue);
            overflow-x: hidden;
        }

        /* Navbar Enhancement */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        /* Hero Section - Animated Gradient */
        .hero {
            background: radial-gradient(circle at top right, #e0f2fe 0%, #f8fafc 50%);
            padding: 140px 0 100px 0;
            position: relative;
        }
        
        .hero h1 {
            font-size: 3.5rem;
            font-weight: 700;
            background: linear-gradient(45deg, var(--primary-blue), var(--secondary-teal));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -1px;
        }

        /* Cards & Sections */
        .section { padding: 90px 0; }
        
        .card {
            border: none;
            border-radius: 20px;
            background: #ffffff;
            box-shadow: var(--card-shadow);
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(5, 97, 252, 0.1);
        }

        /* Icon Styling */
        .icon-box {
            width: 70px;
            height: 70px;
            background: rgba(5, 97, 252, 0.05);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        /* Stats Section */
        .stats {
            background: var(--dark-blue);
            color: white;
            padding: 60px 0;
            border-radius: 30px;
            margin: 0 20px;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--secondary-teal);
        }

        /* Process Steps */
        .step-number {
            width: 40px;
            height: 40px;
            background: var(--primary-blue);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-weight: 600;
        }

        /* Buttons */
        .btn-primary {
            background: var(--primary-blue);
            border: none;
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-primary:hover {
            background: #044ecb;
            box-shadow: 0 8px 20px rgba(5, 97, 252, 0.3);
        }

        .btn-outline-primary {
            border: 2px solid var(--primary-blue);
            color: var(--primary-blue);
            border-radius: 12px;
            font-weight: 600;
        }

        /* Footer */
        footer {
            background: #ffffff;
            padding: 40px 0;
            border-top: 1px solid #e2e8f0;
            color: #64748b;
        }
    </style>
</head>

<body>

<jsp:include page="includes/navbar.jsp" />

<%
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>

<% if(userName == null){ %>

    <section class="hero text-center">
        <div class="container">
            <span class="badge rounded-pill bg-primary bg-opacity-10 text-primary px-3 py-2 mb-3">ISO 9001:2026 Certified</span>
            <h1>Reliable & Accurate <br>Diagnostic Services</h1>
            <p class="mt-3 mb-5 mx-auto text-muted" style="max-width: 600px;">
                Experience the next generation of healthcare with world-class pathology testing, 
                AI-assisted accuracy, and rapid digital reporting.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="patient/register.jsp" class="btn btn-primary btn-lg px-5 shadow">Book a Test</a>
                <a href="login.jsp" class="btn btn-outline-primary btn-lg px-5">Member Login</a>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container text-center">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <h2 class="fw-bold mb-4">Pioneering Laboratory Excellence</h2>
                    <p class="lead text-muted">
                        We combine cutting-edge technology with compassionate care. Our laboratory is 
                        equipped with automated systems to ensure every result is precise and delivered on time.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <section class="section" style="background: #f1f5f9;">
        <div class="container text-center">
            <h2 class="fw-bold mb-2">Our Expertise</h2>
            <p class="text-muted mb-5">Specialized testing for every health need</p>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card p-5">
                        <div class="icon-box"><i class="bi bi-droplet-half fs-2 text-primary"></i></div>
                        <h5 class="fw-bold">Blood & Urine Tests</h5>
                        <p class="text-muted">Comprehensive molecular analysis with high-speed processing.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-5">
                        <div class="icon-box"><i class="bi bi-clipboard2-pulse fs-2 text-success"></i></div>
                        <h5 class="fw-bold">Health Packages</h5>
                        <p class="text-muted">Preventive checkups tailored for all age groups and lifestyles.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-5">
                        <div class="icon-box"><i class="bi bi-file-earmark-medical fs-2 text-info"></i></div>
                        <h5 class="fw-bold">Digital Reports</h5>
                        <p class="text-muted">Encrypted PDF reports delivered straight to your dashboard.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container text-center">
            <h2 class="fw-bold mb-5">How It Works</h2>
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="step-number shadow-sm">1</div>
                    <h6 class="fw-bold">Register</h6>
                    <p class="small text-muted">Create your secure health profile.</p>
                </div>
                <div class="col-md-3">
                    <div class="step-number shadow-sm">2</div>
                    <h6 class="fw-bold">Book Test</h6>
                    <p class="small text-muted">Select from 500+ diagnostic tests.</p>
                </div>
                <div class="col-md-3">
                    <div class="step-number shadow-sm">3</div>
                    <h6 class="fw-bold">Sample Collection</h6>
                    <p class="small text-muted">Visit us or request a home visit.</p>
                </div>
                <div class="col-md-3">
                    <div class="step-number shadow-sm">4</div>
                    <h6 class="fw-bold">Get Report</h6>
                    <p class="small text-muted">View results online within 24 hours.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="stats text-center shadow-lg">
                <div class="row">
                    <div class="col-md-3 border-end border-secondary border-opacity-25">
                        <div class="stat-number">15K+</div>
                        <p class="mb-0 text-white-50">Tests Conducted</p>
                    </div>
                    <div class="col-md-3 border-end border-secondary border-opacity-25">
                        <div class="stat-number">8K+</div>
                        <p class="mb-0 text-white-50">Happy Patients</p>
                    </div>
                    <div class="col-md-3 border-end border-secondary border-opacity-25">
                        <div class="stat-number">60+</div>
                        <p class="mb-0 text-white-50">Expert Staff</p>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-number">99.2%</div>
                        <p class="mb-0 text-white-50">Accuracy Rate</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container text-center">
            <h2 class="fw-bold mb-5">Patient Stories</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card p-4 text-start h-100">
                        <div class="text-warning mb-3"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="fst-italic">"Excellent service and quick reports! The online dashboard is so easy to use."</p>
                        <h6 class="fw-bold mt-auto mb-0">- Rahul Sharma</h6>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-4 text-start h-100">
                        <div class="text-warning mb-3"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="fst-italic">"Professional staff and modern equipment. I felt very safe during my collection."</p>
                        <h6 class="fw-bold mt-auto mb-0">- Priya Verma</h6>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-4 text-start h-100">
                        <div class="text-warning mb-3"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="fst-italic">"Highly accurate results and very affordable health packages. Highly recommended."</p>
                        <h6 class="fw-bold mt-auto mb-0">- Amit Singh</h6>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="section text-center mb-5">
        <div class="container">
            <div class="p-5 rounded-4 shadow-sm" style="background: linear-gradient(135deg, #0561FC 0%, #00d2ff 100%); color: white;">
                <h2 class="fw-bold mb-3">Ready to Book Your Test?</h2>
                <p class="mb-4 opacity-75">Join thousands of patients who trust us with their health diagnostics.</p>
                <a href="patient/register.jsp" class="btn btn-light btn-lg px-5 fw-bold text-primary">Get Started Today</a>
            </div>
        </div>
    </section>

<% } else { %>

    <section class="section text-center">
        <div class="container">
            <div class="card p-5 d-inline-block shadow-lg border-0" style="max-width: 600px;">
                <div class="icon-box"><i class="bi bi-person-check fs-1 text-primary"></i></div>
                <h2 class="fw-bold">Welcome back, <%= userName %>!</h2>
                <p class="text-muted mb-4">You are logged in as <span class="badge bg-primary bg-opacity-10 text-primary"><%= userRole %></span></p>
                
                <a href="<%= userRole.equals("patient") ? "patient/dashboard.jsp" : 
                           userRole.equals("physician") ? "doctor/doctorDashboard" : 
                           "admin/adminDashboard.jsp" %>" 
                   class="btn btn-primary btn-lg w-100">
                    Go to Dashboard
                </a>
            </div>
        </div>
    </section>

<% } %>

<footer class="text-center">
    <div class="container">
        <p class="mb-0">&copy; 2026 Pathology Lab System | <span class="text-primary fw-bold">Precision in Every Result</span></p>
        <div class="mt-2 small text-muted">Designed with care for a healthier tomorrow</div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>