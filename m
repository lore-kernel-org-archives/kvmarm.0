Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C652C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 11:18:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A1C49EBE;
	Fri, 11 Mar 2022 06:18:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IdvRDNqC5IFG; Fri, 11 Mar 2022 06:18:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6191949EC5;
	Fri, 11 Mar 2022 06:18:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAC8349EC3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 06:18:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g4uRLOpUsrLT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 06:18:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C2E449EBE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 06:18:33 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3CC1175D;
 Fri, 11 Mar 2022 03:18:32 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C69F73FA45;
 Fri, 11 Mar 2022 03:18:31 -0800 (PST)
Date: Fri, 11 Mar 2022 11:18:55 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH kvmtool v10 2/3] aarch64: Add stolen time support
Message-ID: <YiswH2PGOB86gLNQ@monolith.localdoman>
References: <20220309133422.2432649-1-sebastianene@google.com>
 <20220309133422.2432649-3-sebastianene@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220309133422.2432649-3-sebastianene@google.com>
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Wed, Mar 09, 2022 at 01:34:23PM +0000, Sebastian Ene wrote:
> This patch adds support for stolen time by sharing a memory region
> with the guest which will be used by the hypervisor to store the stolen
> time information. Reserve a 64kb MMIO memory region after the RTC peripheral
> to be used by pvtime. The exact format of the structure stored by the
> hypervisor is described in the ARM DEN0057A document.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  Makefile                               |  1 +
>  arm/aarch32/include/kvm/kvm-cpu-arch.h |  5 ++
>  arm/aarch64/arm-cpu.c                  |  2 +-
>  arm/aarch64/include/kvm/kvm-cpu-arch.h |  2 +
>  arm/aarch64/pvtime.c                   | 96 ++++++++++++++++++++++++++
>  arm/include/arm-common/kvm-arch.h      |  6 +-
>  arm/kvm-cpu.c                          |  1 +
>  include/kvm/kvm-config.h               |  1 +
>  8 files changed, 112 insertions(+), 2 deletions(-)
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
> diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> index 780e0e2..6fe0206 100644
> --- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> @@ -20,4 +20,9 @@ static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
>  	return 0;
>  }
>  
> +static inline int kvm_cpu__teardown_pvtime(struct kvm *kvm)
> +{
> +	return 0;
> +}
> +
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> index d7572b7..7e4a3c1 100644
> --- a/arm/aarch64/arm-cpu.c
> +++ b/arm/aarch64/arm-cpu.c
> @@ -22,7 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
>  {
>  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> -	return 0;
> +	return kvm_cpu__setup_pvtime(vcpu);
>  }
>  
>  static struct kvm_arm_target target_generic_v8 = {
> diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> index 8dfb82e..35996dc 100644
> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> @@ -19,5 +19,7 @@
>  
>  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
>  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> +int kvm_cpu__teardown_pvtime(struct kvm *kvm);
>  
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> new file mode 100644
> index 0000000..720e9de
> --- /dev/null
> +++ b/arm/aarch64/pvtime.c
> @@ -0,0 +1,96 @@
> +#include "kvm/kvm.h"
> +#include "kvm/kvm-cpu.h"
> +#include "kvm/util.h"
> +
> +#include <linux/byteorder.h>
> +#include <linux/types.h>
> +
> +#define ARM_PVTIME_STRUCT_SIZE		(64)
> +
> +static void *usr_mem;
> +
> +static int pvtime__alloc_region(struct kvm *kvm)
> +{
> +	char *mem;
> +	int ret = 0;
> +
> +	mem = mmap(NULL, ARM_PVTIME_BASE, PROT_RW,
> +		   MAP_ANON_NORESERVE, -1, 0);
> +	if (mem == MAP_FAILED)
> +		return -errno;
> +
> +	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
> +				ARM_PVTIME_BASE, mem);
> +	if (ret) {
> +		munmap(mem, ARM_PVTIME_BASE);
> +		return ret;
> +	}
> +
> +	usr_mem = mem;
> +	return ret;
> +}
> +
> +static int pvtime__teardown_region(struct kvm *kvm)
> +{
> +	if (usr_mem == NULL)
> +		return 0;
> +
> +	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
> +			 ARM_PVTIME_BASE, usr_mem);
> +	munmap(usr_mem, ARM_PVTIME_BASE);
> +	usr_mem = NULL;
> +	return 0;
> +}
> +
> +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> +{
> +	int ret;
> +	bool has_stolen_time;
> +	u64 pvtime_guest_addr = ARM_PVTIME_BASE + vcpu->cpu_id *
> +		ARM_PVTIME_STRUCT_SIZE;
> +	struct kvm_config *kvm_cfg = NULL;
> +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> +		.attr	= KVM_ARM_VCPU_PVTIME_IPA
> +	};
> +
> +	kvm_cfg = &vcpu->kvm->cfg;
> +	if (kvm_cfg->no_pvtime)
> +		return 0;
> +
> +	has_stolen_time = kvm__supports_extension(vcpu->kvm,
> +						  KVM_CAP_STEAL_TIME);
> +	if (!has_stolen_time) {
> +		kvm_cfg->no_pvtime = true;
> +		return 0;
> +	}
> +
> +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> +	if (ret) {
> +		perror("KVM_HAS_DEVICE_ATTR failed\n");
> +		goto out_err;

Nitpick: here we return -1 (ioctl() return value when it fails) instead of
returning -errno. You can set ret = -errno before the perror() call (in
case it also fails for some reason, thus changing the value of errno).

Not a big deal, but it changes the semantics of the return value for the
function: below, for pvtime__alloc_region() we return -errno, but here we
return -1. Someone who is debugging an error might print this return value
and think that the ioctl() failed with error code EPERM (EPERM is 1), which
is not a valid error code for ioctl() according to man 2 ioctl. It will
also look rather strange for the perror to print the error message
associated with a different error code than the error code that is returned
from this function.

> +	}
> +
> +	if (!usr_mem) {
> +		ret = pvtime__alloc_region(vcpu->kvm);
> +		if (ret) {
> +			perror("Failed allocating pvtime region\n");
> +			goto out_err;
> +		}
> +	}
> +
> +	pvtime_attr.addr = (u64)&pvtime_guest_addr;
> +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
> +	if (!ret)
> +		return 0;

Nitpick: same here, ret must be set to -errno before returning.

> +
> +	perror("KVM_SET_DEVICE_ATTR failed\n");
> +	pvtime__teardown_region(vcpu->kvm);
> +out_err:
> +	return ret;
> +}
> +
> +int kvm_cpu__teardown_pvtime(struct kvm *kvm)
> +{
> +	return pvtime__teardown_region(kvm);
> +}
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index c645ac0..43b1f77 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -15,7 +15,8 @@
>   * |  PCI  |////| plat  |       |        |     |         |
>   * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
>   * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
> - * |       |////| RTC   |       |        |     |         |
> + * |       |////| RTC,  |       |        |     |         |
> + * |       |////| PVTIME|       |        |     |         |
>   * +-------+----+-------+-------+--------+-----+---------+---......
>   */
>  
> @@ -34,6 +35,9 @@
>  #define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
>  #define ARM_RTC_MMIO_SIZE	0x10000
>  
> +#define ARM_PVTIME_BASE		(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
> +#define ARM_PVTIME_SIZE		SZ_64K
> +
>  #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
>  #define KVM_FLASH_MAX_SIZE	0x1000000
>  
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 84ac1e9..00660d6 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -144,6 +144,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
>  
>  void kvm_cpu__delete(struct kvm_cpu *vcpu)
>  {
> +	kvm_cpu__teardown_pvtime(vcpu->kvm);
>  	free(vcpu);
>  }
>  
> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> index 6a5720c..48adf27 100644
> --- a/include/kvm/kvm-config.h
> +++ b/include/kvm/kvm-config.h
> @@ -62,6 +62,7 @@ struct kvm_config {
>  	bool no_dhcp;
>  	bool ioport_debug;
>  	bool mmio_debug;
> +	bool no_pvtime;
>  };
>  
>  #endif
> -- 

Tested the series, a guest is able to detect pvtime:

[    0.008661] arm-pv: using stolen time PV

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

With the two nitpicks above fixed, the patch looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
