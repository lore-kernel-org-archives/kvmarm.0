Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37FA12DD88
	for <kvmarm@lists.linux.dev>; Sat, 12 Oct 2024 05:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728710543; cv=none; b=mhCzr/khOx6R4T4IKlnm+YRt0Fg71D0nqZbOUWluTMIDslK+94kYETDdb9W1jBXLnKMk+lDna21GWoHbWAFkYsk8ouyPFJlwvMcO5MlEhBVn14KnXnjkYkbVNjzqpgHB6euA0LEmb9RRWLW8PS7fR7kU0nli+omlEhnVrQvjOVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728710543; c=relaxed/simple;
	bh=KP48yn2zu/bvXJGE9dWPkWLMt3oDQ+5HzzzKc0IzQwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mYf/QEBPuMB0n3JOTil0WeM2yQP+3vCeiY08UNZ1vDGCmkqfpwRkCyqRbQHI/o4sZT+e1OGMD9FSyeQ6LrqnfgVbHaPUNWM2PLe/zXlGg99Z3rZxFPxXjAP5oHtsjOul71drs2pVFaPbBsWXkS+zqWXd6Dcq+J7dAlLKvuVIc9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dm5/+cMV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dm5/+cMV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728710540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hvDr0hBqceMPoqKr59VTJA2PMmkK0w6bfmvafMG1XxI=;
	b=Dm5/+cMVNBzbfRqv+ROUMIs/ZQgIP7hqP8GzPLpnUyePti5UfztUwUwpDN3pLUrP6q/mKC
	qUfXxC9GUKgWby7TwaBQwejXEzhlA602YpHv1nbzOdKGAXd4c1gKtwVSwsOhmghDKiywl/
	68po9XIonYtIKxu7vL+Ig6MJECq6PQM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-M3JWDIrwORi54FhrRsgW9g-1; Sat, 12 Oct 2024 01:22:17 -0400
X-MC-Unique: M3JWDIrwORi54FhrRsgW9g-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-20c8d7f9128so31782975ad.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 22:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728710536; x=1729315336;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hvDr0hBqceMPoqKr59VTJA2PMmkK0w6bfmvafMG1XxI=;
        b=L4H5SUjY3O3lJj4adJK4xtb/+TziXLOfAijoJR9cCThZAslCi4B92Bvav/hlRi17Nd
         zsk4nVfT/7q7oMKxmahwg8exfOWmlmUp86CZGE/C3TpZZhBLCnN485lEhQck5stqgWLR
         dk3YU3cY0xjrdwYScbGTAeoNBMH4eeLcmGrfdiOkFALWLvK3DwThdzIjX3wXOjxiiDws
         D4fTEGvmx2OlA73JYNKjQ2K1QOL1yJ/R08p3w6h3mJ4Hrw05+RKG/fuWaYZfye3lN3ty
         mGuBSZQ9Gbd7X0rJIIr0/AOg0vlT8J3xtoipq98SKIJgmiKwcBlKZUyWCQohX0q5jug4
         WGIA==
X-Forwarded-Encrypted: i=1; AJvYcCXMt7WYGo4OQ2DNgQiAr7YWNLAcrcIg0IIquLygSX35yuBEpXdylbvGcc29Um5d/HALBmV0fLo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzz4KUM4Fn3yITegndKZrpKqIFE9vnew/D3SwnrhGSdWcAPV1At
	SztBxFzY2HDXiaiGy3IUchZaY3YeONKdHUUTYkHcAYF4FOAKPrF0x1Pi5GnPqtZscnM6PWTyd9M
	m0381t7DBI3SGdmVpJl2Z7SL3BS+Lzf+v3D+ggBNX4B1bJZJLQLsBVg==
X-Received: by 2002:a17:903:2292:b0:20c:be0e:d47e with SMTP id d9443c01a7336-20cbe0ed77fmr27330295ad.56.1728710536252;
        Fri, 11 Oct 2024 22:22:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPdfPL4sLDuZbuEZ8hOCaoZXNRre8SGr7tfbn9VtHIuESumtQnMGZco/QwYJ9wvIb8IjS+5g==
X-Received: by 2002:a17:903:2292:b0:20c:be0e:d47e with SMTP id d9443c01a7336-20cbe0ed77fmr27329915ad.56.1728710535801;
        Fri, 11 Oct 2024 22:22:15 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c33fdf9sm31443385ad.260.2024.10.11.22.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 22:22:15 -0700 (PDT)
Message-ID: <cfbd0cbb-bfff-41fc-b729-c8c49ce28215@redhat.com>
Date: Sat, 12 Oct 2024 15:22:06 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/11] arm64: rsi: Map unprotected MMIO as decrypted
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-6-steven.price@arm.com>
 <e21481a9-3e36-4a5d-9428-0f5ef8083676@redhat.com> <Zwkl51C3DFEQQ0Jb@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <Zwkl51C3DFEQQ0Jb@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/24 11:19 PM, Catalin Marinas wrote:
> On Tue, Oct 08, 2024 at 10:31:06AM +1000, Gavin Shan wrote:
>> On 10/5/24 12:43 AM, Steven Price wrote:
>>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>>> index d7bba4cee627..f1add76f89ce 100644
>>> --- a/arch/arm64/kernel/rsi.c
>>> +++ b/arch/arm64/kernel/rsi.c
>>> @@ -6,6 +6,8 @@
>>>    #include <linux/jump_label.h>
>>>    #include <linux/memblock.h>
>>>    #include <linux/psci.h>
>>> +
>>> +#include <asm/io.h>
>>>    #include <asm/rsi.h>
>>>    struct realm_config config;
>>> @@ -92,6 +94,16 @@ bool arm64_is_protected_mmio(phys_addr_t base, size_t size)
>>>    }
>>>    EXPORT_SYMBOL(arm64_is_protected_mmio);
>>> +static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
>>> +{
>>> +	if (arm64_is_protected_mmio(phys, size))
>>> +		*prot = pgprot_encrypted(*prot);
>>> +	else
>>> +		*prot = pgprot_decrypted(*prot);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>
>> We probably need arm64_is_mmio_private() here, meaning arm64_is_protected_mmio() isn't
>> sufficient to avoid invoking SMCCC call SMC_RSI_IPA_STATE_GET in a regular guest where
>> realm capability isn't present.
> 
> I think we get away with this since the hook won't be registered in a
> normal guest (done from arm64_rsi_init()). So the additional check in
> arm64_is_mmio_private() is unnecessary.
> 

Indeed. I missed the point that the hook won't be registered for a normal
guest. So we're good and safe.

Thanks,
Gavin

