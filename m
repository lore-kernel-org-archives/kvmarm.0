Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614E1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 13:51:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAE8149EE7;
	Tue, 18 Jan 2022 08:51:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 09jpN02l0kuU; Tue, 18 Jan 2022 08:51:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA93140BDF;
	Tue, 18 Jan 2022 08:51:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 071E440D01
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 08:51:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PChQeIE92mYW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 08:51:17 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A49E40C2B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 08:51:16 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642513876;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XtsWfSO5g+1IkZhp0URadLZGJDH3pn6puBwMTeb0Tvw=;
 b=A+kWj0oV0pnk/UIQLc9/x7AC65xKv5yjo9eGSOWIaeoIBukMQmx+HDfPnkHpClu/pHfgKl
 RRHU+g8NZjuqVdB1Ocuc0PoODd12Xh91GQbsg9cIuS9JUavs57qwx16pBUZCgBe82XEz2c
 LxzEn3iRQ45IO2yuTHxK0pj9aI9f4/c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-ZkExxpimOz6zPUvgnTlCYg-1; Tue, 18 Jan 2022 08:51:15 -0500
X-MC-Unique: ZkExxpimOz6zPUvgnTlCYg-1
Received: by mail-wm1-f71.google.com with SMTP id
 a3-20020a05600c348300b0034a0dfc86aaso1876910wmq.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 05:51:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=XtsWfSO5g+1IkZhp0URadLZGJDH3pn6puBwMTeb0Tvw=;
 b=lYmgppndD+NQ+npLRxOEmF5gn0Hfq/oYeMAEjpjf7kS/gOLzteumG8ugLVB7jwupUW
 g2HhhymUe2SKIFQLJD1Gs7k8M+Y/ZozuzbQNjHPswPS2kxwuZDw/Ys99AgxN/SWgZDHM
 3BVthCuxgucXspx0+4GLEdT5JgVygCFg1UWhoxrJcDD7/sfG+alxHqDjqhoYo+3TUvzl
 uHh3cjidzANijOTrZ34SwBC/rgDf56SDROBUd/kLYkIEh5i3m8a3PkAut2OtNY3PgN66
 PnpeOQVbcPcnXyu1DBV23CvpSlT3TRtLZqsIoDPGRE9EyAVhPYD6WJqV1PDeCnWeejZE
 WgKg==
X-Gm-Message-State: AOAM533E/C72thUk1Q7h56UGz13PG/Hq6EHXX7HkGdF2CNRD4BrX59Uh
 IjmNyxFZiM7p33JaWjw1sHER74Jm4Cl5KKrKWbjHoC4w971TX7UhTCLBGskSDKXVeaD4E9dZhlO
 FRnIdRR7zBwi4b8Nif8f2HyaD
X-Received: by 2002:adf:d216:: with SMTP id j22mr24178140wrh.577.1642513873896; 
 Tue, 18 Jan 2022 05:51:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+zdAwpffOMmGVouMShoWBPumbBdn/bH0H3D0yY6l0Qqa/DIEvHGXEORdmRbsUH9omHoWCww==
X-Received: by 2002:adf:d216:: with SMTP id j22mr24178127wrh.577.1642513873737; 
 Tue, 18 Jan 2022 05:51:13 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id w9sm2903086wmc.36.2022.01.18.05.51.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Jan 2022 05:51:13 -0800 (PST)
Subject: Re: [PATCH v5 2/6] hw/arm/virt: Add a control for the the highmem
 redistributors
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220114140741.1358263-1-maz@kernel.org>
 <20220114140741.1358263-3-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <8a25a161-6ad5-4a2a-c16b-b3784dd60af6@redhat.com>
Date: Tue, 18 Jan 2022 14:51:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220114140741.1358263-3-maz@kernel.org>
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

On 1/14/22 3:07 PM, Marc Zyngier wrote:
> Just like we can control the enablement of the highmem PCIe region
> using highmem_ecam, let's add a control for the highmem GICv3
> redistributor region.
>
> Similarily to highmem_ecam, these redistributors are disabled when
> highmem is off.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/arm/virt-acpi-build.c | 2 ++
>  hw/arm/virt.c            | 2 ++
>  include/hw/arm/virt.h    | 4 +++-
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 449fab0080..0757c28f69 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -947,6 +947,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
>  
> +    vms->highmem_redists &= vms->highmem;
> +
>      acpi_add_table(table_offsets, tables_blob);
>      build_madt(tables_blob, tables->linker, vms);
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index ed8ea96acc..e734a75850 100644
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
>  }
>  
>  #endif /* QEMU_ARM_VIRT_H */

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
