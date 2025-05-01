Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3F3230273
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 02:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068362; cv=none; b=lnAd7lJxBNFn+VgwGnbfIY6Wrnpuwb0GfvZc0ZM3sF0vHdDU6AkeYF/DiW8ZQQyscXpk08kkDEmLA7q3qb7qoT/58EZK7E/ZcHNM1L7hQb5VBlXGoKrjweUmoXmT3KvFdylDmgqAehZaweAXiz4QHSTq5kyQukbulJsrB+KPh2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068362; c=relaxed/simple;
	bh=Zko5+xN7riZiMuZ1pSKeoiFEaqg2+CWZlT1tk47iQVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LX+Z/YGoh8B4FsQ4gYpHDAzT3KgU47+nVcU31G5YWqp9f4jD/wacLLP8SOFohO4n+SfCyG56NKAJ8L/LQRLu7FSYsMeG1VvEUrr5vP3LrKhx80GoyUmCatbfy6wT09RBYejEBDk/KEDFn+m8BilPMAqeZaMWtXyjyKpYJPlbrW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HNbuQubZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HNbuQubZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWDv7QgtWpFRbFd8EFQQNhSn0JvkvImiDgitgfxQfQw=;
	b=HNbuQubZyitsZm+0qkxQomjVt2KDFzhZSfEYL0eVl+3/NEGrGmNj5TcLWyaZRY/pZfWUUg
	IcAEnMTqG0uA0a0f1vQyRxbFsYL1HF130gJKoAg9E0GEl9DGJwyAoBGW5BaUR5PPnfoBow
	7zVBq0VxvkX44eNgsURzxwLmWZhvghc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-a842YSxlNEyA2yGDm2L_xQ-1; Wed, 30 Apr 2025 22:59:15 -0400
X-MC-Unique: a842YSxlNEyA2yGDm2L_xQ-1
X-Mimecast-MFC-AGG-ID: a842YSxlNEyA2yGDm2L_xQ_1746068353
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-73917303082so397066b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 19:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068353; x=1746673153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yWDv7QgtWpFRbFd8EFQQNhSn0JvkvImiDgitgfxQfQw=;
        b=hmEgFcsitHpJ9GEFVVisizS3GxJTZ0kap0qvncdjpes7T70kxumJdQoqpvFok3ZHGH
         R5Se9ziw/TjN7iFTP6DrruMWYIUwYZwM295Hg1P5eLtkdtWqbe9wrolSs4aotqsRdeaF
         RhWyu62rDm2Lvp4MgpmdWk4JnJUUxafLUA1I+hlsnzdKy+/vnrwmXtVYK1PUM4IrLdex
         fu+LMM2Ju7K3VNCHSUca5D+XQ60HRTDUuCPyWP7wtmqjtncrYoCfsMk+lDxR/liUUqkk
         0dyd+dPA+5fGNoZcM1/YbuBYrIgm5c/3flQZOY1FRxltrAXv58RxKp+lB15o96ziUu+R
         1kcA==
X-Forwarded-Encrypted: i=1; AJvYcCWYNmfdRW+TNoWgHY5/vxaheZhTz8kFsdxvt8OlASwWi7FWCjpg0RAyKsNWv3Ows+1fG2XpQBY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCKylx8ohm8+r2LN5MMmo63PZV6hx/XEgxwLgr1nC6W7S1FuGr
	g4aknrkR1cpLt8GDx89LioHdqsnIy9j/tzO4lZH1ARlSi8JypKHPfmHAJnc5uKei7dGykKyP5c1
	l9H43saWdbXX9zwis5MAu91NL1rt2Tz72eAGmcTmgl+ei8nbH+nuQtg==
X-Gm-Gg: ASbGncvDQYWbqUGQaH1j8VVWNkVNqPxheKeexluJtJLtCWVKlpQh6vTGlcq3liTrkvQ
	YdIkWmPhjr8IBG0CQEeZ/IDhx9oB1TOCkUbE9H1+NZF+LeEuj9aIHnJtPpIUpwVuZHhhhqNFSJ1
	oChaPrBKATI/ohV11c2cJxa0GGRbDzCYFm30QDQGGTM4zOa7AvOgjEVw9nlje+uxSqb35Bu3kSl
	yYZA0RO/mItCeoegpXgOvcksMS38KgdZPM9fv+psByHHtP+z9D2/HBEF75cOFX3n3+syxy0FOVQ
	9jv326pz4mPp
X-Received: by 2002:a05:6a00:3a25:b0:73e:10ea:1196 with SMTP id d2e1a72fcca58-7403a77bf00mr7642192b3a.8.1746068352842;
        Wed, 30 Apr 2025 19:59:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0SD+HY6HsoDRs4fU8wKvcmnTLQD3iURrjVjXooMLHosKIAp3vt2EoNdzvtsz4Y2FqbqtOvg==
X-Received: by 2002:a05:6a00:3a25:b0:73e:10ea:1196 with SMTP id d2e1a72fcca58-7403a77bf00mr7642161b3a.8.1746068352436;
        Wed, 30 Apr 2025 19:59:12 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7403991fcbfsm2480425b3a.49.2025.04.30.19.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 19:59:11 -0700 (PDT)
Message-ID: <0cd3d811-1e05-4cdc-aaea-b45fddfc9e2d@redhat.com>
Date: Thu, 1 May 2025 12:59:03 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 29/43] arm64: RME: Always use 4k pages for realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-30-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-30-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VZ3KguaF_qN1U58y5TBRe1JLt8O2BeuCFSCZpXpqx40_1746068353
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> Guest_memfd doesn't yet natively support huge pages, and there are
> currently difficulties for a VMM to manage huge pages efficiently so for
> now always split up mappings to PTE (4k).
> 
> The two issues that need progressing before supporting huge pages for
> realms are:
> 
>   1. guest_memfd needs to be able to allocate from an appropriate
>      allocator which can provide huge pages.
> 
>   2. The VMM needs to be able to repurpose private memory for a shared
>      mapping when the guest VM requests memory is transitioned. Because
>      this can happen at a 4k granularity it isn't possible to
>      free/reallocate while huge pages are in use. Allowing the VMM to
>      mmap() the shared portion of a huge page would allow the huge page
>      to be recreated when the memory is unshared and made protected again.
> 
> These two issues are not specific to realms and don't affect the realm
> API, so for now just break everything down to 4k pages in the RMM
> controlled stage 2. Future work can add huge page support without
> changing the uAPI.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Rewritten commit message
> ---
>   arch/arm64/kvm/mmu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 

One nitpick below.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 02b66ee35426..29bab7a46033 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1653,6 +1653,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (logging_active || is_protected_kvm_enabled()) {
>   		force_pte = true;
>   		vma_shift = PAGE_SHIFT;
> +	} else if (vcpu_is_rec(vcpu)) {
> +		// Force PTE level mappings for realms
> +		force_pte = true;
> +		vma_shift = PAGE_SHIFT;

		/* Force PTE level mappings for realms */

>   	} else {
>   		vma_shift = get_vma_page_shift(vma, hva);
>   	}

Thanks,
Gavin

