From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 20/40] KVM: arm/arm64: Remove leftover comment from
 kvm_vcpu_run_vhe
Date: Wed, 21 Feb 2018 18:47:31 +0100
Message-ID: <20180221174731.mrykgulbdjesyz4m@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-21-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 730C34070F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 12:41:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z3Vc9TquoV6x for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Feb 2018 12:40:58 -0500 (EST)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F01524047F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 12:40:57 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-21-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 15, 2018 at 10:03:12PM +0100, Christoffer Dall wrote:
> The comment only applied to SPE on non-VHE systems, so we simply remove
> it.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 717c8f5c6be7..a99224996e33 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -410,10 +410,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
>  	}
>  
> -	/*
> -	 * This must come after restoring the host sysregs, since a non-VHE
> -	 * system may enable SPE here and make use of the TTBRs.
> -	 */
>  	__debug_switch_to_host(vcpu);
>  
>  	return exit_code;
> -- 
> 2.14.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
