From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 12/21] arm64: KVM: VHE: Enable minimal sysreg
 save/restore
Date: Mon, 1 Feb 2016 15:02:13 +0100
Message-ID: <20160201140213.GR1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-13-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6044E40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 08:56:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XUO4MkjLszSv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 08:56:30 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C64940BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 08:56:29 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id l66so71693316wml.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2016 06:01:47 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1453737235-16522-13-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 03:53:46PM +0000, Marc Zyngier wrote:
> We're now in a position where we can introduce VHE's minimal
> save/restore, which is limited to the handful of shared sysregs.
> 
> Add the required alternative function calls that result in a
> "do nothing" call on VHE, and the normal save/restore for non-VHE.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/sysreg-sr.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 7d7d757..36bbdec 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -23,6 +23,9 @@
>  
>  #include "hyp.h"
>  
> +/* Yes, this does nothing, on purpose */
> +static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
> +
>  /*
>   * Non-VHE: Both host and guest must save everything.
>   *
> @@ -67,9 +70,13 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
>  	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
>  }
>  
> +static hyp_alternate_select(__sysreg_call_save_state,

__sysreg_call_save_host_state for symmetry with the restore path below?

> +			    __sysreg_save_state, __sysreg_do_nothing,
> +			    ARM64_HAS_VIRT_HOST_EXTN);
> +
>  void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
>  {
> -	__sysreg_save_state(ctxt);
> +	__sysreg_call_save_state()(ctxt);
>  	__sysreg_save_common_state(ctxt);
>  }
>  
> @@ -116,9 +123,13 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
>  }
>  
> +static hyp_alternate_select(__sysreg_call_restore_host_state,
> +			    __sysreg_restore_state, __sysreg_do_nothing,
> +			    ARM64_HAS_VIRT_HOST_EXTN);
> +
>  void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
>  {
> -	__sysreg_restore_state(ctxt);
> +	__sysreg_call_restore_host_state()(ctxt);
>  	__sysreg_restore_common_state(ctxt);
>  }
>  
> -- 
> 2.1.4
> 

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
