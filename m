Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040574C4F58
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781948; cv=none; b=kpwRp5gaInjLDB1ZKwhThdmWzf0BOKSfINO6vAtva3YWddziRgJgeQmYX/jXxNqujVavrw0ev8j31kg/NrhrIrR//algQTFZtlDcvcPsE1hCGSAU0UqKE16995jkI9c8RpV0KsK9/7TQgqUgpO01cfEq4xrpff4OrzbV+BwIGpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781948; c=relaxed/simple;
	bh=tw8VEhkaJLys3VBxozpDegjtznBwhDam2zldl0cUZcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pBUYzHFFUvc+2c+O2RPnw6Y0hNU1Crl8bt9wKaUpCUqWC8ElRs+97rUIcV6/OaK0qRa5KMvNS056hhsPATn9UADaCl2mzmTW2HDEUmYmYSLenIHN+D7yXtAFeLqyJjcJMWVH/lFXY8XsWPRjfjwGwYHToOcRJXqu0mpNBSRSVKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qb/KHaK3; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qb/KHaK3"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e32f913c3so14549766b.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1790781938; x=1791386738; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=URPVZ5mnqaX/4a/mHP5WDlkoNKbhEPagHNKAx4oZedE=;
        b=Qb/KHaK3hjbAqlkJtPNP/JMK7GzdDzSrPiMWZb+57SubyObY8NwNGQcod/mJte/W3w
         lo3WEF4kh2tWmrvC5vEq2bVrfssUQpCvDJySnvroNswVlfuY8+RULYBsZ7uXI+3xgEUh
         iyUYEs3fctAf///trsiL80eMkMfb0J6oMDAkRp+iLdGKVI3HMJB10hg7Xn5lavfW8goP
         6tPIFFlYOX0fW3le8YnFrcrzQv6OEaA989suzrJ+qb8oAGwdv8dMKzaGGdg1ePSCzU3e
         05AW8yjUCBrPxqZYwPdmj0w6nujPncxIqxBNu2dUgGG17/n2pYKN/89zZh4Czxn2uSyB
         7oAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781938; x=1791386738;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=URPVZ5mnqaX/4a/mHP5WDlkoNKbhEPagHNKAx4oZedE=;
        b=FIbTH0AYtfCig0I3eW6EGsV6D+yaaHKL659MLaVtUy50uVhIrbHrl6hdrTVcqIa3Uh
         2gyG+pcchys23SzzN7Cl8XiByEKH9N+26qr7Ier2oqbnmhbD8P5Rgs85D1ONzLGdaqWY
         7gvjIYEcVqxv7XKFNbX6JEGUeviboSqz8NXtClHcFpW6/4XxjAim6n+I7wZe/s09UAGN
         2xPOrPBqtS13OWBFaWXJmRENaEn/nLI8YbtoaoMJOBlk/Crt9h4rbwOsniAvv2Ae7pwA
         mbuXQYeDYS4xnvAnnUxX1g6+RImObWyEj5u77JpSoMd+L3NyVIxUjofpigyQGhFGdQvJ
         Usjw==
X-Forwarded-Encrypted: i=1; AKwUvBxyeeJUVZiAtakuhxgZDRGOnT5YG+26XWFVlDXET4MyAkAUGypV9246Y8EvwSYVFBVjxW1JY/M=@lists.linux.dev
X-Gm-Message-State: AFq9FYLEXSk+NbvLA1dmCniZYheYgFAXLDCZCY6I6IuKj98/kObcvt1o
	vqLwD4zxUfGKx01qUbgarvgBHpGiaSV13GSJWidrA0OxrzQZQnN/RDBetaZNVQqCgAA=
X-Gm-Gg: AYBFou2NFNTrhXBsxNRBdkZypt7IJ58Z2gP/MIoyYwTHZ0fYacXz3SUtVwT+xjlLuzp
	bcVFRlXF3HSSlaTq2PVVuNCbObcB/g8GJsdaksjpbilauXtaiRvnHETkGnYuONPT3CguAEMev5b
	Vbb4ENfXWyIhOkx/QoM+gWWucDQSmf75wSg/ecX8hyIU2s7tRpNG1Frbv5tiV/LQljL9La3ajlj
	UdD93zx9+saXGyp/hmB9mMD8+Wd6njv7uOM5LwgFv3nqrP6riENN+pvRjgkbV7tYEVjDG7P7Pyz
	QP1WMarZ19ago+eznJ7SoI3LMwVfu64wzwj2FI5WVGaQD2umwtYUhjy6FkHs24rW9MhXvHw9f+z
	OoMhJDTtf0zxvCJIsMz8ADQJ1MfTQThyUrTxRWi/HwMEJKyYDDJl8kHfOc/9pajrgTpj6r9eUSc
	Nwi8DIHKdk4UYeHKY6g/29a/97KsZzm1rBnh5Vu6a8XCDcsRVYbFNFkuT1zAjkaf7clClIGkFBg
	VI=
X-Received: by 2002:a17:907:6095:b0:c29:5215:b2d8 with SMTP id a640c23a62f3a-c2e23cabf4fmr155306066b.14.1790781938443;
        Wed, 30 Sep 2026 08:25:38 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.141.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31dd955bsm23066166b.70.2026.09.30.08.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 08:25:38 -0700 (PDT)
Message-ID: <8e47bb89-a894-4fd0-9f96-e11b5dea1972@linaro.org>
Date: Wed, 30 Sep 2026 16:25:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/22] ARM64 PMU Partitioning
To: Colton Lewis <coltonlewis@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Zide Chen <zide.chen@intel.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Mingwei Zhang <mizhang@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
References: <20260924172928.2110956-1-coltonlewis@google.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 24/09/2026 18:29, Colton Lewis wrote:
> This series creates a new PMU scheme on ARM, a partitioned PMU that
> allows reserving a subset of counters for more direct guest access,
> significantly reducing overhead. More details, including performance
> benchmarks, can be read in the v1 cover letter linked below.
> 
> There is no longer a kernel command line parameter
> (`arm_pmuv3.reserved_host_counters`); PMU partitioning is now completely
> controlled via the KVM API using `KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION`
> and `KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS` vCPU device attributes. When
> partitioning is enabled for a VM, userspace must explicitly configure a
> guest event counter count strictly less than the maximum general-purpose
> counters implemented by the PMU (leaving at least one general-purpose
> counter for the host) prior to calling `KVM_ARM_VCPU_PMU_V3_INIT`. A QEMU
> patch demonstrating how to use the uAPI is sent separately.
> 
> An overview of what this series accomplishes was presented at KVM
> Forum 2025. Slides [1] and video [2] are linked below.
> 
> v9:
> 
> * Rebase on top of v7.3-rc4.
> 
> * Drop the `arm_pmuv3.reserved_host_counters` module parameter so
>    partitioning is completely controlled via the KVM vCPU device
>    attribute uAPI (`KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION` and
>    `KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS`), and document the new
>    attribute and counter allocation rules in
>    `Documentation/virt/kvm/devices/vcpu.rst` (James Clark).
> 
> * Move the dynamic counter allocation mask (`cntr_mask`) from global
>    `struct arm_pmu` to per-CPU `struct pmu_hw_events` (`cpuc->cntr_mask`)
>    in a dedicated `drivers/perf` patch, fixing multi-pCPU counter
>    reservation clobbering on vCPU migration and eliminating the
>    `cpu_pm_pmu_setup()` cpuidle `WARN_ON_ONCE` (Zide Chen, James Clark).
> 
> * Synchronously propagate trapped guest writes to `PMEVTYPER<n>_EL0`
>    and `PMCCFILTR_EL0` to hardware via `kvm_pmu_apply_single_event_filter()`
>    when guest-owned, fixing in-guest `perf stat` event count skew across
>    runs (James Clark, Sashiko AI Review).
> 
> * Refactor `armv8pmu_can_use_pmccntr()` and `armv8pmu_get_event_idx()`
>    to check `cntr_mask` inside `armv8pmu_can_use_pmccntr()` and un-nest
>    the 64-bit user-access check so cycle events fall back cleanly to
>    general-purpose counters when `PMCCNTR_EL0` is reserved by a guest
>    (Robin Murphy).
> 
> * Restrict the lazy transition to `VCPU_PMU_ACCESS_GUEST_OWNED` to when
>    the guest actively enables counting (`PMCR_EL0.E = 1` or setting guest
>    counter bits in `PMCNTENSET_EL0` / `PMINTENSET_EL1`), preventing guest
>    boot-time PMU probing from prematurely claiming hardware counters and
>    triggering spurious host counter preemption warnings (James Clark).
> 
> * Fix patch dependency ordering and series bisectability across all
>    commits, removing intermediate `max_guest_counters` / `hw_cntr_impl`
>    churn and squashing the selftest exception relaxation into the
>    Partitioned PMU selftest patch (James Clark).
> 
> * Fix compiler warning for `struct arm_pmu` declaration in
>    `include/kvm/arm_pmu.h` (kernel test robot) and guard
>    `kvm_pmu_host_counter_mask()` when KVM is compiled in but not active
>    (wuyifan).
> 
> * Track physical CPU PMU residency in `vcpu->arch.pmu.loaded_on_cpu`
>    separately from `VCPU_PMU_ACCESS_GUEST_OWNED`, and toggle
>    `MDCR_EL2.HPME` via `kvm_pmu_host_start()` / `kvm_pmu_host_stop()`
>    instead of `PMCR_EL0.E` when starting/stopping host perf events while
>    a partitioned guest is loaded.
> 
> * Allow `kvm_vcpu_pmu_resync_el0()` to resynchronize VHE EL0 event
>    filters (`PMEVTYPER<n>_EL0.U`) in process context and order
>    `kvm_pmu_put()` before `kvm_vcpu_pmu_restore_host()` in
>    `kvm_arch_vcpu_put()`.
> 
> * Address additional Sashiko AI Review findings:
>    - Check `idx - 1` against `cpuc->cntr_mask` in `armv8pmu_get_chain_idx()`
>      to prevent 64-bit chained host events from crossing an odd `HPMN`
>      partition boundary, and use `cpuc->cntr_mask` in
>      `armv8pmu_enable_user_access()`.
>    - Latch live hardware `PMOVSSET_EL0` overflow bits for guest counters
>      with IRQs disabled (`local_irq_save()`) in `kvm_pmu_part_overflow_status()`
>      and during trapped guest accesses to `PMOVS{SET,CLR}_EL0`.
>    - Add mandatory `isb()` barriers after control-plane system register
>      writes (`mdcr_el2`, `pmcntenclr_el0`, `pmintenclr_el1`), preserve
>      guest `PMSELR_EL0` / `PMUSERENR_EL0` when `MDCR_EL2.TPM == 0`, and
>      restore host `PMCR_EL0` control flags on `kvm_pmu_put()`.
> 
> v8:
> https://lore.kernel.org/kvmarm/20260612192909.1153907-1-coltonlewis@google.com/
> 
> v7:
> https://lore.kernel.org/kvmarm/20260504211813.1804997-1-coltonlewis@google.com/
> 
> v6:
> https://lore.kernel.org/kvmarm/20260209221414.2169465-1-coltonlewis@google.com/
> 
> v5:
> https://lore.kernel.org/kvmarm/20251209205121.1871534-1-coltonlewis@google.com/
> 
> v4:
> https://lore.kernel.org/kvmarm/20250714225917.1396543-1-coltonlewis@google.com/
> 
> v3:
> https://lore.kernel.org/kvm/20250626200459.1153955-1-coltonlewis@google.com/
> 
> v2:
> https://lore.kernel.org/kvm/20250620221326.1261128-1-coltonlewis@google.com/
> 
> v1:
> https://lore.kernel.org/kvm/20250602192702.2125115-1-coltonlewis@google.com/
> 
> [1] https://gitlab.com/qemu-project/kvm-forum/-/raw/main/_attachments/2025/Optimizing__itvHkhc.pdf
> [2] https://www.youtube.com/watch?v=YRzZ8jMIA6M&list=PLW3ep1uCIRfxwmllXTOA2txfDWN6vUOHp&index=9
> 
> Colton Lewis (21):
>    arm64: cpufeature: Add cpucap for HPMN0
>    KVM: arm64: Reorganize PMU functions
>    perf: arm_pmuv3: Generalize counter bitmasks
>    perf: arm_pmuv3: Move counter allocation mask to per-CPU struct
>      pmu_hw_events
>    perf: arm_pmuv3: Check cntr_mask before using pmccntr
>    perf: arm_pmuv3: Allocate counter indices from high to low
>    KVM: arm64: Add initial scaffolding for Partitioned PMU
>    KVM: arm64: Set up FGT for Partitioned PMU
>    KVM: arm64: Add Partitioned PMU register trap handlers
>    KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU
>    KVM: arm64: Context swap Partitioned PMU guest registers
>    KVM: arm64: Enforce PMU event filter at vcpu_load()
>    perf: Add perf_pmu_resched_update()
>    KVM: arm64: Allow kvm_vcpu_pmu_resync_el0() to resync filters in
>      process context
>    KVM: arm64: Apply dynamic guest counter reservations
>    KVM: arm64: Implement lazy PMU context swaps
>    perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
>    KVM: arm64: Detect overflows for the Partitioned PMU
>    KVM: arm64: Add vCPU device attr to partition the PMU
>    KVM: selftests: Add find_bit to KVM library
>    KVM: arm64: selftests: Add test case for Partitioned PMU
> 
> Marc Zyngier (1):
>    KVM: arm64: Reorganize PMU includes
> 
>   Documentation/virt/kvm/devices/vcpu.rst       |  42 +-
>   arch/arm/include/asm/arm_pmuv3.h              |  16 +
>   arch/arm64/include/asm/arm_pmuv3.h            |   7 +-
>   arch/arm64/include/asm/kvm_host.h             |  18 +-
>   arch/arm64/include/asm/kvm_types.h            |   6 +-
>   arch/arm64/include/uapi/asm/kvm.h             |   2 +
>   arch/arm64/kernel/cpufeature.c                |  10 +-
>   arch/arm64/kvm/Makefile                       |   2 +-
>   arch/arm64/kvm/arm.c                          |   4 +-
>   arch/arm64/kvm/config.c                       |  49 +-
>   arch/arm64/kvm/debug.c                        |  41 +-
>   arch/arm64/kvm/pmu-direct.c                   | 636 ++++++++++++++
>   arch/arm64/kvm/pmu-emul.c                     | 718 +---------------
>   arch/arm64/kvm/pmu.c                          | 787 +++++++++++++++++-
>   arch/arm64/kvm/sys_regs.c                     | 334 ++++++--
>   arch/arm64/tools/cpucaps                      |   1 +
>   arch/arm64/tools/sysreg                       |   6 +-
>   drivers/perf/arm_pmu.c                        |   7 +-
>   drivers/perf/arm_pmuv3.c                      |  97 ++-
>   include/kvm/arm_pmu.h                         |  93 ++-
>   include/linux/perf/arm_pmu.h                  |   2 +
>   include/linux/perf/arm_pmuv3.h                |  14 +-
>   include/linux/perf_event.h                    |   3 +
>   kernel/events/core.c                          |  31 +-
>   tools/include/perf/arm_pmuv3.h                |  12 +-
>   tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>   .../selftests/kvm/arm64/vpmu_counter_access.c | 129 ++-
>   tools/testing/selftests/kvm/lib/find_bit.c    |   2 +
>   28 files changed, 2200 insertions(+), 870 deletions(-)
>   create mode 100644 arch/arm64/kvm/pmu-direct.c
>   create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5

Hi Colton,

Looks good to me, everything seems to be working now:

Tested-by: James Clark <james.clark@linaro.org>

There are still a few Sashiko comments though, and one critical one 
about racing with pseudo-NMI PMU interrupts that looked reasonable. I 
tried to test it and reproduce an actual issue but couldn't, so maybe 
it's bogus.

