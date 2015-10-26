From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 00/20] KVM: ARM64: Add guest PMU support
Date: Mon, 26 Oct 2015 12:33:49 +0100
Message-ID: <20151026113349.GA20298@cbox>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D0A410BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 07:30:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id drweHH4s3r07 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2015 07:30:22 -0400 (EDT)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FB7440FA2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 07:30:22 -0400 (EDT)
Received: by lffz202 with SMTP id z202so144497082lff.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 04:33:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <shannon.zhao@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 24, 2015 at 03:31:05PM -0700, Shannon Zhao wrote:
> This patchset adds guest PMU support for KVM on ARM64. It takes
> trap-and-emulate approach. When guest wants to monitor one event, it
> will be trapped by KVM and KVM will call perf_event API to create a perf
> event and call relevant perf_event APIs to get the count value of event.
> 
> Use perf to test this patchset in guest. When using "perf list", it
> shows the list of the hardware events and hardware cache events perf
> supports. Then use "perf stat -e EVENT" to monitor some event. For
> example, use "perf stat -e cycles" to count cpu cycles and
> "perf stat -e cache-misses" to count cache misses.
> 
> Below are the outputs of "perf stat -r 5 sleep 5" when running in host
> and guest.
> 
> Host:
>  Performance counter stats for 'sleep 5' (5 runs):
> 
>           0.551428      task-clock (msec)         #    0.000 CPUs utilized            ( +-  0.91% )
>                  1      context-switches          #    0.002 M/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 48      page-faults               #    0.088 M/sec                    ( +-  1.05% )
>            1150265      cycles                    #    2.086 GHz                      ( +-  0.92% )
>    <not supported>      stalled-cycles-frontend
>    <not supported>      stalled-cycles-backend
>             526398      instructions              #    0.46  insns per cycle          ( +-  0.89% )
>    <not supported>      branches
>               9485      branch-misses             #   17.201 M/sec                    ( +-  2.35% )
> 
>        5.000831616 seconds time elapsed                                          ( +-  0.00% )
> 
> Guest:
>  Performance counter stats for 'sleep 5' (5 runs):
> 
>           0.730868      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.13% )
>                  1      context-switches          #    0.001 M/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                 48      page-faults               #    0.065 M/sec                    ( +-  0.42% )
>            1642982      cycles                    #    2.248 GHz                      ( +-  1.04% )
>    <not supported>      stalled-cycles-frontend
>    <not supported>      stalled-cycles-backend
>             637964      instructions              #    0.39  insns per cycle          ( +-  0.65% )
>    <not supported>      branches
>              10377      branch-misses             #   14.198 M/sec                    ( +-  1.09% )
> 
>        5.001289068 seconds time elapsed                                          ( +-  0.00% )

This looks pretty cool!

I'll review your next patch set version in more detail.

Have you tried runnig a no-op cycle counter read test in the guest and
in the host?

Basically something like:

static void nop(void *junk)
{
}

static void test_nop(void)
{
	unsigned long before,after;
	before = read_cycles();
	isb();
	nop(NULL);
	isb();
	after = read_cycles();
}

I would be very curious to see if we get a ~6000 cycles overhead in the
guest compared to bare-metal, which I expect.

If we do, we should consider a hot-path in the the EL2 assembly code to
read the cycle counter to reduce the overhead to something more precise.


Thanks,
-Christoffer


> 
> This patchset can be fetched from [1] and the relevant QEMU version for
> test can be fetched from [2].
> 
> Thanks,
> Shannon
> 
> [1] https://git.linaro.org/people/shannon.zhao/linux-mainline.git  KVM_ARM64_PMU_v3
> [2] https://git.linaro.org/people/shannon.zhao/qemu.git  PMU_v2
> 
> Changes since v2->v3:
> * Directly use perf raw event type to create perf_event in KVM
> * Add a helper vcpu_sysreg_write
> * remove unrelated header file
> 
> Changes since v1->v2:
> * Use switch...case for registers access handler instead of adding
>   alone handler for each register
> * Try to use the sys_regs to store the register value instead of adding
>   new variables in struct kvm_pmc
> * Fix the handle of cp15 regs
> * Create a new kvm device vPMU, then userspace could choose whether to
>   create PMU
> * Fix the handle of PMU overflow interrupt
> 
> Shannon Zhao (20):
>   ARM64: Move PMU register related defines to asm/pmu.h
>   KVM: ARM64: Define PMU data structure for each vcpu
>   KVM: ARM64: Add offset defines for PMU registers
>   KVM: ARM64: Add reset and access handlers for PMCR_EL0 register
>   KVM: ARM64: Add reset and access handlers for PMSELR register
>   KVM: ARM64: Add reset and access handlers for PMCEID0 and PMCEID1
>     register
>   KVM: ARM64: PMU: Add perf event map and introduce perf event creating
>     function
>   KVM: ARM64: Add reset and access handlers for PMXEVTYPER register
>   KVM: ARM64: Add reset and access handlers for PMXEVCNTR register
>   KVM: ARM64: Add reset and access handlers for PMCCNTR register
>   KVM: ARM64: Add reset and access handlers for PMCNTENSET and
>     PMCNTENCLR register
>   KVM: ARM64: Add reset and access handlers for PMINTENSET and
>     PMINTENCLR register
>   KVM: ARM64: Add reset and access handlers for PMOVSSET and PMOVSCLR
>     register
>   KVM: ARM64: Add reset and access handlers for PMUSERENR register
>   KVM: ARM64: Add reset and access handlers for PMSWINC register
>   KVM: ARM64: Add access handlers for PMEVCNTRn and PMEVTYPERn register
>   KVM: ARM64: Add PMU overflow interrupt routing
>   KVM: ARM64: Reset PMU state when resetting vcpu
>   KVM: ARM64: Free perf event of PMU when destroying vcpu
>   KVM: ARM64: Add a new kvm ARM PMU device
> 
>  Documentation/virtual/kvm/devices/arm-pmu.txt |  15 +
>  arch/arm/kvm/arm.c                            |   5 +
>  arch/arm64/include/asm/kvm_asm.h              |  59 +++-
>  arch/arm64/include/asm/kvm_host.h             |   2 +
>  arch/arm64/include/asm/pmu.h                  |  47 +++
>  arch/arm64/include/uapi/asm/kvm.h             |   3 +
>  arch/arm64/kernel/perf_event.c                |  35 --
>  arch/arm64/kvm/Kconfig                        |   8 +
>  arch/arm64/kvm/Makefile                       |   1 +
>  arch/arm64/kvm/reset.c                        |   3 +
>  arch/arm64/kvm/sys_regs.c                     | 488 ++++++++++++++++++++++++--
>  arch/arm64/kvm/sys_regs.h                     |  16 +
>  include/kvm/arm_pmu.h                         |  65 ++++
>  include/linux/kvm_host.h                      |   1 +
>  include/uapi/linux/kvm.h                      |   2 +
>  virt/kvm/arm/pmu.c                            | 414 ++++++++++++++++++++++
>  virt/kvm/kvm_main.c                           |   4 +
>  17 files changed, 1098 insertions(+), 70 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
>  create mode 100644 include/kvm/arm_pmu.h
>  create mode 100644 virt/kvm/arm/pmu.c
> 
> -- 
> 2.1.4
> 
