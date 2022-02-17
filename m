Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF66C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 15:17:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BB3249DF6;
	Thu, 17 Feb 2022 10:17:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3ZgelTFqtdKk; Thu, 17 Feb 2022 10:17:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5051949E39;
	Thu, 17 Feb 2022 10:17:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F5F140BBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 10:05:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mzCU8ddafyqr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 10:05:06 -0500 (EST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10D21408AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 10:05:06 -0500 (EST)
Received: by mail-wm1-f47.google.com with SMTP id i19so3377668wmq.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 07:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=D/03XibBchYyDQEKiqzuUpnTX3XMKwI9ay4R6S/T1Co=;
 b=k0DDGrdSPYNqMbIq5mYbgRekNCX9UbT37xG1e3W217dxggMlah9Uv4iLaklwG4ukuy
 OkjwbEJKun8WtE3cRlAfDdwKie7LMlEmPp8tRViY+3piKrjxpWBhyZpY7Z7b0x7hLAN7
 GzRSECz3eMCRmui8WRG2iGNWmRJs2gbBkuFbUwUJERRQkfYz869rQ+FB5qO/5xHWXa+V
 xUyMnw+Cj7PYkbXPNZ6hq8J4nEtO4ZSfvwfCsplaFGySZGwuAVc1+l3i+RqxTDqAtpVf
 ++bAEmpP4T36P9u/t3v6nQRJOVLWcY7kmm6fWAXyx+tZyO3YBOXsYzcDXHOnWXcWTKHQ
 Qj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=D/03XibBchYyDQEKiqzuUpnTX3XMKwI9ay4R6S/T1Co=;
 b=R5LkvLJR3AMzdDm1GXHFS9sqvx7sO5MhfSfUrLy3CciO4TcrW4jlLyhb42UPwoEAz0
 +4baO3LdRRMMsxohdnTm/nplrfa3YN6Rgam3BEHVapoMZwGbovYRPqmJGrlEQu8t/Tq5
 aL4grr4+scGzdwDrH8YNhW+dL+5xyaJE9nQXsalO+XUFPHlL0Y1vLbE5Df54BRmPFIaZ
 RZliQQh41i0buik4kmWsehM63xl3LCdEmLs7Wo0vq8/LzLMLs7/uAMCCHukIo//bktQJ
 LxxJlWpYe76YlcaIW3LtyaQh2JeVfX46u4x4YnlIW1q7teKQnS4p+k17DS4ny7yPhoq/
 ljtw==
X-Gm-Message-State: AOAM530mC0BbknG7x/sv+gAflZFKH8+mxmdpf1PCyJt61SdsoERe9Qbq
 ykw1YEPwh3M8zNm/7lc4q8FDbg==
X-Google-Smtp-Source: ABdhPJxbtk1JKRQtHDmGnZPBvcNsTxw4iFSh0IfrUIrfkH/cfLLp9gnNMe2Z152Ll9mkdr27SmLp5w==
X-Received: by 2002:a05:600c:204a:b0:37b:bcbd:47b1 with SMTP id
 p10-20020a05600c204a00b0037bbcbd47b1mr3029257wmg.103.1645110304676; 
 Thu, 17 Feb 2022 07:05:04 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com.
 [104.199.75.203])
 by smtp.gmail.com with ESMTPSA id p2sm1500153wmc.33.2022.02.17.07.05.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Feb 2022 07:05:04 -0800 (PST)
Date: Thu, 17 Feb 2022 15:05:02 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool] aarch64: Add stolen time support
Message-ID: <Yg5kHg9jJyDRioS6@google.com>
References: <Yg0jcO32I+zFz/0s@google.com>
 <6dcb9ce8090a34105be012965f3eadc4@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6dcb9ce8090a34105be012965f3eadc4@kernel.org>
X-Mailman-Approved-At: Thu, 17 Feb 2022 10:17:55 -0500
Cc: will@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Wed, Feb 16, 2022 at 04:59:10PM +0000, Marc Zyngier wrote:
> Hi Sebastian,
> 
> Thanks for looking into this. A few comments below.
> 

Hello Marc,

Thanks for taking the time to review my patch.

> On 2022-02-16 16:16, Sebastian Ene wrote:
> > This patch add support for stolen time by sharing a memory region
> > with the guest which will be used by the hypervisor to store the stolen
> > time information. The exact format of the structure stored by the
> > hypervisor is described in the ARM DEN0057A document.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  Makefile                          |  3 +-
> >  arm/aarch64/arm-cpu.c             |  2 +
> >  arm/aarch64/include/kvm/pvtime.h  |  6 +++
> >  arm/aarch64/pvtime.c              | 83 +++++++++++++++++++++++++++++++
> >  arm/include/arm-common/kvm-arch.h |  6 +++
> >  arm/kvm-cpu.c                     | 14 +++---
> >  6 files changed, 106 insertions(+), 8 deletions(-)
> >  create mode 100644 arm/aarch64/include/kvm/pvtime.h
> >  create mode 100644 arm/aarch64/pvtime.c
> > 
> > diff --git a/Makefile b/Makefile
> > index f251147..282ae99 100644
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
> > @@ -582,4 +583,4 @@ ifneq ($(MAKECMDGOALS),clean)
> > 
> >  KVMTOOLS-VERSION-FILE:
> >  	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
> > -endif
> > \ No newline at end of file
> > +endif
> 
> Spurious change?
> 

Right, ACK I will revert this change.

> > diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> > index d7572b7..80bf83a 100644
> > --- a/arm/aarch64/arm-cpu.c
> > +++ b/arm/aarch64/arm-cpu.c
> > @@ -2,6 +2,7 @@
> >  #include "kvm/kvm.h"
> >  #include "kvm/kvm-cpu.h"
> >  #include "kvm/util.h"
> > +#include "kvm/pvtime.h"
> > 
> >  #include "arm-common/gic.h"
> >  #include "arm-common/timer.h"
> > @@ -22,6 +23,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm
> > *kvm)
> >  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
> >  {
> >  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> > +	pvtime__setup_vcpu(vcpu);
> >  	return 0;
> >  }
> > 
> > diff --git a/arm/aarch64/include/kvm/pvtime.h
> > b/arm/aarch64/include/kvm/pvtime.h
> > new file mode 100644
> > index 0000000..c31f019
> > --- /dev/null
> > +++ b/arm/aarch64/include/kvm/pvtime.h
> > @@ -0,0 +1,6 @@
> > +#ifndef KVM__PVTIME_H
> > +#define KVM__PVTIME_H
> > +
> > +void pvtime__setup_vcpu(struct kvm_cpu *vcpu);
> > +
> > +#endif /* KVM__PVTIME_H */
> 
> How about sticking this in kvm-cpu-arch.h instead? A whole new include file
> for just a prototype isn't totally warranted.
>

I think that's a good ideea, I will do this.

> > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > new file mode 100644
> > index 0000000..eb92388
> > --- /dev/null
> > +++ b/arm/aarch64/pvtime.c
> > @@ -0,0 +1,83 @@
> > +#include "kvm/kvm.h"
> > +#include "kvm/kvm-cpu.h"
> > +#include "kvm/util.h"
> > +#include "kvm/pvtime.h"
> > +
> > +#include <linux/byteorder.h>
> > +#include <linux/types.h>
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
> > +static int pvtime__aloc_region(struct kvm *kvm)
> 
> s/aloc/alloc/ ?
> 

I will fix the typo.

> > +{
> > +	char *mem;
> > +	int ret = 0;
> > +
> > +	mem = mmap(NULL, AARCH64_PVTIME_IPA_MAX_SIZE, PROT_RW,
> > +		   MAP_ANON_NORESERVE, -1, 0);
> > +	if (mem == MAP_FAILED)
> > +		return -ENOMEM;
> > +
> > +	ret = kvm__register_dev_mem(kvm, AARCH64_PVTIME_IPA_START,
> > +				    AARCH64_PVTIME_IPA_MAX_SIZE, mem);
> > +	if (ret) {
> > +		munmap(mem, AARCH64_PVTIME_IPA_MAX_SIZE);
> > +		return ret;
> > +	}
> > +
> > +	pvtime_data.usr_mem = mem;
> > +	return ret;
> > +}
> > +
> > +static int pvtime__teardown_region(struct kvm *kvm)
> > +{
> > +	kvm__destroy_mem(kvm, AARCH64_PVTIME_IPA_START,
> > +			 AARCH64_PVTIME_IPA_MAX_SIZE, pvtime_data.usr_mem);
> > +	munmap(pvtime_data.usr_mem, AARCH64_PVTIME_IPA_MAX_SIZE);
> > +	pvtime_data.usr_mem = NULL;
> > +	return 0;
> > +}
> > +
> > +void pvtime__setup_vcpu(struct kvm_cpu *vcpu)
> > +{
> > +	int ret;
> > +	u64 pvtime_guest_addr = AARCH64_PVTIME_IPA_START + vcpu->cpu_id *
> > +		AARCH64_PVTIME_SIZE;
> > +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> > +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> > +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> > +	};
> > +
> > +	if (!pvtime_data.is_supported)
> > +		return;
> > +
> > +	if (!pvtime_data.usr_mem) {
> > +		ret = pvtime__aloc_region(vcpu->kvm);
> > +		if (ret)
> > +			goto out_err_alloc;
> > +	}
> > +
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pvtime_attr);
> > +	if (ret)
> > +		goto out_err_attr;
> 
> You should check for the stolen time capability before allocating and
> mapping
> the memory.
> 

Good catch ! I will do this, thanks.

> > +
> > +	pvtime_attr.addr = (u64)&pvtime_guest_addr;
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pvtime_attr);
> > +	if (!ret)
> > +		return;
> > +
> > +out_err_attr:
> > +	pvtime__teardown_region(vcpu->kvm);
> > +out_err_alloc:
> > +	pvtime_data.is_supported = false;
> > +}
> > +
> > +dev_exit(pvtime__teardown_region);
> > diff --git a/arm/include/arm-common/kvm-arch.h
> > b/arm/include/arm-common/kvm-arch.h
> > index c645ac0..7b683d6 100644
> > --- a/arm/include/arm-common/kvm-arch.h
> > +++ b/arm/include/arm-common/kvm-arch.h
> > @@ -54,6 +54,12 @@
> >  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
> >  				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
> > 
> > +#define AARCH64_PVTIME_IPA_MAX_SIZE		(0x10000)
> 
> SZ_64K?
>

I will update the `AARCH64_PVTIME_IPA_MAX_SIZE` defintion with `SZ_64K`.

> > +#define AARCH64_PROTECTED_VM_FW_MAX_SIZE	(0x200000)
> 
> This definitely looks like something that shouldn't be there. Yet.
> 

I agree, I will remove it for the moment.

> > +#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
> > +					 AARCH64_PROTECTED_VM_FW_MAX_SIZE - \
> > +					 AARCH64_PVTIME_IPA_MAX_SIZE)
> > +#define AARCH64_PVTIME_SIZE		(64)
> > 
> >  #define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
> >  #define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
> > diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> > index 6a2408c..84ac1e9 100644
> > --- a/arm/kvm-cpu.c
> > +++ b/arm/kvm-cpu.c
> > @@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm
> > *kvm, unsigned long cpu_id)
> >  			die("Unable to find matching target");
> >  	}
> > 
> > +	/* Populate the vcpu structure. */
> > +	vcpu->kvm		= kvm;
> > +	vcpu->cpu_id		= cpu_id;
> > +	vcpu->cpu_type		= vcpu_init.target;
> > +	vcpu->cpu_compatible	= target->compatible;
> > +	vcpu->is_running	= true;
> > +
> >  	if (err || target->init(vcpu))
> >  		die("Unable to initialise vcpu");
> > 
> > @@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm
> > *kvm, unsigned long cpu_id)
> >  		vcpu->ring = (void *)vcpu->kvm_run +
> >  			     (coalesced_offset * PAGE_SIZE);
> > 
> > -	/* Populate the vcpu structure. */
> > -	vcpu->kvm		= kvm;
> > -	vcpu->cpu_id		= cpu_id;
> > -	vcpu->cpu_type		= vcpu_init.target;
> > -	vcpu->cpu_compatible	= target->compatible;
> > -	vcpu->is_running	= true;
> > -
> 
> What is the reason for moving these assignments around?
> 

The setup of the pvtime is done during the vcpu initialisation and I
need to access the kvm structure during that time.

> >  	if (kvm_cpu__configure_features(vcpu))
> >  		die("Unable to configure requested vcpu features");
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
