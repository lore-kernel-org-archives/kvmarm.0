Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C92B22A80D
	for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739992987; cv=none; b=g7qGr/TXBWAuNJJEVYB1ulrwyJCJhb67KVL7vCMD2nL0zOEy2Vht+zEf5W4fVLNaMTUYw6ZQJM+dAPK799cUofDJbak9km63MlUkT7yR8yo/ZTeryjctyFszuWkp6c+hOTSwvVdJEeCYMigI03EBP0keU5eg7+pKhF0E5nRho4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739992987; c=relaxed/simple;
	bh=x6t1hSCMqZLMmIpOqoAE6uKCuFN1pTWBANKfk/1zrpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0EbEX4N08JlITxOWx+VJ/lazzPwEZ5bb5czkd9UNJvoUQBSzCtspURBKbGLkA9QrTOfwePVkmv63UTKVkO6lf7a1GOCtIt6mAm64O749lF/mJgX/YtyweZ0oPyhNgyFUcgTzdzmhXKbS9JGvs2aPL34oEteWObP837W4ITqsoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wpbGXpA9; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wpbGXpA9"
Date: Wed, 19 Feb 2025 11:22:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739992982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=py62NjgHyqePD/1xxiF47Ojj/UAYgJgEPILXJQHYeUw=;
	b=wpbGXpA9K426wUIeTQaneUGsyJ2aLTd7V1pWeTS2jiBxCc8g047ll176UouBJ5WeCFvdv3
	koB6l5gRLjQaWG28qTOndotTu4GRwC/XZDb5Oy5fGRzjhBSsE0AMirgk9sMV4KrHwnJQns
	j3sPE519Ckg/6+GNw5nq70IOFWFCTL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH v2 07/14] KVM: arm64: Use a cpucap to determine if system
 supports FEAT_PMUv3
Message-ID: <Z7YvkHpm3w__HnkO@linux.dev>
References: <20250203183111.191519-1-oliver.upton@linux.dev>
 <20250203183111.191519-8-oliver.upton@linux.dev>
 <864j0psuas.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864j0psuas.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 19, 2025 at 05:44:59PM +0000, Marc Zyngier wrote:
> > +static bool has_pmuv3(const struct arm64_cpu_capabilities *entry, int scope)
> > +{
> > +	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > +	unsigned int pmuver;
> > +
> > +	pmuver = cpuid_feature_extract_unsigned_field(dfr0,
> > +						      ID_AA64DFR0_EL1_PMUVer_SHIFT);
> > +	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> > +		return false;
> > +
> > +	return pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP;
> 
> Given that PMUVer is a signed field, how about using
> cpuid_feature_extract_signed_field() and do a signed comparison instead?

I'm happy to include a comment, but the PMUVer field is not signed. Any value
other than 0xF is meant to be treated as an unsigned quantity.

DDI047L.a D24.1.3.2 is where this is coming from.

> > +}
> > +
> >  #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
> >  #define KPTI_NG_TEMP_VA		(-(1UL << PMD_SHIFT))
> >  
> > @@ -2999,6 +3012,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
> >  		ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, GCS, IMP)
> >  	},
> >  #endif
> > +	{
> > +		.desc = "PMUv3",
> > +		.capability = ARM64_HAS_PMUV3,
> > +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> > +		.matches = has_pmuv3,
> > +	},
> 
> This cap is probed unconditionally (without any configuration
> dependency)...
> 
> >  	{},
> >  };
> >  
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index f838a45665f2..0edc7882bedb 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -244,7 +244,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> >  	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
> >  	 * EL1 instead of being trapped to EL2.
> >  	 */
> > -	if (kvm_arm_support_pmu_v3()) {
> > +	if (system_supports_pmuv3()) {
> 
> ... but kvm_arm_support_pmu_v3() is conditional on
> CONFIG_HW_PERF_EVENTS.  Doesn't this create some sort of new code path
> that we didn't expect?

Yep. It ought to be benign, but pointless. I'll condition this correctly
next time around.

Thanks,
Oliver
