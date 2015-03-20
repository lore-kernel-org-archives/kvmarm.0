From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 08/12] KVM: arm/arm64: implement kvm_io_bus MMIO handling
 for the VGIC
Date: Fri, 20 Mar 2015 15:24:23 +0100
Message-ID: <20150320142423.GF23225@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-9-git-send-email-andre.przywara@arm.com>
 <20150314142720.GD10935@cbox>
 <550AEEF3.80702@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <550AEEF3.80702@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 19, 2015 at 03:44:51PM +0000, Andre Przywara wrote:
> Hej Christoffer,
> 
> On 14/03/15 14:27, Christoffer Dall wrote:
> > On Fri, Mar 13, 2015 at 04:10:08PM +0000, Andre Przywara wrote:
> >> Currently we use a lot of VGIC specific code to do the MMIO
> >> dispatching.
> >> Use the previous reworks to add kvm_io_bus style MMIO handlers.
> >>
> >> Those are not yet called by the MMIO abort handler, also the actual
> >> VGIC emulator function do not make use of it yet, but will be enabled
> >> with the following patches.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  include/kvm/arm_vgic.h |    9 ++++
> >>  virt/kvm/arm/vgic.c    |  111 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic.h    |    7 +++
> >>  3 files changed, 127 insertions(+)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index b81630b..4bfc6a3 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -24,6 +24,7 @@
> >>  #include <linux/irqreturn.h>
> >>  #include <linux/spinlock.h>
> >>  #include <linux/types.h>
> >> +#include <kvm/iodev.h>
> >>
> >>  #define VGIC_NR_IRQS_LEGACY 256
> >>  #define VGIC_NR_SGIS                16
> >> @@ -147,6 +148,14 @@ struct vgic_vm_ops {
> >>      int     (*map_resources)(struct kvm *, const struct vgic_params *);
> >>  };
> >>
> >> +struct vgic_io_device {
> >> +    gpa_t addr;
> >> +    int len;
> >> +    const struct vgic_io_range *reg_ranges;
> >> +    struct kvm_vcpu *redist_vcpu;
> >> +    struct kvm_io_device dev;
> >> +};
> >> +
> >>  struct vgic_dist {
> >>      spinlock_t              lock;
> >>      bool                    in_kernel;
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index 7aae19b..71389b8 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -32,6 +32,8 @@
> >>  #include <asm/kvm_arm.h>
> >>  #include <asm/kvm_mmu.h>
> >>  #include <trace/events/kvm.h>
> >> +#include <asm/kvm.h>
> >> +#include <kvm/iodev.h>
> >>
> >>  /*
> >>   * How the whole thing works (courtesy of Christoffer Dall):
> >> @@ -774,6 +776,66 @@ bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >>  }
> >>
> >>  /**
> >> + * vgic_handle_mmio_access - handle an in-kernel MMIO access
> >> + * This is called by the read/write KVM IO device wrappers below.
> >> + * @vcpu:   pointer to the vcpu performing the access
> >> + * @this:   pointer to the KVM IO device in charge
> >> + * @addr:   guest physical address of the access
> >> + * @len:    size of the access
> >> + * @val:    pointer to the data region
> >> + * @is_write:       read or write access
> >> + *
> >> + * returns true if the MMIO access could be performed
> >> + */
> >> +static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
> >> +                               struct kvm_io_device *this, gpa_t addr,
> >> +                               int len, void *val, bool is_write)
> >> +{
> >> +    struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> >> +    struct vgic_io_device *iodev = container_of(this,
> >> +                                                struct vgic_io_device, dev);
> >> +    struct kvm_run *run = vcpu->run;
> >> +    const struct vgic_io_range *range;
> >> +    struct kvm_exit_mmio mmio;
> >> +    bool updated_state;
> >> +    gpa_t offset;
> >> +
> >> +    offset = addr - iodev->addr;
> >> +    range = vgic_find_range(iodev->reg_ranges, len, offset);
> >> +    if (unlikely(!range || !range->handle_mmio)) {
> >> +            pr_warn("Unhandled access %d %08llx %d\n", is_write, addr, len);
> >> +            return -ENXIO;
> >> +    }
> >> +
> >> +    mmio.phys_addr = addr;
> >> +    mmio.len = len;
> >> +    mmio.is_write = is_write;
> >> +    if (is_write)
> >> +            memcpy(mmio.data, val, len);
> >> +    mmio.private = iodev->redist_vcpu;
> >> +
> >> +    spin_lock(&dist->lock);
> >> +    offset -= range->base;
> >> +    if (vgic_validate_access(dist, range, offset)) {
> >> +            updated_state = call_range_handler(vcpu, &mmio, offset, range);
> >> +            if (!is_write)
> >> +                    memcpy(val, mmio.data, len);
> >> +    } else {
> >> +            if (!is_write)
> >> +                    memset(val, 0, len);
> >> +            updated_state = false;
> >> +    }
> >> +    spin_unlock(&dist->lock);
> >> +    kvm_prepare_mmio(run, &mmio);
> >
> > we're not the only user of kvm_exit_mmio I believe, so we could rename
> 
> (assuming you mean we _are_ the only user here, which I can acknowledge)
> 

yes, I think wanted to write now, not not.

> > this to vgic_io as well and you could change the mmio.data array to be a
> > void *val pointer, which just gets set to the pointer passed into this
> > function (which I think points to the kvm_run structs data array) and
> > you can avoid all these memcopies, right?
> 
> That sounds indeed tempting, but the comment on the struct kvm_exit_mmio
> declaration reads:
> /*
>  * The in-kernel MMIO emulation code wants to use a copy of run->mmio,
>  * which is an anonymous type. Use our own type instead.
>  */
> How I understand this the structure was introduced to _not_ use the same
> memory, but use a copy instead. Do you remember any reason for this? And
> in how far is this type anonymous? It's even in an uapi header.

the kvm exit api is designed without regard for how anything in-kernel
works.  Since the work we were doing was leveraging some of the handling
that pointed to the anonymous struct from user-space, we just copied its
definition.

> 
> Briefly looking at the code we do quite some memcpy on the way.
> I am about to go all the way down into that ARM MMIO handling cave now
> to check this (Marc, if I am not showing up again after some hours,
> please come and rescue me ;-)
> 

For the purposes of this series, the struct is just private vgic
parameter passing now.  You just use the struct kvm_exit_mmio pointer
inside the vgic code to call the range handlers.  You don't have to do
that, you can just define your own struct, call it vgic_mmio_params or
whatever, and instead of it having a data array, it now has a data
pointer.

What I think you'll find is that our need for struct kvm_exit_mmio then
goes away, because it is superseeded by what the kvm dev io bus thingy
now uses, and with some clever pattern matching the code should be
fairly trivial, with the worst part being changing the pointer type in
some places.

If it blows up and I missed something, we can leave this for a future
optimization, but it doesn't sound all that scary to me.

Thanks,
-Christoffer
