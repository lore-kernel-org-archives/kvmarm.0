From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 19 May 2016 11:44:23 +0100
Message-ID: <CAFEAcA_RATH6-6PuqevNWw=X=C+_hphhspu6_u=hcpeeRfLtpg@mail.gmail.com>
References: <1463150637-6896-1-git-send-email-christoffer.dall@linaro.org>
 <CAFEAcA8fcxo18HhfboE5j=SC8TyrPXqmpsPNymM8zw4PhMTRDw@mail.gmail.com> <20160518170349.GL6666@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160518170349.GL6666@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 18 May 2016 at 18:03, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Fri, May 13, 2016 at 04:28:44PM +0100, Peter Maydell wrote:
>> I would like this to simply get/set the latch state regardless of whether
>> the interrupt is edge triggered or level triggered. (Obviously if the
>> interrupt is edge triggered this is equivalent to accessing the
>> ISPENDR/ICPENDR registers, but I don't want in userspace to have to
>> manually look at whether each interrupt is edge or level in order to
>> identify whether to use ISPENDR or this API, when in fact the state
>> in the kernel is exactly the same. I just want a straightforward
>> get/set accessor to the underlying state.)

> I think my reservations against this come from the fact that we're
> getting farther and farther away from anything that looks like
> software's interface to the GIC hardware as specified by the
> architecture, and it was kind of the motivation for our choice of API
> here in the first place to try to stay close to that.
>
> That being said, what we're designing an API for here is a different
> case that for what the software view of the hardware via registers has
> been designed for, so potentially it's ok to deviate from that.

Yes; our two deviations are just the two awkward points where the
register view of the hardware doesn't provide complete access to
the internal state.

> How about we special-case the SPENDR region, and make CPENDR region
> RAZ/WI, and the SPENDR region then reflects the latch state exclusively.
> Or is this more confusing than just having a separate 'fake' region?

I don't have a preference either way here.

> Do you have a suggestion in mind for wording/naming of the 'latch state'
> that makes sense for software people who have access to the GIC manual,
> but doesn't necessarily understand how the hardware would be built and
> why 'latch state' logically has clear semantics... ?

This is a bit tricky because the spec leaves you to deduce how things
work and doesn't provide much terminology to work with either. Here's
an attempt at an explanation, which is a bit long-winded but I can't
see any way to be more concise:

This returns the value of the latched pending state for the interrupts.
This is identical to the value read from ISPENDR for an edge triggered
interrupt, but may differ for level triggered interrupts. For edge
triggered interrupts, once an interrupt becomes pending (whether because
of an edge detected on the input line or because of a guest write to
ISPENDR) this state is "latched", and only cleared when either the
interrupt is activated or when the guest writes to ICPENDR. A
level triggered interrupt may be pending either because the level input
is held high by a device, or because of a guest write to the ISPENDR
register. Only ISPENDR writes are latched: if the device lowers the line
level then the interrupt is no longer pending unless the guest also
wrote to ISPENDR, and conversely writes to ICPENDR or activations of the
interrupt do not clear the pending status if the line level is still
being held high. (These rules are documented in the GICv3 specification
descriptions of the ICPENDR and ISPENDR registers.)
For a level triggered interrupt the value returned here is that of the
latch which is set by ISPENDR and cleared by ICPENDR or interrupt
activation, whereas the value read from ISPENDR is the logical OR of
the latch value and the input line level. Raw access to the latch state
is provided to userspace so that it can save and restore the entire GIC
internal state (which is defined by the combination of the current input
line level and the latch state, and cannot be deduced from purely the
line level and the value of the ISPENDR registers).

thanks
-- PMM
