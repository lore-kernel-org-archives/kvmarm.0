From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Fri, 15 Dec 2017 09:09:05 +0000
Message-ID: <519f0e33-4419-68be-32b4-11bb5e19cf17@arm.com>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <20171213091803.GQ910@cbox> <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
 <20171214130954.GV910@cbox> <5615f3e1-756e-0537-f0b6-20ae8626ac87@gmail.com>
 <20171214154518.GX910@cbox> <e5ccbf1c-6078-4c43-8aa3-fc226ed358f7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FFD049D5E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 04:05:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yy8VMclDBuX6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 04:05:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69EAA406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 04:05:33 -0500 (EST)
In-Reply-To: <e5ccbf1c-6078-4c43-8aa3-fc226ed358f7@gmail.com>
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
To: Jia He <hejianet@gmail.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Jia He <jia.he@hxt-semitech.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/17 02:27, Jia He wrote:
> 
> 

[...]

>> @@ -367,6 +368,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
>>   
>>   	/* Disable the virtual timer */
>>   	write_sysreg_el0(0, cntv_ctl);
>> +	isb();
> My only concern is whether this isb() is required here?
> Sorryif this is a stupid question.I understand little about arm arch 
> memory barrier. But seems isb will flush all the instruction prefetch.Do 
> you think if an timer interrupt irq arrives, arm will use the previous 
> instruction prefetch?


This barrier has little to do with prefetch. It just guarantees that the
code after the isb() is now running with a disabled virtual timer.
Otherwise, a CPU can freely reorder the write_sysreg() until the next
context synchronization event.

An interrupt coming between the write and the barrier will also act as a
context synchronization event. For more details, see the ARMv8 ARM (the
glossary has a section on the concept).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
