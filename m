From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: KVM/ARM: sleeping function called from invalid context
Date: Thu, 30 Mar 2017 17:40:34 +0100
Message-ID: <7047d954-5c43-600a-3511-4c7dbd60c175@arm.com>
References: <20170330143112.GI16211@leverpostej>
 <20170330152955.GJ16211@leverpostej>
 <e25e57ee-5ba5-4343-ed4e-aad6f4e665b4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <e25e57ee-5ba5-4343-ed4e-aad6f4e665b4@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: tglx@linutronix.de, peterz@infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/03/17 16:41, Marc Zyngier wrote:
> On 30/03/17 16:29, Mark Rutland wrote:
>> On Thu, Mar 30, 2017 at 03:31:12PM +0100, Mark Rutland wrote:
>>> Hi,
>>>
>>> I'm seeing the splat below when running KVM on an arm64 host with
>>> CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_LOCKDEP enabled.
>>>
>>> I saw this on v4.11-rc1, and I can reproduce the problem on the current
>>> kvmarm master branch (563e2f5daa66fbc1).
>>>
>>> I've hacked noinlines into arch/arm/kvm/mmu.c in an attempt to get a
>>> better backtrace; without this, the report says the call is at
>>> arch/arm/kvm/mmu.c:299, which is somewhat confusing.
>>
>> Looking again, that initial kernel was not a vanilla v4.11-rc1, and I am
>> *not* able to reproduce this issue with a vanilla v4.11-rc1.
>>
>> I believe I had applied an earlier fix for the locking issue Suzuki
>> recently addressed, which was why my line numbers were off.
>>
>> I *can* trigger this issue with the current kvmarm master, and the log I
>> posted is valid.
>>
>> Sorry for the bogus info; I will be more careful next time.
>
> No worries, thanks Mark.
>
> So here's my (very) superficial analysis of the issue:
> - Memory pressure, we try to swap out something
> - try_to_unmap_one takes a spinlock (via page_vma_mapped_walk)
> - MMU notifier kick in with the spinlock held
> - we take kvm->mmu_lock
> - in unmap_stage2_range, we do a cond_resched_lock(kvm->mmu_lock)
> - we still hold the page_vma_mapped_walk spinlock, might_sleep screams

Correct.

>
> I can see multiple ways of doing this:
> 1) We track that we're coming via an MMU notifier, and don't call
> cond_resched_lock() in that case
> 2) We get rid of cond_resched_lock()
> 3) we have a different code path for the MMU notifier that doesn't
> involve cond_resched_lock().
>
> Only (1) vaguely appeals to me, and I positively hate (3). We could
> revert to (2), but it is likely to be helpful when tearing down large
> ranges.
>
> Another possibility is that the might_sleep() warning is just spurious,
> and I think that Suzuki has a theory...

So the cond_resched_lock() thinks that it could drop the lock and do a sched.
So it issues __might_sleep(PREEMPT_LOCK_OFFSET) to make sure the preempt_count
is as if there is only one {i.e, this} spin_lock preventing the preemption, and
it could drop the lock after verifying should_resched(PREEMPT_LOCK_OFFSET) (and bit more
other checks) turns true. But since we are holding two spin_locks in this rare path,
the preempt_offset is PREEMPT_LOCK_OFFSET + 1 (as we do preempt_count_inc for each
lock).

Now, ___might_sleep() checks if the preempt_count exactly matches the passed count, using
preempt_count_equals(), and goes ahead to complain if it doesn't, even if the preempt_count
is greater than the passed count, in which case the should_resched() should deny the schedule
operation and we skip it. So, I think, ___might_sleep should really check
if (preempt_count >= preempt_offset) to scream about it, of course making sure that the callers
honoring the same case.

To summarise, since we do have two locks held, we won't be able to reschedule in this case
but the might_sleep screams even if we are safe.

Suzuki
