Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F51623504B
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779799733; cv=none; b=TkyZ3KOeHf/Co4IPO714R1xqcjHybYdhMTpxVrahL6IBTeiTvNztyyMUZQgIIqjNV/zVkwQpWacBvnKDmnlgwM/zhN+5GNFnAw8y7/jM5Nkd6ImFzpYJF8GKiMNn2+uK+NGBahO7CZVO8VYqHPs0UTFQX8T3X7Mb9sS5YEI/6pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779799733; c=relaxed/simple;
	bh=iVSKChv7eKUg+EWssQSvbeUHPrHZzgtGW7zvLa9lrck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=toktFw5ZGjK3qKsP6j+V36R7WfSW0m2VC2+Ihu0iMK8SDjaRBRz/jBxS90F+NRX8vx215818lr5uykHRCeSCwZElTVWmwTA4nBCNW8WqNBxuLv8ciif0QmjTLAjwbSkWo3xoM1GRsiGojCl4A405jyyACormuj1XLJ70/0OmTwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ao89louo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ao89louo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AB5E169C;
	Tue, 26 May 2026 05:48:45 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B64353F7B4;
	Tue, 26 May 2026 05:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779799730; bh=iVSKChv7eKUg+EWssQSvbeUHPrHZzgtGW7zvLa9lrck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ao89louokZgAi+vZXN9MNzXkPL+ttcyCfT2VjmwaTjPb2mDKJJU9tokn4RuoJjn/8
	 JngV14i95CSd6OnB6OrWcJxgRfHh6gWegBQWcpwifwQcoCy894JweappRrMZPK/ib5
	 C9qPA2vkR750H04wlFNYcGhvuoMfw1CmRoOrvc5Y=
Date: Tue, 26 May 2026 13:48:41 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <ahWWqU51Zffmhlo5@J2N7QTR9R3>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-2-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-2-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:00:54PM +0000, Mark Brown wrote:
> Currently we enable EL0 and EL1 access to FA64 and ZT0 at boot and leave
> them enabled throughout the runtime of the system. When we add KVM support
> we will need to make this configuration dynamic, these features may be
> disabled for some KVM guests. Since the host kernel saves the floating
> point state for non-protected guests and we wish to avoid KVM having to
> reload the floating point state needlessly on guest reentry let's move the
> configuration of these enables to the floating point state reload.
> 
> We provide a helper which does the configuration as part of a
> read/modify/write operation along with the configuration of the task VL,
> then update the floating point state load and SME access trap to use it.
> We also remove the setting of the enable bits from the CPU feature
> identification and resume paths.  There will be a small overhead from
> setting the enables one at a time but this should be negligible in the
> context of the state load or access trap.  In order to avoid compiler
> warnings due to unused variables in !CONFIG_ARM64_SME cases we avoid
> storing the vector length in temporary variables.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h | 18 ++++++++++++++++
>  arch/arm64/kernel/cpufeature.c  |  2 --
>  arch/arm64/kernel/fpsimd.c      | 47 +++++++++++------------------------------
>  3 files changed, 30 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 1d2e33559bd5..7361b3b4a5f5 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -428,6 +428,22 @@ static inline size_t sme_state_size(struct task_struct const *task)
>  	return __sme_state_size(task_get_sme_vl(task));
>  }
>  
> +/*
> + * Note that unlike SVE we have additional feature bits for FA64 and
> + * ZT0 as well as the VL.
> + */
> +#define sme_cond_update_smcr(vl, fa64, zt0, reg)		\
> +	do {							\
> +		u64 __old = read_sysreg_s((reg));		\
> +		u64 __new = vl & SMCR_ELx_LEN_MASK;		\

Nit: this isn't VL, it's VQ - 1.

If that value is bigger than SMCR_ELx_LEN_MASK to begin with, there's a
latent bug in the caller, and silently masking the value is just hiding the
problem.

> +		if (fa64)					\
> +			__new |= SMCR_ELx_FA64;			\
> +		if (zt0)					\
> +			__new |= SMCR_ELx_EZT0;			\
> +		if (__old != __new)				\
> +			write_sysreg_s(__new, (reg));		\
> +	} while (0)
> +

I'd strongly prefer that we make it the caller's responsiblity to track
all the bits within SMCR, rather than requiring each caller to pass a
bag of booleans.

Either we can store the full SMCR value in the task, or we can have
something like:

	unsigned long __task_smcr(const struct task_struct *tsk)
	{
		unsigned long vq = sve_vq_from_vl(task_get_sme_vl(tsk));
		unsigned long smcr = vq - 1;

		if (system_supports_fa64())
			smcr |= SMCR_ELx_FA64;

		if (system_supports_sme2())
			smcr |= SMCR_ELx_EZT0;

		return smcr;
	}

... and if we need a helper for a conditional update, we can have
generic versions:

	#define sysreg_cond_update(sysreg, val) \
		sysreg_clear_set(syreg, ~0UL, val)

	#define sysreg_cond_update_s(sysreg, val) \
		sysreg_clear_set_s(syreg, ~0UL, val)

That way task_fpsimd_load() and do_sme_acc() don't need to duplicate all
the system_supports_XXX() checks, and both can have:

	sysreg_cond_update_s(SYS_SMCR_EL1, __task_smcr(current));

... which keeps all the points of use simpler and consistent with one
another, and keeps the logic in the helper far more legibile and robust
(e.g. no macro variable shadowing).

We can do the same for ZCR, e.g.

	unsigned long __task_zcr(const struct task_struct *tsk)
	{
		unsigned long vq = sve_vq_from_vl(task_get_sve_vl(tsk));
		unsigned long zcr = vq - 1;

		return zcr;
	}

[...]

> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 9de1d8a604cb..cf419319f077 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -398,11 +398,15 @@ static void task_fpsimd_load(void)
>  
>  	/* Restore SME, override SVE register configuration if needed */
>  	if (system_supports_sme()) {
> -		unsigned long sme_vl = task_get_sme_vl(current);
> -
> -		/* Ensure VL is set up for restoring data */
> +		/*
> +		 * Ensure VL is set up for restoring data.  KVM might
> +		 * disable subfeatures so we reset them each time.
> +		 */
>  		if (test_thread_flag(TIF_SME))
> -			sme_set_vq(sve_vq_from_vl(sme_vl) - 1);
> +			sme_cond_update_smcr(sve_vq_from_vl(task_get_sme_vl(current)) - 1,
> +					     system_supports_fa64(),
> +					     system_supports_sme2(),
> +					     SYS_SMCR_EL1);
>  
>  		write_sysreg_s(current->thread.svcr, SYS_SVCR);

With the proposal above, this would become:

	if (system_supports_sme()) {

		/*
		 * Ensure any SME controls are configured appropriately
		 * before restoring state.
		 */
		if (test_thread_flag(TIF_SME))
			sysreg_cond_update_s(SYS_SMCR_EL1, __task_smcr(current));

		[...]
	}

[...]

> @@ -1400,9 +1376,10 @@ void do_sme_acc(unsigned long esr, struct pt_regs *regs)
>  		WARN_ON(1);
>  
>  	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
> -		unsigned long vq_minus_one =
> -			sve_vq_from_vl(task_get_sme_vl(current)) - 1;
> -		sme_set_vq(vq_minus_one);
> +		sme_cond_update_smcr(sve_vq_from_vl(task_get_sme_vl(current)) - 1,
> +				     system_supports_fa64(),
> +				     system_supports_sme2(),
> +				     SYS_SMCR_EL1);
>  
>  		fpsimd_bind_task_to_cpu();
>  	} else {

Likewise, with the proposal above, this would become:

	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
		sysreg_cond_update_s(SYS_SMCR_EL1, __task_smcr(current));
		fpsimd_bind_task_to_cpu();
	} else {
		[...]
	}

Mark.
