Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D262DC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 17:20:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AE2840CDE;
	Fri, 20 May 2022 13:20:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vr7ZSFNR5JmG; Fri, 20 May 2022 13:20:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF72749E08;
	Fri, 20 May 2022 13:20:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C016C40CDE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 13:20:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3W0SO5A4CeXr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 13:20:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3E64076A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 13:20:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8682C1477;
 Fri, 20 May 2022 10:20:19 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F2473F718;
 Fri, 20 May 2022 10:20:18 -0700 (PDT)
Date: Fri, 20 May 2022 18:20:15 +0100
From: Andre Przywara <andre.przywara@foss.arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 kvmtool 12/12] arm64: Allow the user to specify the
 RAM base address
Message-ID: <20220520182015.3e8948b8@donnerap.cambridge.arm.com>
In-Reply-To: <20220516155526.181694-13-alexandru.elisei@arm.com>
References: <20220516155526.181694-1-alexandru.elisei@arm.com>
 <20220516155526.181694-13-alexandru.elisei@arm.com>
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

On Mon, 16 May 2022 16:55:26 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> Allow the user to specify the RAM base address by using -m/--mem size@addr
> command line argument. The base address must be above 2GB, as to not
> overlap with the MMIO I/O region.

Just started to play with this, in general the series looks good to me on
a first glance. I will review in anger next week.
Meanwhile: when you start kvmtool without explicitly specifying a ram size
on the command line, the code misses to initialise cfg.ram_addr, so it
stays at 0 and kvmtool reports:
  Fatal: RAM address is below 2GB
One possible fix would be to initialise this in get_ram_size() to
kvm__arch_default_ram_address(), I guess, but you might find a better solution.

Cheers,
Andre

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/aarch64/include/kvm/kvm-arch.h |  2 ++
>  arm/aarch64/kvm.c                  |  5 ++++-
>  arm/kvm.c                          |  7 +++++--
>  builtin-run.c                      | 29 +++++++++++++++++++++++++----
>  include/kvm/kvm-config.h           |  1 +
>  include/kvm/kvm.h                  | 12 ++++++++++++
>  6 files changed, 49 insertions(+), 7 deletions(-)
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
> index af8e7eae0da2..14ffae9e39dc 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -44,6 +44,9 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
>  		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
>  		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
>  	}
> +
> +	if (kvm->cfg.ram_addr < ARM_MEMORY_AREA)
> +		die("RAM address is below %luGB", ARM_MEMORY_AREA >> 30);
>  }
>  
>  u64 kvm__arch_default_ram_address(void)
> @@ -117,7 +120,7 @@ int kvm__get_vm_type(struct kvm *kvm)
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
> index 57c58be55159..26e6e9974009 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -131,12 +131,22 @@ static u64 parse_mem_option(const char *nptr, char **next)
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
> +	kvm->cfg.ram_addr = kvm__arch_default_ram_address();
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
> @@ -147,15 +157,26 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
