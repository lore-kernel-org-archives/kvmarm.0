Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC053BC680;
	Tue, 30 Jun 2026 18:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782844984; cv=none; b=bHRBHAONQDkhufXnnas0IUfdqQy8F0mI4P+VkCOLL8z0299GRdwT/LKo2hi7HQElRoXAanXk/i54kFUaUBPinG2C36HHeW77JwnijLf2jYiLOGjz87s1lecLzIX524N1kpaca2Eu9ZOmCaS/9tPlEq/o6SDfOa/ww9w8QYUBSXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782844984; c=relaxed/simple;
	bh=KCpPnllPAwe9Z27cf/4FimUMcyNxdIrK1MgP/ku1r34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFpUSuIUFPPidwaSqzPyCwrNa97HYzJBAqFtqE/fXynVW3/eT3XQFrxi4oyyco7vza7sSrDDW8PujDutS9kEC9/5mjYZJZOrOekyQSzF1pwfW5vppBes4eoFeESyVPOuV/rX7WprF6cVqFjR5k6NKmWKWbJel+J/M+70sALKHBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQtWrNY6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQtWrNY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6874A1F000E9;
	Tue, 30 Jun 2026 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782844982;
	bh=oQ+QKmGqWrf4GF4IimLK8GVC3TpRZgBWH53NHUwQR9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NQtWrNY6deyk6hU0I6nlk4xSdhwxHXR6kR9B4J1sHsU6FnRp2n6GEO/jH3bNsx4xQ
	 Hl+pa43WV1nCLHUEpRdsJwFV5obDUWIqJbkI+UVSscYCYT2Z9vjt8zaCw9JAon8U9J
	 wiqkI67jof5FRKXkHetzhSr//hCaDgM14Tn601cxT7MlY+liS/bC6vYVX57Ltxm5B5
	 d7R1n0y5BJUJ87vGwq73g5/UwgcMIDIPDUF5fS9bYKAZ3LdkulFhDu8tIxMOnefWid
	 kOtkPEWL+FE8GMUnU9bja8mUEfopDaar4Y4+cTeWsG2ycAXC/eWU8LP65eOWp9jsBg
	 rLKJc+WuAT/Lg==
Date: Tue, 30 Jun 2026 11:43:01 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if
 HDBSS is available
Message-ID: <akQONWoRRZXu1-56@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-3-leo.bras@arm.com>
 <20260629113645.BE6801F000E9@smtp.kernel.org>
 <akKFlzAdB43lRpi1@LeoBrasDK>
 <akKmHqRaZEUjN3zY@kernel.org>
 <akO9iHJmKN7MzTjM@LeoBrasDK>
 <akPkVASjWWYQpkx1@kernel.org>
 <akP4ZDjZIu2_CfVF@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akP4ZDjZIu2_CfVF@LeoBrasDK>

On Tue, Jun 30, 2026 at 06:09:56PM +0100, Leonardo Bras wrote:
> On Tue, Jun 30, 2026 at 08:44:20AM -0700, Oliver Upton wrote:
> > On Tue, Jun 30, 2026 at 01:58:48PM +0100, Leonardo Bras wrote:
> > > On Mon, Jun 29, 2026 at 10:06:38AM -0700, Oliver Upton wrote:
> > > > > But this raises a topic I would like to understand:
> > > > > - Do we actually need this to be a block_size to assure correctness? or is 
> > > > >   it just about efficiency?
> > > > 
> > > > What value is there in having a chunk size larger than the largest
> > > > possible block mapping? The whole UAPI is deliberately tied up with page
> > > > table geometry.
> > > 
> > > Not larger, possibly smallerv My concern was the difference in pages to 
> > > split between 4k, 16k and 64k.
> > 
> > Ok, well in any case the upper bound is going to be the largest possible
> > block mapping for a given page granule.
> >
> 
> Sure, we can do this.

I'm describing the UAPI behavior of what we already have. Please do not
change anything and continue to leave userspace in charge of eager
splitting / chunk size.

> > > > 
> > > > Overall, I'm not buying the argument for changing the behavior of
> > > > KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE. There are very good reasons for
> > > > *not* eagerly splitting the entire address space, especially if you know
> > > > the working set of the VM is small.
> > > > 
> > > > You can still use HDBSS without eagerly splitting, so long as block
> > > > mappings are {DBM, S2AP_W} = {0, 0} and leaf mappings (which have
> > > > a writable PFN) are {1, 0}.
> > > > 
> > > 
> > > Block mappings being read-only, and leaf mappings being writable-clean, 
> > > then? Could you please ellaborate on why does not it need eager-split?
> > 
> > Read-only translations will continue to generate permission faults
> > whereas writable-clean descriptors can be updated by hardware. You get
> > the opportunity to split a block mapping lazily while preserving
> > hardware dirty tracking for page mappings.
> > 
> 
> So you suggest we only enable DBM bit after we split the block, that will 
> happen only after a block is dirtied for the first time after dirty-log 
> starts? 

If the VMM wants to do lazy splitting, yes. Otherwise this would happen
as part of eager page splitting for block mappings that are known to be
writable.

> > The approach I think we may need is:
> > 
> >  - Use a software bit in the PTE to stash whether or not a PFN is
> >    'software-writable' when constructing the stage-2. By this I mean
> >    we've already faulted it in for write from the primary MMU.
> > 
> >  - At the time of write protection, reap the hardware-writable state
> >    from all PTEs but preserve the software-writable bit.
> > 
> >  - Whenever splitting a block mapping, set the DBM bit in the page-level
> >    PTEs if the block was software-writable and HDBSS is present.
> > 
> > That way you'd have sufficient metadata in the PTE to safely set DBM.
> 
> I remember that, for some reason I can't recall, it would not be great to 
> set DBM during dirty-log start, and instead we should have it since VM 
> creation. Maybe it had to do with part of the pagetable using the old 
> encoding (no DBM), and the other part using the new one.
> 
> IIRC, only blocks that are backed by writable memory (S1) were supposed to 
> receive the DBM bit. We could use that info for deciding what to split, 
> then.

That's why I'm saying to use a software bit. We can't leave DBM=1 on
block mappings and set VTCR_EL2.HD=1 for obvious reasons.

> Another option would be to split when we are collecting a dirty-entry from 
> HDBSS, but for live migration that would mean we have to transfer the whole 
> block (possibly a large LEVEL1 block), because we have no idea which part 
> of it got dirty.

We need to do dirty tracking at page granularity. The only scenario
where we have writable block mappings while dirty logging is enabled on
a memslot is if the VMM enabled KVM_DIRTY_LOG_INITIALLY_SET.

Thanks,
Oliver
