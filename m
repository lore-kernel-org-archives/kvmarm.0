Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B421EA7F4
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 00:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548156; cv=none; b=mYOPqSN8Zr4/Im86R8FCphXavOFptwCKvsx6I91k9oDg6/F0cQvkcAuA/UoV3xcsGl/KQsGP74wlXdOqV9AwHERGN2Jh7r4rj3qzhkSvsMmtBsagZh3Je0/Xa7U5wiM8PYgmI3X5zSf2lFBeK5utTpT8CdDhizh+GbIvBi4XQkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548156; c=relaxed/simple;
	bh=Ud4lqyOYJxLqwMF4L6RwgtA92lV9p1IYKw7lMroz3mw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rmpSsdMx8XFTLwoRxLYAACvarHXd7PwlIhwARf8hui7J5hOvemR3G+fvm2g5DoBVqLa054rzednFH7gLLP3vNV1KcuBLT7NNSybILYBSzioCNLrCZwjBK2RkW2AmieZLU04Sja92O8KzVJkYGRy4Tl+zztG28Bt3zr7k/XCXq8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1TollKMP; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1TollKMP"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ab0b2e804cso17962775ad.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 16:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548154; x=1772152954; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dg8JwpDSolSLBMhrmXm5uOOceqMFfere5VVKNjBSeNo=;
        b=1TollKMPuOwCnJYFbQoxLjsJWx8tcVKJjDJqrvi+ihj0eGAVggxwIw6HUR9KONJ04Y
         K3pE5ofyhfcNSeqohiH1rRGipwJ/F9CtHtV02xNcIktl58zXnY6jma6ekgNCA3K3K2Dc
         i0vkJw2LyfP6G6sGWZrwBkLHReU47XgWh9gomG2B1ixLkXXecz5gC85EZIGTakwpbvli
         /N/kh7y2e5OocDA3TV6gGUyEIir6rvTCHv4jZgQH0ikZLoIKj1nVJbbp4E4L89jBpM5X
         dwZJiBBO3HCsBgzgfFaccRgBIeiVOpt/gx8yjteRCr0gc4O3SYLokyY+mmaGBrWvkd3q
         YUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548154; x=1772152954;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dg8JwpDSolSLBMhrmXm5uOOceqMFfere5VVKNjBSeNo=;
        b=TmgLZNFKvNjpw8SZ6PBBJXADyvBQaU12vPPxbXsFnQ/f9d4/SiQU2VkZ7GWproKkHJ
         wx6P7wJlKzOSeg2nZxdkHcuxT/MlcWzMVg1TESVuwkYIwXVBH7RglA6bJiPoI2oNLElN
         JM+EV4Xh6l6aPJnMPM6joTrrF7+jGRb4vHFbxFhA+vdVWdHeONHCvlivORXTrovCJ8Vb
         8tr+NJHDaNaQ4ccOzBGTzwTIgxT5Ix59RNM8k1dzTQJ3iGYQIl+o9pEWS7CvjNb31EVn
         QJiYOhY6rQBuJNHFjnNzs6MfStuIsj4y7lC3xpB6vN4tq2LvAioc9EmNBuz5QbmTmitt
         qzHw==
X-Forwarded-Encrypted: i=1; AJvYcCVGrOdK25a0xVpGeW9YhS4ARZJLEdvpj41wY/3wBbg1dY7YAeVTeoqw7eMscmcGGxex9NzEJhc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd96zAfeJzgVi7dRP+vnXzIzOoE/kUbWR1orv/5owc3po1fLVy
	BDyZ93TJOh/X2Xe7ULwwQWcFPYSPOBlPCoCgAxDMjY6BhW6zzdyAvtZ+7sD0UpE4RrlS8dbKccb
	pvSX1bbVuOp7spg==
X-Received: from pjbsz4.prod.google.com ([2002:a17:90b:2d44:b0:354:aa76:8270])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:190d:b0:29e:c2de:4ad with SMTP id d9443c01a7336-2ad5b03d9eamr38042765ad.24.1771548154020;
 Thu, 19 Feb 2026 16:42:34 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-1-dmatlack@google.com>
Subject: [PATCH v2 00/10] KVM: selftests: Use kernel-style integer and
 g[vp]a_t types
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

This series renames types across all KVM selftests to more align with
types used in the kernel:

  vm_vaddr_t -> gva_t
  vm_paddr_t -> gpa_t

  uint64_t -> u64
  uint32_t -> u32
  uint16_t -> u16
  uint8_t  -> u8

  int64_t -> s64
  int32_t -> s32
  int16_t -> s16
  int8_t  -> s8

The goal of this series is to make the KVM selftests code more concise
(the new type names are shorter) and more similar to the kernel, since
selftests are developed by kernel developers.

v2:
 - Reapply the series on top of kvm/queue

v1: https://lore.kernel.org/kvm/20250501183304.2433192-1-dmatlack@google.com/

David Matlack (10):
  KVM: selftests: Use gva_t instead of vm_vaddr_t
  KVM: selftests: Use gpa_t instead of vm_paddr_t
  KVM: selftests: Use gpa_t for GPAs in Hyper-V selftests
  KVM: selftests: Use u64 instead of uint64_t
  KVM: selftests: Use s64 instead of int64_t
  KVM: selftests: Use u32 instead of uint32_t
  KVM: selftests: Use s32 instead of int32_t
  KVM: selftests: Use u16 instead of uint16_t
  KVM: selftests: Use s16 instead of int16_t
  KVM: selftests: Use u8 instead of uint8_t

 .../selftests/kvm/access_tracking_perf_test.c |  42 +--
 tools/testing/selftests/kvm/arch_timer.c      |   6 +-
 .../selftests/kvm/arm64/aarch32_id_regs.c     |  14 +-
 .../testing/selftests/kvm/arm64/arch_timer.c  |   8 +-
 .../kvm/arm64/arch_timer_edge_cases.c         | 161 +++++----
 .../selftests/kvm/arm64/debug-exceptions.c    |  72 ++--
 .../testing/selftests/kvm/arm64/hypercalls.c  |  24 +-
 .../testing/selftests/kvm/arm64/idreg-idst.c  |   4 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  |   6 +-
 .../selftests/kvm/arm64/page_fault_test.c     |  82 ++---
 tools/testing/selftests/kvm/arm64/psci_test.c |  26 +-
 .../testing/selftests/kvm/arm64/sea_to_user.c |  32 +-
 .../testing/selftests/kvm/arm64/set_id_regs.c |  66 ++--
 .../selftests/kvm/arm64/smccc_filter.c        |  10 +-
 tools/testing/selftests/kvm/arm64/vgic_init.c |  56 +--
 tools/testing/selftests/kvm/arm64/vgic_irq.c  | 137 ++++----
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |  20 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c |  56 +--
 .../testing/selftests/kvm/coalesced_io_test.c |  38 +-
 .../selftests/kvm/demand_paging_test.c        |  10 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  14 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  82 ++---
 tools/testing/selftests/kvm/get-reg-list.c    |   2 +-
 .../testing/selftests/kvm/guest_memfd_test.c  |  16 +-
 .../testing/selftests/kvm/guest_print_test.c  |  22 +-
 .../selftests/kvm/hardware_disable_test.c     |   6 +-
 .../selftests/kvm/include/arm64/arch_timer.h  |  30 +-
 .../selftests/kvm/include/arm64/delay.h       |   4 +-
 .../testing/selftests/kvm/include/arm64/gic.h |   8 +-
 .../selftests/kvm/include/arm64/gic_v3_its.h  |   8 +-
 .../selftests/kvm/include/arm64/processor.h   |  22 +-
 .../selftests/kvm/include/arm64/ucall.h       |   4 +-
 .../selftests/kvm/include/arm64/vgic.h        |  22 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 328 +++++++++---------
 .../selftests/kvm/include/kvm_util_types.h    |   4 +-
 .../kvm/include/loongarch/arch_timer.h        |   4 +-
 .../selftests/kvm/include/loongarch/ucall.h   |   4 +-
 .../testing/selftests/kvm/include/memstress.h |  30 +-
 .../selftests/kvm/include/riscv/arch_timer.h  |  22 +-
 .../selftests/kvm/include/riscv/processor.h   |   9 +-
 .../selftests/kvm/include/riscv/ucall.h       |   4 +-
 .../kvm/include/s390/diag318_test_handler.h   |   2 +-
 .../selftests/kvm/include/s390/facility.h     |   4 +-
 .../selftests/kvm/include/s390/ucall.h        |   4 +-
 .../testing/selftests/kvm/include/sparsebit.h |   6 +-
 .../testing/selftests/kvm/include/test_util.h |  40 ++-
 .../selftests/kvm/include/timer_test.h        |  18 +-
 .../selftests/kvm/include/ucall_common.h      |  22 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   6 +-
 .../testing/selftests/kvm/include/x86/apic.h  |  22 +-
 .../testing/selftests/kvm/include/x86/evmcs.h |  22 +-
 .../selftests/kvm/include/x86/hyperv.h        |  28 +-
 .../selftests/kvm/include/x86/kvm_util_arch.h |  36 +-
 tools/testing/selftests/kvm/include/x86/pmu.h |   9 +-
 .../selftests/kvm/include/x86/processor.h     | 282 ++++++++-------
 tools/testing/selftests/kvm/include/x86/sev.h |  20 +-
 .../selftests/kvm/include/x86/svm_util.h      |  12 +-
 .../testing/selftests/kvm/include/x86/ucall.h |   2 +-
 tools/testing/selftests/kvm/include/x86/vmx.h |  70 ++--
 .../selftests/kvm/kvm_page_table_test.c       |  54 +--
 tools/testing/selftests/kvm/lib/arm64/gic.c   |   6 +-
 .../selftests/kvm/lib/arm64/gic_private.h     |  26 +-
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  90 ++---
 .../selftests/kvm/lib/arm64/gic_v3_its.c      |  12 +-
 .../selftests/kvm/lib/arm64/processor.c       | 126 +++----
 tools/testing/selftests/kvm/lib/arm64/ucall.c |  12 +-
 tools/testing/selftests/kvm/lib/arm64/vgic.c  |  40 +--
 tools/testing/selftests/kvm/lib/elf.c         |   8 +-
 tools/testing/selftests/kvm/lib/guest_modes.c |   2 +-
 .../testing/selftests/kvm/lib/guest_sprintf.c |  18 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 220 ++++++------
 .../selftests/kvm/lib/loongarch/processor.c   |  79 +++--
 .../selftests/kvm/lib/loongarch/ucall.c       |  12 +-
 tools/testing/selftests/kvm/lib/memstress.c   |  38 +-
 .../selftests/kvm/lib/riscv/processor.c       |  58 ++--
 .../kvm/lib/s390/diag318_test_handler.c       |  12 +-
 .../testing/selftests/kvm/lib/s390/facility.c |   2 +-
 .../selftests/kvm/lib/s390/processor.c        |  42 +--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  18 +-
 tools/testing/selftests/kvm/lib/test_util.c   |  30 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |  30 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  14 +-
 tools/testing/selftests/kvm/lib/x86/apic.c    |   2 +-
 tools/testing/selftests/kvm/lib/x86/hyperv.c  |  14 +-
 .../testing/selftests/kvm/lib/x86/memstress.c |  14 +-
 tools/testing/selftests/kvm/lib/x86/pmu.c     |   8 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 199 ++++++-----
 tools/testing/selftests/kvm/lib/x86/sev.c     |  20 +-
 tools/testing/selftests/kvm/lib/x86/svm.c     |  16 +-
 tools/testing/selftests/kvm/lib/x86/ucall.c   |   4 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     |  44 +--
 .../selftests/kvm/loongarch/arch_timer.c      |  28 +-
 .../kvm/memslot_modification_stress_test.c    |  10 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 164 ++++-----
 tools/testing/selftests/kvm/mmu_stress_test.c |  28 +-
 .../selftests/kvm/pre_fault_memory_test.c     |  10 +-
 .../testing/selftests/kvm/riscv/arch_timer.c  |   8 +-
 .../testing/selftests/kvm/riscv/ebreak_test.c |   6 +-
 .../selftests/kvm/riscv/get-reg-list.c        |   4 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |   8 +-
 tools/testing/selftests/kvm/s390/debug_test.c |   8 +-
 tools/testing/selftests/kvm/s390/memop.c      |  94 ++---
 tools/testing/selftests/kvm/s390/resets.c     |   6 +-
 .../selftests/kvm/s390/shared_zeropage_test.c |   2 +-
 tools/testing/selftests/kvm/s390/tprot.c      |  24 +-
 .../selftests/kvm/s390/ucontrol_test.c        |   2 +-
 .../selftests/kvm/set_memory_region_test.c    |  40 +--
 tools/testing/selftests/kvm/steal_time.c      |  66 ++--
 .../kvm/system_counter_offset_test.c          |  12 +-
 tools/testing/selftests/kvm/x86/amx_test.c    |  14 +-
 .../selftests/kvm/x86/aperfmperf_test.c       |  16 +-
 .../selftests/kvm/x86/apic_bus_clock_test.c   |  24 +-
 tools/testing/selftests/kvm/x86/cpuid_test.c  |   6 +-
 tools/testing/selftests/kvm/x86/debug_regs.c  |   4 +-
 .../kvm/x86/dirty_log_page_splitting_test.c   |  16 +-
 .../testing/selftests/kvm/x86/fastops_test.c  |  52 +--
 .../selftests/kvm/x86/feature_msrs_test.c     |  12 +-
 .../selftests/kvm/x86/fix_hypercall_test.c    |  20 +-
 .../selftests/kvm/x86/flds_emulation.h        |   6 +-
 .../testing/selftests/kvm/x86/hwcr_msr_test.c |  10 +-
 .../testing/selftests/kvm/x86/hyperv_clock.c  |   6 +-
 .../testing/selftests/kvm/x86/hyperv_evmcs.c  |  10 +-
 .../kvm/x86/hyperv_extended_hypercalls.c      |  20 +-
 .../selftests/kvm/x86/hyperv_features.c       |  26 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  |  12 +-
 .../selftests/kvm/x86/hyperv_svm_test.c       |  10 +-
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |  36 +-
 .../selftests/kvm/x86/kvm_buslock_test.c      |   2 +-
 .../selftests/kvm/x86/kvm_clock_test.c        |  14 +-
 tools/testing/selftests/kvm/x86/kvm_pv_test.c |  10 +-
 .../selftests/kvm/x86/monitor_mwait_test.c    |   2 +-
 .../selftests/kvm/x86/nested_close_kvm_test.c |   2 +-
 .../selftests/kvm/x86/nested_dirty_log_test.c |  10 +-
 .../selftests/kvm/x86/nested_emulation_test.c |  20 +-
 .../kvm/x86/nested_exceptions_test.c          |   6 +-
 .../kvm/x86/nested_invalid_cr3_test.c         |   2 +-
 .../selftests/kvm/x86/nested_set_state_test.c |   4 +-
 .../kvm/x86/nested_tsc_adjust_test.c          |  12 +-
 .../kvm/x86/nested_tsc_scaling_test.c         |  26 +-
 .../kvm/x86/nested_vmsave_vmload_test.c       |   2 +-
 .../selftests/kvm/x86/nx_huge_pages_test.c    |  18 +-
 .../selftests/kvm/x86/platform_info_test.c    |   6 +-
 .../selftests/kvm/x86/pmu_counters_test.c     | 110 +++---
 .../selftests/kvm/x86/pmu_event_filter_test.c | 102 +++---
 .../kvm/x86/private_mem_conversions_test.c    |  78 ++---
 .../kvm/x86/private_mem_kvm_exits_test.c      |  14 +-
 .../selftests/kvm/x86/set_boot_cpu_id.c       |   6 +-
 .../selftests/kvm/x86/set_sregs_test.c        |   6 +-
 .../selftests/kvm/x86/sev_init2_tests.c       |   6 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |  16 +-
 .../x86/smaller_maxphyaddr_emulation_test.c   |   8 +-
 tools/testing/selftests/kvm/x86/smm_test.c    |   8 +-
 tools/testing/selftests/kvm/x86/state_test.c  |  14 +-
 .../selftests/kvm/x86/svm_int_ctl_test.c      |   2 +-
 .../kvm/x86/svm_nested_shutdown_test.c        |   2 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     |  10 +-
 .../selftests/kvm/x86/svm_vmcall_test.c       |   2 +-
 .../selftests/kvm/x86/sync_regs_test.c        |   2 +-
 .../kvm/x86/triple_fault_event_test.c         |   4 +-
 .../testing/selftests/kvm/x86/tsc_msrs_test.c |   2 +-
 .../selftests/kvm/x86/tsc_scaling_sync.c      |   4 +-
 .../selftests/kvm/x86/ucna_injection_test.c   |  45 +--
 .../selftests/kvm/x86/userspace_io_test.c     |   4 +-
 .../kvm/x86/userspace_msr_exit_test.c         |  58 ++--
 .../selftests/kvm/x86/vmx_apic_access_test.c  |   4 +-
 .../kvm/x86/vmx_apicv_updates_test.c          |   4 +-
 .../kvm/x86/vmx_invalid_nested_guest_state.c  |   2 +-
 .../testing/selftests/kvm/x86/vmx_msrs_test.c |  22 +-
 .../kvm/x86/vmx_nested_la57_state_test.c      |   4 +-
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  12 +-
 .../kvm/x86/vmx_preemption_timer_test.c       |   2 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  58 ++--
 .../selftests/kvm/x86/xapic_state_test.c      |  20 +-
 .../selftests/kvm/x86/xapic_tpr_test.c        |  24 +-
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |   8 +-
 .../selftests/kvm/x86/xen_shinfo_test.c       |  22 +-
 .../testing/selftests/kvm/x86/xss_msr_test.c  |   2 +-
 177 files changed, 2514 insertions(+), 2519 deletions(-)


base-commit: b1195183ed42f1522fae3fe44ebee3af437aa000
-- 
2.53.0.414.gf7e9f6c205-goog

