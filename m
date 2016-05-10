From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 19/55] KVM: arm/arm64: vgic-new: Add GICv3 world switch
 backend
Date: Tue, 10 May 2016 15:22:20 +0100
Message-ID: <5731EE9C.5000201@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-20-git-send-email-andre.przywara@arm.com>
 <20160510140454.GG27623@cbox>
 <CAFEAcA9U9qqsSJt7RfNJmDutCsYwnaPGfi-sEcnxYYjSm5C8sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA9U9qqsSJt7RfNJmDutCsYwnaPGfi-sEcnxYYjSm5C8sA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andre Przywara <andre.przywara@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/05/16 15:15, Peter Maydell wrote:
> On 10 May 2016 at 15:04, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> On Fri, May 06, 2016 at 11:45:32AM +0100, Andre Przywara wrote:
>>> +     /*
>>> +      * Currently all guest IRQs are Group1, as Group0 would result
>>> +      * in a FIQ in the guest, which it wouldn't expect.
>>
>> I still don't like or understand this comment.  This should simply say
>> that we're making a gross assumption about all interrupts being group1
>> here.
> 
> It's not really an assumption so much as it's a missing feature (aka bug):
> there's no reason the vGIC shouldn't support group 0 interrupts. We
> just get away with only supporting group 1 because Linux guests
> happen to only use group 1 interrupts. If/when the vGIC gains support
> for group0 interrupts, then it should reset with interrupts configured
> in group0 by default.
> 
>>> +      * Eventually we want to make this configurable, so we may
>>> +      * revisit this in the future.
>>> +      */
> 
> The only reason to make it configurable is to work around a guest
> kernel bug whereby Linux assumes that all interrupts start out
> in Group1. Marc sent out a patch earlier today that fixes that bug:
>  https://lkml.org/lkml/2016/5/10/297
> Depending on how long it takes you to fix this missing vgic feature,
> such kernels may all be long-forgotten, in which case you can
> get away without the config option :-)

I've CC'd stable for this particular patch, so hopefully we won't have
to make it configurable as people will diligently update their
kernels... I also have a patch for handling both groups in KVM, but I'll
hold onto it until we have something we agree on for the bulk of the code.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
