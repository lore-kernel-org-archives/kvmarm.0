From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 15:40:40 +0100
Message-ID: <54E0AFE8.20202@web.de>
References: <54D714B9.6090106@web.de> <20150213044613.GA47577@lvm>	<87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org>	<54E05E8A.5020109@web.de> <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RoPAbddmhalfQBQvHEGEHIrjpU4SOBhLo"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RoPAbddmhalfQBQvHEGEHIrjpU4SOBhLo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-02-15 14:37, Marc Zyngier wrote:
> On Sun, Feb 15 2015 at  8:53:30 am GMT, Jan Kiszka <jan.kiszka@web.de> =
wrote:
>> I'm now throwing trace_printk at my broken KVM. Already found out that=
 I
>> get ARM_EXCEPTION_IRQ every few 10 =C2=B5s. Not seeing any irq_* trace=
s,
>> though. Weird.
>=20
> This very much looks like a screaming interrupt. At such a rate, no
> wonder your VM make much progress. Can you find out which interrupt is
> screaming like this? Looking at GICC_HPPIR should help, but you'll have=

> to map the CPU interface in HYP before being able to access it there.

OK... let me figure this out. I had this suspect as well - the host gets
a VM exit for each injected guest IRQ?

BTW, I also tried with in-kernel GIC disabled (in the kernel config),
but I guess that's pointless. Linux seems to be stuck on a
non-functional architectural timer then, right?

>=20
> Do you have an form of power-management on this system?

Just killed every config that has PM for FREQ in its name, but that
makes no difference.

Jan



--RoPAbddmhalfQBQvHEGEHIrjpU4SOBhLo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTgr+gACgkQitSsb3rl5xQIswCfSYdCssxHTEf4cU0rLjdunMEC
KFoAn0Y81AcAuFS+0qtAVvTJGdeDJlav
=Brps
-----END PGP SIGNATURE-----

--RoPAbddmhalfQBQvHEGEHIrjpU4SOBhLo--
