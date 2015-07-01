From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 05/10] KVM: arm/arm64: vgic: Relax vgic_can_sample_irq
 for edge IRQs
Date: Wed, 01 Jul 2015 10:17:52 +0100
Message-ID: <5593B040.6050208@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <1433783045-8002-6-git-send-email-marc.zyngier@arm.com> <20150630201933.GA11332@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150630201933.GA11332@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/06/15 21:19, Christoffer Dall wrote:
> On Mon, Jun 08, 2015 at 06:04:00PM +0100, Marc Zyngier wrote:
>> We only set the irq_queued flag for level interrupts, meaning
>> that "!vgic_irq_is_queued(vcpu, irq)" is a good enough predicate
>> for all interrupts.
>>
>> This will allow us to inject edge HW interrupts, for which the
>> state ACTIVE+PENDING is not allowed.
> 
> I don't understand this; ACTIVE+PENDING is allowed for edge interrupts.
> Do you mean that if we set the HW bit in the LR, then we are linking to
> an HW interrupt where we don't allow that to be ACTIVE+PENDING on the HW
> GIC side?
> 
> Why is this relevant here?  I feel like I'm missing context.

I've probably taken a shortcut here - bear with me while I'm trying to
explain the issue.

For HW interrupts, we shouldn't even try to use the state bits in the
LR, because that state is contained in the physical distributor. Setting
the HW bit really means "there is something going on at the distributor
level, just go there".

If we were to inject a ACTIVE+PENDING interrupt at the LR level, we'd
basically loose the second interrupt because that state is simply not
considered.

So the trick we're using is to only inject the active interrupt, and
prevent anything else from being injected until we can confirm that the
active state has been cleared at the physical level.

Does it make any sense?

	M.
-- 
Jazz is not dead. It just smells funny...
