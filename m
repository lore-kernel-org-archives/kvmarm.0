From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 32/40] KVM: arm64: Directly call VHE and non-VHE
 FPSIMD enabled functions
Date: Thu, 22 Feb 2018 16:38:42 +0100
Message-ID: <20180222153842.mdqlaxnxizqfhfnq@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-33-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3530349F86
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 10:32:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q5pzVP7Fq1BZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Feb 2018 10:32:06 -0500 (EST)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 628BD49F88
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Feb 2018 10:32:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-33-christoffer.dall@linaro.org>
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

On Thu, Feb 15, 2018 at 10:03:24PM +0100, Christoffer Dall wrote:
> There is no longer a need for an alternative to choose the right
> function to tell us whether or not FPSIMD was enabled for the VM,
> because we can simply cann the appropriate functions directly fromwithin

s/cann/call/
s/fromwithin/from within/

> the _vhe and _nvhe run functions.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> 
> Notes:
>     Changes since v3:
>      - New patch since we no longer defer FPSIMD handling to load/put
> 
>  arch/arm64/kvm/hyp/switch.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 17e3c6f26a34..9c40e203bd09 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -33,20 +33,11 @@ static bool __hyp_text __fpsimd_enabled_nvhe(void)
>  	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
>  }
>  
> -static bool __hyp_text __fpsimd_enabled_vhe(void)
> +static bool fpsimd_enabled_vhe(void)
>  {
>  	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
>  }
>  
> -static hyp_alternate_select(__fpsimd_is_enabled,
> -			    __fpsimd_enabled_nvhe, __fpsimd_enabled_vhe,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> -
> -bool __hyp_text __fpsimd_enabled(void)
> -{
> -	return __fpsimd_is_enabled()();
> -}
> -
>  /* Save the 32-bit only FPSIMD system register state */
>  static inline void __hyp_text __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
>  {
> @@ -413,7 +404,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  		/* And we're baaack! */
>  	} while (fixup_guest_exit(vcpu, &exit_code));
>  
> -	fp_enabled = __fpsimd_enabled();
> +	fp_enabled = fpsimd_enabled_vhe();
>  
>  	sysreg_save_guest_state_vhe(guest_ctxt);
>  	__vgic_save_state(vcpu);
> @@ -478,7 +469,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  			__qcom_hyp_sanitize_btac_predictors();
>  	}
>  
> -	fp_enabled = __fpsimd_enabled();
> +	fp_enabled = __fpsimd_enabled_nvhe();
>  
>  	__sysreg_save_state_nvhe(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
> -- 
> 2.14.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
