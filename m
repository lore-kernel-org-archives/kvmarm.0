From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 3/6] hw/char: pl011 don't keep setting the IRQ if nothing changed
Date: Fri, 13 Mar 2015 10:38:58 +0000
Message-ID: <87ioe5b2rh.fsf@linaro.org>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org> <1425479753-18349-4-git-send-email-alex.bennee@linaro.org> <CAFEAcA-RhZVe1qwKQ3LzfWbzYVcBQ-jrwTnhH0OX69GNtnoysw@mail.gmail.com> <CAFEAcA-UOfgxBA969U6ADdra75fxYQPi6JFe017J6-oMG1rGhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <CAFEAcA-UOfgxBA969U6ADdra75fxYQPi6JFe017J6-oMG1rGhg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu


Peter Maydell <peter.maydell@linaro.org> writes:

> On 12 March 2015 at 15:51, Peter Maydell <peter.maydell@linaro.org> w=
rote:
>> On 4 March 2015 at 14:35, Alex Benn=C3=A9e <alex.bennee@linaro.org> =
wrote:
>>> While observing KVM traces I can see additional IRQ calls on pretty=
 much
>>> every MMIO access which is just plain inefficient. Only update the =
QEMU
>>> IRQ level if something has actually changed from last time. Otherwi=
se we
>>> may be papering over other failure modes.
>
>> Consider this sequence of events:
>
> Incidentally, the code review rule of thumb that led me to
> construct that scenario is:
>  * state inside the device struct which doesn't correspond
>    to real hardware state is suspicious
>  * state which doesn't have any handling on migration
>    save/restore is doubly suspicious
> ...and then it was just a matter of "find the situation
> where this is broken" :-)
>
> If we want to avoid making syscalls back into KVM it might
> be better to attack the problem in the GIC object rather
> than in all the devices that might be connected to it.
> In general QEMU devices tend to assume they can just
> always call qemu_set_irq() and it's the other end's
> job to avoid doing anything too expensive in that situation.

=46air enough - I'll drop this patch on the re-spin

>
> -- PMM

--=20
Alex Benn=C3=A9e
