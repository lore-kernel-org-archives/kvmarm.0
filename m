From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 06/10] KVM: arm/arm64: Update the physical timer
 interrupt level
Date: Mon, 30 Jan 2017 18:48:02 +0000
Message-ID: <13152c8e-2256-4224-e15c-73c8d6ce06e4@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
 <86sho199jx.fsf@arm.com> <20170130150203.GD16459@cbox>
 <b3a4a3e4-65d4-1af3-2b77-14b7fffd9d06@arm.com> <20170130184131.GE16459@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61EA040905
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 13:47:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5-EBl86UZgPO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 13:47:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1311040783
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 13:47:47 -0500 (EST)
In-Reply-To: <20170130184131.GE16459@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/17 18:41, Christoffer Dall wrote:
> On Mon, Jan 30, 2017 at 05:50:03PM +0000, Marc Zyngier wrote:
>> On 30/01/17 15:02, Christoffer Dall wrote:
>>> On Sun, Jan 29, 2017 at 03:21:06PM +0000, Marc Zyngier wrote:
>>>> On Fri, Jan 27 2017 at 01:04:56 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>>>>> Now that we maintain the EL1 physical timer register states of VMs,
>>>>> update the physical timer interrupt level along with the virtual one.
>>>>>
>>>>> Note that the emulated EL1 physical timer is not mapped to any hardware
>>>>> timer, so we call a proper vgic function.
>>>>>
>>>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>>>> ---
>>>>>  virt/kvm/arm/arch_timer.c | 20 ++++++++++++++++++++
>>>>>  1 file changed, 20 insertions(+)
>>>>>
>>>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>>>> index 0f6e935..3b6bd50 100644
>>>>> --- a/virt/kvm/arm/arch_timer.c
>>>>> +++ b/virt/kvm/arm/arch_timer.c
>>>>> @@ -180,6 +180,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
>>>>>  	WARN_ON(ret);
>>>>>  }
>>>>>  
>>>>> +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>>>>> +				 struct arch_timer_context *timer)
>>>>> +{
>>>>> +	int ret;
>>>>> +
>>>>> +	BUG_ON(!vgic_initialized(vcpu->kvm));
>>>>
>>>> Although I've added my fair share of BUG_ON() in the code base, I've
>>>> since reconsidered my position. If we get in a situation where the vgic
>>>> is not initialized, maybe it would be better to just WARN_ON and return
>>>> early rather than killing the whole box. Thoughts?
>>>>
>>>
>>> The distinction to me is whether this will cause fatal crashes or
>>> exploits down the road if we're working on uninitialized data.  If all
>>> that can happen if the vgic is not initialized, is that the guest
>>> doesn't see interrupts, for example, then a WARN_ON is appropriate.
>>>
>>> Which is the case here?
>>>
>>> That being said, do we need this at all?  This is in the critial path
>>> and is actually measurable (I know this from my work on the other timer
>>> series), so it's better to get rid of it if we can.  Can we simply
>>> convince ourselves this will never happen, and is the code ever likely
>>> to change so that it gets called with the vgic disabled later?
>>
>> That'd be the best course of action. I remember us reworking some of
>> that in the now defunct vgic-less series. Maybe we could salvage that
>> code, if only for the time we spent on it...
>>
> Ah, we never merged it?  Were we waiting on a userspace implementation
> or agreement on the ABI?

We were waiting on the userspace side to be respun against the latest
API, and there were some comments from Peter (IIRC) about supporting
PPIs in general (the other timers and the PMU, for example).

None of that happened, as the most vocal proponent of the series
apparently lost interest.

> There was definitely a useful cleanup with the whole enabled flag thing
> on the timer I remember.

Indeed. We should at least try to resurrect that bit.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
