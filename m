From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: Intermittent guest kernel crashes with v4.5-rc6.
Date: Thu, 3 Mar 2016 07:25:30 -0600
Message-ID: <56D83B4A.1050401@codeaurora.org>
References: <56D6F113.9020605@codeaurora.org> <56D6F5CC.5020101@arm.com>
 <56D6FFDE.9050704@codeaurora.org> <56D7023C.7050309@arm.com>
 <56D70B31.70608@codeaurora.org> <56D72464.4080903@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4072341145
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 08:18:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qBsEckGjbW3L for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Mar 2016 08:18:19 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CE39410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 08:18:18 -0500 (EST)
In-Reply-To: <56D72464.4080903@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 03/02/2016 11:35 AM, Marc Zyngier wrote:
> On 02/03/16 15:48, Shanker Donthineni wrote:
>
>> We haven't started running heavy workloads in VMs. So far we
>> have noticed this random nature behavior only during guest
>> kernel boot (at EL1).  
>>
>> We didn't see this problem on 4.3 kernel. Do you think it is
>> related to TLB conflicts?
> I cannot imagine why a DSB would solve a TLB conflict. But the fact that
> you didn't see it crashing on 4.3 is a good indication that something
> else it at play.
>
> In 4.5, we've rewritten a large part of KVM in C, which has changed the
> ordering of the various accesses a lot. It could be that a latent
> problem is now exposed more widely.
>
> Can you try moving this DSB around and find out what is the earliest
> point where it solves this problem? Some sort of bisection?
The maximum I can move up 'dsb ishst' to the beginning of
__guest_enter() but not out side of this function.

I don't understand why it is failing below code, branch
instruction causing problems.

    /* Jump in the fire! */
+  dsb(ishst);
    exit_code = __guest_enter(vcpu, host_ctxt);
    /* And we're baaack! */

> Thanks,
>
> 	M.

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
