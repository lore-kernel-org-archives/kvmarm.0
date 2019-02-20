From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 14/26] KVM: arm64/sve: Context switch the SVE registers
Date: Wed, 20 Feb 2019 16:19:18 +0000
Message-ID: <20190220161917.GG4763@lakrids.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-15-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1550519559-15915-15-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 18, 2019 at 07:52:27PM +0000, Dave Martin wrote:
> -static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> +/* Check for an FPSIMD/SVE trap and handle as appropriate */
> +static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  {
> -	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
> +	bool vhe, sve_guest, sve_host;
> +	u8 trap_class;

Nit: elsewhere in kvm, this gets called hsr_ec. Can we use the same name
here?

>  
> -	if (has_vhe())
> -		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
> -			     cpacr_el1);
> -	else
> +	if (!system_supports_fpsimd())
> +		return false;
> +
> +	if (system_supports_sve()) {
> +		sve_guest = vcpu_has_sve(vcpu);
> +		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
> +		vhe = true;
> +	} else {
> +		sve_guest = false;
> +		sve_host = false;
> +		vhe = has_vhe();
> +	}
> +
> +	trap_class = kvm_vcpu_trap_get_class(vcpu);
> +	if (trap_class != ESR_ELx_EC_FP_ASIMD &&
> +	    (!sve_guest || trap_class != ESR_ELx_EC_SVE))
> +		return false;

This is somewhat painful to decipher, but I couldn't come up with
something that was both succint and legible.

Maybe it's worth duplicating the SVE check, i.e.

	if (hsr_ec != ESR_ELx_EC_FP_ASIMD &&
	    hsr_ec != ESR_ELx_EC_SVE)
		return false;

	if (!sve_guest && hsr_ec == ESR_ELx_EC_SVE)
		return false;

... ?

Thanks,
Mark.
