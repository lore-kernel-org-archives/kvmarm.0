Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC7412D1E2
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824506; cv=none; b=LuT5q13kmSlDGx1HC1UC4omeSvxW7N7E7Btrrjoq2j2E6XyfiIp0sk+A4eaJmfJWH6dlKIRkpGN/PoW+7/3wGmoYd57qZfFj4K5KNxFcb0sz2rlWnSAdSO2KZRArRNIP5SFFX+Qw/+ejfVJ1+Cy5grBoZfc/33G1//30NnI3u/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824506; c=relaxed/simple;
	bh=g20Xpc6OyJvxtAVwhdWMbolXe263sghDZOnUASUTrdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWvGjGTPWePaWxhrh3wgDdV4M+6D/wUJ7eLZh2/8IH7vAG6PVyUMRkb4kpNjvBopUvX2E62IVr/mepNqJOcBAj/KUVFIiWy9rS4PQZrI7kPN5HfX5IMMn4rEfWYhssncU/D+eYGOD+kYUrqriv8N+NJQ03UdrPUj7N9aAjQfHxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 736EB1FB;
	Thu,  7 Mar 2024 07:15:38 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB0243F73F;
	Thu,  7 Mar 2024 07:14:59 -0800 (PST)
Date: Thu, 7 Mar 2024 15:14:54 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 08/13] KVM: arm64: nv: Handle HCR_EL2.{API,APK}
 independently
Message-ID: <20240307151454.GA913041@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226100601.2379693-9-maz@kernel.org>

On Mon, Feb 26, 2024 at 10:05:56AM +0000, Marc Zyngier wrote:
> Although KVM couples API and APK for simplicity, the architecture
> makes no such requirement, and the two can be independently set or
> cleared.
> 
> Check for which of the two possible reasons we have trapped here,
> and if the corresponding L1 control bit isn't set, delegate the
> handling for forwarding.
> 
> Otherwise, set this exact bit in HCR_EL2 and resume the guest.
> Of course, in the non-NV case, we keep setting both bits and
> be done with it. Note that the entry core already saves/restores
> the keys should any of the two control bits be set.
> 
> This results in a bit of rework, and the removal of the (trivial)
> vcpu_ptrauth_enable() helper.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h    |  5 ----
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++++++----
>  2 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index debc3753d2ef..d2177bc77844 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -125,11 +125,6 @@ static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hcr_el2 |= HCR_TWI;
>  }
>  
> -static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
> -{
> -	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
> -}
> -
>  static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index f5f701f309a9..a0908d7a8f56 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -480,11 +480,35 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	struct kvm_cpu_context *ctxt;
> -	u64 val;
> +	u64 enable = 0;
>  
>  	if (!vcpu_has_ptrauth(vcpu))
>  		return false;
>  
> +	/*
> +	 * NV requires us to handle API and APK independently, just in
> +	 * case the hypervisor is totally nuts. Please barf >here<.
> +	 */
> +	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +		switch (ESR_ELx_EC(kvm_vcpu_get_esr(vcpu))) {
> +		case ESR_ELx_EC_PAC:
> +			if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_API))
> +				return false;
> +
> +			enable |= HCR_API;
> +			break;
> +
> +		case ESR_ELx_EC_SYS64:
> +			if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_APK))
> +				return false;
> +
> +			enable |= HCR_APK;
> +			break;
> +		}
> +	} else {
> +		enable = HCR_API | HCR_APK;
> +	}
> +
>  	ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
>  	__ptrauth_save_key(ctxt, APIA);
>  	__ptrauth_save_key(ctxt, APIB);
> @@ -492,11 +516,9 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	__ptrauth_save_key(ctxt, APDB);
>  	__ptrauth_save_key(ctxt, APGA);
>  
> -	vcpu_ptrauth_enable(vcpu);
>  
> -	val = read_sysreg(hcr_el2);
> -	val |= (HCR_API | HCR_APK);
> -	write_sysreg(val, hcr_el2);
> +	vcpu->arch.hcr_el2 |= enable;
> +	sysreg_clear_set(hcr_el2, 0, enable);
>  
>  	return true;
>  }

A bit of sleuthing tells me you plan to delete kvm_hyp_handle_ptrauth() anyway,
so presumably it makes some sense to put that patch before this to avoid
modifying the code just to delete it!

Thanks,
Joey
