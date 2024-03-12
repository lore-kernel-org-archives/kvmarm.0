Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A073969D0A
	for <kvmarm@lists.linux.dev>; Tue, 12 Mar 2024 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710242273; cv=none; b=fKTKhQ/rO5VpjoNaCNPU1Wvf6TzCvWwlQcBNrH6tC56fw8A7pzxHxoswqBTV0asDk8H30rYZz//ccz6F9nCSnCzPYHJ9ljvlFe3hhFppYi7cIeR8f0QTxolavYbfahzqWIBTyZvNoEfiLy7UvjV+QwjglrmEJSRwOHRc2xLIKYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710242273; c=relaxed/simple;
	bh=m5rgtW1UM30ykYf+ugPgEXgV7jBy/L9CHYiImNcdCW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdzSAqn0Klbp35JQuuv9Mai6UkA6C5JF+UnLysDZsiLNKgKcuxh2Y+TpS31J9gf4RTL9IxNDFE/fz5mngl/yhJkvejUmRhw1ZVd9RcNkbGds9+aDx9WuAU5WJTo10SqdDzUtboSPV+4ZvVy7Tr9cj+Fz6jJjLa+b9VaFarkOxUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32C6B1007;
	Tue, 12 Mar 2024 04:18:26 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C76F3F762;
	Tue, 12 Mar 2024 04:17:47 -0700 (PDT)
Date: Tue, 12 Mar 2024 11:17:42 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 12/13] KVM: arm64: nv: Handle ERETA[AB] instructions
Message-ID: <20240312111742.GA1635791@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226100601.2379693-13-maz@kernel.org>

On Mon, Feb 26, 2024 at 10:06:00AM +0000, Marc Zyngier wrote:
> Now that we have some emulation in place for ERETA[AB], we can
> plug it into the exception handling machinery.
> 
> As for a bare ERET, an "easy" ERETAx instruction is processed as
> a fixup, while something that requires a translation regime
> transition or an exception delivery is left to the slow path.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 22 ++++++++++++++++++++--
>  arch/arm64/kvm/handle_exit.c    |  3 ++-
>  arch/arm64/kvm/hyp/vhe/switch.c | 13 +++++++++++--
>  3 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 63a74c0330f1..72d733c74a38 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2172,7 +2172,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>  
>  void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  {
> -	u64 spsr, elr;
> +	u64 spsr, elr, esr;
>  
>  	/*
>  	 * Forward this trap to the virtual EL2 if the virtual
> @@ -2181,12 +2181,30 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  	if (forward_traps(vcpu, HCR_NV))
>  		return;
>  
> +	/* Check for an ERETAx */
> +	esr = kvm_vcpu_get_esr(vcpu);
> +	if (esr_iss_is_eretax(esr) && !kvm_auth_eretax(vcpu, &elr)) {
> +		/*
> +		 * Oh no, ERETAx failed to authenticate.  If we have
> +		 * FPACCOMBINE, deliver an exception right away.  If we
> +		 * don't, then let the mangled ELR value trickle down the
> +		 * ERET handling, and the guest will have a little surprise.
> +		 */
> +		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE)) {
> +			esr &= ESR_ELx_ERET_ISS_ERETA;
> +			esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
> +			kvm_inject_nested_sync(vcpu, esr);
> +			return;
> +		}
> +	}
> +
>  	preempt_disable();
>  	kvm_arch_vcpu_put(vcpu);
>  
>  	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
>  	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
> -	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
> +	if (!esr_iss_is_eretax(esr))
> +		elr = __vcpu_sys_reg(vcpu, ELR_EL2);
>  
>  	trace_kvm_nested_eret(vcpu, elr, spsr);
>  
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 1ba2f788b2c3..407bdfbb572b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -248,7 +248,8 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
>  
>  static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>  {
> -	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)))
> +	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)) &&
> +	    !vcpu_has_ptrauth(vcpu))
>  		return kvm_handle_ptrauth(vcpu);
>  
>  	/*
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 3ea9bdf6b555..49d36666040e 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -208,7 +208,8 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
>  
>  static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> -	u64 spsr, mode;
> +	u64 esr = kvm_vcpu_get_esr(vcpu);
> +	u64 spsr, elr, mode;
>  
>  	/*
>  	 * Going through the whole put/load motions is a waste of time
> @@ -242,10 +243,18 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  		return false;
>  	}
>  
> +	/* If ERETAx fails, take the slow path */
> +	if (esr_iss_is_eretax(esr)) {
> +		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))
> +			return false;
> +	} else {
> +		elr = read_sysreg_el1(SYS_ELR);
> +	}
> +
>  	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
>  
>  	write_sysreg_el2(spsr, SYS_SPSR);
> -	write_sysreg_el2(read_sysreg_el1(SYS_ELR), SYS_ELR);
> +	write_sysreg_el2(elr, SYS_ELR);
>  
>  	return true;
>  }
> 

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
