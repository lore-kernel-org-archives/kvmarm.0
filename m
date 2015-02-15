From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 16:35:14 +0100
Message-ID: <54E0BCB2.9000103@web.de>
References: <54D714B9.6090106@web.de> <20150213044613.GA47577@lvm>	<87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org>	<54E05E8A.5020109@web.de> <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>	<54E0AFE8.20202@web.de> <87oaovdxvb.fsf@why.wild-wind.fr.eu.org>	<54E0B646.6030601@web.de> <87k2zjdwg4.fsf@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eQ7wA6StLbf0N6wWXOx6BDeXC4hOV1Gnt"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87k2zjdwg4.fsf@why.wild-wind.fr.eu.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eQ7wA6StLbf0N6wWXOx6BDeXC4hOV1Gnt
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


OK.

>=20
> BTW, when you look at /proc/interrupts on the host, don't you see an
> interrupt that's a bit too eager to fire?

No - but that makes sense given that we do not enter any interrupt
handler according to ftrace, thus there can't be any counter incrementati=
on.

>=20
>>>> BTW, I also tried with in-kernel GIC disabled (in the kernel config)=
,
>>>> but I guess that's pointless. Linux seems to be stuck on a
>>>> non-functional architectural timer then, right?
>>>
>>> Yes. Useful for bringup, but nothing more.
>>
>> Maybe we should perform a feature check and issue a warning from QEMU?=

>=20
> I'd assume this is already in place (but I almost never run QEMU, so I
> could be wrong here).

Nope, QEMU starts up fine, just lets the guest starve while waiting for
jiffies to increase.

>=20
>>> I still wonder if the 4+1 design on the K1 is not playing tricks behi=
nd
>>> our back. Having talked to Ian Campbell earlier this week, he also ca=
n't
>>> manage to run guests in Xen on this platform, so there's something
>>> rather fishy here.
>>
>> Interesting. The announcements of his PSCI patches [1] sounded more
>> promising. Maybe it was only referring to getting the hypervisor itsel=
f
>> running...
>=20
> This is my understanding so far.
>=20
>> To my current (still limited understanding) of that platform would say=

>> that this little core is parked after power-up of the main APs. And as=

>> we do not power them down, there is no reason to perform a cluster
>> switch or anything similarly nasty, no?
>=20
> I can't see why this would happen, but I've learned not to assume
> anything when it come to braindead creativity on the HW side...

True.

Jan



--eQ7wA6StLbf0N6wWXOx6BDeXC4hOV1Gnt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTgvLIACgkQitSsb3rl5xQJAQCfcYXX5NUeIQbhwS8ojy5N/lWy
PFgAnRBLP7wePezKgg2YCuh3cuaw/5y0
=7xyD
-----END PGP SIGNATURE-----

--eQ7wA6StLbf0N6wWXOx6BDeXC4hOV1Gnt--
