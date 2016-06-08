From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: fix build with CONFIG_ARM_PMU disabled
Date: Wed, 8 Jun 2016 11:48:13 +0100
Message-ID: <5757F7ED.9060308@arm.com>
References: <1465382335-5024-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB5DD49D66
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2016 06:44:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tSL6Ms-BBQHw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2016 06:44:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A979F49D65
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2016 06:44:01 -0400 (EDT)
In-Reply-To: <1465382335-5024-1-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/06/16 11:38, Sudeep Holla wrote:
> When CONFIG_ARM_PMU is disabled, we get the following build error:
> 
> arch/arm64/kvm/sys_regs.c: In function 'pmu_counter_idx_valid':
> arch/arm64/kvm/sys_regs.c:564:27: error: 'ARMV8_PMU_CYCLE_IDX' undeclared (first use in this function)
>   if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX)
>                            ^
> arch/arm64/kvm/sys_regs.c:564:27: note: each undeclared identifier is reported only once for each function it appears in
> arch/arm64/kvm/sys_regs.c: In function 'access_pmu_evcntr':
> arch/arm64/kvm/sys_regs.c:592:10: error: 'ARMV8_PMU_CYCLE_IDX' undeclared (first use in this function)
>     idx = ARMV8_PMU_CYCLE_IDX;
>           ^
> arch/arm64/kvm/sys_regs.c: In function 'access_pmu_evtyper':
> arch/arm64/kvm/sys_regs.c:638:14: error: 'ARMV8_PMU_CYCLE_IDX' undeclared (first use in this function)
>    if (idx == ARMV8_PMU_CYCLE_IDX)
>               ^
> arch/arm64/kvm/hyp/switch.c:86:15: error: 'ARMV8_PMU_USERENR_MASK' undeclared (first use in this function)
>   write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> 
> This patch fixes the build with CONFIG_ARM_PMU disabled.
> 
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
