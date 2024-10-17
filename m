Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32491388
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 00:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729123830; cv=none; b=f631pkAcVTzDOSAxMqnwuVdgq71tF9rn1o/kkvCihbv/4DMq8xmATQywHvFV3w3jxEdueBb9+PgFC+4CvVudxr7ifMtQ52apdCNFkt9BgPz/MOq14vu3QPAsoMqbXczWsDrr+Et58PH80LvwWnm7TCXcKdVYd3TPuaC3v+aX064=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729123830; c=relaxed/simple;
	bh=sGFXnJUhJZ0gQlhqlg0H5bUZszK/wAHYH4MnH46qwfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xq1LgyuGWT8ed1YJIwL2rw+GnghENQGlBCo2A44FbQaR8imywInvowIEVURBFDVUzk1MwssjJVNc7CfV92D3YH2qS3sOvrS88lH7qe5JHh7rRdP5V+7SMxQ4XmqykAX+jMu3T9JJrRaGUkjzZf4PEeP5BhKnOWgx7XN+q/n55Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bF46m3KL; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bF46m3KL"
Date: Wed, 16 Oct 2024 17:10:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729123826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieleEVTPWn9Zh92ysgfXoFMSmClM+5NchpTLWKRdSEM=;
	b=bF46m3KLhianGDXXLx8rsBwd6lfkgfNp3rCw5OTV71Hxht7cUl6QBeIPXuOudNzUG0wUCd
	1SbGrYG/phNu6azS7ciM0dR39LmKpPvipqM7svTeHtylH/hTCpEVLZrXRxMedleIOGyeTD
	uwV3Sf9uXK8h8y2uj/pnY/5IZLQ4E/A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, james.morse@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/7] KVM: arm64: Fix missing traps of guest accesses
 to the MPAM registers
Message-ID: <ZxBV6c4Z_GlyDoBr@linux.dev>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-5-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015133923.3910916-5-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Joey,

On Tue, Oct 15, 2024 at 02:39:20PM +0100, Joey Gouly wrote:
> +static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
> +{
> +	u64 r = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> +
> +	if (!cpus_support_mpam())
> +		return;
> +
> +	/* trap guest access to MPAMIDR_EL1 */
> +	if (mpam_cpus_have_mpam_hcr()) {
> +		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
> +	} else {
> +		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
> +		r |= MPAM2_EL2_TIDR;
> +	}
> +
> +	write_sysreg_s(r, SYS_MPAM2_EL2);
> +}
> +
> +static inline void __deactivate_traps_mpam(void)
> +{
> +	if (!cpus_support_mpam())
> +		return;
> +
> +	write_sysreg_s(0, SYS_MPAM2_EL2);
> +
> +	if (mpam_cpus_have_mpam_hcr())
> +		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
> +}

TBH, I think our trap configuration should *not* be conditioned on
CONFIG_ARM64_MPAM. Otherwise we're silently allowing the guest to change
things under the nose of KVM/host kernel, assuming an unkind firmware
that left the EL2 trap configuration in a permissive state.

WDYT about detecting the feature && enforcing traps regardless of the Kconfig?

-- 
Thanks,
Oliver
