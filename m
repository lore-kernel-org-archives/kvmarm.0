Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4783021B91D
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 10:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746527804; cv=none; b=jPm28QH2nuT+LU6Atz7a/4a8VV1ZXBHMmYdPbvK6kThHMZzfAJIAJNbkI7Vwz+0yFlnQnU8AzyNoOy5+279bXB7pLhppz3bv3AJejzAlkVZZ1vDsvhBwJySiTM/4BfzK8/2zKUki1lAHaMoGOjpWaZBOzdlEYeuH9JK7/PYlcZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746527804; c=relaxed/simple;
	bh=doINJDVKHGcrz+5RKbuuacCK4OinbdLgMhBEmYZ+Kz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyQY9ljxXg6k+fNVFjeCmPbB8gXAUIBj3tCbJk4pftSKhln7D2wy6HKVw5E75FhdzFzxrIC9t5abBteQ+rZ76ekfUrw2J/ql2HCkeHTDYvGHJon8ITWq+He3Z5jzTIxf/YVIqjZO0AUrtNpde0JJQnKrV5dBrLILerMjQ4N0Pyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hlkBXfeX; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hlkBXfeX"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39c0dfba946so4433848f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 03:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746527800; x=1747132600; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=83BB7SmwDzPYUhpIg9noheded8S+cXeSPX7ePATlnPI=;
        b=hlkBXfeXLEg0DVUwBxqu7otXPN7vRlftWAINQJwSt7UsysHStOpBuChYj8Esg9b9Zw
         dNptMTC6bATXFeRs9Aq3/e/eOCPCCU5/uRRBRBF8L9k10TpBlFssMgeUh1Zt5WA29HWi
         oyClo6T6k8G0nkIL+kTbI7PAUXTMAiYCGX3CQTDFtGsCd/wJyigi8yCPNJeoXtS+OmTc
         5lo0hgWVLLkSWJ5t1eM9/nnbQ1vs5SaPlIjDlmhLSYnIBl6VqpIaoMpF8spC1SQYTZzy
         sNF50MlnyfB+LJz5EKs9kFhwyzKRfXAYZtIWFy+ql9C1cn+3K3pi+HlvUo0Z1LPaiiyg
         duxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746527800; x=1747132600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83BB7SmwDzPYUhpIg9noheded8S+cXeSPX7ePATlnPI=;
        b=nARyprXYxANUMs9vdloxDdgW+LIUYofNpXVS/KeYKALvgAJcwQNnaqB1QBrF7VIfdX
         8So/07YmeIrBPhDWbNTu3KiGUYy42P9qDOt1x/++fwx2v5UjmPcqSFE8RrRhfxy4JzkH
         bOvt+1jhOlWl/5upkJF9h/7tG631rnO8Oxz23DtGCnKXmgGFc1OTM1au+xgAJZ8FNv0I
         qR/lTEJi5d2SVst2QUFlmqB9v9fxzQo3SN0R8E3A4zym8ujbzEXLjGLQPMlc9fPg9C6Q
         NEoKT/32yZLS/eKO9CJenB9rkxLJqtUrofpoIqV2WjMZIE5/Jq3TeUQGd8kSDqJbn+g2
         E8RQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0meeN+f7PQitjnLXJ1+EAA38NPKZCcoxONqZ76ZymsNWi4pn1ukSLZWzEBOBWfFruuPJWBuQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiiD/HOLEBotmJkI3hwB/ESaTqRzNBarGidtmL1dI1BbItaLya
	COfDLNDIuuEQcJVLBzYaHQ4rj8odBPi+WMlh/GIw08ZOPOJE83IUsZV65O6VEQ==
X-Gm-Gg: ASbGnctcHW2sKHIfY2xfK7CVqSRAcZnS87GkaPLswg0DAY/5iSWrAjmKE/JNGDZVoFM
	OyqtXJO5T98hz040PgzKUpzGVDWmdbqq5kazAab6tCYoiciwObr6741FWY388YuLCkxMcr84JZ5
	r/LwSyhunnARjMda/qakBpsnsGsxSHqA/UrQ+qnzz+25rKUqc4ssnYtSzc8vYypftH7eB2bFnBz
	voe4EIBhUo2b59QKz0+IJNIIqgqGqFc+QP4FXjiTD+Z17CEUpq/aT6GlLcyXAwFVBYZbl8oNsnm
	kDv8Ngi8cYWAZMEve6VZaARfwiVlS64XUJkwQZRRABJ1puTsXYxTiodWI0EbqGmF/+wpCTnD/b4
	BAWGkbw==
X-Google-Smtp-Source: AGHT+IG2CayH2yxmNUdwN95+efpUFPMFHxnxBFQj2axpQ8sGyin+5/PNn5XBefvcRCOTd+k50QaHVw==
X-Received: by 2002:a5d:5f8a:0:b0:3a0:7a7c:2648 with SMTP id ffacd0b85a97d-3a0ac0eaa24mr2087956f8f.27.1746527800468;
        Tue, 06 May 2025 03:36:40 -0700 (PDT)
Received: from google.com (24.204.140.34.bc.googleusercontent.com. [34.140.204.24])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a0b0dffaa1sm1179414f8f.31.2025.05.06.03.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 03:36:40 -0700 (PDT)
Date: Tue, 6 May 2025 11:36:35 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix uninitialized memcache pointer in
 user_mem_abort()
Message-ID: <aBnmM7DSonZr_VHC@google.com>
References: <20250505173148.33900-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505173148.33900-1-sebott@redhat.com>

On Mon, May 05, 2025 at 07:31:48PM +0200, Sebastian Ott wrote:
> Commit fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM") made the
> initialization of the local memcache variable in user_mem_abort()
> conditional, leaving a codepath where it is used uninitialized via
> kvm_pgtable_stage2_map().
> 
> This can fail on any path that requires a stage-2 allocation
> without transition via a permission fault or dirty logging.
> 
> Fix this by making sure that memcache is always valid.
> 
> Fixes: fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM")
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/kvmarm/3f5db4c7-ccce-fb95-595c-692fa7aad227@redhat.com/
> ---
>  arch/arm64/kvm/mmu.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 754f2fe0cc67..eeda92330ade 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1501,6 +1501,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		return -EFAULT;
>  	}
>  
> +	if (!is_protected_kvm_enabled())
> +		memcache = &vcpu->arch.mmu_page_cache;
> +	else
> +		memcache = &vcpu->arch.pkvm_memcache;
> +
>  	/*
>  	 * Permission faults just need to update the existing leaf entry,
>  	 * and so normally don't require allocations from the memcache. The
> @@ -1510,13 +1515,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (!fault_is_perm || (logging_active && write_fault)) {
>  		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
>  
> -		if (!is_protected_kvm_enabled()) {
> -			memcache = &vcpu->arch.mmu_page_cache;
> +		if (!is_protected_kvm_enabled())
>  			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
> -		} else {
> -			memcache = &vcpu->arch.pkvm_memcache;
> +		else
>  			ret = topup_hyp_memcache(memcache, min_pages);
> -		}
> +
>  		if (ret)
>  			return ret;
>  	}
> 
> base-commit: 92a09c47464d040866cf2b4cd052bc60555185fb
> -- 
> 2.49.0
> 
> 

For the pKVM part 

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

Thanks
