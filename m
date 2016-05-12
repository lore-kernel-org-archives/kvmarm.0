From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 29/55] KVM: arm/arm64: vgic-new: Add TARGET registers
 handlers
Date: Thu, 12 May 2016 10:54:49 +0200
Message-ID: <20160512085449.GA2370@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-30-git-send-email-andre.przywara@arm.com>
 <20160512083549.GZ27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A04412A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 04:51:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WNd2p6du73dB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 04:51:13 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04B9A40F90
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 04:51:12 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id n129so250119860wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 01:54:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160512083549.GZ27623@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 12, 2016 at 10:35:49AM +0200, Christoffer Dall wrote:
> On Fri, May 06, 2016 at 11:45:42AM +0100, Andre Przywara wrote:
> > The target register handlers are v2 emulation specific, so their
> > implementation lives entirely in vgic-mmio-v2.c.
> > We copy the old VGIC behaviour of assigning an IRQ to the first VCPU
> > set in the target mask instead of making it possibly pending on
> > multiple VCPUs.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> > Changelog RFC..v1:
> > - remove runtime VCPU determination from this v2-only register
> > - fold in implementation of vgic_v2_irq_change_affinity()
> > - replace ffs() with __ffs()
> > 
> > Changelog v1 .. v2:
> > - adapt to new MMIO framework
> > 
> >  virt/kvm/arm/vgic/vgic-mmio-v2.c | 43 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 42 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > index 2a953ec..888529e 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > @@ -66,6 +66,47 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
> >  	}
> >  }
> >  
> > +static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
> > +					   gpa_t addr, unsigned int len)
> > +{
> > +	u32 intid = addr & 0x3ff;
> > +	int i;
> > +	u64 val = 0;
> > +
> > +	for (i = 0; i < len; i++) {
> > +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> > +
> > +		val |= (u64)irq->targets << (i * 8);
> > +	}
> > +
> > +	return val;
> 
> this register should allow byte access, so you're missing a call to
> extract_bytes() ?
> 
Strike that, not enough coffee this morning.

I was in the mindset that val was always being constructed as the full
32-bit register value.

> 
> > +}
> > +
> > +static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
> > +				   gpa_t addr, unsigned int len,
> > +				   unsigned long val)
> > +{
> > +	u32 intid = addr & 0x3ff;
> > +	int i;
> > +
> > +	/* GICD_ITARGETSR[0-7] are read-only */
> > +	if (intid < VGIC_NR_PRIVATE_IRQS)
> > +		return;
> > +
> > +	for (i = 0; i < len; i++) {
> > +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid + i);
> > +		int target;
> > +
> > +		spin_lock(&irq->irq_lock);
> > +
> > +		irq->targets = (val >> (i * 8)) & 0xff;
> 
> this doesn't seem right given byte accesses either, and I don't see the
> fixups we have in the works fixing it...
> 

Strike that too, sorry.

-Christoffer
