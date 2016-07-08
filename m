From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC v6 4/6] KVM: arm/arm64: enable irqchip routing
Date: Fri, 8 Jul 2016 10:52:33 +0200
Message-ID: <20160708085233.qjptxd4qh7ukbgl3@hawk.localdomain>
References: <1467794875-5237-1-git-send-email-eric.auger@redhat.com>
 <1467794875-5237-5-git-send-email-eric.auger@redhat.com>
 <20160707172052.5weyrjus3i3mgzik@hawk.localdomain>
 <11b05e3b-f3fd-aae3-b1e7-6ca9836cfc97@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D7DC48531
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2016 04:47:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ux2gm4lUg7vU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2016 04:47:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31950412ED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2016 04:47:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <11b05e3b-f3fd-aae3-b1e7-6ca9836cfc97@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 08, 2016 at 10:16:53AM +0200, Auger Eric wrote:
> Hi Drew,
> 
> On 07/07/2016 19:20, Andrew Jones wrote:
> > On Wed, Jul 06, 2016 at 10:47:53AM +0200, Eric Auger wrote:
> >> This patch adds compilation and link against irqchip.
> >>
> >> Main motivation behind using irqchip code is to enable MSI
> >> routing code. In the future irqchip routing may also be useful
> >> when targeting multiple irqchips.
> >>
> >> Routing standard callbacks now are implemented in vgic-irqfd:
> >> - kvm_set_routing_entry
> >> - kvm_set_irq
> >> - kvm_set_msi
> >>
> >> They only are supported with new_vgic code.
> >>
> >> Both HAVE_KVM_IRQCHIP and HAVE_KVM_IRQ_ROUTING are defined.
> >> KVM_CAP_IRQ_ROUTING is advertised and KVM_SET_GSI_ROUTING is allowed.
> >>
> >> So from now on IRQCHIP routing is enabled and a routing table entry
> >> must exist for irqfd injection to succeed for a given SPI. This patch
> >> builds a default flat irqchip routing table (gsi=irqchip.pin) covering
> >> all the VGIC SPI indexes. This routing table is overwritten by the
> >> first first user-space call to KVM_SET_GSI_ROUTING ioctl.
> >>
> >> MSI routing setup is not yet allowed.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >> v5 -> v6:
> >> - rebase on top of Andre's v8 + removal of old vgic
> >>
> >> v4 -> v5:
> >> - vgic_irqfd.c was renamed into vgic-irqfd.c by Andre
> >> - minor comment changes
> >> - remove trace_kvm_set_irq since it is called in irqchip
> >> - remove CONFIG_HAVE_KVM_MSI setting (done in KVM section)
> >> - despite Christoffer's question, in kvm_set_msi, I kept the copy from
> >>   the input "struct kvm_kernel_irq_routing_entry *e" imposed by the
> >>   irqchip callback API into the struct kvm_msi * passed to
> >>   vits_inject_msi. Since vits_inject_msi is directly called by
> >>   kvm_send_userspace_msi which takes a struct kvm_msi*, makes sense
> >>   to me to keep the copy.
> >> - squash former [PATCH v4 5/7] KVM: arm/arm64: build a default routing
> >>   table into that patch
> >> - handle default routing table alloc failure
> >>
> >> v3 -> v4:
> >> - provide support only for new-vgic
> >> - code previously in vgic.c now in vgic_irqfd.c
> >>
> >> v2 -> v3:
> >> - unconditionally set devid and KVM_MSI_VALID_DEVID flag as suggested
> >>   by Andre (KVM_IRQ_ROUTING_EXTENDED_MSI type not used anymore)
> >> - vgic_irqfd_set_irq now is static
> >> - propagate flags
> >> - add comments
> >>
> >> v1 -> v2:
> >> - fix bug reported by Andre related to msi.flags and msi.devid setting
> >>   in kvm_send_userspace_msi
> >> - avoid injecting reserved IRQ numbers in vgic_irqfd_set_irq
> >>
> >> RFC -> PATCH
> >> - reword api.txt:
> >>   x move MSI routing comments in a subsequent patch,
> >>   x clearly state GSI routing does not apply to KVM_IRQ_LINE
> >> ---
> >>  Documentation/virtual/kvm/api.txt | 12 ++++--
> >>  arch/arm/include/asm/kvm_host.h   |  2 +
> >>  arch/arm/kvm/Kconfig              |  2 +
> >>  arch/arm/kvm/Makefile             |  1 +
> >>  arch/arm64/include/asm/kvm_host.h |  1 +
> >>  arch/arm64/kvm/Kconfig            |  2 +
> >>  arch/arm64/kvm/Makefile           |  1 +
> >>  virt/kvm/arm/vgic/vgic-init.c     | 27 +++++++++++++
> >>  virt/kvm/arm/vgic/vgic-irqfd.c    | 82 ++++++++++++++++++++++++++++++---------
> >>  virt/kvm/arm/vgic/vgic.c          |  7 ----
> >>  virt/kvm/irqchip.c                |  2 +
> >>  11 files changed, 109 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> >> index 0065c8e..3bb60d3 100644
> >> --- a/Documentation/virtual/kvm/api.txt
> >> +++ b/Documentation/virtual/kvm/api.txt
> >> @@ -1433,13 +1433,16 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
> >>  4.52 KVM_SET_GSI_ROUTING
> >>  
> >>  Capability: KVM_CAP_IRQ_ROUTING
> >> -Architectures: x86 s390
> >> +Architectures: x86 s390 arm arm64
> >>  Type: vm ioctl
> >>  Parameters: struct kvm_irq_routing (in)
> >>  Returns: 0 on success, -1 on error
> >>  
> >>  Sets the GSI routing table entries, overwriting any previously set entries.
> >>  
> >> +On arm/arm64, GSI routing has the following limitation:
> >> +- GSI routing does not apply to KVM_IRQ_LINE but only to KVM_IRQFD.
> >> +
> >>  struct kvm_irq_routing {
> >>  	__u32 nr;
> >>  	__u32 flags;
> >> @@ -2368,9 +2371,10 @@ Note that closing the resamplefd is not sufficient to disable the
> >>  irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
> >>  and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
> >>  
> >> -On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
> >> -Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
> >> -given by gsi + 32.
> >> +On arm/arm64, gsi routing being supported, the following can happen:
> >> +- in case no routing entry is associated to this gsi, injection fails
> >> +- in case the gsi is associated to an irqchip routing entry,
> >> +  irqchip.pin + 32 corresponds to the injected SPI ID.
> >>  
> >>  4.76 KVM_PPC_ALLOCATE_HTAB
> >>  
> >> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> >> index 3c40facd..161997e 100644
> >> --- a/arch/arm/include/asm/kvm_host.h
> >> +++ b/arch/arm/include/asm/kvm_host.h
> >> @@ -37,6 +37,8 @@
> >>  
> >>  #define KVM_VCPU_MAX_FEATURES 2
> >>  
> >> +#define KVM_IRQCHIP_NUM_PINS 988 /* 1020 - 32 is the number of SPIs */
> > 
> > I wonder if it's time for include/linux/irqchip/arm-gic-common.h to
> > gain some defines like include/kvm/vgic/vgic.h has, in order to
> > replace all the scatterings of 1020s and 32s throughout irq-gic*.c
> > code. In any case, just a nite, but I'd write this define as
> 
> Marc, any opinion on this?
> > 
> >  #define KVM_IRQCHIP_NUM_PINS (1020 - 32) /* number of SPIs */
> 
> sure
> > 
> >> +
> >>  #include <kvm/arm_vgic.h>
> >>  
> >>  #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
> >> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> >> index 95a0005..3e1cd04 100644
> >> --- a/arch/arm/kvm/Kconfig
> >> +++ b/arch/arm/kvm/Kconfig
> >> @@ -32,6 +32,8 @@ config KVM
> >>  	select KVM_VFIO
> >>  	select HAVE_KVM_EVENTFD
> >>  	select HAVE_KVM_IRQFD
> >> +	select HAVE_KVM_IRQCHIP
> >> +	select HAVE_KVM_IRQ_ROUTING
> >>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
> >>  	---help---
> >>  	  Support hosting virtualized guest machines.
> >> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> >> index 5e28df8..025d812 100644
> >> --- a/arch/arm/kvm/Makefile
> >> +++ b/arch/arm/kvm/Makefile
> >> @@ -29,4 +29,5 @@ obj-y += $(KVM)/arm/vgic/vgic-v2.o
> >>  obj-y += $(KVM)/arm/vgic/vgic-mmio.o
> >>  obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
> >>  obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
> >> +obj-y += $(KVM)//irqchip.o
> > 
> > extra '/'
> ok thanks
> > 
> >>  obj-y += $(KVM)/arm/arch_timer.o
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index ebe8904..58f4a60 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -34,6 +34,7 @@
> >>  #define KVM_PRIVATE_MEM_SLOTS 4
> >>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> >>  #define KVM_HALT_POLL_NS_DEFAULT 500000
> >> +#define KVM_IRQCHIP_NUM_PINS 988 /* 1020 - 32 is the number of SPIs */
> > 
> > same comment as above
> yep
> > 
> >>  
> >>  #include <kvm/arm_vgic.h>
> >>  #include <kvm/arm_arch_timer.h>
> >> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> >> index 9d2eff0..9c9edc9 100644
> >> --- a/arch/arm64/kvm/Kconfig
> >> +++ b/arch/arm64/kvm/Kconfig
> >> @@ -37,6 +37,8 @@ config KVM
> >>  	select KVM_ARM_VGIC_V3
> >>  	select KVM_ARM_PMU if HW_PERF_EVENTS
> >>  	select HAVE_KVM_MSI
> >> +	select HAVE_KVM_IRQCHIP
> >> +	select HAVE_KVM_IRQ_ROUTING
> >>  	---help---
> >>  	  Support hosting virtualized guest machines.
> >>  	  We don't support KVM with 16K page tables yet, due to the multiple
> >> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> >> index a5b9664..695eb3c 100644
> >> --- a/arch/arm64/kvm/Makefile
> >> +++ b/arch/arm64/kvm/Makefile
> >> @@ -30,5 +30,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
> >> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
> >>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> >> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> >> index 01a60dc..591571e 100644
> >> --- a/virt/kvm/arm/vgic/vgic-init.c
> >> +++ b/virt/kvm/arm/vgic/vgic-init.c
> >> @@ -264,6 +264,10 @@ int vgic_init(struct kvm *kvm)
> >>  	kvm_for_each_vcpu(i, vcpu, kvm)
> >>  		kvm_vgic_vcpu_init(vcpu);
> >>  
> >> +	ret = kvm_setup_default_irq_routing(kvm);
> >> +	if (ret)
> >> +		goto out;
> >> +
> >>  	dist->initialized = true;
> >>  out:
> >>  	return ret;
> >> @@ -457,3 +461,26 @@ out_free_irq:
> >>  			kvm_get_running_vcpus());
> >>  	return ret;
> >>  }
> >> +
> >> +int kvm_setup_default_irq_routing(struct kvm *kvm)
> >> +{
> >> +	struct kvm_irq_routing_entry *entries;
> >> +	struct vgic_dist *dist = &kvm->arch.vgic;
> >> +	u32 nr = dist->nr_spis;
> >> +	int i, ret;
> >> +
> >> +	entries = kcalloc(nr, sizeof(struct kvm_kernel_irq_routing_entry),
> >> +			  GFP_KERNEL);
> >> +	if (!entries)
> >> +		return -ENOMEM;
> >> +
> >> +	for (i = 0; i < nr; i++) {
> >> +		entries[i].gsi = i;
> >> +		entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
> >> +		entries[i].u.irqchip.irqchip = 0;
> >> +		entries[i].u.irqchip.pin = i;
> >> +	}
> >> +	ret = kvm_set_irq_routing(kvm, entries, nr, 0);
> >> +	kfree(entries);
> >> +	return ret;
> >> +}
> >> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> >> index c675513..b03ab4e 100644
> >> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
> >> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> >> @@ -17,36 +17,80 @@
> >>  #include <linux/kvm.h>
> >>  #include <linux/kvm_host.h>
> >>  #include <trace/events/kvm.h>
> >> +#include <kvm/arm_vgic.h>
> >> +#include "vgic.h"
> >>  
> >> -int kvm_irq_map_gsi(struct kvm *kvm,
> >> -		    struct kvm_kernel_irq_routing_entry *entries,
> >> -		    int gsi)
> >> +/**
> >> + * vgic_irqfd_set_irq: inject the IRQ corresponding to the
> >> + * irqchip routing entry
> >> + *
> >> + * This is the entry point for irqfd IRQ injection
> >> + */
> >> +static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
> >> +			struct kvm *kvm, int irq_source_id,
> >> +			int level, bool line_status)
> >>  {
> >> -	return 0;
> >> -}
> >> +	unsigned int spi_id = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
> >> +	struct vgic_dist *dist = &kvm->arch.vgic;
> >>  
> >> -int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip,
> >> -			 unsigned int pin)
> >> -{
> >> -	return pin;
> >> +	BUG_ON(!vgic_initialized(kvm));
> > 
> > Is it possible for userspace to trigger this by [intentionally]
> > doing setup out of order? If so, then we should only error here.
> kvm_irq_map_chip_pin is called from kvm_irq_has_notifier and
> kvm_notify_acked_irq. On ARM we only use the latter. This is basically
> used to retrieved the gsi associated with a physical (irqchip/pin) and
> eventually signal the resamplefd associated to this gsi, if any.
> kvm_notify_acked_irq is called from *process_maintenance meaning a
> level-sensitive vIRQ was deactivated. So at that point the vGIC is
> initialized since a virtual IRQ was already injected. So I think it is
> even safe to remove the check.

I vote we remove it then.

> 
> > 
> >> +
> >> +	if (spi_id > min(dist->nr_spis, 1020))
> > 
> > Another 1020.
> ok
> > 
> >> +		return -EINVAL;
> >> +	return kvm_vgic_inject_irq(kvm, 0, spi_id, level);
> >>  }
> >>  
> >> -int kvm_set_irq(struct kvm *kvm, int irq_source_id,
> >> -		u32 irq, int level, bool line_status)
> >> +/**
> >> + * kvm_set_routing_entry: populate a kvm routing entry
> >> + * from a user routing entry
> >> + *
> >> + * @e: kvm kernel routing entry handle
> >> + * @ue: user api routing entry handle
> >> + * return 0 on success, -EINVAL on errors.
> >> + */
> >> +int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
> >> +			  const struct kvm_irq_routing_entry *ue)
> >>  {
> >> -	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
> >> +	int r = -EINVAL;
> >>  
> >> -	trace_kvm_set_irq(irq, level, irq_source_id);
> >> -
> >> -	BUG_ON(!vgic_initialized(kvm));
> >> -
> >> -	return kvm_vgic_inject_irq(kvm, 0, spi, level);
> >> +	switch (ue->type) {
> >> +	case KVM_IRQ_ROUTING_IRQCHIP:
> >> +		e->set = vgic_irqfd_set_irq;
> >> +		e->irqchip.irqchip = ue->u.irqchip.irqchip;
> >> +		e->irqchip.pin = ue->u.irqchip.pin;
> >> +		if ((e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS) ||
> >> +		    (e->irqchip.irqchip >= KVM_NR_IRQCHIPS))
> >> +			goto out;
> >> +		break;
> >> +	default:
> >> +		goto out;
> >> +	}
> >> +	r = 0;
> >> +out:
> >> +	return r;
> >>  }
> >>  
> >> -/* MSI not implemented yet */
> >> +/**
> >> + * kvm_set_msi: inject the MSI corresponding to the
> >> + * MSI routing entry
> >> + *
> >> + * This is the entry point for irqfd MSI injection
> >> + * and userspace MSI injection.
> >> + */
> >>  int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> >>  		struct kvm *kvm, int irq_source_id,
> >>  		int level, bool line_status)
> >>  {
> >> -	return 0;
> >> +	struct kvm_msi msi;
> >> +
> >> +	msi.address_lo = e->msi.address_lo;
> >> +	msi.address_hi = e->msi.address_hi;
> >> +	msi.data = e->msi.data;
> >> +	msi.flags = e->flags;
> >> +	msi.devid = e->devid;
> >> +
> >> +	if (!vgic_has_its(kvm))
> >> +		return -ENODEV;
> >> +
> >> +	return vgic_its_inject_msi(kvm, &msi);
> >>  }
> >> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >> index c4f3aba..b254833 100644
> >> --- a/virt/kvm/arm/vgic/vgic.c
> >> +++ b/virt/kvm/arm/vgic/vgic.c
> >> @@ -684,10 +684,3 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
> >>  	return map_is_active;
> >>  }
> >>  
> >> -int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
> >> -{
> >> -	if (vgic_has_its(kvm))
> >> -		return vgic_its_inject_msi(kvm, msi);
> >> -	else
> >> -		return -ENODEV;
> >> -}
> >> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> >> index 32e5646..03632e3 100644
> >> --- a/virt/kvm/irqchip.c
> >> +++ b/virt/kvm/irqchip.c
> >> @@ -29,7 +29,9 @@
> >>  #include <linux/srcu.h>
> >>  #include <linux/export.h>
> >>  #include <trace/events/kvm.h>
> >> +#if !defined(CONFIG_ARM) && !defined(CONFIG_ARM64)
> >>  #include "irq.h"
> >> +#endif
> > 
> > Instead of doing this, shouldn't we add arch/arm[64]/kvm/irq.h files.
> > Probably a simple one like ./arch/s390/kvm/irq.h ?
> 
> Well I considered this solution in the past but I did not find much to
> put there (it was even void). typically irqchip_in_kernel is in
> include/kvm/arm_vgic.h since the macro can be shared between arm/arm64.

I think I'd prefer a nearly empty file to the #ifdef's, but Paolo and
Radim should chime in.

Thanks,
drew

> 
> Thank you for your time!
> 
> Eric
> > 
> > Thanks,
> > drew
> > 
> >>  
> >>  int kvm_irq_map_gsi(struct kvm *kvm,
> >>  		    struct kvm_kernel_irq_routing_entry *entries, int gsi)
> >> -- 
> >> 2.5.5
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe kvm" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
