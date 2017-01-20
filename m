From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Add debugfs vgic-state file
Date: Fri, 20 Jan 2017 21:07:08 +0100
Message-ID: <20170120200708.GM13531@cbox>
References: <20170120103330.13858-1-christoffer.dall@linaro.org>
 <d63155bc-84f3-85cc-ec32-5a73e635b774@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d63155bc-84f3-85cc-ec32-5a73e635b774@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Alex Bennee <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On Fri, Jan 20, 2017 at 06:07:26PM +0000, Andre Przywara wrote:
> Hej Christoffer,
> 
> On 20/01/17 10:33, Christoffer Dall wrote:
> > Add a file to debugfs to read the in-kernel state of the vgic.  We don't
> > do any locking of the entire VGIC state while traversing all the IRQs,
> > so if the VM is running the user/developer may not see a quiesced state,
> > but should take care to pause the VM using facilities in user space for
> > that purpose.
> > 
> > We also don't support LPIs yet, but they can be added easily if needed.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm/kvm/Makefile          |   1 +
> >  arch/arm64/kvm/Makefile        |   1 +
> >  include/kvm/arm_vgic.h         |   5 +
> >  virt/kvm/arm/vgic/vgic-debug.c | 278 +++++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/arm/vgic/vgic-init.c  |   4 +
> >  virt/kvm/arm/vgic/vgic.h       |   3 +
> >  6 files changed, 292 insertions(+)
> >  create mode 100644 virt/kvm/arm/vgic/vgic-debug.c
> > 
> > diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> > index d571243..12b6281 100644
> > --- a/arch/arm/kvm/Makefile
> > +++ b/arch/arm/kvm/Makefile
> > @@ -33,5 +33,6 @@ obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
> >  obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
> >  obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
> >  obj-y += $(KVM)/arm/vgic/vgic-its.o
> > +obj-y += $(KVM)/arm/vgic/vgic-debug.o
> >  obj-y += $(KVM)/irqchip.o
> >  obj-y += $(KVM)/arm/arch_timer.o
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index d50a82a..e025bec 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -31,6 +31,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
> >  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
> >  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
> >  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
> > +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-debug.o
> >  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> >  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
> >  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > index 002f092..1087aee 100644
> > --- a/include/kvm/arm_vgic.h
> > +++ b/include/kvm/arm_vgic.h
> > @@ -165,6 +165,8 @@ struct vgic_its {
> >  	struct list_head	collection_list;
> >  };
> >  
> > +struct vgic_state_iter;
> > +
> >  struct vgic_dist {
> >  	bool			in_kernel;
> >  	bool			ready;
> > @@ -212,6 +214,9 @@ struct vgic_dist {
> >  	spinlock_t		lpi_list_lock;
> >  	struct list_head	lpi_list_head;
> >  	int			lpi_list_count;
> > +
> > +	/* used by vgic-debug */
> > +	struct vgic_state_iter *iter;
> >  };
> >  
> >  struct vgic_v2_cpu_if {
> > diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
> > new file mode 100644
> > index 0000000..76e8b11
> > --- /dev/null
> > +++ b/virt/kvm/arm/vgic/vgic-debug.c
> > @@ -0,0 +1,278 @@
> > +/*
> > + * Copyright (C) 2016 Linaro
> > + * Author: Christoffer Dall <christoffer.dall@linaro.org>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/cpu.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/kvm_host.h>
> > +#include <linux/seq_file.h>
> > +#include <linux/uaccess.h>
> > +#include <kvm/arm_vgic.h>
> > +#include <asm/kvm_mmu.h>
> > +#include "vgic.h"
> > +
> > +/*
> > + * Structure to control looping through the entire vgic state.  We start at
> > + * zero for each field and move upwards.  So, if dist_id is 0 we print the
> > + * distributor info.  When dist_id is 1, we have already printed it and move
> > + * on.
> > + *
> > + * When vcpu_id < nr_cpus we print the vcpu info until vcpu_id == nr_cpus and
> > + * so on.
> > + */
> > +struct vgic_state_iter {
> > +	int nr_cpus;
> > +	int nr_spis;
> > +	int dist_id;
> > +	int vcpu_id;
> > +	int intid;
> > +};
> > +
> > +static void iter_next(struct vgic_state_iter *iter)
> > +{
> > +	if (iter->dist_id == 0) {
> > +		iter->dist_id++;
> > +		return;
> > +	}
> > +
> > +	iter->intid++;
> > +	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
> > +	    ++iter->vcpu_id < iter->nr_cpus)
> > +		iter->intid = 0;
> > +}
> > +
> > +static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
> > +		      loff_t pos)
> > +{
> > +	int nr_cpus = atomic_read(&kvm->online_vcpus);
> > +
> > +	memset(iter, 0, sizeof(*iter));
> > +
> > +	iter->nr_cpus = nr_cpus;
> > +	iter->nr_spis = kvm->arch.vgic.nr_spis;
> > +
> > +	/* Fast forward to the right position if needed */
> > +	while (pos--)
> > +		iter_next(iter);
> > +}
> > +
> > +static bool the_end(struct vgic_state_iter *iter)
> 
> "Of everything that stands, the end"? ;-)

"It's the end of the world as we know it".  How appropriate on this day.


> 
> I wonder if we really need this. AFAICT the_end never returns true after
> init has been called, so the only caller is after the iter_next(). So
> can't we just close the Door(s) and fold the_end() into
> iter_next()?
> 

see below.

> > +{
> > +	return iter->dist_id > 0 &&
> > +		iter->vcpu_id == iter->nr_cpus &&
> > +		(iter->intid - VGIC_NR_PRIVATE_IRQS) == iter->nr_spis;
> > +}
> > +
> > +static void *debug_start(struct seq_file *s, loff_t *pos)
> > +{
> > +	struct kvm *kvm = (struct kvm *)s->private;
> > +	struct vgic_state_iter *iter;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	iter = kvm->arch.vgic.iter;
> > +	if (iter) {
> > +		iter = ERR_PTR(-EBUSY);
> > +		goto out;
> > +	}
> > +
> > +	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
> > +	if (!iter) {
> > +		iter = ERR_PTR(-ENOMEM);
> > +		goto out;
> > +	}
> > +
> > +	iter_init(kvm, iter, *pos);
> > +	kvm->arch.vgic.iter = iter;
> > +
> > +	if (the_end(iter))
> > +		iter = NULL;
> 
> I don't understand the need for that. If you have just initialized iter,
> the_end() will never return true, as at least dist_id is always 0.
> Or is there some magic (maybe future?) feature that I miss here?
> 

This has file position semantics, so it's possible to call debug_start
with a non-zero offset, and in fact possible to jump all the way ahead
past the end of the file.  In this case, this function must return NULL.

I base this on a number of examples out there (there's a recent one on
lwn.net) and on trying to understand the seq file logic.

> > +out:
> > +	mutex_unlock(&kvm->lock);
> > +	return iter;
> > +}
> > +
> > +static void *debug_next(struct seq_file *s, void *v, loff_t *pos)
> > +{
> > +	struct kvm *kvm = (struct kvm *)s->private;
> > +	struct vgic_state_iter *iter = kvm->arch.vgic.iter;
> > +
> > +	++*pos;
> > +	iter_next(iter);
> > +	if (the_end(iter))
> > +		iter = NULL;
> > +	return iter;
> > +}
> > +
> > +static void debug_stop(struct seq_file *s, void *v)
> > +{
> > +	struct kvm *kvm = (struct kvm *)s->private;
> > +	struct vgic_state_iter *iter;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	iter = kvm->arch.vgic.iter;
> > +	kfree(iter);
> > +	kvm->arch.vgic.iter = NULL;
> 
> Would it be better to set the kvm->iter pointer to NULL before we free
> it? Or doesn't this matter as we are under the lock and the only other
> code who cares is debug_start()?

Yeah, that would be the definition of a critical section wouldn't it?

I don't mind moving it around though, if it makes some

> 
> So far, need to wrap my mind around this sequential file operations
> scheme first ...
> 

Thanks for having a look.  I don't think we need to overdo this one,
it's a debug feature, it seems pretty stable, and you need root access
to look at it, but of course it shouldn't be entirely shitty either.

Thanks,
-Christoffer
