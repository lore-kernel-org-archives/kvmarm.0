Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F87C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 07:16:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0E4E61165
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 07:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C0E4E61165
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1424B0ED;
	Wed,  8 Sep 2021 03:16:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GWAObcTq1XMz; Wed,  8 Sep 2021 03:16:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DBAA4B0BD;
	Wed,  8 Sep 2021 03:16:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC7844B08E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 03:16:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lBY-CyiH4ttR for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 03:16:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACF1F4B08B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 03:16:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631085392;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nbJO5IEe+xQ4o2hyduhVSdtU4KYDyRNeaf2n3UHUb4k=;
 b=WJE6S6dv5sCQoh/0Sd0kbD9Vd3wODjbSMpUBup5PE5aE4RUxkluK9ecSkxf1m6T1h+yJwm
 FP1h4vhSSqxHSbkWBWuIfdVyVvwPLhJ7/F9wlZdzgz/7boRSeOh2NuwG3+mnDqZkJqkpsG
 bN4BU89/Mg3jHQAQi8bRXnOy6/zuJz4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-0T3Y5J-2O9e2nDgyqFtp-Q-1; Wed, 08 Sep 2021 03:16:31 -0400
X-MC-Unique: 0T3Y5J-2O9e2nDgyqFtp-Q-1
Received: by mail-wm1-f69.google.com with SMTP id
 n17-20020a7bc5d1000000b002f8ca8bacdeso508895wmk.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 00:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=nbJO5IEe+xQ4o2hyduhVSdtU4KYDyRNeaf2n3UHUb4k=;
 b=XFFS9tfN3GKdMpHGYMJQlffGvX9a4KGV/amo1wHLnuoRP5hmRAQXjRbwzw88fnnUjv
 Ewmg03sp7HDrF0Q07RSjhcn2eP2XTHWd/rbzw5siWp5H/P2kuaMT+8TDcbNoOCSeeltH
 mTwdgWVww9Kd2b1FaHeTy5fQHOeaRKfXfIYgkQRu9KPzSQ7vdwv690eK/jp2dHeKE3JM
 +3jEcfwKgdv6Bow9o+cHZaVOOaFE5IH95B/ObqFeIGu2/Atr9NAXzqSbrFRDn65b8cDx
 vcT/pfXN0fWwgOWUVFnwTsCmkm/rG/tMlU68YEJwcRB/tuKvYPHK90nqcHeP4O8XCVGV
 ac6A==
X-Gm-Message-State: AOAM533RVHH8lX1qDCnkHKrfvKNjny5h/S0D2GelkzVUYfqmlUGWylfy
 eZfSsTZhBkioboPeXjLHZ72f+E+orzu6ICEkNXx77kawgDKz4X3m9TjLGHCPSgeOPyQrgzxw+IJ
 9jOKbAOaHf7yOXKsCIOIeg8S4
X-Received: by 2002:adf:fb91:: with SMTP id a17mr2181595wrr.376.1631085390000; 
 Wed, 08 Sep 2021 00:16:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPKtJXLjpkkYJc6hfE/GBP0ZcfENgsVgOUyZszAz9xpVvta2M+XQswK/zCwzROecZ4lKdbxg==
X-Received: by 2002:adf:fb91:: with SMTP id a17mr2181580wrr.376.1631085389806; 
 Wed, 08 Sep 2021 00:16:29 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id c3sm1259790wrd.34.2021.09.08.00.16.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 08 Sep 2021 00:16:29 -0700 (PDT)
Subject: Re: [PATCH 2/3] hw/arm/virt: Honor highmem setting when computing
 highest_gpa
To: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <maz@kernel.org>
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-3-maz@kernel.org>
 <CAFEAcA9=SJd52ZEQb0gyW+2q9md4KMnLy8YsME-Mkd-AbvV41Q@mail.gmail.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <8a927165-e45d-07c9-a6d6-b32303195523@redhat.com>
Date: Wed, 8 Sep 2021 09:16:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9=SJd52ZEQb0gyW+2q9md4KMnLy8YsME-Mkd-AbvV41Q@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Android Kernel Team <kernel-team@android.com>,
 QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

Hi
On 9/7/21 2:58 PM, Peter Maydell wrote:
> On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
>> Even when the VM is configured with highmem=off, the highest_gpa
>> field includes devices that are above the 4GiB limit, which is
>> what highmem=off is supposed to enforce. This leads to failures
>> in virt_kvm_type() on systems that have a crippled IPA range,
>> as the reported IPA space is larger than what it should be.
>>
>> Instead, honor the user-specified limit to only use the devices
>> at the lowest end of the spectrum.
>>
>> Note that this doesn't affect memory, which is still allowed to
>> go beyond 4GiB with highmem=on configurations.
>>
>> Cc: Andrew Jones <drjones@redhat.com>
>> Cc: Eric Auger <eric.auger@redhat.com>
>> Cc: Peter Maydell <peter.maydell@linaro.org>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  hw/arm/virt.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index 81eda46b0b..bc189e30b8 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -1598,7 +1598,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>>  static void virt_set_memmap(VirtMachineState *vms)
>>  {
>>      MachineState *ms = MACHINE(vms);
>> -    hwaddr base, device_memory_base, device_memory_size;
>> +    hwaddr base, device_memory_base, device_memory_size, ceiling;
>>      int i;
>>
>>      vms->memmap = extended_memmap;
>> @@ -1625,7 +1625,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>>      device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>>
>>      /* Base address of the high IO region */
>> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
>> +    ceiling = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
>>      if (base < device_memory_base) {
>>          error_report("maxmem/slots too huge");
>>          exit(EXIT_FAILURE);
>> @@ -1642,7 +1642,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>>          vms->memmap[i].size = size;
>>          base += size;
>>      }
>> -    vms->highest_gpa = base - 1;
>> +    if (vms->highmem) {
>> +           /* If we have highmem, move the IPA limit to the top */
>> +           ceiling = base;
>> +    }
>> +    vms->highest_gpa = ceiling - 1;
> This doesn't look right to me. If highmem is false and the
> high IO region would be above the 4GB mark then we should not
> create the high IO region at all, surely? This code looks like
> it goes ahead and puts the high IO region above 4GB and then
> lies in the highest_gpa value about what the highest used GPA is.
>
> -- PMM
>
Doesn't the problem come from "if maxram_size is < 255GiB we keep the
legacy memory map" and set base = vms->memmap[VIRT_MEM].base +
LEGACY_RAMLIMIT_BYTES; leading to IO regions allocated above?
Instead shouldn't we condition this to highmem=on only then?

But by the way do we need to added extended_memmap IO regions at all if
highmem=off?
I am not wrong the VIRT_HIGH_PCIE_ECAM and VIRT_HIGH_PCIE_MMIO only are
used if highmem=on. In create_pcie(), base_mmio_high/size_mmio_high are
used if vms->highmem and we have ecam_id =
VIRT_ECAM_ID(vms->highmem_ecam); with vms->highmem_ecam &= vms->highmem
&& (!firmware_loaded || aarch64);

So if I do not miss anything maybe we could skip the allocation of the
extended_memmap IO regions if highmem=off?

And doesn't it look reasonable to limit the number of vcpus if highmem=off?

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
