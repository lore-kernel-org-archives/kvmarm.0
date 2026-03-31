Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14703A4F25
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986138; cv=none; b=oRCo0Q/wLU72uCPSrDYzehpMXMeOB5SSpixPp4fwc+DEwhWaFEKvFFvmtn32ysDZ7oL1KNdWYhw6s3h7NTnXNLSUJLMen4e9emyoc+ZNRr4d2tZ6pbrZ5GGU4xE4Z69LBtH2dBf+XKC8e6a8n36/qA+HtfdJ48ttWGx4XzTK2iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986138; c=relaxed/simple;
	bh=RsWz28mXJeJUgS3BcMK/BqnMF/erQFFQn8+hB3ZU6o0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CEV6cWblfgDDEq2DwCP4TlcNaCnjQaizV2s0gkMMPggSH/dS8BYKnQxZuEyTjTxMPYb/lhkJ66L/o52iIgvIW2CNJCSiEHUsFoMGZC02fdohRNe5PBoYZtKvxLZQX1eFyNBcTNWFdxtTT0218FTlYTJhaOJgdMTx+I8X3fGwN18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TbYhmj1t; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TbYhmj1t"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b24a00d12cso35557965ad.1
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986136; x=1775590936; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=okyRWg6SJ1Nbhs5yC14NmJAon29R3bVuhvecgVY39ps=;
        b=TbYhmj1tWYog102uelcApaXIzoPW7oI0cL6SK3zLU62L5olkW3vHHkX/cQ/KcKFh4l
         ZKG35h6EGEtnq8bh+YN1HyXj3OxpVtJ4lhaLTwyBaHFuT1oEsHGKl4bC9kIGrYOCW8o5
         AynEmhC/bqb8JuvjXEDd2ekHuA2hSXjRHs/ZG1QJMgQLEaBiIltynKt7HtYjwzYGU/xj
         t8OU5+iEf/nuXHdpYF2K8s3QWHZoqtGNDvYGQM30Fh3xH7WLxcITLueyT23qXvTdwIyB
         1PbA1IDswNWi6zK+y+PaHPrauuqLgQtKZ6Iu1t4Ts4n489hEVo3Vlx9sPxHlcU8wngVR
         EYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986136; x=1775590936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=okyRWg6SJ1Nbhs5yC14NmJAon29R3bVuhvecgVY39ps=;
        b=FZ/I+Cx/F/TLFQFGaNPTP5F867kOXLTh8y7wzfY5FiO3H+XgHfYvNhirYJMAbwoc0y
         U3pkWB0l51R4JsfRdyQN7WSl9VWjuo17TjZZ4YB09N22dMHdKM9rRitBEqNX/xJpKnVw
         7LfgvsvT3amvv6/TCMepi28Ka+W15jUVNCTSg/lXE3QPev2rfNsLyw9K52OdD0CklJqX
         Q1ifTEfFgeSCcmv9qn7Kme3cAfyQgbViqoQeA97Jb2A8klTDvOynnuRhSVQXxqEDt9Nf
         0/ipQPCdE5tFSGj33iU+CBLMGIHdmsH9MZo5nw4QMEFBluHwkIusjD4q/Vlg7DJ6XrYl
         j95g==
X-Forwarded-Encrypted: i=1; AJvYcCX1YBeH4qBPU/b6CjGC59HviUEb/zmR9gobFUyGfxBjwvHMiaVA6H48qkBPWAcykBRyAZRcg4Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCKnfVz6DQA31s/MrKsblSIYm5Wonx6vq/cXhVoh7PW7ZlsWqb
	2nxU6hjbIZcnMBqGz+avrDCvV0LVNSrS7uo11IGUMcS6/iD5vvsymFdkMWOecgziHGVpdAtecKf
	FAp17mskVEg==
X-Received: from plbmm7.prod.google.com ([2002:a17:903:a07:b0:2b0:4b14:f0e9])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:fb0:b0:2ae:5eee:7a5
 with SMTP id d9443c01a7336-2b269aca7a0mr4064425ad.12.1774986135979; Tue, 31
 Mar 2026 12:42:15 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:41:55 -0700
In-Reply-To: <20260331194202.1722082-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-3-vipinsh@google.com>
Subject: [PATCH v4 2/9] KVM: selftests: Provide executables path option to the
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
index db87f426331d..9b6c78e69c64 100644
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
index 5a86f9ceedd4..c1720897c629 100644
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
2.53.0.1118.gaef5881109-goog

