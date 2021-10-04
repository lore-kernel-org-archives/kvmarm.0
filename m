Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29653C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:41:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1DA96126A
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A1DA96126A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25C5E4B20D;
	Mon,  4 Oct 2021 05:41:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nnKyYItVT42l; Mon,  4 Oct 2021 05:41:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B3B24B224;
	Mon,  4 Oct 2021 05:41:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34D204B21E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:41:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yLDlodGLpNbZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 05:41:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 437074B20D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:41:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633340476;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=dxfVhJVrqy9SilnYUxM4IeGNxJd1tbk2Hh41DGObvxE=;
 b=Zn34M2LHw4dab01WvAtoXBcNCsYSB7dmo+r2zU5Nae6KzhD8kMU6ggIdPLE8x9Do/3kb1H
 AQItDN6NtxmjKxsy+WiKjq0DHd0pEPh8zl+QQA/qvIbYRVp/253OyMVLALavTxukWmNRwa
 lQ6qd2Ux/HmyceMsmZoVQXdqYj2aD0s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-N8h2_Q2BNAi888XD5bCXOw-1; Mon, 04 Oct 2021 05:41:14 -0400
X-MC-Unique: N8h2_Q2BNAi888XD5bCXOw-1
Received: by mail-wr1-f71.google.com with SMTP id
 r15-20020adfce8f000000b0015df1098ccbso4456591wrn.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 02:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dxfVhJVrqy9SilnYUxM4IeGNxJd1tbk2Hh41DGObvxE=;
 b=2NPEpq7+U7yIxtTnpPaKutwVh1WvXX1TdRdZcGVSDi0CXPe3Z67PEtJgXAfDWblrjV
 Xw+xtrearZUAjg86J6H8nbL0vrF1AuJBp3287YOl8/M4thAZixx9NSrWQo1RupND6PZY
 aSvX81ntty4v2qRXvdPlMyk2AMtPxOVPu1DbXO2qPamxXjXQfTeDJy4e/+enx170oJ7g
 3n2ZbGHha3RHKfSBKC/oqHTKwpILqRyBvewsrne7hJGfHdKc7pg6+LTRp9Er2linAknL
 mWbxFfXTIyvkW1DcnBwUG8gWejrHIJtJvQrHYr0RC6u9UtC4Jcgj+KYmGzYnqxxwAt1C
 /WXQ==
X-Gm-Message-State: AOAM531Jm2A/Gyy9TYOfBPGc8usbzUa+coLbynASzowyZBqUyRJmbgyx
 wG280loJ+boTW6A1jpRALUCDJ21z5YvAcYoqA4pOQ/JYo/37eJmZG01kWQ2GRWZ8EVZ0ltC9C+n
 /ZepdP/MM1Vhuiyt0KiN1TuSp
X-Received: by 2002:adf:8b17:: with SMTP id n23mr11450050wra.290.1633340473733; 
 Mon, 04 Oct 2021 02:41:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJKWagXir+Cur7XWqj46gpIlntXbexRxFlKwV6Z5cdcFb0pk6YR7WGxNsnbwzxcb78pAGg9g==
X-Received: by 2002:adf:8b17:: with SMTP id n23mr11450026wra.290.1633340473501; 
 Mon, 04 Oct 2021 02:41:13 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id o8sm7202183wme.38.2021.10.04.02.41.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 02:41:13 -0700 (PDT)
Date: Mon, 4 Oct 2021 11:41:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/5] hw/arm/virt: Key enablement of highmem PCIe on
 highmem_ecam
Message-ID: <20211004094111.2762nq634e24j4rn@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-2-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-2-maz@kernel.org>
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

On Sun, Oct 03, 2021 at 05:46:01PM +0100, Marc Zyngier wrote:
> Currently, the highmem PCIe region is oddly keyed on the highmem
> attribute instead of highmem_ecam. Move the enablement of this PCIe
> region over to highmem_ecam.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt-acpi-build.c | 10 ++++------
>  hw/arm/virt.c            |  4 ++--
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 037cc1fd82..d7bef0e627 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -157,10 +157,9 @@ static void acpi_dsdt_add_virtio(Aml *scope,
>  }
>  
>  static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
> -                              uint32_t irq, bool use_highmem, bool highmem_ecam,
> -                              VirtMachineState *vms)
> +                              uint32_t irq, VirtMachineState *vms)
>  {
> -    int ecam_id = VIRT_ECAM_ID(highmem_ecam);
> +    int ecam_id = VIRT_ECAM_ID(vms->highmem_ecam);
>      struct GPEXConfig cfg = {
>          .mmio32 = memmap[VIRT_PCIE_MMIO],
>          .pio    = memmap[VIRT_PCIE_PIO],
> @@ -169,7 +168,7 @@ static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>          .bus    = vms->bus,
>      };
>  
> -    if (use_highmem) {
> +    if (vms->highmem_ecam) {
>          cfg.mmio64 = memmap[VIRT_HIGH_PCIE_MMIO];
>      }
>  
> @@ -712,8 +711,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>      acpi_dsdt_add_fw_cfg(scope, &memmap[VIRT_FW_CFG]);
>      acpi_dsdt_add_virtio(scope, &memmap[VIRT_MMIO],
>                      (irqmap[VIRT_MMIO] + ARM_SPI_BASE), NUM_VIRTIO_TRANSPORTS);
> -    acpi_dsdt_add_pci(scope, memmap, (irqmap[VIRT_PCIE] + ARM_SPI_BASE),
> -                      vms->highmem, vms->highmem_ecam, vms);
> +    acpi_dsdt_add_pci(scope, memmap, (irqmap[VIRT_PCIE] + ARM_SPI_BASE), vms);

While tidying this interface, could also remove the superfluous ().

>      if (vms->acpi_dev) {
>          build_ged_aml(scope, "\\_SB."GED_DEVICE,
>                        HOTPLUG_HANDLER(vms->acpi_dev),
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 7170aaacd5..8021d545c3 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1362,7 +1362,7 @@ static void create_pcie(VirtMachineState *vms)
>                               mmio_reg, base_mmio, size_mmio);
>      memory_region_add_subregion(get_system_memory(), base_mmio, mmio_alias);
>  
> -    if (vms->highmem) {
> +    if (vms->highmem_ecam) {
>          /* Map high MMIO space */
>          MemoryRegion *high_mmio_alias = g_new0(MemoryRegion, 1);
>  
> @@ -1416,7 +1416,7 @@ static void create_pcie(VirtMachineState *vms)
>      qemu_fdt_setprop_sized_cells(ms->fdt, nodename, "reg",
>                                   2, base_ecam, 2, size_ecam);
>  
> -    if (vms->highmem) {
> +    if (vms->highmem_ecam) {
>          qemu_fdt_setprop_sized_cells(ms->fdt, nodename, "ranges",
>                                       1, FDT_PCI_RANGE_IOPORT, 2, 0,
>                                       2, base_pio, 2, size_pio,
> -- 
> 2.30.2
> 


Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
