Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C4C1F09A2
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 19:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740769614; cv=none; b=i1ujjBhA0QXhRe17zsxSFi0p9UuItr2kLDkY+Pbl12VEBAr6DLRZYKoI/GSSm7t9rcD3TFCPUO0/u313c53+H46VxqxcUMV0TOSOrAhX9IL57KZTlHrLic39iqviekaC4asm/VGDIae3j7b69hL7SIxArB8eFsuTP+NwSqZSRr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740769614; c=relaxed/simple;
	bh=OCN3u5wSjbvOGv3cYLmLbEn4K1fJZqzIx2HUAFJtftw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbfXL6JA4O/Gb86YN/1h0xOvY43qqzqdd5dY1CvNRzlzDLiN5p4LInbLBkV8dB8056ElduGvWs8Vf/I6j+6iOosl8PkhEJMiRoqEgJuNJMomSzxn9iBR3OJR0MwCbproFaz8zM42bWHIuc4SaMZaFwOlo1EgxOTu91wtcsmnNHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WUe3sl1c; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WUe3sl1c"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abb79af88afso456557866b.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 11:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740769611; x=1741374411; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ea7ysfoGL0hxym9kuH3xIfg8V89PAft4k8+18YntGKQ=;
        b=WUe3sl1cBUhPXZdJROsLFpF1tUzSJDYcEadsY3lDE0+Czw/hyhvGI0kuYRodRIaU2T
         uEgoRV5JwbwJ8Nw8/a8tQXIfxBuJquotXiSZZY6ifvrDwoj/GF1MWDfcJUXbk9qbREQr
         66GpjsPEvTQ26YqZhAikOs2Psd2FRa5tLckXEL6ScXPyxh5WQMk+zCr19i8TfJdNma86
         wMXkai85WxunlAc+ZcKn+XYeNHAg99wqAJm6M131j+5EOlfkYSIbLEY5ev0Qf1B+kPPC
         PGiSt/pEWEr9AymgXZERTsIh2UkkjLG/XBGtECuZv265cO1ywxyIMCBvzPc6DX5OXDWi
         oLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740769611; x=1741374411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ea7ysfoGL0hxym9kuH3xIfg8V89PAft4k8+18YntGKQ=;
        b=a+QGb106wFTKmQwS7zJDuucObE89jc0TuDA6PSuMV2hg0mPrJWiYyAfKoU/5gd8sJU
         Y+pSpyHmOtrS8HUlKADuA/qo6b56wURzO9btsaVcQVwWi/sKqEsa7OTXQ9kotY+iGxOo
         +utZtm17Z4hOqjvwjZ5jq2RE5cyOqpI58+gSc7NSK21Vx3Wub7zP+uWFyxzakoUS9qo6
         vvH8jPu5Y8uE6dUq16Pw0sdDICwEw4wSvwdH9OO6bPfA/H0YgDHUOVzogiOcASHFQBcm
         3AHNh6EPoRqL2xOmOB7lndNLTBtUv5+qBoAa2ErOUG6I5hO8sz7hkH0WGrcWDNBsGomC
         WaCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuLEojiW1p9P7eoE49ozs+EepbYBXh8boot9CyNZUXBf3dDrh6V8awD9GGO5gRYlvxxrfct5c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrrkcH8i6T2XrTU8qgaGDSPIy/dkzhmQZ3DnawV/c34jTD9bXR
	9szHxSI+TYvC5PWMpABvvzqyfttu7Cd/FHWHfVDQE+7fT1lmsm+SRf2nLcS8kw==
X-Gm-Gg: ASbGncsGzMNBtgrQ+I+9tAMqY9l/fqO9nnBQcEnRdANVFR8COlJdC6HF/V2scnFKuBK
	FqSOWTSKBDmUelV2zs3Maz5BQ8k2sz2MK+pqEYHxgUTnvGFubL6jnvOXs1zhATUm7zycqS75qZs
	wu2IfDBzY5JO/oJXJ9wOdlKEROW1fkRDssc9djKBuK0Vt+FkOO/s9iVIqL/QbjEpd5OJ1F8+7o1
	vWc7eWz5f30zrscDsedJV5YQ0PeFpAjsxU7GD6j3nf+SRTaEAO74YGuXHe4VNnEUGehFsjnoTIC
	QdgrEGbMmEoDeu1V5CEgeNPonUubkkohojse9F64f1Yzto8S1UzXm/7W4VqI4E0=
X-Google-Smtp-Source: AGHT+IHwpQw241bZAJUNRa/tRbDYtqAe8cu3t+94vTg5nA3MIoSIYj/LClqOfEXXyyELcdm0kfuXLg==
X-Received: by 2002:a17:907:7f0f:b0:ab6:b9c0:1ea2 with SMTP id a640c23a62f3a-abf261f2529mr471016666b.25.1740769611173;
        Fri, 28 Feb 2025 11:06:51 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c1165e7sm333069566b.82.2025.02.28.11.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 11:06:50 -0800 (PST)
Date: Fri, 28 Feb 2025 19:06:46 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 2/9] KVM: arm64: Add a range to __pkvm_host_share_guest()
Message-ID: <Z8IJRpoQUoGazLku@google.com>
References: <20250228102530.1229089-1-vdonnefort@google.com>
 <20250228102530.1229089-3-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228102530.1229089-3-vdonnefort@google.com>

On Friday 28 Feb 2025 at 10:25:18 (+0000), Vincent Donnefort wrote:
> +int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
>  			    enum kvm_pgtable_prot prot)
>  {
>  	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
>  	u64 phys = hyp_pfn_to_phys(pfn);
>  	u64 ipa = hyp_pfn_to_phys(gfn);
>  	struct hyp_page *page;
> +	u64 size;
>  	int ret;
>  
>  	if (prot & ~KVM_PGTABLE_PROT_RWX)
>  		return -EINVAL;
>  
> -	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);

I'm not sure it is safe to drop this check here, see below.

> +	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
>  	if (ret)
>  		return ret;
>  
>  	host_lock_component();
>  	guest_lock_component(vm);
>  
> -	ret = __guest_check_page_state_range(vcpu, ipa, PAGE_SIZE, PKVM_NOPAGE);
> +	ret = __guest_check_page_state_range(vm, ipa, size, PKVM_NOPAGE);
>  	if (ret)
>  		goto unlock;
>  
>  	page = hyp_phys_to_page(phys);

Phys really needs to be a valid memory address here for 'page' to be
present in the vmemma -- dereference right below. So we can't rely on
the check in __host_check_page_state_range() sadly ...

> +	ret = __host_check_page_state_range(phys, size, page->host_state);
> +	if (ret)
> +		goto unlock;
> +
>  	switch (page->host_state) {
>  	case PKVM_PAGE_OWNED:
> -		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
> +		WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED));
>  		break;
>  	case PKVM_PAGE_SHARED_OWNED:
> -		if (page->host_share_guest_count)
> -			break;
> -		/* Only host to np-guest multi-sharing is tolerated */
> -		WARN_ON(1);
> -		fallthrough;
> +		for_each_hyp_page(phys, size, page) {
> +			/* Only host to np-guest multi-sharing is tolerated */
> +			if (WARN_ON(!page->host_share_guest_count)) {
> +				ret = -EPERM;
> +				goto unlock;
> +			}
> +		}
> +		break;
>  	default:
>  		ret = -EPERM;
>  		goto unlock;
>  	}
>  
> -	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> +	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
>  				       pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
>  				       &vcpu->vcpu.arch.pkvm_memcache, 0));
> -	page->host_share_guest_count++;
> +	__host_update_share_guest_count(phys, size, true);
>  
>  unlock:
>  	guest_unlock_component(vm);
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 930b677eb9b0..00fd9a524bf7 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -361,7 +361,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		return -EINVAL;
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> -	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, prot);
> +	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, 1, prot);
>  	if (ret) {
>  		/* Is the gfn already mapped due to a racing vCPU? */
>  		if (ret == -EPERM)
> -- 
> 2.48.1.711.g2feabab25a-goog
> 
