Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723884;
	b=LmCOKaoSoGZbsGitR4/vW5jmcIiOt0YSOiDXgEAproB5l/1ghrVc9uQI/Q64iuZ57EO7
	 kkZmf7j4TAmG866oyF+ik9GTVSjwa/0hIVm5+4idXEQwDrcA2N1xuROP5Nk/zkFqIGZGZ
	 HXm2mmeT+GM6kDqMH2wyHyhXrbFRJFLe5okKlY26mxlxq0ei2xotK2rJ3BjzQHA//xb5e
	 rf9Wfz8i42ycZ83tfrsgODv6XF7rx7fMPev84M0utatC1SV5QMot2b/n3KAKOMS5C+PfP
	 BejejbdB1OIcX7nR03d6C47ay4ee9+kT+5nUNwBcP9SN+0daawAUeOxQov4zoGX2ehw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723884;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=CWv72uCOCqMYoLAg7IauldxNcJXBuFWTSZgkJBhwQnA=;
	b=eOQyMb6gnoWMzkYY8rZ8/Tr7fnz2AhRSrVYrrj1E4ulgJM3ndXox0KwKxw3JffEDN01+
	 UKKDHWDbSJRfK0qFDpKgFsBYFHV4f49ikViVfkvdBCcDkmbVC7WGZYLFMpvlw2ypimKxu
	 3yrhloKvcCzs+oRFl+yQo+kItRfzR1xHRKW+AS1l+Vids7N5Aah3LeqLFUcEJX1+0JQGr
	 LQRYChJ3dvTsuxRzR/dpkOOTLoDJhGhpWrgex+SDlVNdG2eKHxeKL/AVIfmVZCC3mlH7A
	 eOH7/yoDDBhaMkKrPp47qKv0/y0I7cWk0xt98ZuMLLAZjWeb5YEGPc9JuvXNLy6y7Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IxnvZsmg;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2816606D839
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 16:38:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2816606D839
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IxnvZsmg
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e09aa5264so2243968f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 08:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793723882; x=1794328682; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CWv72uCOCqMYoLAg7IauldxNcJXBuFWTSZgkJBhwQnA=;
        b=IxnvZsmgYP3Ziwc0/+DslKRG1HEBHdWZoCW4KrBjt/uLqDlRMUwXE3DWclbNv6fXUy
         8y37zQbq1IL2ZNnSVGMCIdmhRjQHgCubceeVYQB2FdPlG0TyVYbP1ryPIWkSkmYiHUQp
         rJnmkeLylFSwOUpyXGGnpcOuJ0tx6m7slZnvX+QG6qNFktjz+jjdh/Wq7P/tRMJwYDt2
         XOQ7u09+gMlYMJCIC2B1NFdDqzQApmNQfIzoieMHtLnMDhNZY72syMgY6BSM9dH+f0i3
         ANfV8QOoYGQx7y0DO4D8QXwLzat3f/iWqWRHMn6lqD+hn9pZjHCq0LgnJQ79Fj2zz9/r
         AH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793723882; x=1794328682;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CWv72uCOCqMYoLAg7IauldxNcJXBuFWTSZgkJBhwQnA=;
        b=kwLkagdMpkkvmCiAQkxNnW0y2RfSD6p2wWD6fjHA2oLh0/4YNZG9KcyZgOtyhHiTf1
         RQN/T/oyW+7P7lJuGtovWzJOpZdr6z/iMGEghItvDLAx5YRONHDh9Uw4sn1vNmRxAB0v
         xjr4mbC3oqWG+nWn5o+hDCU/YMonxHQJ2edVzGFlfm9QqsjH3teuD7VlX8D3miFkm4uA
         A8XXbSMw8NxNnCtddEjIx+xv156W4A5CbLZaMla28JHTmvFf98XuuyaiBTh9mdnm1Hxp
         hlupI4jBY5EMtmJcSs0HC8J1t+qYy+oZOWSkM5uj+AJVNRawTkJd9GoDlP5S/re02dtG
         qAtw==
X-Forwarded-Encrypted: i=1; AKwUvBwMK387yux3nzNWG4+OfmfqbVmQd3LB2vI6+Io8LQ9rePlC44veIgAp3WhbpQe5iCbcZ5UMuEM=@lists.linux.dev
X-Gm-Message-State: APuU4Z8G8WULsxUvWa9yO5HiY4QWn68I58SY6jp/zx/ritSn9Vtr9hvq
	h8nUT/REE4FweJBfv5eBBJVdV2agnZpzZIoQcAYOpqSD8bLs/3XZdm2YrmeyGQaabQ==
X-Gm-Gg: AYBFou0UwLXZLCV3izBGLYrdI//eJbkwBFR8kkgDl/I6vENbXbNnNA5rCGMZh0CKm5v
	3ez9qLwfslRKJPxjrm5Z5Zn8PxRl5vrdw6KFsjl6n8KpXWRIGTNxg/VZmlGjzNE8rKIs4Ii4Y5C
	eQUB9alFuL72PbT1Pi8rgLJtjEzMVsFBrNUObcfr5yc/3lJGSg1h5bP6mVZ41JlBjCGBdlw7xjU
	FAVsyxrUyJkTD2PpaRJ3GAqANjvyKZz1fb3gLIP+0GCr8ztJGpwYJim4rYTAPsawFnhr2jnoEPb
	raKQULJpDhjrgEULFZrk2T4BaydRow4OCGzGVVOyhEPACmBKNCirBbOhn81TpskHDu3+C3DvfGR
	AwopQlKsnlMRzJ/aDSuyPgjJM5BJnzwo13QZRXbW7nlWwIjQOVZyIks5lg2+BTnUQnwnEjn7s9P
	b8G2AdX2rdLAaU5jKBz0fzja4asCdEhHHE1DBWLbtX8jcRDAQaG/hWemws+EePtoII6Z912PyCl
	W4bfCiXWXkVYNzKIntWV6PynYSgySgH0IIoDkJW+YpEaeajbkALCYJbOuTdeDoBnYbsMK/ttOZn
	5BebfNAoIbgo64zxLfI83yMN4ccxYod2xUA5Kj8tSXXgYngkgIqAPvHV1j0X9svOMA==
X-Received: by 2002:a05:6000:310d:b0:48a:f59f:8b70 with SMTP id ffacd0b85a97d-48e6e4f8c71mr33055012f8f.46.1793723880548;
        Tue, 03 Nov 2026 08:38:00 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a84esm28271412f8f.39.2026.11.03.08.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 08:37:58 -0800 (PST)
Date: Tue, 3 Nov 2026 16:37:54 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't walk the whole IPA space when
 destroying a pKVM stage-2
Message-ID: <auoN4h8iloqPuepc@google.com>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
 <20261103084742.1302597-2-fuad.tabba@linux.dev>
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
In-Reply-To: <20261103084742.1302597-2-fuad.tabba@linux.dev>

On Tue, Nov 03, 2026 at 08:47:40AM +0000, Fuad Tabba wrote:
> Since commit 4ddfab5436b6 ("KVM: arm64: Reschedule as needed when
> destroying the stage-2 page-tables"), kvm_stage2_destroy() steps through
> the IPA space in block-sized chunks, and with pKVM each chunk is a
> lookup in the VM's mapping tree. However, pKVM gives every VM the host's
> IPA limit, so with LPA2 a teardown makes 2^27 lookups with 16K pages
> (2^22 with 4K), nearly all of them for empty space.
> 
> Walk the mapping tree once instead, and reschedule after passing each
> mapping to the reclaim or unshare helper. The unshare helper can't
> reschedule itself, as the map and unmap paths call it under the
> mmu_lock. A failed unshare now leaves only its own mapping behind, not
> the rest of its chunk.
> 
> Fixes: 4ddfab5436b69 ("KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/mmu.c  |  7 ++++++-
>  arch/arm64/kvm/pkvm.c | 17 +++++++++++++----
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db73..42977cf8a7f5d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1022,7 +1022,12 @@ static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
>  {
>  	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
>  
> -	stage2_destroy_range(pgt, 0, BIT(ia_bits));
> +	/* pKVM walks its mapping tree, not the IPA space, and reschedules per mapping */
> +	if (is_protected_kvm_enabled())
> +		pkvm_pgtable_stage2_destroy_range(pgt, 0, BIT(ia_bits));
> +	else
> +		stage2_destroy_range(pgt, 0, BIT(ia_bits));
> +
>  	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
>  }
>  
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 016997288fd23..992ed3ca6bdd9 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -504,6 +504,7 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>  	pkvm_handle_t handle = kvm->arch.pkvm.handle;
> +	struct pkvm_mapping *mapping;
>  
>  	if (!handle)
>  		return;
> @@ -513,10 +514,18 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>  		kvm->arch.pkvm.is_dying = true;
>  	}
>  
> -	if (kvm_vm_is_protected(kvm))
> -		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
> -	else
> -		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> +	/* Called once for the whole IPA space, so reschedule between mappings */
> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> +		u64 start = __pkvm_mapping_start(mapping);
> +		u64 end = __pkvm_mapping_end(mapping) + 1;
> +
> +		if (kvm_vm_is_protected(kvm))
> +			__pkvm_pgtable_stage2_reclaim(pgt, start, end);
> +		else
> +			__pkvm_pgtable_stage2_unshare(pgt, start, end);
> +
> +		cond_resched();
> +	}
>  }

Just thought that it is a bit weird that pkvm_pgtable_stage2_destroy_range()
does cond_resched() while kvm_pgtable_stage2_destroy_range() does not.

How about instead kvm_stage2_destroy() refines start/end with some accessors
calling in pkvm.c pkvm_mapping_iter_first() / pkvm_mapping_iter_last()?

>  
>  void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> -- 
> 2.47.3
> 
> 

-- 
Vincent
