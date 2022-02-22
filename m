Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D58C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Feb 2022 16:20:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB2149EC5;
	Tue, 22 Feb 2022 11:20:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ASGKlVodMtnn; Tue, 22 Feb 2022 11:20:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1950449ED6;
	Tue, 22 Feb 2022 11:20:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBD3249ED5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:20:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MW7PsbRcHUOc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 11:20:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B82D49ECC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:20:29 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF900106F;
 Tue, 22 Feb 2022 08:20:28 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43E713F70D;
 Tue, 22 Feb 2022 08:20:27 -0800 (PST)
Date: Tue, 22 Feb 2022 16:20:46 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH kvmtool v3] aarch64: Add stolen time support
Message-ID: <YhUNXn3QSC/LPLc3@monolith.localdoman>
References: <YhS2Htrzwks/allO@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YhS2Htrzwks/allO@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, will@kernel.org,
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

Hi,

I think pvtime needs a command line argument to toggle it (line
--enable/disable-pvtime), with the default being enabled, for several
reasons:

- For testing purposes.

- In case the guest's (or KVM's) pvtime misbehaves (not very likeyly, I
  would say).

- The presence of this special region is not advertised in the DTB, and
  guests which are not aware of pvtime might make assumptions about the
  memory that kvmtool assigned to pvtime. For example, kvm-unit-tests uses
  a page-aligned address above RAM to get KVM to inject an abort as part of
  the selftest vectors-kernel test.

Thanks,
Alex

On Tue, Feb 22, 2022 at 10:08:30AM +0000, Sebastian Ene wrote:
> This patch adds support for stolen time by sharing a memory region
> with the guest which will be used by the hypervisor to store the stolen
> time information. The exact format of the structure stored by the
> hypervisor is described in the ARM DEN0057A document.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  Changelog since v2:
>  - Moved the AARCH64_PVTIME_* definitions from arm-common/kvm-arch.h to
>    arm64/pvtime.c as pvtime is only available for arm64.
> 
>  Changelog since v1:
>  - Removed the pvtime.h header file and moved the definitions to kvm-cpu-arch.h
>    Verified if the stolen time capability is supported before allocating
>    and mapping the memory.
> 
>  Makefile                               |  1 +
>  arm/aarch64/arm-cpu.c                  |  1 +
>  arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
>  arm/aarch64/pvtime.c                   | 89 ++++++++++++++++++++++++++
>  arm/kvm-cpu.c                          | 14 ++--
>  5 files changed, 99 insertions(+), 7 deletions(-)
>  create mode 100644 arm/aarch64/pvtime.c
> 
> diff --git a/Makefile b/Makefile
> index f251147..e9121dc 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
>  	OBJS		+= arm/aarch64/arm-cpu.o
>  	OBJS		+= arm/aarch64/kvm-cpu.o
>  	OBJS		+= arm/aarch64/kvm.o
> +	OBJS		+= arm/aarch64/pvtime.o
>  	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
>  	ARCH_INCLUDE	+= -Iarm/aarch64/include
>  
> diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> index d7572b7..326fb20 100644
> --- a/arm/aarch64/arm-cpu.c
> +++ b/arm/aarch64/arm-cpu.c
> @@ -22,6 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
>  {
>  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> +	kvm_cpu__setup_pvtime(vcpu);
>  	return 0;
>  }
>  
> diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> index 8dfb82e..b57d6e6 100644
> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> @@ -19,5 +19,6 @@
>  
>  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
>  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
>  
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> new file mode 100644
> index 0000000..247e4f3
> --- /dev/null
> +++ b/arm/aarch64/pvtime.c
> @@ -0,0 +1,89 @@
> +#include "kvm/kvm.h"
> +#include "kvm/kvm-cpu.h"
> +#include "kvm/util.h"
> +
> +#include <linux/byteorder.h>
> +#include <linux/types.h>
> +
> +#define AARCH64_PVTIME_IPA_MAX_SIZE	SZ_64K
> +#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
> +					 AARCH64_PVTIME_IPA_MAX_SIZE)
> +#define AARCH64_PVTIME_SIZE		(64)
> +
> +struct pvtime_data_priv {
> +	bool	is_supported;
> +	char	*usr_mem;
> +};
> +
> +static struct pvtime_data_priv pvtime_data = {
> +	.is_supported	= true,
> +	.usr_mem	= NULL
> +};
> +
> +static int pvtime__alloc_region(struct kvm *kvm)
> +{
> +	char *mem;
> +	int ret = 0;
> +
> +	mem = mmap(NULL, AARCH64_PVTIME_IPA_MAX_SIZE, PROT_RW,
> +		   MAP_ANON_NORESERVE, -1, 0);
> +	if (mem == MAP_FAILED)
> +		return -ENOMEM;
> +
> +	ret = kvm__register_dev_mem(kvm, AARCH64_PVTIME_IPA_START,
> +				    AARCH64_PVTIME_IPA_MAX_SIZE, mem);
> +	if (ret) {
> +		munmap(mem, AARCH64_PVTIME_IPA_MAX_SIZE);
> +		return ret;
> +	}
> +
> +	pvtime_data.usr_mem = mem;
> +	return ret;
> +}
> +
> +static int pvtime__teardown_region(struct kvm *kvm)
> +{
> +	if (pvtime_data.usr_mem == NULL)
> +		return 0;
> +
> +	kvm__destroy_mem(kvm, AARCH64_PVTIME_IPA_START,
> +			 AARCH64_PVTIME_IPA_MAX_SIZE, pvtime_data.usr_mem);
> +	munmap(pvtime_data.usr_mem, AARCH64_PVTIME_IPA_MAX_SIZE);
> +	pvtime_data.usr_mem = NULL;
> +	return 0;
> +}
> +
> +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> +{
> +	int ret;
> +	u64 pvtime_guest_addr = AARCH64_PVTIME_IPA_START + vcpu->cpu_id *
> +		AARCH64_PVTIME_SIZE;
> +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> +	};
> +
> +	if (!pvtime_data.is_supported)
> +		return;
> +
> +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> +	if (ret)
> +		goto out_err;
> +
> +	if (!pvtime_data.usr_mem) {
> +		ret = pvtime__alloc_region(vcpu->kvm);
> +		if (ret)
> +			goto out_err;
> +	}
> +
> +	pvtime_attr.addr = (u64)&pvtime_guest_addr;
> +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
> +	if (!ret)
> +		return;
> +
> +	pvtime__teardown_region(vcpu->kvm);
> +out_err:
> +	pvtime_data.is_supported = false;
> +}
> +
> +dev_exit(pvtime__teardown_region);
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 6a2408c..84ac1e9 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  			die("Unable to find matching target");
>  	}
>  
> +	/* Populate the vcpu structure. */
> +	vcpu->kvm		= kvm;
> +	vcpu->cpu_id		= cpu_id;
> +	vcpu->cpu_type		= vcpu_init.target;
> +	vcpu->cpu_compatible	= target->compatible;
> +	vcpu->is_running	= true;
> +
>  	if (err || target->init(vcpu))
>  		die("Unable to initialise vcpu");
>  
> @@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  		vcpu->ring = (void *)vcpu->kvm_run +
>  			     (coalesced_offset * PAGE_SIZE);
>  
> -	/* Populate the vcpu structure. */
> -	vcpu->kvm		= kvm;
> -	vcpu->cpu_id		= cpu_id;
> -	vcpu->cpu_type		= vcpu_init.target;
> -	vcpu->cpu_compatible	= target->compatible;
> -	vcpu->is_running	= true;
> -
>  	if (kvm_cpu__configure_features(vcpu))
>  		die("Unable to configure requested vcpu features");
>  
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
