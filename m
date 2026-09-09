Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8E357981A
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964544; cv=none; b=SZyx0wc0pGvBG/RueD9KSSyew5TEo+3dQvdf51O7IjDWn63aU9B+jSs0IZEltJBSmKPt6t5geZdmAN4amN/51oKINAJugtc4kOsAedbxUZtqtLga4N0NxEAvOQV8ZYBPZ392H46o+CjqxfETgO8elP5orsRmlkU55QHtyUmFacw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964544; c=relaxed/simple;
	bh=I9XuzW0cEz018KO1kKpVvVK/800kvyU3xHh5hRfnP+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=N973nIJsJF4EbpXSY2gWSna7RWXBCezRPGWva/FI+cClVQLYo8TuL+RtePAz3XW5DNZ2lq5xjdCe5HVaCcm3yVnFdrOLxlDsa9VoZ3EfxApij6eV9RzR/TVg4eZ8s1JXYxx2P5R7U/Ev2iik6OfpzqRhVi8aM3MA+4Vsx8S1CgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BqKs46+T; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BqKs46+T"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 037CB1691;
	Wed,  9 Sep 2026 07:35:37 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61A7C3F528;
	Wed,  9 Sep 2026 07:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788964540; bh=I9XuzW0cEz018KO1kKpVvVK/800kvyU3xHh5hRfnP+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqKs46+Tdriido5VOOEb+8dsa+BZ+2TaSdLHLwoQDJqu5BOmU8sslti7c6UK1BNkH
	 c640ChcuSxdgZtAm/+cLOWochAsR310WLvdnktS3rOnEHNXnsitQUN2nRxBPpzY0Ui
	 QGXmp+pK+/uKU5ureLNQspeJTVYWXAVhoE//ZfXw=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 08/14] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Date: Wed,  9 Sep 2026 15:35:32 +0100
Message-ID: <aqFutNSGfEpJFKJl@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-8-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-8-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:06PM +0100, Mark Brown wrote:
> As per I_CFFNS and the pseudocode for the SPSR_ELx and ELR_ELx registers
> a GCS exception with ExType 1 is generated for attempts to write to
> those registers when both GCSCR_ELx.EXLOCKEN and PSTATE.EXLOCK are set.
> Ensure that this is enforced for guests if access to these registers
> from the guest is handled by the hypervisor.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  8 +++++++
>  arch/arm64/kvm/sys_regs.c            | 42 ++++++++++++++++++++++++++++++++----
>  2 files changed, 46 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 0cd91b3d6c82..e47ab38327de 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -81,6 +81,14 @@ int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
>  int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
>  int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr);
>  
> +static inline void kvm_inject_exlock(struct kvm_vcpu *vcpu)
> +{
> +	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_GCS) | ESR_ELx_IL |
> +		  FIELD_PREP(ESR_ELx_ExType_MASK, ESR_ELx_ExType_EXLOCK);

Seems the likely encoding, based on reading the ESR_EL2 doc, not sure if 
there is a better place to read that from.

> +
> +	kvm_inject_sync(vcpu, esr);
> +}
> +
>  static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
>  {
>  	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SVE) |
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c5ce18b3f7d8..1f80c26a9839 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2866,14 +2866,42 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static inline bool sysregs_exlocked(struct kvm_vcpu *vcpu)
> +{
> +	u64 gcscr;
> +
> +	if (!kvm_has_gcs(vcpu->kvm))
> +		return false;
> +
> +	if (!(vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT))
> +		return false;
> +
> +	/*
> +	 * Note that the EXLOCKEN for the running EL is checked
> +	 * regardless of the register written to.
> +	 */
> +	if (is_hyp_ctxt(vcpu))
> +		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL2);
> +	else
> +		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL1);
> +
> +	return gcscr & GCSCR_ELx_EXLOCKEN;
> +}
> +

Right, because on both ELR_ELx and SPSR_EL{1,2} we have to check if
GCS is enabled && EXLOCKEN=1 && EXLOCK=1, 
so any of those conditions being false mean no exlock injection is needed. 


>  static bool access_elr(struct kvm_vcpu *vcpu,
>  		       struct sys_reg_params *p,
>  		       const struct sys_reg_desc *r)
>  {
> -	if (p->is_write)
> +	if (p->is_write) {
> +		if (sysregs_exlocked(vcpu)) {
> +			kvm_inject_exlock(vcpu);
> +			return false;
> +		}
> +
>  		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
> -	else
> +	} else {
>  		p->regval = vcpu_read_sys_reg(vcpu, ELR_EL1);
> +	}
>  
>  	return true;
>  }
> @@ -2882,10 +2910,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>  			struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
>  {
> -	if (p->is_write)
> +	if (p->is_write) {
> +		if (sysregs_exlocked(vcpu)) {
> +			kvm_inject_exlock(vcpu);
> +			return false;
> +		}
> +
>  		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, p->regval);
> -	else
> +	} else {
>  		p->regval = __vcpu_sys_reg(vcpu, SPSR_EL1);
> +	}
>  
>  	return true;
>  }

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
