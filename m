Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E130927701A
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 18:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740768888; cv=none; b=XooGfhJKvUAPK8k2qIP5nL5OfAmOsPgAaO0+haNljSGf5IvHRbSnTnK72rRay5zmVZKtOqYK0A0rnVI5VgblXOHPOKLvXnuv94iS0IBUxfyG+YeyRTCY5V6rsfktjEg3MH9h+3dqLPR5ebw2ybUxlpjA2j/wcynQQR3DpE88VKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740768888; c=relaxed/simple;
	bh=TYvRxcLgN1IYxafXpxrr2T3Ke1WemjDAQaAfqYgyWxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fi1OhhHp6AP/o9A4kDxSmYyQmO5B1VyEOBokG4vS48++96kohPZ029Fr2/Jfpslv1m2KPqNelG2x1yWjWl61bm7PXVEAKTkwF6Wl0CkRedv1VUWLaq4TAEdJiiexS2aI4rGEdC9jEGU0VqtqgMMVZgHeFpL74bLs9qJVONtdnqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v/kWvAU5; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v/kWvAU5"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so474260866b.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740768885; x=1741373685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ppwxYptxUoJTBAvtQNONLY3e8TNhsTgMXgKzmUOztsk=;
        b=v/kWvAU5r77EnWKPh3WVLNnmblrcp19rPUntsySBsLqIutYj2zFWzcbt7RrNBQymsy
         jmRDUUxVgijipatpwjbbn4S4Z4523/XUU4rmCb6oQqOqZvzJzVspa09UkopQWtDk5NAQ
         Y3snq1oZN+/x3JSW78lxaF/HNZA28hvXji53AgTFaIHUsJTRz0p5A2XExiuPexINkjIf
         Mt9sUWFuZ7jWbhcAwYxCQ+nm0eUfMVfKEBULRbf+UzGYNBvlXhhItFvR0eWaAjLYWF1m
         iYBogcMOz7FWLmeCBmNvCRk+tRxrIa/g9jZxA/VSDj4gMG5Y5nc+RYYktH4du0C3vWd6
         oaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740768885; x=1741373685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppwxYptxUoJTBAvtQNONLY3e8TNhsTgMXgKzmUOztsk=;
        b=cGrPDz/O5ENg+B2u7aMSQ3A2qk15KPYu19/sAcmCnqrf0YxUO/2tEGzZ8l5X7r5Ioz
         fffNAlIsi7AbCyxCHlAoScTV0WEDVFdQQwrBNm2ifj4K3ajCvElgWm1jVnNrlRvzfsX6
         MatrakMSgHaDxzqg10yDOlNsORCYWzXGjiy7Zp6YrOTAfnMqDgYJmsSFCSW8qNpmZaAB
         fqjXdRgTZ+nUzNxOVorTsKzu/QNO/Y1t2WpTtVKutH9YVvR6vfvgL8HrBhdUaV1VPYVd
         yVQ2TtKImS2dfuigO3q5H/otAg0kHtMJ/FpJ/L3U/+dqE0Xwgft1w+kzuLHVZ6u8yyV7
         vh2g==
X-Forwarded-Encrypted: i=1; AJvYcCULZaC61Evvrzjn+aaaQHqo5lanz+BdUpxY/rBeCqFFPEoyQKyPZKo3aGyGo/xPR7tuT5aU7Hk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yww1n3uKCOjSZT47WqoMDlqEnLjZDmwCoDGVZos2pkuDt1v5oYr
	SNSISlTdGV3+jUmF3QGOZmRO2NcKYCrcGftXAm+D0T8PA1OYpLVtzqfqYVYjXA==
X-Gm-Gg: ASbGncvHgdqBKLsKA/lmpPdQJr6f42azAPME0/KzJKwQgleKudvysZ6kTnoMoqOLP0C
	lgdv0wBY6RJG5Yb3mDSw4yhu4A0W35dC9Qukp1eoaeau57qsJzZaHL7Bw/hE/wSG6nQoxX9Q72M
	VhydkJ0Qu7e04TXcpv0tmTW8Rq76GDyb1heE7/HCf2bSyaXQj17Ml1P1sxBVHpzDZcb4kPtySqY
	AaPh4S/9ovYbzV3X3UEWu3Cl7gpvBBnGCUjMf3Zhwxe6edtoMIZprzKKOoxLe7lkCVsWtl+FdWU
	n5zMHcDN8Fzxip8q/UsGvqpamjhviWK7R1cxLiMKl66FbRsZRgQwepYyBFCUtmo=
X-Google-Smtp-Source: AGHT+IGRZqJXTWPcNybDnAZQX/clH2G/w7qq2Cr5221PpPPsrD4hU6+CM6oIxOZll7K724ZB2dG1Dg==
X-Received: by 2002:a17:907:7f94:b0:ab7:be66:792f with SMTP id a640c23a62f3a-abf26837d32mr566881466b.49.1740768884775;
        Fri, 28 Feb 2025 10:54:44 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c0ba408sm331183566b.37.2025.02.28.10.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 10:54:43 -0800 (PST)
Date: Fri, 28 Feb 2025 18:54:40 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 1/9] KVM: arm64: Handle huge mappings for np-guest CMOs
Message-ID: <Z8IGcA6h6hZx7ujh@google.com>
References: <20250228102530.1229089-1-vdonnefort@google.com>
 <20250228102530.1229089-2-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228102530.1229089-2-vdonnefort@google.com>

On Friday 28 Feb 2025 at 10:25:17 (+0000), Vincent Donnefort wrote:
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 19c3c631708c..a796e257c41f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -219,14 +219,24 @@ static void guest_s2_put_page(void *addr)
>  
>  static void clean_dcache_guest_page(void *va, size_t size)
>  {
> -	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
> -	hyp_fixmap_unmap();
> +	while (size) {

Nit: not a problem at the moment, but this makes me mildly worried if
size ever became non-page-aligned, could we make the code robust to
that?

> +		__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
> +					  PAGE_SIZE);
> +		hyp_fixmap_unmap();
> +		va += PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +	}
>  }
>  
>  static void invalidate_icache_guest_page(void *va, size_t size)
>  {
> -	__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
> -	hyp_fixmap_unmap();
> +	while (size) {
> +		__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
> +					       PAGE_SIZE);
> +		hyp_fixmap_unmap();
> +		va += PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +	}
>  }
>  
>  int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
> -- 
> 2.48.1.711.g2feabab25a-goog
> 
