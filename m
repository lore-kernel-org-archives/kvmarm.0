Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4F919FA93
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250211; cv=none; b=iRbHMKsDAAKUS2L7otd154/+ketBwozJ6SyMU1ew9ha9SvTtSZ+G5zwHMNYy0UkzlOo/Dj8BXxthycctaa++olZty7V7bC9ro/wcvcGnfA3pv1gt21MvRRx6Q9k+XCciWUWKTcMZxLEGzf+9/SRwE8h27z0VJ0GH19q3gc5gi30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250211; c=relaxed/simple;
	bh=6kgZ+o75xEJ9EbdBpm/V0tjYB3JQHgta7TJivYfMla0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DmFw2fXCnHCgQHU/wpUD52amHO+9os6yfvSdn7XIHQCi/JRaGX6ugEAFIo8lc66S1FCdA8ZN/e+89QqWYjGNhHnsr1/fBYhB9Nx7JIReCtQ/3D8i7ua0J9bn+ObWvFauYGpyIUDThRgyEtc34pGBQ/cUurM7gIXtTf5UHR91VBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QSzzUGa1; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QSzzUGa1"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-780fb254938so5296370b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250209; x=1759855009; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q5LgePzkRxjmi424htLltNXg1q5zxRKaifVE5Syh82s=;
        b=QSzzUGa1VPWoEbUvduCzekSsOi5JrpGIlL+4quGjlZHhaB7jIB3AqLjnmYfBWQMgul
         hol1hplkXgUpRN6Th9HUHUEz20AxyTkYxKAFfjwfmjA8E29e3BkP2e/sWBLxfcPtl6Ur
         fsS1pDSxRDU2AryBgm/Jxzy9BFkw7T+BaqqW6+amtDFBoB9wDbY5rExYSoqBLKcncViE
         Rero3rfm3Cfx+SY1fGkCaGGZk4zTQRoaicIJoLG8uJ8+abXXgKttAwRVY4x0ZvmaVfTJ
         Vc62+XoChZ23G2YkWcZNA8/depo+c9ZtHtfcAZoPASTAXFUP7e0SKWECbXjgJ/ckruAQ
         pzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250209; x=1759855009;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5LgePzkRxjmi424htLltNXg1q5zxRKaifVE5Syh82s=;
        b=sNiKvxKsQBb3q6ffe1S71l+JeBurjYmM4sXBHhekx4F2BN2hN28rq8S4zw7iCZ9zLC
         gMuLnfH0hQfvXl8yxrgY52xX5Myxg+vv8XAZEflov1dYxEvgg1Sr3Mv6LaEq8tx6/lUU
         IuBhVdQ6Ys8b6tE6jR5jjezlWtRSkQLGfs8S/B/zvVOqg2IfQwD5CYhehRRo+mCDSVF9
         CiVVNwz5Og6MEVc0E76f5bpVdFl4VKvcopJmGi9rcLQ3n2xCpnHXf+R+TXrh5tKUnU/6
         SlpIc8mTgEn6jsjIk3oXdeqsupYXmcmlF+PINbnSkkrCippwC2Q6YZioRCOXxz5mW32q
         JcMg==
X-Forwarded-Encrypted: i=1; AJvYcCXcEB7NtErFHNwDiP6IKgpCWjAfgqBgz6a8nvX1gzwbIm6yGmiDP+9DHNZio0W0y4G6rXCfr2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRwrR/P9Zwz93o3mXgystDkdZYu2YRzpbFsIs2tserLlPO7UQF
	IcASmRaprSkOWM/HZWzAINiZdRyFZxM+rQVFhKrsSO7ZgFN504wjs1NlCmz/dqzgVVxcDF8lDjT
	0RaGgFUD79g==
X-Google-Smtp-Source: AGHT+IFfwV3VactE4ba6FoRVHzTuew8H79oNEwJxTcAq0uf0cCqCG98iICrJcj6DOYhQRbECloIyWc7dk2Ej
X-Received: from pfoh10.prod.google.com ([2002:aa7:86ca:0:b0:77c:4a2a:9783])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa3:b0:2e8:6bf6:7d6c
 with SMTP id adf61e73a8af0-321d8452cb1mr555553637.2.1759250208788; Tue, 30
 Sep 2025 09:36:48 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:26 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-1-vipinsh@google.com>
Subject: [PATCH v3 0/9] KVM Selftest Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This is v3 of KVM selftest runner. After making changes on feedback
given in v2, this series has reduced from 15 patches to 9 patches. I
have tried to address all of the comments from v2. There are none left
open and are incorporated to best of my understanding. 

To recap (copied from v2), KVM Selftest Runner allows running KVM
selftests with added features not present in default selftest runner
provided by selftests framework.

This Runner has two broad goals:
1. Make it easier for contributors and maintainers to run various
   configuration of tests with features like preserving output,
   controlling output verbosity, parallelism, different combinations of
   command line arguments.
2. Provide common place to write interesting and useful combinations of
   tests command line arguments to improve KVM test coverage. Default
   selftests runner provide little to no control over this.

Future patches will add features like:
- Print process id of the test in execution.
- CTRL+C currently spits out lots of warning (depending on --job value).
  This will be fixed in the next version.
- Add more tests configurations.
- Provide a way to set the environment in which runner will start tests. For
  example, setting huge pages, stress testing based on resources
  available on host.

This series is also available on github at:

https://github.com/shvipin/linux kvm/sefltests/runner-v3

v3:
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
 tools/testing/selftests/kvm/Makefile.kvm      |  20 ++
 tools/testing/selftests/kvm/runner/README.rst |  54 +++++
 .../testing/selftests/kvm/runner/__main__.py  | 184 ++++++++++++++++++
 .../testing/selftests/kvm/runner/selftest.py  | 105 ++++++++++
 .../selftests/kvm/runner/test_runner.py       |  79 ++++++++
 .../2slot_5vcpu_10iter.test                   |   1 +
 .../no_dirty_log_protect.test                 |   1 +
 8 files changed, 449 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/runner/README.rst
 create mode 100644 tools/testing/selftests/kvm/runner/__main__.py
 create mode 100644 tools/testing/selftests/kvm/runner/selftest.py
 create mode 100644 tools/testing/selftests/kvm/runner/test_runner.py
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
 create mode 100644 tools/testing/selftests/kvm/tests/dirty_log_perf_test/no_dirty_log_protect.test

-- 
2.51.0.618.g983fd99d29-goog

