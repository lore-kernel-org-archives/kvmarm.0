From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 15:30:03 +0000
Message-ID: <87k2zjdwg4.fsf@why.wild-wind.fr.eu.org>
References: <54D714B9.6090106@web.de> <20150213044613.GA47577@lvm>
	<87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org>
	<54E05E8A.5020109@web.de> <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>
	<54E0AFE8.20202@web.de> <87oaovdxvb.fsf@why.wild-wind.fr.eu.org>
	<54E0B646.6030601@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <54E0B646.6030601@web.de> (Jan Kiszka's message of "Sun, 15 Feb
	2015 15:07:50 +0000")
Sender: kvm-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Feb 15 2015 at  3:07:50 pm GMT, Jan Kiszka <jan.kiszka@web.de> =
wrote:
> On 2015-02-15 15:59, Marc Zyngier wrote:
>> On Sun, Feb 15 2015 at  2:40:40 pm GMT, Jan Kiszka <jan.kiszka@web.d=
e> wrote:
>>> On 2015-02-15 14:37, Marc Zyngier wrote:
>>>> On Sun, Feb 15 2015 at 8:53:30 am GMT, Jan Kiszka
>>>> <jan.kiszka@web.de> wrote:
>>>>> I'm now throwing trace_printk at my broken KVM. Already found out=
 that I
>>>>> get ARM_EXCEPTION_IRQ every few 10 =C2=B5s. Not seeing any irq_* =
traces,
>>>>> though. Weird.
>>>>
>>>> This very much looks like a screaming interrupt. At such a rate, n=
o
>>>> wonder your VM make much progress. Can you find out which interrup=
t is
>>>> screaming like this? Looking at GICC_HPPIR should help, but you'll=
 have
>>>> to map the CPU interface in HYP before being able to access it the=
re.
>>>
>>> OK... let me figure this out. I had this suspect as well - the host=
 gets
>>> a VM exit for each injected guest IRQ?
>>=20
>> Not exactly. There is a VM exit for each physical interrupt that fir=
es
>> while the guest is running. Injecting an interrupt also causes a VM
>> exit, as we force the vcpu to reload its context.
>
> Ah, GICC !=3D GICV - you are referring to host-side pending IRQs. Any
> hints on how to get access to that register would accelerate the
> analysis (ARM KVM code is still new to me).

Map the GICC region in HYP using create_hyp_io_mapping (see
vgic_v2_probe for an example of how we map GICH), and stash the read of
GICC_HPPIR before leaving HYP mode (and before saving the guest timer).

BTW, when you look at /proc/interrupts on the host, don't you see an
interrupt that's a bit too eager to fire?

>>> BTW, I also tried with in-kernel GIC disabled (in the kernel config=
),
>>> but I guess that's pointless. Linux seems to be stuck on a
>>> non-functional architectural timer then, right?
>>=20
>> Yes. Useful for bringup, but nothing more.
>
> Maybe we should perform a feature check and issue a warning from QEMU=
?

I'd assume this is already in place (but I almost never run QEMU, so I
could be wrong here).

>> I still wonder if the 4+1 design on the K1 is not playing tricks beh=
ind
>> our back. Having talked to Ian Campbell earlier this week, he also c=
an't
>> manage to run guests in Xen on this platform, so there's something
>> rather fishy here.
>
> Interesting. The announcements of his PSCI patches [1] sounded more
> promising. Maybe it was only referring to getting the hypervisor itse=
lf
> running...

This is my understanding so far.

> To my current (still limited understanding) of that platform would sa=
y
> that this little core is parked after power-up of the main APs. And a=
s
> we do not power them down, there is no reason to perform a cluster
> switch or anything similarly nasty, no?

I can't see why this would happen, but I've learned not to assume
anything when it come to braindead creativity on the HW side...

	M.
--=20
Without deviation from the norm, progress is not possible.
