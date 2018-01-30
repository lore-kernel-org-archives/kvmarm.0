From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 11/13] KVM: arm64: Handle RAS SErrors from EL1 on guest
 exit
Date: Tue, 30 Jan 2018 19:18:57 +0000
Message-ID: <5A70C521.2020903@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-12-james.morse@arm.com> <20180119192055.GH21802@cbox>
 <5A662B0E.7060305@arm.com> <20180123153245.GN21802@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180123153245.GN21802@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, Xie XiuQi <xiexiuqi@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 23/01/18 15:32, Christoffer Dall wrote:
> On Mon, Jan 22, 2018 at 06:18:54PM +0000, James Morse wrote:
>> On 19/01/18 19:20, Christoffer Dall wrote:
>>> On Mon, Jan 15, 2018 at 07:39:04PM +0000, James Morse wrote:
>>>> If only some of the CPUs support RAS the guest will see the cpufeature
>>>> sanitised version of the id registers, but we may still take RAS SError
>>>> on this CPU. Move the SError handling out of handle_exit() into a new
>>>> handler that runs before we can be preempted. This allows us to use
>>>> this_cpu_has_cap(), via arm64_is_ras_serror().
>>>
>>> Would it be possible to optimize this a bit later on by caching
>>> this_cpu_has_cap() in vcpu_load() so that we can use a single
>>> handle_exit function to process all exits?
>>
>> If vcpu_load() prevents pre-emption between the guest-exit exception and the
>> this_cpu_has_cap() test then we wouldn't need a separate handle_exit().
> 
> It doesn't, but you'd get another vcpu_put() / vcpu_load() if you get
> preempted, and you could record anything you need to know about the CPU
> that actually ran the guest in vcpu_put().

Snazzy!

> So it might be possible to call some "process pending serror" function
> in vcpu_put().

Hmm, maybe. When we exit the guest its because we've had a notification an error
occurred, but we don't know what/where yet. The case that worries me is we
reschedule() onto some other affected task, and it gets notification of the
error too.

For notifications signalled by an SError I'd like to feed them into the RAS
machinery before we unmask SError on the host, so that the first error is
handled first. Otherwise KVM has to eyeball the SError ESR and guess as to
whether the host is affected by the error, before re-enabling preemption on the
grounds it 'probably only affects this guest'.


>> But, if we support kernel-first RAS or firmware-first's NOTIFY_SEI we shouldn't
>> unmask SError until we've fed the guest-exit:SError into the RAS code. This
>> would also need the SError related handle_exit() calls to be separate/earlier.
>> (there was some verbiage on this in the cover letter).
> 
> Yeah, I sort-of understood where this was going...

(sorry, I assume not everyone reads the cover letter!)


>> (I started down the 'make handle_exit() non-preemptible', but WF{E,I}'s
>> kvm_vcpu_block()->schedule() and kvm_vcpu_on_spin()s use of kvm_vcpu_yield_to()
>> put an end to that).
> 
> It's not clear to me exactly how that would work, as handle_exit() can
> also block on stuff like allocating memory.  

Yes, it was a dead end. I figured two handle_exit()s was a bit ugly, I assumed
you were asking about moving back to a single handle_exit()...


> I suppose enabling
> preemption could be per exit reason, but that might be hard to maintain.


>> In terms of caching this_cpu_has_cap() value, is this due to a performance
>> concern? It's all called behind 'exception_index == ARM_EXCEPTION_EL1_SERROR',
>> so we've already taken an SError out of the guest. Once its all put together
>> we're likely to have a pending signal for user-space.
>> 'Corrected' (or at least ignorable) errors are going to be the odd one out, I
>> don't think we should worry about these!
> 
> The performance concern is having to call another function to check the
> return value again in the critical path.

My justification for this sort of thing has been we've taken an SError, we may
panic() the host if its uncontained. Provided there is no extra cost on the 'no
SError' path, I don't think the 'we've taken an SError' paths need to be fast.


> On older implementations this
> kind of thing is actually measureable, and there's a tendency to add a
> call here and a call there for any new aspect of the architecture, and
> it will eventually weigh things down, I believe.

I'll keep this in mind.


> On the other hand,having a "process some things before we enable preemption"
>  which is your handle_exit_early() function (could this also have been called
> handle_exit_nopreempt() ?)

Yes, and that would have been a better name!


Thanks,

James


> is a potentially generally useful thing to
> have and a reasonable thing overall.
