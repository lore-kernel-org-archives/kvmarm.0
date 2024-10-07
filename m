Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA351DD861
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 19:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728328817; cv=none; b=jg3bXG1siBFUl1LamSKg8L24YYtkxpLCJGXVt4J5iaDyUa35M46GhGs7lJNEZZgAFu2Jhr7qWebqCDErrVd0nK8Wsmxdig+bCmU58iL1axEet0538uhDY3bdAGf7zwQuAxJo4/X4Ru4UKWKDGGsWwQhqUbBCDZ1y1uiOjjwv+oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728328817; c=relaxed/simple;
	bh=HUdiwu1sWV9JWeQpehiSSMlhEVUTV8nkPRJpujsaJr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QjmL8/qYaqkw1eUfuZAavNrSozhpy2LpUxySZ+CptbDneiyDtMvr+p6jYJn5ueFYjbSIlYmW8SV31tbiWr0zSGZ8rQ8LnWlgfMd0+glW+UNEgxdnQq3jyzUiTa78QhdI8oZRxJaiQcx291c2wFZEz0doKiEYJND+XuuQnOHj5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JBNdut2e; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JBNdut2e"
Date: Mon, 7 Oct 2024 19:20:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728328813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uF60bbIjOKn4q49X9M368w0/nWAqo5VANFpL/TDEjYA=;
	b=JBNdut2eitcLSzmM/vEZ3WMvtv/5VwWvxDJGfsT4Dd4cP3l5l0n4wifUC4D4C86fboSWPU
	wHbR1fTHx7ae9HlBE4eRoa8hiaFiyCmXDyuOBkqi4dTMnF3u37o8lPPRJoSFbV1XXgsGNP
	wv33UspCp4gv8lcAQ+hFHoQAB3w8hmg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: nv: Clarify safety of allowing TLBI
 unmaps to reschedule
Message-ID: <ZwQ0ZJk2wfQIwyjN@linux.dev>
References: <20241007164256.1795250-1-oliver.upton@linux.dev>
 <20241007164256.1795250-5-oliver.upton@linux.dev>
 <ZwQtuQ4mU-i3kY4i@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwQtuQ4mU-i3kY4i@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 07, 2024 at 11:51:37AM -0700, Sean Christopherson wrote:
> On Mon, Oct 07, 2024, Oliver Upton wrote:
> > There's been a decent amount of attention around unmaps of nested MMUs,
> > and TLBI handling is no exception to this. Add a comment clarifying why
> > it is safe to reschedule during a TLBI unmap, even without a reference
> > on the MMU in progress.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index e0c7cc16466e..b773d107cd35 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2955,6 +2955,29 @@ union tlbi_info {
> >  static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
> >  			       const union tlbi_info *info)
> >  {
> > +	/*
> > +	 * The unmap operation is allowed to drop the MMU lock and block, which
> > +	 * means that @mmu could be used for a different context than the one
> > +	 * currently being invalidated.
> > +	 *
> > +	 * This behavior is still safe, as:
> > +	 *
> > +	 *  1) The vCPU that recycled the MMU is responsible for invalidating
> > +	 *     the entire MMU before reusing it, which still honors the intent
> > +	 *     of a TLBI.
> 
> I think it's worth calling out that other vCPUs that want to reuse the "new" MMU
> will also ensure the entire MMU is invalidated before reusing it, and maybe even
> that multiple vCPUs can participate in recyling an MMU.  The "The vCPU" wording
> is probably going to be interpreted by most readers as meaning only _one_ vCPU
> will ensure the MMU is invalidated.

I'm going to s/vCPU/vCPU(s)/ this block, but I'll leave any other detail
of how recycling works at the point it gets inflicted on potentially
more than one vCPU.

-- 
Thanks,
Oliver
