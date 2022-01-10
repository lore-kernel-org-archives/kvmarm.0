Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9C1C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 17:14:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6104B17D;
	Mon, 10 Jan 2022 12:14:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ihkb6k5oTapx; Mon, 10 Jan 2022 12:14:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8EE94B191;
	Mon, 10 Jan 2022 12:14:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1405B4B17D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 12:14:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FjstgUa2XOmp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 12:14:08 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 158524B186
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 12:14:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641834847;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/OwkNEmN55JU96/ASO65aR43EkpF+6fG5Yz1cY2wG7A=;
 b=gU40bLJ52rUovQUFNLHpDtbqYtPGqJGMAUR4AveKt3mr9vrkVqj75YoobLVxvAEcxar7k6
 Pfa64xDzMhjuzd4HWs5AWwuHZe/Q1kFR0WwMMcs4LJN/cxaVuBZH0Sd5kXqgPr08rTgQdT
 D3n9S/3eBhkFhAe5LxTU17oPTxG0Bbg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-0tv9HfTiPTSir6k9bCqJ6g-1; Mon, 10 Jan 2022 12:14:06 -0500
X-MC-Unique: 0tv9HfTiPTSir6k9bCqJ6g-1
Received: by mail-wm1-f71.google.com with SMTP id
 d4-20020a05600c34c400b00345d5d47d54so251921wmq.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 09:14:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=/OwkNEmN55JU96/ASO65aR43EkpF+6fG5Yz1cY2wG7A=;
 b=Waut0pfKxJOmKC7hUjNloz+hUZSpiCJDSF8IL+b070j0Z4jlSoDcfEGjahFo65jgOD
 oW+chkjUuSbMxm6NMRz24Pd7GWDsjPl9JExqGFiKTuUlGsjNWl8sSYG6mp6KQ4uxs4V8
 EDyV/L5uNMJyQEPIHxtTFkGmWg/C4ke5OJyg6E85tlptip58zAe0E15Go/D9/ZK8xd5Y
 AEhfnkHfmlHAcPNzUkwdFfUekeKHh1vGvt6ii3H4w++xeTYENpf1xpPg6eVE6bYubNdC
 dQ8M36kSE/kvMWUrXbHw2jfUoPPLRBPwId7lbqMhNxV2iQY2L/8ZSulSUEomVS9YYAfZ
 331g==
X-Gm-Message-State: AOAM533whbtB0HtX4/wLu4OHzmLzGAQF+dTAmHGuLRK6LNhRdov5NHHV
 P2wfRL4Qi1Wkmo4Bw/BUJfCY/w6aeO/6zW6+aka15MdiHWFjJvD02jPtR7jmz7T25g295bPPRDE
 xY08l6sUDAsECVUa352qSSd3n
X-Received: by 2002:a1c:1b8f:: with SMTP id
 b137mr13975733wmb.115.1641834845327; 
 Mon, 10 Jan 2022 09:14:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzX/AVDnmSq9VH+zfYVCj+he8c52vstnXhZ8DJLq9SVI9o4IHfyMCkkhoDPHbGcjU2e6D7Ycg==
X-Received: by 2002:a1c:1b8f:: with SMTP id
 b137mr13975716wmb.115.1641834845157; 
 Mon, 10 Jan 2022 09:14:05 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id w7sm1646476wrv.96.2022.01.10.09.14.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 10 Jan 2022 09:14:04 -0800 (PST)
Subject: Re: [PATCH v4 6/6] hw/arm/virt: Drop superfluous checks against
 highmem
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-7-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <ddb29c44-bcbb-b3fd-c226-889b352b1dc8@redhat.com>
Date: Mon, 10 Jan 2022 18:14:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-7-maz@kernel.org>
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
> Now that the devices present in the extended memory map are checked
> against the available PA space and disabled when they don't fit,
> there is no need to keep the same checks against highmem, as
> highmem really is a shortcut for the PA space being 32bit.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  hw/arm/virt-acpi-build.c | 2 --
>  hw/arm/virt.c            | 5 +----
>  2 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 505c61e88e..cdac009419 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -946,8 +946,6 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
>  
> -    vms->highmem_redists &= vms->highmem;
> -
>      acpi_add_table(table_offsets, tables_blob);
>      build_madt(tables_blob, tables->linker, vms);
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 70b4773b3e..641c6a9c31 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2170,9 +2170,6 @@ static void machvirt_init(MachineState *machine)
>  
>      virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
>  
> -    vms->highmem_mmio &= vms->highmem;
> -    vms->highmem_redists &= vms->highmem;
> -
>      create_gic(vms, sysmem);
>  
>      virt_cpu_post_init(vms, sysmem);
> @@ -2191,7 +2188,7 @@ static void machvirt_init(MachineState *machine)
>                         machine->ram_size, "mach-virt.tag");
>      }
>  
> -    vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);
> +    vms->highmem_ecam &= (!firmware_loaded || aarch64);
>  
>      create_rtc(vms);
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
