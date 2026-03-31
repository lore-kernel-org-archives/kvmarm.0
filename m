Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6426C3E5EE0
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986150; cv=none; b=jVqV6oSiKJNLlAWP1lXxr9W6RslNorchAeSjkp6DUY4OEVlLOBnwqjl8Or0a34Zen1KHMHHX3iM+wDlfiDospfohDjxYaXPHfkL4CkDYPJJTiQE2gFR9GU+ZyAmEzklSBuT6L93AYbOU2mddVb7Hm7MGPtA173JYKuromf+b1Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986150; c=relaxed/simple;
	bh=GITysqpsuExjWQhqq0sSrPFK14GmluxS38AFp03oq24=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GZvb/UXwd5l28GnfF7e0cDCeXYC+3fNrfidgIRRuP9n+SUGgtpnkT0dVoHTmZQ8EfYTy+Is/DK54zUGT1xnguaGV8Z2mfEnDyxxM7uP/znw/hOwdwX4eU5UZhp8NJH6Ny8o24oODxbUOxYYT2up2N0sob6HylRVK1c9paGeRFek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kRByxgHt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kRByxgHt"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c44bf176so7747525a91.0
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986149; x=1775590949; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4VWnO9ZqBqweDz2fb12798lX7BIjzp/risNDY0rLawk=;
        b=kRByxgHt++cfGRZUlRH2QGJ/uQZc6JYkfcDA/nhec4tIjaHF1Vb+3qsHgIkahG2N4P
         DSvcLuj1f1WD9MAvi/ECnfYFWA5w6/OspHWSKP4ho45dCSJgisFwP4kjrM94xqwRdunR
         TSJ8w9lCXfWyIvwUNHmOtcSos3kaL41kFbNOXmcXsxYoFzcOEAVkUuSwZJMFjSpVF0oe
         MBYWbmnEQKJCq1uVVwgjlvKlwXrxvPbXLyrJ+QtijFzRBe/4Nnm5HbtAlW4ym9IYT7gK
         2Wco87BUBSvuXGG8qIgsY9Lx830ZxBE8+qZkME769it+9VdKRkZYFXEr15xo/tzkzwqu
         Y55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986149; x=1775590949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4VWnO9ZqBqweDz2fb12798lX7BIjzp/risNDY0rLawk=;
        b=PDshYelDpqUvz1H7a9osAFTsziKzDlDxNgqjFzvOBMH2AwiKJwCt+66+ZF9jzGkBuQ
         65+Udid6tcZ7mprK2NBREVoMxnexF1w6f02jCD5P2lGRa1zqebY2NVP7fVoaifGpmUlu
         NGDlnxEMwfqHKYpEk1u6yomhRJGhVDiomUSNsBYvjQZDsbrJKrqCD/1MCCFtPOWNsLaO
         evhKh0z73JInmP4rY750aEcKes2SnjBivq2hfz2IUF/sjrWUzLGmYKyz3I6/yeNk7A2o
         POH8VZIV+iQw+QdYQS7zqzsIVq+JY+UqEelCUIGut2yEFzv/Zan23swEY2WFHdghYRho
         +fEA==
X-Forwarded-Encrypted: i=1; AJvYcCXCCse0j4yEY6nbEZ2lOrX0/jCe6ciQbSrwsETt/rbVy9NDBabZPFCJtD7bbKQg+dXRj4o1zQg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTvAlQJc+SICZlLcpZ+FcO4+LawjZBuVzsE+/ghWDyM4T91OIT
	ZeiUykuO+7uobKu29akvxGfrUzPP+KODJGcYHcEGa/9HBVs/ZZRknm0dzsNeLCASFFiZWLVnGXm
	sFAqyYBhIbw==
X-Received: from pjyw24.prod.google.com ([2002:a17:90a:ea18:b0:35d:a917:a7bf])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:528c:b0:35d:a3b4:2f0d
 with SMTP id 98e67ed59e1d1-35dc6e77eb0mr554628a91.6.1774986148828; Tue, 31
 Mar 2026 12:42:28 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:42:02 -0700
In-Reply-To: <20260331194202.1722082-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-10-vipinsh@google.com>
Subject: [PATCH v4 9/9] KVM: selftests: Provide README.rst for KVM selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add README.rst for KVM selftest runner and explain how to use the
runner.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/runner/README.rst | 95 +++++++++++++++++++
 2 files changed, 96 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/runner/README.rst

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 548d435bde2f..83aa2fe01bac 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -4,6 +4,7 @@
 !*.c
 !*.h
 !*.py
+!*.rst
 !*.S
 !*.sh
 !*.test
diff --git a/tools/testing/selftests/kvm/runner/README.rst b/tools/testing/selftests/kvm/runner/README.rst
new file mode 100644
index 000000000000..e264c78ace68
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/README.rst
@@ -0,0 +1,95 @@
+KVM Selftest Runner
+===================
+
+Execute KVM selftests with high configurability. The runner supports parallel
+execution, hierarchical output storage, console output control, and execution
+status reporting.
+
+Compatibility with KVM Selftests
+===============================
+
+The runner acts as a non-intrusive wrapper around the existing KVM selftests.
+It does not modify the underlying test binaries or the way they are built.
+You can still run KVM selftests using traditional methods without any conflict:
+
+- Execute binaries directly: ``./dirty_log_perf_test -v 4``
+- Use the standard kselftest framework: ``make -C tools/testing/selftests TARGETS=kvm run_tests``
+
+Comparison with kselftest framework
+===================================
+
+While the standard ``kselftest`` framework provides basic execution and reporting,
+this runner is designed for more advanced testing scenarios and offers several
+advantages:
+
+- **Flexible Test Selection**: Unlike some ``kselftest`` options that may use a
+  fixed ``suite:test`` syntax for selection, this runner leverages the
+  filesystem. You can group tests into directories (acting as suites) or
+  provide a list of specific test files, offering a more intuitive way to
+  organize and execute subsets of tests.
+- **Parallel Execution**: Run tests concurrently using the ``-j`` flag to
+  significantly reduce total execution time.
+- **Granular Output Control**: Control exactly what gets printed to the console
+  for passed, failed, skipped, or timed-out tests.
+- **Hierarchical Logging**: Automatically save the stdout and stderr of every
+  test into a structured directory tree, making it easy to debug failures in
+  large test runs.
+- **Out-of-Tree Support**: Easily run test binaries located in a different
+  directory using the ``-p`` flag.
+
+Generate Default Tests
+======================
+
+Generate the default test case files using the provided make target::
+
+  # make tests_install
+
+This creates the ``testcases_default_gen`` directory containing ``default.test``
+files. Each KVM selftest has a directory with a ``default.test`` file. This file
+contains the executable path relative to the KVM selftest root directory
+(``/tools/testing/selftests/kvm``). For example, the ``dirty_log_perf_test``
+entry looks like::
+
+  # cat testcases_default_gen/dirty_log_perf_test/default.test
+  dirty_log_perf_test
+
+In above testcase, the runner executes ``dirty_log_perf_test``. Testcase files
+can provide extra arguments to the test::
+
+  # cat tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
+  dirty_log_perf_test -x 2 -v 5 -i 10
+
+In this case, the runner executes ``dirty_log_perf_test`` with the specified
+options.
+
+Examples
+========
+
+Display all options::
+
+  # python3 runner -h
+
+Run all default tests::
+
+  # python3 runner -d testcases_default_gen
+
+Run tests in parallel::
+
+  # python3 runner -d testcases_default_gen -j 40
+
+Print only passed test status and failed test stderr::
+
+  # python3 runner -d testcases_default_gen --print-passed status \
+  --print-failed stderr
+
+Run test binaries from a different directory (e.g., out-of-tree builds)::
+
+  # python3 runner -d testcases_default_gen -p /path/to/binaries
+
+Save all test outputs (stdout, stderr, status) to a directory::
+
+  # python3 runner -d testcases_default_gen -o test_outputs
+
+Run specific testcase files::
+
+  # python3 runner -t tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
-- 
2.53.0.1118.gaef5881109-goog

