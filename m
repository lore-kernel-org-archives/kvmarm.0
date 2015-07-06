From: shannon.zhao@linaro.org
Subject: [PATCH 00/18] KVM: ARM64: Add guest PMU support
Date: Mon,  6 Jul 2015 10:17:30 +0800
Message-ID: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, shannon.zhao@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

This patchset adds guest PMU support for KVM on ARM64. It takes
trap-and-emulate approach. When guest wants to monitor one event, it
will be trapped by KVM and KVM will call perf_event API to create a perf
event and call relevant perf_event APIs to get the count value of event.

Use perf to test this patchset in guest. When using "perf list", it
shows the list of the hardware events and hardware cache events perf
supports. Then use "perf stat -e EVENT" to monitor some event. For
example, use "perf stat -e cycles" to count cpu cycles and
"perf stat -e cache-misses" to count cache misses.

This can be fetched from [1] and the relevant QEMU version for test can
be fetched from [2].

Thanks,
Shannon

[1] https://git.linaro.org/people/shannon.zhao/linux-mainline.git  KVM_ARM64_PMU_v1
[2] https://git.linaro.org/people/shannon.zhao/qemu.git  PMU

Shannon Zhao (18):
  ARM64: Move PMU register related defines to asm/pmu.h
  KVM: ARM64: Add initial support for PMU
  KVM: ARM64: Add offset defines for PMU registers
  KVM: ARM64: Add reset and access handlers for PMCR_EL0 register
  KVM: ARM64: Add reset and access handlers for PMSELR_EL0 register
  KVM: ARM64: Add reset and access handlers for PMCEID0_EL0 and
    PMCEID1_EL0 register
  KVM: ARM64: PMU: Add perf event map and introduce perf event creating
    function
  KVM: ARM64: Add reset and access handlers for PMXEVTYPER_EL0 register
  KVM: ARM64: Add reset and access handlers for PMXEVCNTR_EL0 register
  KVM: ARM64: Add reset and access handlers for PMCCNTR_EL0 register
  KVM: ARM64: Add reset and access handlers for PMCNTENSET_EL0 and
    PMCNTENCLR_EL0 register
  KVM: ARM64: Add reset and access handlers for PMINTENSET_EL1 and
    PMINTENCLR_EL1 register
  KVM: ARM64: Add reset and access handlers for PMOVSSET_EL0 and
    PMOVSCLR_EL0 register
  KVM: ARM64: Add reset and access handlers for PMUSERENR_EL0 register
  KVM: ARM64: Add reset and access handlers for PMSWINC_EL0 register
  KVM: ARM64: Add access handlers for PMEVCNTRn_EL0 and PMEVTYPERn_EL0
    register
  KVM: ARM64: Add PMU overflow interrupt routing
  KVM: ARM64: Add KVM_CAP_ARM_PMU and KVM_ARM_PMU_SET_IRQ

 arch/arm/kvm/arm.c                |  14 ++
 arch/arm64/include/asm/kvm_asm.h  |  59 ++++-
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/pmu.h      |  47 ++++
 arch/arm64/kernel/perf_event.c    |  35 ---
 arch/arm64/kvm/Kconfig            |   7 +
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/reset.c            |   3 +
 arch/arm64/kvm/sys_regs.c         | 448 ++++++++++++++++++++++++++++++++++++--
 include/kvm/arm_pmu.h             |  87 ++++++++
 include/uapi/linux/kvm.h          |   4 +
 virt/kvm/arm/pmu.c                | 414 +++++++++++++++++++++++++++++++++++
 12 files changed, 1064 insertions(+), 57 deletions(-)
 create mode 100644 include/kvm/arm_pmu.h
 create mode 100644 virt/kvm/arm/pmu.c

-- 
2.1.0

