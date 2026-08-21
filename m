Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8141A47DF9B
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 14:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322797; cv=none; b=e/tTIA3Ha2YnMTbzDfT9C8+yC7jfAkdE/RpWQt8A5uFvd+IO6fXBdOkrPG6cZj9ZBSkdDcvsHQRXexTRVntvo0utc5hEPTATkVvr9+eYLdqfYKaPD7Lul5x7o3mLf2GlEcULPFlabJWAAteTtdo9diBnU1fUMxJuGJABmCsopE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322797; c=relaxed/simple;
	bh=0Xa7Oehcy9x1McUKUPlTBOCPe3WmYJS7pLp5g3Y//5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9Ea7h0GwfKwexffmuReYLXcT0Rn1aA0o7Z9O10Qwwtd86OhgpMwqpsG5dNLNQxeG52hr/WHOQzAULBzpCfPz6KaDj1WjH7Tot2H7AdIbWbiQknhAfCv4YMFFlXKN0fG4NVhZ/GURfLfiEW3DpftPWhFxKABdKBoBVtcmIHde4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sOB5zNlW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sOB5zNlW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA075153B;
	Fri, 21 Aug 2026 07:33:04 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26AE93F85F;
	Fri, 21 Aug 2026 07:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787322788; bh=0Xa7Oehcy9x1McUKUPlTBOCPe3WmYJS7pLp5g3Y//5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sOB5zNlWly8ECDNc6e96+rPB4KK8F8ATbYU6GSwUAWXmJ77Kyrb6Zlvr37vN+qZ/U
	 +zYbTubLHh8rD3ZXaZIj3DxaCtXn3nOL/b4mnX0kRza/RCZrLO0x8dt6Av4B+FXCN8
	 oBTO+ZfpcnRLZGPd4ej4+3Ssg1OxdkQXzgirz2PM=
Date: Fri, 21 Aug 2026 15:32:58 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Mark Brown <broonie@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Message-ID: <vdmz43ogvmwu4liilfqzdrgsf5v765bucl7mybhfdxj7yrywkd@5mssukdegdwg>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-6-9105afd828ac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812-arm64-gcs-v19-6-9105afd828ac@kernel.org>

On Wed, Aug 12, 2026 at 08:12:05PM +0100, Mark Brown wrote:
> As per DDI0487 R_TYTWB GCS adds an additional case where an illegal
> exception return can be generated. If all of:
> 
>  - PSTATE.EXLOCK is 0.
>  - The EL is not being changed by the ERET.
>  - GCSCR_ELx.EXLOCKEN is 1.
> 
> are true then the return is illegal. Emulate this behaviour when
> emulating ERET for nested guests, while we're at it using the symbolic
> definition for EXLOCK in SPSR.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 39 +++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/emulate-nested.c     |  5 ++++-
>  arch/arm64/kvm/hyp/vhe/switch.c     |  4 ++++
>  3 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 012d711034d1..f25ddee89206 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -240,6 +240,45 @@ static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
>  }
>  #endif
>  
> +#ifdef CONFIG_ARM64_GCS
> +/*
> + * A subset of the pseudocode ELFromSPSR(), validity checks are
> + * assumed to have been done in code that is not GCS specific.
> + */
> +static inline int exlock_el_from_spsr(u64 spsr)
> +{
> +	return FIELD_GET(GENMASK(3, 2), spsr);
> +}

It feels a bit odd to me to have this function named exlock specific, as
it's just spsr_to_el, right?

Thanks,
Wei-Lin Chang

> +
> +/* See IllegalExceptionReturn() pseudocode */
> +static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
> +						   u64 spsr)
> +{
> +	u64 cur_el, target_el;
> +
> +	if (!kvm_has_gcs(vcpu->kvm))
> +		return false;
> +
> +	if (vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT)
> +		return false;
> +
> +	cur_el = exlock_el_from_spsr(vcpu->arch.ctxt.regs.pstate);
> +	target_el = exlock_el_from_spsr(spsr);
> +
> +	if (cur_el != target_el)
> +		return false;
> +
> +	return vcpu_read_sys_reg(vcpu, GCSCR_EL2) & GCSCR_ELx_EXLOCKEN;
> +}
> +
> +#else
> +static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
> +						   u64 spsr)
> +{
> +	return false;
> +}
> +#endif
> +
>  #define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
>  
>  static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)

[...]
