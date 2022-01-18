Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3BDC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 13:52:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D2404087B;
	Tue, 18 Jan 2022 08:52:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZhAsXoD99f2z; Tue, 18 Jan 2022 08:52:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE97740BDF;
	Tue, 18 Jan 2022 08:52:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B531740BDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 08:52:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wAl9UJwqt0BH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 08:52:51 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 844544087B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 08:52:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642513971;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=36a2BKXBbIf5JkcOHL88oMqp1VmRzpTRArA4l0SrL9E=;
 b=iUzfuFySopiv4HVf5ab7jJkRUjVuhdB5+08N6qns/0MFwLHY3AYZwgr2KjvBB/J8Ml3uWN
 U6DoJ8S+PVp0d8x2AqAy8aYf3WfDTYihRSP+VcokayqXw/wjA3yB57GpmUlYmHadNYx3jO
 b8pnJvk+cywKxW3vfP8OhJB3fkm8BOo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-rWCmw5aRNXu8e1AcCtWRkA-1; Tue, 18 Jan 2022 08:52:50 -0500
X-MC-Unique: rWCmw5aRNXu8e1AcCtWRkA-1
Received: by mail-wm1-f72.google.com with SMTP id
 n14-20020a7bcbce000000b003488820f0d9so2125798wmi.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 05:52:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=36a2BKXBbIf5JkcOHL88oMqp1VmRzpTRArA4l0SrL9E=;
 b=lKJxvYJVnsQa68aQ81yZKVYtTXajHqR2ht3orYfhefnEUhor39kXL8EWQl2RORScPy
 v3BCYfWtXDwHeDmGjB4m506u0qBMKv1BfGSfRVfmDrH0kolm0cGBolIyL+Y68EvHakgi
 1OiUqbtFC62WNQmTSOxBDoX4tHQuwPfPCdsyXcPUxTOAA7Sz53WlrJgRbK1BC8HLLZdV
 ffYKfz6TSZOxSY/4v4tZ88Y/gkK0oW7woLBaevie9BoiAbRuwvpX33nb8SdRGFo4BZpC
 H35TpGyPeiJnr1kMBmXx9PBaxtqsKcMj36QBXRbXfDYxMOWZkz2dq+/gSztVj/Oi1iJJ
 JP8g==
X-Gm-Message-State: AOAM531+CXUhaM5yLpOaTXLQRpwYhv4C8c+GmWRsspnM4JnB4DV9tOKD
 UNftHl3i+NxuBPdL6r6l+FEo4pfJ+/OYR2ntaeuNfM2uApbHuXrZBf6NmmY+WeVrpTD4aVn0jGH
 TUJqgXn8z6heSzAxd9+mys2ar
X-Received: by 2002:adf:ed0b:: with SMTP id a11mr25227526wro.471.1642513968917; 
 Tue, 18 Jan 2022 05:52:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwt90WS6vKSrgwSoLg58YPWYMQwAew02iX8hgtdnIgF6OmJ/Nj4hW8KBNl2YkgmySR0dgcH+w==
X-Received: by 2002:adf:ed0b:: with SMTP id a11mr25227511wro.471.1642513968719; 
 Tue, 18 Jan 2022 05:52:48 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id v13sm2364415wmh.45.2022.01.18.05.52.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Jan 2022 05:52:48 -0800 (PST)
Subject: Re: [PATCH v5 1/6] hw/arm/virt: Add a control for the the highmem
 PCIe MMIO
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20220114140741.1358263-1-maz@kernel.org>
 <20220114140741.1358263-2-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <a4a47554-64c9-75cf-fd99-6c69b4b76f6d@redhat.com>
Date: Tue, 18 Jan 2022 14:52:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220114140741.1358263-2-maz@kernel.org>
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
> Just like we can control the enablement of the highmem PCIe ECAM
> region using highmem_ecam, let's add a control for the highmem
> PCIe MMIO  region.
>
> Similarily to highmem_ecam, this region is disabled when highmem
> is off.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/arm/virt-acpi-build.c | 10 ++++------
>  hw/arm/virt.c            |  7 +++++--
>  include/hw/arm/virt.h    |  1 +
>  3 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index f2514ce77c..449fab0080 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -158,10 +158,9 @@ static void acpi_dsdt_add_virtio(Aml *scope,
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
> @@ -170,7 +169,7 @@ static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>          .bus    = vms->bus,
>      };
>  
> -    if (use_highmem) {
> +    if (vms->highmem_mmio) {
>          cfg.mmio64 = memmap[VIRT_HIGH_PCIE_MMIO];
>      }
>  
> @@ -869,8 +868,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>      acpi_dsdt_add_fw_cfg(scope, &memmap[VIRT_FW_CFG]);
>      acpi_dsdt_add_virtio(scope, &memmap[VIRT_MMIO],
>                      (irqmap[VIRT_MMIO] + ARM_SPI_BASE), NUM_VIRTIO_TRANSPORTS);
> -    acpi_dsdt_add_pci(scope, memmap, (irqmap[VIRT_PCIE] + ARM_SPI_BASE),
> -                      vms->highmem, vms->highmem_ecam, vms);
> +    acpi_dsdt_add_pci(scope, memmap, irqmap[VIRT_PCIE] + ARM_SPI_BASE, vms);
>      if (vms->acpi_dev) {
>          build_ged_aml(scope, "\\_SB."GED_DEVICE,
>                        HOTPLUG_HANDLER(vms->acpi_dev),
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index b45b52c90e..ed8ea96acc 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1412,7 +1412,7 @@ static void create_pcie(VirtMachineState *vms)
>                               mmio_reg, base_mmio, size_mmio);
>      memory_region_add_subregion(get_system_memory(), base_mmio, mmio_alias);
>  
> -    if (vms->highmem) {
> +    if (vms->highmem_mmio) {
>          /* Map high MMIO space */
>          MemoryRegion *high_mmio_alias = g_new0(MemoryRegion, 1);
>  
> @@ -1466,7 +1466,7 @@ static void create_pcie(VirtMachineState *vms)
>      qemu_fdt_setprop_sized_cells(ms->fdt, nodename, "reg",
>                                   2, base_ecam, 2, size_ecam);
>  
> -    if (vms->highmem) {
> +    if (vms->highmem_mmio) {
>          qemu_fdt_setprop_sized_cells(ms->fdt, nodename, "ranges",
>                                       1, FDT_PCI_RANGE_IOPORT, 2, 0,
>                                       2, base_pio, 2, size_pio,
> @@ -2105,6 +2105,8 @@ static void machvirt_init(MachineState *machine)
>  
>      virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
>  
> +    vms->highmem_mmio &= vms->highmem;
> +
>      create_gic(vms, sysmem);
>  
>      virt_cpu_post_init(vms, sysmem);
> @@ -2802,6 +2804,7 @@ static void virt_instance_init(Object *obj)
>      vms->gic_version = VIRT_GIC_VERSION_NOSEL;
>  
>      vms->highmem_ecam = !vmc->no_highmem_ecam;
> +    vms->highmem_mmio = true;
>  
>      if (vmc->no_its) {
>          vms->its = false;
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index dc6b66ffc8..9c54acd10d 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -143,6 +143,7 @@ struct VirtMachineState {
>      bool secure;
>      bool highmem;
>      bool highmem_ecam;
> +    bool highmem_mmio;
>      bool its;
>      bool tcg_its;
>      bool virt;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
