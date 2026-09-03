Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03504E2365
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449884; cv=none; b=CpqOrR46H1HmcMuGS9xTO/bYiLeZnXO+bYQoM2IK3yECRou9GX8LJx2NVTRVpehONzI+iaR0Q8yK3xCBkVZEHIFFg5HMeb3x3aJ4HaRaP/+9LI0MJyTz8wUBtqiI7j0fo/Avtk4GZSj1dXPLkTklBlyRcmeymGVfHgS0Kj/Rnkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449884; c=relaxed/simple;
	bh=oCZbPDVvCXBkOJzwU5rhSB7/JmNpokz7ClUQIUpFm5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=n4aoVYNOEaK9xnDZ0sX8VSFOoDzEU35xO3iBHTwaAAoH8NOVgoRICPaP7npMCgzOw+PnXKYMizgjRY3j0aj534zrAR6wBfAKGW6nvYYvKEz773qkLCrASWE9FbjBd3MYlh+ytls7muowyhq5JShuN5sI2TKAuVk375+snF2nnag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OEMbio4G; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OEMbio4G"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 320021596;
	Thu,  3 Sep 2026 08:37:51 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0D013F7D8;
	Thu,  3 Sep 2026 08:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788449874; bh=oCZbPDVvCXBkOJzwU5rhSB7/JmNpokz7ClUQIUpFm5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEMbio4GVl0XWAA8MxNYy8/78cHWeKkeSKov4BrZM47nNeFK1FHGCIutpsBSvLacf
	 MQJI2phietymUtotbazfVjw/nYwJF3ZyVwqCuG/7fs5xq+DhCZUE/qI9IuNQn8FtKr
	 1JwJVdol0cXrEDUH4UreZbPXJTz3/pwONCDOXAL8=
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
Subject: Re: [PATCH v20 06/14] KVM: arm64: Validate GCS exception lock when emulating ERET
Date: Thu,  3 Sep 2026 16:37:37 +0100
Message-ID: <apmUQETDlhTIuJIY@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-6-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-6-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:04PM +0100, Mark Brown wrote:
[...]
> +#ifdef CONFIG_ARM64_GCS
> +/* See IllegalExceptionReturn() pseudocode */
> +static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
> +						   u64 spsr)
> +{
> +	u64 pstate, cur_mode, target_mode;
> +
> +	if (!kvm_has_gcs(vcpu->kvm))
> +		return false;
> +
> +	if (vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT)
> +		return false;
> +
> +	/* Check the EL only, ignore thread mode */
> +	pstate = vcpu->arch.ctxt.regs.pstate;
> +	cur_mode = (pstate & PSR_MODE_MASK) | PSR_MODE_THREAD_BIT;
> +	target_mode = (spsr & PSR_MODE_MASK) | PSR_MODE_THREAD_BIT;
> +
> +	if (cur_mode != target_mode)
> +		return false;
> +
> +	return vcpu_read_sys_reg(vcpu, GCSCR_EL2) & GCSCR_ELx_EXLOCKEN;
> +}

The above perfectly translates the GCS part of IllegalExceptionReturn().

It's a nit, as I suppose there should be no compiler warning on that, but
the function should return a bool, and the last return line returns an u64.

Maybe adding a "return !!()" would be better?

[...]
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 3806ff0920fe..170c0c521f22 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2748,10 +2748,13 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>  	 * - trying to return to an illegal M value
>  	 * - trying to return to a 32bit EL
>  	 * - trying to return to EL1 with HCR_EL2.TGE set
> +	 * - GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is 0 when attempting
> +	 *   to return from ELx the same EL.
>  	 */
>  	if (mode == PSR_MODE_EL3t   || mode == PSR_MODE_EL3h ||
>  	    mode == 0b00001         || (mode & BIT(1))       ||
>  	    (spsr & PSR_MODE32_BIT) ||
> +	    kvm_check_illegal_exlock_return(vcpu, spsr) ||
>  	    (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
>  					   mode == PSR_MODE_EL1h))) {
>  		u64 mask;

In IllegalExceptionReturn(), the GCS-related clause happens at the end, and 
here it happens before the TGE one. Could this cause any weird behavior in 
the future?

I get that by doing like this you don't change the last line of the "if", 
but I wonder if that could change anything.

[...]
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 7875911c0506..af59d1bf51ad 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -383,6 +383,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  		return false;
>  	}
>  
> +	/* Push GCS exception lock failures into the slow path */
> +	if (kvm_check_illegal_exlock_return(vcpu, spsr))
> +		return false;
> +
>  	/* If ERETAx fails, take the slow path */
>  	if (esr_iss_is_eretax(esr)) {
>  		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))

IIUC, this function will be called on the __kvm_vcpu_run_vhe() inner loop, 
in the cases where the guest exited due to a eret. 

What you change here is that in case of an illegal exlock return, it goes 
out of the loop and return to host kernel, probably to deal with it in the 
mentioned slowpath, the same way the ERETAx entry does.

I don't question on this being needed. 
I would just like to understand why this is needed here. 

This does not seem to be related to nested, as this is called in 
__fixup_guest_exit() and not in fixup_nv_guest_exit(). But would not 
hardware be responsible for cheking this, then?

Thanks!
Leo
