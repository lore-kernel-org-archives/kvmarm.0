Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208A74DBD67;
	Tue, 19 May 2026 12:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779194623; cv=none; b=fDQllmjGO3J1MdyJy4UJf6spfHMZ8l4AvnK3CpfdyoEd7b6J4pT3vfFCA+MSwgqgLH8Q5wumPCEeA6xMd9yW+x1vacdr0SRhniA+I69qH/CTfuXS3ESDYTM50c46vksE63vsmNWENWdP/mjq1cbyl9Qiej4edgXD6av5ii1B06g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779194623; c=relaxed/simple;
	bh=hmwbv3gqqbu9yBYmBx9zaYS9bABt+uvbkJGYxywxwzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C24P6xPeT9qOZK0exD9XkbrUUzP9Beeuwv9fJZCcwbvI5SOVS/kkHYMgWjCiVAMWgPgEibRqAsRbjhtzGdF84BLjoM8pvSXDxXJwQpZC0U7UBHiNJG0vrhyNeaHjWIhAr4z7ArHCOAMh/WZk9PwSyeGM9mCwhCOTMk0KC3N+8HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVE1YeOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVE1YeOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0E9C2BCB3;
	Tue, 19 May 2026 12:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779194622;
	bh=hmwbv3gqqbu9yBYmBx9zaYS9bABt+uvbkJGYxywxwzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rVE1YeOZV2XbKbVfX+FQ9bZc9J7twuHL/3/W1z+n+q07I1Z1Ko5baS4YO5TmKvyOK
	 rd9HoZ5sdQejOXx0oAlv0aSFMayjD0fK1gdCeJtdvMa6l7b0U1S8iLa1zPIimBPbJl
	 Ez+esnryZEKDSlLimDEo2/+DvY+XYihEdtvT47lsV4r91sOW8ktv/EI24ihElDFjdf
	 lWtKOMweX98zCjFdUlxYNRVm60qqDSEOiqwe1PC50Qx7JcztgWiKtG4i9MNCqERXdd
	 nHE3ocfqpp3I7DNWnI56vOKM9c9S2lEPiNqq4qnZ5A06o+mBagO1kvdjUYEw39MywW
	 N5r9RaC5RaNtA==
Date: Tue, 19 May 2026 13:43:37 +0100
From: Will Deacon <will@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: Introduce S2 walker SKIP return
 options
Message-ID: <agxa-TydN1PoKsYn@willie-the-truck>
References: <20260515195904.2466381-1-leo.bras@arm.com>
 <20260515195904.2466381-2-leo.bras@arm.com>
 <agq-RyKhBy4CIThm@kernel.org>
 <agrTQMw4QJX6HGrm@willie-the-truck>
 <agsYF-Dav2bpxWK4@devkitleo>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agsYF-Dav2bpxWK4@devkitleo>

On Mon, May 18, 2026 at 02:45:59PM +0100, Leonardo Bras wrote:
> Hello Oliver, Will,
> Thanks for reviewing!
> 
> On Mon, May 18, 2026 at 09:52:16AM +0100, Will Deacon wrote:
> > On Mon, May 18, 2026 at 12:22:47AM -0700, Oliver Upton wrote:
> > > On Fri, May 15, 2026 at 08:59:02PM +0100, Leonardo Bras wrote:
> > > > Introduce S2 walker return values:
> > > > - SKIP_CHILDREN: skip walking the children of the current node
> > > > - SKIP_SIBLINGS: skip waling the siblings of the current node
> > > > 
> > > > Also, modify __kvm_pgtable_visit() to fulfil the hing on above return
> > > > values. Current walkers should not be impacted
> > > 
> > > I'd rather see something based around new walk flags than introducing an
> > > entirely new mechanic around return values.
> > > 
> > > e.g. you could split the LEAF flag into separate flags for blocks v.
> > > pages:
> > > 
> > > 	KVM_PGTABLE_WALK_PAGE,
> > > 	KVM_PGTABLE_WALK_BLOCK,
> > > 	KVM_PGTABLE_WALK_LEAF	= KVM_PGTABLE_WALK_PAGE |
> > > 				  KVM_PGTABLE_WALK_BLOCK,
> > > 
> > > and then let __kvm_pgtable_visit() decide how to steer the walk. You may
> > > need some special handling to get the address arithmetic right when
> > > skipping over a table of page descriptors.
> 
> I am probably not getting the whole inner workings of this solution, but 
> IIUC the idea would be to walk the blocks, but not the pages, right?
> 
> Blocks meaning level2- and pages being level3?
>  
> > I was wondering along similar lines, but maybe it would be useful just
> > to pass a maximum level to the walker logic? That feels like the most
> > general case without complicating the existing logic.
> 
> This proposal seems simpler for me to understand, and indeed looks like a 
> better solution than what I have proposed, taking care of  the 
> 'already split' case with better performance, as it don't even walk a 
> single level-3 entry. 
> 
> On the 'splitting' case, it also works flawlessly if the memory is given in 
> level-2 blocks. There is only one case that I would like to address here:
> 
> - Memory given in level-1 blocks (say 1GB)
> - Walker flag says 'walk down to level-2 only'
> - Split Walker on level-1 will break page down to (up to) level-3 entries.
> - Walker will continue to be called on level-2 entries, even though it's 
>   not necessary.

If you're only visiting leaves, why would it be called on the level-2
table entries?

Will
