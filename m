Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D79F3DB314;
	Tue, 30 Jun 2026 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782839408; cv=none; b=UsqPxFtJ3C1nVoB8GtOs7eo48/T26nl9dYmXYvxYUu9W364jSwUSW9YyuElOKwAZJ5gsLucOeb3PF5xTpUGmTi/3eJ7/ZqIxho5FSAW/HyGI/++0pl6KfqleDBOto2pBMDMPSY1bfG/Qw9rxNdzI9ZcvXB/9euPFnN65r2hQmkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782839408; c=relaxed/simple;
	bh=GQ5TAATdTtEZez2bd2plLJw/FfHF2+SUgUr0QRwrwIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=GZzxYIhhzUpeCEFLGaXrFn0ZqAoOmb5bnn7Oc/M8fuKYyEblIbgXSXCorOQmpT33jXYi/IrprFbrYCTuDcGxImfFIvkJBvhVW3pSarvI1pHj8f9DRmosdR0H4ecwim5HFs2KvLda012eDhlRSbyRaYzvvp8QmnvFdvRIhEq96hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qHZQc8/b; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qHZQc8/b"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5458D302A;
	Tue, 30 Jun 2026 10:10:01 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9BB73F66F;
	Tue, 30 Jun 2026 10:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782839405; bh=GQ5TAATdTtEZez2bd2plLJw/FfHF2+SUgUr0QRwrwIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHZQc8/bqGgDn3Ev58frl/L6K0QLBurAvqg9mc3KeGIR3omWh5X9QdiPyy/jnRtLA
	 b6QQj+NqGvHSpXMUyYKhk8jskapUnnrgQqYp0I5B9w3dODj4v691tNX9D8EgTOv3bV
	 ZTPoWotFr8DVUQFtdQ1BwheR9CJgxVghLJ0vkRV0=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	sashiko-reviews@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if HDBSS is available
Date: Tue, 30 Jun 2026 18:09:56 +0100
Message-ID: <akP4ZDjZIu2_CfVF@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <akPkVASjWWYQpkx1@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-3-leo.bras@arm.com> <20260629113645.BE6801F000E9@smtp.kernel.org> <akKFlzAdB43lRpi1@LeoBrasDK> <akKmHqRaZEUjN3zY@kernel.org> <akO9iHJmKN7MzTjM@LeoBrasDK> <akPkVASjWWYQpkx1@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 30, 2026 at 08:44:20AM -0700, Oliver Upton wrote:
> On Tue, Jun 30, 2026 at 01:58:48PM +0100, Leonardo Bras wrote:
> > On Mon, Jun 29, 2026 at 10:06:38AM -0700, Oliver Upton wrote:
> > > > But this raises a topic I would like to understand:
> > > > - Do we actually need this to be a block_size to assure correctness? or is 
> > > >   it just about efficiency?
> > > 
> > > What value is there in having a chunk size larger than the largest
> > > possible block mapping? The whole UAPI is deliberately tied up with page
> > > table geometry.
> > 
> > Not larger, possibly smallerv My concern was the difference in pages to 
> > split between 4k, 16k and 64k.
> 
> Ok, well in any case the upper bound is going to be the largest possible
> block mapping for a given page granule.
>

Sure, we can do this.

I was worried because that would mean dealing, per granule, with 256k pages 
in PGSIZE 4k, a 4M pages in PGSIZE 16k, an 64M pages in PGSIZE 64k. 
Those are values with different orders of magnitude, and I worried that it 
would take too long, or require too much cache for a single run.

But if you think that's ok, sure then. 


 
> > > 
> > > Overall, I'm not buying the argument for changing the behavior of
> > > KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE. There are very good reasons for
> > > *not* eagerly splitting the entire address space, especially if you know
> > > the working set of the VM is small.
> > > 
> > > You can still use HDBSS without eagerly splitting, so long as block
> > > mappings are {DBM, S2AP_W} = {0, 0} and leaf mappings (which have
> > > a writable PFN) are {1, 0}.
> > > 
> > 
> > Block mappings being read-only, and leaf mappings being writable-clean, 
> > then? Could you please ellaborate on why does not it need eager-split?
> 
> Read-only translations will continue to generate permission faults
> whereas writable-clean descriptors can be updated by hardware. You get
> the opportunity to split a block mapping lazily while preserving
> hardware dirty tracking for page mappings.
> 

So you suggest we only enable DBM bit after we split the block, that will 
happen only after a block is dirtied for the first time after dirty-log 
starts? 

> > As a review, what I recall from the strategy for hw dirty-logging was:
> > - If we have HDBSS, add DBM for all writable pages {1, 1}
> > - On dirty-logging start, make them writable-clean {1, 0}
> >   - Can be done using HACDBS
> >   - Enable HDBSS & HAFDBS
> > 
> > We don't have a fault for making pages dirty anymore, as this is done 
> > by HAFDBS and recorded by HDBSS, so splitting does not happen on demand 
> > anymore. So if we want to split pages, for better tracking granularity, or 
> > anything, we have to eager-split them.
> 
> What I'm saying is the presumption that eager page splitting is always a
> net-win is wrong. Nor is eager page splitting a hard requirement for
> using HDBSS since you can set up the stage-2 in such a way that only
> page granularity mappings are dirtied by hardware.
> 
> You could, in theory, have a workload that is read-heavy for a majority
> of the VM's address space and writes to only a subset of that memory.
> Eagerly splitting pages would likely regress the workload from a higher
> rate of TLB refills / more TLB walk steps.
> 
> Lazily splitting would have the effect of leaving block mappings in
> place for most of the VM. This is exactly why the VMM is in the driver
> seat for deciding whether to lazily or eagerly split the stage-2.
> 

I see your point.

> The approach I think we may need is:
> 
>  - Use a software bit in the PTE to stash whether or not a PFN is
>    'software-writable' when constructing the stage-2. By this I mean
>    we've already faulted it in for write from the primary MMU.
> 
>  - At the time of write protection, reap the hardware-writable state
>    from all PTEs but preserve the software-writable bit.
> 
>  - Whenever splitting a block mapping, set the DBM bit in the page-level
>    PTEs if the block was software-writable and HDBSS is present.
> 
> That way you'd have sufficient metadata in the PTE to safely set DBM.

I remember that, for some reason I can't recall, it would not be great to 
set DBM during dirty-log start, and instead we should have it since VM 
creation. Maybe it had to do with part of the pagetable using the old 
encoding (no DBM), and the other part using the new one.

IIRC, only blocks that are backed by writable memory (S1) were supposed to 
receive the DBM bit. We could use that info for deciding what to split, 
then.

Another option would be to split when we are collecting a dirty-entry from 
HDBSS, but for live migration that would mean we have to transfer the whole 
block (possibly a large LEVEL1 block), because we have no idea which part 
of it got dirty.



> We
> could even make use of that metadata for write faults on non-HDBSS
> hardware to avoid the overheads of user_mem_abort() (e.g. VMA lookup)
> and treat it more like access flag updates.
> 
> The last point still needs some thought.
> 

I don't quite understand this yet. But will take a look on how would that 
work.


Thanks!
Leo
