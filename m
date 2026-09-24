Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644E241D23D
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270973; cv=none; b=NiiAet9rk8awe+byeCoq/jLP3D0+Fp0EH+gJbSz0mKs/T9JRnbS6xXWfpEMoDz+dPb+RBmQ1p4Ny49x97s19l/3rrwXM79BWLYZA9CYKYcRWnxGB7yGlNvd2MnwtZxBLsaTCtfbDjNn1QK0sdgyusKZcX5P5gHWz166yd9E8JoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270973; c=relaxed/simple;
	bh=Th/gdb82q0l15jjXh7OyXa5eh1Parw2GpJ00iFt/BI8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GreY/jOxk/d5oCD1Knbg/+Np8/jQuFzVL8JuLkZe2NmBKlKiOls42lfkyM24Ct2uTzFoUAfXO/8vYviloTLbQWCvpla2GrHpT1j28RrLye9NYdGbTZaReAEwfQj61vkTcOx+ZL1DjEkDvgeJxRNgmvxKh19Kr9xtJ90FcLnnUXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kDnHkBbM; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kDnHkBbM"
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4c55ba309c2so191233b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790270970; x=1790875770; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5+HVoWUpl0qaj6LVCbO//92JCksvBDFuswRRe0vTxAA=;
        b=kDnHkBbMW4Ad36O1OV/htTcaxZNJlXL2BX2zwOVZZstMjSuI3+52D01OWjyuvAwXL4
         GNSLU7VBuOX0C/U0GuN1SZSJEICghagd28eqSD8mPA5Pl/ocV8LcPawl/9K93O9cpcHo
         9JKYvEGnlH7fJEdpH7kouDiVrrWQDcB5XqZNEy1u0bFFoKsYwLfIlQLQp2Nshy7bfyAL
         mF4KVfYR+ZDsBOj8x09k+BUobRp7sRXQZ8h36Kxb/67Jdv7BvzrELVIkRA8AFhaRLWCe
         xDmiBKK663aFIDN6SQaivpWGigmE9+kSX9QXaVpBdGSPpAejqqvrIvW5oSgGQuDd6Zvg
         EfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270970; x=1790875770;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5+HVoWUpl0qaj6LVCbO//92JCksvBDFuswRRe0vTxAA=;
        b=18Mc4xQUVMaonK2ADoLbz623aGB5Ny5FJTXzUovu7MQAU7OxKk2XYBwz+MbStVDBeV
         uuhE8/qPTThLuDXWaQyyPR0ueiwuDtW2HO2iRmw9F15VUxISNTWMsvNAAtsNMjzc3vkz
         1Qq3WNE7KFgB8JYaL2VkoZN1ld2PsftXz6Iqb43RzDrJsmhrhoQoYO+KMlYLGrmEnsCC
         7UKncIIpnrOI0GQDwp3Vg9IKx9uiSi2rwsc8s4N8vxes476M9S+FgkyaL8CMPn/CCh1N
         pMc+ihO8LzhCJgUyY+nnxnOznAKPpUapTfCxsyzD4M443Qmgjl3M8y4ilCZ/dRik84CO
         Qfdw==
X-Forwarded-Encrypted: i=1; AKwUvBxEDE0j4RcElEPcOntfoQQesLU1M4Sw62uWlDHe3o0Y7BkRAN6H+hmqOlMr7Q1fySMaBM0mSoo=@lists.linux.dev
X-Gm-Message-State: AFuF++kXwyKAJ/ZW1QXb2aqE9rX8TVbWkFlQs1w6z4zPkMeUci1d9Fdr
	pMRGgT1EPYtGRYAgKVq3iUuIqrcD1EXAaRuYFsIKX5v9UgJzo6bu6bm+hqDPyykxhUWe0Nm20mC
	/8HLiMh5rIQ+L6A6ZDjRmyJXnyg==
X-Received: from ilbdr2.prod.google.com ([2002:a05:6e02:3f02:b0:509:22e1:470c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:17aa:b0:4bc:2295:1687 with SMTP id 5614622812f47-4d72df6ccaamr3402135b6e.40.1790270969819;
 Thu, 24 Sep 2026 10:29:29 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-1-coltonlewis@google.com>
Subject: [PATCH v9 00/22] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series creates a new PMU scheme on ARM, a partitioned PMU that
allows reserving a subset of counters for more direct guest access,
significantly reducing overhead. More details, including performance
benchmarks, can be read in the v1 cover letter linked below.

There is no longer a kernel command line parameter
(`arm_pmuv3.reserved_host_counters`); PMU partitioning is now completely
controlled via the KVM API using `KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION`
and `KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS` vCPU device attributes. When
partitioning is enabled for a VM, userspace must explicitly configure a
guest event counter count strictly less than the maximum general-purpose
counters implemented by the PMU (leaving at least one general-purpose
counter for the host) prior to calling `KVM_ARM_VCPU_PMU_V3_INIT`. A QEMU
patch demonstrating how to use the uAPI is sent separately.

An overview of what this series accomplishes was presented at KVM
Forum 2025. Slides [1] and video [2] are linked below.

v9:

* Rebase on top of v7.3-rc4.

* Drop the `arm_pmuv3.reserved_host_counters` module parameter so
  partitioning is completely controlled via the KVM vCPU device
  attribute uAPI (`KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION` and
  `KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS`), and document the new
  attribute and counter allocation rules in
  `Documentation/virt/kvm/devices/vcpu.rst` (James Clark).

* Move the dynamic counter allocation mask (`cntr_mask`) from global
  `struct arm_pmu` to per-CPU `struct pmu_hw_events` (`cpuc->cntr_mask`)
  in a dedicated `drivers/perf` patch, fixing multi-pCPU counter
  reservation clobbering on vCPU migration and eliminating the
  `cpu_pm_pmu_setup()` cpuidle `WARN_ON_ONCE` (Zide Chen, James Clark).

* Synchronously propagate trapped guest writes to `PMEVTYPER<n>_EL0`
  and `PMCCFILTR_EL0` to hardware via `kvm_pmu_apply_single_event_filter()`
  when guest-owned, fixing in-guest `perf stat` event count skew across
  runs (James Clark, Sashiko AI Review).

* Refactor `armv8pmu_can_use_pmccntr()` and `armv8pmu_get_event_idx()`
  to check `cntr_mask` inside `armv8pmu_can_use_pmccntr()` and un-nest
  the 64-bit user-access check so cycle events fall back cleanly to
  general-purpose counters when `PMCCNTR_EL0` is reserved by a guest
  (Robin Murphy).

* Restrict the lazy transition to `VCPU_PMU_ACCESS_GUEST_OWNED` to when
  the guest actively enables counting (`PMCR_EL0.E = 1` or setting guest
  counter bits in `PMCNTENSET_EL0` / `PMINTENSET_EL1`), preventing guest
  boot-time PMU probing from prematurely claiming hardware counters and
  triggering spurious host counter preemption warnings (James Clark).

* Fix patch dependency ordering and series bisectability across all
  commits, removing intermediate `max_guest_counters` / `hw_cntr_impl`
  churn and squashing the selftest exception relaxation into the
  Partitioned PMU selftest patch (James Clark).

* Fix compiler warning for `struct arm_pmu` declaration in
  `include/kvm/arm_pmu.h` (kernel test robot) and guard
  `kvm_pmu_host_counter_mask()` when KVM is compiled in but not active
  (wuyifan).

* Track physical CPU PMU residency in `vcpu->arch.pmu.loaded_on_cpu`
  separately from `VCPU_PMU_ACCESS_GUEST_OWNED`, and toggle
  `MDCR_EL2.HPME` via `kvm_pmu_host_start()` / `kvm_pmu_host_stop()`
  instead of `PMCR_EL0.E` when starting/stopping host perf events while
  a partitioned guest is loaded.

* Allow `kvm_vcpu_pmu_resync_el0()` to resynchronize VHE EL0 event
  filters (`PMEVTYPER<n>_EL0.U`) in process context and order
  `kvm_pmu_put()` before `kvm_vcpu_pmu_restore_host()` in
  `kvm_arch_vcpu_put()`.

* Address additional Sashiko AI Review findings:
  - Check `idx - 1` against `cpuc->cntr_mask` in `armv8pmu_get_chain_idx()`
    to prevent 64-bit chained host events from crossing an odd `HPMN`
    partition boundary, and use `cpuc->cntr_mask` in
    `armv8pmu_enable_user_access()`.
  - Latch live hardware `PMOVSSET_EL0` overflow bits for guest counters
    with IRQs disabled (`local_irq_save()`) in `kvm_pmu_part_overflow_status()`
    and during trapped guest accesses to `PMOVS{SET,CLR}_EL0`.
  - Add mandatory `isb()` barriers after control-plane system register
    writes (`mdcr_el2`, `pmcntenclr_el0`, `pmintenclr_el1`), preserve
    guest `PMSELR_EL0` / `PMUSERENR_EL0` when `MDCR_EL2.TPM == 0`, and
    restore host `PMCR_EL0` control flags on `kvm_pmu_put()`.

v8:
https://lore.kernel.org/kvmarm/20260612192909.1153907-1-coltonlewis@google.com/

v7:
https://lore.kernel.org/kvmarm/20260504211813.1804997-1-coltonlewis@google.com/

v6:
https://lore.kernel.org/kvmarm/20260209221414.2169465-1-coltonlewis@google.com/

v5:
https://lore.kernel.org/kvmarm/20251209205121.1871534-1-coltonlewis@google.com/

v4:
https://lore.kernel.org/kvmarm/20250714225917.1396543-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvm/20250626200459.1153955-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvm/20250620221326.1261128-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20250602192702.2125115-1-coltonlewis@google.com/

[1] https://gitlab.com/qemu-project/kvm-forum/-/raw/main/_attachments/2025/Optimizing__itvHkhc.pdf
[2] https://www.youtube.com/watch?v=YRzZ8jMIA6M&list=PLW3ep1uCIRfxwmllXTOA2txfDWN6vUOHp&index=9

Colton Lewis (21):
  arm64: cpufeature: Add cpucap for HPMN0
  KVM: arm64: Reorganize PMU functions
  perf: arm_pmuv3: Generalize counter bitmasks
  perf: arm_pmuv3: Move counter allocation mask to per-CPU struct
    pmu_hw_events
  perf: arm_pmuv3: Check cntr_mask before using pmccntr
  perf: arm_pmuv3: Allocate counter indices from high to low
  KVM: arm64: Add initial scaffolding for Partitioned PMU
  KVM: arm64: Set up FGT for Partitioned PMU
  KVM: arm64: Add Partitioned PMU register trap handlers
  KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU
  KVM: arm64: Context swap Partitioned PMU guest registers
  KVM: arm64: Enforce PMU event filter at vcpu_load()
  perf: Add perf_pmu_resched_update()
  KVM: arm64: Allow kvm_vcpu_pmu_resync_el0() to resync filters in
    process context
  KVM: arm64: Apply dynamic guest counter reservations
  KVM: arm64: Implement lazy PMU context swaps
  perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
  KVM: arm64: Detect overflows for the Partitioned PMU
  KVM: arm64: Add vCPU device attr to partition the PMU
  KVM: selftests: Add find_bit to KVM library
  KVM: arm64: selftests: Add test case for Partitioned PMU

Marc Zyngier (1):
  KVM: arm64: Reorganize PMU includes

 Documentation/virt/kvm/devices/vcpu.rst       |  42 +-
 arch/arm/include/asm/arm_pmuv3.h              |  16 +
 arch/arm64/include/asm/arm_pmuv3.h            |   7 +-
 arch/arm64/include/asm/kvm_host.h             |  18 +-
 arch/arm64/include/asm/kvm_types.h            |   6 +-
 arch/arm64/include/uapi/asm/kvm.h             |   2 +
 arch/arm64/kernel/cpufeature.c                |  10 +-
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |   4 +-
 arch/arm64/kvm/config.c                       |  49 +-
 arch/arm64/kvm/debug.c                        |  41 +-
 arch/arm64/kvm/pmu-direct.c                   | 636 ++++++++++++++
 arch/arm64/kvm/pmu-emul.c                     | 718 +---------------
 arch/arm64/kvm/pmu.c                          | 787 +++++++++++++++++-
 arch/arm64/kvm/sys_regs.c                     | 334 ++++++--
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |   6 +-
 drivers/perf/arm_pmu.c                        |   7 +-
 drivers/perf/arm_pmuv3.c                      |  97 ++-
 include/kvm/arm_pmu.h                         |  93 ++-
 include/linux/perf/arm_pmu.h                  |   2 +
 include/linux/perf/arm_pmuv3.h                |  14 +-
 include/linux/perf_event.h                    |   3 +
 kernel/events/core.c                          |  31 +-
 tools/include/perf/arm_pmuv3.h                |  12 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vpmu_counter_access.c | 129 ++-
 tools/testing/selftests/kvm/lib/find_bit.c    |   2 +
 28 files changed, 2200 insertions(+), 870 deletions(-)
 create mode 100644 arch/arm64/kvm/pmu-direct.c
 create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.56.0.rc1.310.g51773c2048-goog

