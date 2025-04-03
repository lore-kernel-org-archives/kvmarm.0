Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0962824BCF9
	for <kvmarm@lists.linux.dev>; Thu,  3 Apr 2025 14:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743690263; cv=none; b=ExABrP1bVZBsafY/dk45PQNOZ0CANW3ontn0gcGsuRq8xOHjlLEewSaaSydVKyaLz0e2xRrvcR7cN4JVCDpBbjAMqvyoPXB1gUhY/SCI7fMIa6PlKwJ7kycITUnLUmJz0SpbtMaeQHee8zy5jWZbQGAD1tkiP5Gp995ZvR1yzys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743690263; c=relaxed/simple;
	bh=EkUq54YbtHaSFlkcgNeh41msuRCSH1wM/iY0EssPtSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxOm7X7wqeBQlkzJPdrZRS0aWkCQmXF76S+OKxJNvfchLxR9ArRsCURdQGNGe9QPEdSfCJ0VTzwg2neJDstQVRLY70Q5iz9GngmH5BRTZ/bAfi15xM840Zc1ivZCngh7NkVpwCmhnPmJkwM4FLgEB5hK0zJ4jy6YTCUpPS4S36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4MtAFNVY; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4MtAFNVY"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e5b6f3025dso1545414a12.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Apr 2025 07:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743690260; x=1744295060; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDpmek/X0kwpQJH4VvCCmLBAuzVkaDGKXNEK4ox1gYY=;
        b=4MtAFNVYrGMAlQcwfGcvME6rxYnYBuwLq4cyOd9wLOJ4m+yvGP+w7Un+JPs4rBOKUw
         TxgmzC31uijmhb4iJc71kqRkYu+TsuO+eN6yNoVthpMVWnr00BTgoMBj2fHY2/tIjpKJ
         4sDX2CwsmWJrr/thrTDwXpB8uw9WknUsr9wQBj40B+wjzmXtjVM90OZfy6mz5Y6mBqU4
         cLJPQnki4gUQRxAhyJdahZQr6bZ1jLxZodhzojyCQAQKeMMcF0/yosp0SWDWDKDk2+52
         85bWu2cRrCWP2w7hZmpAtJc6xTuGdK9Tl7LGYqKtFq/XylABqF8V4iFvrBJOhlJ34lLq
         zRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743690260; x=1744295060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDpmek/X0kwpQJH4VvCCmLBAuzVkaDGKXNEK4ox1gYY=;
        b=KG72l0adfJqo48KX12QQqQMI07QsSlmlu3q28PqWB5JxNGfv7Q60bwqUNECAbQqPXe
         klrfr3OgmiZGeP6PulSHRuI0ony0018QV2m1nIUIu0AUFJ36h3CtQizoAw+z5ek1XAnT
         E8Pji9+RjHrLFO3zmeS9lM/z2NEOm9LsRPWYw8hYO4BeJa2WYp9fk8hplSJTBY3PKgnO
         EhUfI2EfMyy4akC3o0JgsWJjPjSQKJE9qqvSQpGNEDXUFbop36GQynq8wvb8kLjmnGif
         juq6MZDfRzSyS49yFCdvPdjFe+Wpa97qKv/EH6XVy7IgMRQqNEs3ZK25A09/4YDbNCwJ
         +GsA==
X-Forwarded-Encrypted: i=1; AJvYcCVMOCiOT8UyVEhxdzG01l8HmqUuZYSxj7u4jpJ4x9jedYWrADenaTQAm5Ai3bJIC+GZPjq7V6E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxh9yk9pd60WgMqEoDX8zUL+I7Gl/kB2HjGLtJDgoMN4a8bTtbv
	+8QLsgAF2cAp9VVWJq4tMIXbajLZMqFN9Ao/BVdd/oi5XNxZu6UtRZ6wTqzDfA==
X-Gm-Gg: ASbGncuKZA8s6EKTsZsR+Cqp9sviER5lIJtFHkrxRtJCHS6WZ2IQdkxSa/SY4jk4EhG
	m3dtjTbOqIts+BZkZZgfKYNkaCU5Pby1p95GQJdjHwWwi4Wvm+HNqHQVexUmlDOVnEe6FEQl8gE
	YCOPtU41IzE+Pkun0Ld8kOjPgvto4An83pdk3rl0PdDKIJ+Y0mSq/JsH+fi71tBz2sxB9RZZILi
	oowZd6Mw+MwBgxuq8NwJnZ06orOUriHjqIV/uVABMZbD6WIlFRpCPWkvf+92mrNK4Tbrbc8oIcC
	t68niw9m2ACqSF3iT6KEcsr8gryYkiuYNIBWWA05ccsjO8t4RvbwMV1R35DOmc1H0Ten+batFaS
	EvEJSNieCeBr1VzWC
X-Google-Smtp-Source: AGHT+IGyNvHXBQg4ozO8/+QSZISlP/oFpgDXV5BJWgExW3afo1HCSCPDBCsyR32+joySAgPe8H3f4Q==
X-Received: by 2002:a05:6402:3204:b0:5f0:82cd:500b with SMTP id 4fb4d7f45d1cf-5f082cd5216mr3828226a12.19.1743690260100;
        Thu, 03 Apr 2025 07:24:20 -0700 (PDT)
Received: from google.com (40.162.204.35.bc.googleusercontent.com. [35.204.162.40])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f0880850f2sm1005128a12.59.2025.04.03.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 07:24:19 -0700 (PDT)
Date: Thu, 3 Apr 2025 14:24:16 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 1/9] KVM: arm64: Handle huge mappings for np-guest CMOs
Message-ID: <Z-6aEOQlbfh_q2Mz@google.com>
References: <20250306110038.3733649-1-vdonnefort@google.com>
 <20250306110038.3733649-2-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306110038.3733649-2-vdonnefort@google.com>

On Thursday 06 Mar 2025 at 11:00:30 (+0000), Vincent Donnefort wrote:
> clean_dcache_guest_page() and invalidate_icache_guest_page() accept a
> size as an argument. But they also rely on fixmap, which can only map a
> single PAGE_SIZE page.
> 
> With the upcoming stage-2 huge mappings for pKVM np-guests, those
> callbacks will get size > PAGE_SIZE. Loop the CMOs on PAGE_SIZE basis
> until the whole range is done.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 19c3c631708c..63968c7740c3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -219,14 +219,30 @@ static void guest_s2_put_page(void *addr)
>  
>  static void clean_dcache_guest_page(void *va, size_t size)
>  {
> -	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
> -	hyp_fixmap_unmap();
> +	if (WARN_ON(!PAGE_ALIGNED(size)))
> +		return;

Nit: it doesn't really matter since WARN_ON() is fatal, but that return
looks a bit weird -- we really shouldn't return without actually do the
CMOs. So maybe just WARN_ON() and not bailing out would be clearer.

Either way the patch works, so:

Reviewed-by: Quentin Perret <qperret@google.com>


> +
> +	while (size) {
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
> +	if (WARN_ON(!PAGE_ALIGNED(size)))
> +		return;
> +
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
