Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B87242D7F
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254209; cv=none; b=tcxxCdYjHsRKOfTJyKXn+EuRXd2MyddjX8Vang3OT50EKdh2coytl8gw6N74O/VlxfBxFDqsb9S2b2Z5j+7xwI3hN0MQOaJFurIwWd1z0/LufrZVvgfUXYc15WPJsSWMGcHA5qE0Mak+1da/gvjwc5FjxDtp5xzpKOSXyHa15/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254209; c=relaxed/simple;
	bh=Tbt5CxmjIkXyOBWIGl4We1H6W7+keF/4RhCn7qXusBw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BgJBN7kBuNTUp3n0kpvOsQabq+SpU3cyWnLsoRjch8w0fL8Q7yDdrT8f1GIpfhGjrlamWRxnA14/tca3VwBNUFpJzBa7YH7mESnaFA4KlG1AZLAEFD0MwBwt1Y9OGdnuxuXDytyqgIhLbzM/26Ufo71mNjWFG89GV2BAYtFIrOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=deV6dYcx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="deV6dYcx"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235e1d66fa6so22468705ad.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254207; x=1749859007; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YvWqyMXWbV+Eh1iT8lLaW4K5z1z2+DMYGYssKn0fVI=;
        b=deV6dYcxPxopqYsEGvGEwLdv3RWN+HMm5dtKTiobQ/JKcTnAYWBXzHj9kGZXGb89Xn
         P6MAyynWGBwuj0JcvOn3hciYJwhPUL3zxClge3Gl3LCxBkILVlsINBRG2KYKHTzYocxe
         M4gWBli0mjsD+056rXgeE+S+NHPEjGfpVsl3DQ1FmKOB90NYtZMwZgzuKQetM05Y9LcO
         PlajUfWirlAjlLVmVFByLy1kwV9T0jqbD7rnRef4UAcNjJrZaUKLTJpGeBAsimytGIP9
         EMqtgwYCu6n92TQQJbTNqIbIjnHKLzpKYErKhxvoopyCLt5B8Akz26WX5tj0vUOfWcWY
         O/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254207; x=1749859007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2YvWqyMXWbV+Eh1iT8lLaW4K5z1z2+DMYGYssKn0fVI=;
        b=qmh7g1vEq4Yu87GTbtDCX62WcOyUVTpIhN0Mm/cbB6KlV1dsceDqQay4JgvKR3G74W
         NAseKnJOt4WfRyChocG0H6Qk6x7+8NC4FYQjM7NP6UjeA4p5ciP17M8tDx1Fj51Q/vhy
         rhU61ftA1HwZsn69Vf2evobpyUm8J7pG8NK/feW96OLC6d6ge76smms33IJOXKxbyg2D
         embuZHYcuwxAZqfbOLy9Qx0PiUXNoObefLBIPaufwJy0543BlgO9wQevVT6hYYpNM3Ju
         YPPpaYQ30uD90Ri2snIDZ8bOKNSJGUpVC5yoNuTs544eU5FTPLuN/opsDYjAB66XwGpf
         4L9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWdP4bTN2WpAXblXnNgtiJA6WqesDGholWdWCwPhG/96rDi/IsCnKQz8O7TON1bmd3LMEmp9JM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpSZNAB37g75Wuc2+E5ozK+3P2Iq7AOCLio0Bc5GJHAO1Ks/ff
	tUQrDCQlbYcPFTUhJOC7scGiowHXl7FkTb2vzg0DdtzmU+HphVxONQwHBK5RNI7NI8njZZ8C4F4
	W1UzezGDt9g==
X-Google-Smtp-Source: AGHT+IECcAGloB9eLcQGrexwmZ6dfzE2vnPa3s6mRZgo8fAz19L92je+kXfcgU8ZDEV3rQMzp1fI/Bkas3Ar
X-Received: from pjbcz12.prod.google.com ([2002:a17:90a:d44c:b0:30a:31eb:ec8e])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f686:b0:224:1af1:87f4
 with SMTP id d9443c01a7336-23601cfec20mr73817855ad.22.1749254207363; Fri, 06
 Jun 2025 16:56:47 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:14 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-11-vipinsh@google.com>
Subject: [PATCH v2 10/15] KVM: selftests: Add flag to suppress all output from
 Selftest KVM Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line flag, --quiet, to suppress all of the output from
runner to terminal.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  |  8 ++++++-
 .../selftests/kvm/runner/test_runner.py       | 21 ++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 2dcac1f4d1c4..c02035a62873 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -129,6 +129,12 @@ def cli():
                         default=False,
                         help="Print only the summary status line.")
 
+    parser.add_argument("-q",
+                        "--quiet",
+                        action="store_true",
+                        default=False,
+                        help="Suppress all of the output to terminal")
+
     return parser.parse_args()
 
 
@@ -136,7 +142,7 @@ def level_filters(args):
     # Levels added here will be printed by logger.
     levels = set()
 
-    if args.sticky_summary_only:
+    if args.sticky_summary_only or args.quiet:
         return levels
 
     if args.print_passed or args.print_passed_status or args.print_status:
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index e0da30d216a2..e7730880907d 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -18,6 +18,7 @@ class TestRunner:
         self.status = {x: 0 for x in SelftestStatus}
         self.output_dir = args.output
         self.jobs = args.jobs
+        self.quiet = args.quiet
         self.print_status = args.print_status
         self.print_stds = {
             SelftestStatus.PASSED: args.print_passed,
@@ -35,17 +36,21 @@ class TestRunner:
         test.run()
         return test
 
+    def _print(self, text, end="\n"):
+        if not self.quiet:
+            print(text, end=end)
+
     def _sticky_update(self):
-        print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}" \
-                f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}" \
-                f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}" \
-                f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"\
-                f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"\
-                f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m", end="\r")
+        self._print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}"
+                    f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}"
+                    f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}"
+                    f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"
+                    f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"
+                    f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m", end="\r")
 
     def _log_result(self, test_result):
         # Clear the status line
-        print("\033[2K", end="\r")
+        self._print("\033[2K", end="\r")
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
         if (self.output_dir is None and self.print_status is False
@@ -79,5 +84,5 @@ class TestRunner:
                                                SelftestStatus.NO_RUN,
                                                SelftestStatus.SKIPPED]):
                     ret = 1
-        print("\n")
+        self._print("")
         return ret
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

