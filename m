From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v8 00/20] KVM: ARM64: Add guest PMU support
Date: Tue, 22 Dec 2015 16:07:55 +0800
Message-ID: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9FC7411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 03:08:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oU-mJIq7yW+W for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 03:08:35 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49C90411AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 03:08:33 -0500 (EST)
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
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
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

          0.549456      task-clock (msec)         #    0.000 CPUs utilized            ( +-  5.68% )
                 1      context-switches          #    0.002 M/sec
                 0      cpu-migrations            #    0.000 K/sec
                48      page-faults               #    0.088 M/sec                    ( +-  1.40% )
           1146243      cycles                    #    2.086 GHz                      ( +-  5.71% )
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
            627195      instructions              #    0.55  insns per cycle          ( +- 15.65% )
   <not supported>      branches
              9826      branch-misses             #   17.883 M/sec                    ( +-  1.10% )

       5.000875516 seconds time elapsed                                          ( +-  0.00% )


Guest:
 Performance counter stats for 'sleep 5' (5 runs):

          0.640712      task-clock (msec)         #    0.000 CPUs utilized            ( +-  0.41% )
                 1      context-switches          #    0.002 M/sec
                 0      cpu-migrations            #    0.000 K/sec
                50      page-faults               #    0.077 M/sec                    ( +-  1.37% )
           1320428      cycles                    #    2.061 GHz                      ( +-  0.29% )
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
            642373      instructions              #    0.49  insns per cycle          ( +-  0.46% )
   <not supported>      branches
             10399      branch-misses             #   16.230 M/sec                    ( +-  1.57% )

       5.001181020 seconds time elapsed                                          ( +-  0.00% )


Have a cycle counter read test like below in guest and host:

static void test(void)
{
	unsigned long count, count1, count2;
	count1 = read_cycles();
	count++;
	count2 = read_cycles();
}

Host:
count1: 3049567104
count2: 3049567247
delta: 143

Guest:
count1: 5281420890
count2: 5281421068
delta: 178

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

[1] https://git.linaro.org/people/shannon.zhao/linux-mainline.git  KVM_ARM64_PMU_v8
[2] https://git.linaro.org/people/shannon.zhao/qemu.git  virtual_PMU
[3] http://people.linaro.org/~shannon.zhao/PMU/perf-test-host.txt
[4] http://people.linaro.org/~shannon.zhao/PMU/perf-test-guest.txt
[5] http://people.linaro.org/~shannon.zhao/PMU/perf_event_tests-host.txt
[6] http://people.linaro.org/~shannon.zhao/PMU/perf_event_tests-guest.txt

Changes since v7:
* Rebase on kvm-arm next
* Fix the handler of PMUSERENR and add a helper to forward trap to guest
  EL1
* Fix some small bugs found by Marc

Changes since v6:
* Rebase on v4.4-rc5
* Drop access_pmu_cp15_regs() so that it could use same handler for both
  arch64 and arch32. And it could drop the definitions of CP15 register
  offsets, also avoid same codes added twice
* Use vcpu_sys_reg() when accessing PMU registers to avoid endian things
* Add handler for PMUSERENR and some checkers for other registers
* Add kvm_arm_pmu_get_attr()

Changes since v5:
* Rebase on new linux kernel mainline
* Remove state duplications and drop PMOVSCLR, PMCNTENCLR, PMINTENCLR,
  PMXEVCNTR, PMXEVTYPER
* Add a helper to check if vPMU is already initialized
* remove kvm_vcpu from kvm_pmc

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

Shannon Zhao (20):
  ARM64: Move PMU register related defines to asm/pmu.h
  KVM: ARM64: Define PMU data structure for each vcpu
  KVM: ARM64: Add offset defines for PMU registers
  KVM: ARM64: Add access handler for PMCR register
  KVM: ARM64: Add access handler for PMSELR register
  KVM: ARM64: Add access handler for PMCEID0 and PMCEID1 register
  KVM: ARM64: PMU: Add perf event map and introduce perf event creating
    function
  KVM: ARM64: Add access handler for event typer register
  KVM: ARM64: Add access handler for event counter register
  KVM: ARM64: Add access handler for PMCNTENSET and PMCNTENCLR register
  KVM: ARM64: Add access handler for PMINTENSET and PMINTENCLR register
  KVM: ARM64: Add access handler for PMOVSSET and PMOVSCLR register
  KVM: ARM64: Add access handler for PMSWINC register
  KVM: ARM64: Add helper to handle PMCR register bits
  KVM: ARM64: Add a helper to forward trap to guest EL1
  KVM: ARM64: Add access handler for PMUSERENR register
  KVM: ARM64: Add PMU overflow interrupt routing
  KVM: ARM64: Reset PMU state when resetting vcpu
  KVM: ARM64: Free perf event of PMU when destroying vcpu
  KVM: ARM64: Add a new kvm ARM PMU device

 Documentation/virtual/kvm/devices/arm-pmu.txt |  24 ++
 arch/arm/kvm/arm.c                            |   3 +
 arch/arm64/include/asm/kvm_emulate.h          |   1 +
 arch/arm64/include/asm/kvm_host.h             |  17 +
 arch/arm64/include/asm/pmu.h                  |  79 ++++
 arch/arm64/include/uapi/asm/kvm.h             |   4 +
 arch/arm64/kernel/perf_event.c                |  36 +-
 arch/arm64/kvm/Kconfig                        |   7 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/hyp/switch.c                   |   3 +
 arch/arm64/kvm/inject_fault.c                 |  52 ++-
 arch/arm64/kvm/reset.c                        |   3 +
 arch/arm64/kvm/sys_regs.c                     | 598 ++++++++++++++++++++++++--
 include/kvm/arm_pmu.h                         |  74 ++++
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 virt/kvm/arm/pmu.c                            | 504 ++++++++++++++++++++++
 virt/kvm/kvm_main.c                           |   4 +
 18 files changed, 1348 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
 create mode 100644 arch/arm64/include/asm/pmu.h
 create mode 100644 include/kvm/arm_pmu.h
 create mode 100644 virt/kvm/arm/pmu.c

-- 
2.0.4
