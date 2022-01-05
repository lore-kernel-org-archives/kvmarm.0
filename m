Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A5BC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 09:37:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DBBA4B126;
	Wed,  5 Jan 2022 04:37:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gCqQziMCg9ku; Wed,  5 Jan 2022 04:36:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67AE14B152;
	Wed,  5 Jan 2022 04:36:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 327114B126
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 04:36:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wZpmSF2MUk86 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 04:36:57 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F016B4B10C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 04:36:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641375416;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4WVzA9BJExJuk1ssdVBduOeQo2g6GGK9eFCCncTyilM=;
 b=OgmfTjVHr2zADXmZbM4i8Lldh5wHLpkGlojxl660F5nWXlOS4ZNZNwR+p9fgduEj3DnS2h
 5quV19noHrxC7lHRl7ybQ5kppQ7zQHJWw+NrVpqjAfJdaEjb2zG3r5Ofj/IswD7LdtPjd1
 g5NdVY9j1t+1IibeBto3mxj0a9jbPao=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-vaThFY_eNyCngSnQuVQj1g-1; Wed, 05 Jan 2022 04:36:55 -0500
X-MC-Unique: vaThFY_eNyCngSnQuVQj1g-1
Received: by mail-wm1-f69.google.com with SMTP id
 c5-20020a1c3505000000b00345c92c27c6so1416193wma.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 01:36:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:from:to:cc:reply-to:references
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=4WVzA9BJExJuk1ssdVBduOeQo2g6GGK9eFCCncTyilM=;
 b=igXXOZ6eIbEbfac0kQfTSUxxCpdfrOMQdMXg8KrrQPMd7ycu+UpwQyPkrvz86OKxZR
 l0UKVi+Sd0c0uDGO74OaYZrvsRt8Tc/DH9NUTg5F66OiYNxZAtMhr31pAQ6LjmyFGKXx
 NQehSEAOpB/XmRY8Ud4W/K2O5FI/5IDaxQ7MEBNZya4JPoDQxsVYLavRpAJcsaIYfbMk
 yKTMRU+9U+E7KaLJBHzKqpMTSQtnocWyqx43CamW+FPsuxHM48PuC/f1O+uWwZek59cp
 LYPHjQv72Cs7lH6Jg4asy1kujxoxblBf2gSkOEPklegQImfw9VTfHmyKqNds6ruJoJBb
 d1sg==
X-Gm-Message-State: AOAM532Cctgo88dzaNqbbpJ/s+je8orGQeO/h+y3s5HZdMKwPBpR/g37
 mhksfH/epm3cVal57pNUleyXYjCNzVlkK0yWYnlQveRowZ4RjLvs4Ms/ggcHJ/g+IBHiu4MCDOk
 +/xA6GO5FJkwUHJ38zu7Nek4H
X-Received: by 2002:a05:600c:1d07:: with SMTP id
 l7mr2134921wms.12.1641375414226; 
 Wed, 05 Jan 2022 01:36:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+iYJbw7dL4mNA5vHV3pQPLdyhZKPXbHb1/JrvElCtt4s3NbE2JDK7q/xQopwj3NdJaMx++w==
X-Received: by 2002:a05:600c:1d07:: with SMTP id
 l7mr2134906wms.12.1641375413966; 
 Wed, 05 Jan 2022 01:36:53 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id n1sm43208190wri.46.2022.01.05.01.36.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 05 Jan 2022 01:36:53 -0800 (PST)
Subject: Re: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
From: Eric Auger <eric.auger@redhat.com>
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20211227211642.994461-1-maz@kernel.org>
 <20211227211642.994461-4-maz@kernel.org>
 <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
Message-ID: <70643d20-b954-dcc4-0dee-6457244b64e0@redhat.com>
Date: Wed, 5 Jan 2022 10:36:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On 1/5/22 10:22 AM, Eric Auger wrote:
> Hi Marc,
> 
> On 12/27/21 10:16 PM, Marc Zyngier wrote:
>> Even when the VM is configured with highmem=off, the highest_gpa
>> field includes devices that are above the 4GiB limit.
>> Similarily, nothing seem to check that the memory is within
>> the limit set by the highmem=off option.
>>
>> This leads to failures in virt_kvm_type() on systems that have
>> a crippled IPA range, as the reported IPA space is larger than
>> what it should be.
>>
>> Instead, honor the user-specified limit to only use the devices
>> at the lowest end of the spectrum, and fail if we have memory
>> crossing the 4GiB limit.
>>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  hw/arm/virt.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index 8b600d82c1..84dd3b36fb 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -1678,6 +1678,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>>          exit(EXIT_FAILURE);
>>      }
>>  
>> +    if (!vms->highmem &&
>> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
>> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
>> +        exit(EXIT_FAILURE);
> 
> The memory is composed of initial memory and device memory.
> device memory is put after the initial memory but has a 1GB alignment
> On top of that you have 1G page alignment per device memory slot
> 
> so potentially the highest mem address is larger than
> vms->memmap[VIRT_MEM].base + ms->maxram_size.
> I would rather do the check on device_memory_base + device_memory_size
>> +    }
>>      /*
>>       * We compute the base of the high IO region depending on the
>>       * amount of initial and device memory. The device memory start/size
>> @@ -1707,7 +1712,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>>          vms->memmap[i].size = size;
>>          base += size;
>>      }
>> -    vms->highest_gpa = base - 1;
>> +    vms->highest_gpa = (vms->highmem ?
>> +                        base :
>> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
> As per the previous comment this looks wrong to me if !highmem.
> 
> If !highmem, if RAM requirements are low we still could get benefit from
> REDIST2 and HIGH ECAM which could fit within the 4GB limit. But maybe we
the above assertion is wrong, sorry, as we kept the legacy mem map in
that situation (HIGH regions always put above 256 GB). So anyway we can
skip the extended memmap if !highmem.

Eric
> simply don't care? If we don't, why don't we simply skip the
> extended_memmap overlay as suggested in v2? I did not get your reply sorry.
> 
> Thanks
> 
> Eric
>>      if (device_memory_size > 0) {
>>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>>          ms->device_memory->base = device_memory_base;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
