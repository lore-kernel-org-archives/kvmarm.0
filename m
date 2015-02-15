From: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 17:10:57 +0100
Message-ID: <54E0C511.5010008@web.de>
References: <20150213044613.GA47577@lvm> <87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org> <54E05E8A.5020109@web.de> <87wq3je1o4.fsf@why.wild-wind.fr.eu.org> <54E0AFE8.20202@web.de> <87oaovdxvb.fsf@why.wild-wind.fr.eu.org> <54E0B646.6030601@web.de> <87k2zjdwg4.fsf@why.wild-wind.fr.eu.org> <54E0BCB2.9000103@web.de> <20150215155954.GC8034@cbox>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nT4BfEQuteDMAOMpQucj0MDeMxl6QoEfW"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150215155954.GC8034@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nT4BfEQuteDMAOMpQucj0MDeMxl6QoEfW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2015-02-15 16:59, Christoffer Dall wrote:
> On Sun, Feb 15, 2015 at 04:35:14PM +0100, Jan Kiszka wrote:
>> On 2015-02-15 16:30, Marc Zyngier wrote:
>>> On Sun, Feb 15 2015 at  3:07:50 pm GMT, Jan Kiszka <jan.kiszka@web.de=
> wrote:
>>>> On 2015-02-15 15:59, Marc Zyngier wrote:
>>>>> On Sun, Feb 15 2015 at  2:40:40 pm GMT, Jan Kiszka <jan.kiszka@web.=
de> wrote:
>>>>>> On 2015-02-15 14:37, Marc Zyngier wrote:
>>>>>>> On Sun, Feb 15 2015 at 8:53:30 am GMT, Jan Kiszka
>>>>>>> <jan.kiszka@web.de> wrote:
>>>>>>>> I'm now throwing trace_printk at my broken KVM. Already found ou=
t that I
>>>>>>>> get ARM_EXCEPTION_IRQ every few 10 =B5s. Not seeing any irq_* tr=
aces,
>>>>>>>> though. Weird.
>>>>>>>
>>>>>>> This very much looks like a screaming interrupt. At such a rate, =
no
>>>>>>> wonder your VM make much progress. Can you find out which interru=
pt is
>>>>>>> screaming like this? Looking at GICC_HPPIR should help, but you'l=
l have
>>>>>>> to map the CPU interface in HYP before being able to access it th=
ere.
>>>>>>
>>>>>> OK... let me figure this out. I had this suspect as well - the hos=
t gets
>>>>>> a VM exit for each injected guest IRQ?
>>>>>
>>>>> Not exactly. There is a VM exit for each physical interrupt that fi=
res
>>>>> while the guest is running. Injecting an interrupt also causes a VM=

>>>>> exit, as we force the vcpu to reload its context.
>>>>
>>>> Ah, GICC !=3D GICV - you are referring to host-side pending IRQs. An=
y
>>>> hints on how to get access to that register would accelerate the
>>>> analysis (ARM KVM code is still new to me).
>>>
>>> Map the GICC region in HYP using create_hyp_io_mapping (see
>>> vgic_v2_probe for an example of how we map GICH), and stash the read =
of
>>> GICC_HPPIR before leaving HYP mode (and before saving the guest timer=
).
>>
>> OK.
>>
>>>
>>> BTW, when you look at /proc/interrupts on the host, don't you see an
>>> interrupt that's a bit too eager to fire?
>>
>> No - but that makes sense given that we do not enter any interrupt
>> handler according to ftrace, thus there can't be any counter increment=
ation.
>>
>>>
>>>>>> BTW, I also tried with in-kernel GIC disabled (in the kernel confi=
g),
>>>>>> but I guess that's pointless. Linux seems to be stuck on a
>>>>>> non-functional architectural timer then, right?
>>>>>
>>>>> Yes. Useful for bringup, but nothing more.
>>>>
>>>> Maybe we should perform a feature check and issue a warning from QEM=
U?
>>>
>>> I'd assume this is already in place (but I almost never run QEMU, so =
I
>>> could be wrong here).
>>
>> Nope, QEMU starts up fine, just lets the guest starve while waiting fo=
r
>> jiffies to increase.
>>
>=20
> you should be able to turn the in-kernel irqchip off with a QEMU
> command-line option and the that should prevent the kernel from adding
> an arch-timer.  This would only work on the vexpress guest model though=
,
> since the virt-board doesn't provide an emulated timer as a replacement=
=2E

I'm running vexpress, but I only tried legacy -no-kvm-irqchip so far
which was refused. -machine vexpress-a15,kernel_irqchip=3Doff has an
effect: host practically locks up, dmesg - when I'm still able to start
on a different console - gives endless "Unexpected interrupt 19 on vcpu
ecd39670". Well, a different smell, but still very fishy.

Jan



--nT4BfEQuteDMAOMpQucj0MDeMxl6QoEfW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTgxREACgkQitSsb3rl5xT/pwCg1M2spk1h8q8WJ9zkgwakmPj6
D1gAnjulhrxsz2WNh2e5T7N+SV7kvQUj
=7eew
-----END PGP SIGNATURE-----

--nT4BfEQuteDMAOMpQucj0MDeMxl6QoEfW--
