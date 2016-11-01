From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Add ARM arch timer interrupts ABI
Date: Tue, 01 Nov 2016 16:56:47 +0000
Message-ID: <86d1ifkuk0.fsf@arm.com>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
        <20160927190806.22988-3-christoffer.dall@linaro.org>
        <CAFEAcA8x9Rt7SwXfqC8QOuXUEysrGBvYZW_=9ZA+pNgYu7HbTA@mail.gmail.com>
        <20161101145019.GB13677@cbox>
        <CAFEAcA_mdrTUBBDV91X3Zo6pNzVaukQ7foN+cPt_41+ouBdEfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA_mdrTUBBDV91X3Zo6pNzVaukQ7foN+cPt_41+ouBdEfQ@mail.gmail.com>
        (Peter Maydell's message of "Tue, 1 Nov 2016 14:54:11 +0000")
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Alexander Graf <agraf@suse.de>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 01 2016 at 02:54:11 PM, Peter Maydell <peter.maydell@linaro.org> wrote:
> On 1 November 2016 at 14:50, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
>> On Tue, Nov 01, 2016 at 11:26:54AM +0000, Peter Maydell wrote:
>>> Possible current and future outbound interrupt lines (some of these
>>> would only show up in some unlikely or lots-of-implementation-needed
>>> cases, I'm just trying to produce an exhaustive list):
>>>  * virtual timer
>>>  * physical timer
>>>  * hyp timer (nested virtualization case)
>>>  * secure timer (unlikely but maybe if EL3 is ever supported inside a VM)
>>>  * gic maintenance interrupt (nested virt again)
>>>  * PMU interrupt
>>
>> Thanks for the list, that's good to have around for the future.
>>
>> There's also the potential of the EL2 virtual timer for nested VHE
>> support, right?
>
> That's the one I meant by "hyp timer".

VHE also adds an extra virtual timer, for symmetry with what EL1
provides (and on which CNTVOFF doesn't have any effect) - see section
B8.1.1 of the ARMv8.1 addendum. So we effectively have:

- Secure physical EL3
- Non-secure physical EL1
- Non-secure virtual EL1
- Non-secure physical EL2
- Non-secure virtual EL2

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
