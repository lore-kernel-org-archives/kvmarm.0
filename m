From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH v2 06/19] KVM: arm/arm64: Make timer_arm and
 timer_disarm helpers more generic
Date: Tue, 1 Aug 2017 16:41:11 +0100
Message-ID: <7f4730e5-bd75-513b-c79c-bb074fabcbfe@arm.com>
References: <20170717142718.13853-1-cdall@linaro.org>
 <20170717142718.13853-7-cdall@linaro.org>
 <f7871c0f-50db-45cc-c161-32c4b54497ac@arm.com> <20170801145746.GJ5176@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170801145746.GJ5176@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/08/17 15:57, Christoffer Dall wrote:
> On Tue, Aug 01, 2017 at 03:10:59PM +0100, Marc Zyngier wrote:
>> On 17/07/17 15:27, Christoffer Dall wrote:
>>> We are about to add an additional soft timer to the arch timer state for
>>> a VCPU and would like to be able to reuse the functions to program and
>>> cancel a timer, so we make them slightly more generic and rename to make
>>> it more clear that these functions work on soft timers and not the
>>> hardware resource that this code is managing.
>>>
>>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
>>> ---
>>>  virt/kvm/arm/arch_timer.c | 33 ++++++++++++++++-----------------
>>>  1 file changed, 16 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>> index 8e89d63..871d8ae 100644
>>> --- a/virt/kvm/arm/arch_timer.c
>>> +++ b/virt/kvm/arm/arch_timer.c
>>> @@ -56,26 +56,22 @@ u64 kvm_phys_timer_read(void)
>>>  	return timecounter->cc->read(timecounter->cc);
>>>  }
>>>  
>>> -static bool timer_is_armed(struct arch_timer_cpu *timer)
>>> +static bool soft_timer_is_armed(struct arch_timer_cpu *timer)
>>>  {
>>>  	return timer->armed;
>>>  }
>>>  
>>> -/* timer_arm: as in "arm the timer", not as in ARM the company */
>>> -static void timer_arm(struct arch_timer_cpu *timer, u64 ns)
>>> +static void soft_timer_start(struct hrtimer *hrt, u64 ns)
>>
>> I find it a bit confusing that the soft_timer_* functions operate on
>> different object types: arch_timer_cpu for soft_timer_is_armed(), and
>> hrtimer for soft_timer_start. Is there anything that prevents us from
>> keeping arch_timer_cpu for all of them?
>>
> 
> The problem is now we have two timers for a VCPU, one which is shared
> between the two timer contexts (physical and virtual) used when the
> process goes to sleep with a programmed timer, and one used to exit the
> guest for the physical timer emulation.  So I either need to provide
> some sideband information or use the hrtimer pointer.

Yes, I came to the same conclusion at while reading patch 8.

> I tried to address this in later patches by renaming timer_is_armed() to
> bg_timer_is_armed(), but I'm open to better suggestions.

Bah, never mind.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
