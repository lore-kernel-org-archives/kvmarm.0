Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225C0C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 13:40:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9304B2B9;
	Wed,  1 Jun 2022 09:40:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5o8tNn6IzzrG; Wed,  1 Jun 2022 09:40:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1394549E33;
	Wed,  1 Jun 2022 09:40:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AF624B387
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 09:40:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xj2y7fH1XJDH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jun 2022 09:40:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A00D04088C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 09:40:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 311351516;
 Wed,  1 Jun 2022 06:40:35 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEAA03F73D;
 Wed,  1 Jun 2022 06:40:33 -0700 (PDT)
Date: Wed, 1 Jun 2022 14:39:21 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 kvmtool 13/13] arm64: Allow the user to specify the
 RAM base address
Message-ID: <20220601143921.585d5fa3@donnerap.cambridge.arm.com>
In-Reply-To: <20220525112345.121321-14-alexandru.elisei@arm.com>
References: <20220525112345.121321-1-alexandru.elisei@arm.com>
 <20220525112345.121321-14-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: julien@xen.org, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, 25 May 2022 12:23:45 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> Allow the user to specify the RAM base address by using -m/--mem size@addr
> command line argument. The base address must be above 2GB, as to not
> overlap with the MMIO I/O region.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/aarch64/include/kvm/kvm-arch.h |  2 ++
>  arm/aarch64/kvm.c                  | 14 ++++++++----
>  arm/kvm.c                          |  7 ++++--
>  builtin-run.c                      | 36 ++++++++++++++++++++++++++----
>  include/kvm/kvm-config.h           |  1 +
>  include/kvm/kvm.h                  | 12 ++++++++++
>  include/linux/sizes.h              |  2 ++
>  7 files changed, 64 insertions(+), 10 deletions(-)
> 
> diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
> index ff857ca6e7b4..02d09a413831 100644
> --- a/arm/aarch64/include/kvm/kvm-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-arch.h
> @@ -10,6 +10,8 @@ void kvm__arch_enable_mte(struct kvm *kvm);
>  
>  #define MAX_PAGE_SIZE	SZ_64K
>  
> +#define ARCH_HAS_CFG_RAM_ADDRESS	1
> +
>  #include "arm-common/kvm-arch.h"
>  
>  #endif /* KVM__KVM_ARCH_H */
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> index 357936844046..54200c9eec9d 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -4,6 +4,7 @@
>  
>  #include <linux/byteorder.h>
>  #include <linux/cpumask.h>
> +#include <linux/sizes.h>
>  
>  #include <kvm/util.h>
>  
> @@ -39,10 +40,15 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
>  
>  void kvm__arch_validate_cfg(struct kvm *kvm)
>  {
> +
> +	if (kvm->cfg.ram_addr < ARM_MEMORY_AREA) {
> +		die("RAM address is below the I/O region ending at %luGB",
> +		    ARM_MEMORY_AREA >> 30);
> +	}
> +
>  	if (kvm->cfg.arch.aarch32_guest &&
> -	    kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
> -		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
> -		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
> +	    kvm->cfg.ram_addr + kvm->cfg.ram_size > SZ_4G) {
> +		die("RAM extends above 4GB");

As mentioned in the other patch, this is actually no problem at all, but
as this patch just retains the current check, that's fine, for now.

The rest looks good, and it seems to work now.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

>  	}
>  }
>  
> @@ -117,7 +123,7 @@ int kvm__get_vm_type(struct kvm *kvm)
>  		return 0;
>  
>  	/* Otherwise, compute the minimal required IPA size */
> -	max_ipa = ARM_MEMORY_AREA + kvm->cfg.ram_size - 1;
> +	max_ipa = kvm->cfg.ram_addr + kvm->cfg.ram_size - 1;
>  	ipa_bits = max(32, fls_long(max_ipa));
>  	pr_debug("max_ipa %lx ipa_bits %d max_ipa_bits %d",
>  		 max_ipa, ipa_bits, max_ipa_bits);
> diff --git a/arm/kvm.c b/arm/kvm.c
> index abcccfabf59e..d51cc15d8b1c 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -55,7 +55,7 @@ void kvm__init_ram(struct kvm *kvm)
>  	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
>  		MADV_HUGEPAGE);
>  
> -	phys_start	= ARM_MEMORY_AREA;
> +	phys_start	= kvm->cfg.ram_addr;
>  	phys_size	= kvm->ram_size;
>  	host_mem	= kvm->ram_start;
>  
> @@ -65,6 +65,9 @@ void kvm__init_ram(struct kvm *kvm)
>  		    "address 0x%llx [err %d]", phys_size, phys_start, err);
>  
>  	kvm->arch.memory_guest_start = phys_start;
> +
> +	pr_debug("RAM created at 0x%llx - 0x%llx",
> +		 phys_start, phys_start + phys_size - 1);
>  }
>  
>  void kvm__arch_delete_ram(struct kvm *kvm)
> @@ -201,7 +204,7 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
>  
>  	/* For default firmware address, lets load it at the begining of RAM */
>  	if (fw_addr == 0)
> -		fw_addr = ARM_MEMORY_AREA;
> +		fw_addr = kvm->arch.memory_guest_start;
>  
>  	if (!validate_fw_addr(kvm, fw_addr))
>  		die("Bad firmware destination: 0x%016llx", fw_addr);
> diff --git a/builtin-run.c b/builtin-run.c
> index a49698d5b2fe..68beaaa7c06f 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -131,12 +131,21 @@ static u64 parse_mem_option(const char *nptr, char **next)
>  static int mem_parser(const struct option *opt, const char *arg, int unset)
>  {
>  	struct kvm *kvm = opt->ptr;
> -	char *next;
> +	char *next, *nptr;
>  
>  	kvm->cfg.ram_size = parse_mem_option(arg, &next);
>  	if (kvm->cfg.ram_size == 0)
>  		die("Invalid RAM size: %s", arg);
>  
> +	if (kvm__arch_has_cfg_ram_address() && *next == '@') {
> +		next++;
> +		if (*next == '\0')
> +			die("Missing memory address: %s", arg);
> +
> +		nptr = next;
> +		kvm->cfg.ram_addr = parse_mem_option(nptr, &next);
> +	}
> +
>  	if (*next != '\0')
>  		die("Invalid memory specifier: %s", arg);
>  
> @@ -147,15 +156,26 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
>  #define OPT_ARCH_RUN(...)
>  #endif
>  
> +#ifdef ARCH_HAS_CFG_RAM_ADDRESS
> +#define MEM_OPT_HELP_SHORT	"size[BKMGTP][@addr[BKMGTP]]"
> +#define MEM_OPT_HELP_LONG						\
> +	"Virtual machine memory size and optional base address, both"	\
> +	" measured by default in megabytes (M)"
> +#else
> +#define MEM_OPT_HELP_SHORT	"size[BKMGTP]"
> +#define MEM_OPT_HELP_LONG						\
> +	"Virtual machine memory size, by default measured in"		\
> +	" in megabytes (M)"
> +#endif
> +
>  #define BUILD_OPTIONS(name, cfg, kvm)					\
>  	struct option name[] = {					\
>  	OPT_GROUP("Basic options:"),					\
>  	OPT_STRING('\0', "name", &(cfg)->guest_name, "guest name",	\
>  			"A name for the guest"),			\
>  	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
> -	OPT_CALLBACK('m', "mem", NULL, "size[BKMGTP]",			\
> -		     "Virtual machine memory size, by default measured"	\
> -		     " in megabytes (M)", mem_parser, kvm),		\
> +	OPT_CALLBACK('m', "mem", NULL, MEM_OPT_HELP_SHORT,		\
> +		     MEM_OPT_HELP_LONG, mem_parser, kvm),		\
>  	OPT_CALLBACK('d', "disk", kvm, "image or rootfs_dir", "Disk "	\
>  			" image or rootfs directory", img_name_parser,	\
>  			kvm),						\
> @@ -601,6 +621,14 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>  
>  	nr_online_cpus = sysconf(_SC_NPROCESSORS_ONLN);
>  	kvm->cfg.custom_rootfs_name = "default";
> +	/*
> +	 * An architecture might allow the user to set the RAM base address to
> +	 * zero. Initialize the address before parsing the command line
> +	 * arguments, because otherwise it will be impossible to distinguish
> +	 * between the user setting the base address to zero or letting it
> +	 * unspecified.
> +	 */
> +	kvm->cfg.ram_addr = kvm__arch_default_ram_address();
>  
>  	while (argc != 0) {
>  		BUILD_OPTIONS(options, &kvm->cfg, kvm);
> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> index 31bc89520d52..45fe1caaebce 100644
> --- a/include/kvm/kvm-config.h
> +++ b/include/kvm/kvm-config.h
> @@ -23,6 +23,7 @@ struct kvm_config {
>  	struct kvm_config_arch arch;
>  	struct disk_image_params disk_image[MAX_DISK_IMAGES];
>  	struct vfio_device_params *vfio_devices;
> +	u64 ram_addr;		/* Guest memory physical base address, in bytes */
>  	u64 ram_size;		/* Guest memory size, in bytes */
>  	u8 num_net_devices;
>  	u8 num_vfio_devices;
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 360430b78b1e..eb23e2f77310 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -197,6 +197,18 @@ int kvm__arch_free_firmware(struct kvm *kvm);
>  bool kvm__arch_cpu_supports_vm(void);
>  void kvm__arch_read_term(struct kvm *kvm);
>  
> +#ifdef ARCH_HAS_CFG_RAM_ADDRESS
> +static inline bool kvm__arch_has_cfg_ram_address(void)
> +{
> +	return true;
> +}
> +#else
> +static inline bool kvm__arch_has_cfg_ram_address(void)
> +{
> +	return false;
> +}
> +#endif
> +
>  void *guest_flat_to_host(struct kvm *kvm, u64 offset);
>  u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
>  
> diff --git a/include/linux/sizes.h b/include/linux/sizes.h
> index b2b5c457cf1c..52afca02aa6e 100644
> --- a/include/linux/sizes.h
> +++ b/include/linux/sizes.h
> @@ -44,4 +44,6 @@
>  #define SZ_1G				0x40000000ULL
>  #define SZ_2G				0x80000000ULL
>  
> +#define SZ_4G				0x100000000ULL
> +
>  #endif /* __LINUX_SIZES_H__ */

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
