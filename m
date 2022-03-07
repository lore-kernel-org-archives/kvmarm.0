Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0495C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 10:52:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 672E64B22A;
	Mon,  7 Mar 2022 05:52:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UrbhqBitAwRG; Mon,  7 Mar 2022 05:52:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A35B4B240;
	Mon,  7 Mar 2022 05:52:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E49C94B22A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 05:52:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zrYaxkXta6o8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 05:52:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 730234B223
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 05:52:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5A4EED1;
 Mon,  7 Mar 2022 02:52:07 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 067E03F73D;
 Mon,  7 Mar 2022 02:52:05 -0800 (PST)
Date: Mon, 7 Mar 2022 10:52:27 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool v7 2/3] aarch64: Add stolen time support
Message-ID: <YiXj6xaw3cGLJzGZ@monolith.localdoman>
References: <20220302140734.1015958-1-sebastianene@google.com>
 <20220302140734.1015958-3-sebastianene@google.com>
 <8735k02z98.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8735k02z98.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 02, 2022 at 02:41:07PM +0000, Marc Zyngier wrote:
> Hi Sebastian,
> 
> On Wed, 02 Mar 2022 14:07:35 +0000,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > This patch adds support for stolen time by sharing a memory region
> > with the guest which will be used by the hypervisor to store the stolen
> > time information. Reserve a 64kb MMIO memory region after the RTC peripheral
> > to be used by pvtime. The exact format of the structure stored by the
> > hypervisor is described in the ARM DEN0057A document.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  Makefile                               |   1 +
> >  arm/aarch64/arm-cpu.c                  |   2 +-
> >  arm/aarch64/include/kvm/kvm-cpu-arch.h |   1 +
> >  arm/aarch64/pvtime.c                   | 103 +++++++++++++++++++++++++
> >  arm/include/arm-common/kvm-arch.h      |   6 +-
> >  include/kvm/kvm-config.h               |   1 +
> >  6 files changed, 112 insertions(+), 2 deletions(-)
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
> > index d7572b7..7e4a3c1 100644
> > --- a/arm/aarch64/arm-cpu.c
> > +++ b/arm/aarch64/arm-cpu.c
> > @@ -22,7 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
> >  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
> >  {
> >  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> > -	return 0;
> > +	return kvm_cpu__setup_pvtime(vcpu);
> >  }
> >  
> >  static struct kvm_arm_target target_generic_v8 = {
> > diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > index 8dfb82e..2b2c1ff 100644
> > --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > @@ -19,5 +19,6 @@
> >  
> >  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
> >  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> > +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> >  
> >  #endif /* KVM__KVM_CPU_ARCH_H */
> > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > new file mode 100644
> > index 0000000..fdde683
> > --- /dev/null
> > +++ b/arm/aarch64/pvtime.c
> > @@ -0,0 +1,103 @@
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
> 
> Consider using void * for pointers that do not have any particular
> semantics associated to them.
> 
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
> 
> I sort of object to the 'MMIO' part of the name. The spec is quite
> clear that this should be normal memory. That's purely cosmetic, but
> still a bit confusing.
> 
> > +		   MAP_ANON_NORESERVE, -1, 0);
> > +	if (mem == MAP_FAILED)
> > +		return -errno;
> > +
> > +	ret = kvm__register_dev_mem(kvm, ARM_PVTIME_MMIO_BASE,
> > +				    ARM_PVTIME_MMIO_SIZE, mem);
> 
> This, on the other side, is wrong. Since the pvtime pages are memory,
> mapping them with device attributes will do the wrong thing (the
> hypervisor will write to a cacheable mapping, and the guest will
> bypass the cache due to the S2 override that you provide here).
> 
> kvm__register_ram() is more likely to lead to the behaviour you'd
> expect.

The type of memory only has meaning for kvmtool, it doesn't affect the memslot
that is created. Both kvm__register_dev_mem() and kvm__register_ram() create the
exact same type of memslot.

But yes, I agree, this should be kvm__kvm_register_ram(), because this matches
the behaviour described in Documentation/virt/kvm/arm/pvtime.rst, where this
shared region is "[..] a reserved region of the normal memory given to the
guest".

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
