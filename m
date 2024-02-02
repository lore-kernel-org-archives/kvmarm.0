Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AD51474B5
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 17:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706894161; cv=none; b=INkJU10CpMgwYNPwXG2FU/gCU6eiZigdAR22q5GQliQWEIjGntSHWfCqQD51+Ddp+JCmsZjXg7xo+AHd5zbSiLRHaBB3Cx+pLMY7lMiV2VJUEvrkiYRs0dyAJd7acQvDNTZF1CNBS4VX270oJ+/G1AaK65mlsJGBoSJuUm9t0/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706894161; c=relaxed/simple;
	bh=WLRnd6XiAOXW/+fV6tGLa4dDZi0W1lIH4peSoDovnP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIneSsPEzElXrwPXuzPNRaLtLekSa9nEvKhgp4sgVpU3brK8NSLWvDiUlxVd7lSdGPhEf7XWNVDI1q+NlfIuGpSfh3B62C9yYjxwMFlVt9kkmKBConwQv3iBuGryvXFGgEmsnElkNB0yifRqQDaOQHyXRDAeBiRSsCsa3xJZV8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WMQCSCoc; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WMQCSCoc"
Date: Fri, 2 Feb 2024 17:15:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706894156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MYEBTTVaj4LjB1JsKoRT880YU/NNwVUy2fGpHIyyHCM=;
	b=WMQCSCocO2jpsqQyh/xPp6PEGYA54CodshsWHHeIbG62TJHb4bbXoDt1liBQ1eQkxGmf1D
	3NhJI8LbyVsJJDWLjwX18D9KQ6xhMSjmAudbJxH+oopjNRytFit3YXrvuOCCzdBT1891B5
	v99uJxmf4uyEzYc4SpjyKYw2uyKKolE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 06/25] KVM: arm64: nv: Add sanitising to VNCR-backed
 HCRX_EL2
Message-ID: <Zb0jRzTYyc0IxR00@linux.dev>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-7-maz@kernel.org>
 <ZbytUKPFYiP2cdd8@linux.dev>
 <86h6iq7w3x.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h6iq7w3x.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 02, 2024 at 02:56:50PM +0000, Marc Zyngier wrote:
> No amount of warnings will do, because people don't give a damn.
> 
> I'm actually in favour of something far more radical: we snapshot the
> raw value of all the used RES0/1, and put BUILD_BUG_ON()s that fire if
> any value has changed. They will have to touch the KVM code to fix
> that, and we catch them red-handed.

Oh I like that a lot more.

> > 
> > > +	if (!kvm_has_feat(kvm, ID_AA64ISAR3_EL1, PACM, TRIVIAL_IMP))
> > > +		res0 |= HCRX_EL2_PACMEn;
> > > +	if (!kvm_has_feat(kvm, ID_AA64PFR2_EL1, FPMR, IMP))
> > > +		res0 |= HCRX_EL2_EnFPM;
> > > +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
> > > +		res0 |= HCRX_EL2_GCSEn;
> > > +	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, SYSREG_128, IMP))
> > > +		res0 |= HCRX_EL2_EnIDCP128;
> > > +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, ADERR, DEV_ASYNC))
> > > +		res0 |= (HCRX_EL2_EnSDERR | HCRX_EL2_EnSNERR);
> > > +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, DF2, IMP))
> > > +		res0 |= HCRX_EL2_TMEA;
> > > +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
> > > +		res0 |= HCRX_EL2_D128En;
> > > +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
> > > +		res0 |= HCRX_EL2_PTTWI;
> > 
> > Ok, not fair. The latest public version of the ARM ARM doesn't have any
> > of this. Where are you getting it from?
> 
> The bloody XML, from which all of this should, in theory, be extracted
> without any human intervention. Sadly, it seems that we are not
> allowed to do so, from what I have been told.
> 
> The ARM ARM is, unfortunately, being quickly rendered obsolete by the
> lack of updates (FEAT_THE is part of the v9.4 architecture, released
> in 2022).

Ah, got it. Thanks both for the reference. That really sucks though!

-- 
Thanks,
Oliver
