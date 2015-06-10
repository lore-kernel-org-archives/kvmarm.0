From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 6/8] arm: prepare for instantiating different IRQ chip
 devices
Date: Wed, 10 Jun 2015 18:21:23 +0100
Message-ID: <55787213.30002@arm.com>
References: <1433493473-4002-1-git-send-email-andre.przywara@arm.com> <1433493473-4002-7-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433493473-4002-7-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <Will.Deacon@arm.com>, "penberg@kernel.org" <penberg@kernel.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/06/15 09:37, Andre Przywara wrote:
> Extend the vGIC handling code to potentially deal with different IRQ
> chip devices instead of hard-coding the GICv2 in.
> We extend most vGIC functions to take a type parameter, but still put
> GICv2 in at the top for the time being.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/aarch32/arm-cpu.c        |  2 +-
>  arm/aarch64/arm-cpu.c        |  2 +-
>  arm/gic.c                    | 66 ++++++++++++++++++++++++++++++++++----------
>  arm/include/arm-common/gic.h |  6 ++--
>  arm/kvm.c                    |  2 +-
>  5 files changed, 58 insertions(+), 20 deletions(-)
> 
> diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
> index 946e443..d8d6293 100644
> --- a/arm/aarch32/arm-cpu.c
> +++ b/arm/aarch32/arm-cpu.c
> @@ -12,7 +12,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm, u32 gic_phandle)
>  {
>  	int timer_interrupts[4] = {13, 14, 11, 10};
>  
> -	gic__generate_fdt_nodes(fdt, gic_phandle);
> +	gic__generate_fdt_nodes(fdt, gic_phandle, IRQCHIP_GICV2);
>  	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
>  }
>  
> diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> index 8efe877..f702b9e 100644
> --- a/arm/aarch64/arm-cpu.c
> +++ b/arm/aarch64/arm-cpu.c
> @@ -12,7 +12,7 @@
>  static void generate_fdt_nodes(void *fdt, struct kvm *kvm, u32 gic_phandle)
>  {
>  	int timer_interrupts[4] = {13, 14, 11, 10};
> -	gic__generate_fdt_nodes(fdt, gic_phandle);
> +	gic__generate_fdt_nodes(fdt, gic_phandle, IRQCHIP_GICV2);
>  	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
>  }
>  
> diff --git a/arm/gic.c b/arm/gic.c
> index 8d47562..0ce40e4 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -11,13 +11,13 @@
>  
>  static int gic_fd = -1;
>  
> -static int gic__create_device(struct kvm *kvm)
> +static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  {
>  	int err;
>  	u64 cpu_if_addr = ARM_GIC_CPUI_BASE;
>  	u64 dist_addr = ARM_GIC_DIST_BASE;
>  	struct kvm_create_device gic_device = {
> -		.type	= KVM_DEV_TYPE_ARM_VGIC_V2,
> +		.flags	= 0,
>  	};
>  	struct kvm_device_attr cpu_if_attr = {
>  		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
> @@ -26,21 +26,37 @@ static int gic__create_device(struct kvm *kvm)
>  	};
>  	struct kvm_device_attr dist_attr = {
>  		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
> -		.attr	= KVM_VGIC_V2_ADDR_TYPE_DIST,
>  		.addr	= (u64)(unsigned long)&dist_addr,
>  	};
>  
> +	switch (type) {
> +	case IRQCHIP_GICV2:
> +		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V2;
> +		break;
> +	default:
> +		return -ENODEV;
> +	}
> +
>  	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &gic_device);
>  	if (err)
>  		return err;
>  
>  	gic_fd = gic_device.fd;
>  
> -	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
> +	switch (type) {
> +	case IRQCHIP_GICV2:
> +		dist_attr.attr = KVM_VGIC_V2_ADDR_TYPE_DIST;

You could move the structure patching in the first switch statement.

> +		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
> +		break;
> +	default:
> +		return -ENODEV;

This default cannot be reached, as you've already caught the weird stuff
above.

> +	}
>  	if (err)
>  		return err;
>  
> -	return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
> +	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
> +
> +	return err;
>  }
>  
>  static int gic__create_irqchip(struct kvm *kvm)
> @@ -71,19 +87,28 @@ static int gic__create_irqchip(struct kvm *kvm)
>  	return err;
>  }
>  
> -int gic__create(struct kvm *kvm)
> +int gic__create(struct kvm *kvm, enum irqchip_type type)
>  {
> +	int max_cpus;
>  	int err;
>  
> -	if (kvm->nrcpus > GIC_MAX_CPUS) {
> +	switch (type) {
> +	case IRQCHIP_GICV2:
> +		max_cpus = GIC_MAX_CPUS;
> +		break;
> +	default:
> +		return -ENODEV;
> +	}
> +
> +	if (kvm->nrcpus > max_cpus) {
>  		pr_warning("%d CPUS greater than maximum of %d -- truncating\n",
> -				kvm->nrcpus, GIC_MAX_CPUS);
> -		kvm->nrcpus = GIC_MAX_CPUS;
> +				kvm->nrcpus, max_cpus);
> +		kvm->nrcpus = max_cpus;
>  	}
>  
>  	/* Try the new way first, and fallback on legacy method otherwise */
> -	err = gic__create_device(kvm);
> -	if (err)
> +	err = gic__create_device(kvm, type);
> +	if (err && type == IRQCHIP_GICV2)
>  		err = gic__create_irqchip(kvm);
>  
>  	return err;
> @@ -131,15 +156,26 @@ static int gic__init_gic(struct kvm *kvm)
>  }
>  late_init(gic__init_gic)
>  
> -void gic__generate_fdt_nodes(void *fdt, u32 phandle)
> +void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
>  {
> +	const char *compatible;
>  	u64 reg_prop[] = {
> -		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
> -		cpu_to_fdt64(ARM_GIC_CPUI_BASE), cpu_to_fdt64(ARM_GIC_CPUI_SIZE),
> +		cpu_to_fdt64(ARM_GIC_DIST_BASE),
> +		cpu_to_fdt64(ARM_GIC_DIST_SIZE),
> +		cpu_to_fdt64(ARM_GIC_CPUI_BASE),
> +		cpu_to_fdt64(ARM_GIC_CPUI_SIZE),
>  	};

Any particular reason for this change? I found the original more readable...

>  
> +	switch (type) {
> +	case IRQCHIP_GICV2:
> +		compatible = "arm,cortex-a15-gic";
> +		break;
> +	default:
> +		return;
> +	}
> +
>  	_FDT(fdt_begin_node(fdt, "intc"));
> -	_FDT(fdt_property_string(fdt, "compatible", "arm,cortex-a15-gic"));
> +	_FDT(fdt_property_string(fdt, "compatible", compatible));
>  	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
>  	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
>  	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
> diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
> index 44859f7..f5f6707 100644
> --- a/arm/include/arm-common/gic.h
> +++ b/arm/include/arm-common/gic.h
> @@ -21,10 +21,12 @@
>  #define GIC_MAX_CPUS			8
>  #define GIC_MAX_IRQ			255
>  
> +enum irqchip_type {IRQCHIP_DEFAULT, IRQCHIP_GICV2};
> +

Can you use the standard enum style:

enum blah {
	E1,
	E2,
};

>  struct kvm;
>  
>  int gic__alloc_irqnum(void);
> -int gic__create(struct kvm *kvm);
> -void gic__generate_fdt_nodes(void *fdt, u32 phandle);
> +int gic__create(struct kvm *kvm, enum irqchip_type type);
> +void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type);
>  
>  #endif /* ARM_COMMON__GIC_H */
> diff --git a/arm/kvm.c b/arm/kvm.c
> index bcd2533..f9685c2 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -82,6 +82,6 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>  		MADV_MERGEABLE | MADV_HUGEPAGE);
>  
>  	/* Create the virtual GIC. */
> -	if (gic__create(kvm))
> +	if (gic__create(kvm, IRQCHIP_GICV2))
>  		die("Failed to create virtual GIC");
>  }
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
