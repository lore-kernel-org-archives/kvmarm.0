Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E777B43165
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 20:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724360194; cv=none; b=a3k4HJcYclBjuY6BAHWTl3CKiMfaPpxd06VNFeYVxVIJGCYBoUapTyb4bTT8fnShGQ1R8R4twJMCJXTfzEY3kWx6322o1eIGcLG47fdUhfDPih0Hq3HM1z7McKAtVZyLnKut3ZdEyqy9udIj+uV+h6ryjXbJtJ57Z+kFIDkpIKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724360194; c=relaxed/simple;
	bh=8CopyTKSL1XJRyLPsu28ciQkolQndACBLxFByVay1/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGxrrbzhumF5zPkAjv/3bE3qzvu8E5X2bmSin/3xe5R/TzS85scQyfqdNzqWvMT30peKPpIMnI/y7nqt7bYKzBGqUVeZDsmXTS2mMu/J9ngeMMRRZRBaA+L8WPBYw3Zr0waG05HVK6kUxHpSYLQCa/vYzW19cTafpyCAuYTenTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uRV4PDY9; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uRV4PDY9"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5bebb241fddso1708a12.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 13:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724360191; x=1724964991; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=td79jgMjWx4Orz9AL6SJH05EMU9DfYAEJ300uGx7uoE=;
        b=uRV4PDY9yhzuyL1WGuTbOes+Rs7zdpEPQMtTIf6NkGZS8/WgHjP2HdBY/vOpcbjKSq
         uScoivah+tDxsOA2nDHtPgORoVcZD9SAhEXLlEl9Wz7cBCwjVfRBIheyrwFS4r75/mI3
         Jm5v4y0LmdlrTlamt7MOg3HKj3J8LD2UYoKYu0H7cXp85jOIj2NrvC3LE2YR95ltsSFp
         6Wzmpn7KW37Eawukqlff2bqTraVetMSBBLLlenhJDJm3lBe+LwyShwjUQpBLGq3iUFth
         pbicbiBnaBRVTSTAaE7Vbgn7DJhXIrPPvpMz6xwvoW9rdV1MvCcJ/IUCTZdLhZ0by210
         vpxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724360191; x=1724964991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=td79jgMjWx4Orz9AL6SJH05EMU9DfYAEJ300uGx7uoE=;
        b=DmLSDza8bzBM7X/EMym4dZFyiXtyoRQcq222VCQjXh3+A3Rq4bhAIov0DQFY6mlg2t
         x4nucl6/S/LqAJlsiGeyCOp7vgEcMXtDQXkoh57upkbyD9NfNQw+2ojj7UJ3F9VMoI5+
         cyCP2yQbOz/OaWAXS9xG2U4GidZ7Uiz810BHpQ/tFsx1GcgA2lDSR4VGbevyIsN7XI3r
         d4WMRNedKGLwnL5bDXsSgWM7Zk8zoehqqFpuVlgS4kqU4dl+uTFbas4YUdtHkEnKojTF
         a6YjChO3jrVm3SClGgS/djeLCM7YxFzKISemgIBkn3rtLHbYe3jmQDHTMUJrRLdYxBqv
         /wFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWI1ZwgOQ8icmCC2zYopGxoqX2Bxuzk0VGxQ/Yfu5Scs5lLJgf8vxfU3arRpTFUWC7RFmXV1/0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDcRmijtKlYJWwrAyWUS4amx5/AL6kHWj7WLnAw0j0KtNO4VBl
	pGps/nq4JWK7ZTVT1c1y7QSuiqjl9zE6ednLxmjdw9Yh4tqwFkTXhQ4aTzLaodVTL/n2PhLKiEZ
	NMZEDjOkTryHfa0YaCmKroeJQ3MlnpKawOf0o
X-Google-Smtp-Source: AGHT+IHo5tJteyr4d1a/DUKU7A9PBB0j6bhzWnkCmBM6x6M3MSRCZRGoEClRJv71KXRc/RKfYDKJvWl16Yr4u3Ha/UI=
X-Received: by 2002:a05:6402:1e8f:b0:58b:93:b624 with SMTP id
 4fb4d7f45d1cf-5c088db5028mr5636a12.1.1724360190911; Thu, 22 Aug 2024 13:56:30
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240821223012.3757828-1-vipinsh@google.com>
In-Reply-To: <20240821223012.3757828-1-vipinsh@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Thu, 22 Aug 2024 13:55:54 -0700
Message-ID: <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] KVM selftests runner for running more than just default
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Anup Patel <anup@brainfault.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oops! Adding archs mailing list and maintainers which have arch folder
in tool/testing/selftests/kvm

On Wed, Aug 21, 2024 at 3:30=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> This series is introducing a KVM selftests runner to make it easier to
> run selftests with some interesting configurations and provide some
> enhancement over existing kselftests runner.
>
> I would like to get an early feedback from the community and see if this
> is something which can be useful for improving KVM selftests coverage
> and worthwhile investing time in it. Some specific questions:
>
> 1. Should this be done?
> 2. What features are must?
> 3. Any other way to write test configuration compared to what is done her=
e?
>
> Note, python code written for runner is not optimized but shows how this
> runner can be useful.
>
> What are the goals?
> - Run tests with more than just the default settings of KVM module
>   parameters and test itself.
> - Capture issues which only show when certain combination of module
>   parameter and tests options are used.
> - Provide minimum testing which can be standardised for KVM patches.
> - Run tests parallely.
> - Dump output in a hierarchical folder structure for easier tracking of
>   failures/success output
> - Feel free to add yours :)
>
> Why not use/extend kselftests?
> - Other submodules goal might not align and its gonna be difficult to
>   capture broader set of requirements.
> - Instead of test configuration we will need separate shell scripts
>   which will act as tests for each test arg and module parameter
>   combination. This will easily pollute the KVM selftests directory.
> - Easier to enhance features using Python packages than shell scripts.
>
> What this runner do?
> - Reads a test configuration file (tests.json in patch 1).
>   Configuration in json are written in hierarchy where multiple suites
>   exist and each suite contains multiple tests.
> - Provides a way to execute tests inside a suite parallelly.
> - Provides a way to dump output to a folder in a hierarchical manner.
> - Allows to run selected suites, or tests in a specific suite.
> - Allows to do some setup and teardown for test suites and tests.
> - Timeout can be provided to limit test execution duration.
> - Allows to run test suites or tests on specific architecture only.
>
> Runner is written in python and goal is to only use standard library
> constructs. This runner will work on Python 3.6 and up
>
> What does a test configuration file looks like?
> Test configuration are written in json as it is easier to read and has
> inbuilt package support in Python. Root level is a json array denoting
> suites and each suite can multiple tests in it using json array.
>
> [
>   {
>     "suite": "dirty_log_perf_tests",
>     "timeout_s": 300,
>     "arch": "x86_64",
>     "setup": "echo Setting up suite",
>     "teardown": "echo tearing down suite",
>     "tests": [
>       {
>         "name": "dirty_log_perf_test_max_vcpu_no_manual_protect",
>         "command": "./dirty_log_perf_test -v $(grep -c ^processor /proc/c=
puinfo) -g",
>         "arch": "x86_64",
>         "setup": "echo Setting up test",
>         "teardown": "echo tearing down test",
>         "timeout_s": 5
>       }
>     ]
>   }
> ]
>
> Usage:
> Runner "runner.py" and test configuration "tests.json" lives in
> tool/testing/selftests/kvm directory.
>
> To run serially:
> ./runner.py tests.json
>
> To run specific test suites:
> ./runner.py tests.json dirty_log_perf_tests x86_sanity_tests
>
> To run specific test in a suite:
> ./runner.py tests.json x86_sanity_tests/vmx_msrs_test
>
> To run everything parallely (runs tests inside a suite parallely):
> ./runner.py -j 10 tests.json
>
> To dump output to disk:
> ./runner.py -j 10 tests.json -o sample_run
>
> Sample output (after removing timestamp, process ID, and logging
> level columns):
>
>   ./runner.py tests.json  -j 10 -o sample_run
>   PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_no_manual_pro=
tect
>   PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_manual_protec=
t
>   PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_vcpu_manual_protec=
t_random_access
>   PASSED: dirty_log_perf_tests/dirty_log_perf_test_max_10_vcpu_hugetlb
>   PASSED: x86_sanity_tests/vmx_msrs_test
>   SKIPPED: x86_sanity_tests/private_mem_conversions_test
>   FAILED: x86_sanity_tests/apic_bus_clock_test
>   PASSED: x86_sanity_tests/dirty_log_page_splitting_test
>   -----------------------------------------------------------------------=
---
>   Test runner result:
>   1) dirty_log_perf_tests:
>      1) PASSED: dirty_log_perf_test_max_vcpu_no_manual_protect
>      2) PASSED: dirty_log_perf_test_max_vcpu_manual_protect
>      3) PASSED: dirty_log_perf_test_max_vcpu_manual_protect_random_access
>      4) PASSED: dirty_log_perf_test_max_10_vcpu_hugetlb
>   2) x86_sanity_tests:
>      1) PASSED: vmx_msrs_test
>      2) SKIPPED: private_mem_conversions_test
>      3) FAILED: apic_bus_clock_test
>      4) PASSED: dirty_log_page_splitting_test
>   -----------------------------------------------------------------------=
---
>
> Directory structure created:
>
> sample_run/
> |-- dirty_log_perf_tests
> |   |-- dirty_log_perf_test_max_10_vcpu_hugetlb
> |   |   |-- command.stderr
> |   |   |-- command.stdout
> |   |   |-- setup.stderr
> |   |   |-- setup.stdout
> |   |   |-- teardown.stderr
> |   |   `-- teardown.stdout
> |   |-- dirty_log_perf_test_max_vcpu_manual_protect
> |   |   |-- command.stderr
> |   |   `-- command.stdout
> |   |-- dirty_log_perf_test_max_vcpu_manual_protect_random_access
> |   |   |-- command.stderr
> |   |   `-- command.stdout
> |   `-- dirty_log_perf_test_max_vcpu_no_manual_protect
> |       |-- command.stderr
> |       `-- command.stdout
> `-- x86_sanity_tests
>     |-- apic_bus_clock_test
>     |   |-- command.stderr
>     |   `-- command.stdout
>     |-- dirty_log_page_splitting_test
>     |   |-- command.stderr
>     |   |-- command.stdout
>     |   |-- setup.stderr
>     |   |-- setup.stdout
>     |   |-- teardown.stderr
>     |   `-- teardown.stdout
>     |-- private_mem_conversions_test
>     |   |-- command.stderr
>     |   `-- command.stdout
>     `-- vmx_msrs_test
>         |-- command.stderr
>         `-- command.stdout
>
>
> Some other features for future:
> - Provide "precheck" command option in json, which can filter/skip tests =
if
>   certain conditions are not met.
> - Iteration option in the runner. This will allow the same test suites to
>   run again.
>
> Vipin Sharma (1):
>   KVM: selftestsi: Create KVM selftests runnner to run interesting tests
>
>  tools/testing/selftests/kvm/runner.py  | 282 +++++++++++++++++++++++++
>  tools/testing/selftests/kvm/tests.json |  60 ++++++
>  2 files changed, 342 insertions(+)
>  create mode 100755 tools/testing/selftests/kvm/runner.py
>  create mode 100644 tools/testing/selftests/kvm/tests.json
>
>
> base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
> --
> 2.46.0.184.g6999bdac58-goog
>
