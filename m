Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F55C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 09:45:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCB1E4B1B6;
	Wed, 27 Apr 2022 05:45:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WmZaWrUYTTnU; Wed, 27 Apr 2022 05:45:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 054F14B1D7;
	Wed, 27 Apr 2022 05:45:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59FEA4B1B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 05:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kJ7P0KqDnRux for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 05:45:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6541C49F26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 05:45:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC74B1480;
 Wed, 27 Apr 2022 02:45:39 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 996F53F5A1;
 Wed, 27 Apr 2022 02:45:38 -0700 (PDT)
Date: Wed, 27 Apr 2022 10:45:39 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM/arm64: Don't emulate a PMU for 32-bit guests if
 feature not set
Message-ID: <YmkQw8UGFOTFlI1q@monolith.localdoman>
References: <20220425145530.723858-1-alexandru.elisei@arm.com>
 <Yment8uGahyB+wgK@google.com>
 <Yme02Tw3WdbXBAR1@monolith.localdoman>
 <CAOQ_Qsj47JkEn-sOhKCAKyZnetsKqpWvBALnfAzyMfMy=eqOHg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ_Qsj47JkEn-sOhKCAKyZnetsKqpWvBALnfAzyMfMy=eqOHg@mail.gmail.com>
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On Wed, Apr 27, 2022 at 12:57:57AM -0700, Oliver Upton wrote:
> Hi Alex,
> 
> On Tue, Apr 26, 2022 at 2:01 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> > > > The odroid-c4 is somewhat of a special case, because Linux doesn't probe
> > > > the PMU. But the above errors can easily be reproduced on any hardware,
> > > > with or without a PMU driver, as long as userspace doesn't set the PMU
> > > > feature.
> > >
> > > This note has me wondering if we could do more negative testing with
> > > kvm-unit-tests just by selectively turning on/off features, with the
> > > expectation that tests either skip or pass.
> >
> > I'm not sure that that can be accomplished right now. kvm-unit-tests
> > supports only qemu as an automated test runner, and qemu enables the PMU by
> > default. I don't know if it can be disabled, it would be nice if it could.
> > I stumbled upon this by mistake, when I ran kvmtool without enabling the
> > PMU (the default in kvmtool is to not have it enabled).
> >
> > If it is possible to disable PMU emulation from the qemu's command line,
> > then it should be as simple as writing a test that expects all PMU register
> > accesses to trigger an undefined exception (and adding a new test
> > definition).
> 
> You can disable the PMU with QEMU by specifying pmu=off in the -cpu
> argument, among other things.

Thanks, didn't know that. I'll keep that in mind for testing.

> 
> > If it is not possible to do this with qemu, then we would have to wait
> > until kvm-unit-tests can use kvmtool as the test runner. I have an RFC sent
> > for that [1], I need to get back to it.
> >
> > Another option would be to have this as a kselftest, although I don't know
> > how easy it is to register an exception handler in a kselftest. The test
> > could be further expanded to other registers gated by a VCPU feature being
> > set.
> 
> We definitely have the plumbing for exception handlers in selftests,
> aarch64/debug-exceptions.c is an example. My thought was more general
> + rather lazy. For any combination of CPU features, expect that
> kvm-unit-tests should either pass or skip. If they fail or blow up the
> host then probably a good indicator of a KVM bug.
> 
> > [1] https://lore.kernel.org/kvmarm/20210702163122.96110-1-alexandru.elisei@arm.com/
> 
> Thanks for the link, I'll have a peek.

Please keep in mind that while it works, it still needs significant changes
before it is merged.

> 
> > >
> > > > Work around the fact that KVM advertises a PMU even when the VCPU feature
> > > > is not set by gating all PMU emulation on the feature. The guest can still
> > > > access the registers without KVM injecting an undefined exception.
> > >
> > > We're going to need something similar even after KVM conditionally
> > > advertises the PMU.
> > >
> > > WDYT about wiring up sys_reg_desc::visibility for the AArch32 PMU
> > > registers? For now just treat them as REG_RAZ (probably extend this to
> > > imply WI too) then promote to REG_HIDDEN in a later patch.
> >
> > I was thinking you can simply use .visibility = pmu_visibility, like it's
> > done with the PMU_SYS_REG macro:
> 
> Right -- I completely agree this is where we should be when AArch32
> feature registers are trapped.
> 
> Seems to me all the AArch32 feature register trap logic should come
> later on as there's a nonzero chance I introduced a bug :) Shall we
> stop the bleeding w/ your originally proposed patch? Doesn't seem any
> more objectionable than what we're already doing.

I am leaning towards merging this patch to prevent people from seeing the
splat, and when the AArch32 ID reg series gets merged it can be reverted.
But in the end it's up to Marc to decide what he prefers.

> 
> [...]
> 
> > I've renamed AA32_ZEROHIGH -> AA32_DIRECT. Feel free to use the snippet as
> > you see fit (or not at all).
> 
> To avoid shamelessly plagiarizing: may I package up what you have
> below as a commit coming from you?

Sure, no problem. Here's the patch, it's earlier attempt to fix NULL
pointer dereference, feel free to change change it as you see fit:

    KVM/arm64: Hide AArch32 PMU registers when not available

    Commit 11663111cd49 ("KVM: arm64: Hide PMU registers from userspace when
    not available") hid the AArch64 PMU registers from userspace and guest
    when the PMU VCPU feature was not set. Do the same when the PMU
    registers are accessed by an AArch32 guest.

    This also fixes this nasty splat which was observed on an odroid-c4, by
    running the kvm-unit-tests' pmu-cycle-counter test with kvmtool without
    an emulated PMU:

    [   44.993727] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000150
    [   44.996897] Mem abort info:
    [   44.999654]   ESR = 0x96000004
    [   45.002696]   EC = 0x25: DABT (current EL), IL = 32 bits
    [   45.007944]   SET = 0, FnV = 0
    [   45.010956]   EA = 0, S1PTW = 0
    [   45.014056]   FSC = 0x04: level 0 translation fault
    [   45.018886] Data abort info:
    [   45.021722]   ISV = 0, ISS = 0x00000004
    [   45.025532]   CM = 0, WnR = 0
    [   45.028463] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000004909000
    [   45.034844] [0000000000000150] pgd=0000000000000000, p4d=0000000000000000
    [   45.041574] Internal error: Oops: 96000004 [#1] PREEMPT SMP
    [   45.047068] Modules linked in:
    [   45.050086] CPU: 0 PID: 259 Comm: kvm-vcpu-0 Not tainted 5.18.0-rc3-00001-g5c5591319a5e #107
    [   45.058455] Hardware name: Hardkernel ODROID-C4 (DT)
    [   45.063369] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
    [   45.070269] pc : kvm_pmu_event_mask.isra.0+0x14/0x74
    [   45.075184] lr : kvm_pmu_set_counter_event_type+0x2c/0x80
    [   45.080532] sp : ffff80000aa839c0
    [   45.083807] x29: ffff80000aa839c0 x28: ffff000001ce5580 x27: 0000000000000000
    [   45.090882] x26: 0000000000000000 x25: 0000000000000000 x24: ffff00000d608000
    [   45.097955] x23: ffff000001ce5580 x22: ffff00000d5e4000 x21: 0000000000000000
    [   45.105027] x20: 000000000000001f x19: 00000000000003ff x18: 0000000000000000
    [   45.112100] x17: 000000008003fe98 x16: 0000000000000000 x15: 0000000000000000
    [   45.119172] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
    [   45.126245] x11: 000000008003fdbc x10: 0000000000009d20 x9 : 000000000000001b
    [   45.133318] x8 : 0000000000000000 x7 : 0000000000000d00 x6 : 0000000000009d00
    [   45.140390] x5 : 0000000000000037 x4 : 0000000000009d00 x3 : 0d09000000000000
    [   45.147463] x2 : 000000000000001f x1 : 0000000000000000 x0 : 0000000000000000
    [   45.154535] Call trace:
    [   45.156947]  kvm_pmu_event_mask.isra.0+0x14/0x74
    [   45.161521]  kvm_pmu_set_counter_event_type+0x2c/0x80
    [   45.166522]  access_pmu_evtyper+0x128/0x170
    [   45.170662]  perform_access+0x34/0x80
    [   45.174284]  kvm_handle_cp_32+0x13c/0x160
    [   45.178252]  kvm_handle_cp15_32+0x1c/0x30
    [   45.182219]  handle_exit+0x70/0x180
    [   45.185669]  kvm_arch_vcpu_ioctl_run+0x1c4/0x5e0
    [   45.190241]  kvm_vcpu_ioctl+0x23c/0x940
    [   45.194036]  __arm64_sys_ioctl+0xa8/0xf0
    [   45.197917]  invoke_syscall+0x48/0x114
    [   45.201626]  el0_svc_common.constprop.0+0xd4/0xfc
    [   45.206284]  do_el0_svc+0x28/0x90
    [   45.209560]  el0_svc+0x34/0xb0
    [   45.212579]  el0t_64_sync_handler+0xa4/0x130
    [   45.216806]  el0t_64_sync+0x18c/0x190
    [   45.220432] Code: a9be7bfd 910003fd f9000bf3 52807ff3 (b9415001)
    [   45.226469] ---[ end trace 0000000000000000 ]---

    This is caused by the fact the kvm->arch.arm_pmu is NULL when the VCPU
    feature is not set and kvm_pmu_event_mask() tries to dereference the NULL
    pointer to get at pmuver.

    Now that KVM emulates ID_DFR0 and hides the PMU from the guest when the
    feature is not set, it is safe to inject to inject an undefined exception
    when the PMU is not present, as that corresponds to the architected
    behaviour.

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..b0db275f41c5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2014,19 +2014,22 @@ static const struct sys_reg_desc cp14_64_regs[] = {
        { Op1( 0), CRm( 2), .access = trap_raz_wi },
 };

+#define CP15_PMU_SYS_REG(_map, _Op1, _CRn, _CRm, _Op2)                 \
+       AA32(_map),                                                     \
+       Op1(_Op1), CRn(_CRn), CRm(_CRm), Op2(_Op2),                     \
+       .visibility = pmu_visibility
+
 /* Macro to expand the PMEVCNTRn register */
 #define PMU_PMEVCNTR(n)                                                        \
-       /* PMEVCNTRn */                                                 \
-       { Op1(0), CRn(0b1110),                                          \
-         CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),         \
-         access_pmu_evcntr }
+       { CP15_PMU_SYS_REG(DIRECT, 0, 0b1110,                           \
+         (0b1000 | (((n) >> 3) & 0x3)), ((n) & 0x7)),                  \
+         .access = access_pmu_evcntr }

 /* Macro to expand the PMEVTYPERn register */
 #define PMU_PMEVTYPER(n)                                               \
-       /* PMEVTYPERn */                                                \
-       { Op1(0), CRn(0b1110),                                          \
-         CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),         \
-         access_pmu_evtyper }
+       { CP15_PMU_SYS_REG(DIRECT, 0, 0b1110,                           \
+         (0b1100 | (((n) >> 3) & 0x3)), ((n) & 0x7)),                  \
+         .access = access_pmu_evtyper }

 /*
  * Trapped cp15 registers. TTBR0/TTBR1 get a double encoding,
@@ -2067,25 +2070,25 @@ static const struct sys_reg_desc cp15_regs[] = {
        { Op1( 0), CRn( 7), CRm(14), Op2( 2), access_dcsw },

        /* PMU */
-       { Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
-       { Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcnten },
-       { Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcnten },
-       { Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
-       { Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmswinc },
-       { Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
-       { AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
-       { AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
-       { Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
-       { Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
-       { Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
-       { Op1( 0), CRn( 9), CRm(14), Op2( 0), access_pmuserenr },
-       { Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
-       { Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
-       { Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
-       { AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 4), access_pmceid },
-       { AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 5), access_pmceid },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 0), .access = access_pmcr },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 1), .access = access_pmcnten },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 2), .access = access_pmcnten },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 3), .access = access_pmovs },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 4), .access = access_pmswinc },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 5), .access = access_pmselr },
+       { CP15_PMU_SYS_REG(LO,     0, 9, 12, 6), .access = access_pmceid },
+       { CP15_PMU_SYS_REG(LO,     0, 9, 12, 7), .access = access_pmceid },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 13, 0), .access = access_pmu_evcntr },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 13, 1), .access = access_pmu_evtyper },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 13, 2), .access = access_pmu_evcntr },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 0), .access = access_pmuserenr },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 1), .access = access_pminten },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 2), .access = access_pminten },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 3), .access = access_pmovs },
+       { CP15_PMU_SYS_REG(HI,     0, 9, 14, 4), .access = access_pmceid },
+       { CP15_PMU_SYS_REG(HI,     0, 9, 14, 5), .access = access_pmceid },
        /* PMMIR */
-       { Op1( 0), CRn( 9), CRm(14), Op2( 6), trap_raz_wi },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 6), .access = trap_raz_wi },

        /* PRRR/MAIR0 */
        { AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },
@@ -2170,7 +2173,7 @@ static const struct sys_reg_desc cp15_regs[] = {
        PMU_PMEVTYPER(29),
        PMU_PMEVTYPER(30),
        /* PMCCFILTR */
-       { Op1(0), CRn(14), CRm(15), Op2(7), access_pmu_evtyper },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 14, 15, 7), .access = access_pmu_evtyper },

        { Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
        { Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
@@ -2179,7 +2182,7 @@ static const struct sys_reg_desc cp15_regs[] = {

 static const struct sys_reg_desc cp15_64_regs[] = {
        { Op1( 0), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR0_EL1 },
-       { Op1( 0), CRn( 0), CRm( 9), Op2( 0), access_pmu_evcntr },
+       { CP15_PMU_SYS_REG(DIRECT, 0, 0, 9, 0), .access = access_pmu_evcntr },
        { Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI1R */
        { Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
        { Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
