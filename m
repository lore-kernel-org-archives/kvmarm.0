From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 9/9] arm: KVM: Treat CP15 accessors returning false as
 successful
Date: Tue, 28 Mar 2017 14:46:14 +0200
Message-ID: <20170328124614.GI31156@cbox>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
 <20170327160345.12402-10-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F36340992
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:44:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IGi8PFV0okbK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 08:44:17 -0400 (EDT)
Received: from mail-wr0-f175.google.com (mail-wr0-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9034640C2D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:44:17 -0400 (EDT)
Received: by mail-wr0-f175.google.com with SMTP id w43so89162792wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 05:46:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170327160345.12402-10-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27, 2017 at 05:03:45PM +0100, Marc Zyngier wrote:
> Instead of considering that a CP15 accessor has failed when
> returning false, let's consider that it is *always* successful
> (after all, we won't stand for an incomplete emulation).
> 
> The return value now simply indicates whether we should skip
> the instruction (because it has now been emulated), or if we
> should leave the PC alone if the emulation has injected an
> exception.
> 

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/coproc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 519aac12b365..2c14b69511e9 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -520,15 +520,15 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
>  		if (likely(r->access(vcpu, params, r))) {
>  			/* Skip instruction, since it was emulated */
>  			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> -			return 1;
>  		}
> -		/* If access function fails, it should complain. */
>  	} else {
> +		/* If access function fails, it should complain. */
>  		kvm_err("Unsupported guest CP15 access at: %08lx\n",
>  			*vcpu_pc(vcpu));
>  		print_cp_instr(params);
> +		kvm_inject_undefined(vcpu);
>  	}
> -	kvm_inject_undefined(vcpu);
> +
>  	return 1;
>  }
>  
> -- 
> 2.11.0
> 
