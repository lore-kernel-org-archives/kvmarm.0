From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 14:59:20 +0000
Message-ID: <87oaovdxvb.fsf@why.wild-wind.fr.eu.org>
References: <54D714B9.6090106@web.de> <20150213044613.GA47577@lvm>
	<87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org>
	<54E05E8A.5020109@web.de> <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>
	<54E0AFE8.20202@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <54E0AFE8.20202@web.de> (Jan Kiszka's message of "Sun, 15 Feb
	2015 14:40:40 +0000")
Sender: kvm-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Feb 15 2015 at  2:40:40 pm GMT, Jan Kiszka <jan.kiszka@web.de> =
wrote:
> On 2015-02-15 14:37, Marc Zyngier wrote:
>> On Sun, Feb 15 2015 at  8:53:30 am GMT, Jan Kiszka <jan.kiszka@web.d=
e> wrote:
>>> I'm now throwing trace_printk at my broken KVM. Already found out t=
hat I
>>> get ARM_EXCEPTION_IRQ every few 10 =C2=B5s. Not seeing any irq_* tr=
aces,
>>> though. Weird.
>>=20
>> This very much looks like a screaming interrupt. At such a rate, no
>> wonder your VM make much progress. Can you find out which interrupt =
is
>> screaming like this? Looking at GICC_HPPIR should help, but you'll h=
ave
>> to map the CPU interface in HYP before being able to access it there=
=2E
>
> OK... let me figure this out. I had this suspect as well - the host g=
ets
> a VM exit for each injected guest IRQ?

Not exactly. There is a VM exit for each physical interrupt that fires
while the guest is running. Injecting an interrupt also causes a VM
exit, as we force the vcpu to reload its context.

> BTW, I also tried with in-kernel GIC disabled (in the kernel config),
> but I guess that's pointless. Linux seems to be stuck on a
> non-functional architectural timer then, right?

Yes. Useful for bringup, but nothing more.

>>=20
>> Do you have an form of power-management on this system?
>
> Just killed every config that has PM for FREQ in its name, but that
> makes no difference.

I still wonder if the 4+1 design on the K1 is not playing tricks behind
our back. Having talked to Ian Campbell earlier this week, he also can'=
t
manage to run guests in Xen on this platform, so there's something
rather fishy here.

	M.
--=20
Without deviation from the norm, progress is not possible.
