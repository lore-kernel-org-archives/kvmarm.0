From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Thu, 7 Sep 2017 19:49:43 +0800
Message-ID: <eebc5831-79ff-c79c-34ff-37c852885bbe@huawei.com>
References: <1504763684-30128-1-git-send-email-gengdongjiu@huawei.com>
 <59B10F52.9010400@arm.com> <f710f68a-1e89-85a6-41a6-afc7588114db@huawei.com>
 <ec27c833-c9f7-d144-3c6f-a87a3bf3d97f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <ec27c833-c9f7-d144-3c6f-a87a3bf3d97f@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, vladimir.murzin@arm.com, rkrcmar@redhat.com, catalin.marinas@arm.com, shankerd@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhanghaibin7@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2017/9/7 18:13, Marc Zyngier wrote:
> On 07/09/17 11:05, gengdongjiu wrote:
>> Hi James,
>>
>> On 2017/9/7 17:20, James Morse wrote:
>>> Hi Dongjiu Geng,
>>>
>>> On 07/09/17 06:54, Dongjiu Geng wrote:
>>>> In VHE mode, host kernel runs in the EL2 and can enable
>>>> 'User Access Override' when fs==KERNEL_DS so that it can
>>>> access kernel memory. However, PSTATE.UAO is set to 0 on
>>>> an exception taken from EL1 to EL2. Thus when VHE is used
>>>> and exception taken from a guest UAO will be disabled and
>>>> host will use the incorrect PSTATE.UAO. So check and reset
>>>> the PSTATE.UAO when switching to host.
>>>
>>> This would only be a problem if KVM were calling into world-switch with
>>> fs==KERNEL_DS. I can't see where this happens.
>>  Not only KVM, may also kernel sets the fs == KERNEL_DS before calling into world-switch
> 
> How? Please describe the exact sequence of event that lead to this
> situation with the current code base.

Hi Marc,

   Different tasks have different fs, such as USER_DS or KERNEL_DS. In the context switch, it will restore the
task's fs. Thus, that depends on task itself, as shown below code. UAO is different with PAN, PAN will be always enabled if
hardware CPU supports PAN feature, but UAO is dynamical change.

/*
 * Thread switching.
 */
__notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
				struct task_struct *next)
{
	struct task_struct *last;

	fpsimd_thread_switch(next);
	tls_thread_switch(next);
	hw_breakpoint_thread_switch(next);
	contextidr_thread_switch(next);
	entry_task_switch(next);
	uao_thread_switch(next);
 	..........
}

/* Restore the UAO state depending on next's addr_limit */
void uao_thread_switch(struct task_struct *next)
{
	if (IS_ENABLED(CONFIG_ARM64_UAO)) {
		if (task_thread_info(next)->addr_limit == KERNEL_DS)
			asm(ALTERNATIVE("nop", SET_PSTATE_UAO(1), ARM64_HAS_UAO));
		else
			asm(ALTERNATIVE("nop", SET_PSTATE_UAO(0), ARM64_HAS_UAO));
	}
}

> 
> 	M.
> 
