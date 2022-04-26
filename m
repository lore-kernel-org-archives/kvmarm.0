Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B03BC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 09:01:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7B894B1F3;
	Tue, 26 Apr 2022 05:01:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nn0DL7J5Vh2r; Tue, 26 Apr 2022 05:01:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21DE24B1C9;
	Tue, 26 Apr 2022 05:01:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D20B94B156
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:01:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9D+wY++H18Ao for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 05:01:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2709649EF3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:01:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 975DC23A;
 Tue, 26 Apr 2022 02:01:13 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74CD33F73B;
 Tue, 26 Apr 2022 02:01:12 -0700 (PDT)
Date: Tue, 26 Apr 2022 10:01:13 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM/arm64: Don't emulate a PMU for 32-bit guests if
 feature not set
Message-ID: <Yme02Tw3WdbXBAR1@monolith.localdoman>
References: <20220425145530.723858-1-alexandru.elisei@arm.com>
 <Yment8uGahyB+wgK@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yment8uGahyB+wgK@google.com>
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

On Tue, Apr 26, 2022 at 08:05:11AM +0000, Oliver Upton wrote:
> Hi Alex,
> 
> On Mon, Apr 25, 2022 at 03:55:30PM +0100, Alexandru Elisei wrote:
> 
> [...]
> 
> > The root cause remains the same: kvm->arch.pmuver was never set to
> > something sensible because the VCPU feature itself was never set.
> > 
> > The odroid-c4 is somewhat of a special case, because Linux doesn't probe
> > the PMU. But the above errors can easily be reproduced on any hardware,
> > with or without a PMU driver, as long as userspace doesn't set the PMU
> > feature.
> 
> This note has me wondering if we could do more negative testing with
> kvm-unit-tests just by selectively turning on/off features, with the
> expectation that tests either skip or pass.

I'm not sure that that can be accomplished right now. kvm-unit-tests
supports only qemu as an automated test runner, and qemu enables the PMU by
default. I don't know if it can be disabled, it would be nice if it could.
I stumbled upon this by mistake, when I ran kvmtool without enabling the
PMU (the default in kvmtool is to not have it enabled).

If it is possible to disable PMU emulation from the qemu's command line,
then it should be as simple as writing a test that expects all PMU register
accesses to trigger an undefined exception (and adding a new test
definition).

If it is not possible to do this with qemu, then we would have to wait
until kvm-unit-tests can use kvmtool as the test runner. I have an RFC sent
for that [1], I need to get back to it.

Another option would be to have this as a kselftest, although I don't know
how easy it is to register an exception handler in a kselftest. The test
could be further expanded to other registers gated by a VCPU feature being
set.

[1] https://lore.kernel.org/kvmarm/20210702163122.96110-1-alexandru.elisei@arm.com/

> 
> > Work around the fact that KVM advertises a PMU even when the VCPU feature
> > is not set by gating all PMU emulation on the feature. The guest can still
> > access the registers without KVM injecting an undefined exception.
> 
> We're going to need something similar even after KVM conditionally
> advertises the PMU.
> 
> WDYT about wiring up sys_reg_desc::visibility for the AArch32 PMU
> registers? For now just treat them as REG_RAZ (probably extend this to
> imply WI too) then promote to REG_HIDDEN in a later patch.

I was thinking you can simply use .visibility = pmu_visibility, like it's
done with the PMU_SYS_REG macro:

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

I've renamed AA32_ZEROHIGH -> AA32_DIRECT. Feel free to use the snippet as
you see fit (or not at all).

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
