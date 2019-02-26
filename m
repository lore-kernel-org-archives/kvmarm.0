From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 14/26] KVM: arm64/sve: Context switch the SVE registers
Date: Tue, 26 Feb 2019 12:13:12 +0000
Message-ID: <20190226121312.GP3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-15-git-send-email-Dave.Martin@arm.com>
 <20190220161917.GG4763@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFFA14A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:13:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U3WyQA3Tgn-J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:13:17 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C9649E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:13:17 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190220161917.GG4763@lakrids.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 20, 2019 at 04:19:18PM +0000, Mark Rutland wrote:
> On Mon, Feb 18, 2019 at 07:52:27PM +0000, Dave Martin wrote:
> > -static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> > +/* Check for an FPSIMD/SVE trap and handle as appropriate */
> > +static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
> >  {
> > -	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
> > +	bool vhe, sve_guest, sve_host;
> > +	u8 trap_class;
> 
> Nit: elsewhere in kvm, this gets called hsr_ec. Can we use the same name
> here?

Done.

(This name is not used in hyp/switch.c yet, and I was sort of trying to
conform to the naming of kvm_vcpu_trap_get_class().  But hsr_ec is used
elsewhere, and more self-describing, so it makes sense.)

> 
> >  
> > -	if (has_vhe())
> > -		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
> > -			     cpacr_el1);
> > -	else
> > +	if (!system_supports_fpsimd())
> > +		return false;
> > +
> > +	if (system_supports_sve()) {
> > +		sve_guest = vcpu_has_sve(vcpu);
> > +		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
> > +		vhe = true;
> > +	} else {
> > +		sve_guest = false;
> > +		sve_host = false;
> > +		vhe = has_vhe();
> > +	}
> > +
> > +	trap_class = kvm_vcpu_trap_get_class(vcpu);
> > +	if (trap_class != ESR_ELx_EC_FP_ASIMD &&
> > +	    (!sve_guest || trap_class != ESR_ELx_EC_SVE))
> > +		return false;
> 
> This is somewhat painful to decipher, but I couldn't come up with
> something that was both succint and legible.
> 
> Maybe it's worth duplicating the SVE check, i.e.
> 
> 	if (hsr_ec != ESR_ELx_EC_FP_ASIMD &&
> 	    hsr_ec != ESR_ELx_EC_SVE)
> 		return false;
> 
> 	if (!sve_guest && hsr_ec == ESR_ELx_EC_SVE)
> 		return false;
> 
> ... ?

There were previously some static_key checks in here that I didn't want
to duplicate, which is part of the reason for trying to merge related
if-conditions together explicitly.

This is no longer relevant now that the static_key checks have been
hoisted out explicitly.  Something along the lines of your version
would definitely be clearer.  gcc also seems to merge the conditions
competently, so I'll pick up your suggestion for now.

Thanks
---Dave
