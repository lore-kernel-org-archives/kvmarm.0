From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 06/16] arm64/sve: Refactor user SVE trap maintenance
 for external use
Date: Wed, 9 May 2018 17:47:31 +0100
Message-ID: <d61937a5-d8f1-92fb-6d0c-483cd9d2244a@arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-7-git-send-email-Dave.Martin@arm.com>
 <dad74a47-26f4-d38f-a9c4-e60fc9d1a07a@arm.com>
 <20180509164125.GQ7753@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FA66402B8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 May 2018 12:37:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v4JE4UPrmU74 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 May 2018 12:37:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9A84401CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 May 2018 12:37:32 -0400 (EDT)
In-Reply-To: <20180509164125.GQ7753@e103592.cambridge.arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/05/18 17:41, Dave Martin wrote:
> On Wed, May 09, 2018 at 05:36:30PM +0100, Marc Zyngier wrote:
>> On 09/05/18 17:12, Dave Martin wrote:
>>> In preparation for optimising the way KVM manages switching the
>>> guest and host FPSIMD state, it is necessary to provide a means for
>>> code outside arch/arm64/kernel/fpsimd.c to restore the user trap
>>> configuration for SVE correctly for the current task.
>>>
>>> Rather than requiring external code to duplicate the maintenance
>>> explicitly, this patch wraps moves the trap maintenenace to
>>> fpsimd_bind_to_cpu(), since it is logically part of the work of
>>> associating the current task with the cpu.
>>>
>>> Because fpsimd_bind_to_cpu() is rather a cryptic name to publish
>>> alongside fpsimd_bind_state_to_cpu(), the former function is
>>> renamed to fpsimd_bind_task_to_cpu() to make its purpose more
>>> explicit.
>>>
>>> This patch makes appropriate changes to ensure that
>>> fpsimd_bind_task_to_cpu() is always called alongside
>>> task_fpsimd_load(), so that the trap maintenance continues to be
>>> done in every situation where it was done prior to this patch.
>>>
>>> As a side-effect, the metadata updates done by
>>> fpsimd_bind_task_to_cpu() now change from conditional to
>>> unconditional in the "already bound" case of sigreturn.  This is
>>> harmless, and a couple of extra stores on this slow path will not
>>> impact performance.  I consider this a reasonable price to pay for
>>> a slightly cleaner interface.
>>>
>>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>>> ---
>>>  arch/arm64/kernel/fpsimd.c | 28 ++++++++++++++--------------
>>>  1 file changed, 14 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> 
> [...]
> 
>>> @@ -1006,6 +996,16 @@ static void fpsimd_bind_to_cpu(void)
>>>  	last->st = &current->thread.uw.fpsimd_state;
>>>  	last->sve_in_use = test_thread_flag(TIF_SVE);
>>>  	current->thread.fpsimd_cpu = smp_processor_id();
>>> +
>>> +	if (system_supports_sve()) {
>>
>> Is it worth moving the last->sve_in_use assignment here? If the system
>> doesn't have SVE, the assignment is always 0, and we probably don't need
>> to do it at all. It could avoid the double call to test_thread_flag.
> 
> Could do now that you point it out ... but patch 13 gets rid of it
> entirely anyway.  This is (was) part of the (now legacy) mechanism for
> working round KVM's inability to lazily save the host SVE state.
> 
> If I respin I could tweak it here, but it would be purely cosmetic from
> the whole-series point of view.
Nah, don't even bother.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
