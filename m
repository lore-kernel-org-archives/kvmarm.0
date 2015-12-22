From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH 1/2] arm: KVM: Do not update PC if the trap handler has
 updated it
Date: Tue, 22 Dec 2015 18:35:18 +0800
Message-ID: <56792766.8040707@linaro.org>
References: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com>
 <1450778118-12715-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C14DE412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 05:32:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jc4uXU2qYcrn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 05:32:45 -0500 (EST)
Received: from mail-pf0-f181.google.com (mail-pf0-f181.google.com
 [209.85.192.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D411410B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 05:32:45 -0500 (EST)
Received: by mail-pf0-f181.google.com with SMTP id n128so88015180pfn.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 02:35:28 -0800 (PST)
In-Reply-To: <1450778118-12715-2-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/22 17:55, Marc Zyngier wrote:
> Assuming we trap a coprocessor access, and decide that the access
> is illegal, we will inject an exception in the guest. In this
> case, we shouldn't increment the PC, or the vcpu will miss the
> first instruction of the handler, leading to a mildly confused
> guest.
> 
> Solve this by snapshoting PC before the access is performed,
> and checking if it has moved or not before incrementing it.
> 
> Reported-by: Shannon Zhao <shannon.zhao@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm/kvm/coproc.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index f3d88dc..f4ad2f2 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -447,12 +447,22 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
>  		r = find_reg(params, cp15_regs, ARRAY_SIZE(cp15_regs));
>  
>  	if (likely(r)) {
> +		unsigned long pc = *vcpu_pc(vcpu);
> +
>  		/* If we don't have an accessor, we should never get here! */
>  		BUG_ON(!r->access);
>  
>  		if (likely(r->access(vcpu, params, r))) {
> -			/* Skip instruction, since it was emulated */
> -			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +			/*
> +			 * Skip the instruction if it was emulated
> +			 * without PC having changed. This allows us
> +			 * to detect a fault being injected
> +			 * (incrementing the PC here would cause the
> +			 * vcpu to skip the first instruction of its
> +			 * fault handler).
> +			 */
> +			if (pc == *vcpu_pc(vcpu))
> +				kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
>  			return 1;
>  		}
>  		/* If access function fails, it should complain. */
> 

-- 
Shannon
