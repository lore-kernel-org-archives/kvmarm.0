From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 19:01:12 +0100
Message-ID: <54E0DEE8.7020109@web.de>
References: <54D714B9.6090106@web.de> <20150213044613.GA47577@lvm>	<87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org>	<54E05E8A.5020109@web.de> <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>	<54E0AFE8.20202@web.de> <87oaovdxvb.fsf@why.wild-wind.fr.eu.org>	<54E0B646.6030601@web.de> <87k2zjdwg4.fsf@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4imV49EIsrR7RhFd2Enh96BQvIV1n1h2o"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87k2zjdwg4.fsf@why.wild-wind.fr.eu.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4imV49EIsrR7RhFd2Enh96BQvIV1n1h2o
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-02-15 16:30, Marc Zyngier wrote:
> On Sun, Feb 15 2015 at  3:07:50 pm GMT, Jan Kiszka <jan.kiszka@web.de> =
wrote:
>> On 2015-02-15 15:59, Marc Zyngier wrote:
>>> On Sun, Feb 15 2015 at  2:40:40 pm GMT, Jan Kiszka <jan.kiszka@web.de=
> wrote:
>>>> On 2015-02-15 14:37, Marc Zyngier wrote:
>>>>> On Sun, Feb 15 2015 at 8:53:30 am GMT, Jan Kiszka
>>>>> <jan.kiszka@web.de> wrote:
>>>>>> I'm now throwing trace_printk at my broken KVM. Already found out =
that I
>>>>>> get ARM_EXCEPTION_IRQ every few 10 =C2=B5s. Not seeing any irq_* t=
races,
>>>>>> though. Weird.
>>>>>
>>>>> This very much looks like a screaming interrupt. At such a rate, no=

>>>>> wonder your VM make much progress. Can you find out which interrupt=
 is
>>>>> screaming like this? Looking at GICC_HPPIR should help, but you'll =
have
>>>>> to map the CPU interface in HYP before being able to access it ther=
e.
>>>>
>>>> OK... let me figure this out. I had this suspect as well - the host =
gets
>>>> a VM exit for each injected guest IRQ?
>>>
>>> Not exactly. There is a VM exit for each physical interrupt that fire=
s
>>> while the guest is running. Injecting an interrupt also causes a VM
>>> exit, as we force the vcpu to reload its context.
>>
>> Ah, GICC !=3D GICV - you are referring to host-side pending IRQs. Any
>> hints on how to get access to that register would accelerate the
>> analysis (ARM KVM code is still new to me).
>=20
> Map the GICC region in HYP using create_hyp_io_mapping (see
> vgic_v2_probe for an example of how we map GICH), and stash the read of=

> GICC_HPPIR before leaving HYP mode (and before saving the guest timer).=


Hacked on it until it started to work. The result delivered initially
are 0x002 or 0x01e. Then, when the guest gets stuck, I have 0x01b most
of the time (a few 0x01e arrive when there is a real host irq). The
virtual timer on speed?

Wait, there is also early printk for ARM, but it was off in my guest!
Turning it on confirms we have some problems here:

  Architected timer frequency not available
  Division by zero in kernel.

When in emulation mode, I get:

  Architected cp15 timer(s) running at 62.50MHz (virt).

Digging deeper.

Jan



--4imV49EIsrR7RhFd2Enh96BQvIV1n1h2o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTg3ugACgkQitSsb3rl5xRW9wCg3WN7h+z6SV68l1cymxVfur5j
cf4An3+0YNExLt9I/aQ3SavbbXJ8iGDT
=Oadn
-----END PGP SIGNATURE-----

--4imV49EIsrR7RhFd2Enh96BQvIV1n1h2o--
