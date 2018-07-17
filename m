From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v4 10/10] KVM: arm/arm64: vgic: Update documentation of
 the GIC devices wrt IIDR
Date: Tue, 17 Jul 2018 11:13:55 +0200
Message-ID: <20180717091355.GC30570@e113682-lin.lund.arm.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-11-git-send-email-christoffer.dall@arm.com>
 <AM5PR0401MB25454B501D430C2EB6BF1C069A5D0@AM5PR0401MB2545.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B328C4A15F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 05:00:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LD4OwvVPWY+k for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jul 2018 05:00:57 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C294A15C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 05:00:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <AM5PR0401MB25454B501D430C2EB6BF1C069A5D0@AM5PR0401MB2545.eurprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bharat Bhushan <bharat.bhushan@nxp.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 16, 2018 at 03:59:42PM +0000, Bharat Bhushan wrote:
> Hi Christoffer,
> 
> > -----Original Message-----
> > From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-
> > bounces@lists.cs.columbia.edu] On Behalf Of Christoffer Dall
> > Sent: Monday, July 16, 2018 6:36 PM
> > To: kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> > Cc: kvm@vger.kernel.org; Marc Zyngier <marc.zyngier@arm.com>; Andre
> > Przywara <andre.przywara@arm.com>
> > Subject: [PATCH v4 10/10] KVM: arm/arm64: vgic: Update documentation of
> > the GIC devices wrt IIDR
> > 
> > Update the documentation to reflect the ordering requirements of
> > restoring the GICD_IIDR register before any other registers and the
> > effects this has on restoring the interrupt groups for an emulated GICv2
> > insttance.
> > 
> > Also remove some outdated limitations in the documentation while we're
> > at it.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  8 ++++++++
> >  Documentation/virtual/kvm/devices/arm-vgic.txt    | 15 +++++++++------
> >  2 files changed, 17 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> > b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> > index 2408ab7..eba20ae 100644
> > --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> > +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> > @@ -100,6 +100,14 @@ Groups:
> >      Note that distributor fields are not banked, but return the same value
> >      regardless of the mpidr used to access the register.
> > 
> > +    GICD_IIDR.Revision is updated when the KVM implementation is changed
> > in a
> > +    way directly observable by the guest or userspace.  Userspace should
> > read
> > +    GICD_IIDR from KVM and write back the read value to confirm its
> > expected
> > +    behavior is aligned with the KVM implementation.  Userspace should set
> > +    GICD_IIDR before setting any other registers.  to ensure the expected
> > +    behavior.
> > +
> > +
> >      The GICD_STATUSR and GICR_STATUSR registers are architecturally
> > defined such
> >      that a write of a clear bit has no effect, whereas a write with a set bit
> >      clears that value.  To allow userspace to freely set the values of these two
> > diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt
> > b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > index b3ce126..4ff7635 100644
> > --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> > +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > @@ -49,9 +49,15 @@ Groups:
> >      index is specified with the vcpu_index field.  Note that most distributor
> >      fields are not banked, but return the same value regardless of the
> >      vcpu_index used to access the register.
> > -  Limitations:
> > -    - Priorities are not implemented, and registers are RAZ/WI
> > -    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
> > +
> > +    GICD_IIDR.Revision is updated when the KVM implementation of an
> > emulated
> > +    GICv2 is changed in a way directly observable by the guest or userspace.
> > +    Userspace should read GICD_IIDR from KVM and write back the read
> > value to
> > +    confirm its expected behavior is aligned with the KVM implementation.
> > +    Userspace should set GICD_IIDR before setting any other registers (both
> > +    KVM_DEV_ARM_VGIC_GRP_DIST_REGS and
> > KVM_DEV_ARM_VGIC_GRP_CPU_REGS) to ensure
> > +    the expected behavior.  Unless GICD_IIDR has been set from userspace,
> > writes
> > +    to the interrupt group registers (GICD_IGROUPR) are ignored.
> 
> Newer user-space will write to GICD_IIDR, that mean interrupt-groups are supported otherwise not.

It only means that userspace can write interrupt groups, interrupt
groups will always be supported (and writable) from the guest's point of
view with newer kernels.

An updated userspace (which writes IIDR) must know to either raise an
error if it sees a migration stream from an older QEMU or translate the
interrupt groups from 1 to 0 before writing them.

> And when interrupt-groups are not supported then writes to GICD_IGROUPR are ignored (backward compatibility)

Legacy userspace which doesn't write IIDR will not have the above logic
so to preserve migration support between an old kernel and a new kernel,
both with legacy userspace, we ignore userspace writes to the IGROUPRs
in the KVM interface for userspace which hasn't written IIDR.

Hope this helps,
-Christoffer
