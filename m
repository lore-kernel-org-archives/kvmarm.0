Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC6143B3FF
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 14:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783951577; cv=none; b=OtAeoeX3I3lpYko524fQ5Y51Ld+1I2vZ0NNrRsoPYTVJYdikC2XgHkDA2Gk7WIkjahysgdi/j78uaR8NNH0ejimcTSsQiYtGjl2sXuL8Tld8O1P9JEVTerzxRut/rPH9nFfV0NvCDV3dZyAltQXDJ2s5r629lyS0uN9jsVIMKNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783951577; c=relaxed/simple;
	bh=O5obKWBC3f0nz8VhvV8KfQWeSGeWkfkmlsDJqw3Penk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=RjeVqtHriNlMJ8RL/wj++FLP/sD3sC5HueNGV2wl+dlFmYoQGfANuaAIkI13XV2UilwRgakAUhutBh6UU3a39KCx9gTs1dIvwnmrV/CUPEOxTw/WlEw3HZM1ftgfgAa2UJ457ECx7tw3NXIaX9OauboTwZ86xx+MyPF8cU/14Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nodE9k5v; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nodE9k5v"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 775B61595;
	Mon, 13 Jul 2026 07:06:11 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE9293F7B4;
	Mon, 13 Jul 2026 07:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951575; bh=O5obKWBC3f0nz8VhvV8KfQWeSGeWkfkmlsDJqw3Penk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nodE9k5vTbKKc6U9w7bmZEjQVkoZ9peDV0OhvaN9+Rw92spOUUxCq4pAIDkVflkWI
	 Cp9pH4bxPFf28N+icokpcQsfUVO7l+a1QY1iUrYIJP7D/FHJ4BkLLRcfnFXprOdVPr
	 2x500Re3yrbQzmWMB5who4Na7nUX0S9+jyNZ6Rek=
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
Subject: Re: [PATCH v4 5/6] KVM: arm64: Add HDBSS fault handling and buffer flush
Date: Mon, 13 Jul 2026 15:06:10 +0100
Message-ID: <alTw0nwiBDWoFrjB@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709104026.2612599-6-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-6-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 09, 2026 at 06:40:25PM +0800, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> Add HDBSS fault handling for buffer full, external abort, and general
> protection fault (GPF) events. When the HDBSS buffer becomes full,
> the hardware traps to EL2 with an HDBSSF event, which is handled by
> setting a flush request.
> 
> Add kvm_flush_hdbss_buffer() to consume HDBSS buffer entries and
> propagate dirty information into the userspace-visible dirty bitmap.
> Flush is triggered on vcpu_put, check_vcpu_requests, and
> sync_dirty_log.
> 
> Add esr_iss2_is_hdbssf() helper for HDBSS fault detection in guest
> abort handling.
> 
> Signed-off-by: Eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/esr.h           |  5 +++
>  arch/arm64/include/asm/kvm_dirty_bit.h | 11 +++++
>  arch/arm64/include/asm/kvm_host.h      |  1 +
>  arch/arm64/kvm/arm.c                   | 14 ++++++
>  arch/arm64/kvm/dirty_bit.c             | 62 ++++++++++++++++++++++++++
>  arch/arm64/kvm/mmu.c                   |  4 ++
>  6 files changed, 97 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 81c17320a588..2e6b679b5908 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -437,6 +437,11 @@
>  #ifndef __ASSEMBLER__
>  #include <asm/types.h>
> 
> +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
> +{
> +	return ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF;

This will return a long, which will be casted as bool.
In general, what I see in the kernel is something like:

	return !!(ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)

> +}
> +
>  static inline unsigned long esr_brk_comment(unsigned long esr)
>  {
>  	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> index 84b12f0a10af..4b28000e972f 100644
> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> @@ -10,7 +10,18 @@
>  #include <asm/kvm_pgtable.h>
>  #include <asm/sysreg.h>
> 
> +/* HDBSS entry field definitions */
> +#define HDBSS_ENTRY_VALID	BIT(0)
> +#define HDBSS_ENTRY_TTWL_SHIFT (1)
> +#define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
> +#define HDBSS_ENTRY_TTWL(x) \
> +	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
> +#define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
> +#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
> +
>  int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
>  void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
> 
>  #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c41ec6d9c45a..cecfb884a64f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -55,6 +55,7 @@
>  #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
>  #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
>  #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> +#define KVM_REQ_FLUSH_HDBSS			KVM_ARCH_REQ(12)
> 
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>  				     KVM_DIRTY_LOG_INITIALLY_SET)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index bf6688245d83..566953a4e23a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -755,6 +755,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  		kvm_vcpu_put_hw_mmu(vcpu);
>  	kvm_arm_vmid_clear_active();
> 
> +	if (vcpu->kvm->arch.enable_hdbss)
> +		kvm_flush_hdbss_buffer(vcpu);
> +
>  	vcpu_clear_on_unsupported_cpu(vcpu);
>  	vcpu->cpu = -1;
>  }
> @@ -1157,6 +1160,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  		if (kvm_dirty_ring_check_request(vcpu))
>  			return 0;
> 
> +		if (kvm_check_request(KVM_REQ_FLUSH_HDBSS, vcpu))
> +			kvm_flush_hdbss_buffer(vcpu);
> +
>  		check_nested_vcpu_requests(vcpu);
>  	}
> 
> @@ -1971,7 +1977,15 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
> 
>  void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
> +	/*
> +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> +	 * before reporting dirty_bitmap to userspace. Send a request with
> +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
> +	 */
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> 
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS | KVM_REQUEST_WAIT);
>  }
> 
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 6c7a6ef66b5a..002366337637 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -50,3 +50,65 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> 
>  	vcpu->arch.hdbss.hdbssbr_el2 = 0;
>  }
> +
> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> +{
> +	int idx, curr_idx;
> +	u64 *hdbss_buf;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> +
> +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
> +
> +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
> +	if (curr_idx == 0 || vcpu->arch.hdbss.hdbssbr_el2 == 0)
> +		return;
> +
> +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
> +	if (!hdbss_buf)
> +		return;
> +
> +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
> +	for (idx = 0; idx < curr_idx; idx++) {
> +		u64 gpa;
> +
> +		gpa = hdbss_buf[idx];
> +		if (!(gpa & HDBSS_ENTRY_VALID))
> +			continue;
> +
> +		gpa &= HDBSS_ENTRY_IPA;
> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);

You mention that it does not support dirty-ring, but above function will 
mark the page as dirty in the dirty-ring :/


> +	}
> +
> +	/* reset HDBSS index */
> +	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
> +	vcpu->arch.hdbss.hdbssprod_el2 = 0;
> +	isb();
> +}
> +
> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
> +{
> +	u64 prod;
> +	u64 fsc;
> +
> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
> +	fsc = FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);
> +
> +	switch (fsc) {
> +	case HDBSSPROD_EL2_FSC_OK:
> +		/* Buffer full, set request to flush on next vcpu exit */
> +		kvm_make_request(KVM_REQ_FLUSH_HDBSS, vcpu);
> +		return 1;
> +	case HDBSSPROD_EL2_FSC_ExternalAbort:
> +	case HDBSSPROD_EL2_FSC_GPF:
> +		return -EFAULT;
> +	default:
> +		/* Unknown fault. */
> +		WARN_ONCE(1,
> +			  "Unexpected HDBSS fault type, FSC: 0x%llx (prod=0x%llx, vcpu=%d)\n",
> +			  fsc, prod, vcpu->vcpu_id);
> +		return -EFAULT;
> +	}
> +}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 83251d95bf3f..949fb895add6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2242,6 +2242,7 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>  }
> 
>  /**
> +
>   * kvm_handle_guest_abort - handles all 2nd stage aborts
>   * @vcpu:	the VCPU pointer
>   *
> @@ -2279,6 +2280,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> 
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> 
> +	if (esr_iss2_is_hdbssf(esr))
> +		return kvm_handle_hdbss_fault(vcpu);
> +
>  	if (esr_fsc_is_translation_fault(esr)) {
>  		/* Beyond sanitised PARange (which is the IPA limit) */
>  		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> --
> 2.33.0
> 
