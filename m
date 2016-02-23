From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v12 03/21] KVM: ARM64: Add offset defines for PMU registers
Date: Tue, 23 Feb 2016 17:29:01 +0800
Message-ID: <56CC265D.9000406@linaro.org>
References: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
 <1456133877-9584-4-git-send-email-zhaoshenglong@huawei.com>
 <56CB4A98.2020403@arm.com> <56CBBA06.4040902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 445C34852E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 04:22:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fbP-OUOI3eE3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2016 04:22:30 -0500 (EST)
Received: from mail-pf0-f176.google.com (mail-pf0-f176.google.com
 [209.85.192.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1635748529
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 04:22:29 -0500 (EST)
Received: by mail-pf0-f176.google.com with SMTP id x65so109292626pfb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2016 01:29:09 -0800 (PST)
In-Reply-To: <56CBBA06.4040902@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/23 9:46, Shannon Zhao wrote:
> 
> On 2016/2/23 1:51, Marc Zyngier wrote:
>> > On 22/02/16 09:37, Shannon Zhao wrote:
>>> >> From: Shannon Zhao <shannon.zhao@linaro.org>
>>> >>
>>> >> We are about to trap and emulate accesses to each PMU register
>>> >> individually. This adds the context offsets for the AArch64 PMU
>>> >> registers.
>>> >>
>>> >> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>> >> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>>> >> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>> >> ---
>>> >>  arch/arm64/include/asm/kvm_host.h | 15 +++++++++++++++
>>> >>  1 file changed, 15 insertions(+)
>>> >>
>>> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> >> index 6f0241f..6bab7fb 100644
>>> >> --- a/arch/arm64/include/asm/kvm_host.h
>>> >> +++ b/arch/arm64/include/asm/kvm_host.h
>>> >> @@ -115,6 +115,21 @@ enum vcpu_sysreg {
>>> >>  	MDSCR_EL1,	/* Monitor Debug System Control Register */
>>> >>  	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>>> >>  
>>> >> +	/* Performance Monitors Registers */
>>> >> +	PMCR_EL0,	/* Control Register */
>>> >> +	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
>>> >> +	PMSELR_EL0,	/* Event Counter Selection Register */
>>> >> +	PMEVCNTR0_EL0,	/* Event Counter Register (0-30) */
>>> >> +	PMEVCNTR30_EL0 = PMEVCNTR0_EL0 + 30,
>>> >> +	PMCCNTR_EL0,	/* Cycle Counter Register */
>>> >> +	PMEVTYPER0_EL0,	/* Event Type Register (0-30) */
>>> >> +	PMEVTYPER30_EL0 = PMEVTYPER0_EL0 + 30,
>>> >> +	PMCCFILTR_EL0,	/* Cycle Count Filter Register */
>>> >> +	PMCNTENSET_EL0,	/* Count Enable Set Register */
>>> >> +	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
>>> >> +	PMUSERENR_EL0,	/* User Enable Register */
>>> >> +	PMSWINC_EL0,	/* Software Increment Register */
>>> >> +
>> > 
>> > I've just noticed a rather fundamental issue with this: this makes it
>> > impossible to bisect the whole series.
>> > 
> Ah, sorry. Will fix this.
> 
I've fixed this problem and pushed this series to below place. You can
fetch it from there.

https://git.linaro.org/people/shannon.zhao/linux-mainline.git/shortlog/refs/heads/KVM_ARM64_PMU_v13

Thanks,
-- 
Shannon
