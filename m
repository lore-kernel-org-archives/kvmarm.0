Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489467;
	b=qKtG94XSP/JOTB58s67FlbgPTz7DFe+5Hy14gcefRJYlUYaIe+a722ixpqAEysgIKD7q
	 yRMaXfXTqQN4X4eddcsg+sWTEzXLCtZCkM4hh7zTO6fJMqTD9MG2oQpFAvxmPJp7085lA
	 q/Vfqu/JufKz7cWJLEtGfYBguH9JCfqMYBiPOcgteQg6fDyigTpeQ/NkPVNFCdykz1VGO
	 Dapzt+FzIWWiB16Vb68g03BBYv4C8ee9Nie729SIZV/UWp5Vvhi0ufZDsL0Ii0cQPdV7K
	 FHmZBOEvW2y7CqiTTVi5X+N64kePK8QqxpuwSO8CtENT+pjkVZJ58z+P1SPzQq3j3HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489467;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=J0NPd2sJLaiupFx719PpF/2OXb4U3bSy/8nJPIXJVTs=;
	b=TwhcYD/lh7EevLsHwMcg2MC6ASzZBK+qAUoJmUR3H9JKj0cP/U9MWAVmrpNRdldDNMAg
	 OksQLXdl8DRd0lqe51az053m5C0gzTGwsrVZIwHRe68Aay030a3VgtSEkteR+mHR4hvfY
	 PU3kOZJVl2S7xcWF7b8MdFP4Yn7Asbzc9m7E8dqQmOjgHV21Kd7fs3rNVuNAcx/vYoXug
	 347hl+UFJK8uPkJQ9CKvX0xcGCPR7cOE9qNQUSZSGD51psHDMHVf7Sx3fqwbKszlmW8cJ
	 wKEHeydrMsiNZugEqE0MOQbBhA7ZKXdnvbneNQQ366tYPRv1bQumGZ+da90PRhq7tYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fWYMWfb0;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E00606A321
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 13:17:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17E00606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fWYMWfb0
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so5466355e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 05:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794489465; x=1795094265; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J0NPd2sJLaiupFx719PpF/2OXb4U3bSy/8nJPIXJVTs=;
        b=fWYMWfb03Gum895Rqe6yP5cXmiBuyEIRJHjMBsllVCtFytYFdnM2H1ASqPXEFnTijY
         tG+jcIUmPrmm+AMQdc3lrc/E5piUJZvZKq15EZTYr1iZnxr+VCZ2cIBgEeT92rJR7OqJ
         NBAmbMGW9yOgNIaD68tr4TuMVz4i75I3y2cWu2cHOorHsEimXRCxhdcMppdyvjHVK94f
         myOLHDUx8a9tQDHH4aiybyYvi4gRozVaxNDHRiN4rhOF1UCJFqTt8HJZCWTOx3WNggi+
         LNgo9SB8kFxSsWXVVltRSPRc7hyZsXOdWq4NwSDDrUrvRMGviRQtg1zyRC5DkdvPZ0Vq
         OCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489465; x=1795094265;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=J0NPd2sJLaiupFx719PpF/2OXb4U3bSy/8nJPIXJVTs=;
        b=Ex6kBMBHuYDuTBRKVc4nvlPzy0Gs/mznxDEDOoXR32CRH30kKLGpnMDv6sprsrimTa
         /DpnrikpqkJG5AUBqwo56rBpZN663jTPS/VEWV4Wd8DuelYLKbXLmsdSpVDUO0uZgI5D
         92UJWNM2KqsTTnjCpgVye2aC12IRTnwRgS0KyBXtOsrf9YR4rkx5Ie91fKvAOsQ9v8G/
         6jGIX4NWUqyYpj2xnrlca91jqJhaFwe61HcQzdCHoPuiiNRjFmKvTAPgVJP4hgsEVTj5
         uGsJfiH5DxtN6ua/viMJhmxMhf1N2LWGczziRAWkjYZGMLVXEtQ4sPKVP0YA133NKbZk
         gInQ==
X-Gm-Message-State: APuU4Z8fpEyRhu+/ve6jO8sERKm8AEDDKsZuhZNgN4Kfr5ntirvtXiIS
	+hJT/wOViGA/24fR5FMexoOyQJZOy8SX6XiL3tA8K43iJ3Q63z7dKGUGIvO6R3x89Pzb+dSKo0b
	eRZiMGw==
X-Gm-Gg: AYBFou2Vl9A9LPeg6d7kW1ZNoxz2o2D7v4e+Z+U/irzXU12K2FAmQa/8yOJCNVp14y1
	pFcpeCKwCNfaZYGUbblUWTW6Um5c7ew365bGPfy7yWirw8Ax9z41kojz0xcMffqw7oheJKrvQG7
	7htsq8vMmxWoAsMyFbWRjEX/WSz0qKYZUUF3MAiu/bDvwHZCojNX6rVBOBecfooSbZyBkxp0+YX
	79Qo4d9rsfS4nG32MbRoBYxfJae4lZvj4ZuxC/Nd+cJReh+Pa6W9ouUGPJ57xQmpZcVjDgJi8tI
	I/bTgPCq1J+1thzl01qt88fznjzyc4ByqhCpUnPjME6MeqxUodn3h4ILflcULb2u4+jit00gwnZ
	XcSYXZ89Tg3dnSyD5LTN120Ozkz5fV61HGKDYs3kNfEKWVMcQwfq4EIrZ2T+/PP3oXuSeMEJdQU
	6niRh1lb+5GNpG72EcT8UlckqvfY52PV5M5TYKNdkdkvo6cCzoDWUrKGZ7uXE02cnwpwv+vzG5R
	sVIEUt6NsznHAM2KsP2hy6SjQ7iDQodE/ZHT/vUu7qeGNobFbHdCTTeSqJiBBxjtcC1LUEoPFXx
	s0NZWqWobr7dGw6bxAaGQTdnD0gJT40T4x+OQSfHQiLb+IR+cCAPeaTQDSaUhMVwqg==
X-Received: by 2002:a05:600c:870c:b0:4a2:180a:3417 with SMTP id 5b1f17b1804b1-4bb4e270881mr55125285e9.1.1794489464498;
        Thu, 12 Nov 2026 05:17:44 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2776casm101794785e9.14.2026.11.12.05.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:17:43 -0800 (PST)
Date: Thu, 12 Nov 2026 13:17:40 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 19/23] KVM: arm64: Add __pkvm_host_split_guest HVC
Message-ID: <avW8dIWt5VLbU5_t@google.com>
References: <20261102204628.401871-1-vdonnefort@google.com>
 <20261102204628.401871-20-vdonnefort@google.com>
 <sashiko-outbox-194185@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-194185@kernel.org>

On Mon, Nov 02, 2026 at 09:13:51PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] KVM: arm64: Missing host_stage2_try() when splitting host stage-2 GFN metadata
> --
> 
> commit 1780446e119343d8ac04e9e17e8d107c87019c8d
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Add __pkvm_host_split_guest HVC
> 
> This commit introduces the __pkvm_host_split_guest hypercall so the host can
> split a PMD block mapping in a protected VM's stage-2 page table and update
> the corresponding host stage-2 GFN metadata annotations to page granularity.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 88af0aec1ea92..7ecf4c98d7b5e 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> 
> [ ... ]
> 
> > @@ -690,17 +693,59 @@ static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
> >  		return -EPERM;
> >  
> >  	meta = FIELD_GET(KVM_HOST_DONATION_PTE_EXTRA_MASK, pte);
> > -	handle = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
> > -	*vm = get_vm_by_handle(handle);
> > -	if (!*vm) {
> > -		/* We probably raced with teardown; try again */
> > -		return -EAGAIN;
> > -	}
> > -
> > +	*handle = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
> >  	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
> >  	return 0;
> >  }
> >  
> > +static int host_stage2_split_gfn_meta(phys_addr_t phys, u64 ipa, u64 size, struct pkvm_hyp_vm *vm)
> > +{
> > +	struct kvm_pgtable_mm_ops *mm_ops = &host_mmu.mm_ops;
> > +	struct kvm_pgtable *pgt = &host_mmu.pgt;
> > +	kvm_pte_t pte, *table, *ptep;
> > +	pkvm_handle_t handle;
> > +	s8 level;
> > +	u64 gfn;
> > +	int ret;
> > +
> > +	ret = kvm_pgtable_get_leaf(pgt, phys, &pte, &level, 0);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (kvm_granule_size(level) != size)
> > +		return -EINVAL;
> > +
> > +	ret = host_stage2_decode_gfn_meta(pte, &handle, &gfn);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (handle != vm->kvm.arch.pkvm.handle || gfn != (ipa >> PAGE_SHIFT))
> > +		return -EINVAL;
> > +
> > +	table = mm_ops->zalloc_page(&host_s2_pool);
> > +	if (!table)
> > +		return -ENOMEM;
> 
> [ ... ]
> 
> > @@ -1778,6 +1830,55 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> >  	return 0;
> >  }
> >  
> > +int __pkvm_host_split_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu)
> > +{
> > +	struct kvm_hyp_memcache *mc = &vcpu->vcpu.arch.stage2_mc;
> > +	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> > +	u64 size = nr_pages << PAGE_SHIFT;
> > +	u64 ipa = hyp_pfn_to_phys(gfn);
> > +	kvm_pte_t pte, *table;
> > +	phys_addr_t phys;
> > +	s8 level;
> > +	int ret;
> > +
> > +	if (!mc->nr_pages)
> > +		return -ENOMEM;
> > +
> > +	if (size != PMD_SIZE || !IS_ALIGNED(ipa, PMD_SIZE))
> > +		return -EINVAL;
> > +
> > +	level = KVM_PGTABLE_LAST_LEVEL - 1;
> > +
> > +	host_lock_component();
> > +	guest_lock_component(vm);
> > +
> > +	ret = get_valid_guest_pte(vm, ipa, size, &pte, &phys);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	table = kvm_pgtable_stage2_create_unlinked(&vm->pgt, kvm_pte_to_phys(pte), level,
> > +						   kvm_pgtable_stage2_pte_prot(pte),
> > +						   mc, true);
> > +	if (IS_ERR(table)) {
> > +		ret = PTR_ERR(table);
> > +		goto unlock;
> > +	}
> > +
> > +	ret = host_stage2_split_gfn_meta(phys, ipa, size, vm);
> 
> [Severity: Medium]
> Should the call to host_stage2_split_gfn_meta() be wrapped with
> host_stage2_try()?
> 
> In host_stage2_split_gfn_meta(), mm_ops->zalloc_page(&host_s2_pool)
> allocates a page-table page from the fixed-size host_s2_pool. When system
> RAM is mapped or donated at PMD block granularity in host_mmu.pgt, the
> unused PTE-level page-table pages in host_s2_pool can be consumed by host
> MMIO mappings faulted in via handle_host_mem_abort() -> host_stage2_idmap().
> 
> Other callers that allocate from host_s2_pool (such as
> host_stage2_idmap_locked() and host_stage2_set_owner_metadata_locked()) wrap
> their page-table operations in host_stage2_try(), which handles -ENOMEM by
> calling host_stage2_unmap_dev_all() to reclaim MMIO page-table pages and
> retrying.
> 
> Because pkvm_refill_memcache() only refills the guest stage2_mc, can
> __pkvm_host_split_guest() fail with -ENOMEM if host MMIO mappings have
> exhausted host_s2_pool?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261102204628.401871-1-vdonnefort@google.com?part=19

The size of the host stage-2 pool makes it very much unlikely the retry will
ever be hit. 

But better to align with the other callers.

-- 
Vincent
