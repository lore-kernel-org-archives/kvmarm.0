From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm/arm64: vgic: Virtual interrupt grouping
 support
Date: Fri, 29 Jun 2018 12:45:39 +0200
Message-ID: <20180629104539.GG8441@e113682-lin.lund.arm.com>
References: <20180624221103.15055-1-christoffer.dall@arm.com>
 <CAFEAcA_C6Voh_6Ljj9--cbo14X_uWTOekM30dU=Rp9CtZK-6ow@mail.gmail.com>
 <20180625101347.GF8004@C02W217FHV2R.local>
 <20180625115603.GG8004@C02W217FHV2R.local>
 <86h8lmyn28.wl-marc.zyngier@arm.com>
 <20180629092816.GE8441@e113682-lin.lund.arm.com>
 <86d0w9zysj.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <86d0w9zysj.wl-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 29, 2018 at 11:12:44AM +0100, Marc Zyngier wrote:
> On Fri, 29 Jun 2018 10:28:16 +0100,
> Christoffer Dall <christoffer.dall@arm.com> wrote:
> >
> > On Fri, Jun 29, 2018 at 10:11:27AM +0100, Marc Zyngier wrote:
> > > On Mon, 25 Jun 2018 12:56:03 +0100,
> > > Christoffer Dall <christoffer.dall@arm.com> wrote:
> > > >
> > > > On Mon, Jun 25, 2018 at 12:13:47PM +0200, Christoffer Dall wrote:
> > > > > On Mon, Jun 25, 2018 at 10:52:41AM +0100, Peter Maydell wrote:
> > > > > Interesting.  For GICv2, I think this will actually break, and the
> > > > > migrated Linux guest won't see any interrupts anymore (Linux only sets
> > > > > bit 0 in GICD_CTLR).  For GICv3, everything stays group 1 unless the
> > > > > guest is specifically trying to configure group 0 for something.
> > > > >
> > > > > I suppose this means we need to let userspace request
> > > > > ARCH_COMPLIANT_GICV2 and otherwise ignore userspace writes to IGROUPR?
> > > > >
> > > > Alternatively, we could deny (fail) migration where the
> > > > GICD_IIDR.Revision does not match the source, and just let userspace fix
> > > > things up.  Thoughts?
> > >
> > > That's exactly the kind of thing I had in mind when I suggested to
> > > bump up the IIDR. It allows us to push the knowledge of the quirks to
> > > both the guest and userspace, instead of adding more esoteric API
> > > features.
> > >
> >
> > The problem with that is that upgrading the kernel (but not QEMU) on
> > your destination machine now breaks migration.  Is that acceptable?
>
> Each time we add a new sysreg, we do break migration as well (in the
> other direction though), and I'm not sure we can do much about it
> (that's a QEMU policy, and not the kernel's).
>
> What we could do is to allow IIDR to be written from userspace, and
> pick one behaviour or the other. This would allow compatibility in the
> forward direction, at least, and we have the ITS as a precedent for
> this behaviour.
>

To make things work without imposing an ordering requirement on the
order of GIC register restore, we could then zero all groups when
writing the old IIDR and ignore future writes to GICD_IGROUPR from that
point, and otherwise not do anything for the IIDR.  Esssentially doing
the conversion in the kernel.  Might not be too bad actually.

Thanks,
-Christoffer
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
