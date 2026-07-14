Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E611A3655D8
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 14:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784039645; cv=none; b=E3DiHtXfU3UBVUazhwCSSdyMg67yTQ/4tCpiLc3z2WnVrMI+C7E83Msadh73PZWscGasxR565Wekw2qFQa71gpCUqpmprWex25JbmjNeaw3jriEZt2/kidXki7QXTU7JQmGpNht9T8Z6DXpDRIReESfLWBWGNhzsc95SS6jYqXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784039645; c=relaxed/simple;
	bh=TevgCXj9NpIMOuobBVkQHInIl1fM8bTU+9dfBs/OqbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=gefH0Am7sNroFTJnZ0h9h87XAXhnkfvy8PCLV7SWlBooHILp79z5TD1e19aOhSN9jjtI9cFicF0pccpdWu2OCCi2qycPyy419+DIYHMYmfB9MzQqU3twuOfUOs5y6eEP6QapOZTlgCpHzJsv8MujnLwrY2Ku5XtcQI8mfBy1hvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mfJ1GQ/J; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mfJ1GQ/J"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 128872B;
	Tue, 14 Jul 2026 07:33:59 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47E7A3F7B4;
	Tue, 14 Jul 2026 07:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784039643; bh=TevgCXj9NpIMOuobBVkQHInIl1fM8bTU+9dfBs/OqbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfJ1GQ/J4zUT6ez1zJ0JKESi8tQK13WDb7XHHQ8otluUuKR5wg0StovFj4MRxhrcf
	 Y4ZMi36m7hHW9NfoS7pvQW2/S2EFEoJ18rg1gNwT5b+DLHcUMlxyewTXHXTzOxsxTL
	 KGmhZFLSIuZqNf1Nrlz8oHUmQTxHZmIPzoNxCvAU=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
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
Subject: Re: [PATCH v4 6/6] KVM: arm64: Add auto HDBSS enable/disable on dirty logging change
Date: Tue, 14 Jul 2026 15:33:58 +0100
Message-ID: <alZI1rwmeYJHUFut@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <alYamq9BL5CTaAX7@LeoBrasDK>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-7-zhengtian10@huawei.com> <alT7MeK_1ofOhIuv@LeoBrasDK> <6e8b23bc-d420-4f5a-a921-5a5d64d84200@huawei.com> <alYamq9BL5CTaAX7@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 14, 2026 at 12:16:42PM +0100, Leonardo Bras wrote:
> On Tue, Jul 14, 2026 at 04:58:37PM +0800, Tian Zheng wrote:
> > 
> > On 7/13/2026 10:50 PM, Leonardo Bras wrote:
> > > On Thu, Jul 09, 2026 at 06:40:26PM +0800, Tian Zheng wrote:
> > > > From: eillon <yezhenyu2@huawei.com>
> > > > 
> > > > HDBSS buffers store per-page dirty state after the stage-2 page tables
> > > > have been split down to page granularity (chunk_size == PAGE_SIZE).
> > > chunk_size != PAGE_SIZE now, but that should change as well :)
> > 
> > 
> > Thanks, I'll clarify the comment in v5.
> 
> By the discussion we are having in the HACDBS patchset, I think we can't 
> assume the pages are split in the future. :\
> 
> > 
> > 
> > > 
> > > > When chunk_size == 0 the kernel may lazily skip splitting block mappings,
> > > > leaving the page table coarser than what HDBSS expects. Therefore,
> > > > enabling HDBSS requires disabling lazy split so that all block mappings
> > > > are eagerly broken down before the buffer starts recording.
> > > (See cover letter reply)
> > > 
> > > > Add VM-level HDBSS enable/disable support. When dirty logging is
> > > > enabled on any memslot, HDBSS is automatically enabled. When dirty
> > > > logging is disabled on all memslots, HDBSS is automatically disabled.
> > > > 
> > > > This includes:
> > > > - kvm_arm_enable_hdbss_global() to enable HDBSS for all vCPUs
> > > > - kvm_arm_disable_hdbss_global() to disable and free HDBSS buffers
> > > > - kvm_arm_hdbss_on_dirty_logging_change() for auto enable/disable
> > > > - kvm_arch_destroy_vm() cleanup path
> > > > - kvm_arch_commit_memory_region() integration
> > > > 
> > > > Signed-off-by: Eillon <yezhenyu2@huawei.com>
> > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > ---
> > > >   arch/arm64/include/asm/kvm_dirty_bit.h |   2 +
> > > >   arch/arm64/kvm/arm.c                   |   8 ++
> > > >   arch/arm64/kvm/dirty_bit.c             | 105 +++++++++++++++++++++++++
> > > >   arch/arm64/kvm/mmu.c                   |   3 +
> > > >   4 files changed, 118 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > index 4b28000e972f..a4cda8cdab24 100644
> > > > --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > @@ -23,5 +23,7 @@ int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
> > > >   void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> > > >   void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> > > >   int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
> > > > +void kvm_arm_hdbss_on_dirty_logging_change(struct kvm *kvm, int nr_memslots_logging);
> > > > +void kvm_arm_disable_hdbss_global(struct kvm *kvm);
> > > > 
> > > >   #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index 566953a4e23a..536d94799ba8 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -317,6 +317,14 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> > > >   	if (is_protected_kvm_enabled())
> > > >   		pkvm_destroy_hyp_vm(kvm);
> > > > 
> > > > +	/*
> > > > +	 * Userspace may destroy the VM without disabling dirty logging,
> > > > +	 * so the auto-disable path is never reached. Force disable HDBSS
> > > > +	 * here to ensure vCPU buffers are freed and prevent memory leaks.
> > > > +	 */
> > > > +	if (kvm->arch.enable_hdbss)
> > > > +		kvm_arm_disable_hdbss_global(kvm);
> > > > +
> > > >   	kvm_uninit_stage2_mmu(kvm);
> > > >   	kvm_destroy_mpidr_data(kvm);
> > > > 
> > > > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > > > index 002366337637..c5bf866c23ef 100644
> > > > --- a/arch/arm64/kvm/dirty_bit.c
> > > > +++ b/arch/arm64/kvm/dirty_bit.c
> > > > @@ -112,3 +112,108 @@ int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
> > > >   		return -EFAULT;
> > > >   	}
> > > >   }
> > > > +
> > > > +static unsigned int hdbss_auto_select_order(struct kvm *kvm)
> > > > +{
> > > > +	unsigned long npages = 0;
> > > > +	struct kvm_memory_slot *memslot;
> > > > +	int bkt;
> > > > +
> > > > +	kvm_for_each_memslot(memslot, bkt, kvm_memslots(kvm))
> > > > +		npages += memslot->npages;
> > > > +
> > > > +	if (npages <= 16384)
> > > > +		return 0;
> > > > +	else if (npages <= 262144)
> > > > +		return 3;
> > > > +	else if (npages <= 4194304)
> > > > +		return 6;
> > > > +	else
> > > > +		return 9;
> > > > +}
> > > IIUC you are counting the amount of pages the VM has, and based on that
> > > allocating a size for the HDBSS buffer.
> > > 
> > > A few notes here:
> > > - It's not really nice to use magic numbers around like this. If you
> > >    actually want to use it, then use stuff like SZ_16K, SZ_256K, SZ_4M and
> > >    so on.
> > > - You are returning magic numbers as well, why is it 0, 3, 6, or 9 here?
> > >    It only makes sense if the person is reading HDBSSBR_EL2 documentation,
> > >    which should not be necessary at this point. That's one reason I
> > >    recommended to using sizes. If that was really the best way to use it,
> > >    I would recommend using the defines that we get from sysreg, and you
> > >    actually used before to set the maximum order on a previous patch.
> > > - Also, if you can return only valid values here, why do you check against
> > >    the maximum value in that previous patch?
> > > - Also, are you using some undisclosed rule here? On 'order 0' the
> > >    meanining is 4KB, which translate to 512 HDBSS entries. Why are you using
> > >    it for any value under 16K? Same for 3-32KB-4kEntries you use for under
> > >    256K pages (and so on). If you are assuming a logical rule such as
> > >    'N pages would be ok with N/32 entries' it has to be described here at
> > >    least.
> > > - Not sure VM size is the best way of doing that, since it will depend
> > >    more on the dirtying rate than the actual size, and most VMs would just
> > >    use the biggest size (4M x 4K pages is just 16GB). For instance with
> > >    dirty_ring we can use the dirty_ring.size as a better option.
> > >    (I know this is a hard one to estimate when using dirty-bitmap, though)
> > 
> > 
> > I'll replace the magic numbers and also add a comment in the next version
> > explaining
> > 
> > the mapping between the thresholds and the order values.
> > 
> > 
> > On auto-choosing the size: VM memory size is a simple starting point, but I
> > agree it's
> > 
> > not ideal. For dirty-ring mode we could use dirty_ring_size as a reference;
> > for dirty-bitmap
> > 
> > mode there's no equivalent, so I don't have a good answer yet. I'd really
> > appreciate any
> > 
> > suggestions from the community on a better idea for the dirty-bitmap case.
> 
> I am thinking that we could use a default value (say 1 PAGESIZE/vcpu) and 
> add an ioctl to optionally increase this value. This way we don't require 
> a new interface to benefit from HDBSS, but allow users to tune it.
> 
> > 
> > Also, since we automatically enable HDBSS in the kernel, the check against
> > HDBSS_MAX_ORDER is redundant. I'll remove it.
> > 
> > 
> > > > +
> > > > +/*
> > > > + * Enable HDBSS for all vCPUs in the VM.
> > > > + *
> > > > + * Called from kvm_arm_hdbss_on_dirty_logging_change() which is invoked
> > > > + * by kvm_arch_commit_memory_region() under kvm->slots_lock.
> > > > + *
> > > > + * If buffer allocation fails, HDBSS remains disabled and dirty tracking
> > > > + * falls back to the traditional software-based approach (PTE write-protect
> > > > + * + software dirty marking). This does not affect correctness; dirty
> > > > + * logging remains functional without HDBSS.
> > > > + */
> > > > +static int kvm_arm_enable_hdbss_global(struct kvm *kvm)
> > > > +{
> > > > +	int err;
> > > > +	unsigned long i;
> > > > +	unsigned int order;
> > > > +	struct kvm_vcpu *vcpu;
> > > > +
> > > > +	if (!system_supports_hdbss())
> > > > +		return 0;
> > > > +
> > > > +	if (kvm->dirty_ring_size) /* Don't support HDBSS in dirty ring mode */
> > > > +		return 0;
> > > > +
> > > > +	if (kvm->arch.enable_hdbss) /* Already On */
> > > > +		return 0;
> > > > +
> > > > +	/* Turn it on */
> > > > +	order = hdbss_auto_select_order(kvm);
> > > > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > > > +		err = kvm_arm_vcpu_alloc_hdbss(vcpu, order);
> > > > +		if (err)
> > > > +			goto error_alloc;
> > > > +	}
> > > > +
> > > > +	kvm->arch.enable_hdbss = true;
> > > > +	kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA;
> > > > +
> > > > +	/*
> > > > +	 * We should kick vcpus out of guest mode here to load new
> > > > +	 * vtcr value to vtcr_el2 register when re-enter guest mode.
> > > > +	 */
> > > > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > > > +		kvm_vcpu_kick(vcpu);
> > > > +
> > > > +	return 0;
> > > > +
> > > > +error_alloc:
> > > > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > > > +		if (vcpu->arch.hdbss.base_phys)
> > > > +			kvm_arm_vcpu_free_hdbss(vcpu);
> > > > +
> > > > +	pr_warn_once("kvm: failed to allocate HDBSS buffers (order=%u), "
> > > > +		     "falling back to software dirty tracking\n", order);
> > > > +	return -ENOMEM;
> > > > +}
> > > > +
> > > > +void kvm_arm_disable_hdbss_global(struct kvm *kvm)
> > > > +{
> > > > +	unsigned long i;
> > > > +	struct kvm_vcpu *vcpu;
> > > > +
> > > > +	if (!kvm->arch.enable_hdbss) /* Already Off */
> > > > +		return;
> > > > +
> > > > +	/* Turn it off */
> > > > +	kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA);
> > > > +
> > > > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > > > +		kvm_arm_vcpu_free_hdbss(vcpu);
> > > > +
> > > > +	kvm->arch.enable_hdbss = false;
> > > > +}
> > > > +
> > > Okay, say the user requested it to be disabled, you change the global vtcr,
> > > then free the hdbss on every vcpu.
> > > 
> > > But the vcpus are still running, and since they will only disable this when
> > > they go out of the guest, then in again, HDBSS will still be running,
> > > right?
> > > 
> > > If some page gets dirty in the between, would not the HDBSS try to write to
> > > the already loaded buffer adress, and write to memory that have already
> > > been freed here?
> > > 
> > 
> > You're right — this is a race condition. I'll fix this in v5 by clearing
> > VTCR_EL2_HDBSS from
> > 
> > kvm->arch.mmu.vtcr first, then kicking all vCPUs to force them to exit guest
> > mode and reload the config.
> > 
> > Once all vCPUs are out of guest mode, it will be safe to free the HDBSS
> > buffers.
> >
> 
> That would be safer, indeed.
>  
> > 
> > > > +void kvm_arm_hdbss_on_dirty_logging_change(struct kvm *kvm, int nr_memslots_logging)
> > > > +{
> > > > +	/*
> > > > +	 * Called from kvm_arch_commit_memory_region() under kvm->slots_lock.
> > > > +	 * All state transitions are serialized by slots_lock.
> > > > +	 */
> > > > +	if (nr_memslots_logging > 0 && !kvm->arch.enable_hdbss)
> > > > +		kvm_arm_enable_hdbss_global(kvm);
> > > > +	else if (nr_memslots_logging == 0 && kvm->arch.enable_hdbss)
> > > > +		kvm_arm_disable_hdbss_global(kvm);
> > > > +}
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 949fb895add6..484f48dae000 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -2588,6 +2588,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> > > >   {
> > > >   	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> > > > 
> > > > +	kvm_arm_hdbss_on_dirty_logging_change(kvm,
> > > > +		atomic_read(&kvm->nr_memslots_dirty_logging));
> > > > +
> > > >   	/*
> > > >   	 * At this point memslot has been committed and there is an
> > > >   	 * allocated dirty_bitmap[], dirty pages will be tracked while the
> > > > --
> > > > 2.33.0
> > > > 
> > > Okay, reading the above I remembered something really complicated:
> > > We can't really enable HDBSS partially if we start with DBM set for all
> > > pages. Once we enable HDBSS wit will track changes for all memslots.
> > > 
> > > The only way to enable it partially would be to set DBM during the
> > > dirty-bit tracking, which I recall being complicated for some reasons.
> > > 
> > > Well, we have to think about the overall strategy before a next version.
> > > 
> > > Thanks!
> > > Leo
> > 
> > 
> > Yes, I did consider this when I switched to global DBM injection in v4.
> > There are
> > 
> > indeed some scenarios that are harder to control:
> > 
> > 
> > 
> > Firstly, for lazy split, if we add the DBM tag lazily during live migration
> > dirty tracking (like v3 did),
> > 
> > the first write to each page would trap. That trap serves two purposes: it
> > gives us a chance to split
> > 
> > hugepages on demand (lazy split), and it ensures the DBM addition happens at
> > a safer, more controlled point.
> 
> It also allows us to do the dirty-tracking by slot, which is not possible 
> with the v4 approach.
> 
> > 
> > However, because v4 enables HDBSS and DBM upfront, we lose that initial
> > trap. That's exactly why we
> > 
> > now rely on your eager hugepage splitting patch as a mandatory dependency.
> > 
> 
> Correct.
> 
> > 
> > 
> > Secondly, I'm also concerned about whether global DBM injection could
> > accidentally mark pages
> > 
> > that shouldn't be tracked — for example, pages with special mappings.
> 
> Well, if we want to not track those pages, we have just to make sure we can 
> detect them and not mark them with the DBM bit.
> 
> > If
> > that's possible, then the
> > 
> > lazy approach (only adding DBM on the first write fault) would be safer
> > because it only touches pages
> > 
> > that are actually written to.
> > 
> > 
> > 
> > So I'd like to ask: is avoiding the first-trap overhead worth the potential
> > risks of global DBM injection?
> > 
> > Or do you think the lazy approach is actually safer overall? I'd appreciate
> > your thoughts on this trade-off.
> > 
> 
> Well, even though performance is important, the decision to set DBM bits 
> for all writtable pages at their mapping time was not driven by 
> performance, but instead by an issue with setting DBM while the VCPUs were 
> running. I have to rework what that was, and check if that is still an 
> issue, before we can even discuss what to do next :(
> 
> But the fact that the 'eager DBM setting' makes dirty-bit tracking start 
> global, instead of per-memslot, is something we have to consider as well.
>

Actually, I though more about that part, and we can achieve per-memslot 
dirty-bit tracking with the eager DBM setting.
- On first fault,
  - Read fault: we mark the writable PTE as writable-clean
  - Write fault: we mark the writable PTE as writable-dirty
- In dirty-track enable, we clean the pages that are starting being tracked
  - Only when pages go from writable-clean to writable-dirty they log HDBSS

The only obvious case, which should not happen that often, it that a 
writable-clean page on a mesmslot that is not being tracked goes to 
writable-dirty state. It will make to the HDBSS buffer, but we can just 
check if the memslot is dirty-tracking before registering it to either the 
dirty-bitmap or the dirty-ring. 

While it will be using a entry that could be used for an actual tracking, 
it is not supposed to happen that often in a real scenario, so it should 
not impact performance that much. 

So we only have to worry about the eager vs lazy splitting scenarios for 
now.

Thanks!
Leo
