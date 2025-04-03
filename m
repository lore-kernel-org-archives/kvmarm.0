Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F299188A3A
	for <kvmarm@lists.linux.dev>; Thu,  3 Apr 2025 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694043; cv=none; b=Y8yDVaoezB0YrtlKi9D04wL0JLhPlTsuyczrq+qY/4zwyXGFD5nUPDqxU/aH2rwVxx6vhHedxJbgYSLz2c2fC1jS48sQqpHtBI7qvdY5YvdKieGJkCJbYAhsKDzHLQXs8ils5nM/iQ69VIK1uwSGOW0pynYW50OerzMPsOmoHSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694043; c=relaxed/simple;
	bh=REhjuZvcA3i8G0dTb+3RkycXOZa+eB7qm8HZB2lP/Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cYRmMSYKFa+/3rqQUtJkITV86lo2HS/EUalUrNEURsaxONYGbLv3q7ayBWTNX5wl7+2ChrJWW3CzRdK2TOxBEXkYyCkS+s03CYiuN2U1LsowxlUt16IBmeQDBXLRCAtLRgSohEB2T0p0yYcg0K9tv7tIQ8P6wPF0/WV1bzZK5co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hh6pEtkl; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hh6pEtkl"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac28e66c0e1so154454866b.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Apr 2025 08:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743694040; x=1744298840; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JTskUv4HRecH8zkwhc0nWGv0insFCOczgkdAhLL+Odk=;
        b=Hh6pEtklvCEc04DrIx2bQsfYaYHepTRk8fVs9hybBD2hcaq48zD4wKRgZrbrsK8peg
         hGxx/Gv12gwxjVnf7lH7RZq8TElakmT/rfs3EPx7d+4bI5E0OaAUvnf6+J0oEnzlo36v
         cjuCujxos4K4wsAjNtotuuMMM+6ZYuuOYaVR6dyMEOGD/Y9VUFnIb786tIrZESeeK5I8
         +7/6NUhBUgShLqLm2ZGcVMDG+efDlf6tn+/A+afZMI999tD0pGr+w8wG3woQonCc7Zsl
         i3S+/9OqMQ++gmHxSVV24J2Uegi3oMula/8iNj1sBpd7bBTQ3PqwOVuZBy4P8d4zW+fO
         fQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743694040; x=1744298840;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JTskUv4HRecH8zkwhc0nWGv0insFCOczgkdAhLL+Odk=;
        b=YjiF2ahWeXHcSLf91Ol5S6roHICievDVicxzc2nI/ajJtoE1FG2ycrI7G3ENJ2SHF/
         tqGtta5iXyuEjpfPznoZCJwpFCWwHEloZcQ4Iv3GFn8UbpHY3/ZmkEZOq0zKLNRMtA0v
         5eEDZhHQ1sBCOdsMP6a6YqK5itjxfNfcez1OQgXnV9mm+9+GHfVAJgPtUsr7P5NwkFg+
         BOmuRgEDVf51QVBRzh/sz1Rd8i8A0C3bUbiSditn95oyAZXzj5SKjagi4RIE3dqUNILr
         ZyBmRoD/X5uzuQHBLw1z780C7qEQpZUKi92dtC+qJ1AWy23svEAaw974+3WLI2/Sfxdf
         bwkg==
X-Forwarded-Encrypted: i=1; AJvYcCVRcCN2ZpoKkSlwauS8J2csx3BRPBNtjaMRwiWrd5FeKDeQcO1hJqv8LnnSOYXvQArgVYvelTM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWP6yhGqli6U9LUjpdvrNeRgyLXn2NzDbsnSmFgmhG+L7//AQt
	ocwICtM8f8G5PLosv0UfEdJxu7RY7bf4PuBgs4nFR/+wdd7TDBX7I5XdkDM/iA==
X-Gm-Gg: ASbGncuIaF6LnT+zrfl7W8LFvNNpcXpYniSzu6LlRL5VpcqBy958zm+UPmX4BdE/2jF
	pIcV0ZcbNdrZtDEfkoWmZUw5B2gRj+uAbpbMRSfs/8wW3d24HpH4gCoZB6ZpHKEV9ischDKjx73
	TGb62I+SwemO7cJjKd7wErKQeq+v9PMGJXWk3ProaNOh79baRYQkZZm85qDeciVT+cbHsj+9pcZ
	xGGLEGEgdRtZ3G/jGvMKGuboNqq2dRI/gPouXvCt927M20m5wdf3L+mrriOvhMIRRFbXPhx9pDK
	/G/p7Pq3KWhs70Y5vJF7+K4Bv73S5fjG8NxR82cBh3bTluGBelrPVJeaSJX3Jhbc8AVKb4U+rBS
	lNPnd7g==
X-Google-Smtp-Source: AGHT+IFfmyWrTKMc40a2U0IAHYIOZlLiCjW5rNWsqaDLQ9B5AQ5QDUuo3j6YMdMQxsUaTDXfNwPjYg==
X-Received: by 2002:a17:907:94c2:b0:ac2:a50a:51ad with SMTP id a640c23a62f3a-ac7d1893010mr177366b.14.1743694039740;
        Thu, 03 Apr 2025 08:27:19 -0700 (PDT)
Received: from google.com (40.162.204.35.bc.googleusercontent.com. [35.204.162.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013ec0esm108015266b.98.2025.04.03.08.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 08:27:18 -0700 (PDT)
Date: Thu, 3 Apr 2025 15:27:15 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 2/9] KVM: arm64: Add a range to
 __pkvm_host_share_guest()
Message-ID: <Z-6o0zcLa4Aw0N6R@google.com>
References: <20250306110038.3733649-1-vdonnefort@google.com>
 <20250306110038.3733649-3-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306110038.3733649-3-vdonnefort@google.com>

On Thursday 06 Mar 2025 at 11:00:31 (+0000), Vincent Donnefort wrote:
> +int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
>  			    enum kvm_pgtable_prot prot)
>  {
>  	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
>  	u64 phys = hyp_pfn_to_phys(pfn);
>  	u64 ipa = hyp_pfn_to_phys(gfn);
> +	enum pkvm_page_state state;
>  	struct hyp_page *page;
> +	u64 size;
>  	int ret;
>  
>  	if (prot & ~KVM_PGTABLE_PROT_RWX)
>  		return -EINVAL;
>  
> -	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> +	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
> +	if (ret)
> +		return ret;
> +
> +	ret = check_range_allowed_memory(phys, phys + size);
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
> -	page = hyp_phys_to_page(phys);
> -	switch (page->host_state) {
> +	state = hyp_phys_to_page(phys)->host_state;
> +	for_each_hyp_page(phys, size, page) {
> +		if (page->host_state != state) {
> +			ret = -EPERM;
> +			goto unlock;
> +		}
> +	}
> +
> +	switch (state) {
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

So we're walking the entire phys range 3 times;

	1. to check the host_state is consistent with that of the first
	page;

	2. to set the state to SHARED_OWNED or to check the
	host_share_guest_count;

	3. and then again here to update the host share guest count

I feel like we could probably remove at least one loop with a pattern
like so:

	for_each_hyp_page(phys, size, page) {
		switch (page->state) {
		case PKVM_PAGE_OWNED:
			continue;
		case PKVM_PAGE_SHARED_BORROWED:
			if (page->host_shared_guest_count)
				continue;
			fallthrough;
		default;
			ret = -EPERM;
			goto unlock;
		}
	}

	for_each_hyp_page(phys, size, page) {
		page->host_state = PKVM_PAGE_SHARED_OWNED;
		page->host_share_guest_count++;
	}

That would also tolerate a mix of OWNED and SHARED_OWNED page in the
range, which I'm not sure is needed but it doesn't cost us anything to
support so ... :-)

Wdyt?

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
