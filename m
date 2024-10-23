Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9894B6CDAF
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 04:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729656199; cv=none; b=cn/QfNA6Q25yCXAtFThKwntIHm/bp/UWsZnkUbQeTIBRjwmSfm5LBgpzah4usVbpqFfth6OTHDkE+Xo8eLQhzsjkvvQZ3jv/PQxeD5/H2R+WNHsfSJJ0M1095bNGcLUDIihGUshFx0y6aBvW/kphWqcq3DxxtZOz8tLvJz0Yq5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729656199; c=relaxed/simple;
	bh=60FYQnwEjbn8ia2ijE+rJft1/gH3fGagogxsbRnBaRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qefGeveKZI/tvazRG8TL/zJvH7y84CGnRJL5lewDRFX9S/Un7FmLE5vtiGFo5XUjnRld5jPqOkj0rSXYBrEnZ05VpI6sTOuwfXEEEkIziVnUqvWWgri7MKPY8W5dGVGK6FyCojOVnVslDh92+QBAaZfWrOCTfzHi9CMLF8l1eA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E35sBhFN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E35sBhFN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729656196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fE9bH6h+Dp9Cy+4YV9E9TS1/FxNq1rWMOHkDfIVYSY8=;
	b=E35sBhFNluHaVqqslSsWGZAelY2X4PvAlSJAL4cobvkWeBfxwQHWEkrucZjlJeLDa7KPuE
	0g7DnLb5qTn1umLEozDDbXHEkYCjCcu2mAPbtz1vY1Hch+JjjaLFQHnUvwElrYmbmYTWh+
	h1rhDGqs2En71mSU5c0ePNll0A2f2tU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-yPsOzgXrP0qg2CbOw88xNg-1; Wed, 23 Oct 2024 00:03:13 -0400
X-MC-Unique: yPsOzgXrP0qg2CbOw88xNg-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-7cd9ac1fa89so6541648a12.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 21:03:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729656193; x=1730260993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fE9bH6h+Dp9Cy+4YV9E9TS1/FxNq1rWMOHkDfIVYSY8=;
        b=hgaCrTBMHm3bMlgSrszQ0iu/l+7hGDxHbTtCdNAce/1lDxHYkdidrgLuwNIH0BMvKE
         WqtcSQVk8dRXeWNsxRzq2h5RaoV9y3jp8I6IqjBj6DucqdUKQu5x6eEk8xaUyajaU7GZ
         gKc2lgGuN3XzbxShQ0NsZH8h12F64HhaFtvRu3VwyiH8UCv8eFyLSDWnAiVlGWur0R+P
         hu5da8yivvV+wZpaoUdPq/H5GrD4QHFJS25uc7d1YYFU7vk+JODR//ffCF4Zsi54KdJJ
         RmJ8s40lIUM3+efWo7j0JSxjba/XVSA7vinF5YHB61gDSmmzrhEqKcjs0osYNSxi29nT
         MtxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU4SQ6zBJX0bmAIFdRYU1zhGKCjebo9vMa1u/BgNEn0Fd3USh/RKlxCgkeQYE7FDrSWYvYirM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxO1lt23mUqPhmUyNgNQFtql3Wlp0IAqGqMkKOSRN60lApg9JWZ
	C3zatzRwqwANVzc7bbtFodKHnk/qAlLUDRdwvi4/CRa8BLPBox2cV49IUQBueYcNfacg5VCAtD3
	OWECkEcxbziGL82OR2OHbnf4zmU+c7BvJeYogHiFUuqKYVjcGFMNhmA==
X-Received: by 2002:a17:90b:4c4b:b0:2e2:e148:3d30 with SMTP id 98e67ed59e1d1-2e76b60d401mr1665022a91.23.1729656192757;
        Tue, 22 Oct 2024 21:03:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7Nzd7b22QkSrSkT2X54oW0FrLiZkrnYmJFDKn3Ga/iSi3gYtHtDYeZYfv+zNxnl5T9y8tvQ==
X-Received: by 2002:a17:90b:4c4b:b0:2e2:e148:3d30 with SMTP id 98e67ed59e1d1-2e76b60d401mr1664999a91.23.1729656192357;
        Tue, 22 Oct 2024 21:03:12 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e76e088f1fsm273930a91.56.2024.10.22.21.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 21:03:11 -0700 (PDT)
Message-ID: <032d29e7-b6a3-4493-833b-a9b6d9496a75@redhat.com>
Date: Wed, 23 Oct 2024 14:03:03 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/43] kvm: arm64: pgtable: Track the number of pages
 in the entry level
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-3-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004152804.72508-3-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 1:27 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Keep track of the number of pages allocated for the top level PGD,
> rather than computing it every time (though we need it only twice now).
> This will be used later by Arm CCA KVM changes.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 2 ++
>   arch/arm64/kvm/hyp/pgtable.c         | 5 +++--
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 

If we really want to have the number of pages for the top level PGDs,
the existing helpers kvm_pgtable_stage2_pgd_size() for the same purpose
needs to replaced by (struct kvm_pgtable::pgd_pages << PAGE_SHIFT) and
then removed.

The alternative would be just to use kvm_pgtable_stage2_pgd_size() instead of
introducing struct kvm_pgtable::pgd_pages, which will be used in the slow
paths where realm is created or destroyed.

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 03f4c3d7839c..25b512756200 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -404,6 +404,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
>    * struct kvm_pgtable - KVM page-table.
>    * @ia_bits:		Maximum input address size, in bits.
>    * @start_level:	Level at which the page-table walk starts.
> + * @pgd_pages:		Number of pages in the entry level of the page-table.
>    * @pgd:		Pointer to the first top-level entry of the page-table.
>    * @mm_ops:		Memory management callbacks.
>    * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
> @@ -414,6 +415,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
>   struct kvm_pgtable {
>   	u32					ia_bits;
>   	s8					start_level;
> +	u8					pgd_pages;
>   	kvm_pteref_t				pgd;
>   	struct kvm_pgtable_mm_ops		*mm_ops;
>   
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b11bcebac908..9e1be28c3dc9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1534,7 +1534,8 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
>   	s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>   
> -	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
> +	pgt->pgd_pages = kvm_pgd_pages(ia_bits, start_level);
> +	pgd_sz = pgt->pgd_pages * PAGE_SIZE;
>   	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
>   	if (!pgt->pgd)
>   		return -ENOMEM;
> @@ -1586,7 +1587,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>   	};
>   
>   	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> -	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
> +	pgd_sz = pgt->pgd_pages * PAGE_SIZE;
>   	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(&walker, pgt->pgd), pgd_sz);
>   	pgt->pgd = NULL;
>   }

Thanks,
Gavin

