From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 8/9] KVM: arm/arm64: vgic: Let userspace opt-in to
 writable v2 IGROUPR
Date: Mon, 16 Jul 2018 11:46:57 +0200
Message-ID: <20180716094656.GA30822@e113682-lin.lund.arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
 <1531587940-2490-9-git-send-email-christoffer.dall@arm.com>
 <16b6ec62-4548-3980-073c-2b593d7d4dcb@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8719C4A112
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 05:34:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZsR-iMyVpnzJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 05:34:04 -0400 (EDT)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on0087.outbound.protection.outlook.com [104.47.2.87])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1CB54A106
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 05:34:03 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <16b6ec62-4548-3980-073c-2b593d7d4dcb@arm.com>
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

On Mon, Jul 16, 2018 at 09:38:36AM +0100, Marc Zyngier wrote:
> On 14/07/18 18:05, Christoffer Dall wrote:
> > Simply letting IGROUPR be writable from userspace would break
> > migration from old kernels to newer kernels, because old kernels
> > incorrectly report interrupt groups as group 1.  This would not be a big
> > problem if userspace wrote GICD_IIDR as read from the kernel, because we
> > could detect the incompatibility and return an error to userspace.
> > Unfortunately, this is not the case with current userspace
> > implementations and simply letting IGROUPR be writable from userspace for
> > an emulated GICv2 silently breaks migration and causes the destination
> > VM to no longer run after migration.
> >
> > We now encourage userspace to write the read and expected value of
> > GICD_IIDR as the first part of a GIC register restore, and if we observe
> > a write to GICD_IIDR we know that userspace has been updated and has had
> > a chance to cope with older kernels (VGICv2 IIDR.Revision == 0)
> > incorrectly reporting interrupts as group 1, and therefore we now allow
> > groups to be user writable.
> >
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  include/kvm/arm_vgic.h           |  3 +++
> >  virt/kvm/arm/vgic/vgic-mmio-v2.c | 15 ++++++++++++++-
> >  2 files changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > index c661d0e..c134790 100644
> > --- a/include/kvm/arm_vgic.h
> > +++ b/include/kvm/arm_vgic.h
> > @@ -221,6 +221,9 @@ struct vgic_dist {
> >     /* Implementation revision as reported in the GICD_IIDR */
> >     u32                     implementation_rev;
> >
> > +   /* Userspace can write to GICv2 IGROUPR */
> > +   bool                    v2_groups_user_writable;
> > +
> >     /* Do injected MSIs require an additional device ID? */
> >     bool                    msis_require_devid;
> >
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > index b79de42..9b6b758 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > @@ -85,6 +85,17 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
> >     case GIC_DIST_IIDR:
> >             if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
> >                     return -EINVAL;
> > +
> > +           /*
> > +            * If we observe a write to GICD_IIDR we know that userspace
> > +            * has been updated and has had a chance to cope with older
> > +            * kernels (VGICv2 IIDR.Revision == 0) incorrectly reporting
> > +            * interrupts as group 1, and therefore we now allow gruops to
>
> groups
>
> > +            * be user writable.  Doing this by default would break
> > +            * migration from old kernels to new kernels with legacy
> > +            * userspace.
> > +            */
> > +           vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
>
>               return 0; ?
>
> I think it'd be safer, just in case we decide to do something bizarre in
> vgic_mmio_write_v2_misc...
>

That one was on purpose, as I figured we handle setting values from
userspace and the guest for the other regs in the other function, and it
would be a bit strange that one the one register was special-cased, but
I can see it from the other point of view as well, so I don't mind
changing it.

> >     }
> >
> >     vgic_mmio_write_v2_misc(vcpu, addr, len, val);
> > @@ -95,7 +106,9 @@ static int vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
> >                                         gpa_t addr, unsigned int len,
> >                                         unsigned long val)
> >  {
> > -   /* Ignore writes from userspace */
> > +   if (vcpu->kvm->arch.vgic.v2_groups_user_writable)
> > +           vgic_mmio_write_group(vcpu, addr, len, val);
> > +
> >     return 0;
> >  }
> >
> >
>
> Otherwise looks good..
>

Thanks,
-Christoffer
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
