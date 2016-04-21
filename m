From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v5 1/2] arm/arm64: KVM: Detect vGIC presence at runtime
Date: Fri, 22 Apr 2016 00:35:54 +0200
Message-ID: <571955CA.6030503@suse.de>
References: <cover.1448874023.git.p.fedin@samsung.com>
 <f759b4ba37d4cacdc971d2a416cdc8ecf0c3c3d9.1448874023.git.p.fedin@samsung.com>
 <57194919.5080007@suse.de>
 <CAFEAcA-SK3ZEcF13Zd74DCWRBBkiuz87U2roLaeujZBDu6DVTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA-SK3ZEcF13Zd74DCWRBBkiuz87U2roLaeujZBDu6DVTQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 22.04.16 00:04, Peter Maydell wrote:
> On 21 April 2016 at 22:41, Alexander Graf <agraf@suse.de> wrote:
>> So effectively all we'd need is to set CNTHCTL_EL2.EL1PCEN to 0 for
>> guests that have no in-kernel irqchip, no? We should then trap on all
>> timer accesses and be able to emulate them in user space where we can
>> inject IRQs into an emulated GIC again.
> 
> You'd still need to define a new userspace ABI for "we stopped
> for a system register trap" and the userspace code to emulate
> the timers as part of KVM rather than as part of TCG, which seems
> like a lot of effort for a mode that you really don't want to be
> using...

It might make sense to have a generic "system register couldn't get
handled" exit code anyway. If nothing else, at least to display
unhandled registers in the qemu context where they appear rather than in
the kernel log (which a guest could deliberately clutter as it stands
today).

With such an interface in place, the rest would only be a few lines of glue.

> For GICv3 it gets trickier again because the interface between
> the interrupt controller and the CPU is no longer as simple
> as "an FIQ line and an IRQ line". (In particular the interrupt
> controller needs to know the CPU's current exception level and
> security state to know if it should raise IRQ or FIQ, which means
> that it needs to be told every time the CPU changes EL. I haven't
> yet figured out if I should model this in the QEMU emulated GICv3
> by having a backdoor callback function for this or by biting
> the bullet and putting the GICv3 cpu interface really in the
> CPU with a properly modelled equivalent of the stream protocol...)

We moved the lapic into target-i386 as well, no? Given that it really is
very close to the cpu these days it might not be a bad idea.


Alex
