Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A38495056
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 20:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790195849; cv=none; b=r65FUxQLj2INkSu3mo4S4gc6Okc6gxuBZrapZoYZAyj3WE+7OCHL4MRdxKVlZPzntAmFrvf1L+C6McOCvfTEwLgob/+t++ymPzEXDUgCtJYxnFsKzoTtDmRyn6T6smlXR48PVwGwSj5dXBPMM+5FNtnQN8NiI+/wA3N+fUS87fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790195849; c=relaxed/simple;
	bh=VZoD9Cw692mi8oo2Q4R55ciuu7fQzd0p+mkAoYSaNhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORg1UXJ8gKn+Gs6DYKFQLo26fzwXJ81uoB0idfZI9q4DsI804xm4tbLNhFNgg/QojAkLbznpRxwerICtsgKjjpZrEK2A+YAaJGzK+4Rnvkfi8j5pxjG4Xy61GFToSR93XmULNtN4aODkzAmRh8aGolgElzU05b9wmNDNpXfalV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWBQhskt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWBQhskt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C751F000FF;
	Wed, 23 Sep 2026 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790195848;
	bh=dLxCAEvOkMTrrea+bUopJsFQA7EMgdPhQFWK5P7lVfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dWBQhsktu2ZEDkoNoO1D31FoKv7v+ItmNVp1BOzM3aCbQAuN2ZCS6NfNJl8S+HtTA
	 zNpoXFrDVx4j0CMMQ03k7gn98iAJl+tVEM0Lj7g3JV3MpTTznKsU7bPOD1r4oWPHkr
	 JSLGLNFO7XSJ8vrnwzjcEOxw/+9rdYjGyBUw/pe4mgqqGpwxyImxlE8idXwnESEcp3
	 heo5UQ+ahWITDJ3KH9kUT/1Rkats8yk1JtTsjwKKV5QGjdEqE00zoljXHbbkUogPsL
	 Z7lb2TDc0mJdW6U62Mlt2T54glWUMHfSlCD6sj6nY7LVSZGfEUFdxRXmDPAc0mk/6v
	 JIqcZv94p9Q0g==
Date: Wed, 23 Sep 2026 13:37:26 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 10/22] KVM: arm64: Plumb through access descriptor for
 stage-1
Message-ID: <arQ4hu4jKqGLM6BH@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-11-oupton@kernel.org>
 <arP8cIOl_SMyVRM8@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arP8cIOl_SMyVRM8@LeoBrasDK>

On Wed, Sep 23, 2026 at 05:21:04PM +0100, Leonardo Bras wrote:
> > @@ -1459,12 +1461,14 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
> >  
> >  	va =  read_vncr_el2(vcpu);
> >  
> > -	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, va);
> > +	access.type = WALK_ACCESS_NV2;
> > +	access.ia = va;
> > +	access.write = write_fault;
> 
> It's not clear on why we need the proxy var write_fault.

write_fault gets used immediately below when we fault in the PFN.

> > +
> > +	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, &access);
> >  	if (ret)
> >  		return ret;
> >  
> > -	write_fault = kvm_is_write_fault(vcpu);
> > -
> >  	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> >  	smp_rmb();
> >  
> > -- 
> > 2.47.3
> > 
> 
> IIUC:
> In general terms, change some function signatures to replace va to a struct 
> pointer that contains extra information, such as walk type and it being a 
> write fault.
> 
> On top of that, there are 2 extra kvm_walk_access flags added here, and I 
> see them being attributed, but no information on what they do different.
> 
> Since there are already flags being treated somewhere, maybe a patch just 
> adding these new flags and showing what they do differently on the 
> processing, then adding the remaining of this patch in a new one would make 
> them easier to understand. 
> 
> (I still haven't read what those flags do differently in the next patches, 
> but seems like a no-op at this point, even though it should be doing 
> something different here. Please help me understand if I am missing some 
> context)

As I mention in the changelog, I'm adding annotations to the stage-1
translation fetches so later changes to the PTW can emulate the correct
behavior based on the intent of the translation fetch. These prepatory
patches are split off to keep the whole series digestable, assuming a
degree of familiarity with nested.

Thanks,
Oliver
