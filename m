Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642D6367287
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 15:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338226; cv=none; b=tt2V8aZWp246xZq8WsNJSaPf+nvkS18l0FmvQzhz+14BcgVQtnfg7oUsE9zHqsIXg1FVWBzkRHmccvy7UJGgqhpmGumXowYEUH+ZiIfEjOOuo0HwYMwBLpTlKx5E2SUBrGLsTyD+pjsOfkYM+o8dZwsqXqucSFvJCOCoeF2KZqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338226; c=relaxed/simple;
	bh=l2KGUYqW0UfMsHtQ5m9chnamEWLhEe2YPIHzEgOQPTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=g8/8fA6kdt9nAteh7heQ4ors8IH54ujc9uT9zfB2i1awnSPCxfnkFZ6ZOErgYQBY3Bc0DPu2XslImnG2IPctmCeJCcbgm2MCEgNzEnmdAq/7DSugodCwqD5f2TM2Y3VK7SSYd6xpAILzCT74uWyaH2UklEYEhGMYfjKi7sGAGbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IrINi992; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IrINi992"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2E1F1684;
	Wed, 29 Jul 2026 08:16:59 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EF353F763;
	Wed, 29 Jul 2026 08:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785338223; bh=l2KGUYqW0UfMsHtQ5m9chnamEWLhEe2YPIHzEgOQPTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrINi992JDxSzObZPgC2ZDiKIaq2Ox0SRSnnKuPayaGAptDRrqk8polkETNxgIuak
	 FOERoGq28jGE5o+lVefw5575Rfo4gGYd9xQM8A2Kqyu2xeZ+jCAPr5Na5udLniJI7d
	 PdufV4u2/yaZhZJFt8sLnk9iWysGOLEJeygwvTIo=
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
Date: Wed, 29 Jul 2026 16:16:51 +0100
Message-ID: <amoZY8uGLf1PEpjK@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <96516762-f004-4c2a-a9c6-6fbad49ad6ae@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-4-zhengtian10@huawei.com> <aliKo7dTZzKcWHzI@kernel.org> <0943eb14-9ffb-4dbb-9219-060e97bca2a7@huawei.com> <alpIfIOFfrudBzD5@LeoBrasDK> <al4bYajWE-v6wofu@LeoBrasDK> <96516762-f004-4c2a-a9c6-6fbad49ad6ae@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 04:51:59PM +0800, Tian Zheng wrote:
> 
> 
> On 7/20/2026 8:58 PM, Leonardo Bras wrote:
> > On Fri, Jul 17, 2026 at 04:21:32PM +0100, Leonardo Bras wrote:
> > > On Fri, Jul 17, 2026 at 11:58:06AM +0800, Tian Zheng wrote:
> > > > 
> > > > On 7/16/2026 3:39 PM, Oliver Upton wrote:
> > > > > Hi Tian,
> > > > > 
> > > > > On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
> > > > > > -	if (prot & KVM_PGTABLE_PROT_W)
> > > > > > +	if (prot & KVM_PGTABLE_PROT_W) {
> > > > > >    		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > > > > > 
> > > > > > +		/*
> > > > > > +		 * No DEVICE filter needed here: relax_perms is only called
> > > > > > +		 * on FSC_PERM faults. Device pages always get full RW from
> > > > > > +		 * initial mapping and are never write-protected during
> > > > > > +		 * migration, so they never trigger a permission fault.
> > > > > > +		 */
> > > > > > +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> > > > > > +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > > > > > +	} else {
> > > > > > +		/*
> > > > > > +		 * Clear DBM on W→RO downgrade to prevent hardware from
> > > > > > +		 * silently upgrading RO+DBM back to W+dirty, which would
> > > > > > +		 * bypass KVM's write tracking and cause data corruption.
> > > > > > +		 */
> > > > > > +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > > > > > +	}
> > > > > > +
> > > > > This block makes it pretty evident that the DBM bit really *is* the
> > > > > write permission bit. I'd much rather we introduce the concept of dirty
> > > > > state to the page table library and migrate the abstract write
> > > > > permission to the DBM field, even if we don't have FEAT_HAFDBS.
> > > > > 
> > > 
> > > Ohh, that's an amazing idea!
> > 
> > Thinking about that again...
> > If we adopt the encoding with DBM being the write-permission bit, and all
> > PTEs have it since the start, how can we have lazy-splitting happening?
> > 
> > Only way I think of is removing both DBM and S2_S2AP_W bit from writable
> > PTEs during dirty-track enable, and re-adding them during the first write
> > fault. If we don't remove the DBM bit, systems with HDBSS would just dirty
> > it by hardware, without causing a fault.
> > 
> > DBM=0 would need to happen only in the first write-protect (only on
> > lazy-splitting). All other write-protecting would just clean the S2_S2AP_W
> > bit, as everything is already split.
> > 
> > Is that what was intended?
> > 
> > Thanks!
> > Leo
> > 
> Hi Leo,
> 
> I think the cleanest way to handle this is to simply avoid setting DBM
> on block mappings. If we only set DBM on page-level PTEs, then block
> mappings will naturally stay DBM=0 and trigger a write fault on first
> access — exactly what we need for lazy splitting.
> 
> When the fault occurs, the block gets split into page-level PTEs, and at
> that point we can set DBM=1 on the resulting leaf entries. This way:
> 
> 1. Lazy split works naturally (fault -> split -> set DBM=1)
> 
> 2. No need to clear DBM globally at dirty-track enable
> 
> 3. No special handling for block mappings
> 
> So I think global DBM is still viable — we just need to filter out block
> mappings when setting the DBM bit. That way the lazy split path is preserved
> without extra complexity.

Hi Tian,

Humm, but would not that be contrary to what Oliver suggested: changing the 
encoding from the PTE for all entries?

(Like, if the PTE is writable, it has to have DBM set)

IIUC what you said, on first faulting of the page in the VM:
- If the entry is a page (level-3 leaf) and writable, add DBM
- If it's a block entry (leaf but not a level-3), don't add DBM

So after we enable dirty-logging:
- a level-3 entry would not fault, using HDBSS, and
- a block entry would fault, do the splitting, and add DBM to level-3 
  entries during the split.

If I got that correct, that would be clean indeed.

But then we would have a different encoding for block entries and page 
entries. In page entries, DBM could be used to say if the page is writable, 
but on block entries one would have to look at the 'dirty-bit'.

Would that be ok?

Thanks!
Leo
