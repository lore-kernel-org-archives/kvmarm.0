Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316A630BBBC
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720008; cv=none; b=aUCNQdCJiIZSsQjzrPrMwtCHyuAvl+iSs0BQ7Zm/caBc0cWpXIQHnYCTGCZZzp5jRlZpdeQYPoUIN5AcKjRH0v5ZsXFMycE3dbyF6F0646gzXcFxVE7WQYa3sgH95sx5OOVvU654ssDKu0qAkaUPN1IjlcYBgt/tpF7xvmG7iW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720008; c=relaxed/simple;
	bh=nAKcJriN+/HfEDFMoxxw4dc8lfzgKVKDz0An8f6yvmI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NiYhC7TEGaj5N2kvV5hTSI4txN8yuD3tn6ILSx5hQNhGL9xkXKHJUuIyuWD6zvuYpuJQZ+h7n1qyfFnrAnrNj5yFA1/Lg4Ml73F1mqET1ZK+mrLszJaSgUy/5Xqavfhic6WMsVWMg07SBQofEW/BMz3ll7Y7jg5t2cwo0bfrLEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jh6BP7VY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jh6BP7VY"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b242062308so63286845ad.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720006; x=1777324806; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ay36onivd4dX+Z1a2tz7QaER4k6wTnDl5SDdSR+0YAI=;
        b=jh6BP7VYrE4awpAnMLZkYWZW4gdAUeSTK3HQ9Nv8h9JN/0rdZzcbqmvM5+GIJlbTWE
         MNX+Bvmk6KSJ0VQT6sAexr4OmmEI1hejTyWcx3hKd03TwA3s3hn/tZWmW2EXNYjVri+T
         uCfj2BlVE0czrj62uYIsAw4Hh5p2gKjHIYygGXx+JVltUUroOJ9k9ys9C31WfI/lv1mA
         +2fSJA3Hst6giKykXF1EvK7G2EstaF4ateSByiYVvVN1XOE1viSDZ4nhsWlwIfeQwZsC
         LJlJfTkTBrmwl01KZNR5VZpmZlctpFNGC8eG3Dm3Q2pAhZ053KSQqRplrZ30zr3bfVkc
         Mr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720006; x=1777324806;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ay36onivd4dX+Z1a2tz7QaER4k6wTnDl5SDdSR+0YAI=;
        b=e4Pbyhjf31rT0MOw1vUXgGa6JUSiu4HFiIhQJ+cnvNsYBB623iOju5KzVcUaL05x8I
         a3ns++w5PVdERLj14CFdUDLVtULAhbVUwZhLSc9cPyWcH64gXoWdFVp/MVJw8CL7oPVk
         ui/duVeb3UjCcHnjauoegBIxy1tQEmKLAw8iFCrBwSvd1NURvb4PCt2xDpsW9dhU7h4m
         SAkZnyeHMjdfsQSRmHp8ZgJNtUFlpyyvneRUZAr8OQllfg5ltczYRdGWIc8NQ5ez8dHE
         d9czjur4lkGtMWWJgc31wvU15LALLwCo1Tn3bG9yVqTa5S/iazkBFtsYpgEUY1YrYHRw
         S6hg==
X-Forwarded-Encrypted: i=1; AFNElJ9Ctyh/UUhORnKkGUCKdlMbyoRIQN0eK82bdKd3AWKNgP/aB/GKfcCywlqTeUvrVT82H58KcKg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxf1me84mhqAhiN0Nj/MHr5a+PZD0a+xuYWLfynlt4XuJKDMHGR
	OmED8/yqgEYLbBre4cIqXNB9xsLvoILU2Cgf15Ic55Fd6nK522cSzlppYw7DdgxcTPpXVJSEXck
	c0MyahQ==
X-Received: from pgam23.prod.google.com ([2002:a05:6a02:2b57:b0:c76:a4b1:60cf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3947:b0:3a2:e26b:2940
 with SMTP id adf61e73a8af0-3a2e26c9037mr1652980637.0.1776720006241; Mon, 20
 Apr 2026 14:20:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:19:45 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-1-seanjc@google.com>
Subject: [PATCH v3 00/19] KVM: selftests: Use kernel-style integer and
 g[vp]a_t types
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

David's series to renames types across all KVM selftests.  I'm going to apply
this ~now in order to get it into -next ASAP.  Unless someone screams in the
next few days, I'm going to send a pull request on Thursday, with the goal of
getting this into -rc1 so that all architectures (and developers) can use the
new types straightaway.

Fully tested on x86, and I verified a handful of tests generate identical
code.  I tried to do the same for other architectures, but gcc at least doesn't
seem to provide reproducible builds for other architectures.  E.g. on arm64 and
LoongArch, a completely benign vaddr_t => gva_t rename would sometimes result
in different offsets in the generated code.  But based on manual diffs from
objdump, I'm fairly confident in the result.

The primary goal is to more closely align KVM selftests with the types used in
the kernel proper (selftests are mostly developed by kernel developers):

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

As a bonus, the new type names are shorter and thus make the KVM selftests code
more concise.

v3:
 - Use vm_alloc() instead of gva_alloc(), and put the API renames in a separate
   patch.
 - Rename vaddr => gva and paddr => gpa throughout KVM selftests.
 - Convert a pile of "u64" variables to gva_t or gpa_t as appropriate.
 - Clarify ambiguous variables and function names in arm64's inject_uer()
   and translate_to_host_paddr().
 - Rename pread_uint64() => pread_u64().

v2: https://lore.kernel.org/all/20260220004223.4168331-1-dmatlack@google.com

v1: https://lore.kernel.org/kvm/20250501183304.2433192-1-dmatlack@google.com

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

Sean Christopherson (9):
  KVM: selftests: Drop "vaddr_" from APIs that allocate memory for a
    given VM
  KVM: selftests: Rename vm_vaddr_unused_gap() => vm_unused_gva_gap()
  KVM: selftests: Rename vm_vaddr_populate_bitmap() =>
    vm_populate_gva_bitmap()
  KVM: selftests: Rename translate_to_host_paddr() =>
    translate_hva_to_hpa()
  KVM: selftests: Clarify that arm64's inject_uer() takes a host PA, not
    a guest PA
  KVM: selftests: Replace "vaddr" with "gva" throughout
  KVM: selftests: Replace "u64 gpa" with "gpa_t" throughout
  KVM: selftests: Replace "u64 nested_paddr" with "gpa_t l2_gpa"
  KVM: selftests: Replace "paddr" with "gpa" throughout

 .../selftests/kvm/access_tracking_perf_test.c |  44 +--
 tools/testing/selftests/kvm/arch_timer.c      |   6 +-
 .../selftests/kvm/arm64/aarch32_id_regs.c     |  14 +-
 .../testing/selftests/kvm/arm64/arch_timer.c  |   8 +-
 .../kvm/arm64/arch_timer_edge_cases.c         | 161 ++++----
 .../selftests/kvm/arm64/debug-exceptions.c    |  72 ++--
 .../testing/selftests/kvm/arm64/hypercalls.c  |  24 +-
 .../testing/selftests/kvm/arm64/idreg-idst.c  |   4 +-
 tools/testing/selftests/kvm/arm64/no-vgic.c   |   8 +-
 .../selftests/kvm/arm64/page_fault_test.c     |  82 ++--
 tools/testing/selftests/kvm/arm64/psci_test.c |  26 +-
 .../testing/selftests/kvm/arm64/sea_to_user.c |  41 +-
 .../testing/selftests/kvm/arm64/set_id_regs.c |  70 ++--
 .../selftests/kvm/arm64/smccc_filter.c        |  10 +-
 tools/testing/selftests/kvm/arm64/vgic_init.c |  56 +--
 tools/testing/selftests/kvm/arm64/vgic_irq.c  | 137 +++----
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |  20 +-
 tools/testing/selftests/kvm/arm64/vgic_v5.c   |  10 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c |  56 +--
 .../testing/selftests/kvm/coalesced_io_test.c |  38 +-
 .../selftests/kvm/demand_paging_test.c        |  10 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  14 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  82 ++--
 tools/testing/selftests/kvm/get-reg-list.c    |   2 +-
 .../testing/selftests/kvm/guest_memfd_test.c  |  18 +-
 .../testing/selftests/kvm/guest_print_test.c  |  22 +-
 .../selftests/kvm/hardware_disable_test.c     |   6 +-
 .../selftests/kvm/include/arm64/arch_timer.h  |  30 +-
 .../selftests/kvm/include/arm64/delay.h       |   4 +-
 .../testing/selftests/kvm/include/arm64/gic.h |   8 +-
 .../selftests/kvm/include/arm64/gic_v3_its.h  |   7 +-
 .../selftests/kvm/include/arm64/processor.h   |  22 +-
 .../selftests/kvm/include/arm64/ucall.h       |   4 +-
 .../selftests/kvm/include/arm64/vgic.h        |  22 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 344 ++++++++---------
 .../selftests/kvm/include/kvm_util_types.h    |   8 +-
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
 .../testing/selftests/kvm/include/test_util.h |  40 +-
 .../selftests/kvm/include/timer_test.h        |  18 +-
 .../selftests/kvm/include/ucall_common.h      |  22 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   6 +-
 .../testing/selftests/kvm/include/x86/apic.h  |  22 +-
 .../testing/selftests/kvm/include/x86/evmcs.h |  22 +-
 .../selftests/kvm/include/x86/hyperv.h        |  28 +-
 .../selftests/kvm/include/x86/kvm_util_arch.h |  36 +-
 tools/testing/selftests/kvm/include/x86/pmu.h |   9 +-
 .../selftests/kvm/include/x86/processor.h     | 292 +++++++-------
 tools/testing/selftests/kvm/include/x86/sev.h |  20 +-
 tools/testing/selftests/kvm/include/x86/smm.h |   3 +-
 .../selftests/kvm/include/x86/svm_util.h      |  12 +-
 .../testing/selftests/kvm/include/x86/ucall.h |   2 +-
 tools/testing/selftests/kvm/include/x86/vmx.h |  70 ++--
 .../selftests/kvm/kvm_page_table_test.c       |  54 +--
 tools/testing/selftests/kvm/lib/arm64/gic.c   |   6 +-
 .../selftests/kvm/lib/arm64/gic_private.h     |  26 +-
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  90 ++---
 .../selftests/kvm/lib/arm64/gic_v3_its.c      |  11 +-
 .../selftests/kvm/lib/arm64/processor.c       | 163 ++++----
 tools/testing/selftests/kvm/lib/arm64/ucall.c |  12 +-
 tools/testing/selftests/kvm/lib/arm64/vgic.c  |  40 +-
 tools/testing/selftests/kvm/lib/elf.c         |  17 +-
 tools/testing/selftests/kvm/lib/guest_modes.c |   2 +-
 .../testing/selftests/kvm/lib/guest_sprintf.c |  18 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 359 +++++++-----------
 .../selftests/kvm/lib/loongarch/processor.c   | 110 +++---
 .../selftests/kvm/lib/loongarch/ucall.c       |  12 +-
 tools/testing/selftests/kvm/lib/memstress.c   |  38 +-
 .../selftests/kvm/lib/riscv/processor.c       |  91 +++--
 .../kvm/lib/s390/diag318_test_handler.c       |  12 +-
 .../testing/selftests/kvm/lib/s390/facility.c |   2 +-
 .../selftests/kvm/lib/s390/processor.c        |  65 ++--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  18 +-
 tools/testing/selftests/kvm/lib/test_util.c   |  30 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |  34 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  14 +-
 tools/testing/selftests/kvm/lib/x86/apic.c    |   2 +-
 tools/testing/selftests/kvm/lib/x86/hyperv.c  |  14 +-
 .../testing/selftests/kvm/lib/x86/memstress.c |  14 +-
 tools/testing/selftests/kvm/lib/x86/pmu.c     |   8 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 292 +++++++-------
 tools/testing/selftests/kvm/lib/x86/sev.c     |  20 +-
 tools/testing/selftests/kvm/lib/x86/svm.c     |  16 +-
 tools/testing/selftests/kvm/lib/x86/ucall.c   |   4 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     |  44 +--
 .../selftests/kvm/loongarch/arch_timer.c      |  28 +-
 .../selftests/kvm/loongarch/pmu_test.c        |  10 +-
 .../kvm/memslot_modification_stress_test.c    |  10 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 164 ++++----
 tools/testing/selftests/kvm/mmu_stress_test.c |  28 +-
 .../selftests/kvm/pre_fault_memory_test.c     |  12 +-
 .../testing/selftests/kvm/riscv/arch_timer.c  |   8 +-
 .../testing/selftests/kvm/riscv/ebreak_test.c |   6 +-
 .../selftests/kvm/riscv/get-reg-list.c        |   4 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |   8 +-
 tools/testing/selftests/kvm/s390/debug_test.c |   8 +-
 .../testing/selftests/kvm/s390/irq_routing.c  |   2 +-
 tools/testing/selftests/kvm/s390/memop.c      |  94 ++---
 tools/testing/selftests/kvm/s390/resets.c     |   6 +-
 .../selftests/kvm/s390/shared_zeropage_test.c |   2 +-
 tools/testing/selftests/kvm/s390/tprot.c      |  24 +-
 .../selftests/kvm/s390/ucontrol_test.c        |   8 +-
 .../selftests/kvm/set_memory_region_test.c    |  40 +-
 tools/testing/selftests/kvm/steal_time.c      |  74 ++--
 .../kvm/system_counter_offset_test.c          |  12 +-
 tools/testing/selftests/kvm/x86/amx_test.c    |  14 +-
 .../selftests/kvm/x86/aperfmperf_test.c       |  16 +-
 .../selftests/kvm/x86/apic_bus_clock_test.c   |  24 +-
 tools/testing/selftests/kvm/x86/cpuid_test.c  |   6 +-
 tools/testing/selftests/kvm/x86/debug_regs.c  |   4 +-
 .../kvm/x86/dirty_log_page_splitting_test.c   |  16 +-
 .../kvm/x86/evmcs_smm_controls_test.c         |   6 +-
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
 .../kvm/x86/nested_tsc_scaling_test.c         |  24 +-
 .../kvm/x86/nested_vmsave_vmload_test.c       |   2 +-
 .../selftests/kvm/x86/nx_huge_pages_test.c    |  18 +-
 .../selftests/kvm/x86/platform_info_test.c    |   6 +-
 .../selftests/kvm/x86/pmu_counters_test.c     | 109 +++---
 .../selftests/kvm/x86/pmu_event_filter_test.c | 102 ++---
 .../kvm/x86/private_mem_conversions_test.c    |  78 ++--
 .../kvm/x86/private_mem_kvm_exits_test.c      |  14 +-
 .../selftests/kvm/x86/set_boot_cpu_id.c       |   6 +-
 .../selftests/kvm/x86/set_sregs_test.c        |   6 +-
 .../selftests/kvm/x86/sev_init2_tests.c       |   6 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |  22 +-
 .../x86/smaller_maxphyaddr_emulation_test.c   |   8 +-
 tools/testing/selftests/kvm/x86/smm_test.c    |   8 +-
 tools/testing/selftests/kvm/x86/state_test.c  |  14 +-
 .../selftests/kvm/x86/svm_int_ctl_test.c      |   2 +-
 .../selftests/kvm/x86/svm_lbr_nested_state.c  |   2 +-
 .../kvm/x86/svm_nested_clear_efer_svme.c      |   2 +-
 .../kvm/x86/svm_nested_shutdown_test.c        |   2 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     |  10 +-
 .../selftests/kvm/x86/svm_nested_vmcb12_gpa.c |  14 +-
 .../selftests/kvm/x86/svm_vmcall_test.c       |   2 +-
 .../selftests/kvm/x86/sync_regs_test.c        |   2 +-
 .../kvm/x86/triple_fault_event_test.c         |   4 +-
 .../testing/selftests/kvm/x86/tsc_msrs_test.c |   2 +-
 .../selftests/kvm/x86/tsc_scaling_sync.c      |   4 +-
 .../selftests/kvm/x86/ucna_injection_test.c   |  45 +--
 .../selftests/kvm/x86/userspace_io_test.c     |   4 +-
 .../kvm/x86/userspace_msr_exit_test.c         |  58 +--
 .../selftests/kvm/x86/vmx_apic_access_test.c  |   4 +-
 .../kvm/x86/vmx_apicv_updates_test.c          |   4 +-
 .../kvm/x86/vmx_invalid_nested_guest_state.c  |   2 +-
 .../testing/selftests/kvm/x86/vmx_msrs_test.c |  22 +-
 .../kvm/x86/vmx_nested_la57_state_test.c      |   4 +-
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  12 +-
 .../kvm/x86/vmx_preemption_timer_test.c       |   2 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  64 ++--
 .../selftests/kvm/x86/xapic_state_test.c      |  20 +-
 .../selftests/kvm/x86/xapic_tpr_test.c        |  24 +-
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |   8 +-
 .../selftests/kvm/x86/xen_shinfo_test.c       |  22 +-
 .../testing/selftests/kvm/x86/xss_msr_test.c  |   2 +-
 185 files changed, 2706 insertions(+), 2817 deletions(-)


base-commit: 6b802031877a995456c528095c41d1948546bf45
-- 
2.54.0.rc1.555.g9c883467ad-goog

