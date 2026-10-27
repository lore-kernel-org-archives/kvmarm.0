Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124824;
	b=EsDD3Yx+mR7U+Mn/JEDO2swXqOaoav96lUDEK/hwPoAPoTycg0BUlRBOKyu84K2sl2rV
	 rnAql0dFfIhPIOHpf6SXAmjhJE8eDgyDFr1j/OMcgtCvs3jvzreS9dhehIS2OiVZXuSEM
	 +1KqyKhm5D9pnSiaj/OwSTwWLwPq9Eh3lI1XZgFJuCvYGE/wlnaM3+KOueDZuaoOfagCJ
	 OnzWY5hDXRkgdzsTIRPjLexKEiNupGGNA8cFti2VVhvB4qGRLIvAEtllv3139PQBInm1k
	 QD7Q7lzwx1YZ3Os5s5ycrMaV9JI3Kb8EE1sLq1BeLkVyUqny+xttT30y9phzSkia+ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124824;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=SEGsNEKzJFKAXCSwgMTuyhg9hYL4zxxvha+xxLEPLv0=;
	b=sHb+kRLY/FSWWEYb6qgoSPtQhPNmo0AiBKAtxkOt+iDkUzaFerkjLOVRDaQTk2i9xshS
	 cuBkU7F+b3l/T3zG7K+66xd4PVux3IzKCOLKgsTb4ZRrJM74GMCrQsEyYqJKD4QM4IAql
	 2ULgn5xUbU4LbUKo637HiwL+Z9+NKOuhrW5VyAJzu1G5HpX8lrElaXfAvempd++uChD04
	 YnygOdiFpAElpX/5QWpqzvXs2eW9cmeftsyOu6Sj5yfxTkJX7W5KKLgQ9X8DxK/3/NGhA
	 auBzsZNs//MxtkKYf/2/6YjTBvLwFr18zF37sxR2oHhftXwGSordg/CElrOxzGRxNoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MRWCaJvB;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857C8606A31D
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 18:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 857C8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MRWCaJvB
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5256C1650;
	Tue, 27 Oct 2026 11:13:39 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2746E3F59E;
	Tue, 27 Oct 2026 11:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793124822; bh=StP32dfIcKd8YphSKpAL+/HMutnlIIEzCaQQmma93NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRWCaJvB6Q28OPTMIyyC6DjI8k5TlohZktMkWptC/He2/3HJxzp5kYwhVFDcW74p3
	 o33mnJ07QNYP5dUnmQi2BdWSac/cz93NF/qOl3XcNpzMvuUI9ZLP8rq0VqQ5Xx4KuG
	 8wbM62lsVAv+Qy+Es7f5beZKEbQGV8ixw8A3RHbI=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 08/15] KVM: arm64: Flush the HDBSS buffer on VM exit
Date: Tue, 27 Oct 2026 18:13:35 +0000
Message-ID: <auDpyRNpeDNzIk3W@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929103655.85107-9-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-9-zhengtian10@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 29, 2026 at 06:36:48PM +0800, Tian Zheng wrote:
> From: Eillon <yezhenyu2@huawei.com>
> 
> HDBSS entries accumulate in the per-vCPU buffer while the guest runs,
> and must be drained into the dirty bitmap or dirty ring before
> userspace can observe them.
> 
> Drain the buffer at a single point: kvm_arch_vcpu_ioctl_run() flushes
> it on every VM exit, before the exit reason is handled. Flushing
> inside the run loop keeps the dirty-ring feedback timely: when a flush
> pushes the ring past its soft limit, kvm_dirty_ring_push() raises
> KVM_REQ_DIRTY_RING_SOFT_FULL, which check_vcpu_requests() observes at
> the top of the next loop iteration, so the vCPU exits to userspace for
> the harvest before re-entering the guest.
> 
> kvm_arch_sync_dirty_log() relies on the exit path to flush: it kicks
> vCPUs out of guest mode, and the GET/CLEAR protocol tolerates
> concurrent bitmap writes, so the snapshot is complete without extra
> synchronization.
> 
> Signed-off-by: Eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_dirty_bit.h | 15 +++++++++
>  arch/arm64/kvm/arm.c                   | 20 ++++++++++++
>  arch/arm64/kvm/dirty_bit.c             | 45 ++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> index fe703f02626b..d828e6b43fe9 100644
> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> @@ -13,6 +13,9 @@
>  #include <asm/sysreg.h>
>  #include <linux/sizes.h>
> 
> +#define HDBSS_ENTRY_VALID	BIT(0)
> +#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
> +
>  #define KVM_ARM_HDBSS_DEFAULT_SIZE  PAGE_SIZE
>  #define KVM_ARM_HDBSS_MAX_SIZE      SZ_2M
> 
> @@ -22,7 +25,19 @@ static inline u32 kvm_hdbss_buffer_size(struct kvm *kvm)
>  	return kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
>  }
> 
> +static inline bool kvm_hdbss_enabled(struct kvm *kvm)
> +{
> +	return kvm->arch.mmu.vtcr & VTCR_EL2_HDBSS;
> +}
> +
> +static inline bool vcpu_hdbss_enabled(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.hw_mmu &&
> +		(vcpu->arch.hw_mmu->vtcr & VTCR_EL2_HDBSS);
> +}
> +

IIUC, arch.mmu is always the canonical s2_mmu, while hw_mmu can be the 
nested s2_mmu, if enabled.

Was that your intend here?
If not, we could use only kvm* version, which can be called with vcpu->kvm.

If it was, then I would like to understand the logic here, as IIUC the 
buffer is accessible only for the non-nested guest, as it's 
allocated in a per-vcpu structure. (vcpu->arch)

>  int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu);
>  void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> 
>  #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 5ea4ac26995e..9d7bdece149a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1430,6 +1430,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> 
>  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> 
> +		/*
> +		 * Drain the HDBSS buffer before the exit is handled, so
> +		 * entries pushed to the dirty ring are accounted for by
> +		 * dirty_ring_check_request() on the next iteration.
> +		 */
> +		if (vcpu_hdbss_enabled(vcpu))
> +			kvm_flush_hdbss_buffer(vcpu);
> +
>  		/* Exit types that need handling before we can be preempted */
>  		handle_exit_early(vcpu, ret);
> 


looks the correct place, haven't looked too much on that, though.


> @@ -2017,7 +2025,19 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
> 
>  void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
> +	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> 
> +	if (!kvm_hdbss_enabled(kvm))
> +		return;
> +
> +	/*
> +	 * The buffer is drained on every VM exit, so kicking running
> +	 * vCPUs is enough to flush them; the dirty-log GET/CLEAR
> +	 * protocol tolerates bits set concurrently with the snapshot.
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_vcpu_kick(vcpu);
>  }
> 
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index f9aeb9f34ad0..be0d12555c84 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -13,6 +13,7 @@
>  #include <linux/kconfig.h>
>  #include <linux/log2.h>
>  #include <linux/mm.h>
> +#include <linux/srcu.h>
> 

Out of curiosity, could you please explain you reasoning on selecting srcu 
as locking here? 

(Like, what are you protecting against, and why srcu is a good choice)

>  int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu)
>  {
> @@ -53,3 +54,47 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hdbss.hdbss_pg = NULL;
>  	vcpu->arch.hdbss.hdbssbr_el2 = 0;
>  }
> +
> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> +{
> +	int idx, curr_idx;
> +	u64 prod;
> +	u32 entries;
> +	u64 *hdbss_buf;
> +	struct kvm *kvm = vcpu->kvm;
> +	int srcu_idx;
> +
> +	if (!vcpu_hdbss_enabled(vcpu))
> +		return;

You test this before calling, is it really necessary to test it again, just 
after calling?

> +
> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
> +	curr_idx = HDBSSPROD_IDX(prod);
> +
> +	if (curr_idx == 0 || !vcpu->arch.hdbss.hdbss_pg)
> +		return;
> +
> +	hdbss_buf = page_address(vcpu->arch.hdbss.hdbss_pg);
> +	if (!hdbss_buf)
> +		return;
> +
> +	entries = kvm_hdbss_buffer_size(kvm) / sizeof(u64);
> +
> +	/* kvm_vcpu_mark_page_dirty() resolves the memslot under SRCU. */
> +	srcu_idx = srcu_read_lock(&kvm->srcu);
> +	for (idx = 0; idx < min_t(u32, curr_idx, entries); idx++) {
> +		u64 gpa;
> +
> +		gpa = hdbss_buf[idx];
> +		if (!(gpa & HDBSS_ENTRY_VALID))
> +			continue;
> +
> +		gpa &= HDBSS_ENTRY_IPA;
> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> +	}
> +	srcu_read_unlock(&kvm->srcu, srcu_idx);
> +
> +	prod &= ~HDBSSPROD_EL2_INDEX_MASK;
> +	write_sysreg_s(prod, SYS_HDBSSPROD_EL2);
> +	vcpu->arch.hdbss.hdbssprod_el2 = prod;
> +	isb();
> +}
> --
> 2.43.0
> 


Thanks!
Leo

