Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1AF23D7D1
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250214; cv=none; b=jidC8F+xDqougEiJTooYlIeaxPdZza3gti++/B+5uk87VaKjSDOzn/ljvSLMHi2CnK+5AUTG2C06lTop7t47IHGFixxjC/3iniue/XeQEs5nt+hSKyzPjh0iaAd1Bpk6vfTJrtlNLE/YQVnjKqmD9UY14UydgbBKQXQaocP9Lts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250214; c=relaxed/simple;
	bh=kLygl0SPMeE6v2PxNRdsuri9gfw3S5XMZpA7QdRH8fU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=caT04De++PfWTh9DWgT9A3NA2+6mB0NioqpghSpyo2BZhU7X+nczFHEWoDH3rLYqZW6q52afot4vgpO36ktmeRZFbuZsgc5Q85m0c5olBidOp20YC91wtnHLkzi+XIWkFsqjQIGvFBUOsEexzZ5oUEdVIFQxrlT+9Q7wXm3BjM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bqrXZvWC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bqrXZvWC"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-336b646768eso4555672a91.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250212; x=1759855012; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y+zFjp+5NM5jNpiAGubNmlLxuVM2bHjpWFC3hzUQlno=;
        b=bqrXZvWCkR+FNqBLgCjpOj64DX3Alq1ixi2rv0IqMlkaEJqVKnbdMdMvmtT5PsTT9T
         oKicFem1tykG53NWPWwiF4euIpsTTzkR9Jx+YXjW2KMSXGKWrbyX4v4OFz7hPQYlitEu
         HQhb3AMecBotY1eho7meUAORyda6lUGhkqfQBP4godo1BjjEUOTOx9CMGzWRyngU3yBR
         Sg4hTAv6XhKQqt14M3c+laxE+53it2GMNaZ8z4M65BzpmpoCWhc4nlxm7yFBf6SQJ1rn
         aPaakRgUD1SoM5tJMRtUYPvrK4rFOJlaqhlkByqqHdoVOb9fLAZC9x6KBP+x2/FqqENm
         Sc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250212; x=1759855012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+zFjp+5NM5jNpiAGubNmlLxuVM2bHjpWFC3hzUQlno=;
        b=TOUtLOV9UCqLddChzJT/VmBV02rOB6m5R6k3lwPyfB/RZcTwPBAtViaJd3u5ofRvw8
         HE7bjk9XF8w4GIQ9+tfySaHLni55HHrBC+z9JnUdLOEZQf3S0iO63AKRzRXc/s3PrpUY
         TPW9/vImckmjH5CnUK+G5DZ9xt8NzJeQ3xHhq5PwD4OvJORxHD4Ncza7iLBc5PFoK7oS
         6MvSedLwX28Hq7Xc01E8Bsykgostb4PDSbweQSi8Hlp+g/EPcUjJ/ZAvzdCcVgnHnCr7
         33jzKT6uRxhqs0pGcSBBHLb9p7eFnATsCRpXqMQ3EK9WtmJwL/o1GgMf/mrTaUuUkJJV
         UTyg==
X-Forwarded-Encrypted: i=1; AJvYcCV8qkc8G4kMUd10Uv6EBb804eVFf23hxAH/rEhdgcrK7bCq61rvGmgsDQ3b9p9iabOffKFun4k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVgMZ7pnVKFhTsUSr1Kq7FVvUE0ImPLcL4Ii+WtFa2QMm5lPyz
	XcVXdcTaaP9AcAwIOJqo6AV4PPtPxoFCLRPPji9eexj3v7zL8b89XSD98NmFSKh7kCZ2BiuE/oo
	a8316/DkXVw==
X-Google-Smtp-Source: AGHT+IFs2HoXuNbjJ6THNWiEgkTSiX/5Eo4qEtefSIhRbGYg0YLR1fsOEVA+aC+FeUieWz082F7fpocBNbqJ
X-Received: from pjup24.prod.google.com ([2002:a17:90a:d318:b0:329:e84e:1c50])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8f:b0:32e:7270:94a0
 with SMTP id 98e67ed59e1d1-339a6f84e2amr100040a91.33.1759250212045; Tue, 30
 Sep 2025 09:36:52 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:28 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-3-vipinsh@google.com>
Subject: [PATCH v3 2/9] KVM: selftests: Provide executables path option to the
 KVM selftest runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add command line option, -p/--path, to specify the directory where
test binaries exist. If this option is not provided then default
to the current directory.

Example:
  python3 runner --dirs test -p ~/build/selftests

This option enables executing tests from out-of-tree builds.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/runner/__main__.py    | 8 +++++++-
 tools/testing/selftests/kvm/runner/selftest.py    | 4 ++--
 tools/testing/selftests/kvm/runner/test_runner.py | 4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 8d1a78450e41..943c3bfe2eb6 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -31,6 +31,12 @@ def cli():
                         default=[],
                         help="Run the testcases present in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")
 
+    parser.add_argument("-p",
+                        "--path",
+                        nargs='?',
+                        default=".",
+                        help="Finds the test executables in the given path. Default is the current directory.")
+
     return parser.parse_args()
 
 
@@ -87,7 +93,7 @@ def main():
     args = cli()
     setup_logging()
     testcases = fetch_testcases(args)
-    return TestRunner(testcases).start()
+    return TestRunner(testcases, args).start()
 
 
 if __name__ == "__main__":
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index 34005f83f0c3..a94b6d4cda05 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -28,12 +28,12 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path):
+    def __init__(self, test_path, path):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
 
-        test_command = os.path.join(".", test_command)
+        test_command = os.path.join(path, test_command)
         self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
         self.test_path = test_path
         self.command = test_command
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 4418777d75e3..acc9fb3dabde 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -11,11 +11,11 @@ logger = logging.getLogger("runner")
 
 
 class TestRunner:
-    def __init__(self, testcases):
+    def __init__(self, testcases, args):
         self.tests = []
 
         for testcase in testcases:
-            self.tests.append(Selftest(testcase))
+            self.tests.append(Selftest(testcase, args.path))
 
     def _log_result(self, test_result):
         logger.info("*** stdout ***\n" + test_result.stdout)
-- 
2.51.0.618.g983fd99d29-goog

