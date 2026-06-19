Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72A1DD525
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781877006; cv=none; b=W6x5BfUfiqUYyskJlJ/qtDjByEoReBzP3O9yQPYMNquSawfGYgHURa6U2eD3j3IsdrD+G9wgjxz3Y/SuC2BBtoa4WHEMw/IyzNI9/1UOYlMA9z5lWvIjRN2YusYZRvCmqChQ3hPRiMbWw7550XuPXbvKRxHxUQA7WdsNviaEo5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781877006; c=relaxed/simple;
	bh=qiFiwRkdPUZLaG3a9/RJbKrorenkk34pyYYWNbb/nyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kCYkQS+AyeS4S83gMzolHY3fYgDnLfNgy91zD3AmfnQv2pweNDt3Wnv4SHSNlnnqXCQawgzNmVID+TX+TKJizn5Jj0v9mtHg/wJVzm4ullS/WIIBoaF1mGiPZVhMa6zv329eurFW7gYga9F+FLqEAdlmO94KEHjTS+/MZYbztwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q89pctB5; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q89pctB5"
X-Forwarded-Encrypted: i=1; AFNElJ90gr/MqAGYbCkYnBOMTwCt+VTACx3KdlDAGFmMagWRO9haX7Duo80H8erVzPj270J9YKbq3HM=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781877003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7YkY7/fRlhm+ypYsY6WrTFP5NJOyuEB6S6Db+mhsho=;
	b=q89pctB55DRUAzBYJZ+Udjo+ozWwmzF2xtIbesTkrT2riVvQxO3MoKa6d+4FPn10Hmd3aC
	R/JECrhJFz/ZeTG3hJgkYbC6iZOfZd9/yHYq2Yrj0WjtC5V5HUN7fq+WHJCoq9vLAmmP7u
	cxnCwr6F/OKzr4RcmApe709PVG862zY=
X-Gm-Message-State: AOJu0YwJpc2FR+h+k/S/aE4uvKgpRETttryZqU6y3HSot6bn2JrDbQmY
	qzwATYw16hD3t7bXY3kh0xK+iSXzccaTTAup9DbOibYJYuIGLGhQwJh1rU5VT6kUslm+RWszWZ/
	Xuz2LqNdV3xmYjoCX1y4EtsSL/TV7aX3FvFIl+lZK
X-Received: by 2002:a05:622a:353:b0:517:99ea:ab79 with SMTP id
 d75a77b69052e-519e8e7516bmr7294801cf.25.1781876988300; Fri, 19 Jun 2026
 06:49:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619115415.5475-1-will@kernel.org> <20260619115415.5475-5-will@kernel.org>
In-Reply-To: <20260619115415.5475-5-will@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 19 Jun 2026 14:49:11 +0100
X-Gmail-Original-Message-ID: <CA+EHjTww=aY50itZBv=jUA6VeFNxgzyPkz2bktmW_ua1UdGmbQ@mail.gmail.com>
X-Gm-Features: AVVi8CdpAftAqDtWg1r2PRVf0VZ0OoIuqSLodNzRKnFtDqh6N6W58FWaKSJcgrE
Message-ID: <CA+EHjTww=aY50itZBv=jUA6VeFNxgzyPkz2bktmW_ua1UdGmbQ@mail.gmail.com>
Subject: Re: [PATCH kvmtool 4/4] arm64: Add support for protected VMs
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Will,

On Fri, 19 Jun 2026 at 12:54, Will Deacon <will@kernel.org> wrote:
>
> Introduce a new '--protected' parameter which requests the creation of
> a protected VM type from the kernel. In addition, a reserved DMA region
> is advertised in the device-tree and VIRTIO_F_ACCESS_PLATFORM is
> advertised so that virtio transfers can be bounced through a shared
> memory window.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Two nits below, otherwise:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>


> ---
>  arm64/fdt.c                         | 37 +++++++++++++++++++++++++++--
>  arm64/include/kvm/fdt-arch.h        | 10 +++++++-
>  arm64/include/kvm/kvm-arch.h        |  2 ++
>  arm64/include/kvm/kvm-config-arch.h |  5 +++-
>  arm64/kvm.c                         | 20 +++++++++++++++-
>  arm64/pci.c                         |  2 ++
>  6 files changed, 71 insertions(+), 5 deletions(-)
>
> diff --git a/arm64/fdt.c b/arm64/fdt.c
> index 98f1dd9..3cbd36e 100644
> --- a/arm64/fdt.c
> +++ b/arm64/fdt.c
> @@ -71,6 +71,19 @@ static void generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
>         _FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
>  }
>
> +static bool emit_dma_regions;
> +void generate_dma_region_prop(void *fdt)
> +{
> +       if (emit_dma_regions)
> +               _FDT(fdt_property_cell(fdt, "memory-region", PHANDLE_DMA));
> +}
> +
> +static void generate_aux_props(void *fdt, u8 irq, enum irq_type irq_type)
> +{
> +       generate_irq_prop(fdt, irq, irq_type);
> +       generate_dma_region_prop(fdt);
> +}
> +
>  struct psci_fns {
>         u32 cpu_suspend;
>         u32 cpu_off;
> @@ -103,7 +116,7 @@ static int setup_fdt(struct kvm *kvm)
>  {
>         struct device_header *dev_hdr;
>         u8 staging_fdt[FDT_MAX_SIZE];
> -       u64 mem_reg_prop[]      = {
> +       u64 resv_mem_prop, mem_reg_prop[] = {
>                 cpu_to_fdt64(kvm->arch.memory_guest_start),
>                 cpu_to_fdt64(kvm->ram_size),
>         };
> @@ -116,6 +129,9 @@ static int setup_fdt(struct kvm *kvm)
>         void (*generate_cpu_peripheral_fdt_nodes)(void *, struct kvm *)
>                                         = kvm->cpus[0]->generate_fdt_nodes;
>
> +       /* Generate DMA regions for bouncing in protected VMs */
> +       emit_dma_regions = kvm->cfg.arch.protected;
> +
>         /* Create new tree without a reserve map */
>         _FDT(fdt_create(fdt, FDT_MAX_SIZE));
>         _FDT(fdt_finish_reservemap(fdt));
> @@ -162,6 +178,23 @@ static int setup_fdt(struct kvm *kvm)
>         _FDT(fdt_property(fdt, "reg", mem_reg_prop, sizeof(mem_reg_prop)));
>         _FDT(fdt_end_node(fdt));
>
> +       /* Reserved memory (restricted DMA pool) */
> +       if (emit_dma_regions) {
> +               _FDT(fdt_begin_node(fdt, "reserved-memory"));
> +               _FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
> +               _FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
> +               _FDT(fdt_property(fdt, "ranges", NULL, 0));
> +
> +               _FDT(fdt_begin_node(fdt, "restricted_dma_reserved"));
> +               _FDT(fdt_property_string(fdt, "compatible", "restricted-dma-pool"));
> +               resv_mem_prop = cpu_to_fdt64(DMA_MEM_REGION_SIZE);
> +               _FDT(fdt_property(fdt, "size", &resv_mem_prop, sizeof(resv_mem_prop)));
> +               _FDT(fdt_property_cell(fdt, "phandle", PHANDLE_DMA));
> +               _FDT(fdt_end_node(fdt));
> +
> +               _FDT(fdt_end_node(fdt));
> +       }
> +
>         /* CPU and peripherals (interrupt controller, timers, etc) */
>         generate_cpu_nodes(fdt, kvm);
>         if (generate_cpu_peripheral_fdt_nodes)
> @@ -172,7 +205,7 @@ static int setup_fdt(struct kvm *kvm)
>         while (dev_hdr) {
>                 generate_mmio_fdt_nodes = dev_hdr->data;
>                 if (generate_mmio_fdt_nodes) {
> -                       generate_mmio_fdt_nodes(fdt, dev_hdr, generate_irq_prop);
> +                       generate_mmio_fdt_nodes(fdt, dev_hdr, generate_aux_props);
>                 } else {
>                         pr_debug("Missing FDT node generator for MMIO device %d",
>                                  dev_hdr->dev_num);
> diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
> index 60c2d40..8a0a460 100644
> --- a/arm64/include/kvm/fdt-arch.h
> +++ b/arm64/include/kvm/fdt-arch.h
> @@ -1,6 +1,14 @@
>  #ifndef ARM__FDT_H
>  #define ARM__FDT_H
>
> -enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLES_MAX};
> +enum phandles {
> +       PHANDLE_RESERVED = 0,
> +       PHANDLE_GIC,
> +       PHANDLE_MSI,
> +       PHANDLE_DMA,
> +       PHANDLES_MAX
> +};
> +
> +void generate_dma_region_prop(void *fdt);
>
>  #endif /* ARM__FDT_H */
> diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
> index a50e6a4..e7dd526 100644
> --- a/arm64/include/kvm/kvm-arch.h
> +++ b/arm64/include/kvm/kvm-arch.h
> @@ -87,6 +87,8 @@
>
>  #define MAX_PAGE_SIZE  SZ_64K
>
> +/* Size of DMA region for bouncing when running a protected guest */
> +#define DMA_MEM_REGION_SIZE    SZ_32M

Worth scaling with guest RAM, or making it overridable for DMA-heavy guests?

>
>  static inline bool arm_addr_in_ioport_region(u64 phys_addr)
>  {
> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> index d321b77..c2702d5 100644
> --- a/arm64/include/kvm/kvm-config-arch.h
> +++ b/arm64/include/kvm/kvm-config-arch.h
> @@ -19,6 +19,7 @@ struct kvm_config_arch {
>         unsigned int    sve_max_vq;
>         bool            no_pvtime;
>         bool            psci;
> +       bool            protected;
>  };
>
>  int irqchip_parser(const struct option *opt, const char *arg, int unset);
> @@ -70,6 +71,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>         OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,                        \
>                     "Start VCPUs in EL2 (for nested virt)"),                    \
>         OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,                                 \
> -                   "Create guest without VHE support"),
> +                   "Create guest without VHE support"),                        \
> +       OPT_BOOLEAN('\0', "protected", &(cfg)->protected,                       \
> +                       "Create a protected VM when pKVM is enabled"),
>
>  #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index c8570ce..b899ebd 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -6,6 +6,7 @@
>  #include "kvm/fdt.h"
>  #include "kvm/gic.h"
>  #include "kvm/kvm-cpu.h"
> +#include "kvm/virtio.h"
>
>  #include "asm/smccc.h"
>
> @@ -147,6 +148,9 @@ void kvm__arch_init(struct kvm *kvm)
>         kvm__arch_enable_mte(kvm);
>         kvm__setup_smccc(kvm);
>         kvm__arch_set_counter_offset(kvm);
> +
> +       if (kvm->cfg.arch.protected)
> +               virtio_modern_enable_feat_access_platform();
>  }
>
>
> @@ -463,6 +467,16 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
>
>         if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
>                 pr_warning("--e2h0 requires --nested, ignoring");
> +
> +       if (kvm->cfg.arch.protected) {
> +               if (kvm->cfg.virtio_transport == VIRTIO_MMIO_LEGACY ||
> +                   kvm->cfg.virtio_transport == VIRTIO_PCI_LEGACY) {
> +                       die("Protected VMs require a modern virtio transport");
> +               }
> +
> +               if (kvm->cfg.balloon)
> +                       die("Ballooning not supported with protected VMs");
> +       }
>  }
>
>  u64 kvm__arch_default_ram_address(void)
> @@ -485,6 +499,7 @@ int kvm__get_vm_type(struct kvm *kvm)
>  {
>         unsigned int ipa_bits, max_ipa_bits;
>         unsigned long max_ipa;
> +       int type;
>
>         /* If we're running on an old kernel, use 0 as the VM type */
>         max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
> @@ -500,7 +515,10 @@ int kvm__get_vm_type(struct kvm *kvm)
>         if (ipa_bits > max_ipa_bits)
>                 die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
>
> -       return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
> +       type = KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
> +       if (kvm->cfg.arch.protected)
> +               type |= KVM_VM_TYPE_ARM_PROTECTED;
> +       return type;
>  }

The "old kernel" path above returns type 0, so --protected is dropped there
silently. die() rather than downgrade a protection request without a word?

>
>  static int kvm__arch_free_kernel_header(struct kvm *kvm)
> diff --git a/arm64/pci.c b/arm64/pci.c
> index 0366783..db87db8 100644
> --- a/arm64/pci.c
> +++ b/arm64/pci.c
> @@ -73,6 +73,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>         if (irqchip == IRQCHIP_GICV2M || irqchip == IRQCHIP_GICV3_ITS)
>                 _FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
>
> +       generate_dma_region_prop(fdt);
> +
>         /* Generate the interrupt map ... */
>         dev_hdr = device__first_dev(DEVICE_BUS_PCI);
>         while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>
