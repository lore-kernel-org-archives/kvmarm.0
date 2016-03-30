From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 1/9] clocksource: arm_arch_timer: Gather KVM specific
 information in a structure
Date: Wed, 30 Mar 2016 10:12:33 +0100
Message-ID: <56FB9881.9070209@arm.com>
References: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
 <1458842023-31853-2-git-send-email-julien.grall@arm.com>
 <56FAB7D2.1000508@linaro.org> <56FABC1F.2040500@arm.com>
 <20160330090621.GG4126@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160330090621.GG4126@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, gg@slimlogic.co.uk, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/03/16 10:06, Christoffer Dall wrote:
> On Tue, Mar 29, 2016 at 06:32:15PM +0100, Marc Zyngier wrote:
>> Daniel,
>>
>> On 29/03/16 18:13, Daniel Lezcano wrote:
>>> On 03/24/2016 06:53 PM, Julien Grall wrote:
>>>> Introduce a structure which are filled up by the arch timer driver and
>>>> used by the virtual timer in KVM.
>>>>
>>>> The first member of this structure will be the timecounter. More members
>>>> will be added later.
>>>>
>>>> A stub for the new helper isn't introduced because KVM requires the arch
>>>> timer for both ARM64 and ARM32.
>>>>
>>>> The function arch_timer_get_timecounter is kept for the time being and
>>>> will be dropped in a subsequent patch.
>>>>
>>>> Signed-off-by: Julien Grall <julien.grall@arm.com>
>>>
>>>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>>
>>>>      Changes in v3:
>>>>          - Rename the patch
>>>>          - Move the KVM changes and removal of arch_timer_get_timecounter
>>>>          in separate patches.
>>>> ---
>>>>   drivers/clocksource/arm_arch_timer.c | 12 +++++++++---
>>>>   include/clocksource/arm_arch_timer.h |  5 +++++
>>>>   2 files changed, 14 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>>>> index 5152b38..62bdfe7 100644
>>>> --- a/drivers/clocksource/arm_arch_timer.c
>>>> +++ b/drivers/clocksource/arm_arch_timer.c
>>>> @@ -468,11 +468,16 @@ static struct cyclecounter cyclecounter = {
>>>>   	.mask	= CLOCKSOURCE_MASK(56),
>>>>   };
>>>>
>>>> -static struct timecounter timecounter;
>>>> +static struct arch_timer_kvm_info arch_timer_kvm_info;
>>>
>>> This structure is statically defined in this subsystem but not used in 
>>> this file and a couple of a accessors is added to let another subsystem 
>>> to access it.
>>>
>>> That sounds there is something wrong here with the design of the current 
>>> code, virt/phys are mixed.
>>>
>>> It isn't possible to split the virt/phys timer code respectively in 
>>> virt/kvm/arm/arch_timer.c and drivers/clocksource/arm_arch_timer.c ?
>>
>> No, that'd be the wrong thing to do. The kernel uses *either* the virt
>> or phys timer depending on how it has been booted, and both counters are
>> in use.
>>
>> What KVM (or any other hypervisor) needs from the timer subsystem is:
>> - an interrupt (so that it can force a guest exit when the timer fires),
>> - a way to convert the values programmed into the HW into a timer event
>> (which is what the time counter structure is for).
>>
>> That allows the hypervisor to *emulate* a timer for the guest, and
>> that's what virt/kvm/arm/arch_timer.c is all about. We have a clear
>> separation of what is driving the HW vs what is emulating it, and I'm
>> quite eager to preserve that.
>>
>>> At least, 'struct arch_timer_kvm_info' should belong to 
>>> virt/kvm/arm/arch_timer.c.
>>
>> At the cost of mandating separate storage in the arm_arch_timer driver.
>> I do not find that much nicer, but if you prefer that, fine by me.
>>
> If arch_timer_kvm_info is declared in virt/kvm/arm/arch_timer.c, then
> do you want to make it globally accessible and populated by this code or
> make it static to the KVM code and populate it with accessor functions?

That'd be the latter, as I'm really not fond of global data.

> To me the natural thing is that the arch timer driver maintains data
> about the device it drives, and consumers of that data can ask the arch
> timer driver for the details.

That was my approach too, and that's the way the code proposed by Julien
works. Daniel seems to have a different take on it though.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
