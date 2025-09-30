Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35224257834
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250222; cv=none; b=DMOnpuEhr1/vAv07xHtuKQ9oaA0BBp65qrpLGeYwaXcacoDCgHrDcdVJRecTo8cpjjfN24vtkbXta8FuUdEHI8sV03r7X8yPhJIpG99PQPxBO3NUrL6ZMAHcpOzIIh2xX5F0g8aR5he4esy9nrT0OqEQXYOdc7+ipPWHsME97s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250222; c=relaxed/simple;
	bh=fWBQvt8bKN+5MW/gnO5saP7mD9az3949yN/IfQk5Tg4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ud4jQ8XnQ/9KZq5NPm820aB0Xw0ai+3rB8h1lrah6F5LtNTRNWJJzHykiZn8ZWPlDmAB8mqFeqpMwxBZAOZiyRFE1tnlWygd7GO9jhEpfMnnqlZGAeq5M7sD1HoVQiYpz+bQW3/KluBHc+dziMZoXWMO7JMhHhQj0bUpJvPPm5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2kaco0tW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2kaco0tW"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339a6d9defdso91803a91.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250220; x=1759855020; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OUg12Od11PLsJD4awVDsfJr7RcaROxBR6pzVFyNdKj8=;
        b=2kaco0tWLezFAylrJ+tyr+niUu3AYdQoxJiFplktqk6jIHyFVx6+zyK5kxKlexb/Lj
         ktW6uASBK2beFZVQJwU31r7+XUs7lda+NWg7yT3NRpbwkxwuX+4bENgflqZCCZC+3gqM
         ggWzx9LeqvBUZ3F72dWFQMWxJp6gWMLs4bfybIuHrk1hXeD0QMlycFMeEJ1+FQkxzzYW
         PVhgsWvvqVMEMKKSIs3NE6I/bb6gXQJzd4kiUUxONPAiwATd7kqGBRlQjz6S+/oC0ggY
         V/550HTq9K1gPK46CSyi6sQgyuH76DByCYYefhSp1L+OWnIe6lzzdqtQzlxm7zf1thmg
         Q85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250220; x=1759855020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OUg12Od11PLsJD4awVDsfJr7RcaROxBR6pzVFyNdKj8=;
        b=ww5pLT5GBcoj8PkUz1U/lILRls2GIhIQxkKZAM5SirB0Bfd4zZmYxwizLfhwYkR7Vc
         kA02lxfF3MPy4impyOIK+ClJ9/VFxaSu34nemlH2eTVdaOLgqoXiW8diBCUt7DmV4QKL
         sO1XgJNMbSzypNcb0DOOToArmQIY3sUSwcaOe/Ua4lq8R1wPtEBod+AJHXqYjv/cX+c1
         q49I2ojTN9j7hId9tRZlJO+RFpAoQnG/pBo2qffJ/6FQDqc/bW90Sf8ldGZTgRTREORw
         qqdZgsqlr5dDXUR356todJktDTkXumdJBjRTfTo3bKPIxtP6lmRFbNu0zRKQF9E7vvtO
         niuA==
X-Forwarded-Encrypted: i=1; AJvYcCXXRQ4ZT4PowtPXlL2Y0yImryAnZSoPTyH+juVa1wCQjbvIR2REfg9KHLA25u///X8BBKD6g0k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUU+p/6rsXpRhGZ9FZFY8ABgGsmOZKT+Vji9fHDHSXtoaVcwwD
	VKzNI112NJvXY2ApFC85ypM7g21f95Vj2J/0mZem3gI81973ywBBC68ldJ8MAOPzXvmEgbG2IdY
	ICsq9dyLc1A==
X-Google-Smtp-Source: AGHT+IFs+CMWNOODVu6P+nzztd0EOiTd83LgNk/a5bScJBUGMhwZj+o12u3ClbHwdU+ZCLfO3OKClHjbbXZN
X-Received: from pjbcm23.prod.google.com ([2002:a17:90a:fa17:b0:32e:ddac:6ea5])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b08:b0:329:e9da:35e9
 with SMTP id 98e67ed59e1d1-339a6e8ff19mr118159a91.2.1759250220455; Tue, 30
 Sep 2025 09:37:00 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:33 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-8-vipinsh@google.com>
Subject: [PATCH v3 7/9] KVM: selftests: Print sticky KVM selftests runner
 status at bottom
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Print current state of the KVM selftest runner during its execution.
Show it as the bottom most line, make it sticky and colored. Provide
the following information:
- Total number of tests selected for run.
- How many have executed.
- Total for each end state.

Example:

Total: 3/3 Passed: 1 Failed: 1 Skipped: 0 Timed Out: 0 No Run: 1

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/test_runner.py | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index e8e8fd91c1ad..42274e695b76 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -15,6 +15,7 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, testcases, args):
         self.tests = []
+        self.status = {x: 0 for x in SelftestStatus}
         self.output_dir = args.output
         self.jobs = args.jobs
         self.print_stds = {
@@ -33,9 +34,18 @@ class TestRunner:
         test.run()
         return test
 
+    def _sticky_update(self):
+        print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}" \
+                f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}" \
+                f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}" \
+                f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"\
+                f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"\
+                f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m", end="\r")
+
     def _log_result(self, test_result):
         print_level = self.print_stds.get(test_result.status, "full")
 
+        print("\033[2K", end="\r")
         if (print_level == "full" or print_level == "stdout"):
             logger.info("*** stdout ***\n" + test_result.stdout)
         if (print_level == "full" or print_level == "stderr"):
@@ -43,8 +53,13 @@ class TestRunner:
         if (print_level != "off"):
             logger.log(test_result.status, f"[{test_result.status.name}] {test_result.test_path}")
 
+        self.status[test_result.status] += 1
+        # Sticky bottom line
+        self._sticky_update()
+
     def start(self):
         ret = 0
+        self.tests_ran = 0
 
         with concurrent.futures.ProcessPoolExecutor(max_workers=self.jobs) as executor:
             all_futures = []
@@ -54,9 +69,11 @@ class TestRunner:
 
             for future in concurrent.futures.as_completed(all_futures):
                 test_result = future.result()
+                self.tests_ran += 1
                 self._log_result(test_result)
                 if (test_result.status not in [SelftestStatus.PASSED,
                                                SelftestStatus.NO_RUN,
                                                SelftestStatus.SKIPPED]):
                     ret = 1
+        print("\n")
         return ret
-- 
2.51.0.618.g983fd99d29-goog

