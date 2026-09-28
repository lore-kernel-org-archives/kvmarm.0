Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF969335555
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 01:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790557782; cv=none; b=j91db8pTspDhYF2bK3nSTWwssfxyA2kkcAdrHHlDJHDiV6uQNblJNVhHV210ZqfW8YHXxKJy8lNPxKbTNWGufoKfVx1QUXIzrXR9UvmLh6XLbkVh6qAC63TR1RBJ03fdB+q/a/pcprDp0/PfhsGUiH/jRCjR3KSdaSj1eEfoQYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790557782; c=relaxed/simple;
	bh=WOzxvxqjOyrCq/xhej0a9WYIO2SMCDEzRqeib7Lbsbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XB3+cVzbLAblFgsqXfiZpy0zh6kEpf9SDp5KBkAiNtBQfF42IMTB/IoJORF9jKzG1LmaT2N+mucWR6p7pPyC9EqtPOfhb8q1W1lksXWNaocqTXEP3fTplkoAouCW+CGk0YdwdflxofFRQhxLJ7k5f7wAqJOlkW7ghKzjgXUP4J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ewSQZ7iR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewSQZ7iR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790557778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQVyViu54NB5xRZNuwGjPRH433mqlPk//gSi3xAbMRk=;
	b=ewSQZ7iRfyHAI0kZW6VLVwfmtHbzPrPbUAJ+8PWl2Y/qp0Qwc8iwPSbSwrN/c7ePUm1hkM
	8KIZ0K8Hdv+zWM8yqTv/C4Mnn4LYGBq/v/d3gHIOx1QpwkO98L8ONckMn72+eko3uiSjo5
	e3dNAtzyRJqqRfKr2jsLQhE+cjUYpiE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-cixufL4AMCa4EUTmBq6yow-1; Sun, 27 Sep 2026 21:09:36 -0400
X-MC-Unique: cixufL4AMCa4EUTmBq6yow-1
X-Mimecast-MFC-AGG-ID: cixufL4AMCa4EUTmBq6yow_1790557775
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39e087a17dfso3785479a91.3
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 18:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790557775; x=1791162575;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AQVyViu54NB5xRZNuwGjPRH433mqlPk//gSi3xAbMRk=;
        b=mHpYk4vbgIwD9ooLXxebm7Nu4UPQJ8alO6NvuqCG+pEQ3x2qFPPE29xMwEi9HPxQYd
         tYmLNRQlU/Ve91+Mx0vfOCjygKIVh8HDgC1rV6Jm4eze2/FlMt1w6lQLy0bssizRqSml
         k6pWrGc2pFnMs7CxFrXS2pJrB2HYDAG9fkJDbuBp+Jowyy8hu8lMnw0qLT8fKPnRhFAb
         /UcA/7SHJCVQfQZDjkhfuVt2vAjjaR61qSDtc1amFImCPxyCLrBdpN5hHs3ByQv6nCgZ
         ZwTqZXiI6mAU8HyuOdmxqUOQPRZxH8slKn+3tl8dvq8JUg1u5UglfmoCS40pGD4a1o+J
         omSQ==
X-Forwarded-Encrypted: i=1; AKwUvBwRJEjQb3U8bZRdV0+6mdlfJzFjeWNPEsM9qYQzULXZQBU5lKNAEayUxgKpiOyVc+4MfLV9LlM=@lists.linux.dev
X-Gm-Message-State: AFq9FYL085fkt4Mb3M4Hh8WiuAX4xu3vUkex6rNxao8pkzKmG8beXNdo
	lshY95npw+j4UyezjSf3RJc1lSD3YOLXr8AqlvERs88Nl7oX3yGPiLED7Z45N6P9b31OjCyfEmU
	A5qzPCqfM0s+JtAwGYaxRVCpKS7bP1opG8jcO9oUO2yZ7xnvgwKmnGtKhkw==
X-Gm-Gg: AYBFou050QMJO0uxDpx/VMMnuvrALzq0bQ2r8Wbv1tpfP1/0um2peAXSalfiF93gOQi
	bFV2QA/kCQgFj8klERKo3xjigpN8i4bRwcN10raTBqIqbdWmE6DnprrM/fFcRR9drINWQpMtQ2F
	+85Jep5qtJwHm320A5AfrGRtStmCSAF5Q3mGfujhqwk4hoZQ+u5cmpMa4mJJdu3eLVQSOfReMXf
	1Zf4o+JH+zOIPWAJmPw2lk+jOcz67Cv6/Ex1DD5g1cvZZtd2G3ESTBt5GbCyjzUyWV/1BWKTuDi
	nb0TTPuan2pnBsPfr83rogaECeGrXlnTahF7u0F8xnDgTFhN5OaWqgZz/ZupXhG2FiW2vArc41F
	5NvKR0be8f4A8VASmUFMa8bxYpDmDd9IA4dDhGUuE6g==
X-Received: by 2002:a17:90a:e183:b0:3a0:a912:e768 with SMTP id 98e67ed59e1d1-3a0a912ebe3mr7728696a91.15.1790557775131;
        Sun, 27 Sep 2026 18:09:35 -0700 (PDT)
X-Received: by 2002:a17:90a:e183:b0:3a0:a912:e768 with SMTP id 98e67ed59e1d1-3a0a912ebe3mr7728660a91.15.1790557774598;
        Sun, 27 Sep 2026 18:09:34 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df964d46b0sm30757145ad.15.2026.09.27.18.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 18:09:34 -0700 (PDT)
Message-ID: <647ae455-4175-4070-a40e-d2d89f18971f@redhat.com>
Date: Mon, 28 Sep 2026 11:09:26 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 09/20] KVM: arm64: Add VM specific callback for S2 MMU
 operations
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-10-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-10-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qNjFiYkSr9Dcid_MB9pfrCceOduCgg80cEw6M0xxvfg_1790557775
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
> Add VM type specific S2 MMU operation backends which can be initialized per
> VM flavor, to keep the handling cleaner.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  15 ++++
>   arch/arm64/kvm/mmu.c              | 137 +++++++++++++++++++++++++-----
>   2 files changed, 131 insertions(+), 21 deletions(-)
> 

Apart from the comments from Jonathan, some nitpicks and questions below.

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 149f4582c8b6a..7664d8b8cce5a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -155,6 +155,19 @@ struct kvm_vcpu_ops {
>   	void (*vcpu_put)(struct kvm_vcpu *vcpu);
>   };
>   
> +struct kvm_gfn_range;
> +
> +struct kvm_vm_s2_ops {
> +	bool (*vm_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
> +	bool (*vm_test_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
> +	int (*vm_flush_remote_tlbs)(struct kvm *kvm);
> +	int (*vm_flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
> +					  u64 nr_pages);
> +	void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
> +				      phys_addr_t start, u64 size,
> +				      bool may_block);
> +};
> +
>   struct kvm_s2_mmu {
>   	struct kvm_vmid vmid;
>   
> @@ -332,6 +345,8 @@ struct kvm_arch {
>   	 */
>   	u64 fgu[__NR_FGT_GROUP_IDS__];
>   
> +	const struct kvm_vm_s2_ops *vm_s2_ops;
> +
>   	/*
>   	 * Stage 2 paging state for VMs with nested S2 using a virtual
>   	 * VMID.
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 03f2017a7404a..d97a4a1bca23f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -37,6 +37,8 @@ static unsigned long __ro_after_init io_map_base;
>   
>   #define KVM_PGT_FN(fn)		(!is_protected_kvm_enabled() ? fn : p ## fn)
>   
> +static int kvm_vm_init_vm_s2_ops(struct kvm *kvm);
> +
>   static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
>   					   phys_addr_t size)
>   {
> @@ -166,6 +168,18 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>   	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
>   }
>   
> +static int pkvm_flush_remote_tlbs(struct kvm *kvm)
> +{
> +	kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
> +	return 0;
> +}
> +
> +static int kvm_vm_flush_remote_tlbs(struct kvm *kvm)
> +{
> +	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> +	return 0;
> +}
> +
>   /**
>    * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
>    * @kvm:	pointer to kvm structure.
> @@ -174,26 +188,36 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>    */
>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
> -	if (is_protected_kvm_enabled())
> -		kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
> -	else
> -		kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> -	return 0;
> +	if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs)
> +		return 1;

For the return value, I'm wandering if 0 should be returned. More details
can be found below.

> +	return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs(kvm);
>   }
>   
> -int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> -				      gfn_t gfn, u64 nr_pages)
> +static int pkvm_flush_remote_tlbs_range(struct kvm *kvm,
> +					gfn_t gfn, u64 nr_pages)
> +{
> +	return pkvm_flush_remote_tlbs(kvm);
> +}
> +
> +static int kvm_vm_flush_remote_tlbs_range(struct kvm *kvm,
> +					 gfn_t gfn, u64 nr_pages)
>   {
>   	u64 size = nr_pages << PAGE_SHIFT;
>   	u64 addr = gfn << PAGE_SHIFT;
>   
> -	if (is_protected_kvm_enabled())
> -		kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
> -	else
> -		kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
> +	kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
>   	return 0;
>   }
>   
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> +				     gfn_t gfn, u64 nr_pages)
> +{
> +	if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)
> +		return 1;
> +

Realm would the only case where vm_s2_ops->vm_flush_remote_{tlbs, tlbs_range)
are NULL. On request to flush remote TLBs by kvm_flush_remote_tlbs_range(), it
ends up with event KVM_REQ_TLB_FLUSH queued for each vCPU. How this queued event
is linked to a remote TLB flush for realm? The problem is TLBs are owned by EL2
realm and there are no RMI calls for the management. So I'm wandering we should
return 0 here?

> +	return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range(kvm, gfn, nr_pages);
> +}
> +
>   static void *stage2_memcache_zalloc_page(void *arg)
>   {
>   	struct kvm_mmu_memory_cache *mc = arg;
> @@ -337,13 +361,20 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   				   may_block));
>   }
>   
> +static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
> +				      phys_addr_t start,
> +				      u64 size, bool may_block)
> +{
> +	__unmap_stage2_range(mmu, start, size, may_block);
> +}
> +
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>   			    u64 size, bool may_block)
>   {
> -	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
> -		return;
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>   
> -	__unmap_stage2_range(mmu, start, size, may_block);
> +	if (kvm->arch.vm_s2_ops->vm_stage2_unmap_range)
> +		kvm->arch.vm_s2_ops->vm_stage2_unmap_range(mmu, start, size, may_block);
>   }
>   
>   void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> @@ -983,6 +1014,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	int cpu, err;
>   	struct kvm_pgtable *pgt;
>   
> +	/* Initialize the VM ops for the VM instance for the first time */
> +	if (mmu == &kvm->arch.mmu) {
> +		err = kvm_vm_init_vm_s2_ops(kvm);
> +		if (err)
> +			return err;
> +	}
>   	/*
>   	 * If we already have our page tables in place, and that the
>   	 * MMU context is the canonical one, we have a bug somewhere,
> @@ -2447,34 +2484,46 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   	return false;
>   }
>   
> -bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +static bool kvm_vm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
>   	u64 size = (range->end - range->start) << PAGE_SHIFT;
>   
> -	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
> -		return false;
> -
>   	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, true);
> +}
> +
> +bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +	if (!kvm->arch.mmu.pgt || !kvm->arch.vm_s2_ops->vm_age_gfn)
> +		return false;
> +
> +	return kvm->arch.vm_s2_ops->vm_age_gfn(kvm, range);
>   	/*
>   	 * TODO: Handle nested_mmu structures here using the reverse mapping in
>   	 * a later version of patch series.
>   	 */
>   }
>   
> -bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +static bool kvm_vm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
>   	u64 size = (range->end - range->start) << PAGE_SHIFT;
>   
> -	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
> -		return false;
>   
>   	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, false);
>   }
>   
> +bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +
> +	if (!kvm->arch.mmu.pgt || !kvm->arch.vm_s2_ops->vm_test_age_gfn)
> +		return false;
> +
> +	return kvm->arch.vm_s2_ops->vm_test_age_gfn(kvm, range);
> +}
> +
>   phys_addr_t kvm_mmu_get_httbr(void)
>   {
>   	return __pa(hyp_pgtable->pgd);
> @@ -2796,3 +2845,49 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>   
>   	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>   }
> +
> +static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
> +	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
> +	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
> +	/*
> +	 * Not supported for Protected VMs under pKVM
> +	 * .vm_age_gfn
> +	 * .vm_test_age_gfn
> +	 * .vm_stage2_unmap_range
> +	 */
> +};
> +
> +static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
> +	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
> +	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
> +	.vm_age_gfn			= kvm_vm_age_gfn,
> +	.vm_test_age_gfn		= kvm_vm_test_age_gfn,
> +	.vm_stage2_unmap_range		= kvm_vm_stage2_unmap_range,
> +};
> +
> +static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
> +	.vm_flush_remote_tlbs		= kvm_vm_flush_remote_tlbs,
> +	.vm_flush_remote_tlbs_range	= kvm_vm_flush_remote_tlbs_range,
> +	.vm_age_gfn			= kvm_vm_age_gfn,
> +	.vm_test_age_gfn		= kvm_vm_test_age_gfn,
> +	.vm_stage2_unmap_range		= kvm_vm_stage2_unmap_range,
> +};
> +
> +#define KVM_VM_S2_OPS(flavor, ops)		\
> +		[flavor] = ops

Parentheses are needed, to be consistent with KVM_VCPU_OPS at least.

#define KVM_VM_S2_OPS(flavor, ops)		\
		[(flavor)] = (ops)

Actually, KVM_{VCPU, VM_S2}_OPS() can be combined to one in kvm_host.h as below.

#define KVM_FLAVOR_OPS() [(flavor)] = (ops)

> +static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
> +	KVM_VM_S2_OPS(VM_VHE, &kvm_default_vm_s2_ops),
> +	KVM_VM_S2_OPS(VM_NVHE, &kvm_default_vm_s2_ops),
> +	KVM_VM_S2_OPS(VM_PKVM, &pkvm_vm_s2_ops),
> +	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, &protected_pkvm_vm_s2_ops),
> +};
> +
> +static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
> +{
> +	BUILD_BUG_ON(ARRAY_SIZE(arm64_vm_s2_ops) != VM_FLAVOR_MAX);
> +
> +	kvm->arch.vm_s2_ops = arm64_vm_s2_ops[kvm->arch.vm_flavor];
> +	if (WARN_ON(!kvm->arch.vm_s2_ops))
> +		return -EINVAL;
> +	return 0;
> +}

Thanks,
Gavin

