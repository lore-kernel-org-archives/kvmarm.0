Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114338;
	b=0d/642O4pPFMZyBRGIPoXRIJx/6COudeFGm2sA+Ka0ObCrHzpsSSjWFIirolVOV/i9vl
	 lV1Aqhgd5F9VIQj09Kns1UeVkOeHZiMvsjo0rpU2dJmqabkWVKDHUeODozBj9EGGGZSE1
	 Dyw5pNKNRzxXCiNgzomf9iEj9h1dS/M0HwVr3hHKytweWQfVL8lPNO+mOkkEKgQ9xNEsz
	 d7jpRwwiI55dHa9z05cRDZBeV1pZ0jCYy0o2sasqEdKAwp39m+4ssUZUzTuVdnc8MfHQ4
	 DLebzuBfQW2/neJnvWXrYNvVJf52MW9RIs1Y7ZGUt2jeDoGZhmud5cTI68E1dFD9P/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=VoOEHP3goHz64oiB5iH1uFdwHtOTQlZ8ZXdEISYRevU=;
	b=IC3evHDQjHK12jwk8f7LAV+wLpwedKsWLGLcycPb1di4rJ54KtF3CyuwgOkDdJadM41B
	 15oM+VJrnsAcDsbYxgIS0yltSfoXduUg/ZmfM4uSKQN8MdSK6eUBlCqdz+LBxVjpq7Epb
	 ygjA9JH6JYW8t+Sd5cM45dAHoV5phs4hyRD764egxQkR2YGiRSOLOGBeejEXpf8t9R5fG
	 JNfQWmfQY8P4SthDZZnyuHNVR1lrhEZV1fzAtIL72mHtmbC28xpbDgLwzbqnAqdM7uzKZ
	 ylU9ubL3ND8QQLou5N7XpXIDVyiYMzrgNQ7iSExZT/GcelWmDPUHLwhnEuGiON87FzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LbaxHphM;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2EB606A32C
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC2EB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LbaxHphM
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a41f46d629so199503b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114337; x=1795719137; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VoOEHP3goHz64oiB5iH1uFdwHtOTQlZ8ZXdEISYRevU=;
        b=LbaxHphMz/SptOAKkJlIJf1HUy3nOhrN28n+8q5XBY0SskydZ4hLht5TM2RJRbXmdy
         sWsw93W9trW1FUqSQ4csH6mqZPKmBxpetIDogIW6iiTAflQhvGJMX2iOjSLKr0fN6/T6
         RZoGT8kMIrqEIWnTXSbcsyHz4ps7+LFZZYukucNBnAbmDNV7meh4Q3GMAVFXNsp0RbOy
         FN7XzqFj/UbnfzzORy7aXs2kP0Trq5TKgjqxgZ2SOFxx8WNQH7MWZC1rRjPBnonuaAEC
         eMZ14dx6pny0fgNFT9AXyLDQduQP/tllRKdCb1eu8hv3Ltwdm5YyVQqTg6eKB/3wTkhf
         8uYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114337; x=1795719137;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VoOEHP3goHz64oiB5iH1uFdwHtOTQlZ8ZXdEISYRevU=;
        b=vY6fhakcgbq89517NvIT6XWz34hIKUjOD/jCiR1Xrcl+TOw+SyAXJHkZjsUaClmb8F
         vmf4aj5dkHtTNE5M7jjrVgMcNtSZZXwZijrtu0/+YnyNVAyK0Ppn0EqaCouke+o6iES/
         1PEYM4aE5euYQrJIHMJU+f19+mr56f37J4h5fkDkaA+ELIbZB9e5DuwZJk3o2o4Tx5ip
         B0g5viFQv3tsKDseG8QQr//f9vUAmdSgnBuvPz951i61cerkFf9Ty0OLM5NX1iWiDTKX
         tUFIDcPVWQrRSj6E9ciw7jvTSOY6992JKLEPPd6in/+D0bXRUry6IJeiMKlwd4I9aiCh
         zf2Q==
X-Forwarded-Encrypted: i=1; AL+hErGFuBoyt28lC5vQm1LEl2nw3xWI360vxeXxySV9Fpjhx5n+u8AvTvjd6ivAjScgIExwNH60BXs=@lists.linux.dev
X-Gm-Message-State: APuU4Z9+ve0ilvu9oM/Rz6URDrAQ/m0AGZqs3xP9yw8QOk0IT2tlJndz
	zQVV+Xvvx5heIW0sbhCqRyknxaNdGjxNPvKleEJJhiEociNQRIUMnmxM5fSID6z1cJznVEACwAi
	DnIiy/mFWkOeP6k8C3e+dOCjP8Q==
X-Received: from iodz8.prod.google.com ([2002:a05:6602:6f48:b0:9c7:a5de:745e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:150b:b0:55b:f88d:919f with SMTP id 5614622812f47-57a0a5067f7mr836911b6e.53.1795114336141;
 Thu, 19 Nov 2026 10:52:16 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:42 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-1-coltonlewis@google.com>
Subject: [PATCH v10 00/33] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This series creates a new PMU scheme on ARM, a partitioned PMU that
allows reserving a subset of counters for more direct guest access,
significantly reducing overhead. More details, including performance
benchmarks, can be read in the v1 cover letter linked below.

PMU partitioning is controlled via the KVM API using
`KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION` and
`KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS` vCPU device attributes. When
partitioning is enabled for a VM, userspace must explicitly configure a
guest event counter count strictly less than the maximum general-purpose
counters implemented by the PMU (leaving at least one general-purpose
counter for the host) prior to calling `KVM_ARM_VCPU_PMU_V3_INIT`. The
number of general-purpose counters implemented by each host PMU is
exposed in sysfs at
`/sys/bus/event_source/devices/<pmu>/caps/num_counters`. A QEMU patch
demonstrating how to use the uAPI is sent separately.

An overview of what this series accomplishes was presented at KVM
Forum 2025. Slides [1] and video [2] are linked below.

v10:

* Rebase on top of v7.4-rc3.

* Add nested virtualization (`FEAT_NV` / `FEAT_NV2`) support covering
  both an Emulated L2 PMU (`vHPMN == N_L1`, `TPM == 1`, where L1 keeps
  all `N_L1` counters and emulates L2 via L1 `perf` events) and a
  Sub-partitioned L2 PMU (`vHPMN < N_L1`, `TPM == 0`, creating a
  three-way split across `0..vHPMN-1` for L2, `vHPMN..N_L1-1` for L1,
  and `N_L1..N_phys-1` for L0) (Oliver Upton). Because ARM64 provides
  only a single physical `MDCR_EL2.HPMN` field, hardware can split the
  PMU into two counter ranges at a time rather than three. Key design
  decisions and supporting changes:

  - Keep physical `MDCR_EL2.HPMN = N_L1` at all times (`vHPMN` boundary
    and event filtering): Lowering physical `HPMN` to `vHPMN` while
    running L2 was considered and rejected because it would move L1's
    hypervisor counters (`vHPMN..N_L1-1`) into the same physical
    `>= HPMN` range as L0's host counters (`N_L1..N_phys-1`), where a
    single set of physical `MDCR_EL2.{HPME,HPMD,HLP}` bits governs both
    and breaks host/guest isolation; it would also fail for
    `vHPMN == 0` on hardware without `FEAT_HPMN0`. Instead, when
    `vHPMN < N_L1`, L0 keeps physical `HPMN = N_L1` and sets
    `MDCR_EL2.{TPM,TPMCR}` in L2, forwarding `vHPMN..N_L1-1` traps to
    L1 and handling `0..vHPMN-1` plus `PMCCNTR_EL0` in L0 directly
    against physical registers. This preserves L0 isolation and
    supports `vHPMN == 0` on all hardware; L2 events still count
    directly in hardware without L0 `perf_event` scheduling, at the
    cost of trapping L2 PMU accesses to L0 and rewriting per-counter
    filter registers on `L1 <-> L2` transitions. In L1
    (`is_hyp_ctxt()`), L0 emulates `vHPMN`, `vMDCR_EL2.HPMD`, and
    `vMDCR_EL2.HCCD` via `PMEVTYPER<n>_EL0` and `PMCCFILTR_EL0`.

  - Dynamically multiplex `vPMCR_EL0.E` and `vMDCR_EL2.HPME`: Because
    both `0..vHPMN-1` and `vHPMN..N_L1-1` sit below physical
    `HPMN = N_L1`, hardware gates both with physical `PMCR_EL0.E`.
    Rather than unconditionally trapping `PMCR_EL0` and `PMCNTEN*` for
    all `FEAT_NV` VMs (which would penalize Emulated L2 PMU where
    `vHPMN == N_L1`), L0 dynamically enables `MDCR_EL2.TPMCR` and
    `HDFG{R,W}TR_EL2.PMCNTEN` only when `vHPMN < N_L1`. L0 keeps
    architectural `PMCR_EL0` and `PMCNTENSET_EL0` in memory, sets
    physical `PMCR_EL0.E` to `vPMCR_EL0.E || vMDCR_EL2.HPME`, masks
    disabled sub-ranges out of physical `PMCNTENSET_EL0`, and gates
    overflow delivery per domain. Trapped `PMSWINC_EL0` writes (also
    enabled via `HDFGWTR_EL2` when `vHPMN < N_L1`) flush live registers
    and reuse `kvm_pmu_software_increment()` to prevent cross-partition
    chaining.

  - Bias 32-bit counters on mismatched `vPMCR_EL0.LP != vMDCR_EL2.HLP`
    (`FEAT_PMUv3p5`): When `LP == HLP`, physical `PMCR_EL0.LP` matches
    both domains directly and `PMEVCNTR<n>_EL0` stays untrapped in L1.
    When `vHPMN < N_L1` and `LP != HLP`, rather than ignoring the
    mismatch (breaking 32-bit overflow interrupts) or falling back to
    `perf_event` emulation mid-flight (requiring reservation teardown),
    L0 forces physical `PMCR_EL0.LP = 1` (64-bit overflow), dynamically
    traps `HDFG{R,W}TR_EL2.PMEVCNTRn_EL0`, and biases counters in the
    32-bit sub-range `2^32` events below 64-bit overflow
    (`0xffffffff00000000 | low32`) while tracking their upper-32-bit
    offsets and re-biasing outside interrupt/NMI context. Because
    `HDFG{R,W}TR_EL2.PMEVCNTRn_EL0` is a single trap bit covering all
    event counters (`0..30`), L1 counter reads/writes trap across both
    sub-ranges while `LP != HLP`, with zero overhead when `LP == HLP`.

  - Baseline nested support (both Emulated and Sub-partitioned L2):
    separate implemented and accessible counter masks by using
    `nr_pmu_counters` directly in `kvm_pmu_implemented_counter_mask()`,
    masking trapped guest reads of `PMCNTEN*`, `PMINTEN*`, and `PMOVS*`
    with `kvm_pmu_accessible_counter_mask()`, and ignoring
    `MDCR_EL2.HPMN` in userspace `KVM_GET_ONE_REG` / `KVM_SET_ONE_REG`
    (`set_pmreg()`, `get_pmreg()`, `get_pmcr()`) so saving/restoring a
    nested vCPU paused below EL2 preserves all VM-implemented counters
    and true `PMCR_EL0.N`; preserve host counter reservations across
    `IN_NESTED_ERET` / `IN_NESTED_EXCEPTION` transitions to avoid host
    `perf` reschedules on emulated L2 traps; read live hardware
    `PMSELR_EL0` in `check_mdcr_hpmn()` when untrapped; and forward
    fine-grained traps for selector-indexed `PMXEVTYPER_EL0` and
    `PMXEVCNTR_EL0` to L1.

* Expose the number of general-purpose counters implemented by the PMU
  in sysfs under `/sys/bus/event_source/devices/<pmu>/caps/num_counters`
  so userspace VMMs can query host PMU counter capacity when configuring
  a partitioned PMU (James Clark).

* Make `__vcpu_rmw_sys_reg()` atomic on the local CPU using
  `try_cmpxchg_local()` to prevent read-modify-write races with GICv3
  pseudo-NMI PMU interrupt handlers (`kvm_pmu_handle_guest_irq()`),
  which are not masked by `local_irq_save()` (Sashiko AI Review).

* Construct `mdcr_el2` in a local variable before assigning
  `vcpu->arch.mdcr_el2` once in `kvm_arm_setup_mdcr_el2()`, and mask
  GICv3 pseudo-NMIs (`local_daif_save()`) across hardware PMU context
  switches and `MDCR_EL2` updates (Sashiko AI Review).

* Prioritize kernel-owned pinned event groups (`is_kernel_event()`)
  ahead of userspace pinned events in `perf_event_groups_cmp()` /
  `perf_less_group_idx()` so kernel-owned per-CPU pinned events (such as
  the hardlockup NMI watchdog if toggled at runtime) are scheduled before
  userspace pinned events when `perf_pmu_resched_update()` reschedules
  events out of guest-reserved counters (James Clark, Sashiko AI Review).

* Move `kvm_vcpu_reload_pmu()` from `arch/arm64/kvm/pmu-emul.c` to
  `arch/arm64/kvm/pmu.c` in `KVM: arm64: Reorganize PMU functions`.

* Add `kvm_pmu_is_partitioned()`, `kvm_pmu_guest_counter_mask()`,
  `kvm_pmu_handle_guest_irq()`, `kvm_pmu_host_start()`, and
  `kvm_pmu_host_stop()` stubs to `arch/arm/include/asm/arm_pmuv3.h` to
  fix 32-bit `ARCH=arm` builds (kernel test robot).

* Allow identical VM-wide PMU device attributes
  (`KVM_ARM_VCPU_PMU_V3_SET_PMU`, `KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS`,
  and `KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION`) to be applied across all
  vCPUs when userspace initializes vCPUs sequentially (`CPU_FOREACH`),
  validate `kvm_arm_pmu_part_hpmn(n) < max_counters` (requiring
  `max_counters >= 2` for `n == 0` without `FEAT_HPMN0`), and restrict
  `kvm->arch.supported_cpus` to `arm_pmu->supported_cpus` when
  partitioning is enabled.

* Centralize partitioned PMU hardware register dispatch under
  `kvm_pmu_direct_reg_read()` / `kvm_pmu_direct_reg_write()` with
  preemption disabled (`kvm_pmu_part_on_cpu()`), guard lazy ownership
  transitions in `kvm_pmu_part_overflow_status()` with
  `scoped_guard(preempt)`, avoid matching `reset_unknown()` poison bits on
  `PMCNTENSET_EL0` / `PMINTENSET_EL1` during `KVM_REQ_RELOAD_PMU`, and
  schedule `KVM_REQ_RELOAD_PMU` on `KVM_SET_ONE_REG` writes so
  `vcpu_put()` does not overwrite userspace register writes (Sashiko AI
  Review).

* Support configuring 0 guest event counters (cycle counter only) on
  Partitioned PMU hosts without `FEAT_HPMN0` whenever `max_counters >= 2`.
  Writing `MDCR_EL2.HPMN = 0` without `FEAT_HPMN0` is architecturally
  `CONSTRAINED UNPREDICTABLE`, which would otherwise prevent userspace
  from creating a cycle-counter-only partitioned guest on CPUs lacking
  `FEAT_HPMN0`. Instead, KVM programs physical `MDCR_EL2.HPMN = 1` via
  `kvm_arm_pmu_part_hpmn()`, reserves and quiesces physical counter 0
  alongside `PMCCNTR_EL0` so host perf continues using counters `1..N-1`,
  keeps `MDCR_EL2.TPMCR = 1` so trapped `PMCR_EL0` reads report `N == 0`,
  and enables fine-grained traps on `PMEVCNTRn_EL0`, `PMCNTEN`,
  `PMINTEN`, and `PMSWINC_EL0` so counter 0 stays completely hidden
  (`UNDEFINED` / RAZ / WI) while `PMCCNTR_EL0` remains untrapped on
  `FEAT_FGT` hosts. Also clamp `MDCR_EL2.HPMN` against `nr_pmu_counters`
  in `kvm_vcpu_read_pmcr()` and `kvm_pmu_direct_pmcr_read()`, and extend
  `vpmu_counter_access` to verify `PMCCFILTR_EL0`, live `PMCCNTR_EL0`
  counting, and trapped `UNDEFINED` / RAZ / WI behavior on counter 0 when
  `n == 0`.

Tool-assisted development note (generated-content.rst):
Several v10 additions (nested virtualization sub-partitioning,
cycle-counter-only support without `FEAT_HPMN0`, the userspace `HPMN`
masking fix, and cover letter text) were drafted and verified with AI
coding assistance (Gemini) and pre-reviewed with Sashiko AI Review. All
patches were reviewed, built (`arm64`, `CONFIG_ARM_PMU=n`, 32-bit `arm`),
and tested on bare-metal Neoverse V2 and AmpereOne hosts (and under QEMU
TCG for the userspace `HPMN` fix).

v9:
https://lore.kernel.org/kvmarm/20260924172928.2110956-1-coltonlewis@google.com/

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

Colton Lewis (32):
  arm64: cpufeature: Add cpucap for HPMN0
  KVM: arm64: Reorganize PMU functions
  KVM: arm64: Use nr_pmu_counters in kvm_pmu_implemented_counter_mask()
  KVM: arm64: Ignore HPMN for userspace PMU register access
  perf: arm_pmuv3: Generalize counter bitmasks
  perf: arm_pmuv3: Move counter allocation mask to per-CPU struct
    pmu_hw_events
  perf: arm_pmuv3: Check cntr_mask before using pmccntr
  perf: arm_pmuv3: Allocate counter indices from high to low
  perf: arm_pmuv3: Expose number of general-purpose counters in sysfs
  KVM: arm64: Add initial scaffolding for Partitioned PMU
  KVM: arm64: Set up FGT for Partitioned PMU
  KVM: arm64: Make __vcpu_rmw_sys_reg() atomic
  KVM: arm64: Add Partitioned PMU register trap handlers
  KVM: arm64: Construct mdcr_el2 in a local variable in
    kvm_arm_setup_mdcr_el2()
  KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU
  KVM: arm64: Context swap Partitioned PMU guest registers
  KVM: arm64: Enforce PMU event filter at vcpu_load()
  perf: Add perf_pmu_resched_update()
  perf/core: Prioritize kernel-owned pinned events when scheduling
    groups
  KVM: arm64: Allow kvm_vcpu_pmu_resync_el0() to resync filters in
    process context
  KVM: arm64: Apply dynamic guest counter reservations
  KVM: arm64: Implement lazy PMU context swaps
  perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
  KVM: arm64: Detect overflows for the Partitioned PMU
  KVM: arm64: Multiplex PMCR_EL0.E and MDCR_EL2.HPME for sub-partitioned
    L1
  KVM: arm64: Emulate mismatched LP and HLP overflow widths for
    sub-partitioned L1
  KVM: arm64: Emulate trapped PMSWINC_EL0 writes for Partitioned PMU
  KVM: arm64: Forward FGT traps for PMXEVTYPER_EL0 and PMXEVCNTR_EL0
  KVM: arm64: Support zero event counters on Partitioned PMU without
    HPMN0
  KVM: arm64: Add vCPU device attr to partition the PMU
  KVM: selftests: Add find_bit to KVM library
  KVM: arm64: selftests: Add test case for Partitioned PMU

Marc Zyngier (1):
  KVM: arm64: Reorganize PMU includes

 Documentation/virt/kvm/devices/vcpu.rst       |   57 +-
 arch/arm/include/asm/arm_pmuv3.h              |   12 +
 arch/arm64/include/asm/arm_pmuv3.h            |    7 +-
 arch/arm64/include/asm/kvm_host.h             |   32 +-
 arch/arm64/include/asm/kvm_nested.h           |    2 +-
 arch/arm64/include/asm/kvm_types.h            |    6 +-
 arch/arm64/include/uapi/asm/kvm.h             |    2 +
 arch/arm64/kernel/cpufeature.c                |   11 +-
 arch/arm64/kvm/Makefile                       |    2 +-
 arch/arm64/kvm/arm.c                          |    4 +-
 arch/arm64/kvm/config.c                       |   76 +-
 arch/arm64/kvm/debug.c                        |   76 +-
 arch/arm64/kvm/emulate-nested.c               |   25 +-
 arch/arm64/kvm/nested.c                       |   39 +-
 arch/arm64/kvm/pmu-direct.c                   | 1230 +++++++++++++++++
 arch/arm64/kvm/pmu-emul.c                     |  846 ++----------
 arch/arm64/kvm/pmu.c                          |  831 ++++++++++-
 arch/arm64/kvm/sys_regs.c                     |  199 ++-
 arch/arm64/tools/cpucaps                      |    1 +
 arch/arm64/tools/sysreg                       |    6 +-
 drivers/perf/arm_pmu.c                        |   18 +-
 drivers/perf/arm_pmuv3.c                      |  121 +-
 include/kvm/arm_pmu.h                         |  117 ++
 include/linux/perf/arm_pmu.h                  |    2 +
 include/linux/perf/arm_pmuv3.h                |   14 +-
 include/linux/perf_event.h                    |    3 +
 kernel/events/core.c                          |   61 +-
 tools/include/perf/arm_pmuv3.h                |   12 +-
 tools/testing/selftests/kvm/Makefile.kvm      |    1 +
 .../selftests/kvm/arm64/vpmu_counter_access.c |  217 ++-
 tools/testing/selftests/kvm/lib/find_bit.c    |    2 +
 31 files changed, 3032 insertions(+), 1000 deletions(-)
 create mode 100644 arch/arm64/kvm/pmu-direct.c
 create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.56.1.708.g77570a6a1d-goog
