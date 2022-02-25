Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B5AC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 13:21:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D2624BA26;
	Fri, 25 Feb 2022 08:21:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v1goQjhKBZ5n; Fri, 25 Feb 2022 08:21:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E95C94BA31;
	Fri, 25 Feb 2022 08:21:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FBF24BA24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:21:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id paEjY3G-0ZAr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 08:21:30 -0500 (EST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 406004BA21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:21:30 -0500 (EST)
Received: by mail-wm1-f47.google.com with SMTP id
 c18-20020a7bc852000000b003806ce86c6dso1661980wml.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 05:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8odr+j5C0A3ib7LzuuIhcU/6+CAYsVE62idfXAGlWfI=;
 b=donM3/QXoEcPJzPzN8IAbC8SnOUJW8felVzZHfsgO8S0vkId6rGyK4HnaRd0WBjOEI
 5H3JBfZxOLyVIFnencawjDrmxK4whr5WbApfuG6nTFvKNURwC5h97pdoWLzfZkwN5r+m
 YHvUXLm9m56oX+aPNJbR5WqFy3u82tuWfDBwiJdD0EsmWH4PVWyxhwHAWYwd1zNNpdaE
 vITd4bfyLKx2jKHYzyYMw2XuT8a2UfDucxl5hYapYrm3VR64DS8xd8McCIxCzV/jY1nP
 Ac5Tm98VdKf/pkgTZxK9MJe9bV9FadfM8clHdqqTIC7KhkKdeF/+LsxCfs/w8rA421oW
 B2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8odr+j5C0A3ib7LzuuIhcU/6+CAYsVE62idfXAGlWfI=;
 b=aVwJAeUUcxMfBtgoSjT9fefopvwmSF4lgDR9R8tLb7zNgduKIIqQU2yDiZT9S5ety0
 J/E2iTpntKzDRAi61s92FJxHcNvS8n259qW0qTlFDxC4ACI1QWwJ/8TOUqORlSqbPZGb
 BIoiVFRRpzlT0BuEtgWkpg0QWhNNkDNg9RQKqHYqop2X9XebmlFrjgrC4nRpax50AG+x
 B4+uG51gM4Vsj0SBWYP5OmCgrj2cn27VmGDV/N34jk1Z8aO4594sHstVW6rSmY5F1iR3
 DrUoc5g0fCO30VudLhJdffvXMkdYlY5wiaP8pOrdkeHVSUF1eHV0OS9TKiU8zlaPc31O
 YXTQ==
X-Gm-Message-State: AOAM531t04CSOJfmVMVguc5Ae5VBZedJQ/5ml9ypLVsJunwTkq6YW0Zz
 8QEpzP0HExDYZESFaMWB6TzD5w==
X-Google-Smtp-Source: ABdhPJxVAVV4cPGA60dClORTOVx0ViqF+Q6QZCLlT+CCKEkE9B6HHfH50zi0TgiFiOmR7RHO5ZN9eQ==
X-Received: by 2002:a1c:6a18:0:b0:380:dec5:7f05 with SMTP id
 f24-20020a1c6a18000000b00380dec57f05mr2790555wmc.129.1645795288965; 
 Fri, 25 Feb 2022 05:21:28 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com.
 [104.199.75.203]) by smtp.gmail.com with ESMTPSA id
 m21-20020a05600c4f5500b0037d342db78asm6096410wmq.35.2022.02.25.05.21.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 25 Feb 2022 05:21:27 -0800 (PST)
Date: Fri, 25 Feb 2022 13:21:26 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v4 1/3] aarch64: Add stolen time support
Message-ID: <YhjX1kHqDuVaGH/l@google.com>
References: <20220224165103.1157358-1-sebastianene@google.com>
 <20220224165103.1157358-2-sebastianene@google.com>
 <YhjDl/1BvaMu3d/9@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YhjDl/1BvaMu3d/9@monolith.localdoman>
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

On Fri, Feb 25, 2022 at 11:55:03AM +0000, Alexandru Elisei wrote:
> Hi,
> 

Hi,

> On Thu, Feb 24, 2022 at 04:51:03PM +0000, Sebastian Ene wrote:
> > This patch adds support for stolen time by sharing a memory region
> > with the guest which will be used by the hypervisor to store the stolen
> > time information. Reserve a 64kb MMIO memory region after the RTC peripheral
> > to be used by pvtime. The exact format of the structure stored by the
> > hypervisor is described in the ARM DEN0057A document.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  Makefile                               |  1 +
> >  arm/aarch64/arm-cpu.c                  |  1 +
> >  arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
> >  arm/aarch64/pvtime.c                   | 94 ++++++++++++++++++++++++++
> >  arm/include/arm-common/kvm-arch.h      |  6 +-
> >  include/kvm/kvm-config.h               |  1 +
> >  6 files changed, 103 insertions(+), 1 deletion(-)
> >  create mode 100644 arm/aarch64/pvtime.c
> > 
> > diff --git a/Makefile b/Makefile
> > index f251147..e9121dc 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
> >  	OBJS		+= arm/aarch64/arm-cpu.o
> >  	OBJS		+= arm/aarch64/kvm-cpu.o
> >  	OBJS		+= arm/aarch64/kvm.o
> > +	OBJS		+= arm/aarch64/pvtime.o
> >  	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
> >  	ARCH_INCLUDE	+= -Iarm/aarch64/include
> >  
> > diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> > index d7572b7..326fb20 100644
> > --- a/arm/aarch64/arm-cpu.c
> > +++ b/arm/aarch64/arm-cpu.c
> > @@ -22,6 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
> >  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
> >  {
> >  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> > +	kvm_cpu__setup_pvtime(vcpu);
> >  	return 0;
> >  }
> >  
> > diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > index 8dfb82e..b57d6e6 100644
> > --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > @@ -19,5 +19,6 @@
> >  
> >  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
> >  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> > +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> >  
> >  #endif /* KVM__KVM_CPU_ARCH_H */
> > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > new file mode 100644
> > index 0000000..8251f6a
> > --- /dev/null
> > +++ b/arm/aarch64/pvtime.c
> > @@ -0,0 +1,94 @@
> > +#include "kvm/kvm.h"
> > +#include "kvm/kvm-cpu.h"
> > +#include "kvm/util.h"
> > +
> > +#include <linux/byteorder.h>
> > +#include <linux/types.h>
> > +
> > +#define ARM_PVTIME_STRUCT_SIZE		(64)
> > +
> > +struct pvtime_data_priv {
> > +	bool	is_supported;
> > +	char	*usr_mem;
> > +};
> > +
> > +static struct pvtime_data_priv pvtime_data = {
> > +	.is_supported	= true,
> > +	.usr_mem	= NULL
> > +};
> > +
> > +static int pvtime__alloc_region(struct kvm *kvm)
> > +{
> > +	char *mem;
> > +	int ret = 0;
> > +
> > +	mem = mmap(NULL, ARM_PVTIME_MMIO_SIZE, PROT_RW,
> > +		   MAP_ANON_NORESERVE, -1, 0);
> > +	if (mem == MAP_FAILED)
> > +		return -ENOMEM;
> 
> Hm... man 2 mmap lists a few dozen error codes, why use -ENOMEM here instead of
> -errno? This just makes debugging harder.
> 

I will return the -errno error code here.

> > +
> > +	ret = kvm__register_dev_mem(kvm, ARM_PVTIME_MMIO_BASE,
> > +				    ARM_PVTIME_MMIO_SIZE, mem);
> > +	if (ret) {
> > +		munmap(mem, ARM_PVTIME_MMIO_SIZE);
> > +		return ret;
> > +	}
> > +
> > +	pvtime_data.usr_mem = mem;
> > +	return ret;
> > +}
> > +
> > +static int pvtime__teardown_region(struct kvm *kvm)
> > +{
> > +	if (pvtime_data.usr_mem == NULL)
> > +		return 0;
> > +
> > +	kvm__destroy_mem(kvm, ARM_PVTIME_MMIO_BASE,
> > +			 ARM_PVTIME_MMIO_SIZE, pvtime_data.usr_mem);
> > +	munmap(pvtime_data.usr_mem, ARM_PVTIME_MMIO_SIZE);
> > +	pvtime_data.usr_mem = NULL;
> > +	return 0;
> > +}
> > +
> > +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> > +{
> > +	int ret;
> > +	u64 pvtime_guest_addr = ARM_PVTIME_MMIO_BASE + vcpu->cpu_id *
> 
> That's trange, cpu_id is not initialized here because target->init() is called
> before setting up the cpu_id. The following patch in the series, "aarch64:
> Populate the vCPU struct before target->init()" should come before this one.
> 
> > +		ARM_PVTIME_STRUCT_SIZE;
> > +	struct kvm_config *kvm_cfg = NULL;
> > +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> > +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> > +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> > +	};
> > +
> > +	BUG_ON(!vcpu);
> > +	BUG_ON(!vcpu->kvm);
> > +
> > +	kvm_cfg = &vcpu->kvm->cfg;
> > +	if (kvm_cfg && kvm_cfg->no_pvtime)
> 
> If you move the next patch in the series before this one, all the above checks
> will not be needed and should be removed.
> 
> In general, each patch in a series should be able to build properly and run a VM
> without errors. This is to help users when bisecting [1]. If I build kvmtool
> from this patch and I try to run a VM I get the error:
> 
> Error: BUG at arm/aarch64/pvtime.c:65
> 
> [1] https://github.com/torvalds/linux/blob/master/Documentation/process/submitting-patches.rst#separate-your-changes
> 

I will move the patch that handles the structure initialisation before
this one and I will remove those checks. Thanks for the suggestion !

> > +		return;
> > +
> > +	if (!pvtime_data.is_supported)
> > +		return;
> > +
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> > +	if (ret)
> > +		goto out_err;
> 
> You should check that pvtime is supported by checking the KVM_CAP_STEAL_TIME on
> the VM fd, as that's how capabilities are advertised by KVM.
> 

I thought that it is sufficient to verify that it has the device
attributes for *PVTIME. I will add this check too, thanks for the
suggestion !

> > +
> > +	if (!pvtime_data.usr_mem) {
> > +		ret = pvtime__alloc_region(vcpu->kvm);
> 
> pvtime__alloc_region() can fail pretty catastrophically, is it ok to ignore it
> and go on? I would have expected kvm_cpu__setup_pvtime() to return an error
> which is then propagated to target->init().
>

Hmm, I didn't propagate the error code from kvm_cpu__setup_pvtime()
because if this feature is not supported it will hit:"Unable to
initialise vcpu".

But I guess that now we can propagate the error code as we have '--no-pvtime'
command argument. What do you think ?

> > +		if (ret)
> > +			goto out_err;
> > +	}
> > +
> > +	pvtime_attr.addr = (u64)&pvtime_guest_addr;
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
> > +	if (!ret)
> > +		return;
> > +
> > +	pvtime__teardown_region(vcpu->kvm);
> > +out_err:
> > +	pvtime_data.is_supported = false;
> > +}
> > +
> > +dev_exit(pvtime__teardown_region);
> 
> It is customary to put the dev_exit() exactly after the function it refers to.
> 

I will move this.

> > diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> > index c645ac0..3f82663 100644
> > --- a/arm/include/arm-common/kvm-arch.h
> > +++ b/arm/include/arm-common/kvm-arch.h
> > @@ -15,7 +15,8 @@
> >   * |  PCI  |////| plat  |       |        |     |         |
> >   * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
> >   * | space |////| UART, |       |  MMIO  |     |  (AXI)  |
> > - * |       |////| RTC   |       |        |     |         |
> > + * |       |////| RTC,  |       |        |     |         |
> > + * |       |////| PVTIME|       |        |     |         |
> >   * +-------+----+-------+-------+--------+-----+---------+---......
> >   */
> >  
> > @@ -34,6 +35,9 @@
> >  #define ARM_RTC_MMIO_BASE	(ARM_UART_MMIO_BASE + ARM_UART_MMIO_SIZE)
> >  #define ARM_RTC_MMIO_SIZE	0x10000
> >  
> > +#define ARM_PVTIME_MMIO_BASE	(ARM_RTC_MMIO_BASE + ARM_RTC_MMIO_SIZE)
> > +#define ARM_PVTIME_MMIO_SIZE	SZ_64K
> 
> This looks good.
> 
> Thanks,
> Alex
>

Thanks for the review,
Sebastian

> > +
> >  #define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
> >  #define KVM_FLASH_MAX_SIZE	0x1000000
> >  
> > diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
> > index 6a5720c..48adf27 100644
> > --- a/include/kvm/kvm-config.h
> > +++ b/include/kvm/kvm-config.h
> > @@ -62,6 +62,7 @@ struct kvm_config {
> >  	bool no_dhcp;
> >  	bool ioport_debug;
> >  	bool mmio_debug;
> > +	bool no_pvtime;
> >  };
> >  
> >  #endif
> > -- 
> > 2.35.1.473.g83b2b277ed-goog
> > 
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
