Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E221AC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 09:41:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 485F649E2A;
	Wed,  5 Jan 2022 04:41:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yu-iGjT3YCAR; Wed,  5 Jan 2022 04:41:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F2F249E29;
	Wed,  5 Jan 2022 04:41:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0844149E29
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 04:41:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 57bLD6oC96FB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 04:41:23 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC3A749B0A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 04:41:23 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641375683;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XoueNQR4kEqT+Matt0jgIO5+7tZ5WzGFoeukEV1ezTI=;
 b=Y1ArslOA0OPBToB7anv0Bto1ZAJEp5qov5rWR2TkYUb/nayRdN+gsrDl09Gim6Y0NPoEEE
 xv9kIzU3KurWECSAMDpYutvIrTTtpzpbYnNYAAES2jt7eZ0DSh5b19tNXt+uM1Qgt8f+p/
 XWRGCLNFfMLi2pxqKcFY6gZeaT+d3KU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-sZFEya8dNfKUyA9_8EgL5g-1; Wed, 05 Jan 2022 04:41:22 -0500
X-MC-Unique: sZFEya8dNfKUyA9_8EgL5g-1
Received: by mail-wm1-f72.google.com with SMTP id
 r10-20020a1c440a000000b003456b2594e0so10290193wma.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 01:41:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=XoueNQR4kEqT+Matt0jgIO5+7tZ5WzGFoeukEV1ezTI=;
 b=VDSgUaZAqkn1o5Yg3q5sa3lz3q60EV8A/iiAacasMA2XeEoDWyicDc5DFdYaKcEiMO
 uRHbV7g7xvPESWnmJepMauhzQu0Da66N9T3mcH3N7pJ/utN9iy4OwyDFQg1YCplzq35u
 Uk421hIOn0ibOGT6RFOPkCv09L7GUaVUD1NXvED2ebJGxScAAgs4yEOKvYEH08cMs2pR
 U+ro5OCTXC8/apT4zL7NOKutEMhNQgt0uqmM2549+Zg8hgBHPkaXQPn2ldsPAe5PmIyg
 6dimx/mgfnT8e/6M6mvxxWy2HQMllFlnrogSN/gWxG8+MnBeT6YDlGpWlDnmWX/xhkRW
 BbRQ==
X-Gm-Message-State: AOAM530yr4M1s74J05y/rBXFx5D+AVLZiEkIYQkwlU/b2TM6EfJHqsDp
 FBUU/IMze2XP5+BGce6q2YpiVwja+v37cr1VcQuMAligKt3hNrrKhETp04V7z69eNqKYGVNFOre
 CcxwqU8IX7BgX1xw6ZILdF2nu
X-Received: by 2002:adf:ea0d:: with SMTP id q13mr44299142wrm.597.1641375681233; 
 Wed, 05 Jan 2022 01:41:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8VwkzaUkiWk9Ver7jbdWPviFeEGKyfmS9ZKn/BPTA0eFyTMoTynKWTrju9cdQaTpcN6b/EA==
X-Received: by 2002:adf:ea0d:: with SMTP id q13mr44299120wrm.597.1641375680951; 
 Wed, 05 Jan 2022 01:41:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id 1sm34185991wrb.13.2022.01.05.01.41.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 05 Jan 2022 01:41:20 -0800 (PST)
Subject: Re: [PATCH v2 1/5] hw/arm/virt: Key enablement of highmem PCIe on
 highmem_ecam
To: Marc Zyngier <maz@kernel.org>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-2-maz@kernel.org>
 <dbe883ca-880e-7f2b-1de7-4b2d3361545d@redhat.com>
 <87pmpiyrfw.wl-maz@kernel.org>
 <b9031d40-897e-b8c5-4240-fc2936dcbcb9@redhat.com>
 <877dbfywpj.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <cb9f6c39-40f8-eea7-73bf-13df1e5dae9d@redhat.com>
Date: Wed, 5 Jan 2022 10:41:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <877dbfywpj.wl-maz@kernel.org>
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

On 1/4/22 11:15 PM, Marc Zyngier wrote:
> Hi Eric,
>
> On Tue, 04 Jan 2022 15:31:33 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 12/27/21 4:53 PM, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> Picking this up again after a stupidly long time...
>>>
>>> On Mon, 04 Oct 2021 13:00:21 +0100,
>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>> Hi Marc,
>>>>
>>>> On 10/3/21 6:46 PM, Marc Zyngier wrote:
>>>>> Currently, the highmem PCIe region is oddly keyed on the highmem
>>>>> attribute instead of highmem_ecam. Move the enablement of this PCIe
>>>>> region over to highmem_ecam.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>>  hw/arm/virt-acpi-build.c | 10 ++++------
>>>>>  hw/arm/virt.c            |  4 ++--
>>>>>  2 files changed, 6 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
>>>>> index 037cc1fd82..d7bef0e627 100644
>>>>> --- a/hw/arm/virt-acpi-build.c
>>>>> +++ b/hw/arm/virt-acpi-build.c
>>>>> @@ -157,10 +157,9 @@ static void acpi_dsdt_add_virtio(Aml *scope,
>>>>>  }
>>>>>  
>>>>>  static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>>>>> -                              uint32_t irq, bool use_highmem, bool highmem_ecam,
>>>>> -                              VirtMachineState *vms)
>>>>> +                              uint32_t irq, VirtMachineState *vms)
>>>>>  {
>>>>> -    int ecam_id = VIRT_ECAM_ID(highmem_ecam);
>>>>> +    int ecam_id = VIRT_ECAM_ID(vms->highmem_ecam);
>>>>>      struct GPEXConfig cfg = {
>>>>>          .mmio32 = memmap[VIRT_PCIE_MMIO],
>>>>>          .pio    = memmap[VIRT_PCIE_PIO],
>>>>> @@ -169,7 +168,7 @@ static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>>>>>          .bus    = vms->bus,
>>>>>      };
>>>>>  
>>>>> -    if (use_highmem) {
>>>>> +    if (vms->highmem_ecam) {
>>>> highmem_ecam is more restrictive than use_highmem:
>>>> vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);
>>>>
>>>> If I remember correctly there was a problem using highmem ECAM with 32b
>>>> AAVMF FW.
>>>>
>>>> However 5125f9cd2532 ("hw/arm/virt: Add high MMIO PCI region, 512G in
>>>> size") introduced high MMIO PCI region without this constraint.
>>> Then I really don't understand the point of this highmem_ecam. We only
>>> register the highmem version if highmem_ecam is set (see the use of
>>> VIRT_ECAM_ID() to pick the right ECAM window).
>> but aren't we talking about different regions? On one hand the [high]
>> MMIO region (512GB wide) and the [high] ECAM region (256MB large).
>> To me you can enable either independently. High MMIO region is used by
>> some devices likes ivshmem/video cards while high ECAM was introduced to
>> extend the number of supported buses: 601d626d148a (hw/arm/virt: Add a
>> new 256MB ECAM region).
>>
>> with the above change the high MMIO region won't be set with 32b
>> FW+kernel and LPAE whereas it is currently.
>>
>> high ECAM was not supported by 32b FW, hence the highmem_ecam.
>>
>> but maybe I miss your point?
> There are two issues.
>
> First, I have been conflating the ECAM and MMIO ranges, and you only
> made me realise that they were supposed to be independent.  I still
> think the keying on highmem is wrong, but the main issue is that the
> highmem* flags don't quite describe the shape of the platform.
>
> All these booleans indicate is whether the feature they describe (the
> high MMIO range, the high ECAM range, and in one of my patches the
> high RD range) are *allowed* to live above 4GB, but do not express
> whether then are actually usable (i.e. fit in the PA range).
>
> Maybe we need to be more thorough in the way we describe the extended
> region in the VirtMachineState structure:
>
> - highmem: overall control for anything that *can* live above 4GB
> - highmem_ecam: Has a PCIe ECAM region above 256GB
> - highmem_mmio: Has a PCIe MMIO region above 256GB
> - highmem_redist: Has 512 RDs above 256GB
>
> Crucially, the last 3 items must fit in the PA range or be disabled.
>
> We have highmem_ecam which is keyed on highmem, but not on the PA
> range.  highmem_mmio doesn't exist at all (we use highmem instead),
"highmem_ecam is keyed on highmem but not on the PA range". True but it
is properly taken into account in highest_gpa computation so eventually
we make sure it does not overflow the IPA limit. Same for the high mmio
region which is keyed on highmem.
> and I'm only introducing highmem_redist.
>
> For these 3 ranges, we should have something like
>
> vms->highmem_xxx &= (vms->highmem &&
> 		     (vms->memmap[XXX].base + vms->vms->memmap[XXX].size) < vms->highest_gpa);

couldn't you simply introduce highmem_redist which is truly missing. You
could set it in virt_set_memmap() in case you skip extended_map overlay
and use it in virt_gicv3_redist_region_count() as you did?
In addition to the device memory top address check against the 4GB limit
if !highmem, we should be fine then?

Eric
>
> and treat them as independent entities.  Unless someone shouts, I'm
> going to go ahead and implement this logic.
>
> Thanks,
>
> 	M.
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
