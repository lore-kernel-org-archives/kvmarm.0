Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3643E1CFB;
	Mon, 29 Jun 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782744487; cv=none; b=IwZEeshfJ9DBCdYqvV2s/eFnckilXmOtEDQJu24OnN7bIGN52x0pBjOt9IK2Rc2H1wdXKapaMjDsJ8rOl68SYxiB/cHg6CJhhLsJ/YqH/8oVbU+0RGgn9ayAclqUt8xlKtu3/qDtGzI/1HjBsDtv6fxZzpNQunDz2cHhtogjP+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782744487; c=relaxed/simple;
	bh=+pCNkkGZ56/6raU8EBpJrhM1D7spqmtSQE1bdpbcxMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=CTZU4zCK7liHnODZA3tMZHfEmRLJwkheF79HENt4yHlovejIsJUNWWMMSgsO8FJBi92A7CY1KDMFazKOegmBRtdS9/6FLoy6cRcyOcL6PFNBslN6OljgArz3yfz6GMFqROfEFhZJ9dRvcxi7P5qt3ZuiezUHNB4t20yMoPl/lJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B2pVSlBC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B2pVSlBC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6931416A3;
	Mon, 29 Jun 2026 07:48:00 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD2D13F905;
	Mon, 29 Jun 2026 07:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782744484; bh=+pCNkkGZ56/6raU8EBpJrhM1D7spqmtSQE1bdpbcxMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2pVSlBCQBm2Envdg9jvKjD6n+rnB3LoLf5kFWbO+8Q06YXHgPWssgdYDCnMx5BL5
	 Xs/oTXNpxpK4ZAtoi82u9wB4/2uQn0FC/MsXRmZrhJtIbMI/oFfAb1+D1Ql71j7hBV
	 XzOwJij/KMDptrK4WCjyAlPeONV5Zfv0DFi/YGtE=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if HDBSS is available
Date: Mon, 29 Jun 2026 15:47:51 +0100
Message-ID: <akKFlzAdB43lRpi1@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629113645.BE6801F000E9@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-3-leo.bras@arm.com> <20260629113645.BE6801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:36:45AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [High] The default eager page splitting chunk size violates the KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE UAPI contract by using a value that is not a valid block size for 16KB and 64KB page kernels.
> 
> Pre-existing issues:
> - [Critical] Dropping mmu_lock between primary and nested stage-2 write-protection creates a window where nested guests can bypass dirty logging.
> --
> 
> commit 09e1d250ed331b9dc20b42b7f9315892a86a5d50
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Enable eager hugepage splitting if HDBSS is available
> 
> This commit enables eager hugepage splitting by default for systems
> supporting HDBSS, setting the default chunk size to 256K pages at
> stage2 initialization.
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 6c941aaa10c63..e086c01a9325e 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
> >  	for_each_possible_cpu(cpu)
> >  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
> >  
> > -	 /* The eager page splitting is disabled by default */
> > -	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > +	 /* The eager page splitting is disabled by default if system has no HDBSS */
> > +	if (system_supports_hdbss())
> > +		mmu->split_page_chunk_size = 256 * 1024 * PAGE_SIZE;
> 
> [Severity: High]
> Does this hardcoded chunk size violate the KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> UAPI contract on kernels with 16KB or 64KB pages?
> 
> By setting the default chunk size to 256 * 1024 * PAGE_SIZE, this evaluates to
> 4GB on 16KB page systems and 16GB on 64KB page systems.
> 
> However, in arch/arm64/kvm/arm.c:kvm_vm_ioctl_enable_cap(), the chunk size is
> validated against valid architectural block sizes:
> 
>     if (!new_cap || kvm_is_block_size_supported(new_cap)) {
>     ...
> 
> Since 4GB and 16GB are not valid block sizes on those configurations, a VMM
> like QEMU attempting to read the default capability via KVM_CHECK_EXTENSION
> and set it back via KVM_ENABLE_CAP will be rejected with -EINVAL.

Sure, changing this to something like PMD_SIZE or PUD_SIZE should be no issue.
 
But this raises a topic I would like to understand:
- Do we actually need this to be a block_size to assure correctness? or is 
  it just about efficiency?

I was thinking on using PUD_SIZE here before, but that would mean very 
different splitting granularity, as on 4k pagesize we would be splitting 
512*512 pages (above mentioned 256k pages), but on 16k pagesize we would be 
splitting 2048*2048 pages (4M), and on 64k pagesize it would be 8k*8k pages 
(64M). 

Doing that could defeat the purpose of chunk size to have a possible sleep 
to not keep the lock hold for too long. In that case, would not it make 
more sense to use a fixed number of pages instead?


> 
> [Severity: Critical]
> This is a pre-existing issue, but by enabling eager hugepage splitting by
> default for HDBSS, does this exacerbate a race condition with nested guests
> bypassing dirty logging?
> 
> In arch/arm64/kvm/mmu.c:kvm_arch_mmu_enable_log_dirty_pt_masked(), KVM enables
> dirty logging by write-protecting the primary stage-2 and then calling
> kvm_mmu_split_huge_pages():
> 
>     if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>         kvm_mmu_split_huge_pages(kvm, start, end);
> 
>     kvm_nested_s2_wp(kvm);
> 
> Because kvm_mmu_split_huge_pages() can drop the mmu_lock to top-up the memory
> cache or reschedule, a race window is created before kvm_nested_s2_wp()
> protects the nested stage-2 tables.
> 
> While the lock is dropped, a nested VCPU can fault, map the page via its
> separate shadow stage-2 (which hasn't been write-protected yet), and write to
> the page without setting the dirty bitmap, leading to silent memory corruption
> after live migration.
> 

But if it's already write-protected in S2, if the nested VCPU faults 
something, would not that be handled by non-nested faulting routine?

I understand very little of nested, and I can't understand how does that 
work properly. Maybe Marc or Wei Lin may have a better answer for that.

CC: Wei Lin

Thanks!
Leo

