From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 00/21] KVM: ARM64: Add guest PMU support
Date: Fri, 30 Oct 2015 14:21:42 +0800
Message-ID: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, zhaoshenglong@huawei.com
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

Below are the outputs of "perf stat -r 5 sleep 5" when running in host
and guest.

Host:
 Performance counter stats for 'sleep 5' (5 runs):

          0.522048      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.50% )
                 1      context-switches          #    0.002 M/sec
                 0      cpu-migrations            #    0.383 K/sec                    ( +-100.00% )
                48      page-faults               #    0.092 M/sec                    ( +-  0.66% )
           1088597      cycles                    #    2.085 GHz                      ( +-  1.50% )
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
            524457      instructions              #    0.48  insns per cycle          ( +-  0.89% )
   <not supported>      branches
              9688      branch-misses             #   18.557 M/sec                    ( +-  1.78% )

       5.000851736 seconds time elapsed                                          ( +-  0.00% )

Guest:
 Performance counter stats for 'sleep 5' (5 runs):

          0.632288      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.11% )
                 1      context-switches          #    0.002 M/sec
                 0      cpu-migrations            #    0.000 K/sec
                49      page-faults               #    0.078 M/sec                    ( +-  1.19% )
           1119933      cycles                    #    1.771 GHz                      ( +-  1.19% )
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
            568318      instructions              #    0.51  insns per cycle          ( +-  0.91% )
   <not supported>      branches
             10227      branch-misses             #   16.175 M/sec                    ( +-  1.71% )

       5.001170616 seconds time elapsed                                          ( +-  0.00% )

Have a cycle counter read test like below in guest and host:

static void test(void)
{
	unsigned long count, count1, count2;
	count1 = read_cycles();
	count++;
	count2 = read_cycles();
}

Host:
count1: 3044948797
count2: 3044948931
delta: 134

Guest:
count1: 5782364731
count2: 5782364885
delta: 154

The gap between guest and host is very small. One reason for this I
think is that it doesn't count the cycles in EL2 and host since we add
exclude_hv = 1. So the cycles spent to store/restore registers which
happens at EL2 are not included.

This patchset can be fetched from [1] and the relevant QEMU version for
test can be fetched from [2].

The results of 'perf test' can be found from [3][4].
The results of perf_event_tests test suite can be found from [5][6].

Thanks,
Shannon

[1] https://git.linaro.org/people/shannon.zhao/linux-mainline.git  KVM_ARM64_PMU_v4
[2] https://git.linaro.org/people/shannon.zhao/qemu.git  virtual_PMU
[3] http://people.linaro.org/~shannon.zhao/PMU/perf-test-host.txt
[4] http://people.linaro.org/~shannon.zhao/PMU/perf-test-guest.txt
[5] http://people.linaro.org/~shannon.zhao/PMU/perf_event_tests-host.txt
[6] http://people.linaro.org/~shannon.zhao/PMU/perf_event_tests-guest.txt

Changes since v3:
* Rebase on new linux kernel mainline 
* Use ARMV8_MAX_COUNTERS instead of 32
* Reset PMCR.E to zero.
* Trigger overflow for software increment.
* Optimize PMU interrupt inject logic.
* Add handler for E,C,P bits of PMCR
* Fix the overflow bug found by perf_event_tests
* Run 'perf test', 'perf top' and perf_event_tests test suite
* Add exclude_hv = 1 configuration to not count in EL2

Changes since v2:
* Directly use perf raw event type to create perf_event in KVM
* Add a helper vcpu_sysreg_write
* remove unrelated header file

Changes since v1:
* Use switch...case for registers access handler instead of adding
  alone handler for each register
* Try to use the sys_regs to store the register value instead of adding
  new variables in struct kvm_pmc
* Fix the handle of cp15 regs
* Create a new kvm device vPMU, then userspace could choose whether to
  create PMU
* Fix the handle of PMU overflow interrupt

Shannon Zhao (21):
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
  KVM: ARM64: Add helper to handle PMCR register bits
  KVM: ARM64: Add PMU overflow interrupt routing
  KVM: ARM64: Reset PMU state when resetting vcpu
  KVM: ARM64: Free perf event of PMU when destroying vcpu
  KVM: ARM64: Add a new kvm ARM PMU device

 Documentation/virtual/kvm/devices/arm-pmu.txt |  15 +
 arch/arm/kvm/arm.c                            |   5 +
 arch/arm64/include/asm/kvm_asm.h              |  55 ++-
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/pmu.h                  |  47 +++
 arch/arm64/include/uapi/asm/kvm.h             |   3 +
 arch/arm64/kernel/perf_event.c                |  35 --
 arch/arm64/kvm/Kconfig                        |   8 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/reset.c                        |   3 +
 arch/arm64/kvm/sys_regs.c                     | 547 ++++++++++++++++++++++++--
 arch/arm64/kvm/sys_regs.h                     |  16 +
 include/kvm/arm_pmu.h                         |  74 ++++
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 virt/kvm/arm/pmu.c                            | 510 ++++++++++++++++++++++++
 virt/kvm/arm/vgic.c                           |   8 +
 virt/kvm/arm/vgic.h                           |   1 +
 virt/kvm/kvm_main.c                           |   4 +
 19 files changed, 1269 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
 create mode 100644 include/kvm/arm_pmu.h
 create mode 100644 virt/kvm/arm/pmu.c

-- 
2.0.4


