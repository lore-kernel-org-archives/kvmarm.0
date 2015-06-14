From: zichao <zhichao.huang@linaro.org>
Subject: Re: [PATCH v2 01/11] KVM: arm: plug guest debug exploit
Date: Mon, 15 Jun 2015 00:08:04 +0800
Message-ID: <557DA6E4.7090609@linaro.org>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org> <1433046432-1824-2-git-send-email-zhichao.huang@linaro.org> <556C3A68.8050903@arm.com> <557449EA.7040003@linaro.org> <5576BFF7.3070706@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5576BFF7.3070706@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "alex.bennee@linaro.org" <alex.bennee@linaro.org>, Will Deacon <Will.Deacon@arm.com>
Cc: "huangzhichao@huawei.com" <huangzhichao@huawei.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi, Marc,

On 2015/6/9 18:29, Marc Zyngier wrote:
> On 07/06/15 14:40, zichao wrote:
>> Hi, Marc,
>>
>> On 2015/6/1 18:56, Marc Zyngier wrote:
>>> Hi Zhichao,
>>>
>>> On 31/05/15 05:27, Zhichao Huang wrote:
>>>> Hardware debugging in guests is not intercepted currently, it means
>>>> that a malicious guest can bring down the entire machine by writing
>>>> to the debug registers.
>>>>
>>>> This patch enable trapping of all debug registers, preventing the guests
>>>> to mess with the host state.
>>>>
>>>> However, it is a precursor for later patches which will need to do
>>>> more to world switch debug states while necessary.
>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
>>>> ---
>>>>  arch/arm/include/asm/kvm_coproc.h |  3 +-
>>>>  arch/arm/kvm/coproc.c             | 60 +++++++++++++++++++++++++++++++++++----
>>>>  arch/arm/kvm/handle_exit.c        |  4 +--
>>>>  arch/arm/kvm/interrupts_head.S    |  2 +-
>>>>  4 files changed, 59 insertions(+), 10 deletions(-)
>>>>
......
>>>
>>> There is a small problem here. Imagine the host has programmed a
>>> watchpoint on some VA. We switch to the guest, and then access the same
>>> VA. At that stage, the guest will take the debug exception. That's
>>> really not pretty.
>>>
>>
>> I've thought about it and I think there maybe OK, because when we switch from the
>> host to the guest, the context_switch() in host must be called first, and then
>> the host will switch debug registers, and the guest will not see the watchpoint
>> the host programmed before.
>>
>> Or am I missing some circumstances here?
> 
> I don't see anything in this patch that reprograms the debug registers.
> You are simply trapping the guest access to these registers, but
> whatever content the host has put there is still active.
> 
> So, assuming that the guest does not touch any debug register (and
> legitimately assumes that they are inactive), a debug exception may fire
> at PL1.
> 

I have had a test on the problem you mentioned. I programmed a watchpoint in the host,
and then observe the value of debug registers in the guest.

The result is that in most cases, the guest would not be able to see the watchpoint because
when we switch from the host to the guest, the process schedule function(__schedule) would
be called, and it will uninstall debug registers the host just programed.

__schedule  ->  __perf_event_task_sched_out -> event_sched_out -> arch_uninstall_hw_breakpoint

However, there is one exception, if we programed a watchpoint based on the Qemu process in
the host, there would be no process schedule between the Qemu process and the guest, and then,
the problem you mentioned appear, the guest will see the value of debug registers.

>>> I think using HDCR_TDE as well should sort it, effectively preventing
>>> the exception from being delivered to the guest, but you will need to
>>> handle this on the HYP side. Performance wise, this is also really horrible.
>>>
>>> A better way would be to disable the host's BPs/WPs if any is enabled.
> 
> I still think you either need to fixup the host's registers if they are
> active when you enter the guest.

Compared to disable the whole debug feature in the host, I think there may be a slighter way to
plug the exploit.

We can only save/restore DBGDSCR on each switch between the guest and the host. It means that
the debug monitor in guest would be disabled forever(because the guest could not be able to enable
the debug monitor without the following patches), and then the guest would not be able to take
any debug exceptions.

What's your opinion?

> 
> Thanks,
> 
> 	M.
> 
