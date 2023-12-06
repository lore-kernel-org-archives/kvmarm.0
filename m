Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05644597B
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nYM7LMkh"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-50c0f6b1015so1949333e87.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 09:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882163; x=1702486963; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Me0qqRrskpa11GvKdt5GrXiD/qCgAfM3AQizYA0X8fg=;
        b=nYM7LMkhp5g9UoHltJHilpBg21YvvEgbBM80/2V1YwICDaI6bCSc9nbgJnA/f6J0cF
         GUxCLgdlgO5QgUQr2uZR7Kp5DOCty7KjYLzPrbgMDp09LMf0eOcFaQKqkF2ImzUvd0rU
         cznz7zVwHg5BcDjgM993iIjKZ9KdvRYpdHAqhh155bFkyMfarFdQOZ8xkCxg5aNkaJgt
         USwC06yTyPmyk3Lbrf/jxcGtaIPzO3Jm+ZAhWUx1NK7ap1eBtAUuTpFoqnG39vfuAdsN
         4xtecenODl0l3i2N8GRCyMaAD9HjHJkZ4t2PlMuu0xUfvsZ7p4AefUC8UKdh6iRD99oK
         MTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882163; x=1702486963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Me0qqRrskpa11GvKdt5GrXiD/qCgAfM3AQizYA0X8fg=;
        b=vbNGdrnP2ZKWz1gFp2novGnBQMccfvsSWCdPvJxNJ3SVSLn1beVJ5UlZPmWveG+95V
         n7mWxzpnG0OC63Km2RDxnpw+44jcdm3KeFzFDst/r25JvnS7VWnx78mdeBTfu0Ejc1k8
         WhvKSdJt4tcsNuGm2AsBwlrlIkmRPa3ChhZYpJXgT0jYC/6S4V1ccYAvPkdkLjljMEz8
         K0G9xuw4naj9NmOpJ9fgc38QPUQQWZai35WnCE79slxHKabg/yhXmMcpG5d5lh/Oh/Zu
         hf8lneVtkFvekwnZvxjBj7VQgiavk/Z9gIlHauRGY3bLKxchE665dWTyaM1zTDnlwyCu
         eF8A==
X-Gm-Message-State: AOJu0YySVO9L4PFLlTZB5wec/u6XGGiYTSUFoZf1OPCt/wDO53fVmTq6
	iUHSrumh72JIE1tkD5JW+lJiPw==
X-Google-Smtp-Source: AGHT+IECVyI5nSuArrzUeLvq2gF2I0dRUO6u4KVRrS6V9wDhUNsXaChckaX+LSPb1AXIsiukHIvlxQ==
X-Received: by 2002:a05:6512:549:b0:50b:d3cf:1e8c with SMTP id h9-20020a056512054900b0050bd3cf1e8cmr612707lfl.43.1701882162556;
        Wed, 06 Dec 2023 09:02:42 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id l4-20020a056402344400b0054cc474b25fsm189776edc.40.2023.12.06.09.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:42 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	anup@brainfault.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Subject: [PATCH 0/5] KVM: selftests: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:42 +0100
Message-ID: <20231206170241.82801-7-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

This series has a lot of churn for dubious value, but I'm posting it
anyway since I've already done the work. Each patch in the series is
simply removing trailing newlines from format strings in TEST_* function
callsites, since TEST_* functions append their own. The first patch
addresses common lib and test code, the rest of the changes are split
by arch in the remaining patches.

Figuring out which newlines to delete was done with a long, ugly
grep regular expression[*] and then highlighting '\n' in the output
and manually skimming to find, and then manually fix, each instance.
I'm sure there's some AI tool that would have done everything for me,
but this was my chance to prove I'm still as capable as AI (well,
unless I missed some...)

[*] grep -rn . tools/testing/selftests/kvm |
    grep -Pzo '(?s)\n[^\n]*TEST_(ASSERT|REQUIRE|FAIL)\(.*?\)\s*;' |
    tr '\0' '\n'


Andrew Jones (5):
  KVM: selftests: Remove redundant newlines
  KVM: selftests: aarch64: Remove redundant newlines
  KVM: selftests: riscv: Remove redundant newlines
  KVM: selftests: s390x: Remove redundant newlines
  KVM: selftests: x86_64: Remove redundant newlines

 .../selftests/kvm/aarch64/arch_timer.c        | 12 ++++----
 .../selftests/kvm/aarch64/hypercalls.c        | 16 +++++------
 .../selftests/kvm/aarch64/page_fault_test.c   |  6 ++--
 .../selftests/kvm/aarch64/smccc_filter.c      |  2 +-
 .../kvm/aarch64/vpmu_counter_access.c         | 12 ++++----
 .../selftests/kvm/demand_paging_test.c        |  4 +--
 .../selftests/kvm/dirty_log_perf_test.c       |  4 +--
 tools/testing/selftests/kvm/dirty_log_test.c  |  4 +--
 tools/testing/selftests/kvm/get-reg-list.c    |  2 +-
 .../testing/selftests/kvm/guest_print_test.c  |  8 +++---
 .../selftests/kvm/hardware_disable_test.c     |  6 ++--
 .../selftests/kvm/kvm_create_max_vcpus.c      |  2 +-
 .../selftests/kvm/kvm_page_table_test.c       |  4 +--
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  4 +--
 tools/testing/selftests/kvm/lib/elf.c         |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 16 +++++------
 tools/testing/selftests/kvm/lib/memstress.c   |  2 +-
 .../selftests/kvm/lib/riscv/processor.c       |  2 +-
 .../selftests/kvm/lib/s390x/processor.c       |  2 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  2 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 10 +++----
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  6 ++--
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 .../testing/selftests/kvm/memslot_perf_test.c |  6 ++--
 .../selftests/kvm/riscv/get-reg-list.c        |  2 +-
 tools/testing/selftests/kvm/rseq_test.c       |  4 +--
 tools/testing/selftests/kvm/s390x/resets.c    |  4 +--
 .../selftests/kvm/s390x/sync_regs_test.c      | 20 ++++++-------
 .../selftests/kvm/set_memory_region_test.c    |  6 ++--
 .../kvm/system_counter_offset_test.c          |  2 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  4 +--
 .../selftests/kvm/x86_64/flds_emulation.h     |  2 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |  4 +--
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c |  2 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   |  2 +-
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  8 +++---
 .../selftests/kvm/x86_64/platform_info_test.c |  2 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 28 +++++++++----------
 .../smaller_maxphyaddr_emulation_test.c       |  4 +--
 .../selftests/kvm/x86_64/sync_regs_test.c     | 10 +++----
 .../kvm/x86_64/ucna_injection_test.c          |  8 +++---
 .../selftests/kvm/x86_64/userspace_io_test.c  |  2 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c | 16 +++++------
 .../vmx_exception_with_invalid_guest_state.c  |  2 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |  8 +++---
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |  2 +-
 .../selftests/kvm/x86_64/xss_msr_test.c       |  2 +-
 51 files changed, 144 insertions(+), 144 deletions(-)

-- 
2.43.0

