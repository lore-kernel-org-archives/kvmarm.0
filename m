Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DC9226CF3
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 08:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750752752; cv=none; b=WSOf744J2ep1aPkwCkEaDqbP9waGyx2PrG68V1FR/LEYpl4yCjZF7dY33IloQMX6kvRmIMVaiYHMKWz3uuaBSNTvOhanrJ1Fs+orI4oRYpdo+yV0Nug9z0VUSFNNq09btR/FuZHw+x742IAsIGKfyrftWQgxjSj7KJ+joXdScRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750752752; c=relaxed/simple;
	bh=ylX8IM7p3jzCV03TZYcy+ty2S7gBcJAFH21OA0LGKME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRewoEdwvCs8/qF3MPUbPfWra1KQfetB9u+LlDr29WKjaPlnqV98B3gKjAB/DExzza0nBchk8qvr7c5eWgkOWjpPz/Q/CLt/Qbirt1tfGMlmvPu9YKqwiPlGL1tCl+kuTEgsDk9v6YbnWxJJCjkdV/kx+4Kfa3Ceb7GRWSRF5fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MRTkbLK4; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MRTkbLK4"
Date: Tue, 24 Jun 2025 01:12:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750752748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cedj1kBNsQHfa/B9s3D6TFagUS33WIFC4uIHRIWvzl0=;
	b=MRTkbLK47S5o553lE2spGTpbAsUqzsSWny/PIiat/onnoCbtSj4CaH1XyeRJqPTv0/8hak
	zl/fpkzO511F0E4R2wjgXo8OMM9KGgyRIKJJe9IUhx3bnOHOdZt1LW960kanM8FuVFsSH3
	6mKY4gQGoy5MF/ohlue9tUd615qOYWM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 17/27] KVM: arm64: Route SEAs to the SError vector
 when EASE is set
Message-ID: <aFpd2aVS-nqULCjT@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
 <20250616230308.1192565-18-oliver.upton@linux.dev>
 <86a561cntt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a561cntt.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 21, 2025 at 12:54:06PM +0100, Marc Zyngier wrote:
> On Tue, 17 Jun 2025 00:02:58 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > One of the finest additions of FEAT_DoubleFault2 is the ability for
> > software to request *synchronous* external aborts be taken to the
> > SError vector, which of coure are *asynchronous* in nature.
> > 
> > Opinions be damned, implement the architecture and send SEAs to the
> > SError vector if EASE is set for the target context.
> 
> As they say, there is no accounting for taste! :)
> 
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/emulate-nested.c |  3 +++
> >  arch/arm64/kvm/hyp/exception.c  |  6 +++++-
> >  arch/arm64/kvm/inject_fault.c   | 38 ++++++++++++++++++++++++++++++++-
> >  3 files changed, 45 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> > index 86c9a48fc8b6..7f9081c6ab11 100644
> > --- a/arch/arm64/kvm/emulate-nested.c
> > +++ b/arch/arm64/kvm/emulate-nested.c
> > @@ -2833,6 +2833,9 @@ int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
> >  			     iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
> >  	esr |= ESR_ELx_FSC_EXTABT | ESR_ELx_IL;
> >  
> > +	if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
> > +		return kvm_inject_nested(vcpu, esr, except_type_serror);
> 
> Are we allowed to not set FAR_EL2 here? My reading of R_RYXCL is that
> only the exception vector changes, not what is reported.
> 
> But the spec is clear as mud, and I wonder if I'm reading too much
> into it.

This was an oversight on my part. My interpretation is similar to yours,
where EASE allows software to choose the regular or spicy exception
vector but preserves the rest of the exception context.

I've wound up fixing this by way of unhitching from kvm_inject_s2_fault()

Thanks,
Oliver
