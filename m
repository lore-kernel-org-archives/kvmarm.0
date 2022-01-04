Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEF3C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 15:31:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C4CA48F9C;
	Tue,  4 Jan 2022 10:31:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1QisRmN-C0l2; Tue,  4 Jan 2022 10:31:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31AB049F12;
	Tue,  4 Jan 2022 10:31:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 703BB49F12
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 10:31:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zKkfOMY+1HvP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 10:31:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 522B449F11
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 10:31:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641310299;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dHb1Dlc/ItOolPMR+Jc0/qUYSK2KoiTzttrdRcxrJcE=;
 b=dXAapQKnSB7RiCtEBXIKVSPwSlMTNVoP8Kz56hXZ8ZyuuVdZoD1BE/lYozmL0ndK3SuVB6
 iRnshMrjgZfwJGQa7mG4bVeiW7GbYb/87fRj0Fh6LabwXqLn8QYNOGzLBHWGWyWtP0RqaN
 E/aCX/1vWxIWWreJT1PUDBQnHUs5mug=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-illx7BQCNA-gmY-3BMQtOQ-1; Tue, 04 Jan 2022 10:31:37 -0500
X-MC-Unique: illx7BQCNA-gmY-3BMQtOQ-1
Received: by mail-wr1-f71.google.com with SMTP id
 j19-20020adfa553000000b001a375e473d8so3367848wrb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 07:31:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=dHb1Dlc/ItOolPMR+Jc0/qUYSK2KoiTzttrdRcxrJcE=;
 b=PNYFB398tKcUDMM7FIKDBbRUeELYiQfHsHbVXJW4HonKtNE8Zwk+IoRsAeesPSnaiq
 O8tRy2jZtGqoFVXTGDV6a+MgBIcBYa8s16c8Zoik8vjhhNcdJbzVxhIKu8z+s1bu899/
 vHRHmMhTA8suNOpQQA32P3L18hQue73Du4nDoWN2+GtlvmEhkvhbLi3u+WDYGaHh43xS
 /fFvxrcUhCjZCmaXmsT+xlDxU0yMal4/pJ1qK77DjhapLrbAfZmUGbj7T68Tmoz28lts
 CsRiDW1EqE31KYjeaMIs0aS/MHmGmB6c+hmsf5ROylkUEg9AxVHc/WNZGY/FmI7kCOHk
 PfAw==
X-Gm-Message-State: AOAM530z9RDOPZumLnVHWefaoCpiNx4fQi6PZunCa4kp+YMdQoSaBhRN
 gJGLzEBiU4N0rlM7ooOPBiAB9NcBQohwtNKx27ah09vxe8EEA42BnW1b+hDs0MQfbnjruie0W67
 +Au5nqUzbot2qxpEh2iEH4cub
X-Received: by 2002:a05:600c:4f83:: with SMTP id
 n3mr41830317wmq.129.1641310295485; 
 Tue, 04 Jan 2022 07:31:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwV9IRJ1sEs6RhagLAEfvJinAJ1OWUzplrbq8dl6cI1k7STj6fGh3vl7cyX2z/tYQ7+BP7Pxw==
X-Received: by 2002:a05:600c:4f83:: with SMTP id
 n3mr41830296wmq.129.1641310295252; 
 Tue, 04 Jan 2022 07:31:35 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id ay29sm39635325wmb.13.2022.01.04.07.31.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 04 Jan 2022 07:31:34 -0800 (PST)
Subject: Re: [PATCH v2 1/5] hw/arm/virt: Key enablement of highmem PCIe on
 highmem_ecam
To: Marc Zyngier <maz@kernel.org>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-2-maz@kernel.org>
 <dbe883ca-880e-7f2b-1de7-4b2d3361545d@redhat.com>
 <87pmpiyrfw.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <b9031d40-897e-b8c5-4240-fc2936dcbcb9@redhat.com>
Date: Tue, 4 Jan 2022 16:31:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87pmpiyrfw.wl-maz@kernel.org>
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

On 12/27/21 4:53 PM, Marc Zyngier wrote:
> Hi Eric,
>
> Picking this up again after a stupidly long time...
>
> On Mon, 04 Oct 2021 13:00:21 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 10/3/21 6:46 PM, Marc Zyngier wrote:
>>> Currently, the highmem PCIe region is oddly keyed on the highmem
>>> attribute instead of highmem_ecam. Move the enablement of this PCIe
>>> region over to highmem_ecam.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  hw/arm/virt-acpi-build.c | 10 ++++------
>>>  hw/arm/virt.c            |  4 ++--
>>>  2 files changed, 6 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
>>> index 037cc1fd82..d7bef0e627 100644
>>> --- a/hw/arm/virt-acpi-build.c
>>> +++ b/hw/arm/virt-acpi-build.c
>>> @@ -157,10 +157,9 @@ static void acpi_dsdt_add_virtio(Aml *scope,
>>>  }
>>>  
>>>  static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>>> -                              uint32_t irq, bool use_highmem, bool highmem_ecam,
>>> -                              VirtMachineState *vms)
>>> +                              uint32_t irq, VirtMachineState *vms)
>>>  {
>>> -    int ecam_id = VIRT_ECAM_ID(highmem_ecam);
>>> +    int ecam_id = VIRT_ECAM_ID(vms->highmem_ecam);
>>>      struct GPEXConfig cfg = {
>>>          .mmio32 = memmap[VIRT_PCIE_MMIO],
>>>          .pio    = memmap[VIRT_PCIE_PIO],
>>> @@ -169,7 +168,7 @@ static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>>>          .bus    = vms->bus,
>>>      };
>>>  
>>> -    if (use_highmem) {
>>> +    if (vms->highmem_ecam) {
>> highmem_ecam is more restrictive than use_highmem:
>> vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);
>>
>> If I remember correctly there was a problem using highmem ECAM with 32b
>> AAVMF FW.
>>
>> However 5125f9cd2532 ("hw/arm/virt: Add high MMIO PCI region, 512G in
>> size") introduced high MMIO PCI region without this constraint.
> Then I really don't understand the point of this highmem_ecam. We only
> register the highmem version if highmem_ecam is set (see the use of
> VIRT_ECAM_ID() to pick the right ECAM window).

but aren't we talking about different regions? On one hand the [high]
MMIO region (512GB wide) and the [high] ECAM region (256MB large).
To me you can enable either independently. High MMIO region is used by
some devices likes ivshmem/video cards while high ECAM was introduced to
extend the number of supported buses: 601d626d148a (hw/arm/virt: Add a
new 256MB ECAM region).

with the above change the high MMIO region won't be set with 32b
FW+kernel and LPAE whereas it is currently.

high ECAM was not supported by 32b FW, hence the highmem_ecam.

but maybe I miss your point?

Eric
>
> So keying this on highmem makes it expose a device that may not be
> there the first place since, as you pointed out that highmem_ecam can
> be false in cases where highmem is true.
>
>> So to me we should keep vms->highmem here
> I really must be missing how this is supposed to work.
>
> 	M.
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
