Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420F21DDC1B
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 09:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758275548; cv=none; b=Wvj9rHdZz2+Z7j+/hCUujQ8EDUm30ci3/TQaWlAnCT74Kl7PGxq5HwFzwOI9RYoxiTgDDQUmMLipZWLYKCcr/OCVVBB0Hc9D26DaiBvFDUeARCNEjXnDaR4+YU2scGKRDijtjMF6uhoYJl6VtW7VFVZHHrTM69swq7cM3Tae1i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758275548; c=relaxed/simple;
	bh=NXtV1b+xb2CwF1HZDhTTmEnGT96qLK6WuDF/rWwgzd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJaIlA9Av/kKAmbTd3DCzWdYgvpzH/YkrTiKPb6GjSJ8RCaRb5F0BHfButqAGFtrlrM7iDq4Q8tHkyCqScF/aJK7iWXlDc+xaegg+aoMjqKAXsgaREOqpCewCa3Vwmk1eePsg1k1sa+R+NLn+igpWlmQGwc+ZtH8/KzI24RW7Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qEHTHMef; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qEHTHMef"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55ce508d4d6so1784503e87.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 02:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758275544; x=1758880344; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lAjbnEPAZMAdFwjUN3o9+aXIN1g6BbdbU7cFibLkhCE=;
        b=qEHTHMefjJ5rIYKRgmmxymexZo5Re3D8srXvvF08SHauYkqQY1yUYn+4te6Zv8XvAr
         4j7J0ynNsKeyR0QS121FezrYWiSbTVIiHxl1F6iUooRS7rqfAp7YTaIPjI6QK3KbPMIe
         MQ02UUtY/Pdqb8PoqC6pEFe1NWY5ykydgDe2mHNhtEOqpSR7yV96TdY8PtNAw2W6EYjh
         /Oy1OVnA7Oebusg6uG78ASKmSIshjOT/NGfF7H3fFprX+2fL3UUFh5xLiFgACwVsZ0lW
         Ql5VbGgpTq2jzfrWD0LFyhTGJ15lK2SwQ7ZNs04MxYYFntXJGfLwgrxqqNDOjRHlyuvt
         Wplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758275544; x=1758880344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAjbnEPAZMAdFwjUN3o9+aXIN1g6BbdbU7cFibLkhCE=;
        b=nPaYX8ZvPOOZKj7d6+Zf7XXrp239XwnDNsN5rBdH30vDURm0C0msv37DEAPu+oGuoV
         N8rc2a3Y4EjPDP2MVwDmmA0XwtsJiNA4irtybgMfmJLI+uR/21Au5ntwzC3it4zjzZQV
         sY+mhvH6NpIcpW8E09OXcs0vlYwRbygTC6jaOGXyZUsfym3rI9edjvN7S+xAX7yejASg
         XDfCiYWbwM/nUD4rGMMP+zrvia9tJKOHe/a9o/i6KISyt+Ocn4EPeL30OBJwzPpVwE7Y
         idJyO7zss3QCXmnTWXVDXiPE+d+RZEs0+1III+HMLXygcMjlMJlS9R8cnHcFkWnbISDB
         p/Ug==
X-Forwarded-Encrypted: i=1; AJvYcCXBaaQ94kI5wDfkkFYoklmuK63VfOXZmsX2aP1quN2Te0xvousBMtUcbmRNR/I2oX8vyqgWuL8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6ZpwMTkMAYk0LsNBlFI3gIqMRPTAq/B1cy/HlkTv7mnRnKQkA
	e1vnSOCpSd3Hgv8HpaT2cVOyCdUG1yASIJtR8JjWPubSpkJrRR5nIUNQQrUpgibWnA==
X-Gm-Gg: ASbGncvJLbhrbKnwCACmgshvsBv/FiBUjy6cbcfsFyi9mNjnHSs/wOYHUfyI+Ss0kGr
	9B02C5krSZlnJeIOoZTC7B+FqyimskdCOZh+/9d7fIf9xYRZKAeuBs1CREplFLhMNbBQcnjZZza
	rLm6zfu3Fw1JBbYDRIajhf8T/Yrez31zwXKrY5fXoD7EyV4dRMTfSnZc+p14lZ37TjvjN7p39ig
	pg8aNyp4anUD5ofH5Q2Ajc3bhpY7ap0jrXKY0ol5SA0LTF1/gT56dZ7RcdBAfo7WA9WJU6QNWHr
	SMV8PR+XRrTTNWSH36DbjwmP1iujFGiqrhs40Z6woZkHtZwSA2lXgCJEWJaw9BIS5shJVn0jg10
	jNKpbvON2s9ZUg2CNSOZYIcYFWpZcULSk++S9s/olNDGm0hOO44i0YOO8
X-Google-Smtp-Source: AGHT+IFKy+FwZofZjdcvEDLB/j3u6QlsxJjpuXcH/jzqyXhI1pRvoG7N8aLbvnRsyKe4C6YJXaCgJw==
X-Received: by 2002:ac2:4f08:0:b0:576:fbdc:e3d7 with SMTP id 2adb3069b0e04-579e28e0ff7mr996313e87.57.1758275544122;
        Fri, 19 Sep 2025 02:52:24 -0700 (PDT)
Received: from google.com (146.92.88.34.bc.googleusercontent.com. [34.88.92.146])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-578a5f447f3sm1288190e87.13.2025.09.19.02.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 02:52:23 -0700 (PDT)
Date: Fri, 19 Sep 2025 09:52:20 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	sebastianene@google.com, keirf@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Validate input range for pKVM mem transitions
Message-ID: <cf3v4dn233bf6y74ythiqulwfnshcdmddsdx3iqcenqjos5cct@zkcw7g5ieei7>
References: <20250918180050.2000445-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918180050.2000445-1-vdonnefort@google.com>

On Thursday 18 Sep 2025 at 19:00:49 (+0100), Vincent Donnefort wrote:
> There's currently no verification for host issued ranges in most of the
> pKVM memory transitions. The subsequent end boundary might therefore be
> subject to overflow and could evade the later checks.
> 
> Close this loophole with an additional range_is_valid() check on a per
> public function basis.
> 
> host_unshare_guest transition is already protected via
> __check_host_shared_guest(), while assert_host_shared_guest() callers
> are already ignoring host checks.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 8957734d6183..b156fb0bad0f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -443,6 +443,11 @@ static bool range_is_memory(u64 start, u64 end)
>  	return is_in_mem_range(end - 1, &r);
>  }
>  
> +static bool range_is_valid(u64 start, u64 end)
> +{
> +	return start < end;
> +}
> +
>  static inline int __host_stage2_idmap(u64 start, u64 end,
>  				      enum kvm_pgtable_prot prot)
>  {
> @@ -776,6 +781,9 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
>  	void *virt = __hyp_va(phys);
>  	int ret;
>  
> +	if (!range_is_valid(phys, phys + size))
> +		return -EINVAL;
> +
>  	host_lock_component();
>  	hyp_lock_component();
>  
> @@ -804,6 +812,9 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
>  	u64 virt = (u64)__hyp_va(phys);
>  	int ret;
>  
> +	if (!range_is_valid(phys, phys + size))
> +		return -EINVAL;
> +
>  	host_lock_component();
>  	hyp_lock_component();
>  
> @@ -887,6 +898,9 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
>  	u64 size = PAGE_SIZE * nr_pages;

It occurred to me that this can also overflow, so perhaps fold that
calculation into your helper as well to be on the safe?

Thanks,
Quentin

>  	int ret;
>  
> +	if (!range_is_valid(phys, phys + size))
> +		return -EINVAL;
> +
>  	host_lock_component();
>  	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
>  	if (!ret)
> @@ -902,6 +916,9 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
>  	u64 size = PAGE_SIZE * nr_pages;
>  	int ret;
>  
> +	if (!range_is_valid(phys, phys + size))
> +		return -EINVAL;
> +
>  	host_lock_component();
>  	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
>  	if (!ret)
> @@ -949,6 +966,9 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
>  	if (ret)
>  		return ret;
>  
> +	if (!range_is_valid(phys, phys + size))
> +		return -EINVAL;
> +
>  	ret = check_range_allowed_memory(phys, phys + size);
>  	if (ret)
>  		return ret;
> 
> base-commit: 8b789f2b7602a818e7c7488c74414fae21392b63
> -- 
> 2.51.0.470.ga7dc726c21-goog
> 
