From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: fix build with CONFIG_ARM_PMU disabled
Date: Mon, 27 Jun 2016 13:08:55 +0200
Message-ID: <20160627110855.GE26498@cbox>
References: <1465382335-5024-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 485274998D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 07:03:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dM70wnPxPMzl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 07:03:01 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BD7041AF6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 07:03:01 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id f126so95557807wma.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 04:08:09 -0700 (PDT)
Content-Disposition: inline
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
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 08, 2016 at 11:38:55AM +0100, Sudeep Holla wrote:
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

Applied, thanks.

-Christoffer
