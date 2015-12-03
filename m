From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 00/21] KVM: ARM64: Add guest PMU support
Date: Thu, 3 Dec 2015 14:11:10 +0800
Message-ID: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8AAE49932
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:11:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4rgVwk1vZ3VP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 01:11:21 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10077498E9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:11:18 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
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

          0.510276      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.57% )
                 1      context-switches          #    0.002 M/sec
                 0      cpu-migrations            #    0.000 K/sec
                49      page-faults               #    0.096 M/sec                    ( +-  0.77% )
           1064117      cycles                    #    2.085 GHz                      ( +-  1.56% )
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
            529051      instructions              #    0.50  insns per cycle          ( +-  0.55% )
   <not supported>      branches
              9894      branch-misses             #   19.390 M/sec                    ( +-  1.70% )

       5.000853900 seconds time elapsed                                          ( +-  0.00% )

Guest:
 Performance counter stats for 'sleep 5' (5 runs):

          0.642456      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.81% )
                 1      context-switches          #    0.002 M/sec
                 0      cpu-migrations            #    0.000 K/sec
                49      page-faults               #    0.076 M/sec                    ( +-  1.64% )
           1322717      cycles                    #    2.059 GHz                      ( +-  1.88% )
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
            640944      instructions              #    0.48  insns per cycle          ( +-  1.10% )
   <not supported>      branches
             10665      branch-misses             #   16.600 M/sec                    ( +-  2.23% )

       5.001181452 seconds time elapsed                                          ( +-  0.00% )

Have a cycle counter read test like below in guest and host:

static void test(void)
{
	unsigned long count, count1, count2;
	count1 = read_cycles();
	count++;
	count2 = read_cycles();
}

Host:
count1: 3046186213
count2: 3046186347
delta: 134

Guest:
count1: 5645797121
count2: 5645797270
delta: 149

The gap between guest and host is very small. One reason for this I
think is that it doesn't count the cycles in EL2 and host since we add
exclude_hv = 1. So the cycles spent to store/restore registers which
happens at EL2 are not included.

This patchset can be fetched from [1] and the relevant QEMU version for
test can be fetched from [2].

The results of 'perf test' can be found from [3][4].
The results of perf_event_tests test suite can be found from [5][6].

Also, I have tested "perf top" in two VMs and host at the same time. It
works well.

Thanks,
Shannon

[1] https://git.linaro.org/people/shannon.zhao/linux-mainline.git  KVM_ARM64_PMU_v5
[2] https://git.linaro.org/people/shannon.zhao/qemu.git  virtual_PMU
[3] http://people.linaro.org/~shannon.zhao/PMU/perf-test-host.txt
[4] http://people.linaro.org/~shannon.zhao/PMU/perf-test-guest.txt
[5] http://people.linaro.org/~shannon.zhao/PMU/perf_event_tests-host.txt
[6] http://people.linaro.org/~shannon.zhao/PMU/perf_event_tests-guest.txt

Changes since v4:
* Rebase on new linux kernel mainline 
* Drop the reset handler of CP15 registers
* Fix a compile failure on arch ARM due to lack of asm/pmu.h
* Refactor the interrupt injecting flow according to Marc's suggestion
* Check the value of PMSELR register
* Calculate the attr.disabled according to PMCR.E and PMCNTENSET/CLR
* Fix some coding style
* Document the vPMU irq range

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

 Documentation/virtual/kvm/devices/arm-pmu.txt |  16 +
 arch/arm/kvm/arm.c                            |   3 +
 arch/arm64/include/asm/kvm_asm.h              |  55 ++-
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/pmu.h                  |  66 +++
 arch/arm64/include/uapi/asm/kvm.h             |   3 +
 arch/arm64/kernel/perf_event.c                |  36 +-
 arch/arm64/kvm/Kconfig                        |   8 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/reset.c                        |   3 +
 arch/arm64/kvm/sys_regs.c                     | 559 ++++++++++++++++++++++++--
 include/kvm/arm_pmu.h                         |  72 ++++
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 virt/kvm/arm/pmu.c                            | 525 ++++++++++++++++++++++++
 virt/kvm/kvm_main.c                           |   4 +
 16 files changed, 1288 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
 create mode 100644 arch/arm64/include/asm/pmu.h
 create mode 100644 include/kvm/arm_pmu.h
 create mode 100644 virt/kvm/arm/pmu.c

-- 
2.0.4
