Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498EE2D94B5;
	Fri,  4 Sep 2026 13:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527078; cv=none; b=fedLA+WzuwxQGn8zgCZ/ZbUsyHHd0ObokPq39EmnvgPwoWRTiXMdrjZaszKl76DCMA1BhvV76z+6xgufFFlyEJcgYizfRVmafvJKG+U+RJDBqOnSDIYDyDf2U0FGiVq6wKVfIOiN9/0FPw73uplCve+u3ilwZd8ZfI2rc6lMOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527078; c=relaxed/simple;
	bh=hgMkUm6ZJXGaN8CSWA74FoH3YB5D0Q8YypvHtnEdcWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6pJtf6pq6UQh3iXWKU+DFkLK0ZJxBEid9VNLUdxATUV0QItgyFwhJnurCl6908kJh7SS3l4TvimUbnqgwq0l74RigKZIiqpfZq2hEbZRWuoxhQEQRtCoJV5lPVDMbdTw+N7VfmftKCXdgZ2pZOIrgeCBaw+OIjU+Zkizsau8hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FI9jXmPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FI9jXmPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F225F1F00A3D;
	Fri,  4 Sep 2026 13:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788527077;
	bh=4uzkzE9HQAjsck1RvYQ8k28kiSnXOy+3W2NVGAadN4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FI9jXmPkKkcA/J38KUy6UrC0lnv+GHJhr4JQlSroai4bNWSKzKJK6Jd8IeHsBM0iI
	 PPjg7gu2zyFEDpkr1v6U/HQfRkQi+1qfIGq5A5rwkQftQWM4DOkNz1zWSvzb3pAiYd
	 xIWckFefXGNa7lmCgHI+a81XYczWY5ODSX5GYJnaLN4nd+nuz/hYKBUW1rXmXK5d56
	 h00Mmp1i8kzP+LCpD81ppXggZBiqkdC2kCxRSVMDLqi0y2dsEQRu2ReFT9ZJ8pF3IA
	 sh+X5YPSFhtDClkhSsQ4e3he0mYS93R1OQwT+Kl5q+6GE7Oi3ZFALnCSfvVW8SVVXH
	 CLTjn0y6S8+Zw==
Date: Fri, 4 Sep 2026 14:04:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Message-ID: <apq2uELk-VRvrg7w@gremlin>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-5-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-arm64-gcs-v20-5-f31750bdfadb@kernel.org>

On Tue, Sep 01, 2026 at 10:47:03PM +0100, Mark Brown wrote:
> As per DDI 0487 R_WTXBY we need to manage PSTATE.EXLOCK when entering an

I'm guessing this is the doc at this unreasonably huge URI? :)

https://support.arm.com/documentation/ddi0487/mc/-Part-D-The-AArch64-System-Level-Architecture/-Chapter-D1-The-AArch64-System-Level-Programmers--Model/-D1-4-Exceptions/-D1-4-2-Exception-entry?lang=en#wtxby

> exception, when the exception is entered from a lower EL the bit is cleared
> while if entering from the same EL it is set to GCSCR_ELx.EXLOCKEN.
> Implement this behaviour in enter_exception64().

Ack, all makes sense and matches the doc.

>
> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

All LGTM! A couple small nits but otherwise:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/include/uapi/asm/ptrace.h |  1 +
>  arch/arm64/kvm/hyp/exception.c       | 37 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
>
> diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
> index 15649a253a57..eed7f1226be6 100644
> --- a/arch/arm64/include/uapi/asm/ptrace.h
> +++ b/arch/arm64/include/uapi/asm/ptrace.h
> @@ -56,6 +56,7 @@
>  #define PSR_C_BIT	0x20000000
>  #define PSR_Z_BIT	0x40000000
>  #define PSR_N_BIT	0x80000000
> +#define PSR_EXLOCK_BIT 0x400000000

Ah yeah I see this matches BIT_ULL(34) /* PSTATE.EXLOCK */ in
emulate-nested.c (which you later replace with this :)

>
>  #define PSR_BTYPE_SHIFT		10
>
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 754e2dc1df54..85c873644fe9 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -49,6 +49,38 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
>  		vcpu->arch.ctxt.spsr_und = val;
>  }
>
> +static unsigned long compute_exlock(struct kvm_vcpu *vcpu,
> +				    unsigned long mode,
> +				    unsigned long target_mode)
> +{
> +	u64 gcscr;
> +
> +	if (!kvm_has_gcs(kern_hyp_va(vcpu->kvm)))
> +		return 0;
> +
> +	/* GCS can't be enabled for 32 bit */
> +	if (mode & PSR_MODE32_BIT)
> +		return 0;

Ack makes sense.

> +
> +	/* When taking an exception to a higher EL EXLOCK is cleared. */
> +	if ((mode | PSR_MODE_THREAD_BIT) != target_mode)
> +		return 0;

Ack makes sense as per doc.

> +
> +	/*
> +	 * When taking an exception to the same EL EXLOCK is set to
> +	 * the effective value of GCSR_ELx.EXLOCKEN.

NIT: Typo? Other references to this here are for GCSCR_ELx.EXLOCKEN.

> +	 */
> +	if (is_hyp_ctxt(vcpu))
> +		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL2);

I guess with VHE this does the automagically 'think it's in EL2' even if
it's nested in EL1 stuff? :)

> +	else
> +		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL1);
> +
> +	if (gcscr & GCSCR_ELx_EXLOCKEN)
> +		return PSR_EXLOCK_BIT;

This all LGTM.

> +
> +	return 0;
> +}
> +
>  /*
>   * This performs the exception entry at a given EL (@target_mode), stashing PC
>   * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
> @@ -138,6 +170,11 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	// PSTATE.BTYPE is set to zero upon any exception to AArch64
>  	// See ARM DDI 0487E.a, pages D1-2293 to D1-2294.
>
> +	// PSTATE.EXLOCK is set to 0 upon any exception to a higher
> +	// EL, or to GCSCR_ELx.EXLOCKEN for an exception to the same
> +	// exception level.  See ARM DDI 0487 R_WTXBY.

Yeah confirmed:

	"If FEAT_GCS is implemented, PSTATE.EXLOCK is updated based on the
	 following situations:

	 On taking an exception to the same Exception level, PSTATE.EXLOCK
	 is set to the Effective value of GCSCR_ELx.EXLOCKEN for the
	 current Exception level.

	 On taking an exception to a higher Exception level, PSTATE.EXLOCK
	 is set to 0."

A slight nit is that maybe the comment should live with compute_exlock()
but it's no big deal.

> +	new |= compute_exlock(vcpu, mode, target_mode);
> +
>  	new |= PSR_D_BIT;
>  	new |= PSR_A_BIT;
>  	new |= PSR_I_BIT;
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
