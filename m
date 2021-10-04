Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7967C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:44:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48D116124D
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 48D116124D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC1A24B27D;
	Mon,  4 Oct 2021 05:44:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zb1ML22SDxKm; Mon,  4 Oct 2021 05:44:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 838C64B235;
	Mon,  4 Oct 2021 05:44:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B194B220
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:44:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D04Tkl38eXE9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 05:44:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 762E04B201
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:44:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633340652;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Xj2EuEVOkKsDx8NDBU7nmAb1dXmNr3DxIeN0lCugnx4=;
 b=FVZv1JOXn+VW3Vqk08MTxPUKD5qsI7WBDvUyOGz3xaVTmuqGa0ydPLT9+JAeHRFBNAnsqS
 X7+qByrqgXDwbUYM10fKLQew1z+mVEqDiJeG3v92iBHlKPz+m/zcxMv+LBORxzGkuNSQQP
 ANYKr5rZXy25CJNtnYuRuHs9glCJy+I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-1_0hMMFdP5SnEJsEXFBSjg-1; Mon, 04 Oct 2021 05:44:11 -0400
X-MC-Unique: 1_0hMMFdP5SnEJsEXFBSjg-1
Received: by mail-wm1-f72.google.com with SMTP id
 z194-20020a1c7ecb000000b0030b7ccea080so9721313wmc.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 02:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Xj2EuEVOkKsDx8NDBU7nmAb1dXmNr3DxIeN0lCugnx4=;
 b=6G4cpWkH2yUEedh5dKQOqxxOR1xyQblLboTDAiUkUWbRjvwRBI26yh7VQrLzC3iGuH
 Qdoxe40ppsGKxo7ybqaoqR30my9AGeWtkjNP2WP5kkWp9W1dbGNpbA4l/rVqxG6qAjqM
 XwKxAX64rfHFBN8JuWWsOKZDXxYtY7xGsPJw/zGBAjU/9+CY79O0prIQhdtYac1IlFbc
 SZ9gMwOAtcHO3N3pWYr27bRGUxAJgHFQvCUSZQMDz0hJmzOpckBTFqtFMIVRLr/CJJwD
 6xOa5hEl6rKeXnv+VTd49iow+KgwtPciQmO619uLEnMFOhszsuWOIUnfeQvVr0XriB+X
 JV/A==
X-Gm-Message-State: AOAM532oyRsQ4v0WT011sTIop8DgX/k20OqdQRsW5X3/A3bCe/9m52Bp
 gPoHge/FGW7jyXVJRTGLCdQ/Th8EOc6qA/4MNxLDvwCu1watS4bAgVZZiir/uvCrUFsA/CrHk70
 uuGDjvf9TBdcWEPE3zSmvrMOO
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr17252394wmc.6.1633340650116; 
 Mon, 04 Oct 2021 02:44:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJwJXaCcMvmdsIG+SbzkOzsOXG04w26FIdFhGoCqVjymAJqr3ER5/M9rlRA8olgI7/usRnrw==
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr17252376wmc.6.1633340649909; 
 Mon, 04 Oct 2021 02:44:09 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id n68sm16106200wmn.13.2021.10.04.02.44.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 02:44:09 -0700 (PDT)
Date: Mon, 4 Oct 2021 11:44:08 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/5] hw/arm/virt: Add a control for the the highmem
 redistributors
Message-ID: <20211004094408.xfftmls7h6bbypuk@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-3-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-3-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

On Sun, Oct 03, 2021 at 05:46:02PM +0100, Marc Zyngier wrote:
> Just like we can control the enablement of the highmem PCIe region
> using highmem_ecam, let's add a control for the highmem GICv3
> redistributor region.
> 
> Similarily to highmem_ecam, these redistributors are disabled when
> highmem is off.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt-acpi-build.c | 2 ++
>  hw/arm/virt.c            | 3 +++
>  include/hw/arm/virt.h    | 4 +++-
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index d7bef0e627..f0d0b662b7 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -792,6 +792,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
>  
> +    vms->highmem_redists &= vms->highmem;
> +
>      acpi_add_table(table_offsets, tables_blob);
>      build_madt(tables_blob, tables->linker, vms);
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 8021d545c3..bcf58f677d 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2053,6 +2053,8 @@ static void machvirt_init(MachineState *machine)
>  
>      virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
>  
> +    vms->highmem_redists &= vms->highmem;
> +
>      create_gic(vms, sysmem);
>  
>      virt_cpu_post_init(vms, sysmem);
> @@ -2750,6 +2752,7 @@ static void virt_instance_init(Object *obj)
>      vms->gic_version = VIRT_GIC_VERSION_NOSEL;
>  
>      vms->highmem_ecam = !vmc->no_highmem_ecam;
> +    vms->highmem_redists = true;
>  
>      if (vmc->no_its) {
>          vms->its = false;
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index b461b8d261..787cc8a27d 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -141,6 +141,7 @@ struct VirtMachineState {
>      bool secure;
>      bool highmem;
>      bool highmem_ecam;
> +    bool highmem_redists;
>      bool its;
>      bool tcg_its;
>      bool virt;
> @@ -187,7 +188,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
>  
>      assert(vms->gic_version == VIRT_GIC_VERSION_3);
>  
> -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
> +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
> +            vms->highmem_redists) ? 2 : 1;

Wouldn't it be equivalent to just use vms->highmem here?

>  }
>  
>  #endif /* QEMU_ARM_VIRT_H */
> -- 
> 2.30.2
> 

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
