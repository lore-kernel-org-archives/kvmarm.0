Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4362F12DA
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 06:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761804579; cv=none; b=pFgHI1u14oWEloPX1EbaDD4hy6BvPtphZml60iwfIq9SPnIR3JiVpIh4kuj/+/MWwpwqa/pxAu8tZRtCNlskqtqBBzFxb+qU1M4cYa7zrk5t/2SAnnVTlYu8IoQhXQiYvJnyE0mDHu4dHSnmurMecMnk4LiJwHiuqxzLt99VGHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761804579; c=relaxed/simple;
	bh=ye3AvcYv/DjDgZmRS42tFjm/DIKFHiOhTeTHpnujgfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rS3VzrAsGEvGeZ0GO4uqYlVxoLoZS44YFJPS6ozQtLEp6hHhc7iXTn86Ifv2uzMyk1ol24h6JPY6stHVOyAEnFoXj86EYCKJ4ir/pISFLx+LrOTdTkTQSB26OqzUq9/D0lk35xI2jkUGKs3vewWecV292hP5PnTU0Z9cNXnu1C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A0J5rd4L; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A0J5rd4L"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47105bbb8d9so29355e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 23:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761804576; x=1762409376; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DLithzThx8pxlXaz1qEgue0vbFKuTuLtSl9y/H9uBGw=;
        b=A0J5rd4L7jhP3SOozOEo9QVr38lJGzURf9dB/CMY384wBPgh5JMvtQKie9orBNndTC
         0Fy1fo96vZ0wVmMyX6JtWfPDfAmQE8Bc6FWuCJO5G8c1on9J7wu1Jm5zJ65kL6cFXW0c
         rchM13kJb80oBJeNg6t4uCrZGJrtUFWZHam45RlicXtKNPjIIpRApknYSGjGq9CEp6ij
         /p8ckIc2P0/TsLOmIOeEQyCy0vMMrmUO9dmJ4sJRO81XJnsxmM5Mc12wFaRD0IIVKAvc
         d+4mtbCe9aT6eKGREe2WR27YYx9nzJPG/CdScpaZUBuYyb6epSOGWiRG0LDE5FTXrOC5
         7mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761804576; x=1762409376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DLithzThx8pxlXaz1qEgue0vbFKuTuLtSl9y/H9uBGw=;
        b=vKbkklSl0pngQG6z6YNhOmt1q71yz48UlePRNYnyV3VD8jzfmHLVTrWQXnw5ZyNEfM
         CYa45JB7T5O/72K6k7l7hXvlMCeUAXdrsGnH4zc+QAF0UbDDYnaHS/GCOgsQiPr4b354
         1OnkDVrOvEeEtBq/9bbmu4kPjGYOBfWZF8Ps9JFI6qqZVGZ78Z2Mqjw8QfqGx4wfU4hd
         vf90pRYpr6eECIVri8uff0mSdw7c6pe+TWrSCfPhydRiiQT3LcMff+F1Uc5Q0i/8l2nZ
         V3kT8eJax7ia3+k++mYo6+0JpfFzBSjdgQUnH1U2LrJ/8jcSyJ9TFJLgfrNeXgtyfQdH
         8nrA==
X-Forwarded-Encrypted: i=1; AJvYcCVOpKamHE7dkWWlJ0L6c2kLsUjWwk3NtvCuhCthUtzuVaWMxYMxs1bD7jM8pfoXMnrjxOZCJt4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJ1wLe4bLbQ70DPVwDMN+ASYOa3RLCnPt7NTlHEBLMRco89Nb5
	TdqVOywZw7h6Ogx9wXPrMK8fAiK9DXSIvq4QKKCgEPpgCShoerXT+vH4r3qXuRdRhw==
X-Gm-Gg: ASbGncuLs7FTMGh2iuId7uxQh219BxIOk70R7tHGQl0YOUrRiss4Cwsq0QV+BMZCTgt
	kqqX+gw05J2vQxP0CekMOAvBh1dIYmTcUOIQa/MigC6T0AgXQMBynRLCcjohV/VjxwnWtSWIjxF
	aY4YZkb0+wjSs4nfDnwpBXgkXXt2YqWkY2oQ0u7T6/LUZkK9LTdr8m4lkO5w75kRCYtY5v9crRy
	KK08HOnxfPnNkExH0m+gbwjirrtPInDhQL97McTivFdvyyIcn+3v1bCTCpscNy+9rFEhgrgR8oL
	M8KkZF5zwdyln2ZwfSwMrCgvO+hsdGJ6OOCP5SYPU6CXcW20wqtEoT6R3pJsO/R9EwT99y/MYtz
	uesGjD4T8T35M/sOlWbwE+/8lucbXGBbcq7jMgrV5KCyE3r2hhrpF3qajZE9we7jTgMsLMnZrC3
	btMcC58hJpyDneurgT7Vj+ILfvO7Vvg3wKhK7OJON5yvpej+Lc2VrMuOOcdw==
X-Google-Smtp-Source: AGHT+IGeJspzX9tfUeAx5eQ3UCzknbWkBSs575JdAgz7ivV6hKq3b/O79zgLFOS7QUNGGU3V+/JhTA==
X-Received: by 2002:a05:600c:d2:b0:477:255c:bea8 with SMTP id 5b1f17b1804b1-47728a06de2mr733935e9.7.1761804575641;
        Wed, 29 Oct 2025 23:09:35 -0700 (PDT)
Received: from google.com (177.112.205.35.bc.googleusercontent.com. [35.205.112.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289b0bb3sm20742205e9.8.2025.10.29.23.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 23:09:35 -0700 (PDT)
Date: Thu, 30 Oct 2025 06:09:31 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com,
	keirf@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v3] KVM: arm64: Check range args for pKVM mem transitions
Message-ID: <aQMBG0SUlNWuQQFZ@google.com>
References: <20251016164541.3771235-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016164541.3771235-1-vdonnefort@google.com>

On Thu, Oct 16, 2025 at 05:45:41PM +0100, Vincent Donnefort wrote:
> There's currently no verification for host issued ranges in most of the
> pKVM memory transitions. The end boundary might therefore be subject to
> overflow and later checks could be evaded.
> 
> Close this loophole with an additional pfn_range_is_valid() check on a
> per public function basis. Once this check has passed, it is safe to
> convert pfn and nr_pages into a phys_addr_t and a size.
> 
> host_unshare_guest transition is already protected via
> __check_host_shared_guest(), while assert_host_shared_guest() callers
> are already ignoring host checks.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> ---
> 
> v2 -> v3: 
>    * Test range against PA-range and make the func phys specific.
> 
> v1 -> v2:
>    * Also check for (nr_pages * PAGE_SIZE) overflow. (Quentin)
>    * Rename to check_range_args().
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index ddc8beb55eee..49db32f3ddf7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -367,6 +367,19 @@ static int host_stage2_unmap_dev_all(void)
>  	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
>  }

Hello Vincent,

>  
> +/*
> + * Ensure the PFN range is contained within PA-range.
> + *
> + * This check is also robust to overflows and is therefore a requirement before
> + * using a pfn/nr_pages pair from an untrusted source.
> + */
> +static bool pfn_range_is_valid(u64 pfn, u64 nr_pages)
> +{
> +	u64 limit = BIT(kvm_phys_shift(&host_mmu.arch.mmu) - PAGE_SHIFT);
> +
> +	return pfn < limit && ((limit - pfn) >= nr_pages);
> +}
> +

This newly introduced function is probably fine to be called without the host lock held as long
as no one modifies the vtcr field from the host.mmu structure. While
searching I couldn't find a place where this is directly modified so
this is probably fine. 

>  struct kvm_mem_range {
>  	u64 start;
>  	u64 end;
> @@ -776,6 +789,9 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
>  	void *virt = __hyp_va(phys);
>  	int ret;
>  
> +	if (!pfn_range_is_valid(pfn, nr_pages))
> +		return -EINVAL;
> +
>  	host_lock_component();
>  	hyp_lock_component();
>  
> @@ -804,6 +820,9 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
>  	u64 virt = (u64)__hyp_va(phys);
>  	int ret;
>  
> +	if (!pfn_range_is_valid(pfn, nr_pages))
> +		return -EINVAL;
> +
>  	host_lock_component();
>  	hyp_lock_component();
>  
> @@ -887,6 +906,9 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
>  	u64 size = PAGE_SIZE * nr_pages;
>  	int ret;
>  
> +	if (!pfn_range_is_valid(pfn, nr_pages))
> +		return -EINVAL;
> +
>  	host_lock_component();
>  	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
>  	if (!ret)
> @@ -902,6 +924,9 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
>  	u64 size = PAGE_SIZE * nr_pages;
>  	int ret;
>  
> +	if (!pfn_range_is_valid(pfn, nr_pages))
> +		return -EINVAL;
> +
>  	host_lock_component();
>  	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
>  	if (!ret)
> @@ -945,6 +970,9 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
>  	if (prot & ~KVM_PGTABLE_PROT_RWX)
>  		return -EINVAL;
>  
> +	if (!pfn_range_is_valid(pfn, nr_pages))
> +		return -EINVAL;
> +

I think we don't need it here because __pkvm_host_share_guest has the
__guest_check_transition_size verification in place which limits
nr_pages.  

>  	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
>  	if (ret)
>  		return ret;
> 
> base-commit: 7ea30958b3054f5e488fa0b33c352723f7ab3a2a
> -- 
> 2.51.0.869.ge66316f041-goog
>

Other than that this looks good, thanks
Sebastian
