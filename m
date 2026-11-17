Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932321;
	b=YMz1r1iIQb4GEKkNgRNMIHHc8k80wn6jou7qbFCsDOJ/19AoXj1ayksUdOZKl2eYzbCY
	 rlhRJL+u3QeJNPJ6V5+gwWZFNGvfu+nQRtIckrB+NOqyyIHG8ivUemgb8Rjwl5WJBRkqV
	 ZRMFh8GSTXunrYkwMfGF/2WQrFzJvPwqQecPlEIjH8II/4cQ1oHZ7YjeoWzLsnqI0AiMy
	 k06/Z309UJPrK94chM+bUHvjV05xXwDNlMDdhakK5lvkMrj6TneN+MVXppDlGKw2KiJu4
	 6+itcdbg8fDwWBPEKHaas6u6+QSoLXUObCaMHBYFjUFeaC7mbpeoV/bGeiC72HpKXEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932321;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=CKc2uY9tw++qJSeO11LOOO9i6cJhH/YZkvglgrwUC60=;
	b=LTLBb65djyC8ehbVVLXQ1ML/vhMTbUmJBP1uWCqEl32gaXPmS4BpJ4D/w7Bl9L6mlJ0b
	 KkAciJWQwvzevwJAuCQGznECUOKYSE2GTira832MmJcFFg7ww1Agl/PFrfDPCadGem/as
	 8GEWHmuRMaEMBW9kQxtkTprUh58Tv6E8q94kLP7TmMzOt8upL79sDosUBWoHOlPP2EgLc
	 fxqwfw1gAJTW6r4RMxtWOwn+jyEKMRAiy2bMQcO7txVol/+N/Cz3KfkPB0+nTrU8DY5I5
	 uwDBaO5PCd0R28HN1Ek8tIU11ggMrLLjgRb5tBjVN8Vw4I9FACC8xejgbfBi7qjbjbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SD0nXfxa;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E75606A31C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 16:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2E75606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SD0nXfxa
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so14936195e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 08:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794932319; x=1795537119; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CKc2uY9tw++qJSeO11LOOO9i6cJhH/YZkvglgrwUC60=;
        b=SD0nXfxatq0Jj279iTQwL49/5NgW9DG6uqo9a40RK/wXekfb4dHgpC7MlSUkDI8GJN
         WaKcLbjxYdXO1UEpVmCFqfun0lI95RUcY3R2Z5nzQ4rOJMW+WYAko1TikhFy+PJVPT89
         y+Ub+RasVObCLEh6aV5guLBr1aEx5kXMDHyNDjkgOIfpngbMHJIJQZqPUGvTmNTWSDZK
         FVZMByVSwunjAX2CjXeV5VFRJW29ppRp48kkQ3SK5MF7ShNvzU4ys1t2o07/ykNjYyNI
         n0n0AxRKXkoIs3xV7nh2w1oTiupJ737bVOIai4wG15HM9Ffhp8M6jwWyb/dEpiQXT6Cr
         DnKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794932319; x=1795537119;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CKc2uY9tw++qJSeO11LOOO9i6cJhH/YZkvglgrwUC60=;
        b=Yxk8TniB9nPF2cN/la2Jm6KnSmj61d7+wjIKxPZc+iceCdwLXdYqdHfsibJ+/fnhk6
         ykXihmgffvBhfT9c9ZYj82rux5GTYL1UxxLGy7UzPtLjQHea4NF5x1VsMS5Nx9vf4rwp
         sRDzqboqwoaHyRLDJVZIaJMqCnt9JjShOfKEmYeqb7+GyyLN5z2Kh1U02aUD1MIRfZBe
         Ny08sNFufU/HK6/LR++KGbGOD4Svyv65zsVd1+t7EQqTEA3Z4lYW6QP21O2GuH7YGvP7
         QeU/3U7u5BC+yNzvDMXdYa2uZycWXixXttyhRqgt4+jNZkLQSmJGK5XMlKzZDmVFa54X
         rHAA==
X-Forwarded-Encrypted: i=1; AL+hErFsAjExUN4PG9IRo6n7/Vomd2Q3EyS3ZjAVF9PxSg25f6xbglZLObapccUf3xgAcjftiS6ECcY=@lists.linux.dev
X-Gm-Message-State: APuU4Z+sVdwXGG4+oDZaERCkYLRpOV7fyE7Am1/nsTVt1kmkclzMHrxh
	lhE6k1aO/FTxJzG6OiMdIQ7+YTCkO9t8VevLi3gqn5mJX9h2Tw7b2eNnWuntHSXuzw==
X-Gm-Gg: AYBFou2JwPKMjnj1JHuMsfaqB8rVh34kBk2hUOvyy/g+oWUxdKHf26Abe0PTZojmr0a
	AWqIOAT6KoK5ULWhW27mjRwRxpjaMCBBMgLuk7gLMUfX3HzeDTvwwbu1e+6odu8Ry2LhDs1GKlx
	uEpr1sBh00vWLeuyjVCEkKwe4xyXwVK88hU04ZHn7SNvySblgZU8MpBFhvET/b8IpDiZMDAZfBA
	41hBstxAjRv2Vs7A5xRaCdqE/8Jf2eZMY00OvlE4Cjyx5sbHvJjLUo8be2JwCrrgZYHL89eZg2r
	q+Djk0cWVug3lrdYMi/fNHBvJ4Un3oswh4MPmoX0QiVZUvVjN+cUttptA/ievzzKvirfSel+uLX
	LY1wjINxDx/Q0vr91Yo15ibUMt31FsvaLCa7KFVbGsXM6iwA7idvS5Pvm5zaYpHvV2BUrVR8rgq
	SPQtwcGAJxCon842xvVtXD4KtuGDupUKheprQJb9KIxmTnD5Wtz+9MP6PvMQbwkMUaYEtfY8pvR
	PITDEj0Ay3CGMR3zErnkNXrj9fo27efpq/6P0AJ1mu3ODB/rBapDSCgyaoMY67bxRezZWNgxJiH
	Y5slzjR2ehhsl/AuZjo8ZZOEWj+KljGR+ICgmZ7IGAfpgphMeRRAdDr9Nn1da5c75g==
X-Received: by 2002:a05:600c:c103:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4bb7838be00mr52317225e9.13.1794932318543;
        Tue, 17 Nov 2026 08:18:38 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb734b9f44sm105265185e9.1.2026.11.17.08.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 08:18:37 -0800 (PST)
Date: Tue, 17 Nov 2026 16:18:32 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Haseeb Ashraf <haseebashraf091@gmail.com>
Cc: maz@kernel.org, Oliver Upton <oupton@kernel.org>,
	Haseeb Ashraf <haseeb.ashraf@siemens.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, fahad.arslan@siemens.com,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Resume stage-2 range walks where they
 stopped
Message-ID: <avx-WAgBpyjJlwhg@google.com>
References: <20261113080233.640539-1-haseebashraf091@gmail.com>
 <20261113080233.640539-2-haseebashraf091@gmail.com>
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
In-Reply-To: <20261113080233.640539-2-haseebashraf091@gmail.com>

On Fri, Nov 13, 2026 at 01:02:33PM +0500, Haseeb Ashraf wrote:
> From: Haseeb Ashraf <haseeb.ashraf@siemens.com>
> 
> stage2_apply_range() walks a range one block-sized chunk at a time.
> The walker steps over an invalid entry in one go, but the next walk
> starts at the following chunk, so an invalid entry larger than a chunk
> is visited once for every chunk it covers. Unmapping the whole IPA
> space of a shadow stage-2, as emulating TLBI VMALLS12E1IS and TLBI
> ALLE1IS does, takes 2^18 walks with 4K pages and a 48-bit IPA space,
> however little it maps. Each walk also ends with a range TLBI when
> FEAT_TLBIRANGE and FWB are available.
> 
> On an AmpereOne A192-32X (192 CPUs, Xen on KVM, 4K pages, 48-bit IPA),
> a full-range unmap of one shadow stage-2 took 0.84-0.94 s (mean 0.91 s
> over 226 unmaps) on 6.18.29. With this change and the mainline commits
> it builds on backported, it took 2.1-45 ms (mean 4.1 ms over 672
> unmaps), with 512 to 1023 walks instead of 262144. The slowest TLBI
> VMALLS12E1IS trap took 0.94 s before and 46 ms after.
> 
> Have the walk report the address it reached, and have
> stage2_apply_range() resume from there. Unmap, write-protect and flush
> all go through it, so all three get this. kvm_pgtable_stage2_unmap(),
> kvm_pgtable_stage2_wrprotect() and kvm_pgtable_stage2_flush() now
> return the address, or a negative error code, and so do their pKVM
> counterparts, which do not walk page tables and return the end of the
> range. The other callers, in nested.c and at EL2, only looked for an
> error: they now check for a negative value, and those that pass the
> result on turn it back into 0. The walk handles every entry it steps
> over, including invalid entries that carry state, so nothing has to be
> looked up beforehand.
> 
> The unmap of a shadow stage-2 also drops the guest stage-2 records of
> the whole span the walk covered: nothing is mapped in the part it
> stepped over, so any record there is stale. Each walk that remains
> ends with the same deferred TLB invalidation as before. The spans that
> were skipped have no valid entry, so there is nothing to invalidate.
> 
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Haseeb Ashraf <haseeb.ashraf@siemens.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h  | 25 ++++++++++-----
>  arch/arm64/include/asm/kvm_pkvm.h     |  6 +--
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 24 ++++++++----
>  arch/arm64/kvm/hyp/pgtable.c          | 55 +++++++++++++++++----------
>  arch/arm64/kvm/mmu.c                  | 32 ++++++++++------
>  arch/arm64/kvm/nested.c               |  2 +-
>  arch/arm64/kvm/pkvm.c                 | 22 +++++++----
>  7 files changed, 108 insertions(+), 58 deletions(-)
> 

[...]

> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -383,16 +383,20 @@ static int host_stage2_unmap_dev_all(void)
>  	struct kvm_pgtable *pgt = &host_mmu.pgt;
>  	struct memblock_region *reg;
>  	u64 addr = 0;
> -	int i, ret;
> +	int i;
> +	s64 ret;
>  
>  	/* Unmap all non-memory regions to recycle the pages */
>  	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
>  		reg = &hyp_memory[i];
>  		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> -		if (ret)
> +		if (ret < 0)
>  			return ret;
>  	}
> -	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
> +
> +	ret = kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
> +
> +	return ret < 0 ? ret : 0;
>  }
>  
>  /*
> @@ -1418,7 +1422,7 @@ int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
>  		goto unlock;
>  	}
>  
> -	WARN_ON(kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE));
> +	WARN_ON(kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE) < 0);
>  	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
>  
>  unlock:
> @@ -1601,6 +1605,7 @@ int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
>  	u64 ipa = hyp_pfn_to_phys(gfn);
>  	u64 size, phys;
>  	int ret;
> +	s64 reached;
>  
>  	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
>  	if (ret)
> @@ -1613,9 +1618,11 @@ int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
>  	if (ret)
>  		goto unlock;
>  
> -	ret = kvm_pgtable_stage2_unmap(&vm->pgt, ipa, size);
> -	if (ret)
> +	reached = kvm_pgtable_stage2_unmap(&vm->pgt, ipa, size);
> +	if (reached < 0) {
> +		ret = reached;
>  		goto unlock;
> +	}

Could we just make ret s64 to avoid adding another variable?

  ret = kvm_pgtable_stage2_unmap();
  if (ret < 0)
     goto unlock;

  ret = 0;
	
>  
>  	for_each_hyp_page(page, phys, size) {
>  		/* __check_host_shared_guest() protects against underflow */
> @@ -1674,6 +1681,7 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
>  {
>  	u64 size, ipa = hyp_pfn_to_phys(gfn);
>  	int ret;
> +	s64 reached;
>  
>  	if (pkvm_hyp_vm_is_protected(vm))
>  		return -EPERM;
> @@ -1684,10 +1692,10 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
>  
>  	assert_host_shared_guest(vm, ipa, size);
>  	guest_lock_component(vm);
> -	ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, size);
> +	reached = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, size);
>  	guest_unlock_component(vm);
>  
> -	return ret;
> +	return reached < 0 ? reached : 0;
>  }
>  
>  int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm)

[...]

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 0169972..73aad80 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -602,19 +602,24 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	return ret;
>  }
>  
> -int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +s64 pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> +	int ret;
>  
>  	if (WARN_ON(kvm_vm_is_protected(kvm)))
>  		return -EPERM;
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
> -	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> +	ret = __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> +	if (ret)
> +		return ret;
> +
> +	return addr + size;

Could we make this shorter?

return __pkvm_pgtable_stage2_unshare(...) ?: addr + size;

ditto pkvm_pgtable_stage2_wrprotect().

-- 
Vincent


>  }
>  
> -int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +s64 pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>  	pkvm_handle_t handle = kvm->arch.pkvm.handle;
> @@ -632,10 +637,13 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  			break;
>  	}
>  
> -	return ret;
> +	if (ret)
> +		return ret;
> +
> +	return addr + size;
>  }
>  
> -int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +s64 pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>  	struct pkvm_mapping *mapping;
> @@ -643,7 +651,7 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	lockdep_assert_held(&kvm->mmu_lock);
>  
>  	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> -		return 0;
> +		return addr + size;
>  
>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
>  		if (!mapping->nc)
> @@ -651,7 +659,7 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  						  PAGE_SIZE * mapping->nr_pages);
>  	}
>  
> -	return 0;
> +	return addr + size;
>  }
>  
>  bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold)
> -- 
> 2.43.0
> 
