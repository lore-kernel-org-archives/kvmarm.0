Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7AE3A255D
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986134; cv=none; b=svCZkUxSa8AgefUBTSYNt3T+K87/kaB/9o6A9c0cXDWjn0ATpNuOEXG+NJVSlQp9YKPekjqh9Bi4hQ8fTKyV2Q0kU7BIO2dVjean4DbSKLXxWPnq9mNI5BvImzev09YeeSbm0VmsdqpFC2bihPYzDRgKRuF31bw9knptAOxrv3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986134; c=relaxed/simple;
	bh=A8z4+6cIylVs1ax2H5EYgvCtrBN5P6YTJNVSPCHZ23w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nlB5Nyx4mdnYtaY1NL1KMEt4WcVVA3yW+DA//WHiB2XhtOKmJUSoFuC8N29zJmepm8WQCbFqtxGWmhVWMGEKqZkPLnKxQuGW87F4JVntPjMaKpTLQcDmxd/RlYlcEDZTidcRHVCdwghEw4LcYzKoJwi8CQ9gHIKF9tuBrdQmZok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ClzwthXn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ClzwthXn"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3568090851aso19113608a91.1
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986133; x=1775590933; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jSJ9JEryhSvGPhJKGI1u0Qnqsdu8hhpgpJnk/hSuiNY=;
        b=ClzwthXn01seMBwWRJr8SVWMCbrMmw5k3j9HQ0T1aY8EUT8ch1GATJZEH5zEQF8WTQ
         svMjjOD/2xyICKlX0HV5/6WySDpsNTlcylEXJATSLusGgFKOfPMah9182bU42xLpLnIP
         ZKvhnRGwhlLd3T4RnJBODSclM2DtPSgP4Rekvs3uN7sE4QvqBFPHO1x9b8decsRYJseu
         p1j+IAp4RUiRc6QjJCDZiYTybSokO9sQdGtxy8EJBEsZ8mfIRWT6po+bsCKF7RhSGcZ0
         vQSBzj8ouuoDvqH4aiURFrrAtIgsomsjUaOjW8Den0Xc7qSdcI85SPAHRWsX0BbvhJUN
         AQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986133; x=1775590933;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jSJ9JEryhSvGPhJKGI1u0Qnqsdu8hhpgpJnk/hSuiNY=;
        b=ZiFXbYgdgfiIodfR+CastjSlwUPf9Jxmm19gvhAWC/wcQXaxM8hiN51fn4TKFLd8vF
         YXrlOfPxvAffNZ3CVBnyGU4MtgbQOFRyIboC0izl9YnLrC8adrRHe36/VfGO1rXgltGA
         hYDkoSUh9NL4sR0R9G7sGQmrvlG+V2o+QxNZW5cYXkwXgUIXTjwjo/qLXwWw/d6UBgpf
         Jcg5/KV0fbsAATUQOfS0sjGr5vcmhpE6+jy0ist5FSwf9fB2PBPeHsjIg4k5R6B3oDlY
         96FIcdRhoG27WgqbEILhcszva/nY7zkkqtdgxAWSWGRIcI5Y7+VBf25Etj5Acz45GOFE
         pSjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn3D4YiUjbLgQjqMafNBZW1yf7NG1tLDJ7ASsJiD23gPLTE+mqXMnGTs21thq/+Ifrjjv4D0o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzkgi5p9IVszimYL80+fzSV8pSVI2nPwyvt7MW1SVzJJNprfM8a
	Y9P5EGX5IBR2N697QusrisG5KtlLKdj415IfXha2pzejE7O5CVYaRqL1ZjXf/DnY2NPkyFfanSD
	ba9kqBTF0aQ==
X-Received: from pgah15.prod.google.com ([2002:a05:6a02:4e8f:b0:c75:7a93:9b8f])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d88:b0:38b:d9b5:5de2
 with SMTP id adf61e73a8af0-39ef7792bc2mr470704637.50.1774986132379; Tue, 31
 Mar 2026 12:42:12 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:41:53 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-1-vipinsh@google.com>
Subject: [PATCH v4 0/9] KVM: selftests: Create KVM selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This is v4 of KVM selftest runner.

To recap, KVM Selftest Runner allows running KVM selftests with added
features not present in default kselftest infrastructure like
parallelism, user friendly output, saving output hierarchically, etc.
Check README file in the patch 9.

This series is also available on github at:

https://github.com/shvipin/linux kvm/selftests/runner-v4

v4:
- Copy runner code and default test case files to out-of-tree build
  directory.
- Added comparison with kernel selftest framework.
- Added python minimum version (3.6) check for the runner.
- Bug fix where runner was not handling the child process output if returned in
  bytes instead of string.

v3: https://lore.kernel.org/kvm/20250930163635.4035866-1-vipinsh@google.com/
- Created "tests_install" rule in Makefile.kvm to auto generate default
  testcases, which will be ignored in .gitignore.
- Changed command line option names to pass testcase files, directories,
  executable paths, print based on test status, and what to print.
  Removed certain other options based on feedback in v2.
- Merged command.py into selftest.py
- Fixed issue where timed out test's stdout and stderr were not printed.
- Reduced python version from 3.7 to 3.6.
- Fixed issue where test status numerical value was printed instead of
  text like PASSED, FAILED, SKIPPED, etc.
- Added README.rst.

v2: https://lore.kernel.org/kvm/20250606235619.1841595-1-vipinsh@google.com/
- Automatic default test generation.
- Command line flag to provide executables location
- Dump output to filesystem with timestamp
- Accept absolute path of *.test files/directory location
- Sticky status at bottom for the current state of runner.
- Knobs to control output verbosity
- Colored output for terminals.

v1: https://lore.kernel.org/kvm/20250222005943.3348627-1-vipinsh@google.com/
- Parallel test execution.
- Dumping separate output for each test.
- Timeout for test execution
- Specify single test or a test directory.

RFC: https://lore.kernel.org/kvm/20240821223012.3757828-1-vipinsh@google.com/


Vipin Sharma (9):
  KVM: selftest: Create KVM selftest runner
  KVM: selftests: Provide executables path option to the KVM selftest
    runner
  KVM: selftests: Add timeout option in selftests runner
  KVM: selftests: Add option to save selftest runner output to a
    directory
  KVM: selftests: Run tests concurrently in KVM selftests runner
  KVM: selftests: Add various print flags to KVM selftest runner
  KVM: selftests: Print sticky KVM selftests runner status at bottom
  KVM: selftests: Add rule to generate default tests for KVM selftests
    runner
  KVM: selftests: Provide README.rst for KVM selftests runner

 tools/testing/selftests/kvm/.gitignore        |   6 +-
 tools/testing/selftests/kvm/Makefile.kvm      |  26 ++-
 tools/testing/selftests/kvm/runner/README.rst |  95 +++++++++
 .../testing/selftests/kvm/runner/__main__.py  | 189 ++++++++++++++++++
 .../testing/selftests/kvm/runner/selftest.py  |  99 +++++++++
 .../selftests/kvm/runner/test_runner.py       |  83 ++++++++
 .../2slot_5vcpu_10iter.test                   |   1 +
 .../no_dirty_log_protect.test                 |   1 +
 8 files changed, 498 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/runner/README.rst
 create mode 100644 tools/testing/selftests/kvm/runner/__main__.py
 create mode 100644 tools/testing/selftests/kvm/runner/selftest.py
 create mode 100644 tools/testing/selftests/kvm/runner/test_runner.py
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test


base-commit: df83746075778958954aa0460cca55f4b3fc9c02
-- 
2.53.0.1118.gaef5881109-goog

