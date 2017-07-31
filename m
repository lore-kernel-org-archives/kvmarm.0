From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 35/38] KVM: arm64: Respect the virtual HCR_EL2.NV
 bit setting for EL12 register traps
Date: Mon, 31 Jul 2017 14:39:01 +0200
Message-ID: <20170731123901.GU5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-36-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500397144-16232-36-git-send-email-jintack.lim@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:59:01AM -0500, Jintack Lim wrote:
> In addition to EL2 register accesses, setting NV bit will also make EL12
> register accesses trap to EL2. To emulate this for the virtual EL2,
> forword traps due to EL12 register accessses to the virtual EL2 if the
> virtual HCR_EL2.NV bit is set.
> 
> This is for recursive nested virtualization.

> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4fd7090..3559cf7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -149,6 +149,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	int i;
>  	const struct el1_el2_map *map;
>  
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>  	/*
>  	 * Redirect EL1 register accesses to the corresponding EL2 registers if
>  	 * they are meant to access EL2 registers.
> @@ -959,6 +962,9 @@ static bool access_cntkctl_el12(struct kvm_vcpu *vcpu,
>  			 struct sys_reg_params *p,
>  			 const struct sys_reg_desc *r)
>  {
> +	if (forward_nv_traps(vcpu))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>  	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
>  	return true;
>  }
> @@ -1005,6 +1011,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>  	access_rw(p, &vcpu->arch.ctxt.gp_regs.elr_el1);
>  	return true;
>  }
> @@ -1013,6 +1022,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>  	access_rw(p, &vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1]);
>  	return true;
>  }
> @@ -1021,6 +1033,9 @@ static bool access_vbar(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>  	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
>  	return true;
>  }
> @@ -1031,6 +1046,9 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
>  {
>  	u64 reg = sys_reg(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
>  
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>  	/*
>  	 * When the virtual HCR_EL2.E2H == 1, an access to CPACR_EL1
>  	 * in the virtual EL2 is to access CPTR_EL2.
> -- 
> 1.9.1
> 

I'm wondering instead of having all these handlers, could we add this at
a higher level, like kvm_handle_sys() instead?

Thanks,
-Christoffer
