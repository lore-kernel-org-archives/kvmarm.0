From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 17/21] arm64: KVM: VHE: Add alternative panic handling
Date: Mon, 1 Feb 2016 15:26:20 +0100
Message-ID: <20160201142620.GW1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-18-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453737235-16522-18-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 03:53:51PM +0000, Marc Zyngier wrote:
> As the kernel fully runs in HYP when VHE is enabled, we can
> directly branch to the kernel's panic() implementation, and
> not perform an exception return.
> 
> Add the alternative code to deal with this.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm64/kvm/hyp/switch.c | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 77f7c94..0cadb7f 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -211,11 +211,34 @@ __alias(__guest_run) int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
>  static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
>  
> -void __hyp_text __noreturn __hyp_panic(void)
> +static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par)
>  {
>  	unsigned long str_va = (unsigned long)__hyp_panic_string;
> -	u64 spsr = read_sysreg(spsr_el2);
> -	u64 elr = read_sysreg(elr_el2);
> +
> +	__hyp_do_panic(hyp_kern_va(str_va),
> +		       spsr,  elr,
> +		       read_sysreg(esr_el2),   read_sysreg_el2(far),
> +		       read_sysreg(hpfar_el2), par,
> +		       (void *)read_sysreg(tpidr_el2));
> +}
> +
> +static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par)
> +{
> +	panic(__hyp_panic_string,
> +	      spsr,  elr,
> +	      read_sysreg_el2(esr),   read_sysreg_el2(far),
> +	      read_sysreg(hpfar_el2), par,
> +	      (void *)read_sysreg(tpidr_el2));
> +}
> +
> +static hyp_alternate_select(__hyp_call_panic,
> +			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
> +			    ARM64_HAS_VIRT_HOST_EXTN);
> +
> +void __hyp_text __noreturn __hyp_panic(void)
> +{
> +	u64 spsr = read_sysreg_el2(spsr);
> +	u64 elr = read_sysreg_el2(elr);
>  	u64 par = read_sysreg(par_el1);
>  
>  	if (read_sysreg(vttbr_el2)) {
> @@ -230,11 +253,7 @@ void __hyp_text __noreturn __hyp_panic(void)
>  	}
>  
>  	/* Call panic for real */
> -	__hyp_do_panic(hyp_kern_va(str_va),
> -		       spsr,  elr,
> -		       read_sysreg(esr_el2),   read_sysreg(far_el2),
> -		       read_sysreg(hpfar_el2), par,
> -		       (void *)read_sysreg(tpidr_el2));
> +	__hyp_call_panic()(spsr, elr, par);
>  
>  	unreachable();
>  }
> -- 
> 2.1.4
> 
