From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 9/9] KVM: arm/arm64: vgic: Update documentation of the
 GICv2 device
Date: Mon, 16 Jul 2018 11:54:44 +0200
Message-ID: <20180716095444.GB30822@e113682-lin.lund.arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
 <1531587940-2490-10-git-send-email-christoffer.dall@arm.com>
 <a5324e35-53b4-b5b4-84a2-1e0a89b244e7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6DE4A112
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 05:41:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5k0a0o1zNByS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 05:41:50 -0400 (EDT)
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr40082.outbound.protection.outlook.com [40.107.4.82])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A0354A0F6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 05:41:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <a5324e35-53b4-b5b4-84a2-1e0a89b244e7@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 16, 2018 at 09:52:04AM +0100, Marc Zyngier wrote:
> On 14/07/18 18:05, Christoffer Dall wrote:
> > Update the documentation to reflect the ordering requirements of
> > restoring GICv2 distributor registers and remove outdated limitations in
> > the documentation while we're at it.
> >
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  Documentation/virtual/kvm/devices/arm-vgic.txt | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > index b3ce126..c9a6393 100644
> > --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> > +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > @@ -49,9 +49,12 @@ Groups:
> >      index is specified with the vcpu_index field.  Note that most distributor
> >      fields are not banked, but return the same value regardless of the
> >      vcpu_index used to access the register.
> > -  Limitations:
> > -    - Priorities are not implemented, and registers are RAZ/WI
> > -    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
> > +
> > +    GICD_IIDR.Revision is updated when the KVM implementation of an emulated
> > +    GICv2 is changed.  Userspace should read GICD_IIDR from KVM and write back
> > +    the read value to confirm its expected behavior is aligned with the KVM
> > +    implementation.  To properly restore the interrupt group configuration,
> > +    GICD_IIDR should be written before any other registers.
>
> I'd like to make it crystal clear that writing to IIDR doesn't allow to
> select a behaviour, and is merely a confirmation that host and guest do
> agree on either revision 0 (no write) or revision n (n being read and
> written back).
>
> Also, on ordering: does the write to IIDR have to happen before any
> write to other distributor registers? Or to any GIC register? I think
> you mean the former, but I wonder if we shouldn't mandate the latter,
> just to be sure...
>

I was thinking that IIDR should simply be the very first thing you
write, I'll clarify the intent.

> >    Errors:
> >      -ENXIO: Getting or setting this register is not yet supported
> >      -EBUSY: One or more VCPUs are running
> > @@ -94,9 +97,6 @@ Groups:
> >      use the lower 5 bits to communicate with the KVM device and must shift the
> >      value left by 3 places to obtain the actual priority mask level.
> >
> > -  Limitations:
> > -    - Priorities are not implemented, and registers are RAZ/WI
> > -    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
> >    Errors:
> >      -ENXIO: Getting or setting this register is not yet supported
> >      -EBUSY: One or more VCPUs are running
> >
>
> Finally, do we want to to extend the same requirements to GICv3, for the
> sake of uniformity?

Probably.  I'll check the userspace implementation if that would break
compatibility with today.

Thanks,
-Christoffer
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
