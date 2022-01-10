Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F867C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 15:35:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D7F4B12C;
	Mon, 10 Jan 2022 10:35:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EBtHSeQ2umFb; Mon, 10 Jan 2022 10:35:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6CA4B15B;
	Mon, 10 Jan 2022 10:35:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 290584B11A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:35:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ST25u9hXlFMw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 10:35:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB3C84B0ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 10:35:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641828948;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=V4pmMoHNw9NGYka6eDXChlx6TH2icG0i9HWG7XVxjIE=;
 b=fWsvFSrRdak5q08juizNgw8V6SYeBApzuUBLQO5SmXA/VR2SOT8iCHNWfn8aI8sh3ZOCMC
 vRii5Bf+3UyL3IrwlGtdkiuPeoMH+Wl8vwI3mJ7Yfp89pMYZLhJnUWavUmt3rlbXHfnlrA
 EQ13skRlO86S/fVefOdLi34hlohzTnA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-fACLQGbENUOt3_NI1tRAuw-1; Mon, 10 Jan 2022 10:35:47 -0500
X-MC-Unique: fACLQGbENUOt3_NI1tRAuw-1
Received: by mail-wm1-f72.google.com with SMTP id
 j18-20020a05600c1c1200b003335872db8dso2260136wms.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 07:35:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=V4pmMoHNw9NGYka6eDXChlx6TH2icG0i9HWG7XVxjIE=;
 b=0V0ADq5coGmDhf7AzU6uHE+W/lqAxi9r0gaL4UwXvBcD/L2Tn4bU37fNfTzMeivt3E
 HXX61M8ZHd9plQo6GS+8BqmtjULLdy5hD7e5xLdCdBWs5mXdbBnM1lwhXGHnkCCdz9GE
 gqNxE47aFAW8V+RXWHtKZvhycFtvvd46mwkPpME07Wz1W0NiKVKkQn/QrUrhphHzUk97
 3a/mQleyUk0kRGLUFLpZhNle1tmVrvON4QnbIF5CGRt6NMAocDKwkJ5lHy7JlFCYB0ra
 DiUmrHM3Gho5LcEMtLKIJcIhAbnREqIQS9A51sFQWnEwb1X+L/a71ln3sFM0QsZ8035W
 2VAg==
X-Gm-Message-State: AOAM532TjWei/7EjyCcWSGoz4IE2DErTdXV4s4AVughnUZsp6RM8Xstn
 h++uUs+gV4MfAvkZJJSo56+kU7v8uBWXevKKl8P5DU8lGrfXRSFREMWRjUgKDJGYuflGPSKAeOj
 d9eZarZ7tWLkIyL0cKfrOqAtU
X-Received: by 2002:a1c:f01a:: with SMTP id a26mr3962wmb.175.1641828946376;
 Mon, 10 Jan 2022 07:35:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlBR2VhoyVSOdpuV7VUclmcxkriBbSYJVAxqIDuFB2ondyMLGAPdicSSr3ZHYaQzMMUiZ/NA==
X-Received: by 2002:a1c:f01a:: with SMTP id a26mr3943wmb.175.1641828946188;
 Mon, 10 Jan 2022 07:35:46 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id t7sm3889718wmq.42.2022.01.10.07.35.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 10 Jan 2022 07:35:45 -0800 (PST)
Subject: Re: [PATCH v4 2/6] hw/arm/virt: Add a control for the the highmem
 redistributors
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-3-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <448274ac-2650-7c09-742d-584109fb5c56@redhat.com>
Date: Mon, 10 Jan 2022 16:35:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-3-maz@kernel.org>
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

On 1/7/22 5:33 PM, Marc Zyngier wrote:
> Just like we can control the enablement of the highmem PCIe region
> using highmem_ecam, let's add a control for the highmem GICv3
> redistributor region.
>
> Similarily to highmem_ecam, these redistributors are disabled when
> highmem is off.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt-acpi-build.c | 2 ++
>  hw/arm/virt.c            | 2 ++
>  include/hw/arm/virt.h    | 4 +++-
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index cdac009419..505c61e88e 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -946,6 +946,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
>  
> +    vms->highmem_redists &= vms->highmem;
> +
>      acpi_add_table(table_offsets, tables_blob);
>      build_madt(tables_blob, tables->linker, vms);
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index b9ce81f4a1..4d1d629432 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2106,6 +2106,7 @@ static void machvirt_init(MachineState *machine)
>      virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
>  
>      vms->highmem_mmio &= vms->highmem;
> +    vms->highmem_redists &= vms->highmem;
>  
>      create_gic(vms, sysmem);
>  
> @@ -2805,6 +2806,7 @@ static void virt_instance_init(Object *obj)
>  
>      vms->highmem_ecam = !vmc->no_highmem_ecam;
>      vms->highmem_mmio = true;
> +    vms->highmem_redists = true;
>  
>      if (vmc->no_its) {
>          vms->its = false;
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index 9c54acd10d..dc9fa26faa 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -144,6 +144,7 @@ struct VirtMachineState {
>      bool highmem;
>      bool highmem_ecam;
>      bool highmem_mmio;
> +    bool highmem_redists;
>      bool its;
>      bool tcg_its;
>      bool virt;
> @@ -190,7 +191,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
>  
>      assert(vms->gic_version == VIRT_GIC_VERSION_3);
>  
> -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
> +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
> +            vms->highmem_redists) ? 2 : 1;
If we fail to use the high redist region, is there any check that the
number of vcpus does not exceed the first redist region capacity.
Did you check that config, does it nicely fail?

Eric
>  }
>  
>  #endif /* QEMU_ARM_VIRT_H */

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
