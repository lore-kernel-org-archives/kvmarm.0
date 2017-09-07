From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Thu, 7 Sep 2017 16:23:30 +0100
Message-ID: <d01b49a2-e204-73af-23e3-5fd7f7202859@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F2015EF473@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2015EF473@DGGEMA503-MBX.china.huawei.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>, James Morse <james.morse@arm.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "vladimir.murzin@arm.com" <vladimir.murzin@arm.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "shankerd@codeaurora.org" <shankerd@codeaurora.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhanghaibin (Euler)" <zhanghaibin7@huawei.com>, Huangshaoyu <huangshaoyu@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/09/17 16:03, gengdongjiu wrote:
>> On 07/09/17 12:49, gengdongjiu wrote:
>>>
>>>
>>> On 2017/9/7 18:13, Marc Zyngier wrote:
>>>> On 07/09/17 11:05, gengdongjiu wrote:
>>>>> Hi James,
>>>>>
>>>>> On 2017/9/7 17:20, James Morse wrote:
>>>>>> Hi Dongjiu Geng,
>>>>>>
>>>>>> On 07/09/17 06:54, Dongjiu Geng wrote:
>>>>>>> In VHE mode, host kernel runs in the EL2 and can enable 'User
>>>>>>> Access Override' when fs==KERNEL_DS so that it can access kernel
>>>>>>> memory. However, PSTATE.UAO is set to 0 on an exception taken from
>>>>>>> EL1 to EL2. Thus when VHE is used and exception taken from a guest
>>>>>>> UAO will be disabled and host will use the incorrect PSTATE.UAO.
>>>>>>> So check and reset the PSTATE.UAO when switching to host.
>>>>>>
>>>>>> This would only be a problem if KVM were calling into world-switch
>>>>>> with fs==KERNEL_DS. I can't see where this happens.
>>>>>  Not only KVM, may also kernel sets the fs == KERNEL_DS before
>>>>> calling into world-switch
>>>>
>>>> How? Please describe the exact sequence of event that lead to this
>>>> situation with the current code base.
>>>
>>> Hi Marc,
>>>
>>>    Different tasks have different fs, such as USER_DS or KERNEL_DS. In
>>> the context switch, it will restore the task's fs. Thus, that depends
>>> on task itself, as shown below code. UAO is different with PAN, PAN will be always enabled if hardware CPU supports PAN feature, but
>> UAO is dynamical change.
>>
>> You haven't answered my question: There is exactly one point where we enter the world-switch. Show me that, at this point, PSTATE.UAO
>> *before* the call is different from PSTATE.UAO after the call. Give me the exact sequence of event that leads to this situation. Show me a
>> stack trace.
> 
> Hi Marc,
> 
> If using current mainline KVM code + Qemu and modify nothing, may not
> exist broken issue,  because the Qemu progress FS should be USER_DS.

Thanks. You've just been wasting everybody's time for two days. In case
you haven't noticed, mainline KVM code is the *ONLY* thing we care about.

> But if I make a modification for user space( Qemu or KVM tools) to
> change its FS property to KERNEL_DS or use third party application
> with KERNEL_DS FS to run the guest, it will have problem(the
> KERNEL_DS is cleared). If you think my case is reasonable and should
> support, I can show you the calling stack trace. If you think, my
> case is not reasonable and KVM should not support the application
> with KERNEL_DS fs to run guest. You can ignore this patch, thanks.

I really cannot think of a good reason why we'd want to do that. Playing
with set_fs() is almost universally wrong, and I'm certainly going to
oppose to any change in that area unless the code that calls set_fs()
has been made public and properly reviewed. Until then, UAO/PAN will
stay as they are unless you prove that our current code is wrong.

	M.
-- 
Jazz is not dead. It just smells funny...
