From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 16:59:54 +0100
Message-ID: <20150215155954.GC8034@cbox>
References: <20150213044613.GA47577@lvm>
 <87k2zms4ub.fsf@linaro.org>
 <87iof6s3o7.fsf@linaro.org>
 <54E05E8A.5020109@web.de>
 <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>
 <54E0AFE8.20202@web.de>
 <87oaovdxvb.fsf@why.wild-wind.fr.eu.org>
 <54E0B646.6030601@web.de>
 <87k2zjdwg4.fsf@why.wild-wind.fr.eu.org>
 <54E0BCB2.9000103@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54E0BCB2.9000103@web.de>
Sender: kvm-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 15, 2015 at 04:35:14PM +0100, Jan Kiszka wrote:
> On 2015-02-15 16:30, Marc Zyngier wrote:
> > On Sun, Feb 15 2015 at  3:07:50 pm GMT, Jan Kiszka <jan.kiszka@web.de> =
wrote:
> >> On 2015-02-15 15:59, Marc Zyngier wrote:
> >>> On Sun, Feb 15 2015 at  2:40:40 pm GMT, Jan Kiszka <jan.kiszka@web.de=
> wrote:
> >>>> On 2015-02-15 14:37, Marc Zyngier wrote:
> >>>>> On Sun, Feb 15 2015 at 8:53:30 am GMT, Jan Kiszka
> >>>>> <jan.kiszka@web.de> wrote:
> >>>>>> I'm now throwing trace_printk at my broken KVM. Already found out =
that I
> >>>>>> get ARM_EXCEPTION_IRQ every few 10 =B5s. Not seeing any irq_* trac=
es,
> >>>>>> though. Weird.
> >>>>>
> >>>>> This very much looks like a screaming interrupt. At such a rate, no
> >>>>> wonder your VM make much progress. Can you find out which interrupt=
 is
> >>>>> screaming like this? Looking at GICC_HPPIR should help, but you'll =
have
> >>>>> to map the CPU interface in HYP before being able to access it ther=
e.
> >>>>
> >>>> OK... let me figure this out. I had this suspect as well - the host =
gets
> >>>> a VM exit for each injected guest IRQ?
> >>>
> >>> Not exactly. There is a VM exit for each physical interrupt that fires
> >>> while the guest is running. Injecting an interrupt also causes a VM
> >>> exit, as we force the vcpu to reload its context.
> >>
> >> Ah, GICC !=3D GICV - you are referring to host-side pending IRQs. Any
> >> hints on how to get access to that register would accelerate the
> >> analysis (ARM KVM code is still new to me).
> >=20
> > Map the GICC region in HYP using create_hyp_io_mapping (see
> > vgic_v2_probe for an example of how we map GICH), and stash the read of
> > GICC_HPPIR before leaving HYP mode (and before saving the guest timer).
>=20
> OK.
>=20
> >=20
> > BTW, when you look at /proc/interrupts on the host, don't you see an
> > interrupt that's a bit too eager to fire?
>=20
> No - but that makes sense given that we do not enter any interrupt
> handler according to ftrace, thus there can't be any counter incrementati=
on.
>=20
> >=20
> >>>> BTW, I also tried with in-kernel GIC disabled (in the kernel config),
> >>>> but I guess that's pointless. Linux seems to be stuck on a
> >>>> non-functional architectural timer then, right?
> >>>
> >>> Yes. Useful for bringup, but nothing more.
> >>
> >> Maybe we should perform a feature check and issue a warning from QEMU?
> >=20
> > I'd assume this is already in place (but I almost never run QEMU, so I
> > could be wrong here).
>=20
> Nope, QEMU starts up fine, just lets the guest starve while waiting for
> jiffies to increase.
>=20

you should be able to turn the in-kernel irqchip off with a QEMU
command-line option and the that should prevent the kernel from adding
an arch-timer.  This would only work on the vexpress guest model though,
since the virt-board doesn't provide an emulated timer as a replacement.

-Christoffer

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJU4MJ6AAoJEEtpOizt6ddyv24H/i5ZuKu6/7ha0tsBSGKW0GMU
D6FADa5OZLVgCgnEbWPwrWPUui5f2QcbxoujDMowQRX4SfUfMMKRUS1h1F1cf5L6
OfygB3R/wInAczhBTI7ENhveX/DMyHIeZ1Yb8An7gmoKPOM/xnL0K/+4HZsMKkHi
5ENk9CklPS1E6tZgyj27KEOMTaN6/3aHytuQwvn1nA+suaRCHz0ihsWC6a50vcv0
Iog3HNvMc8+7WJ8UUWkGyhr7ZQsIdXNxRHHgtf1fPLdom1UCL3cPc5VgICGK36uL
al61o7a0bvetwCHuK5Tv9XWqmqtH39t/ri7RmRLi9Rvm8NQkC3epOo/jYPB84AM=
=5NLt
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
