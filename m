From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Thu, 7 Sep 2017 13:00:50 +0100
Message-ID: <a2f82bb5-e61c-9c80-51c9-738fbcdd127e@arm.com>
References: <1504763684-30128-1-git-send-email-gengdongjiu@huawei.com>
 <59B10F52.9010400@arm.com> <f710f68a-1e89-85a6-41a6-afc7588114db@huawei.com>
 <ec27c833-c9f7-d144-3c6f-a87a3bf3d97f@arm.com>
 <eebc5831-79ff-c79c-34ff-37c852885bbe@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 881DE40D8B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Sep 2017 07:58:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VTzLUDh0-apG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Sep 2017 07:58:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8377A40C5A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Sep 2017 07:58:26 -0400 (EDT)
In-Reply-To: <eebc5831-79ff-c79c-34ff-37c852885bbe@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>, James Morse <james.morse@arm.com>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, huangshaoyu@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, zhanghaibin7@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 07/09/17 12:49, gengdongjiu wrote:
> 
> 
> On 2017/9/7 18:13, Marc Zyngier wrote:
>> On 07/09/17 11:05, gengdongjiu wrote:
>>> Hi James,
>>>
>>> On 2017/9/7 17:20, James Morse wrote:
>>>> Hi Dongjiu Geng,
>>>>
>>>> On 07/09/17 06:54, Dongjiu Geng wrote:
>>>>> In VHE mode, host kernel runs in the EL2 and can enable
>>>>> 'User Access Override' when fs==KERNEL_DS so that it can
>>>>> access kernel memory. However, PSTATE.UAO is set to 0 on
>>>>> an exception taken from EL1 to EL2. Thus when VHE is used
>>>>> and exception taken from a guest UAO will be disabled and
>>>>> host will use the incorrect PSTATE.UAO. So check and reset
>>>>> the PSTATE.UAO when switching to host.
>>>>
>>>> This would only be a problem if KVM were calling into world-switch with
>>>> fs==KERNEL_DS. I can't see where this happens.
>>>  Not only KVM, may also kernel sets the fs == KERNEL_DS before calling into world-switch
>>
>> How? Please describe the exact sequence of event that lead to this
>> situation with the current code base.
> 
> Hi Marc,
> 
>    Different tasks have different fs, such as USER_DS or KERNEL_DS. In the context switch, it will restore the
> task's fs. Thus, that depends on task itself, as shown below code. UAO is different with PAN, PAN will be always enabled if
> hardware CPU supports PAN feature, but UAO is dynamical change.

You haven't answered my question: There is exactly one point where we
enter the world-switch. Show me that, at this point, PSTATE.UAO *before*
the call is different from PSTATE.UAO after the call. Give me the exact
sequence of event that leads to this situation. Show me a stack trace.

Until you do this, I will ignore any further comment coming from you on
this subject.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
