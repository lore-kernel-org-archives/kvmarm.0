Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648FA182B7
	for <kvmarm@lists.linux.dev>; Sat, 31 May 2025 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748713881; cv=none; b=TWTi6whoLuGEacLWUAA3WjjZFrF4ObO6mRIJkQC120AA0M8kAWr/8nMaNM6z84VqezAULiW5G3ppVY8uv3aL+RY38RkUNADbR6jegzhaMz9kiMvOOTJ7LefKTibkZuSmfBsXm3avZ253F8lAvcuLEHWM7Oxj+r8KFJWqzs3z+Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748713881; c=relaxed/simple;
	bh=M1nthUqlA0AKVMttPqJfU22jNUVqcQlvoBBH/Qm/ZTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SaW0QRYpiaCRbmkQqrFPmHqXbMY57kISkJVKp9rY8/Fe4ISrJzEeHxo1Zdup2pjSIV0etp74Mp+zg66wIaQAmO5pOdHnTHrSvq79vXaaw/FwHFriwSztIFxsICb1XF5IDE0k/1f8vX4WbSl/Y/DXYRC4bswt2tdAcaBP77GfwFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OeYPAIO4; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OeYPAIO4"
Date: Sat, 31 May 2025 10:51:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748713876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29SUBP1Yep/oipMWdHz+OR6CW8bpsF0erup2vmt0dis=;
	b=OeYPAIO4RJczy20YNjgTMOSVwkPOAp+3QgCNpa8ORhylXp29y1mzsMbIgpp5jQKzCBD55q
	5fV/Gdw0b73hwQ23vUh9BsfsbAB4Dfcf0vhnRhZ4Nxw2ykyo9toqzNYTgg67ElgKpp4P5l
	ywWy4yLfnQYYyLlXaksSzo1t1NKQcr4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/4] KVM: arm64: nv: Respect exception routing rules for
 SEAs
Message-ID: <aDtBjCyHdGPW6nJv@linux.dev>
References: <20250530230623.650888-1-oliver.upton@linux.dev>
 <20250530230623.650888-2-oliver.upton@linux.dev>
 <87r004eokv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r004eokv.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Sat, May 31, 2025 at 05:23:44PM +0100, Marc Zyngier wrote:
> > +int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
> > +{
> > +	u64 esr;
> > +
> > +	/*
> > +	 * The destination EL is in the same translation regime as the origin;
> > +	 * directly inject the SEA.
> > +	 */
> > +	if (is_hyp_ctxt(vcpu) || !(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_TEA)) {
> > +		__kvm_inject_sea(vcpu, iabt, addr);
> > +		return 1;
> > +	}
> 
> I find this a bit confusing.
> 
> Here, we end-up *not* injecting a nested exception, but instead
> delivering it in context. I think it would be clearer to move this
> condition in kvm_inject_sea(), and then make __kvm_inject_sea()
> static.

So I went about it this way because I didn't like having NV-specific
triage outside of the nested code, though I agree the meaning of this
helper is a bit muddied. The routing is simple now but...

> Other than my rambling above, this looks rather good. But there is a
> bit more, "thanks" to FEAT_DoubleFault2:
> 
> - HCRX_EL2.TMEA also affects this patch, both on the SEA and SError
>   paths (both can be routed to EL2 when masked).
> 
> - SCTLR2_EL{1,2}2.EASE also influence the delivery of the SEA,
>   upgrading it to a SError (yes, this is the routing from hell and
>   ties directly into the following patches).

This is gonna be an ugly pile to deal with later on. Anyway, I'll pull
apart the routing / emulated exception entry to keep in-context
injection out of NV coed.

> I was expecting to see FEAT_RAS being enabled at some point, but
> that's not the case yet. Are you planning to do so?

Yup, still planning on it. Just wanted to flush out bug fixes on list.

Thanks,
Oliver
