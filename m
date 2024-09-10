Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0653192581
	for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 04:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725941756; cv=none; b=apmUixPlEm6H71Y/GTqPsx3oM4gOQIb+9G0Tl68zPgN19oQl1NOB/iijD9IN+PVa2oqyb7eoOvy3+5MEJnVe4H/cuQ5IT7ZoGfuEgOK+VlCS7eBHqwYKxfQB9oOBvmAIN/Qns2jW+QMHv1vkq2jxJ3fN9JWEqXLU/G2TRjjuCbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725941756; c=relaxed/simple;
	bh=gkZzcVeOY1zKE6Oa+cxE4jiLx/E16ZR2j2sfe3+e4vI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THK3C5hKdyOEt2jtNE8dJe26LuEYByDXOhY8FaZGEcnwrlEKJD0sdtv0x4xTtlJ0DOOqynMT/HfvlA5nZ6RmgX83c7gT7U2vTYJC3dfTE4c9r9idiqKRkAWYMfacSAtj4WggJ9VUE6x6nFd1PMA1efmdzSo+Svikj07ubBOwe+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YDP7NQNK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YDP7NQNK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725941753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u/+FRQQ8Ru8+M5tm0CToElnSS7luR16tiIP4Dg8B3y8=;
	b=YDP7NQNKdmTgwhBpGBLGvuTBuCs/cIk61kktkXoMh1A3uOqkZdz4M4wG1nefO/BfGQbi4O
	D7i4g9gvW3LWYwgGoeRuSeoFBBZ/6ymOr6+YpSGj0Q7ndFNOXQs6EL1pXiyki62dJriG0y
	6qAI7iNxXVtGJvqy+zmzDnvEIHqrQjY=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-7Q2Jhjn7NjemEPoTK9ZhsA-1; Tue, 10 Sep 2024 00:15:50 -0400
X-MC-Unique: 7Q2Jhjn7NjemEPoTK9ZhsA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-207302f244aso17952165ad.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 21:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725941749; x=1726546549;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/+FRQQ8Ru8+M5tm0CToElnSS7luR16tiIP4Dg8B3y8=;
        b=MDWkkbp0hVG6mDJWyMp6L8uD2tdA8/6jwpkWeH6AdfeTBEB0EqN1ISh6UG9s8N2puZ
         izwBJeesPDTNphP6jQpDT3JJ+YwvXz8epRAe/We3wbcXXNXADhMlvuGuxfLdV68feqCw
         osYCdpDqKekjlon4SjKRCWXDd5xQRBZ6HwMZtndbDwQ6vEp8/BV981AzLyRAd5dzIsLS
         F6AjH3njjXQftDJCW6d6CJD5Pj0rE4zD19kt3BVTuoziyNxxUdmGPf/p1Ti1NFHRybJa
         UGCkZBatdC/oZaDbcobcGuh8x7gXZTUk+yfsHBABl6h+16WTQoQ3RYBuOM7EKeGxFBgM
         wrVg==
X-Forwarded-Encrypted: i=1; AJvYcCXoJoDyHfPphxIF0K0/D0CAEQS38hyeQdQsE77tXKSgduwwnMoQQ9/rBoALox1SWQ0wGsxjdUQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxsAO1c2VywGVywvkjsElrxA6uOe0Nlc5n60x9ikfxpiDJUobE2
	+oVIjd0osHhOI3kCf6eZ/J7xKCMyGrI+eWxeLA7PBwKfB88ozzbrI+nJHUxaNj5n5RVWEXtdQ0N
	1EpcZW4DrZC2iQ49tSPErw7WIXco6h1Tyqm3dfcUB3nbuC5rpeofzDg==
X-Received: by 2002:a17:902:f549:b0:202:5af:47fc with SMTP id d9443c01a7336-206f0511f66mr213103765ad.13.1725941749245;
        Mon, 09 Sep 2024 21:15:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESpzFJPvUaYPPTKHz8T4YHLbc03zqgmBJU6sgzN1/EtRPQmV6cfuytRj9V1iBRvh9wsUVF0g==
X-Received: by 2002:a17:902:f549:b0:202:5af:47fc with SMTP id d9443c01a7336-206f0511f66mr213103255ad.13.1725941748534;
        Mon, 09 Sep 2024 21:15:48 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710e0efbesm40682855ad.40.2024.09.09.21.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 21:15:48 -0700 (PDT)
Message-ID: <29016e56-e632-422d-a4d2-1891fad2c565@redhat.com>
Date: Tue, 10 Sep 2024 14:15:39 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/19] efi: arm64: Map Device with Prot Shared
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-13-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240819131924.372366-13-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 11:19 PM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings need to be emualted by the VMM so must be mapped shared
> with the host.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Reworked to use arm64_is_iomem_private() to decide whether the memory
>     needs to be decrypted or not.
> ---
>   arch/arm64/kernel/efi.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 712718aed5dd..95f8e8bf07f8 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -34,8 +34,16 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
>   	u64 attr = md->attribute;
>   	u32 type = md->type;
>   
> -	if (type == EFI_MEMORY_MAPPED_IO)
> -		return PROT_DEVICE_nGnRE;
> +	if (type == EFI_MEMORY_MAPPED_IO) {
> +		pgprot_t prot = __pgprot(PROT_DEVICE_nGnRE);
> +
> +		if (arm64_is_iomem_private(md->phys_addr,
> +					   md->num_pages << EFI_PAGE_SHIFT))
> +			prot = pgprot_encrypted(prot);
> +		else
> +			prot = pgprot_decrypted(prot);
> +		return pgprot_val(prot);
> +	}
>   

Question: the second parameter (@size) passed to arm64_is_iomem_private() covers the
whole region. In [PATCH v5 10/19] arm64: Override set_fixmap_io, the size has been
truncated to the granule size (4KB). They look inconsistent and I don't understand
the reason.

Thanks,
Gavin

