From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 16:07:50 +0100
Message-ID: <54E0B646.6030601@web.de>
References: <54D714B9.6090106@web.de> <20150213044613.GA47577@lvm>	<87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org>	<54E05E8A.5020109@web.de> <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>	<54E0AFE8.20202@web.de> <87oaovdxvb.fsf@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="cNAaXvHCnX1efFjMHcU0LjC7H59r3hBg7"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87oaovdxvb.fsf@why.wild-wind.fr.eu.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cNAaXvHCnX1efFjMHcU0LjC7H59r3hBg7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-02-15 15:59, Marc Zyngier wrote:
> On Sun, Feb 15 2015 at  2:40:40 pm GMT, Jan Kiszka <jan.kiszka@web.de> =
wrote:
>> On 2015-02-15 14:37, Marc Zyngier wrote:
>>> On Sun, Feb 15 2015 at  8:53:30 am GMT, Jan Kiszka <jan.kiszka@web.de=
> wrote:
>>>> I'm now throwing trace_printk at my broken KVM. Already found out th=
at I
>>>> get ARM_EXCEPTION_IRQ every few 10 =C2=B5s. Not seeing any irq_* tra=
ces,
>>>> though. Weird.
>>>
>>> This very much looks like a screaming interrupt. At such a rate, no
>>> wonder your VM make much progress. Can you find out which interrupt i=
s
>>> screaming like this? Looking at GICC_HPPIR should help, but you'll ha=
ve
>>> to map the CPU interface in HYP before being able to access it there.=

>>
>> OK... let me figure this out. I had this suspect as well - the host ge=
ts
>> a VM exit for each injected guest IRQ?
>=20
> Not exactly. There is a VM exit for each physical interrupt that fires
> while the guest is running. Injecting an interrupt also causes a VM
> exit, as we force the vcpu to reload its context.

Ah, GICC !=3D GICV - you are referring to host-side pending IRQs. Any
hints on how to get access to that register would accelerate the
analysis (ARM KVM code is still new to me).

>=20
>> BTW, I also tried with in-kernel GIC disabled (in the kernel config),
>> but I guess that's pointless. Linux seems to be stuck on a
>> non-functional architectural timer then, right?
>=20
> Yes. Useful for bringup, but nothing more.

Maybe we should perform a feature check and issue a warning from QEMU?

>=20
>>>
>>> Do you have an form of power-management on this system?
>>
>> Just killed every config that has PM for FREQ in its name, but that
>> makes no difference.
>=20
> I still wonder if the 4+1 design on the K1 is not playing tricks behind=

> our back. Having talked to Ian Campbell earlier this week, he also can'=
t
> manage to run guests in Xen on this platform, so there's something
> rather fishy here.

Interesting. The announcements of his PSCI patches [1] sounded more
promising. Maybe it was only referring to getting the hypervisor itself
running...

To my current (still limited understanding) of that platform would say
that this little core is parked after power-up of the main APs. And as
we do not power them down, there is no reason to perform a cluster
switch or anything similarly nasty, no?

Jan

PS: For those with such a board in reach, newer U-Boot patches are
available at [2] now.

[1] http://permalink.gmane.org/gmane.comp.boot-loaders.u-boot/208034
[2] https://github.com/siemens/u-boot/commits/jetson-tk1-v2


--cNAaXvHCnX1efFjMHcU0LjC7H59r3hBg7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTgtkYACgkQitSsb3rl5xTU5ACdE/vhaf/WSC7QOAcg6WlG1CFu
EWsAn25f7G8LulqfZFpIrmvFxlDZnCCm
=+Ib2
-----END PGP SIGNATURE-----

--cNAaXvHCnX1efFjMHcU0LjC7H59r3hBg7--
