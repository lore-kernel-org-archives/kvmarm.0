From: Christopher Covington <cov@codeaurora.org>
Subject: Re: Intermittent guest kernel crashes with v4.5-rc6.
Date: Mon, 18 Apr 2016 11:56:35 -0400
Message-ID: <571503B3.6060001@codeaurora.org>
References: <56D6F113.9020605@codeaurora.org> <56D6F5CC.5020101@arm.com>
 <56D6FFDE.9050704@codeaurora.org> <56D7023C.7050309@arm.com>
 <56D70B31.70608@codeaurora.org> <56D72464.4080903@arm.com>
 <56D83B4A.1050401@codeaurora.org> <56D8443C.7060107@arm.com>
 <56D849AF.2040606@codeaurora.org> <56D84C73.3070305@arm.com>
 <56DE48B6.4060705@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2230649BE1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 11:54:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dwlgqHRY8iNL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2016 11:54:44 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB8AC49BDF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 11:54:43 -0400 (EDT)
In-Reply-To: <56DE48B6.4060705@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 03/07/2016 10:36 PM, Shanker Donthineni wrote:
> On 03/03/2016 08:38 AM, Marc Zyngier wrote:
>> On 03/03/16 14:26, Shanker Donthineni wrote:
>>> On 03/03/2016 08:03 AM, Marc Zyngier wrote:
>>>> On 03/03/16 13:25, Shanker Donthineni wrote:
>>>>> On 03/02/2016 11:35 AM, Marc Zyngier wrote:
>>>>>> On 02/03/16 15:48, Shanker Donthineni wrote:
>>>>>>
>>>>>>> We haven't started running heavy workloads in VMs. So far we
>>>>>>> have noticed this random nature behavior only during guest
>>>>>>> kernel boot (at EL1).
>>>>>>>
>>>>>>> We didn't see this problem on 4.3 kernel. Do you think it is
>>>>>>> related to TLB conflicts?
>>>>>> I cannot imagine why a DSB would solve a TLB conflict. But the fact 
>>>>>> that
>>>>>> you didn't see it crashing on 4.3 is a good indication that something
>>>>>> else it at play.
>>>>>>
>>>>>> In 4.5, we've rewritten a large part of KVM in C, which has changed the
>>>>>> ordering of the various accesses a lot. It could be that a latent
>>>>>> problem is now exposed more widely.
>>>>>>
>>>>>> Can you try moving this DSB around and find out what is the earliest
>>>>>> point where it solves this problem? Some sort of bisection?
>>>>> The maximum I can move up 'dsb ishst' to the beginning of
>>>>> __guest_enter() but not out side of this function.
>>>>>
>>>>> I don't understand why it is failing below code, branch
>>>>> instruction causing problems.
>>>>>
>>>>>     /* Jump in the fire! */
>>>>> +  dsb(ishst);
>>>>>     exit_code = __guest_enter(vcpu, host_ctxt);
>>>>>     /* And we're baaack! */
>>>> That's very worrying. I can't see how the branch can have an influence
>>>> on the the DSB (nor why the DSB has an influence on the rest of the
>>>> execution, btw).
>>>>
>>>> What if you replace the DSB with an ISB? Do you observe a similar
>>>> behaviour (works if the barrier is in __guest_enter, but not if it is
>>>> outside)?
>>> I have already tried with isb without success. I did another
>>> experiment flush stage-2 TLBs before calling __guest_enetr(),
>>> it fixed the problem.
>> I suspected something like that. But it is such a massive hammer that it
>> will hide any sort of subtle bug (HW *and* SW).
>>
>>>> Another thing worth looking at is what happened just before we decided
>>>> to get back into the guest. Or to put it differently, what was the
>>>> reason to exit the first place. Was it a Stage-2 fault by any chance?
>>> I will collect as much possible debug data and update results
>>> to you. I went through your KVM refracted 'C' code and did not
>>> find any thing suspicious. I am thinking may be Qualcomm CPUs
>>> have a very aggressive prefech logic that causing the problem.
>> OK. Please keep me posted about your findings. Also maybe involving some
>> HW people ouwld be a good idea (running something in an emulator, for
>> example...).

This has been confirmed to be a hardware defect with a firmware workaround.

Regards,
Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
