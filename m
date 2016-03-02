From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Intermittent guest kernel crashes with v4.5-rc6.
Date: Wed, 2 Mar 2016 17:35:32 +0000
Message-ID: <56D72464.4080903@arm.com>
References: <56D6F113.9020605@codeaurora.org> <56D6F5CC.5020101@arm.com>
 <56D6FFDE.9050704@codeaurora.org> <56D7023C.7050309@arm.com>
 <56D70B31.70608@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C988B411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 12:28:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D2G8jbXOU-lB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2016 12:28:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7741410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 12:28:24 -0500 (EST)
In-Reply-To: <56D70B31.70608@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/03/16 15:48, Shanker Donthineni wrote:

> We haven't started running heavy workloads in VMs. So far we
> have noticed this random nature behavior only during guest
> kernel boot (at EL1).  
> 
> We didn't see this problem on 4.3 kernel. Do you think it is
> related to TLB conflicts?

I cannot imagine why a DSB would solve a TLB conflict. But the fact that
you didn't see it crashing on 4.3 is a good indication that something
else it at play.

In 4.5, we've rewritten a large part of KVM in C, which has changed the
ordering of the various accesses a lot. It could be that a latent
problem is now exposed more widely.

Can you try moving this DSB around and find out what is the earliest
point where it solves this problem? Some sort of bisection?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
