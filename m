Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366391E521
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 00:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741133774; cv=none; b=oW4pUl8Pa8mkQ3g92KRNjmrxdibvUnnpKx7M2aWwD53NWTU5Tu4QZlCaqPphGiPSpprAoff8xxCHWVSRDmtvgw69/ufW1D9tcVT/bAw8Yknvppau/KQVI2PZ0Ipq+VUAyPAuYZT6eS8ALY9HqhlLA5nqntXMzCcNrnfQkbtUFc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741133774; c=relaxed/simple;
	bh=1eNeeZMatMhbyDkf4IzA6vyYEqGA9LjWEzci90EKIKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KYh/U7FlwhjfUcZjUmRdnEEj8HyuOlLtPlrXtY2PHp1Pi6V6ou/bIr+PoEht/Ik01yCth8P8rxQhoRO4iILAV8ab0VMXkjM/RKsa8YEJ+x1Bq24TtCZ8N4B9ETXfMfgj9Y8taYqTQqhAb3o+RYlSaHGU61890/XKixVkbqIyOVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b1TB9YDt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1TB9YDt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741133772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K+nZIdJ+GUg9TiIWa5Z45oEZwDdDHGq5zn5aUSYMnu4=;
	b=b1TB9YDtXw6fCDL0gQgkuZ6cSez8JSsDghJBo9uqn4vAA6Z6Pf8VayPQnoBdw/cQbxPVFX
	QuzT+47tUnyGbmZq9Tx1PaSqO8JwthFsP7HGXB6QbTDJ0KdN0WAlqDnuzVFEvp0xXgapLL
	7ZU2iJPMKbOLxSeAVWAyqEbLwJ1ApZo=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-S1zP-Oc2PnOz20o5c216iw-1; Tue, 04 Mar 2025 19:16:06 -0500
X-MC-Unique: S1zP-Oc2PnOz20o5c216iw-1
X-Mimecast-MFC-AGG-ID: S1zP-Oc2PnOz20o5c216iw_1741133765
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-223d86b4df0so41897805ad.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 16:16:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741133765; x=1741738565;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K+nZIdJ+GUg9TiIWa5Z45oEZwDdDHGq5zn5aUSYMnu4=;
        b=FoPmr54fbrARFqBVMhKOeFYdOA/oScPZDN8WF090+UDX9/1YdwrKPaPw+tWC76OyH3
         cRzCfPsZUH6iA39hVSJCLlJbiUcSc99yj+IbXlnCqa04TL9kJwsz35ujERmnaH7vOLj6
         ck4KGW3GI+gFv93QLpM7Oqybnu9RbJjr9zXY79MwtF853qpcw7IzA/J0CScNUlzhFPqp
         r+5JjC7Yycc1fGw60PtrJ1vjtupKaBES1SBq8nf0SrRyAOBuky2Fw4d23zpEB6e5FVdA
         nPQ87KvsqZpj9MCZG07aGBkTnRrE9g3cGGYDc4N9sqqWvs/8kXfr4pbaEv6dKOBsrkAl
         gD1g==
X-Forwarded-Encrypted: i=1; AJvYcCUOLviA28e2LbhoX/AgCBXheQi4eegqdZktWX7+0z7oZZ65ayGbbD1OBZ+CTOVtVsBoKrL3Vfs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9lEPCPks9OhH+QLkswqx2bn4TA1iOyNrRKxhteWJ1soa8+54i
	AduBsjAwPZ/s5tExqK1rndYiJ7o2JoCOS418+ts7g0K9hdvd2fFsetq7MwaWcz16iGCw6nu0Tm9
	4hKF6K466xxFjihzZEH9Bro6o4Y+JV6CMzL0j5LZV7xx2W3UU5zl9jg==
X-Gm-Gg: ASbGncuua5M24Rr8GJpjBYD/UUie7Uk6mrMKlE+zduv2fH44mWBOBm+MvCrBtMdQtx7
	WJl84AC3+YqHiu5AxsBDBT0kS+jbFK4jWrrm+hpUYBcWVuNbQkCxFVBvfTaCYcWwLOTq+r8zr6j
	HaVtwhLSp+0PQAIaRMyTYleWvjn9kmKFQ4JqTYvg3EBrdTehZpvuKMjRtn5O1vc4rkhsaHeFsGu
	JtE8FomHBJOZde3uCc7Y5lAxhqkvyfmGI6Yt/IArRu9DTdT2GGyjPWShcWIl1YA9zp2mnGHJH9A
	7CqeDu+klwqd9oU=
X-Received: by 2002:a05:6a00:b42:b0:736:4e02:c543 with SMTP id d2e1a72fcca58-73682b73e82mr1248267b3a.9.1741133764820;
        Tue, 04 Mar 2025 16:16:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtbldcyedC0VzElSl5L414yZHuxZ/AzfRFOHxkoXbZKPjFlAxwXPjGCGBZbMPisg2mcwac1Q==
X-Received: by 2002:a05:6a00:b42:b0:736:4e02:c543 with SMTP id d2e1a72fcca58-73682b73e82mr1248225b3a.9.1741133764350;
        Tue, 04 Mar 2025 16:16:04 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7363a0f88bfsm7109144b3a.24.2025.03.04.16.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 16:16:03 -0800 (PST)
Message-ID: <1e1aa766-c358-4a4f-918e-f0044fe499fe@redhat.com>
Date: Wed, 5 Mar 2025 10:15:54 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/45] arm64: RME: Add wrappers for RMI calls
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-6-steven.price@arm.com>
 <8f08b96b-8219-4d51-8f46-bc367bbf2031@redhat.com>
 <59f84354-e890-48c8-ba06-87dda471f364@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <59f84354-e890-48c8-ba06-87dda471f364@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vDv_Fkl2Uslz0nCfdKk2i2nnOndmD5LJHh3--MMgc3s_1741133765
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/4/25 1:05 AM, Steven Price wrote:
> On 03/03/2025 03:42, Gavin Shan wrote:
>> On 2/14/25 2:13 AM, Steven Price wrote:
>>> The wrappers make the call sites easier to read and deal with the
>>> boiler plate of handling the error codes from the RMM.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes from v5:
>>>    * Further improve comments
>>> Changes from v4:
>>>    * Improve comments
>>> Changes from v2:
>>>    * Make output arguments optional.
>>>    * Mask RIPAS value rmi_rtt_read_entry()
>>>    * Drop unused rmi_rtt_get_phys()
>>> ---
>>>    arch/arm64/include/asm/rmi_cmds.h | 508 ++++++++++++++++++++++++++++++
>>>    1 file changed, 508 insertions(+)
>>>    create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>>>
>>
>> With the following nitpicks addressed:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> Thanks, there were a couple of other pages and params_ptr references
> that I've updated to granules and just 'params' too now. With hindsight
> conflating pages and granules in the earlier versions of this series was
> a big mistake ;)
> 

Yeah, that was because the assumption was the page size and granule size are
equal(4KB), but they're still different things. With the intention to support
ARM CCA on host with non-aligned page sizes (16KB/64KB), we have to differentiate
granule/page.

Ideally, the granule is only visible to RMI calls and their helpers. An new memory
allocator seems inevitable so that the allocated pages can be distributed on requests
by various RMI helpers in granule. It means the allocator is the line to separate page
and granule :)

Thanks,
Gavin

> Steve
> 
>>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/
>>> asm/rmi_cmds.h
>>> new file mode 100644
>>> index 000000000000..043b7ff278ee
>>> --- /dev/null
>>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>>> @@ -0,0 +1,508 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * Copyright (C) 2023 ARM Ltd.
>>> + */
>>> +
>>> +#ifndef __ASM_RMI_CMDS_H
>>> +#define __ASM_RMI_CMDS_H
>>> +
>>
>> [...]
>>
>>> +
>>> +/**
>>> + * rmi_rec_aux_count() - Get number of auxiliary granules required
>>> + * @rd: PA of the RD
>>> + * @aux_count: Number of pages written to this pointer
>>                    ^^^^^^^^^^^^^^^
>>                    Number of granules
>>> + *
>>> + * A REC may require extra auxiliary pages to be delegated for the
>>> RMM to
>>                                          ^^^^^
>>                                          granules
>>
>>> + * store metadata (not visible to the normal world) in. This function
>>> provides
>>> + * the number of pages that are required.
>>                      ^^^^^
>>                      granules
>>> + *
>>> + * Return: RMI return code
>>> + */
>>> +static inline int rmi_rec_aux_count(unsigned long rd, unsigned long
>>> *aux_count)
>>> +{
>>> +    struct arm_smccc_res res;
>>> +
>>> +    arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
>>> +
>>> +    if (aux_count)
>>> +        *aux_count = res.a1;
>>> +    return res.a0;
>>> +}
>>> +
>>> +/**
>>> + * rmi_rec_create() - Create a REC
>>> + * @rd: PA of the RD
>>> + * @rec: PA of the target REC
>>> + * @params_ptr: PA of REC parameters
>>> + *
>>> + * Create a REC using the parameters specified in the struct
>>> rec_params pointed
>>> + * to by @params_ptr.
>>> + *
>>> + * Return: RMI return code
>>> + */
>>> +static inline int rmi_rec_create(unsigned long rd, unsigned long rec,
>>> +                 unsigned long params_ptr)
>>> +{
>>> +    struct arm_smccc_res res;
>>> +
>>> +    arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rd, rec, params_ptr, &res);
>>> +
>>> +    return res.a0;
>>> +}
>>> +
>>
>> 'params_ptr' may be renamed to 'params'.
>>
>>
>> [...]
>>> +#endif /* __ASM_RMI_CMDS_H */
>>
>> Thanks,
>> Gavin
>>
> 

