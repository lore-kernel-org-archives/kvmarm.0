Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C1904963B7
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779195420; cv=none; b=U/fGzGnNZcj+KQL2nFr5YO7RTJ8hwR9bFeHB4GEh7ROugJQ1BgVBdKUQhatVyUvPX1ig55l4q5QBIzNES3Isl4J9m9OcEMv/fBBC9qn0cColMO3dHT+/GhPh2pMw0cdn3NRsfJAC+2AB9gPG7lN4z0uUEe3Uhalj3ZiJPiAqJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779195420; c=relaxed/simple;
	bh=uFXN63M6oomAV1p7S8fr6m5nzqQT8/Btt+JUqxPdLE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=MUPkHGToHj7q4kS45nXlpx5YIY12ZyCkiVOAcr5ZsS8AouwzVnC2WcrRNOPuOITYTeO1Y+EbfqZDONeu+XtcwcvWW7JxaVI3MkW31Qv238dLtdSWUrnfqg1/isZLVC77dgGBpgbbeUxbRBH0LxZRzvQJswQfx/PN/P60WpXiImI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hCnPifhD; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hCnPifhD"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BFD722FA;
	Tue, 19 May 2026 05:56:52 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6EA63F85F;
	Tue, 19 May 2026 05:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779195417; bh=uFXN63M6oomAV1p7S8fr6m5nzqQT8/Btt+JUqxPdLE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCnPifhD6GJEbWGa2HRF2205tvabhxVReW4owSlp3i+aAukutLgQ/9s3+qlU8x5K5
	 B0YRa8w7A2mw5NJS993dWD5PaLeYJcpGzNfe5hG1Tb+K1C+saTb9PA28H86jMjX+ZG
	 inczeUBSrHMOb4CeL6/WwX9m9seCvz263+HgMai8=
From: Leonardo Bras <leo.bras@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: Introduce S2 walker SKIP return options
Date: Tue, 19 May 2026 13:56:48 +0100
Message-ID: <agxeEA14cP3yMV1m@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <agxa-TydN1PoKsYn@willie-the-truck>
References: <20260515195904.2466381-1-leo.bras@arm.com> <20260515195904.2466381-2-leo.bras@arm.com> <agq-RyKhBy4CIThm@kernel.org> <agrTQMw4QJX6HGrm@willie-the-truck> <agsYF-Dav2bpxWK4@devkitleo> <agxa-TydN1PoKsYn@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 19, 2026 at 01:43:37PM +0100, Will Deacon wrote:
> On Mon, May 18, 2026 at 02:45:59PM +0100, Leonardo Bras wrote:
> > Hello Oliver, Will,
> > Thanks for reviewing!
> > 
> > On Mon, May 18, 2026 at 09:52:16AM +0100, Will Deacon wrote:
> > > On Mon, May 18, 2026 at 12:22:47AM -0700, Oliver Upton wrote:
> > > > On Fri, May 15, 2026 at 08:59:02PM +0100, Leonardo Bras wrote:
> > > > > Introduce S2 walker return values:
> > > > > - SKIP_CHILDREN: skip walking the children of the current node
> > > > > - SKIP_SIBLINGS: skip waling the siblings of the current node
> > > > > 
> > > > > Also, modify __kvm_pgtable_visit() to fulfil the hing on above return
> > > > > values. Current walkers should not be impacted
> > > > 
> > > > I'd rather see something based around new walk flags than introducing an
> > > > entirely new mechanic around return values.
> > > > 
> > > > e.g. you could split the LEAF flag into separate flags for blocks v.
> > > > pages:
> > > > 
> > > > 	KVM_PGTABLE_WALK_PAGE,
> > > > 	KVM_PGTABLE_WALK_BLOCK,
> > > > 	KVM_PGTABLE_WALK_LEAF	= KVM_PGTABLE_WALK_PAGE |
> > > > 				  KVM_PGTABLE_WALK_BLOCK,
> > > > 
> > > > and then let __kvm_pgtable_visit() decide how to steer the walk. You may
> > > > need some special handling to get the address arithmetic right when
> > > > skipping over a table of page descriptors.
> > 
> > I am probably not getting the whole inner workings of this solution, but 
> > IIUC the idea would be to walk the blocks, but not the pages, right?
> > 
> > Blocks meaning level2- and pages being level3?
> >  
> > > I was wondering along similar lines, but maybe it would be useful just
> > > to pass a maximum level to the walker logic? That feels like the most
> > > general case without complicating the existing logic.
> > 
> > This proposal seems simpler for me to understand, and indeed looks like a 
> > better solution than what I have proposed, taking care of  the 
> > 'already split' case with better performance, as it don't even walk a 
> > single level-3 entry. 
> > 
> > On the 'splitting' case, it also works flawlessly if the memory is given in 
> > level-2 blocks. There is only one case that I would like to address here:
> > 
> > - Memory given in level-1 blocks (say 1GB)
> > - Walker flag says 'walk down to level-2 only'
> > - Split Walker on level-1 will break page down to (up to) level-3 entries.
> > - Walker will continue to be called on level-2 entries, even though it's 
> >   not necessary.
> 
> If you're only visiting leaves, why would it be called on the level-2
> table entries?
> 

Because once the leaf is turned into a table by the splitting walker, it 
gets reloaded and walked. This is an excerpt of __kvm_pgtable_visit():

---

if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
         ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
         reload = true;
 }

 /*
  * Reload the page table after invoking the walker callback for leaf
  * entries or after pre-order traversal, to allow the walker to descend
  * into a newly installed or replaced table.
  */
 if (reload) {
         ctx.old = READ_ONCE(*ptep);
         table = kvm_pte_table(ctx.old, level);
 }

 if (!kvm_pgtable_walk_continue(data->walker, ret))
         goto out;

 if (!table) {
         data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
         data->addr += kvm_granule_size(level);
         goto out;
 }

 childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
 ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
 if (!kvm_pgtable_walk_continue(data->walker, ret))
         goto out;

---

After the leaf is visited, it makes reload=true, which causes the newly 
created table to be detected as such and waked down. It means even the page 
that just got split will be walked down to the specified level.

Example:
- Split this level-1 leave:
  - Walker creates the whole structure up to given level (currently 3)
  - Walker returns, gets reloaded, table detected, go down on that one
  - Level 2 entries walked (which is unnecessary)

Please let me know if I am misunderstanding something.

Thanks!
Leo
