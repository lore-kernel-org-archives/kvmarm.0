From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 09/19] arm64: KVM: Handle async aborts delivered while at
 EL2
Date: Wed, 7 Sep 2016 18:21:55 +0100
Message-ID: <57D04CB3.1030208@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
 <1473166937-15271-10-git-send-email-marc.zyngier@arm.com>
 <20160907170304.GT23592@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C902149B32
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 13:13:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tE4n2FIqW6zp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2016 13:13:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3355411E3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 13:13:31 -0400 (EDT)
In-Reply-To: <20160907170304.GT23592@cbox>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 07/09/16 18:03, Christoffer Dall wrote:
> On Tue, Sep 06, 2016 at 02:02:07PM +0100, Marc Zyngier wrote:
>> If EL1 generates an asynchronous abort and then traps into EL2
>> before the abort has been delivered, we may end-up with the
>> abort firing at the worse possible place: on the host.
>>
>> In order to avoid this, it is necessary to take the abort at EL2,
>> by clearing the PSTATE.A bit. In order to survive this abort,
>> we do it at a point where we're in a known state with respect
>> to the world switch, and handle the resulting exception,
>> overloading the exit code in the process.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/entry.S     | 33 ++++++++++++++++++++++++++++++++-
>>  arch/arm64/kvm/hyp/hyp-entry.S | 25 +++++++++++++++++++++++--
>>  arch/arm64/kvm/hyp/switch.c    |  6 ++++++
>>  3 files changed, 61 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
>> index 3967c231..7662ef5 100644
>> --- a/arch/arm64/kvm/hyp/entry.S
>> +++ b/arch/arm64/kvm/hyp/entry.S
>> @@ -122,7 +122,38 @@ ENTRY(__guest_exit)
>>  	// Now restore the host regs
>>  	restore_callee_saved_regs x2
>>  
>> -	ret
>> +	// If we have a pending asynchronous abort, now is the
>> +	// time to find out. From your VAXorcist book, page 666:
>> +	// "Threaten me not, oh Evil one!  For I speak with
>> +	// the power of DEC, and I command thee to show thyself!"
>> +	mrs	x2, elr_el2
>> +	mrs	x3, esr_el2
>> +	mrs	x4, spsr_el2
>> +	mov	x5, x0
>> +
>> +	dsb	sy		// Synchronize against in-flight ld/st
>> +	msr	daifclr, #4	// Unmask aborts
>> +
>> +	// This is our single instruction exception window. A pending
>> +	// SError is guaranteed to occur at the earliest when we unmask
>> +	// it, and at the latest just after the ISB.
> 
> Why is it guaranteed to to occur at the latest after the ISB?  I thought
> that asynchronous exceptions could in theory be deferred until forever,
> but I am probably wrong about this.

The DSB is going to force all transactions to be completed and at that
point, we shouldn't have anything being further delayed (this is not an
architectural guarantee, but something that happens to work on the cores
I have access to), and the potential exception becomes pending.

At this point, we perform the unmask. A pending exception *can* fire at
that point, but is not guaranteed to do so. But the ISB, being a
"context synchronization event", guarantees that the exception fires
before the first instruction that follows the ISB (see D1.14.4). This is
what gives us this one instruction window (after the unmask, or after
the isb).

Hope this helps,

	M.
-- 
Jazz is not dead. It just smells funny...
