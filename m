From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 00/20] KVM: ARM64: Add guest PMU support
Date: Thu, 24 Sep 2015 15:31:05 -0700
Message-ID: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patchset adds guest PMU support for KVM on ARM64. It takes
trap-and-emulate approach. When guest wants to monitor one event, it
will be trapped by KVM and KVM will call perf_event API to create a perf
event and call relevant perf_event APIs to get the count value of event.

Use perf to test this patchset in guest. When using "perf list", it
shows the list of the hardware events and hardware cache events perf
supports. Then use "perf stat -e EVENT" to monitor some event. For
example, use "perf stat -e cycles" to count cpu cycles and
"perf stat -e cache-misses" to count cache misses.

Below are the outputs of "perf stat -r 5 sleep 5" when running in host
and guest.

Host:
 Performance counter stats for 'sleep 5' (5 runs):

          0.551428      task-clock (msec)         #    0.000 CPUs utilized            ( +-  0.91% )
                 1      context-switches          #    0.002 M/sec
                 0      cpu-migrations            #    0.000 K/sec
                48      page-faults               #    0.088 M/sec                    ( +-  1.05% )
           1150265      cycles                    #    2.086 GHz                      ( +-  0.92% )
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
            526398      instructions              #    0.46  insns per cycle          ( +-  0.89% )
   <not supported>      branches
              9485      branch-misses             #   17.201 M/sec                    ( +-  2.35% )

       5.000831616 seconds time elapsed                                          ( +-  0.00% )

Guest:
 Performance counter stats for 'sleep 5' (5 runs):

          0.730868      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.13% )
                 1      context-switches          #    0.001 M/sec
                 0      cpu-migrations            #    0.000 K/sec
                48      page-faults               #    0.065 M/sec                    ( +-  0.42% )
           1642982      cycles                    #    2.248 GHz                      ( +-  1.04% )
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
            637964      instructions              #    0.39  insns per cycle          ( +-  0.65% )
   <not supported>      branches
             10377      branch-misses             #   14.198 M/sec                    ( +-  1.09% )

       5.001289068 seconds time elapsed                                          ( +-  0.00% )

This patchset can be fetched from [1] and the relevant QEMU version for
test can be fetched from [2].

Thanks,
Shannon

[1] https://git.linaro.org/people/shannon.zhao/linux-mainline.git  KVM_ARM64_PMU_v3
[2] https://git.linaro.org/people/shannon.zhao/qemu.git  PMU_v2

Changes since v2->v3:
* Directly use perf raw event type to create perf_event in KVM
* Add a helper vcpu_sysreg_write
* remove unrelated header file

Changes since v1->v2:
* Use switch...case for registers access handler instead of adding
  alone handler for each register
* Try to use the sys_regs to store the register value instead of adding
  new variables in struct kvm_pmc
* Fix the handle of cp15 regs
* Create a new kvm device vPMU, then userspace could choose whether to
  create PMU
* Fix the handle of PMU overflow interrupt

Shannon Zhao (20):
  ARM64: Move PMU register related defines to asm/pmu.h
  KVM: ARM64: Define PMU data structure for each vcpu
  KVM: ARM64: Add offset defines for PMU registers
  KVM: ARM64: Add reset and access handlers for PMCR_EL0 register
  KVM: ARM64: Add reset and access handlers for PMSELR register
  KVM: ARM64: Add reset and access handlers for PMCEID0 and PMCEID1
    register
  KVM: ARM64: PMU: Add perf event map and introduce perf event creating
    function
  KVM: ARM64: Add reset and access handlers for PMXEVTYPER register
  KVM: ARM64: Add reset and access handlers for PMXEVCNTR register
  KVM: ARM64: Add reset and access handlers for PMCCNTR register
  KVM: ARM64: Add reset and access handlers for PMCNTENSET and
    PMCNTENCLR register
  KVM: ARM64: Add reset and access handlers for PMINTENSET and
    PMINTENCLR register
  KVM: ARM64: Add reset and access handlers for PMOVSSET and PMOVSCLR
    register
  KVM: ARM64: Add reset and access handlers for PMUSERENR register
  KVM: ARM64: Add reset and access handlers for PMSWINC register
  KVM: ARM64: Add access handlers for PMEVCNTRn and PMEVTYPERn register
  KVM: ARM64: Add PMU overflow interrupt routing
  KVM: ARM64: Reset PMU state when resetting vcpu
  KVM: ARM64: Free perf event of PMU when destroying vcpu
  KVM: ARM64: Add a new kvm ARM PMU device

 Documentation/virtual/kvm/devices/arm-pmu.txt |  15 +
 arch/arm/kvm/arm.c                            |   5 +
 arch/arm64/include/asm/kvm_asm.h              |  59 +++-
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/pmu.h                  |  47 +++
 arch/arm64/include/uapi/asm/kvm.h             |   3 +
 arch/arm64/kernel/perf_event.c                |  35 --
 arch/arm64/kvm/Kconfig                        |   8 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/reset.c                        |   3 +
 arch/arm64/kvm/sys_regs.c                     | 488 ++++++++++++++++++++++++--
 arch/arm64/kvm/sys_regs.h                     |  16 +
 include/kvm/arm_pmu.h                         |  65 ++++
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 virt/kvm/arm/pmu.c                            | 414 ++++++++++++++++++++++
 virt/kvm/kvm_main.c                           |   4 +
 17 files changed, 1098 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
 create mode 100644 include/kvm/arm_pmu.h
 create mode 100644 virt/kvm/arm/pmu.c

-- 
2.1.4

