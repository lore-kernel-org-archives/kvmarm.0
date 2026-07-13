Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BDD428472
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783954233; cv=none; b=W32EkOzrtXcMqMnIKsSQtxKVy2Hz8H1yOCCufIX80PlnE/t+Si2AshmwI9aa9xI0wzV5eKJS9zXxGoMzKgsebXTLfQROonAhfSf1T3eIQvNq6zjAlSgulB8r6day5Wbz5RwSHZCR6uXsAQWE7fsk8cy4LZFKuLLm3hHTJq9P6Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783954233; c=relaxed/simple;
	bh=4Ah3ygSjY7HUwPChZQMsaqpNXbeCw/+Xh5v2OYwic58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=EpixaSxUIiy7NAMJGMNv6MN5n5r+3fcEUbLtqRsXvNub8qUWeZZIBoBMe6Xnj5S5/BpZ0ScpiUoZgEcQA6YyqMcimiSK6XVkc4eME2XoV8AvA5cc7oc5C0JzxirVDFVDNUS/zJZ/xW4DcuZUAld1p7Tx938o1wBUCtsyrkuAOT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y2jKodlL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y2jKodlL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B72E152B;
	Mon, 13 Jul 2026 07:50:26 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 945B03F7B4;
	Mon, 13 Jul 2026 07:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783954230; bh=4Ah3ygSjY7HUwPChZQMsaqpNXbeCw/+Xh5v2OYwic58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2jKodlLuPNRN5F/3tfH4GBhtaylwedslPiEU3JWHjTRDlaJknk4x8K8ZKo+Mfd7l
	 C8eJG4wsIIUxsFr1/ynFF3bNZHpl1R7oGo7IjjwaskGi50tMBWddYZcHHVOM/RtgeA
	 h4zzz3KcAMvGhDqdYIx2XYd6MxPmU0bc1oJ15Ukk=
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
Date: Mon, 13 Jul 2026 15:50:25 +0100
Message-ID: <alT7MeK_1ofOhIuv@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709104026.2612599-7-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-7-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 09, 2026 at 06:40:26PM +0800, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> HDBSS buffers store per-page dirty state after the stage-2 page tables
> have been split down to page granularity (chunk_size == PAGE_SIZE).

chunk_size != PAGE_SIZE now, but that should change as well :)

> When chunk_size == 0 the kernel may lazily skip splitting block mappings,
> leaving the page table coarser than what HDBSS expects. Therefore,
> enabling HDBSS requires disabling lazy split so that all block mappings
> are eagerly broken down before the buffer starts recording.

(See cover letter reply)

> 
> Add VM-level HDBSS enable/disable support. When dirty logging is
> enabled on any memslot, HDBSS is automatically enabled. When dirty
> logging is disabled on all memslots, HDBSS is automatically disabled.
> 
> This includes:
> - kvm_arm_enable_hdbss_global() to enable HDBSS for all vCPUs
> - kvm_arm_disable_hdbss_global() to disable and free HDBSS buffers
> - kvm_arm_hdbss_on_dirty_logging_change() for auto enable/disable
> - kvm_arch_destroy_vm() cleanup path
> - kvm_arch_commit_memory_region() integration
> 
> Signed-off-by: Eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_dirty_bit.h |   2 +
>  arch/arm64/kvm/arm.c                   |   8 ++
>  arch/arm64/kvm/dirty_bit.c             | 105 +++++++++++++++++++++++++
>  arch/arm64/kvm/mmu.c                   |   3 +
>  4 files changed, 118 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> index 4b28000e972f..a4cda8cdab24 100644
> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> @@ -23,5 +23,7 @@ int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
>  void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>  void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
>  int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
> +void kvm_arm_hdbss_on_dirty_logging_change(struct kvm *kvm, int nr_memslots_logging);
> +void kvm_arm_disable_hdbss_global(struct kvm *kvm);
> 
>  #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 566953a4e23a..536d94799ba8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -317,6 +317,14 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	if (is_protected_kvm_enabled())
>  		pkvm_destroy_hyp_vm(kvm);
> 
> +	/*
> +	 * Userspace may destroy the VM without disabling dirty logging,
> +	 * so the auto-disable path is never reached. Force disable HDBSS
> +	 * here to ensure vCPU buffers are freed and prevent memory leaks.
> +	 */
> +	if (kvm->arch.enable_hdbss)
> +		kvm_arm_disable_hdbss_global(kvm);
> +
>  	kvm_uninit_stage2_mmu(kvm);
>  	kvm_destroy_mpidr_data(kvm);
> 
> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 002366337637..c5bf866c23ef 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -112,3 +112,108 @@ int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
>  		return -EFAULT;
>  	}
>  }
> +
> +static unsigned int hdbss_auto_select_order(struct kvm *kvm)
> +{
> +	unsigned long npages = 0;
> +	struct kvm_memory_slot *memslot;
> +	int bkt;
> +
> +	kvm_for_each_memslot(memslot, bkt, kvm_memslots(kvm))
> +		npages += memslot->npages;
> +
> +	if (npages <= 16384)
> +		return 0;
> +	else if (npages <= 262144)
> +		return 3;
> +	else if (npages <= 4194304)
> +		return 6;
> +	else
> +		return 9;
> +}

IIUC you are counting the amount of pages the VM has, and based on that 
allocating a size for the HDBSS buffer.

A few notes here:
- It's not really nice to use magic numbers around like this. If you 
  actually want to use it, then use stuff like SZ_16K, SZ_256K, SZ_4M and 
  so on.
- You are returning magic numbers as well, why is it 0, 3, 6, or 9 here?
  It only makes sense if the person is reading HDBSSBR_EL2 documentation,
  which should not be necessary at this point. That's one reason I 
  recommended to using sizes. If that was really the best way to use it, 
  I would recommend using the defines that we get from sysreg, and you 
  actually used before to set the maximum order on a previous patch.
- Also, if you can return only valid values here, why do you check against 
  the maximum value in that previous patch?
- Also, are you using some undisclosed rule here? On 'order 0' the 
  meanining is 4KB, which translate to 512 HDBSS entries. Why are you using 
  it for any value under 16K? Same for 3-32KB-4kEntries you use for under 
  256K pages (and so on). If you are assuming a logical rule such as 
  'N pages would be ok with N/32 entries' it has to be described here at 
  least.
- Not sure VM size is the best way of doing that, since it will depend 
  more on the dirtying rate than the actual size, and most VMs would just 
  use the biggest size (4M x 4K pages is just 16GB). For instance with 
  dirty_ring we can use the dirty_ring.size as a better option.
  (I know this is a hard one to estimate when using dirty-bitmap, though)

> +
> +/*
> + * Enable HDBSS for all vCPUs in the VM.
> + *
> + * Called from kvm_arm_hdbss_on_dirty_logging_change() which is invoked
> + * by kvm_arch_commit_memory_region() under kvm->slots_lock.
> + *
> + * If buffer allocation fails, HDBSS remains disabled and dirty tracking
> + * falls back to the traditional software-based approach (PTE write-protect
> + * + software dirty marking). This does not affect correctness; dirty
> + * logging remains functional without HDBSS.
> + */
> +static int kvm_arm_enable_hdbss_global(struct kvm *kvm)
> +{
> +	int err;
> +	unsigned long i;
> +	unsigned int order;
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!system_supports_hdbss())
> +		return 0;
> +
> +	if (kvm->dirty_ring_size) /* Don't support HDBSS in dirty ring mode */
> +		return 0;
> +
> +	if (kvm->arch.enable_hdbss) /* Already On */
> +		return 0;
> +
> +	/* Turn it on */
> +	order = hdbss_auto_select_order(kvm);
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		err = kvm_arm_vcpu_alloc_hdbss(vcpu, order);
> +		if (err)
> +			goto error_alloc;
> +	}
> +
> +	kvm->arch.enable_hdbss = true;
> +	kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA;
> +
> +	/*
> +	 * We should kick vcpus out of guest mode here to load new
> +	 * vtcr value to vtcr_el2 register when re-enter guest mode.
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_vcpu_kick(vcpu);
> +
> +	return 0;
> +
> +error_alloc:
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		if (vcpu->arch.hdbss.base_phys)
> +			kvm_arm_vcpu_free_hdbss(vcpu);
> +
> +	pr_warn_once("kvm: failed to allocate HDBSS buffers (order=%u), "
> +		     "falling back to software dirty tracking\n", order);
> +	return -ENOMEM;
> +}
> +
> +void kvm_arm_disable_hdbss_global(struct kvm *kvm)
> +{
> +	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!kvm->arch.enable_hdbss) /* Already Off */
> +		return;
> +
> +	/* Turn it off */
> +	kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_arm_vcpu_free_hdbss(vcpu);
> +
> +	kvm->arch.enable_hdbss = false;
> +}
> +

Okay, say the user requested it to be disabled, you change the global vtcr, 
then free the hdbss on every vcpu. 

But the vcpus are still running, and since they will only disable this when 
they go out of the guest, then in again, HDBSS will still be running, 
right?

If some page gets dirty in the between, would not the HDBSS try to write to 
the already loaded buffer adress, and write to memory that have already 
been freed here?


> +void kvm_arm_hdbss_on_dirty_logging_change(struct kvm *kvm, int nr_memslots_logging)
> +{
> +	/*
> +	 * Called from kvm_arch_commit_memory_region() under kvm->slots_lock.
> +	 * All state transitions are serialized by slots_lock.
> +	 */
> +	if (nr_memslots_logging > 0 && !kvm->arch.enable_hdbss)
> +		kvm_arm_enable_hdbss_global(kvm);
> +	else if (nr_memslots_logging == 0 && kvm->arch.enable_hdbss)
> +		kvm_arm_disable_hdbss_global(kvm);
> +}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 949fb895add6..484f48dae000 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2588,6 +2588,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  {
>  	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> 
> +	kvm_arm_hdbss_on_dirty_logging_change(kvm,
> +		atomic_read(&kvm->nr_memslots_dirty_logging));
> +
>  	/*
>  	 * At this point memslot has been committed and there is an
>  	 * allocated dirty_bitmap[], dirty pages will be tracked while the
> --
> 2.33.0
> 

Okay, reading the above I remembered something really complicated:
We can't really enable HDBSS partially if we start with DBM set for all 
pages. Once we enable HDBSS wit will track changes for all memslots.

The only way to enable it partially would be to set DBM during the 
dirty-bit tracking, which I recall being complicated for some reasons.

Well, we have to think about the overall strategy before a next version.

Thanks!
Leo
