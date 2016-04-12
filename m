From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 12/45] KVM: arm/arm64: vgic-new: Add MMIO handling
 framework
Date: Tue, 12 Apr 2016 19:26:06 +0200
Message-ID: <20160412172606.GN3039@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-13-git-send-email-andre.przywara@arm.com>
 <20160331090824.GR4126@cbox> <570B8221.3050506@arm.com>
 <20160412125035.GD3039@cbox> <570D1A98.9000300@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 743134053F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 13:24:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svWxatQenWfU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2016 13:24:10 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C50BA400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 13:24:09 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id v188so135968186wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 10:25:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570D1A98.9000300@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 12, 2016 at 04:56:08PM +0100, Marc Zyngier wrote:
> On 12/04/16 13:50, Christoffer Dall wrote:
> > On Mon, Apr 11, 2016 at 11:53:21AM +0100, Andre Przywara wrote:
> >> Hi Christoffer,
> >>
> >> On 31/03/16 10:08, Christoffer Dall wrote:
> >>> Hi Andre,
> >>>
> >>> [cc'ing Paolo here for his thoughts on the KVM IO bus framework]
> >>>
> >>> On Fri, Mar 25, 2016 at 02:04:35AM +0000, Andre Przywara wrote:
> >>>> We register each register group of the distributor and redistributors
> >>>> as separate regions of the kvm-io-bus framework. This way calls get
> >>>> directly handed over to the actual handler.
> >>>> This puts a lot more regions into kvm-io-bus than what we use at the
> >>>> moment on other architectures, so we will probably need to revisit the
> >>>> implementation of the framework later to be more efficient.
> >>>
> >>> Looking more carefully at the KVM IO bus stuff, it looks like it is
> >>> indeed designed to be a *per device* thing you register, not a *per
> >>> register* thing.
> >>>
> >>> My comments to Vladimir's bug report notwithstanding, there's still a
> >>> choice here to:
> >>>
> >>> 1) Expand/modify the KVM IO bus framework to take an arbitrary number of devices
> >>>
> >>> 2) Build a KVM architectureal generic framework on top of the IO bus
> >>> framework to handle individual register regions.
> >>>
> >>> 3) Stick with what we had before, do not modify the KVM IO bus stuff,
> >>> and handle the individual register region business locally within the
> >>> arm/vgic code.
> >>>
> >>>
> >>>>
> >>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >>>> ---
> >>>>  include/kvm/vgic/vgic.h       |   9 ++
> >>>>  virt/kvm/arm/vgic/vgic_mmio.c | 194 ++++++++++++++++++++++++++++++++++++++++++
> >>>>  virt/kvm/arm/vgic/vgic_mmio.h |  47 ++++++++++
> >>>>  3 files changed, 250 insertions(+)
> >>>>  create mode 100644 virt/kvm/arm/vgic/vgic_mmio.c
> >>>>  create mode 100644 virt/kvm/arm/vgic/vgic_mmio.h
> >>>>
> >>>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> >>>> index 2ce9b4a..a8262c7 100644
> >>>> --- a/include/kvm/vgic/vgic.h
> >>>> +++ b/include/kvm/vgic/vgic.h
> >>>> @@ -106,6 +106,12 @@ struct vgic_irq {
> >>>>  	enum vgic_irq_config config;	/* Level or edge */
> >>>>  };
> >>>>  
> >>>> +struct vgic_io_device {
> >>>> +	gpa_t base_addr;
> >>>> +	struct kvm_vcpu *redist_vcpu;
> >>>> +	struct kvm_io_device dev;
> >>>> +};
> >>>> +
> >>>>  struct vgic_dist {
> >>>>  	bool			in_kernel;
> >>>>  	bool			ready;
> >>>> @@ -132,6 +138,9 @@ struct vgic_dist {
> >>>>  	u32			enabled;
> >>>>  
> >>>>  	struct vgic_irq		*spis;
> >>>> +
> >>>> +	struct vgic_io_device	*dist_iodevs;
> >>>> +	struct vgic_io_device	*redist_iodevs;
> >>>>  };
> >>>>  
> >>>>  struct vgic_v2_cpu_if {
> >>>> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> >>>> new file mode 100644
> >>>> index 0000000..26c46e7
> >>>> --- /dev/null
> >>>> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> >>>> @@ -0,0 +1,194 @@
> >>>> +/*
> >>>> + * VGIC MMIO handling functions
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or modify
> >>>> + * it under the terms of the GNU General Public License version 2 as
> >>>> + * published by the Free Software Foundation.
> >>>> + *
> >>>> + * This program is distributed in the hope that it will be useful,
> >>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>> + * GNU General Public License for more details.
> >>>> + */
> >>>> +
> >>>> +#include <linux/kvm.h>
> >>>> +#include <linux/kvm_host.h>
> >>>> +#include <kvm/iodev.h>
> >>>> +#include <kvm/vgic/vgic.h>
> >>>> +#include <linux/bitops.h>
> >>>> +#include <linux/irqchip/arm-gic.h>
> >>>> +
> >>>> +#include "vgic.h"
> >>>> +#include "vgic_mmio.h"
> >>>> +
> >>>> +void write_mask32(u32 value, int offset, int len, void *val)
> >>>> +{
> >>>> +	value = cpu_to_le32(value) >> (offset * 8);
> >>>> +	memcpy(val, &value, len);
> >>>> +}
> >>>> +
> >>>> +u32 mask32(u32 origvalue, int offset, int len, const void *val)
> >>>> +{
> >>>> +	origvalue &= ~((BIT_ULL(len) - 1) << (offset * 8));
> >>>> +	memcpy((char *)&origvalue + (offset * 8), val, len);
> >>>> +	return origvalue;
> >>>> +}
> >>>> +
> >>>> +#ifdef CONFIG_KVM_ARM_VGIC_V3
> >>>> +void write_mask64(u64 value, int offset, int len, void *val)
> >>>> +{
> >>>> +	value = cpu_to_le64(value) >> (offset * 8);
> >>>> +	memcpy(val, &value, len);
> >>>> +}
> >>>> +
> >>>> +/* FIXME: I am clearly misguided here, there must be some saner way ... */
> >>>
> >>> I'm confuses in general.  Can you explain what these mask functions do
> >>> overall at some higher level?
> >>
> >> They do what you already guessed: take care about masking and endianness.
> >>
> >>> I also keep having a feeling that mixing endianness stuff into the
> >>> emulation code itself is the wrong way to go about it.
> >>
> >> I agree.
> >>
> >>>  The emulation
> >>> code should just deal with register values of varying length and the
> >>> interface to the VGIC should abstract all endianness nonsense for us,
> >>> but I also think I've lost this argument some time in the past.  Sigh.
> > 
> > I tend to agree with this.  Who did you loose this argument against and
> > do you have a pointer?
> > 
> >>>
> >>> But, is the maximum read/write unit for any MMIO access not a 64-bit
> >>> value?  So why can't we let the VGIC emulation code simply take/return a
> >>> u64 which is then masked off/morphed into the right endianness outside
> >>> the VGIC code?
> >>
> >> The main problem is that the interface for kvm_io_bus is (int len, void
> >> *val).
> > 
> > That could be solved by always just doing a (u64) conversion on the
> > caller/receiver side.  E.g.
> > 
> > int vgic_handle_mmio_access(..., int len, void *val, bool is_write)
> > {
> > 	u64 data;
> > 
> > 	if (unsupported_vgic_len(len))
> > 		return -ENXIO;
> > 
> > 	if (is_write)
> > 		data = mmio_read_buf(val, len);
> > 
> > 	// data is now just some data of some lenght in a typed register
> > 
> > 	call_range_handler(vcpu, &data, len, ...);
> > 
> > 	if (!is_write)
> > 		mmio_write_buf(val, len, data);
> > }
> > 
> > (and share the mmio_ functions in a header file between mmio.c and
> > consumers of the packed data).
> > 
> > The idea would be that the gic is just emulation code in C, which can be
> > compiled to some endianness, and we really don't care about how it's
> > physically stored in memory.
> > 
> > 
> > 
> >> And since the guest's MMIO access can be of different length, we need to
> >> take care of this in any case (since we need to know how many IRQs we
> >> need to update). So we cannot get rid of the length parameter.
> > 
> > no we cannot, but we can use a typed pointer instead of a void pointer
> > everywhere in the vgic code, since the max access we're going to support
> > is 64 bits.
> > 
> >> I guess what we could do is to either:
> >> a) Declare the VGIC as purely little endian (which it really is, AFAIK).
> >> We care about the necessary endianness conversion in mmio.c before
> >> invoking the kvm_io_bus framework. But that means that we need to deal
> >> with the _host's_ endianness in the VGIC emulation.
> >> I think this is very close to what we currently do.    OR
> >> b) Declare our VGIC emulation as always using the host's endianess. We
> >> wouldn't need to care about endianness in the VGIC code anymore (is that
> >> actually true?) We convert the MMIO traps (which are little endian
> >> always) into the host's endianness before passing it on to kvm-io-bus.
> >>
> >> I just see that this probably adds more to the confusion, oh well...
> > 
> > No, it doesn't add anymore confusion.  I think option (b) is what we
> > should do, unless it's not possible for some reason that I fail to
> > realize at this very moment.
> > 
> > If all your pointers in the vgic emulation code are always typed, then I
> > don't see why you'd have to worry about endianness anywhere?
> > 
> > The only place we should worry about endianness is the
> > vcpu_data_guest_to_host() and vcpu_data_host_to_guest() functions.
> > Doing it anywhere else as well is an indication that we're doing
> > something wrong.
> 
> That seems sensible to me. This should define a frontier where the
> access to the GIC is always expected in LE mode, but we implement the
> GIC using the host endianness. We have to make sure that no data
> structure gets passed outside of this interface (and that includes
> userspace access).

I think userspace accesses are fine.  That's another external interface
where you can handle whatever endianness conversion there.

> 
> This works fine for MMIO, but I'm more worried of memory-based
> interfaces that we get with GICv3 and the ITS, specially with migration.
> Property table is fine (byte access), but pending table can be slightly
> more tricky (bit position in words). And then we get to the ITS tables,
> which need a standard representation. Maybe it is too early for that,
> but it is worth keeping it in mind.
> 
I didn't consider the visible-to-guest in-memory data structures.  We
should define anything that would be affected by endianness strictly,
but I still think we're limited to dealing with endianness in (1) the
MMIO interface, (2) userspace access, (3) flushing the in-kernel cache
to memory data structures.

That's much better than every time we fix some part of the emulation
code, it touches some magic endianness function/trick, and you have to
follow a trail a mile long to figure out all the conversions and whether
it's right or not.  At least I have found this very hard in the past.

Thanks,
-Christoffer
