Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44614223716
	for <kvmarm@lists.linux.dev>; Thu,  3 Apr 2025 14:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743690076; cv=none; b=bsxmY1EDU11SIh6c2DX5RYV7C9/gTT/mU05Lhs7I3CbzSDHY4RxAsXW2tydT7f1OcCv7MyLj9Ocr33biDOANHcBilQ383W1XOndFtSXICB7FVpc09rzlpJYJHZw2LztyBb4ON03C00Y4KJpazD1wr7ifqYJYsu8GMyd41XH5Kgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743690076; c=relaxed/simple;
	bh=6bn6maREDF+L1e+/f66gyRIINYrf9kDWSpu9v95X1Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvh7qY1Sltsz28veHdScRIRDNFWvDv97RsUULM+fDnzZcCtqf1uqm72xA73l8GR0W/iK/Yo0MMI8DlwLZTHnvGRzxxajP8Ci2e0jV8nD5OvGj9pFjQwDKNQHTRjCdgQu99JWX+8SxHroxJ9CBuhbGn5TtWOVLVBRVJFDbi6h2rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EGld3LYZ; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EGld3LYZ"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso181271766b.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Apr 2025 07:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743690072; x=1744294872; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RdKyMlf3QjSGqDaSEQwhmI34sCc+7J8IQI9BHCCFOAE=;
        b=EGld3LYZndRIxi/uIUoAfiLgu9q6F2pCoxOw1eS0eVgRBKP2AD5CTd4gEYY+GqmexO
         hJIm7siGSUPaNfVMMSwAFVYPtyPNr6R9KpaVzQnQAG+gxjiNkC+NoXz5ZkLuyts8hvYL
         Xss5J9lxNRsNMvvWReomM8Qo2tMwjbwg5s14wv5KqAODSQG3mUEviN7TTYcO5c8c99sm
         zrC/m7CUkApsJgtszjT9SbdUsYSURFQMwX5Eq4QyXbwLTPRDGlszRdZIb+rVQP+9pWy7
         KVGhT7PmafPiSWwkpDmvrCLxnKu8GIYlUQAsmXBf4nd5xmsqjoz8nw3yf8k+L2Y4bidE
         4+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743690072; x=1744294872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RdKyMlf3QjSGqDaSEQwhmI34sCc+7J8IQI9BHCCFOAE=;
        b=BeIoRmXSGaIMKawgqWhYjdK9n8e13QLCl8E87t5dvkucYuDSuGN36Gbq9zDoftc8yh
         ck9o7Wbs0H8vqmtrd5xGvr1O8h6b4fAlSssqGwQPk83U4wb8i26u5d14dFPPypG8vUtM
         GtgIqEVGZsnap19ifRmBn1NfS3vWv81NffKMexYK/xu7Y+dwrZ4h6WxItHuAyQxQM6IA
         8acMsvG9nUW8muZje84RSfH6Srv+2oD6ujmrvxC5aIcsevkKlOWrBSRCH0omgKug73WR
         PJcV863nkIXW97yeuR7PAhcFp8Sr/n7iYFiwvM6H9Kr9tmQSBirLNAuDOSYnh7XzEeEE
         eBMw==
X-Forwarded-Encrypted: i=1; AJvYcCX4aTajOEfsHc7GLWnBD/T/ao5fAo1EMymSPdJtd6cxr1wYXr0hr+0dhkAtpKy4h5N4Kv2M/KI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiDAM2vLifl2GVzH0RK0WXpgdcns4Mwjrol81A6DbSRFPUCwVI
	PfX6TyT2bKlDhNq0pZ8eecXFg9DPy/Ngi/Z4UDy72hQrFE2xsdpRyscI6HmfKA==
X-Gm-Gg: ASbGncvK55qFyAqF5DlBX4GSbtLcoFARujziIHcX4t06eDD58dOh8VMHi1ntVyJKQP6
	kAU4BNDDcIoGGwlh4/16Ooy4YPAe2lSbEldE0V4GXqcg9p18QCUvj7yj8yLnR4SIM5izfuV9ENY
	U7vV+nin+Tbr7wLoakJiBTBXsZIo2nlpEnAYGbzhyg3dFg3JrDNgxpklmnpx0vrsYyvSnHcLvWq
	EXaziA6FGuEh+8TDhfBxWqCCcW5oUAYCgAi+fqE7EnD1VbvFfMyETGAfuRXat0HzQVPT0YSHbrd
	YLqNJ8MhYkB9pCmC0AyOksoDQjV7KMKluf2MZL7P7OBR0azOWf+VwC3Xw8XHFiTtQ0M4kddKmV6
	ZXl5qTg==
X-Google-Smtp-Source: AGHT+IH9NWYIICiILBtI5t/w7XFm2+Ky2qyQvmJWj71kOjgDjuSgYqFoF+3azC8fuvUTcmLQ14dsAw==
X-Received: by 2002:a17:907:97c9:b0:ac7:2f8b:6844 with SMTP id a640c23a62f3a-ac738a4b2a5mr2120901366b.23.1743690072237;
        Thu, 03 Apr 2025 07:21:12 -0700 (PDT)
Received: from google.com (40.162.204.35.bc.googleusercontent.com. [35.204.162.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe5c599sm99498766b.6.2025.04.03.07.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 07:21:11 -0700 (PDT)
Date: Thu, 3 Apr 2025 14:21:07 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 8/9] KVM: arm64: Stage-2 huge mappings for np-guests
Message-ID: <Z-6ZU7DWkxnVIbff@google.com>
References: <20250306110038.3733649-1-vdonnefort@google.com>
 <20250306110038.3733649-9-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306110038.3733649-9-vdonnefort@google.com>

On Thursday 06 Mar 2025 at 11:00:37 (+0000), Vincent Donnefort wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1f55b0c7b11d..3143f3b52c93 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1525,7 +1525,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * logging_active is guaranteed to never be true for VM_PFNMAP
>  	 * memslots.
>  	 */
> -	if (logging_active || is_protected_kvm_enabled()) {
> +	if (logging_active) {
>  		force_pte = true;
>  		vma_shift = PAGE_SHIFT;
>  	} else {
> @@ -1535,7 +1535,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
>  	case PUD_SHIFT:
> -		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> +		if (is_protected_kvm_enabled() ||
> +		    fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))

Should this be

		if (!is_protected_kvm_enabled() &&
		    fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))

instead?

Thanks,
Quentin
