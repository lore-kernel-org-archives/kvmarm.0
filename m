Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDC61CFAD
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 09:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6g/KoDp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697449922;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fj634e+VaD+ebYjjG6WWajLk8f8HNx2dl58LD2RwMjg=;
	b=f6g/KoDp3kYdqBj5z87EQCAXYZF9DyAnGqOCmSU5AYRJpPAosPJ/Hlc0aozHZxuJizmM0s
	+6sjUbCT5ssAt5XcK77sa6HdMXxvfTdswleQn8a8N5fhYl5VnEpuUlfHJ++ztV8ho7huZl
	BkdjRsSnUO4QJrKkIyXcFPOzEMIEDGk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-ROgu0SkuNu-5N58vRl5UKw-1; Mon, 16 Oct 2023 05:51:52 -0400
X-MC-Unique: ROgu0SkuNu-5N58vRl5UKw-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-65af758fa1eso50122206d6.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 02:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697449911; x=1698054711;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fj634e+VaD+ebYjjG6WWajLk8f8HNx2dl58LD2RwMjg=;
        b=ja8366g52MoxfrCbpmzti1kd1OmBPhBs4wLEJajx3t8RMq8pKPlgU3tVLlVa6NrDii
         ZfUvSmai9S+9uvfy4ucSsVwYLHcQsHMvZm94CoA7FU8rVYfb6hqUhNwKg0oXEq8UhXwF
         h0ik1eUdhmy9r3DVI6W5w9CFueRi1WJD4DM8fMutB3NBk7S9R3jp+TgGJMq4KAqsqdfJ
         u27pmlK4qlxN2wjm9auOEb7aSamMwByoa3v5ytMt2Rpa547QVdrsCg1Trs76fLJv8iI/
         8C8nF/yCxy5fWI2h1pGcxCif9ZskQseSP6eSHgfszIq8o/m6/sO/Xvungigjptn8eiBN
         mqKw==
X-Gm-Message-State: AOJu0Ywjprr0fHEFW3ivZnOZ32VSLdRg7XM6k1708x0haXNP4kq7PP/2
	TawYqhxewLxwZWPyOIpQ2ZSvsdLH4KILf2Oucdl7B/sOMfZERbPy7bXwPzRy7nOoU+7xrZ8VmvY
	d0rXEojfI4x9wWblH
X-Received: by 2002:ac8:5916:0:b0:410:90c7:5185 with SMTP id 22-20020ac85916000000b0041090c75185mr42288207qty.54.1697449911579;
        Mon, 16 Oct 2023 02:51:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5RLADwQA8GUJ6p2b4QyBiClPbS3YW1wz+PHSV7G5Jk5lya6TvrOhvPDh7G0jnEos8F37WSQ==
X-Received: by 2002:ac8:5916:0:b0:410:90c7:5185 with SMTP id 22-20020ac85916000000b0041090c75185mr42288195qty.54.1697449911350;
        Mon, 16 Oct 2023 02:51:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v8-20020a05622a188800b00418142e802bsm2904361qtc.6.2023.10.16.02.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 02:51:50 -0700 (PDT)
Message-ID: <47f2d130-c077-d3fe-e0ea-6bb7c86190a0@redhat.com>
Date: Mon, 16 Oct 2023 11:51:46 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 3/3] arm64/kvm: Fine grain _EL2 system registers list
 that affect nested virtualization
To: Marc Zyngier <maz@kernel.org>
Cc: Miguel Luis <miguel.luis@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20231011180103.91774-1-miguel.luis@oracle.com>
 <20231011180103.91774-4-miguel.luis@oracle.com>
 <7df53e6b-9141-de85-b7a3-b9eb092ef7b4@redhat.com>
 <e6f3002c10848e911c4bfee3a1d472aa@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <e6f3002c10848e911c4bfee3a1d472aa@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Marc,

On 10/12/23 22:36, Marc Zyngier wrote:
> On 2023-10-12 16:22, Eric Auger wrote:
>> Hi Miguel,
>>
>> On 10/11/23 20:01, Miguel Luis wrote:
>>> Implement a fine grained approach in the _EL2 sysreg ranges.
>>>
>>> Fixes: d0fc0a2519a6 ("KVM: arm64: nv: Add trap forwarding for HCR_EL2")
>>> Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
>>> ---
>>>  arch/arm64/kvm/emulate-nested.c | 88 ++++++++++++++++++++++++++++++---
>>>  1 file changed, 82 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/emulate-nested.c
>>> b/arch/arm64/kvm/emulate-nested.c
>>> index 9ced1bf0c2b7..3af49e130ee6 100644
>>> --- a/arch/arm64/kvm/emulate-nested.c
>>> +++ b/arch/arm64/kvm/emulate-nested.c
>>> @@ -648,15 +648,91 @@ static const struct encoding_to_trap_config
>>> encoding_to_cgt[] __initconst = {
>>>      SR_TRAP(SYS_APGAKEYLO_EL1,    CGT_HCR_APK),
>>>      SR_TRAP(SYS_APGAKEYHI_EL1,    CGT_HCR_APK),
>>>      /* All _EL2 registers */
>>> -    SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
>>> -              sys_reg(3, 4, 3, 15, 7), CGT_HCR_NV),
>>> +    SR_TRAP(SYS_VPIDR_EL2,        CGT_HCR_NV),
>> I think you miss DBGVCR32_EL2
>
> I don't think this register should be part of this list. We don't
> support AArch32 with NV, and the spec says that DBGVCR32_EL2 UNDEFs
> when EL1 doesn't support AArch32.
>
> So the change that needs to happen is to inject an UNDEF when trapping
> a DBGVCR32_EL2and not forward the trap to the guest.

OK this makes sense

Thanks

Eric
>
> Thanks,
>
>         M.

