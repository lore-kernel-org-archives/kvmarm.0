From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 02/10] KVM: arm/arm64: Move cntvoff to each timer context
Date: Mon, 30 Jan 2017 14:51:51 +0000
Message-ID: <2453da50-d827-0aa5-1dea-beb35117d1ae@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-3-git-send-email-jintack@cs.columbia.edu>
 <867f5e9j4y.fsf@arm.com> <20170130144550.GA16459@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3D9340666
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:51:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UFXWn54sucP8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 09:51:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F68A40296
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:51:37 -0500 (EST)
In-Reply-To: <20170130144550.GA16459@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/17 14:45, Christoffer Dall wrote:
> On Sun, Jan 29, 2017 at 11:54:05AM +0000, Marc Zyngier wrote:
>> On Fri, Jan 27 2017 at 01:04:52 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>>> Make cntvoff per each timer context. This is helpful to abstract kvm
>>> timer functions to work with timer context without considering timer
>>> types (e.g. physical timer or virtual timer).
>>>
>>> This also would pave the way for ever doing adjustments of the cntvoff
>>> on a per-CPU basis if that should ever make sense.
>>>
>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>> ---
>>>  arch/arm/include/asm/kvm_host.h   |  6 +++---
>>>  arch/arm64/include/asm/kvm_host.h |  4 ++--
>>>  include/kvm/arm_arch_timer.h      |  8 +++-----
>>>  virt/kvm/arm/arch_timer.c         | 26 ++++++++++++++++++++------
>>>  virt/kvm/arm/hyp/timer-sr.c       |  3 +--
>>>  5 files changed, 29 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>> index d5423ab..f5456a9 100644
>>> --- a/arch/arm/include/asm/kvm_host.h
>>> +++ b/arch/arm/include/asm/kvm_host.h
>>> @@ -60,9 +60,6 @@ struct kvm_arch {
>>>  	/* The last vcpu id that ran on each physical CPU */
>>>  	int __percpu *last_vcpu_ran;
>>>  
>>> -	/* Timer */
>>> -	struct arch_timer_kvm	timer;
>>> -
>>>  	/*
>>>  	 * Anything that is not used directly from assembly code goes
>>>  	 * here.
>>> @@ -75,6 +72,9 @@ struct kvm_arch {
>>>  	/* Stage-2 page table */
>>>  	pgd_t *pgd;
>>>  
>>> +	/* A lock to synchronize cntvoff among all vtimer context of vcpus */
>>> +	spinlock_t cntvoff_lock;
>>
>> Is there any condition where we need this to be a spinlock? I would have
>> thought that a mutex should have been enough, as this should only be
>> updated on migration or initialization. Not that it matters much in this
>> case, but I wondered if there is something I'm missing.
>>
> 
> I would think the critical section is small enough that a spinlock makes
> sense, but what I don't think we need is to add the additional lock.
> 
> I think just taking the kvm->lock should be sufficient, which happens to
> be a mutex, and while that may be a bit slower to take than the
> spinlock, it's not in the critical path so let's just keep things
> simple.
> 
> Perhaps this what Marc also meant.

That would be the logical conclusion, assuming that we can sleep on this
path.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
