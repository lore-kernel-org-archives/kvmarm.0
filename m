From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-SPIs
Date: Thu, 1 Dec 2016 12:15:49 +0000
Message-ID: <5FC3163CFD30C246ABAA99954A238FA81747812F@lhreml504-mbs>
References: <1480584341-32340-1-git-send-email-marc.zyngier@arm.com>
 <1480584341-32340-2-git-send-email-marc.zyngier@arm.com>
 <5FC3163CFD30C246ABAA99954A238FA817475F7E@lhreml504-mbs>
 <be0586f4-57b7-b732-f97e-34798f57e066@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1264406F1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 07:15:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dTueM19c2pgD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 07:15:12 -0500 (EST)
Received: from lhrrgout.huawei.com (lhrrgout.huawei.com [194.213.3.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9079E404D5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 07:15:12 -0500 (EST)
In-Reply-To: <be0586f4-57b7-b732-f97e-34798f57e066@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Marc Zyngier [mailto:marc.zyngier@arm.com]
> Sent: Thursday, December 01, 2016 10:58 AM
> To: Shameerali Kolothum Thodi; Paolo Bonzini; Radim Kr=E8m=E1=F8
> Cc: Catalin Marinas; kvmarm@lists.cs.columbia.edu; linux-arm-
> kernel@lists.infradead.org; kvm@vger.kernel.org
> Subject: Re: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-
> SPIs
> =

> On 01/12/16 10:28, Shameerali Kolothum Thodi wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-
> >> bounces@lists.cs.columbia.edu] On Behalf Of Marc Zyngier
> >> Sent: Thursday, December 01, 2016 9:26 AM
> >> To: Paolo Bonzini; Radim Kr=E8m=E1=F8
> >> Cc: Catalin Marinas; kvmarm@lists.cs.columbia.edu; linux-arm-
> >> kernel@lists.infradead.org; kvm@vger.kernel.org
> >> Subject: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-SPIs
> >>
> >> When we inject a level triggerered interrupt (and unless it is
> backed
> >> by the physical distributor - timer style), we request a maintenance
> >> interrupt. Part of the processing for that interrupt is to feed to
> the
> >> rest of KVM (and to the eventfd subsystem) the information that the
> >> interrupt has been EOIed.
> >>
> >> But that notification only makes sense for SPIs, and not PPIs (such
> as
> >> the PMU interrupt). Skip over the notification if the interrupt is
> not
> >> an SPI.
> >
> > Just to clarify my understanding, the maintenance interrupt is
> generated
> > for cases where there is no mapping of virt to phys interrupts
> > (ie, ICH_LR HW bit is not set). And I was under the impression that
> > kvm_notify_acked_irq will eventually deactivate the interrupt on
> distributor
> > for such cases. Its not clear to me how the deactivation is done
> > otherwise.
> >
> > Could you please help me to understand this better.
> =

> kvm_notify_acked_irq() doesn't do *anything* at the distributor level,
> ever (it has no idea of anything GIC-specific anyway). It's sole job is
> to signal the rest of the stack that an interrupt has been EOIed in the
> guest.

Thanks Marc. Understood. I got confused by the kvm_set_irq in the =

kvm_notify_acked_irq path. =


> For these interrupts, which are purely virtual, there is absolutely
> nothing to do at the physical distributor level anyway. Furthermore,
> kvm_notify_acked_irq doesn't know about per-cpu interrupt, which is why
> we cannot notify them.

Just to confirm, that means for any phys interrupt(PPI/SPI) to be injected
to the Guest, the mapping bit has(HW bit set) to be used.

Thanks,
Shameer
