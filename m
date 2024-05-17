Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3F812F5A3
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715965782; cv=none; b=Fq/yEYsqW+xiBVzCqRrcvWiLcSpk/6r9HwKqe6xAuR6cjq7nVsYPRs0MGDBuEIKnTyC40dAbfJkmfq1zRGZI0I2xYeUvdUc58vLbVPSiLvuQlKkvhn02bS63b3coj3BkuqTB6ukC2BWYHsjGIKDmu8Qn/nOCMoHKs1yj2en9ED0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715965782; c=relaxed/simple;
	bh=dD4YCbEC0nx4A/8dje6gjT1esqkORafvF4xIh0rSmfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WhuaUlEv8ZUoQmhNCExjE9jpW+Jn3chT6ZDwD5WWHSXS9LNW2cw/UCwJZ7AesIg83lt++HIA58XL/248yIVidYSfjr+eiFWloJiMbsrd5CvOmfPor8cufp7O0hLHSAZrmn4ch8+vKxR+kqFsUStG5DvOVu+mUh6ED8J36l7d/A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h37jX6WT; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h37jX6WT"
X-Envelope-To: tabba@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715965778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EOd0DGjVTF8TMATOC1ei3+rrNIetbYtP/rVgFxN3if0=;
	b=h37jX6WTUAuYO8xHNmDGL9K/rMHAX47h3nCjx7LXmZjshMKOOIJ1ZAdxDG46VNEKTQBn5m
	iN4bwBL64q77dKFeQlkxfQUwoUNoSVwskxDrtvFMTFgSV4ZbdxEiYLwHhUqacf8ToEWeK2
	eqxhXW1zFajZGwYekhegx4CpLQYa0ys=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: qperret@google.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: philmd@linaro.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: broonie@kernel.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: rananta@google.com
X-Envelope-To: yuzenghui@huawei.com
Date: Fri, 17 May 2024 17:09:31 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Subject: Re: [PATCH v1 6/7] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
Message-ID: <ZkePS5jU6yEv6Nhp@linux.dev>
References: <20240517131814.719933-1-tabba@google.com>
 <20240517131814.719933-7-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240517131814.719933-7-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

On Fri, May 17, 2024 at 02:18:13PM +0100, Fuad Tabba wrote:
>  static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
>  {
> -	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
> +	/*
> +	 * Non-protected kvm relies on the host restoring its sve state.
> +	 * Protected kvm restores the host's sve state as not to reveal that
> +	 * fpsimd was used by a guest nor leak upper sve bits.
> +	 */
> +	if (unlikely(is_protected_kvm_enabled() && system_supports_sve())) {
> +		__hyp_sve_save_host();
> +
> +		/* Re-enable SVE traps for guests that do not support it. */
> +		if (!vcpu_has_sve(vcpu))
> +			sysreg_clear_set(cptr_el2, 0, CPTR_EL2_TZ);

This doesn't account for hVHE. I wonder we'd be better off abstracting
CPTR_EL2 behind a helper wherever it gets used in nVHE and translate
into the VHE-format behind the scenes:

static inline void __cptr_clear_set_hvhe(u64 cptr_clr, u64 cptr_set)
{
	u64 clr = 0, set = 0;

	if (cptr_clr & CPTR_EL2_TFP)
		set |= CPACR_ELx_FPEN;
	if (cptr_clr & CPTR_EL2_TZ)
		set |= CPACR_ELx_ZEN;
	if (cptr_clr & CPTR_EL2_TSM)
		set |= CPACR_ELx_SMEN;

	if (cptr_set & CPTR_EL2_TFP)
		clr |= CPACR_ELx_FPEN;
	if (cptr_set & CPTR_EL2_TZ)
		clr |= CPACR_ELx_ZEN;
	if (cptr_set & CPTR_EL2_TSM)
		clr |= CPACR_ELx_SMEN;

	sysreg_clear_set(cpacr_el1, clr, set);
}

static inline void cptr_clear_set(u64 clr, u64 set)
{
	if (has_hvhe())
		__cptr_clear_set_hvhe(clr, set);
	else
		sysreg_clear_set(cptr_el2, clr, set);
}

-- 
Thanks,
Oliver
