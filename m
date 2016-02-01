From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 16/21] arm64: KVM: VHE: Add fpsimd enabling on guest
 access
Date: Mon, 1 Feb 2016 15:24:18 +0100
Message-ID: <20160201142418.GV1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-17-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453737235-16522-17-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 03:53:50PM +0000, Marc Zyngier wrote:
> Despite the fact that a VHE enabled kernel runs at EL2, it uses
> CPACR_EL1 to trap FPSIMD access. Add the required alternative
> code to re-enable guest FPSIMD access when it has trapped to
> EL2.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/entry.S | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index fd0fbe9..759a0ec 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -130,9 +130,15 @@ ENDPROC(__guest_exit)
>  ENTRY(__fpsimd_guest_restore)
>  	stp	x4, lr, [sp, #-16]!
>  
> +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>  	mrs	x2, cptr_el2
>  	bic	x2, x2, #CPTR_EL2_TFP
>  	msr	cptr_el2, x2
> +alternative_else
> +	mrs	x2, cpacr_el1
> +	orr	x2, x2, #(3 << 20)

nit: bitfield definition again

> +	msr	cpacr_el1, x2
> +alternative_endif
>  	isb
>  
>  	mrs	x3, tpidr_el2
> -- 
> 2.1.4
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
