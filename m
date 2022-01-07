Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EBDC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 17:15:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2DE44B2A5;
	Fri,  7 Jan 2022 12:15:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dvTdNQkc3Bwo; Fri,  7 Jan 2022 12:15:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 987D74B29B;
	Fri,  7 Jan 2022 12:15:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CA5C4B29B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 12:15:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bWHKvzxCz-NE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 12:15:27 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F04984B291
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 12:15:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641575726;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4vsOOMP2jOzKaAjizeC5l39pTNWtPs1ir1jcXzS/usA=;
 b=T4m3vGiYEN1EIJjmxg/ptifLBwSdoHUpPBMP72OpCNWMqXcRLk97YMyRyUZv9D8ECCINQe
 H2MEvsTJzMJa52PyYXsIENFZGHX/M02q0E1LOZUTW0T0Ma3idV01Re39LgqU7EYnBdkmLw
 Tp7jQllIdWpcFClr2xkNb10yXzt33g0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-vLgH0-NLPLe6I3iAG3HrWA-1; Fri, 07 Jan 2022 12:15:22 -0500
X-MC-Unique: vLgH0-NLPLe6I3iAG3HrWA-1
Received: by mail-wm1-f69.google.com with SMTP id
 g4-20020a1c9d04000000b00346e0d6877fso1124678wme.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Jan 2022 09:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=4vsOOMP2jOzKaAjizeC5l39pTNWtPs1ir1jcXzS/usA=;
 b=ER1Km08TbBOog7pODY+H3GaRUncv+yd2l5Zz5dQNAxGZ8l0iMkTdwMwiG5PBaTZJDG
 032G35oHg/aewl9ah0NP0n8iJ14CuJSzqEGsyW22EbVgdk0q5cD1n/Cc3qbl+CkLoR7N
 TpxuvHSiczx70xFRu3lt8v01n7WtN+hGi2fdf9UG+W7B6MCZ/ijSX8qy1E+rIXbiWKJl
 p1BmfXskfCKG7llm6sQeKTqq4Ob4MJ8CgvkTYTGVOI6Po/zVqJ73PoKkIPWEC7Sh6atV
 tdsWgHC/l6dRI45PML4hKBc5gpII8qymwsOqmGt9+o9iLS+jSVHsbXyXsTZkwpYR6SOr
 RFCQ==
X-Gm-Message-State: AOAM530JbgiImnW0nW6x0sq7R8kpiEXpu0U2aNs+NItA95DtJ3Gk7C9p
 zgQO2PXhNKMKn+pPjeLwKc5I1gC77XJgZ8o7kekG+YjDAX30S8Gl6LE3wHp5ebinmTKL2o7RdkV
 TZHOf5em0Wuqjy3NwqDt10jBO
X-Received: by 2002:a5d:6483:: with SMTP id o3mr58268904wri.101.1641575721177; 
 Fri, 07 Jan 2022 09:15:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8r1YuVw97cm+4Ci+idvC+xsdVFCO7vo+Z/vxPfFrHtrqAw3arjPJQbNKCupw6ctQsN426gQ==
X-Received: by 2002:a5d:6483:: with SMTP id o3mr58268875wri.101.1641575720919; 
 Fri, 07 Jan 2022 09:15:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id y15sm1351601wmi.40.2022.01.07.09.15.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 07 Jan 2022 09:15:20 -0800 (PST)
Subject: Re: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
To: Marc Zyngier <maz@kernel.org>
References: <20211227211642.994461-1-maz@kernel.org>
 <20211227211642.994461-4-maz@kernel.org>
 <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
 <871r1kzhbp.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <d330de15-b452-1f9c-14fa-906b88a8b4c4@redhat.com>
Date: Fri, 7 Jan 2022 18:15:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <871r1kzhbp.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 1/6/22 10:26 PM, Marc Zyngier wrote:
> On Wed, 05 Jan 2022 09:22:39 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 12/27/21 10:16 PM, Marc Zyngier wrote:
>>> Even when the VM is configured with highmem=off, the highest_gpa
>>> field includes devices that are above the 4GiB limit.
>>> Similarily, nothing seem to check that the memory is within
>>> the limit set by the highmem=off option.
>>>
>>> This leads to failures in virt_kvm_type() on systems that have
>>> a crippled IPA range, as the reported IPA space is larger than
>>> what it should be.
>>>
>>> Instead, honor the user-specified limit to only use the devices
>>> at the lowest end of the spectrum, and fail if we have memory
>>> crossing the 4GiB limit.
>>>
>>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  hw/arm/virt.c | 9 ++++++++-
>>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>>> index 8b600d82c1..84dd3b36fb 100644
>>> --- a/hw/arm/virt.c
>>> +++ b/hw/arm/virt.c
>>> @@ -1678,6 +1678,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>>>          exit(EXIT_FAILURE);
>>>      }
>>>  
>>> +    if (!vms->highmem &&
>>> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
>>> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
>>> +        exit(EXIT_FAILURE);
>> The memory is composed of initial memory and device memory.
>> device memory is put after the initial memory but has a 1GB alignment
>> On top of that you have 1G page alignment per device memory slot
>>
>> so potentially the highest mem address is larger than
>> vms->memmap[VIRT_MEM].base + ms->maxram_size.
>> I would rather do the check on device_memory_base + device_memory_size
> Yup, that's a good point.
>
> There is also a corner case in one of the later patches where I check
> this limit against the PA using the rounded-up device_memory_size.
> This could result in returning an error if the last memory slot would
> still fit in the PA space, but the rounded-up quantity wouldn't. I
> don't think it matters much, but I'll fix it anyway.
>
>>> +    }
>>>      /*
>>>       * We compute the base of the high IO region depending on the
>>>       * amount of initial and device memory. The device memory start/size
>>> @@ -1707,7 +1712,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>>>          vms->memmap[i].size = size;
>>>          base += size;
>>>      }
>>> -    vms->highest_gpa = base - 1;
>>> +    vms->highest_gpa = (vms->highmem ?
>>> +                        base :
>>> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
>> As per the previous comment this looks wrong to me if !highmem.
> Agreed.
>
>> If !highmem, if RAM requirements are low we still could get benefit from
>> REDIST2 and HIGH ECAM which could fit within the 4GB limit. But maybe we
>> simply don't care?
> I don't see how. These devices live at a minimum of 256GB, which
> contradicts the very meaning of !highmem being a 4GB limit.
Yes I corrected the above statement afterwards, sorry for the noise.
>
>> If we don't, why don't we simply skip the extended_memmap overlay as
>> suggested in v2? I did not get your reply sorry.
> Because although this makes sense if you only care about a 32bit
> limit, we eventually want to check against an arbitrary PA limit and
> enable the individual devices that do fit in that space.

In my understanding that is what virt_kvm_type() was supposed to do by
testing the result of kvm_arm_get_max_vm_ipa_size and requested_pa_size
(which accounted the high regions) and exiting if they were
incompatible. But I must miss something.
>
> In order to do that, we need to compute the base addresses for these
> extra devices. Also, computing 3 base addresses isn't going to be
> massively expensive.
>
> Thanks,
>
> 	M.
>
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
