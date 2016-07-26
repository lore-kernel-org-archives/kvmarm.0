From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RESEND PATCH v4] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Tue, 26 Jul 2016 11:57:13 +0200
Message-ID: <20160726095713.GB17252@cbox>
References: <20160706113725.32437-1-christoffer.dall@linaro.org>
 <CAFEAcA_OJh+sS-adVP9Z7TDZmPQfsNwfmS1Gxm5EzdVi2FjAwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6D3749B6F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2016 05:49:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 88UuJkpQ6QSv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2016 05:49:18 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48A2049B6D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2016 05:49:18 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id o80so8362324wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2016 02:55:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA_OJh+sS-adVP9Z7TDZmPQfsNwfmS1Gxm5EzdVi2FjAwQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 06, 2016 at 01:03:18PM +0100, Peter Maydell wrote:
> On 6 July 2016 at 12:37, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > Factor out the GICv3-specific documentation into a separate
> > documentation file.  Add description for how to access distributor,
> > redistributor, and CPU interface registers for GICv3 in this new file,
> > and add a group for accessing level triggered IRQ information for GICv3
> > as well.
> >
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> > +    Accesses (reads and writes) to the GICD_ISPENDR register region and
> > +    GICR_ISPENDR0 registers get/set the value of the latched pending state for
> > +    the interrupts.
> > +
> > +    This is identical to the value read from ISPENDR for an edge triggered
> > +    interrupt, but may differ for level triggered interrupts. For edge triggered
> > +    interrupts, once an interrupt becomes pending (whether because of an edge
> > +    detected on the input line or because of a guest write to ISPENDR) this
> > +    state is "latched", and only cleared when either the interrupt is activated
> > +    or when the guest writes to ICPENDR. A level triggered interrupt may be
> > +    pending either because the level input is held high by a device, or because
> > +    of a guest write to the ISPENDR register. Only ISPENDR writes are latched;
> > +    if the device lowers the line level then the interrupt is no longer pending
> > +    unless the guest also wrote to ISPENDR, and conversely writes to ICPENDR or
> > +    activations of the interrupt do not clear the pending status if the line
> > +    level is still being held high.  (These rules are documented in the GICv3
> > +    specification descriptions of the ICPENDR and ISPENDR registers.)
> > +    For a level triggered interrupt the value accessed here
> > +    is that of the latch which is set by ISPENDR and cleared by ICPENDR or
> > +    interrupt activation, whereas the value read from ISPENDR is the logical OR
> > +    of the latch value and the input line level.
> 
> Rereading these paragraphs I think
>  "This is identical to the value returned by a guest read from ISPENDR..."
> (in the first line) and
>  "the value returned by a guest read from the ISPENDR register is the
> logical OR..."
> (at the end) would be clearer, just to make sure we're clear between
> when we're describing the behaviour of the hardware register as seen
> by the guest, and when we're describing the behaviour of a read/write
> through this API. I misread the intention the first time around
> even though  I wrote this text :-)

right, I've added the clarification.

> > +  KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
> > +  Attributes:
> > +    The attr field of kvm_device_attr encodes the following values:
> > +    bits:     | 63      ....       32 | 31   ....    10 | 9  ....  0 |
> > +    values:   |         mpidr         |      info       |   vINTID   |
> > +
> > +    The vINTID specifies which set of IRQs is reported on.
> > +
> > +    The info field specifies which information userspace wants to get or set
> > +    using this interface.  Currently we support two different pieces of
> > +    information:
> > +
> > +      VGIC_LEVEL_INFO_LINE_LEVEL:
> > +       Get/Set the input level of the IRQ line for a set of 32 contiguously
> > +       numbered interrupts.
> > +       vINTID must be a multiple of 32.
> > +
> > +        kvm_device_attr.addr points to a __u32 value which will contain a
> 
> stray extra space at start of line?
> 

It's actually because one of the lines was using a tab and the other
spaces, but I've fixed them to both use tabs.

> > +       bitmap where a set bit means the interrupt level is asserted.
> > +
> > +       Bit[n] indicates the status for interrupt vINTID + n.
> > +
> > +    SGIs and any interrupt with a higher ID than the number of interrupts
> > +    supported, will be RAZ/WI.  LPIs are always edge-triggered and are
> > +    therefore not supported by this interface.
> > +
> > +    PPIs are reported per VCPU as specified in the mpidr field, and SPIs are
> > +    reported with the same value regardless of the mpidr specified.
> > +
> > +    The mpidr field encodes the CPU ID based on the affinity information in the
> > +    architecture defined MPIDR, and the field is encoded as follows:
> > +      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
> > +      |    Aff3    |    Aff2    |    Aff1    |    Aff0   |
> 
> Missing space -- ASCII art doesn't quite line up.

ack

> 
> Otherwise
> Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
> 
> 

Thanks!
-Christoffer
