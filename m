Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70503C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 17:08:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A4934B315;
	Thu, 16 Jun 2022 13:08:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CM83L5Vbsd0T; Thu, 16 Jun 2022 13:08:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3E4D4B2B7;
	Thu, 16 Jun 2022 13:08:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B93A4B297
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:08:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id guWZFRmmUbTW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 13:08:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA704B28C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:08:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F23D411FB;
 Thu, 16 Jun 2022 10:08:00 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A30863F73B;
 Thu, 16 Jun 2022 10:07:59 -0700 (PDT)
Date: Thu, 16 Jun 2022 18:07:56 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v4 kvmtool 02/12] builtin-run: Always use RAM size in bytes
Message-ID: <20220616180756.6402b88d@donnerap.cambridge.arm.com>
In-Reply-To: <20220616134828.129006-3-alexandru.elisei@arm.com>
References: <20220616134828.129006-1-alexandru.elisei@arm.com>
 <20220616134828.129006-3-alexandru.elisei@arm.com>
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

On Thu, 16 Jun 2022 14:48:18 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> The user can specify the virtual machine memory size in MB, which is saved
> in cfg->ram_size. kvmtool validates it against the host memory size,
> converted from bytes to MB. ram_size is then converted to bytes, and this
> is how it is used throughout the rest of kvmtool.
> 
> To avoid any confusion about the unit of measurement, especially once the
> user is allowed to specify the unit of measurement, always use ram_size in
> bytes.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

That looks good to me now, many thanks for the changes!
I ran a few large VMs (up to 1TB guest), also tested on an ARM32 host, it
all seems to still work fine, and no UBSAN messages.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre


> ---
>  builtin-run.c            | 19 ++++++++++---------
>  include/kvm/kvm-config.h |  7 ++++---
>  include/kvm/kvm.h        |  2 +-
>  3 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index 0126c9fbcba6..2bf93fe13c92 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -36,6 +36,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/err.h>
> +#include <linux/sizes.h>
>  
>  #include <sys/utsname.h>
>  #include <sys/types.h>
> @@ -264,7 +265,7 @@ static u64 host_ram_size(void)
>  		return 0;
>  	}
>  
> -	return (nr_pages * page_size) >> MB_SHIFT;
> +	return (u64)nr_pages * page_size;
>  }
>  
>  /*
> @@ -278,11 +279,11 @@ static u64 get_ram_size(int nr_cpus)
>  	u64 available;
>  	u64 ram_size;
>  
> -	ram_size	= 64 * (nr_cpus + 3);
> +	ram_size	= (u64)SZ_64M * (nr_cpus + 3);
>  
>  	available	= host_ram_size() * RAM_SIZE_RATIO;
>  	if (!available)
> -		available = MIN_RAM_SIZE_MB;
> +		available = MIN_RAM_SIZE;
>  
>  	if (ram_size > available)
>  		ram_size	= available;
> @@ -595,13 +596,13 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>  
>  	if (!kvm->cfg.ram_size)
>  		kvm->cfg.ram_size = get_ram_size(kvm->cfg.nrcpus);
> +	else
> +		kvm->cfg.ram_size <<= MB_SHIFT;
>  
>  	if (kvm->cfg.ram_size > host_ram_size())
>  		pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",
> -			(unsigned long long)kvm->cfg.ram_size,
> -			(unsigned long long)host_ram_size());
> -
> -	kvm->cfg.ram_size <<= MB_SHIFT;
> +			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> +			(unsigned long long)host_ram_size() >> MB_SHIFT);
>  
>  	if (!kvm->cfg.dev)
>  		kvm->cfg.dev = DEFAULT_KVM_DEV;
> @@ -676,12 +677,12 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>  	if (kvm->cfg.kernel_filename) {
>  		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
>  		       kvm->cfg.kernel_filename,
> -		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
> +		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
>  		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
>  	} else if (kvm->cfg.firmware_filename) {
>  		printf("  # %s run --firmware %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
>  		       kvm->cfg.firmware_filename,
> -		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
> +		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
>  		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
>  	}
>  
> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> index 6a5720c4c7d4..31bc89520d52 100644
> --- a/include/kvm/kvm-config.h
> +++ b/include/kvm/kvm-config.h
> @@ -5,6 +5,8 @@
>  #include "kvm/vfio.h"
>  #include "kvm/kvm-config-arch.h"
>  
> +#include <linux/sizes.h>
> +
>  #define DEFAULT_KVM_DEV		"/dev/kvm"
>  #define DEFAULT_CONSOLE		"serial"
>  #define DEFAULT_NETWORK		"user"
> @@ -15,14 +17,13 @@
>  #define DEFAULT_SCRIPT		"none"
>  #define DEFAULT_SANDBOX_FILENAME "guest/sandbox.sh"
>  
> -#define MIN_RAM_SIZE_MB		(64ULL)
> -#define MIN_RAM_SIZE_BYTE	(MIN_RAM_SIZE_MB << MB_SHIFT)
> +#define MIN_RAM_SIZE		SZ_64M
>  
>  struct kvm_config {
>  	struct kvm_config_arch arch;
>  	struct disk_image_params disk_image[MAX_DISK_IMAGES];
>  	struct vfio_device_params *vfio_devices;
> -	u64 ram_size;
> +	u64 ram_size;		/* Guest memory size, in bytes */
>  	u8 num_net_devices;
>  	u8 num_vfio_devices;
>  	u64 vsock_cid;
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index ad732e56f5ed..7b14b33b50ca 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -87,7 +87,7 @@ struct kvm {
>  	struct kvm_cpu		**cpus;
>  
>  	u32			mem_slots;	/* for KVM_SET_USER_MEMORY_REGION */
> -	u64			ram_size;
> +	u64			ram_size;	/* Guest memory size, in bytes */
>  	void			*ram_start;
>  	u64			ram_pagesize;
>  	struct mutex		mem_banks_lock;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
