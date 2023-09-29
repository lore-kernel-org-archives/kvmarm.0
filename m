Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51298BFB
	for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 23:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696031637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gg+ZFNjMtjrBYYTGlZDlQHf/h2wmW7KvioEkaxoQqFA=;
	b=dTDuGnpg7hJoYDvytejeO2nouKTr4ooCY+tBvsu96j8LSYaDVLDBQrqQTXAcb7vdp2T2lx
	rHi6URQS9wmjEG1qrW3kGMYn+ZPyZ1vMEY7zehavRxKVO2YdJRdLTmusxuG7bwie58FUqo
	W1jjo2WrncCdXb0eS6nxaU57FKPkfMI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-JrDBW5RKOSm44w6h28jtBQ-1; Fri, 29 Sep 2023 19:53:55 -0400
X-MC-Unique: JrDBW5RKOSm44w6h28jtBQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-279353904a9so948081a91.3
        for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 16:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696031634; x=1696636434;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gg+ZFNjMtjrBYYTGlZDlQHf/h2wmW7KvioEkaxoQqFA=;
        b=O80R/J4alGW544lTWoLII/EEnQsKcJqvWiaDG1dsH/O/AcUrc89lYzorYuDSFy4xLP
         OiOOvxfCJFotL51WfDgNEPbTlbYY8bnaikng8untcC3GGL3TC7E49qzcw8bWVkd3qL27
         KpwaV0069gZ5dKywTHCqDeVkDiDgl1BtZFUL1FxgqdD+HwP+dj2X1qsHQ9lX3q5GYd5t
         kkqOiFqa5DS2JAxITXi1o7bf36bq1rKyKHyR+FpnB6vZpevLsJU4kkhpRtreJRrU+yd2
         twDtDGvI9g5M3jmkMDKUMzV7SHFU0cJRA3HmV6TCl1OKiE3qcGKReU2XvUy/rhBnxAsH
         Oh0w==
X-Gm-Message-State: AOJu0YzNf0WBe+xPgGc2zXYXRhTfV5UywdMLxdyuwT6QD8BrCmL7aDVy
	iOj/vUaYLpyDn0JITRG30NVhm46Zlv+4hFpM9xKpRM8dQgYfy1NwGdrPp/sRMg/4ZsmhIwacGXl
	H5jHUbJlqicpKeCDp
X-Received: by 2002:a17:902:e809:b0:1c5:6d04:75ee with SMTP id u9-20020a170902e80900b001c56d0475eemr5887886plg.21.1696031634403;
        Fri, 29 Sep 2023 16:53:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTRgYai7YJJHrkSTs/js26FoVk+Qtz+ItASXxtFqKEp6baT7304RPQVm+TCKbFILRKmw+9ug==
X-Received: by 2002:a17:902:e809:b0:1c5:6d04:75ee with SMTP id u9-20020a170902e80900b001c56d0475eemr5887874plg.21.1696031634064;
        Fri, 29 Sep 2023 16:53:54 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id a5-20020a170902ee8500b001c62d63b817sm8282818pld.179.2023.09.29.16.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 16:53:53 -0700 (PDT)
Message-ID: <9aa58167-3a6b-7b61-1977-05b327f080aa@redhat.com>
Date: Sat, 30 Sep 2023 09:53:48 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use folio for THP adjustment
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
 oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, will@kernel.org, willy@infradead.org
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-3-vdonnefort@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230928173205.2826598-3-vdonnefort@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/23 03:32, Vincent Donnefort wrote:
> Since commit cb196ee1ef39 ("mm/huge_memory: convert
> do_huge_pmd_anonymous_page() to use vma_alloc_folio()"), transparent
> huge pages use folios. It enables us to check efficiently if a page is
> mapped by a block simply looking at the folio size. This is saving a
> page table walk.
> 
> It is safe to read the folio in this path. We've just increased its
> refcount (GUP from __gfn_to_pfn_memslot()). This will prevent attempts
> of splitting the huge page.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index de5e5148ef5d..69fcbcc7aca5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -791,51 +791,6 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>   	return 0;
>   }
>   
> -static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
> -	/* We shouldn't need any other callback to walk the PT */
> -	.phys_to_virt		= kvm_host_va,
> -};
> -
> -static int get_user_mapping_size(struct kvm *kvm, u64 addr)
> -{
> -	struct kvm_pgtable pgt = {
> -		.pgd		= (kvm_pteref_t)kvm->mm->pgd,
> -		.ia_bits	= vabits_actual,
> -		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
> -				   CONFIG_PGTABLE_LEVELS),
> -		.mm_ops		= &kvm_user_mm_ops,
> -	};
> -	unsigned long flags;
> -	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
> -	u32 level = ~0;
> -	int ret;
> -
> -	/*
> -	 * Disable IRQs so that we hazard against a concurrent
> -	 * teardown of the userspace page tables (which relies on
> -	 * IPI-ing threads).
> -	 */
> -	local_irq_save(flags);
> -	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
> -	local_irq_restore(flags);
> -
> -	if (ret)
> -		return ret;
> -
> -	/*
> -	 * Not seeing an error, but not updating level? Something went
> -	 * deeply wrong...
> -	 */
> -	if (WARN_ON(level >= KVM_PGTABLE_MAX_LEVELS))
> -		return -EFAULT;
> -
> -	/* Oops, the userspace PTs are gone... Replay the fault */
> -	if (!kvm_pte_valid(pte))
> -		return -EAGAIN;
> -
> -	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
> -}
> -
>   static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.zalloc_page		= stage2_memcache_zalloc_page,
>   	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
> @@ -1274,7 +1229,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>    *
>    * Returns the size of the mapping.
>    */
> -static long
> +static unsigned long
>   transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   			    unsigned long hva, kvm_pfn_t *pfnp,
>   			    phys_addr_t *ipap)
> @@ -1287,10 +1242,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   	 * block map is contained within the memslot.
>   	 */
>   	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> -		int sz = get_user_mapping_size(kvm, hva);
> -
> -		if (sz < 0)
> -			return sz;
> +		size_t sz = folio_size(pfn_folio(pfn));
>   
>   		if (sz < PMD_SIZE)
>   			return PAGE_SIZE;
> @@ -1385,7 +1337,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	kvm_pfn_t pfn;
>   	bool logging_active = memslot_is_logging(memslot);
>   	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
> -	long vma_pagesize, fault_granule;
> +	unsigned long vma_pagesize, fault_granule;
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt;
>   
> @@ -1530,11 +1482,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
>   								   hva, &pfn,
>   								   &fault_ipa);
> -
> -		if (vma_pagesize < 0) {
> -			ret = vma_pagesize;
> -			goto out_unlock;
> -		}
>   	}
>   
>   	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {

