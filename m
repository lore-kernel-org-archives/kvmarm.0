From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 24/38] KVM: arm64: Respect virtual HCR_EL2.TWX
 setting
Date: Sun, 30 Jul 2017 22:00:25 +0200
Message-ID: <20170730200025.GM5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-25-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500397144-16232-25-git-send-email-jintack.lim@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:50AM -0500, Jintack Lim wrote:
> Forward exceptions due to WFI or WFE instructions to the virtual EL2 if
> they are not coming from the virtual EL2 and virtual HCR_EL2.TWX is set.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/handle_exit.c      | 13 ++++++++++++-
>  arch/arm64/kvm/nested.c           | 20 ++++++++++++++++++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 46880c3..53b0b33 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -442,5 +442,6 @@ static inline void __cpu_init_stage2(void)
>  int __init kvmarm_nested_cfg(char *buf);
>  int init_nested_virt(void);
>  bool nested_virt_in_use(struct kvm_vcpu *vcpu);
> +int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>  
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 8b398b2..25ec824 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -107,7 +107,18 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
>   */
>  static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
> +	bool is_wfe = !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE);
> +
> +	if (nested_virt_in_use(vcpu)) {
> +		int ret = handle_wfx_nested(vcpu, is_wfe);
> +
> +		if (ret < 0 && ret != -EINVAL)
> +			return ret;
> +		else if (ret >= 0)
> +			return ret;

This is very complicated and you're not documenting the return value of
handle_wfx_nested.

If you get rid of the defensive statement in kvm_inject_nested, you can
turn that one into a void, and handle_wfx_nested can become a bool, and
then this becomes:

		if (ret)
			return 1;

If for some reason you don't like that, you can still just do:

		if (ret == 1)
			return 1;


> +	}
> +
> +	if (is_wfe) {
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
>  		vcpu->stat.wfe_exit_stat++;
>  		kvm_vcpu_on_spin(vcpu);
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 9a05c76..042d304 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -18,6 +18,8 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  
> +#include <asm/kvm_emulate.h>
> +
>  static bool nested_param;
>  
>  int __init kvmarm_nested_cfg(char *buf)
> @@ -41,3 +43,21 @@ bool nested_virt_in_use(struct kvm_vcpu *vcpu)
>  
>  	return false;
>  }
> +
> +/*
> + * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
> + * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
> + * handle this.
> + */
> +int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
> +{
> +	u64 hcr_el2 = vcpu_sys_reg(vcpu, HCR_EL2);
> +
> +	if (vcpu_mode_el2(vcpu))
> +		return -EINVAL;
> +
> +	if ((is_wfe && (hcr_el2 & HCR_TWE)) || (!is_wfe && (hcr_el2 & HCR_TWI)))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
> +	return -EINVAL;
> +}
> -- 
> 1.9.1
> 
