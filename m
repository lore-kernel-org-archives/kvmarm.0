From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 00/10] arm/arm64: KVM: Active interrupt state switching
 for shared devices
Date: Wed, 10 Jun 2015 10:03:50 +0100
Message-ID: <5577FD76.7080100@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <5577F63C.5040806@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5577F63C.5040806@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, =?windows-1252?Q?Alex?= =?windows-1252?Q?_Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 10/06/15 09:33, Eric Auger wrote:
> Hi Marc,
> On 06/08/2015 07:03 PM, Marc Zyngier wrote:
>> From day 1, our timer code has been using a terrible hack: whenever
>> the guest is scheduled with a timer interrupt pending (i.e. the HW
>> timer has expired), we restore the timer state with the MASK bit set,
>> in order to avoid the physical interrupt to fire again. And again. And
>> again...
>>
>> This is absolutely silly, for at least two reasons:
>>
>> - This relies on the device (the timer) having a mask bit that we can
>>   play with. Not all devices are built like this.
>>
>> - This expects some behaviour of the guest that only works because the
>>   both the kernel timer code and the KVM counterpart have been written
>>   by the same idiot (the idiot being me).
>>
>> The One True Way is to set the GIC active bit when injecting the
>> interrupt, and to context-switch across the world switch. This is what
>> this series implements.
>>
>> We introduce a relatively simple infrastructure enabling the mapping
>> of a virtual interrupt with its physical counterpart:
>>
>> - Whenever an virtual interrupt is injected, we look it up in an
>>   rbtree. If we have a match, the interrupt is injected with the HW
>>   bit set in the LR, together with the physical interrupt.
>>
>> - Across the world switch, we save/restore the active state for these
>>   interrupts using the irqchip_state API.
>>
>> - On guest EOI, the HW interrupt is automagically deactivated by the
>>   GIC, allowing the interrupt to be resampled.
> 
> I am lost about the status of the irqchip part, allowing EOImode=1 and
> only dropping the prio for physical forwarded IRQs:
> http://lkml.iu.edu/hypermail/linux/kernel/1410.3/00913.html
> Doesn't this series also depend on those patches or did I miss something
> on the ML?

No, these patches are self-contained. As long as we only deal with
shared devices, we don't need EOImode=1, as as we save/restore the
active state, and the only irqchip change required (the state accessors)
went in with the 4.1 merge window.

The EOImode=1 stuff is still on the cards, and this series contains the
basic infrastructure for that (the last patch in the series is there
only for that purpose).

Hope this helps,

	M.
-- 
Jazz is not dead. It just smells funny...
