Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EBA2EC571;
	Mon, 29 Jun 2026 17:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782752801; cv=none; b=re/IS+QXnyQZrWyN6uYO47HTPKZYqhclmPUoJQQdRtP4+uiIyEDy32EVsT6bm4+5WlgJ2hLfhOd2D98dS5CiSUvdl0SkK+gobVSAmWMDsbSW+RZjC7Ls35QnguH91f3UVUzUiYHGW1QOAJPc4jq2vyHojL9bL0L/OD5w9jfmAH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782752801; c=relaxed/simple;
	bh=DFeoWub+K+GN0Iwx/eN48X8/ixtRS5RccqgFRZjJ8w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTNcvvfjgOCy/S3Hlz8j4WAUP1NWcZ/qZlIVvZFk0iLt0xKncaUePKVrzTYND79QOkRENSeLqm1E4mHEJQoEpaqlmN2KnS/TeYFEzvWjf+9iIXrZXK6B9zrWi/D5qYi1DcfRLF2hb9DFUToMQSvE1Gma7TTpNDqIog6VpMoRuac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBLP/41L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBLP/41L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7771F000E9;
	Mon, 29 Jun 2026 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782752799;
	bh=EWRiNk6eB0V2Gzjz+yiZc9zc5mfKjXrgeS4ccVKl+mo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iBLP/41L33gXU0kLIK0aTLY5LUH31d6JENQ17CJxKfsZeE3G20rqWnTDbOQ5xlPNs
	 uCRmv3pnnw5zEH8ABqxlrAShhY0Tm0mVXO81tQjJH5jvNzckNclPfZr8OHFCBRuGft
	 UMkD19Wg1Hv4pEtNLD7dUSpzscrbbRGqckT46S/KRysedD9hPQ5SQgssb61OzKT+xT
	 7FUjkw6siq6VQ4nT+tu/Lw/8Tco2uZGmHf55TT9pw8KJkw8t1zFkivUNjrU9Sw6Mge
	 LeY9OnYoWoKd/eGsmVZ3J4GcRBUoRxbdBZU2p+N2hevlkZmRIZQM8vwcWKLQNqCUQ4
	 yNLxFyRaIMX4A==
Date: Mon, 29 Jun 2026 10:06:38 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if
 HDBSS is available
Message-ID: <akKmHqRaZEUjN3zY@kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-3-leo.bras@arm.com>
 <20260629113645.BE6801F000E9@smtp.kernel.org>
 <akKFlzAdB43lRpi1@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKFlzAdB43lRpi1@LeoBrasDK>

On Mon, Jun 29, 2026 at 03:47:51PM +0100, Leonardo Bras wrote:
> On Mon, Jun 29, 2026 at 11:36:45AM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > 
> > New issues:
> > - [High] The default eager page splitting chunk size violates the KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE UAPI contract by using a value that is not a valid block size for 16KB and 64KB page kernels.
> > 
> > Pre-existing issues:
> > - [Critical] Dropping mmu_lock between primary and nested stage-2 write-protection creates a window where nested guests can bypass dirty logging.
> > --
> > 
> > commit 09e1d250ed331b9dc20b42b7f9315892a86a5d50
> > Author: Leonardo Bras <leo.bras@arm.com>
> > 
> > KVM: arm64: Enable eager hugepage splitting if HDBSS is available
> > 
> > This commit enables eager hugepage splitting by default for systems
> > supporting HDBSS, setting the default chunk size to 256K pages at
> > stage2 initialization.
> > 
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 6c941aaa10c63..e086c01a9325e 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
> > >  	for_each_possible_cpu(cpu)
> > >  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
> > >  
> > > -	 /* The eager page splitting is disabled by default */
> > > -	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > > +	 /* The eager page splitting is disabled by default if system has no HDBSS */
> > > +	if (system_supports_hdbss())
> > > +		mmu->split_page_chunk_size = 256 * 1024 * PAGE_SIZE;
> > 
> > [Severity: High]
> > Does this hardcoded chunk size violate the KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> > UAPI contract on kernels with 16KB or 64KB pages?
> > 
> > By setting the default chunk size to 256 * 1024 * PAGE_SIZE, this evaluates to
> > 4GB on 16KB page systems and 16GB on 64KB page systems.
> > 
> > However, in arch/arm64/kvm/arm.c:kvm_vm_ioctl_enable_cap(), the chunk size is
> > validated against valid architectural block sizes:
> > 
> >     if (!new_cap || kvm_is_block_size_supported(new_cap)) {
> >     ...
> > 
> > Since 4GB and 16GB are not valid block sizes on those configurations, a VMM
> > like QEMU attempting to read the default capability via KVM_CHECK_EXTENSION
> > and set it back via KVM_ENABLE_CAP will be rejected with -EINVAL.
> 
> Sure, changing this to something like PMD_SIZE or PUD_SIZE should be no issue.
>  
> But this raises a topic I would like to understand:
> - Do we actually need this to be a block_size to assure correctness? or is 
>   it just about efficiency?

What value is there in having a chunk size larger than the largest
possible block mapping? The whole UAPI is deliberately tied up with page
table geometry.

Overall, I'm not buying the argument for changing the behavior of
KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE. There are very good reasons for
*not* eagerly splitting the entire address space, especially if you know
the working set of the VM is small.

You can still use HDBSS without eagerly splitting, so long as block
mappings are {DBM, S2AP_W} = {0, 0} and leaf mappings (which have
a writable PFN) are {1, 0}.

> > [Severity: Critical]
> > This is a pre-existing issue, but by enabling eager hugepage splitting by
> > default for HDBSS, does this exacerbate a race condition with nested guests
> > bypassing dirty logging?
> > 
> > In arch/arm64/kvm/mmu.c:kvm_arch_mmu_enable_log_dirty_pt_masked(), KVM enables
> > dirty logging by write-protecting the primary stage-2 and then calling
> > kvm_mmu_split_huge_pages():
> > 
> >     if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> >         kvm_mmu_split_huge_pages(kvm, start, end);
> > 
> >     kvm_nested_s2_wp(kvm);
> > 
> > Because kvm_mmu_split_huge_pages() can drop the mmu_lock to top-up the memory
> > cache or reschedule, a race window is created before kvm_nested_s2_wp()
> > protects the nested stage-2 tables.
> > 
> > While the lock is dropped, a nested VCPU can fault, map the page via its
> > separate shadow stage-2 (which hasn't been write-protected yet), and write to
> > the page without setting the dirty bitmap, leading to silent memory corruption
> > after live migration.
> > 
> 
> But if it's already write-protected in S2, if the nested VCPU faults 
> something, would not that be handled by non-nested faulting routine?
> 
> I understand very little of nested, and I can't understand how does that 
> work properly. Maybe Marc or Wei Lin may have a better answer for that.

The only time this would be an issue is if we allowed userspace to
observe a clean dirty bitmap with a stale, writable shadow stage-2. All
roads go through the slots_lock, so I don't believe this is actually an
issue.

The order of events Sashiko mentions makes no sense. If the shadow
stage-2 translation is already writable there would be no intervening
fault. Since the dirty bitmap is already cleared for these GFNs, a
racing write permission fault would actually set the dirty bitmap.

With that being said, I'd be happy with kvm_nested_s2_wp() getting moved
up earlier in the function anyway as it is easy to forget that the
mmu_lock could be dropped in between.

Thanks,
Oliver
