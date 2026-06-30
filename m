Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0C13F58FE;
	Tue, 30 Jun 2026 12:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782824336; cv=none; b=d07JM6msK0+1QeBPyRICnViRPAREs8I3f75rYUYMAW7g3rpfY3hxQpo6UfSW+FZJHYOeIPnim8DSwX04vr+DfnuJLR+/fNQxiFVST1NTEbyvrEN9CnO57B4fLoVDQoxQiHFtXbbtfBYl4/vQtm5uOdhnrK0VObUoCA3lw7C9lpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782824336; c=relaxed/simple;
	bh=rQy6ufZS/d06sy42Nw501NI/EZ81qs0zBsu6gj+Ji9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=t8uvLO7RPLL0IAHwD9K8wa5lXsfVmAJcTZ7hQu35ktN24puKfqkTDAhn4YW4AP2sOkNLCT23NwflfJy/qgXhr4ifYdt1VqTuO+IR4HSCAoXG6u6egjoSKvmfX77xHVpFIxvmpSyEI/5I8M4qTO3C4RGCcBFRhb6NsWDgjdvGi5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c3QxyXBT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c3QxyXBT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA31016F8;
	Tue, 30 Jun 2026 05:58:49 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E6F43F905;
	Tue, 30 Jun 2026 05:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782824334; bh=rQy6ufZS/d06sy42Nw501NI/EZ81qs0zBsu6gj+Ji9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3QxyXBT0n3rNLXsrfGjdolNmH2SKD+rk1rGRJQT1fdpDUF5wBkAe5GpMLivflJ7k
	 bqbOMbwtOglkrWwBDb7/VqTHg5ZxgU3zsGX/cAB0WkWuehN7eWjArjntbJVfv3BpBN
	 vijushwNdXxGe3uHgDG5F7Ytt0w5M8qWHM+fhKi0=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	sashiko-reviews@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if HDBSS is available
Date: Tue, 30 Jun 2026 13:58:48 +0100
Message-ID: <akO9iHJmKN7MzTjM@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <akKmHqRaZEUjN3zY@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-3-leo.bras@arm.com> <20260629113645.BE6801F000E9@smtp.kernel.org> <akKFlzAdB43lRpi1@LeoBrasDK> <akKmHqRaZEUjN3zY@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 10:06:38AM -0700, Oliver Upton wrote:
> On Mon, Jun 29, 2026 at 03:47:51PM +0100, Leonardo Bras wrote:
> > On Mon, Jun 29, 2026 at 11:36:45AM +0000, sashiko-bot@kernel.org wrote:
> > > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > > 
> > > New issues:
> > > - [High] The default eager page splitting chunk size violates the KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE UAPI contract by using a value that is not a valid block size for 16KB and 64KB page kernels.
> > > 
> > > Pre-existing issues:
> > > - [Critical] Dropping mmu_lock between primary and nested stage-2 write-protection creates a window where nested guests can bypass dirty logging.
> > > --
> > > 
> > > commit 09e1d250ed331b9dc20b42b7f9315892a86a5d50
> > > Author: Leonardo Bras <leo.bras@arm.com>
> > > 
> > > KVM: arm64: Enable eager hugepage splitting if HDBSS is available
> > > 
> > > This commit enables eager hugepage splitting by default for systems
> > > supporting HDBSS, setting the default chunk size to 256K pages at
> > > stage2 initialization.
> > > 
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 6c941aaa10c63..e086c01a9325e 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
> > > >  	for_each_possible_cpu(cpu)
> > > >  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
> > > >  
> > > > -	 /* The eager page splitting is disabled by default */
> > > > -	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > > > +	 /* The eager page splitting is disabled by default if system has no HDBSS */
> > > > +	if (system_supports_hdbss())
> > > > +		mmu->split_page_chunk_size = 256 * 1024 * PAGE_SIZE;
> > > 
> > > [Severity: High]
> > > Does this hardcoded chunk size violate the KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> > > UAPI contract on kernels with 16KB or 64KB pages?
> > > 
> > > By setting the default chunk size to 256 * 1024 * PAGE_SIZE, this evaluates to
> > > 4GB on 16KB page systems and 16GB on 64KB page systems.
> > > 
> > > However, in arch/arm64/kvm/arm.c:kvm_vm_ioctl_enable_cap(), the chunk size is
> > > validated against valid architectural block sizes:
> > > 
> > >     if (!new_cap || kvm_is_block_size_supported(new_cap)) {
> > >     ...
> > > 
> > > Since 4GB and 16GB are not valid block sizes on those configurations, a VMM
> > > like QEMU attempting to read the default capability via KVM_CHECK_EXTENSION
> > > and set it back via KVM_ENABLE_CAP will be rejected with -EINVAL.
> > 
> > Sure, changing this to something like PMD_SIZE or PUD_SIZE should be no issue.
> >  
> > But this raises a topic I would like to understand:
> > - Do we actually need this to be a block_size to assure correctness? or is 
> >   it just about efficiency?
> 
> What value is there in having a chunk size larger than the largest
> possible block mapping? The whole UAPI is deliberately tied up with page
> table geometry.

Not larger, possibly smallerv My concern was the difference in pages to 
split between 4k, 16k and 64k.

> 
> Overall, I'm not buying the argument for changing the behavior of
> KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE. There are very good reasons for
> *not* eagerly splitting the entire address space, especially if you know
> the working set of the VM is small.
> 
> You can still use HDBSS without eagerly splitting, so long as block
> mappings are {DBM, S2AP_W} = {0, 0} and leaf mappings (which have
> a writable PFN) are {1, 0}.
> 

Block mappings being read-only, and leaf mappings being writable-clean, 
then? Could you please ellaborate on why does not it need eager-split?

As a review, what I recall from the strategy for hw dirty-logging was:
- If we have HDBSS, add DBM for all writable pages {1, 1}
- On dirty-logging start, make them writable-clean {1, 0}
  - Can be done using HACDBS
  - Enable HDBSS & HAFDBS

We don't have a fault for making pages dirty anymore, as this is done 
by HAFDBS and recorded by HDBSS, so splitting does not happen on demand 
anymore. So if we want to split pages, for better tracking granularity, or 
anything, we have to eager-split them.

Not doing so may cause us to have different level leaf sizes (pages & 
hugepages) mixed up in HDBSS, which adds complexity, on top of possibly 
making a live migration slower (the whole leaf entry has to be sent over 
network).

> > > [Severity: Critical]
> > > This is a pre-existing issue, but by enabling eager hugepage splitting by
> > > default for HDBSS, does this exacerbate a race condition with nested guests
> > > bypassing dirty logging?
> > > 
> > > In arch/arm64/kvm/mmu.c:kvm_arch_mmu_enable_log_dirty_pt_masked(), KVM enables
> > > dirty logging by write-protecting the primary stage-2 and then calling
> > > kvm_mmu_split_huge_pages():
> > > 
> > >     if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > >         kvm_mmu_split_huge_pages(kvm, start, end);
> > > 
> > >     kvm_nested_s2_wp(kvm);
> > > 
> > > Because kvm_mmu_split_huge_pages() can drop the mmu_lock to top-up the memory
> > > cache or reschedule, a race window is created before kvm_nested_s2_wp()
> > > protects the nested stage-2 tables.
> > > 
> > > While the lock is dropped, a nested VCPU can fault, map the page via its
> > > separate shadow stage-2 (which hasn't been write-protected yet), and write to
> > > the page without setting the dirty bitmap, leading to silent memory corruption
> > > after live migration.
> > > 
> > 
> > But if it's already write-protected in S2, if the nested VCPU faults 
> > something, would not that be handled by non-nested faulting routine?
> > 
> > I understand very little of nested, and I can't understand how does that 
> > work properly. Maybe Marc or Wei Lin may have a better answer for that.
> 
> The only time this would be an issue is if we allowed userspace to
> observe a clean dirty bitmap with a stale, writable shadow stage-2. All
> roads go through the slots_lock, so I don't believe this is actually an
> issue.
> 

Awesome! 

> The order of events Sashiko mentions makes no sense. If the shadow
> stage-2 translation is already writable there would be no intervening
> fault. Since the dirty bitmap is already cleared for these GFNs, a
> racing write permission fault would actually set the dirty bitmap.
> 
> With that being said, I'd be happy with kvm_nested_s2_wp() getting moved
> up earlier in the function anyway as it is easy to forget that the
> mmu_lock could be dropped in between.
> 

Makes sense.

Thanks!
Leo
