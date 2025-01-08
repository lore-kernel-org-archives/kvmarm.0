Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404901FC7E0
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736352562; cv=none; b=P8ck/lZHdGqawLcUtQND5LIedx+mLKQWNHDcs++WLlhyQN3QD5KaxMbxebNhI1fbtwRw6uMIpOpn+H4XyZ3IdVZbNiVWsSOSWaPKySMV+w95pPhftrHqluVpUIhL1Tdfv0sa4AT5f73GnjZORi7vWjiBpYR0cRCMppcOOTG/iJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736352562; c=relaxed/simple;
	bh=NuSrNlulfl9s9cmF0zPWRDVoyTAa1/r7CsPrXlyoVzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ncI1T+LDLCuNQV+g5GMv3knqwVQ+jwnFyKz84k52UDZWtcWGAIBAAmdYGyi5fg140FvT6UZPqdkw3amlFXFKBSPUMufydwOC43PQskAwtwF4Hxe38LnLCWQm/ErfdpPAPT/KrXkZ1BZt9d76IjN1Yd2IwxLOwBQudZUkmkut5jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LbaS4z/1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LbaS4z/1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736352560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s0rlDhIwvvVKAA/Z/ReGOUxjITf8M7mwn/BPJqxsGsg=;
	b=LbaS4z/1oB4jM4LDfy2IamOYEnD5JX8u2xwtaqLPGa+8d27t/4c8Z8SchjBVJl+n7inkS1
	ByVd9CwhKXJDB/taHQyA67eqm2om5Qr+GK8xGT8xlXVhlOpt0Dak0oWZJ8kZNriGeIeR+6
	mmqk7VNWNm4FAU6t7DpTwQjO8kgDiLA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-JCaB_rrcPm-d9L3-clFOkA-1; Wed, 08 Jan 2025 11:09:19 -0500
X-MC-Unique: JCaB_rrcPm-d9L3-clFOkA-1
X-Mimecast-MFC-AGG-ID: JCaB_rrcPm-d9L3-clFOkA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361d4e8359so132003155e9.3
        for <kvmarm@lists.linux.dev>; Wed, 08 Jan 2025 08:09:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736352558; x=1736957358;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s0rlDhIwvvVKAA/Z/ReGOUxjITf8M7mwn/BPJqxsGsg=;
        b=TjLdFbf2eI1yuH3ZUmBwa7JYfEZ3IxJQPJuC6hskp+KLJVv40ARTtWenFijElxZHaQ
         /pqLEbLZg2YKVfaIdJk6ht50jXmn0UA8rVKWBCMVxeRJ+G3Bq8IgEzNrRFjKPQjTKtue
         c0Sk5bCeBKs1ipyrQq1e36taV5gIasvsb1orhXOx6B9MkF+Kp7cIXlKZWIC+WK1scFMZ
         4bIOpGSzEtMxsJnpTE7L/9pLYKkzRyvIodcQcmXikqo8NktXkk0scTpdQlNoowkIO/MM
         hFEkwK/e6rduJDqx5aKaJW3eoNw5sYvgYZCPnZyApGm1M3prqXK/JDbFmQRpR7akRr/P
         XAhw==
X-Forwarded-Encrypted: i=1; AJvYcCUET4piA95dznkeQ7XGZJtnOTcSjrYpVTAaHY14b4HgZpswbm4Fi8jZXkhmwlAHwwxESlH645A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEsyrroWEjwUj2Xi/lh6yU3yoYpppYBSKeuvFTaorHXB22JQT6
	PeOdSU80nzk9BSsxZYG375ZCVtQUJ7GwA9N83ghr7X9Uik8aW5oaJxZwQsransexm5IavgCrpbU
	tHgWqjQM53t6deA28w97gRsvRKe7EMM2WIlD3rrMEONER7bKV0IidgA==
X-Gm-Gg: ASbGnctP0SYqhlqKf7uJHPkbnrmMIIPrJrKhAXc6DF+9yLz6Y/5fPqF2qdEqmtjljC/
	rBL93+vfZ+bowgH3uFUoNC3xPHXJB6McxV86GKhINWu/LYwxvgmDEor97EPhK/8K9OnsXvmSUul
	s1LenjL2P2VCb0oQy5/Yb3rn0cDa1o2FVZeSEIsWf/P+mRTDvNCIVsYj/6slJvqZOR0FN1vx4Qf
	U358a0Oag3obtq1DmzG3ZoxcwNSdUtyUKF1FPUh+ERCKLdmIHscamcinFTeBQffc69HCwpagT5M
	RA4JOH4GytrYuBFhRnWzyLi+Ny9skF9EkMqo7oaHfOVUKNA8UF8sThcDC6pkaiaRo4d7qHrpyrG
	RarDktQ==
X-Received: by 2002:a05:600c:1d0c:b0:436:1bbe:f686 with SMTP id 5b1f17b1804b1-436e2707c59mr26526935e9.21.1736352557847;
        Wed, 08 Jan 2025 08:09:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuW+kXE4dSP1dwStt7dtEmz7DMdPJOlNk4fca0pJWrMp44Izq0k2N2szKXrAfMK8IDoDv+jg==
X-Received: by 2002:a05:600c:1d0c:b0:436:1bbe:f686 with SMTP id 5b1f17b1804b1-436e2707c59mr26526505e9.21.1736352557412;
        Wed, 08 Jan 2025 08:09:17 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2df9f8bsm25473195e9.26.2025.01.08.08.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 08:09:16 -0800 (PST)
Message-ID: <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
Date: Wed, 8 Jan 2025 17:09:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
 shahuang@redhat.com, lpieralisi@kernel.org, aniketa@nvidia.com,
 cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
 jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
 udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
 sebastianene@google.com, coltonlewis@google.com, kevin.tian@intel.com,
 yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 gshan@redhat.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250106165159.GJ5556@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pxt7_dv0tXNL5hikJ4_hZBmFklHjfEtqUs-BVo6sjSY_1736352558
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 06.01.25 17:51, Jason Gunthorpe wrote:
> On Fri, Dec 20, 2024 at 04:42:35PM +0100, David Hildenbrand wrote:
>> On 18.11.24 14:19, ankita@nvidia.com wrote:
>>> From: Ankit Agrawal <ankita@nvidia.com>
>>>
>>> Currently KVM determines if a VMA is pointing at IO memory by checking
>>> pfn_is_map_memory(). However, the MM already gives us a way to tell what
>>> kind of memory it is by inspecting the VMA.
>>
>> Do you primarily care about VM_PFNMAP/VM_MIXEDMAP VMAs, or also other VMA
>> types?
> 
> I think this is exclusively about allowing cachable memory inside a
> VM_PFNMAP VMA (created by VFIO) remain cachable inside the guest VM.

Thanks!

> 
>>> This patch solves the problems where it is possible for the kernel to
>>> have VMAs pointing at cachable memory without causing
>>> pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL
>>> devices. This memory is now properly marked as cachable in KVM.
>>
>> Does this only imply in worse performance, or does this also affect
>> correctness? I suspect performance is the problem, correct?
> 
> Correctness. Things like atomics don't work on non-cachable mappings.

Hah! This needs to be highlighted in the patch description. And maybe 
this even implies Fixes: etc?

> 
>> Maybe one could just reject such cases (if KVM PFN lookup code not
>> already rejects them, which might just be that case IIRC).
> 
> At least VFIO enforces SHARED or it won't create the VMA.
> 
> drivers/vfio/pci/vfio_pci_core.c:       if ((vma->vm_flags & VM_SHARED) == 0)

That makes a lot of sense for VFIO.

> 
> This is pretty normal/essential for drivers..
> 
> Are you suggesting the VMA flags should be inspected more?
> VM_SHARED/PFNMAP before allowing this?


I was wondering if we can safely assume that "device PFNs" can only 
exist in VM_PFNMAP mappings. Then we can avoid all that pfn_valid() / 
pfn_is_map_memory() stuff for "obviously not device" memory.

I tried to protoype, but have to give up for now; the code is too 
complicated to make quick progress :)

-- 
Cheers,

David / dhildenb

