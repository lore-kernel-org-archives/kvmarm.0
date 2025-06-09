Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB75813AC1
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 04:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749442138; cv=none; b=EPjQ178gkFuFELtIWRrjSg3dLGxR4yYO07P2L5p7n3qq1JiVMvSTGY6Vab+fqdL28GVj4Ri/45sckYHI7WmcL2c10duOqkNdizGEwVOWb2Um61lUyaPN1UoCUx8Qe13bLjkKGE79yepBkv5DGGmaZQq7pjxtbvhA3TqV5tVPFSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749442138; c=relaxed/simple;
	bh=iqnb+ZB/2oTCUBhWTrXa/vqr3Uz8tsvhBI9pDkDNIrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dnV19hh4A25blqp2KzGeBLvxGRQaKLfEPZewdGqTy8k+y+07bzFyinGEAZU6bG2LN8iBfxpNJF1aVXv7MYWlxVCN2ZqQKaw1xU3VJMGm9nNlQV7s/Nkjtbj9KX2BA0auCo20ZgllRSYN3+Wb0sDzNHffratLGipi0bFexh8sS0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DuTTgJh5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DuTTgJh5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749442135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=znSV+kVarM376WETpFG5vxmhQ7lGKQs0oHqrXu/evqo=;
	b=DuTTgJh5mU6sc0wFuyLgBk1o2THkQ4slMsQaknxRi8Ti7Mw3TBtnAhXpciRG2aTLq1IOPx
	+q6M4ZQib55/6JWYUvixPLm2L8ibLRLx4KgwZJsrOsI6narV4cLvJXFTKZlFbTvaLXbphN
	PXP8Sa67bju1ZvliA365XqIal8RU6yY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-oSEbCswVNYStsXIcijHjdw-1; Mon, 09 Jun 2025 00:08:54 -0400
X-MC-Unique: oSEbCswVNYStsXIcijHjdw-1
X-Mimecast-MFC-AGG-ID: oSEbCswVNYStsXIcijHjdw_1749442133
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7395d07a3dcso2858376b3a.3
        for <kvmarm@lists.linux.dev>; Sun, 08 Jun 2025 21:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749442133; x=1750046933;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=znSV+kVarM376WETpFG5vxmhQ7lGKQs0oHqrXu/evqo=;
        b=iMGxrTpS2PRZUyDuFKggmSQzkteizJjU8e+fckA9F72czy0rfBwxRjDcHFpNltwh2n
         9iZN53qZg88vauPM7TYa7RSWgmQpIyluyXXs8FNmEGPi/A/Z+ecBXxBbbcr7dm5JKi2E
         +Fwj9UJHhVT8CFp2qL7R8EkYtN1v5Nt2jg2eLv0wGgQerel7/W8Hvw6kc/yZeXEDKwud
         Ldd3+/iHuVIJbuHOSzK6/wiXQUJ++PAuXoK9B8AKZZrTGRfE04j/hhdY7KJjU580HRz8
         EVlC6XKnrxwHEKRyKp4XWKQctvQzBxU8+zJSjmqpXLRDtDp748KK8lQld4vWurnIuFzV
         Nvqw==
X-Forwarded-Encrypted: i=1; AJvYcCVcbzBVPC8Ak8rygmkc23KYYSOmSiJL+veiFySq0UwDfIBhMFHdIXYJWsl0nDkEUQSbHr5AoKg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfJ0D/Z6eWskMkPZMrqopSPeHpIjc2KzK+8WypLzPclYn86Uh8
	1u03mStUdifT89frxBhHUxnQQifCZMUtaMZz7HdgoReyOdft7yLqByT5l5qbyvrhRvLRqu6rV4X
	L/Zp7EbPrzvd8RqWzk7pUSMo824WSKirLjnnH6m3p6rrKDwaOLnrG+QTBtQ==
X-Gm-Gg: ASbGncuo6k5yDYVXP2XzrDG/AAnJcad0q2t11DdWkghIFwukH9i60vv2k//ie6fapDH
	8WRxlAMBFAknmKyUWVVWv2GSCHwoUZu9kKy9wAaW7cAhnGLE34AcjebRitvNNt8hjjfDYjPImdX
	7S5dJxjZSxo/uAR71A9ctZnuKo0XftnDpSnbXHEE5BnvklK9yZjY4OlLEE3IamKHo95tgtpJH3/
	TiXnGxcJGxNIieevrfKBQ0H37b8dwrjK0lIeDHcLciYuWIEDhGns3rtxOICTQ2zSDrvVo7Kb0Tj
	k0g4ZNn1ViGYHnlfX54k0oIohxl8QjRbAEtv+n+J1uqa5NyvTp8=
X-Received: by 2002:a05:6a00:1caa:b0:740:596b:4a7f with SMTP id d2e1a72fcca58-74827f10b78mr13424985b3a.16.1749442133329;
        Sun, 08 Jun 2025 21:08:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7m/zTCGkEamABNbzON01NHA2JLBsIZ9H30Axsha6qHcMH8sLupDXiKBcrqXD+K67xykgA3w==
X-Received: by 2002:a05:6a00:1caa:b0:740:596b:4a7f with SMTP id d2e1a72fcca58-74827f10b78mr13424895b3a.16.1749442132715;
        Sun, 08 Jun 2025 21:08:52 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af382fcsm4806740b3a.28.2025.06.08.21.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 21:08:52 -0700 (PDT)
Message-ID: <3d9a15ff-fbb2-4e9a-b97b-c0e40eb23043@redhat.com>
Date: Mon, 9 Jun 2025 14:08:30 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-15-tabba@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-15-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X1cUcPv3fkBZY3hUunVpvDcXIjr9YnU5JhwwaZk4F00_1749442133
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> Add arm64 support for handling guest page faults on guest_memfd backed
> memslots. Until guest_memfd supports huge pages, the fault granule is
> restricted to PAGE_SIZE.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 90 insertions(+), 3 deletions(-)
> 

One comment below. Otherwise, it looks good to me.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ce80be116a30..f14925fe6144 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>   	*prot |= kvm_encode_nested_level(nested);
>   }
>   
> +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> +
> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +		      struct kvm_s2_trans *nested,
> +		      struct kvm_memory_slot *memslot, bool is_perm)
> +{
> +	bool logging, write_fault, exec_fault, writable;
> +	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +	struct page *page;
> +	struct kvm *kvm = vcpu->kvm;
> +	void *memcache;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +	int ret;
> +
> +	ret = prepare_mmu_memcache(vcpu, !is_perm, &memcache);
> +	if (ret)
> +		return ret;
> +
> +	if (nested)
> +		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> +	else
> +		gfn = fault_ipa >> PAGE_SHIFT;
> +
> +	logging = memslot_is_logging(memslot);
> +	write_fault = kvm_is_write_fault(vcpu);
> +	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> +
> +	if (write_fault && exec_fault) {
> +		kvm_err("Simultaneous write and execution fault\n");
> +		return -EFAULT;
> +	}
> +
> +	if (is_perm && !write_fault && !exec_fault) {
> +		kvm_err("Unexpected L2 read permission error\n");
> +		return -EFAULT;
> +	}
> +
> +	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> +	if (ret) {
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> +					      write_fault, exec_fault, false);
> +		return ret;
> +	}
> +

-EFAULT or -EHWPOISON shall be returned, as documented in virt/kvm/api.rst. Besides,
kvm_send_hwpoison_signal() should be executed when -EHWPOISON is returned from
kvm_gmem_get_pfn()? :-)

Thanks,
Gavin

> +	writable = !(memslot->flags & KVM_MEM_READONLY) &&
> +		   (!logging || write_fault);
> +
> +	if (nested)
> +		adjust_nested_fault_perms(nested, &prot, &writable);
> +
> +	if (writable)
> +		prot |= KVM_PGTABLE_PROT_W;
> +
> +	if (exec_fault ||
> +	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> +	     (!nested || kvm_s2_trans_executable(nested))))
> +		prot |= KVM_PGTABLE_PROT_X;
> +
> +	kvm_fault_lock(kvm);
> +	if (is_perm) {
> +		/*
> +		 * Drop the SW bits in favour of those stored in the
> +		 * PTE, which will be preserved.
> +		 */
> +		prot &= ~KVM_NV_GUEST_MAP_SZ;
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
> +	} else {
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
> +					     __pfn_to_phys(pfn), prot,
> +					     memcache, flags);
> +	}
> +	kvm_release_faultin_page(kvm, page, !!ret, writable);
> +	kvm_fault_unlock(kvm);
> +
> +	if (writable && !ret)
> +		mark_page_dirty_in_slot(kvm, memslot, gfn);
> +
> +	return ret != -EAGAIN ? ret : 0;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_s2_trans *nested,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt;
>   	struct page *page;
> -	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
> +	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
>   
>   	if (fault_is_perm)
>   		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> @@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		goto out_unlock;
>   	}
>   
> -	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -			     esr_fsc_is_permission_fault(esr));
> +	if (kvm_slot_has_gmem(memslot))
> +		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> +				 esr_fsc_is_permission_fault(esr));
> +	else
> +		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> +				     esr_fsc_is_permission_fault(esr));
>   	if (ret == 0)
>   		ret = 1;
>   out:

