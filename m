Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA71A37E30F
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785752522; cv=none; b=k7kUohVeGcAWZYZ5+B6+86ymzGbMVz6U4s7qpjrox1xeOjQ1Zff5MB7l7dEqhpS1umrq1sKztcUogfzhdVptTlkNphjrs8rr3med8YBQY1CmT9aGwvoRtRXsOw1vwgFIL9u58qtk8IbViQS3z0srEDesr2oTPc21wF2vaiBava4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785752522; c=relaxed/simple;
	bh=T5w0v9rfwNZ18adtnKbU/0CMXKOXeL+Y4L5j8xut1SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=uPOlVa8vjaJqd+DbkUCPjZTvlgGGsyfP9BDq3bC6rwd98NOyosZbfS2jM0hXYxnr+QMj2wREek0JLpUwTvPZxh43Ow7JFEnlA2Zuw1oHykmgNTx3e2RfRuFMED5NeiLGxImbc66z+H8EHLxAgdBuBKyycLGuFOSc4SMamM5bSe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i8ywRjfv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i8ywRjfv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A2041682;
	Mon,  3 Aug 2026 03:21:56 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0A373F632;
	Mon,  3 Aug 2026 03:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785752520; bh=T5w0v9rfwNZ18adtnKbU/0CMXKOXeL+Y4L5j8xut1SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8ywRjfv1yVSdfWNbPKYwzdo8jaLeLqQsWGuggP+pXRjqpvSaV+t8tEaQNZqeFQKR
	 jqLgczo8JpPOlAUv2T0pCz/w3wqNHk0K//ts+npHTy7Tc9gelMNoUZgZwI8st8STGt
	 dIyd5Eh/K7B//apc/1seKU82S1GQh4sgEI+zP+Z8=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware dirty tracking
Date: Mon,  3 Aug 2026 11:21:48 +0100
Message-ID: <anBrvILpcSFhW7Wg@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <45d76d0d-48e9-46a6-b1f9-691f840eba46@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-4-zhengtian10@huawei.com> <aliKo7dTZzKcWHzI@kernel.org> <0943eb14-9ffb-4dbb-9219-060e97bca2a7@huawei.com> <alpIfIOFfrudBzD5@LeoBrasDK> <al4bYajWE-v6wofu@LeoBrasDK> <96516762-f004-4c2a-a9c6-6fbad49ad6ae@huawei.com> <amoZY8uGLf1PEpjK@LeoBrasDK> <8e36e2c8-587f-4228-ab13-d6783927a281@huawei.com> <45d76d0d-48e9-46a6-b1f9-691f840eba46@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Aug 03, 2026 at 12:04:24PM +0800, Tian Zheng wrote:
> 
> 
> On 8/3/2026 9:33 AM, Tian Zheng wrote:
> > > > > > > > 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
> > > > > > > > > -    if (prot & KVM_PGTABLE_PROT_W)
> > > > > > > > > +    if (prot & KVM_PGTABLE_PROT_W) {
> > > > > > > > >             set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > > > > > > > > 
> > > > > > > > > +        /*
> > > > > > > > > +         * No DEVICE filter needed here:
> > > > > > > > > relax_perms is only called
> > > > > > > > > +         * on FSC_PERM faults. Device pages
> > > > > > > > > always get full RW from
> > > > > > > > > +         * initial mapping and are never write-protected during
> > > > > > > > > +         * migration, so they never trigger a permission fault.
> > > > > > > > > +         */
> > > > > > > > > +        if (pgt->flags & KVM_PGTABLE_S2_DBM)
> > > > > > > > > +            set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > > > > > > > > +    } else {
> > > > > > > > > +        /*
> > > > > > > > > +         * Clear DBM on W→RO downgrade to prevent hardware from
> > > > > > > > > +         * silently upgrading RO+DBM back to W+dirty, which would
> > > > > > > > > +         * bypass KVM's write tracking and cause data corruption.
> > > > > > > > > +         */
> > > > > > > > > +        clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > > > > > > > > +    }
> > > > > > > > > +
> > > > > > > > This block makes it pretty evident that the DBM bit really *is* the
> > > > > > > > write permission bit. I'd much rather we
> > > > > > > > introduce the concept of dirty
> > > > > > > > state to the page table library and migrate the abstract write
> > > > > > > > permission to the DBM field, even if we don't have FEAT_HAFDBS.
> > > > > > > > 
> > > > > > 
> > > > > > Ohh, that's an amazing idea!
> > > > > 
> > > > > Thinking about that again...
> > > > > If we adopt the encoding with DBM being the write-permission
> > > > > bit, and all
> > > > > PTEs have it since the start, how can we have lazy-splitting happening?
> > > > > 
> > > > > Only way I think of is removing both DBM and S2_S2AP_W bit
> > > > > from writable
> > > > > PTEs during dirty-track enable, and re-adding them during
> > > > > the first write
> > > > > fault. If we don't remove the DBM bit, systems with HDBSS
> > > > > would just dirty
> > > > > it by hardware, without causing a fault.
> > > > > 
> > > > > DBM=0 would need to happen only in the first write-protect (only on
> > > > > lazy-splitting). All other write-protecting would just clean
> > > > > the S2_S2AP_W
> > > > > bit, as everything is already split.
> > > > > 
> > > > > Is that what was intended?
> > > > > 
> > > > > Thanks!
> > > > > Leo
> > > > > 
> > > > Hi Leo,
> > > > 
> > > > I think the cleanest way to handle this is to simply avoid setting DBM
> > > > on block mappings. If we only set DBM on page-level PTEs, then block
> > > > mappings will naturally stay DBM=0 and trigger a write fault on first
> > > > access — exactly what we need for lazy splitting.
> > > > 
> > > > When the fault occurs, the block gets split into page-level PTEs, and at
> > > > that point we can set DBM=1 on the resulting leaf entries. This way:
> > > > 
> > > > 1. Lazy split works naturally (fault -> split -> set DBM=1)
> > > > 
> > > > 2. No need to clear DBM globally at dirty-track enable
> > > > 
> > > > 3. No special handling for block mappings
> > > > 
> > > > So I think global DBM is still viable — we just need to filter out block
> > > > mappings when setting the DBM bit. That way the lazy split path
> > > > is preserved
> > > > without extra complexity.
> > > 
> > > Hi Tian,
> > > 
> > > Humm, but would not that be contrary to what Oliver suggested:
> > > changing the
> > > encoding from the PTE for all entries?
> > > 
> > > (Like, if the PTE is writable, it has to have DBM set)
> > > 
> > > IIUC what you said, on first faulting of the page in the VM:
> > > - If the entry is a page (level-3 leaf) and writable, add DBM
> > > - If it's a block entry (leaf but not a level-3), don't add DBM
> > > 
> > > So after we enable dirty-logging:
> > > - a level-3 entry would not fault, using HDBSS, and
> > > - a block entry would fault, do the splitting, and add DBM to level-3
> > >    entries during the split.
> > > 
> > > If I got that correct, that would be clean indeed.
> > > 
> > > But then we would have a different encoding for block entries and page
> > > entries. In page entries, DBM could be used to say if the page is
> > > writable,
> > > but on block entries one would have to look at the 'dirty-bit'.
> > > 
> > > Would that be ok?
> > > 
> > > Thanks!
> > > Leo
> > > 
> > Hi Leo,
> > 
> > My initial concern was that clearing all DBM bits at the start of
> > migration would be too expensive, so I thought distinguishing between
> > level-3 entries and block entries would be better.
> > 

I think we expect it to be expensive, but since we already clean the 
dirty-bit (ro/rw) bit, we can have both happening in the same write :)

(since we only mark the DBM bit when we fault the memory on lazy-splitting, 
we are expecting to have the same amount of writes to pagetable as we have 
before HDBSS, both on faulting and 1st iteration cleaning)


> > However, I ran a quick test on a 400GB VM (4 vCPUs), and the overhead
> > turned out to be around 30ns — which I think is acceptable.
> 
> Just a quick correction — I misstated the unit in my previous email. The
> overhead for clearing DBM on the 400GB VM (4 vCPUs) was around 32 µs, not 30
> ns.
> 

Oh, that seems more likely :)

Question: is tha above amount of memory initially in Level-1 blocks, 
level-2 blocks or level-3 pages? (aka: were you using explicit/transparent 
hugepages?)

> > 
> > So I think we can go with your approach: simply clear DBM globally in
> > kvm_arch_commit_memory_region() when dirty logging starts, before write-
> > protecting the memslot.
> > 
> > ```
> > void kvm_arch_commit_memory_region(...)
> > {
> >      // ...
> >      if (log_dirty_pages) {
> >          if (change == KVM_MR_DELETE)
> >              return;
> > 
> >          kvm_mmu_clear_dbm_memory_region(kvm, new->id);

Agree, but see the comment above about using the same write that already 
exists, then we are not supposed to see much of a change.

Thanks!
Leo
