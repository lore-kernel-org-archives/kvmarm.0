From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 6/6] arm: Support non-volatile memory
Date: Fri, 14 Dec 2018 18:09:20 +0000
Message-ID: <20181214180920.269698e0@donnerap.cambridge.arm.com>
References: <1543922073-55530-1-git-send-email-julien.thierry@arm.com>
 <1543922073-55530-7-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6D054A327
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Dec 2018 13:09:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id upSCOkqi2Zqx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Dec 2018 13:09:24 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B778E4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Dec 2018 13:09:24 -0500 (EST)
In-Reply-To: <1543922073-55530-7-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue,  4 Dec 2018 11:14:33 +0000
Julien Thierry <julien.thierry@arm.com> wrote:

Hi,

> Add an option to let user load files as non-volatile memory.
> 
> An additional range of addresses is reserved for nv memory.
> Loaded files must be a multiple of the system page size.
> 
> Users can chose whether the data written by the guest modifies the
> original file.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> ---
>  arm/fdt.c                                |  43 ++++++++++
>  arm/include/arm-common/kvm-arch.h        |   5 +-
>  arm/include/arm-common/kvm-config-arch.h |  18 ++++-
>  arm/kvm.c                                | 134
> +++++++++++++++++++++++++++++++ 4 files changed, 198 insertions(+), 2
> deletions(-)
> 
> diff --git a/arm/fdt.c b/arm/fdt.c
> index 2936986..fd482ce 100644
> --- a/arm/fdt.c
> +++ b/arm/fdt.c
> @@ -72,6 +72,46 @@ static void generate_irq_prop(void *fdt, u8 irq,
> enum irq_type irq_type) _FDT(fdt_property(fdt, "interrupts",
> irq_prop, sizeof(irq_prop))); }
>  
> +static void generate_nvmem_node(void *fdt, struct kvm_nv_mem *nvmem)
> +{
> +	char *buf;
> +	int len;
> +	const u64 reg_prop[] = {
> +		cpu_to_fdt64(nvmem->map_addr),
> +		cpu_to_fdt64(nvmem->size)
> +	};
> +
> +	/* Name length + '@' + 8 hex characters + '\0' */
> +	len = strlen(nvmem->name) + 10;
> +	buf = malloc(len);
> +	snprintf(buf, len, "%s@%llx", nvmem->name,
> +		 nvmem->map_addr);
> +	_FDT(fdt_begin_node(fdt, buf));
> +	free(buf);
> +
> +	/* Name length + "kvmtool," + '\0' */
> +	len = strlen(nvmem->name) + 9;
> +	buf = malloc(len);
> +	snprintf(buf, len, "kvmtool,%s", nvmem->name);
> +	_FDT(fdt_property_string(fdt, "compatible", buf));

As discussed in person, it doesn't sound right to (ab)use the
compatible name for this. This one should describe a device type, not
an instance of it.
So I would suggest to use a fixed compatible name (say:
"kvmtool,flash"), then put the designator in a property.
	flash@7f000000 {
		compatible = "kvmtool,flash";
		label = "environment";
		reg = <0 0x7f000000 0 0x10000>;
	};
So the label property would reflect the user provided name.
Also there is the generic "read-only" property, which we might want to
use in case "wb" is not provided.

I am not overly happy with inventing a new compatible name for such a
generic device, but couldn't find anything better (mtd-ram, mtd-rom,
cfi-flash were close, but not a complete fit). Also given that the idea
is to just communicate this from kvmtool to EDK II (without Linux ever
picking this up), I guess this solution works.

Cheers,
Andre,

> +	free(buf);
> +
> +	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
> +
> +	_FDT(fdt_end_node(fdt));
> +}
> +
> +static void generate_nvmem_nodes(void *fdt, struct kvm *kvm)
> +{
> +	struct list_head *nvmem_node;
> +
> +	list_for_each(nvmem_node, &kvm->cfg.arch.nvmem_list)
> +		generate_nvmem_node(fdt,
> +				    container_of(nvmem_node,
> +					         struct kvm_nv_mem,
> +					         node));
> +}
> +
>  struct psci_fns {
>  	u32 cpu_suspend;
>  	u32 cpu_off;
> @@ -210,6 +250,9 @@ static int setup_fdt(struct kvm *kvm)
>  	_FDT(fdt_property_cell(fdt, "migrate", fns->migrate));
>  	_FDT(fdt_end_node(fdt));
>  
> +	/* Non volatile memories */
> +	generate_nvmem_nodes(fdt, kvm);
> +
>  	/* Finalise. */
>  	_FDT(fdt_end_node(fdt));
>  	_FDT(fdt_finish(fdt));
> diff --git a/arm/include/arm-common/kvm-arch.h
> b/arm/include/arm-common/kvm-arch.h index b9d486d..f425d86 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -10,6 +10,7 @@
>  #define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
>  #define ARM_MMIO_AREA		_AC(0x0000000000010000, UL)
>  #define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
> +#define ARM_NVRAM_AREA		_AC(0x000000007f000000, UL)
>  #define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
>  
>  #define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
> @@ -24,9 +25,11 @@
>  #define ARM_IOPORT_SIZE		(ARM_MMIO_AREA -
> ARM_IOPORT_AREA) #define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA -
> (ARM_MMIO_AREA + ARM_GIC_SIZE)) #define ARM_PCI_CFG_SIZE	(1ULL
> << 24) -#define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
> +#define ARM_PCI_MMIO_SIZE	(ARM_NVRAM_AREA - \
>  				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
>  
> +#define ARM_NVRAM_SIZE		(ARM_MEMORY_AREA -
> ARM_NVRAM_AREA) +
>  #define KVM_IOPORT_AREA		ARM_IOPORT_AREA
>  #define KVM_PCI_CFG_AREA	ARM_AXI_AREA
>  #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA +
> ARM_PCI_CFG_SIZE) diff --git
> a/arm/include/arm-common/kvm-config-arch.h
> b/arm/include/arm-common/kvm-config-arch.h index 5734c46..d5742cb
> 100644 --- a/arm/include/arm-common/kvm-config-arch.h +++
> b/arm/include/arm-common/kvm-config-arch.h @@ -1,8 +1,18 @@
>  #ifndef ARM_COMMON__KVM_CONFIG_ARCH_H
>  #define ARM_COMMON__KVM_CONFIG_ARCH_H
>  
> +#include <linux/list.h>
>  #include "kvm/parse-options.h"
>  
> +struct kvm_nv_mem {
> +	char			*data_file;
> +	char			*name;
> +	ssize_t			size;
> +	u64			map_addr;
> +	bool			write_back;
> +	struct list_head	node;
> +};
> +
>  struct kvm_config_arch {
>  	const char	*dump_dtb_filename;
>  	unsigned int	force_cntfrq;
> @@ -12,9 +22,11 @@ struct kvm_config_arch {
>  	u64		kaslr_seed;
>  	enum irqchip_type irqchip;
>  	u64		fw_addr;
> +	struct list_head nvmem_list;
>  };
>  
>  int irqchip_parser(const struct option *opt, const char *arg, int
> unset); +int nvmem_parser(const struct option *opt, const char *arg,
> int unset); 
>  #define OPT_ARCH_RUN(pfx,
> cfg)							\
> pfx,
> \ @@ -33,6 +45,10 @@ int irqchip_parser(const struct option *opt,
> const char *arg, int unset); "Type of interrupt controller to emulate
> in the guest",	\ irqchip_parser,
> NULL),					\ OPT_U64('\0',
> "firmware-address", &(cfg)->fw_addr,			\
> -		"Address where firmware should be loaded"),
> +		"Address where firmware should be
> loaded"),			\
> +	OPT_CALLBACK('\0', "nvmem",
> NULL,					\
> +
> "<file>,<name>[,wb]",					\
> +		     "Load <file> as non-volatile memory
> kvmtool,<name>",	\
> +		     nvmem_parser, kvm),
>  
>  #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> diff --git a/arm/kvm.c b/arm/kvm.c
> index 1a2cfdc..00675d9 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -18,6 +18,53 @@ struct kvm_ext kvm_req_ext[] = {
>  	{ 0, 0 },
>  };
>  
> +int nvmem_parser(const struct option *opt, const char *arg, int
> unset) +{
> +	struct kvm *kvm = (struct kvm*) opt->ptr;
> +	struct kvm_nv_mem *nvmem;
> +	struct stat st;
> +	const char *ptr;
> +	uint32_t len;
> +
> +	nvmem = calloc(sizeof (*nvmem), 1);
> +
> +	if (!nvmem)
> +		die("nvmem: cannot add non-volatile memory");
> +
> +	ptr = strstr(arg, ",");
> +
> +	if (!ptr)
> +		die("nvmem: missing name for non-volatile memory");
> +
> +	len = ptr - arg + 1;
> +	nvmem->data_file = malloc(len);
> +	strncpy(nvmem->data_file, arg, len);
> +	nvmem->data_file[len - 1] = '\0';
> +
> +	if (stat(nvmem->data_file, &st))
> +		die("nvmem: failed to stat data file");
> +	nvmem->size = st.st_size;
> +
> +	arg = arg + len;
> +	for (ptr = arg; *ptr != '\0' && *ptr != ','; ++ptr)
> +		;
> +	len = ptr - arg + 1;
> +	nvmem->name = malloc(len);
> +	strncpy(nvmem->name, arg, len);
> +	nvmem->name[len - 1] = '\0';
> +
> +	if (*ptr == ',') {
> +		if (!strcmp(ptr + 1, "wb"))
> +			nvmem->write_back = true;
> +		else
> +			die("firmware-data: invalid option %s", ptr
> + 1);
> +	}
> +
> +	list_add(&nvmem->node, &kvm->cfg.arch.nvmem_list);
> +
> +	return 0;
> +}
> +
>  bool kvm__arch_cpu_supports_vm(void)
>  {
>  	/* The KVM capability check is enough. */
> @@ -59,6 +106,7 @@ void kvm__arch_set_cmdline(char *cmdline, bool
> video) 
>  void kvm__arch_reset(struct kvm *kvm)
>  {
> +	INIT_LIST_HEAD(&kvm->cfg.arch.nvmem_list);
>  }
>  
>  void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64
> ram_size) @@ -238,3 +286,89 @@ int kvm__arch_setup_firmware(struct
> kvm *kvm) {
>  	return 0;
>  }
> +
> +static int setup_nvmem(struct kvm *kvm)
> +{
> +	u64 map_address = ARM_NVRAM_AREA;
> +	const u64 limit = ARM_NVRAM_AREA + ARM_NVRAM_SIZE;
> +	struct list_head *nvmem_node;
> +	const int pagesize = getpagesize();
> +
> +	list_for_each(nvmem_node, &kvm->cfg.arch.nvmem_list) {
> +		struct kvm_nv_mem *nvmem = container_of(nvmem_node,
> +							struct
> kvm_nv_mem,
> +							node);
> +		void *user_addr;
> +		int fd;
> +
> +		if (map_address + nvmem->size > limit)
> +			die("cannot map file %s in non-volatile
> memory, no space left",
> +			    nvmem->data_file);
> +
> +		if (nvmem->size & (pagesize - 1))
> +			die("size of non-volatile memory files must
> be a multiple of system page size (= %d)",
> +			    pagesize);
> +
> +		user_addr = mmap(NULL, nvmem->size, PROT_RW,
> MAP_ANON_NORESERVE, -1, 0);
> +		if (user_addr == MAP_FAILED)
> +			die("cannot create mapping for file %s",
> +			     nvmem->data_file);
> +
> +		fd = open(nvmem->data_file, O_RDONLY);
> +		if (fd < 0)
> +			die("cannot read file %s", nvmem->data_file);
> +		if (read_file(fd, user_addr, nvmem->size) < 0)
> +			die("failed to map nv memory data %s",
> +			    nvmem->data_file);
> +		close(fd);
> +
> +		if (kvm__register_dev_mem(kvm, map_address,
> nvmem->size,
> +					  user_addr))
> +			die("failed to register nv memory mapping
> for guest"); +
> +		nvmem->map_addr = map_address;
> +		map_address += nvmem->size;
> +	}
> +
> +	return 0;
> +}
> +firmware_init(setup_nvmem);
> +
> +static int flush_nv_mem(struct kvm *kvm)
> +{
> +	struct list_head *nvmem_node;
> +	int err = 0;
> +
> +	list_for_each(nvmem_node, &kvm->cfg.arch.nvmem_list) {
> +		struct kvm_nv_mem *nvmem = container_of(nvmem_node,
> +							struct
> kvm_nv_mem,
> +							node);
> +		void *host_pos;
> +
> +		host_pos = guest_flat_to_host(kvm,
> +					      nvmem->map_addr);
> +
> +		if (nvmem->write_back) {
> +			int fd;
> +
> +			fd = open(nvmem->data_file, O_WRONLY);
> +			if (fd < 0) {
> +				pr_err("failed to open firmware data
> file for writting");
> +				err = -1;
> +				continue;
> +			}
> +
> +			if (write_in_full(fd, host_pos, nvmem->size)
> < 0) {
> +				pr_err("failed to flush firmware
> data to file");
> +				err = -1;
> +			}
> +			close(fd);
> +		}
> +
> +		if (munmap(host_pos, nvmem->size))
> +			err = -1;
> +	}
> +
> +	return err;
> +}
> +firmware_exit(flush_nv_mem);
