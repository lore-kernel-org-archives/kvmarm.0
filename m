From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 22/28] arm64/sve: KVM: Prevent guests from using SVE
Date: Thu, 12 Oct 2017 12:28:32 +0100
Message-ID: <d8a50bf1-bfe0-2423-c56b-adac3925309e@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-23-git-send-email-Dave.Martin@arm.com>
 <c28b3f0d-7beb-cca3-46db-3fce964f4725@arm.com>
 <20171012110409.GG19485@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171012110409.GG19485@e103592.cambridge.arm.com>
Content-Language: en-GB
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Christoffer Dall <cdall@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 12/10/17 12:04, Dave Martin wrote:
> On Wed, Oct 11, 2017 at 05:28:06PM +0100, Marc Zyngier wrote:
>> [+ Christoffer]
>>
>> On 10/10/17 19:38, Dave Martin wrote:
>>> Until KVM has full SVE support, guests must not be allowed to
>>> execute SVE instructions.
>>>
>>> This patch enables the necessary traps, and also ensures that the
>>> traps are disabled again on exit from the guest so that the host
>>> can still use SVE if it wants to.
>>>
>>> This patch introduces another instance of
>>> __this_cpu_write(fpsimd_last_state, NULL), so this flush operation
>>> is abstracted out as a separate helper fpsimd_flush_cpu_state().
>>> Other instances are ported appropriately.
>>>
>>> As a side effect of this refactoring, a this_cpu_write() in
>>> fpsimd_cpu_pm_notifier() is changed to __this_cpu_write().  This
>>> should be fine, since cpu_pm_enter() is supposed to be called only
>>> with interrupts disabled.
>>>
>>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>>> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
> 
> [...]
> 
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index e923b58..674912d 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
> 
> [...]
> 
>>> @@ -384,4 +385,14 @@ static inline void __cpu_init_stage2(void)
> 
> [...]
> 
>>> +static inline void kvm_fpsimd_flush_cpu_state(void)
>>> +{
>>> +	if (system_supports_sve())
>>> +		sve_flush_cpu_state();
>>
>> Hmmm. How does this work if...
> 
> !IS_ENABLED(CONFIG_ARM64_SVE) implies !system_supports_sve(), so
> if CONFIG_ARM64_SVE is not set, the call is optimised away.
> 
> [...]
> 
>>> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
>>> index a9cb794..6ae3703 100644
>>> --- a/arch/arm64/kernel/fpsimd.c
>>> +++ b/arch/arm64/kernel/fpsimd.c
>>> @@ -1073,6 +1073,33 @@ void fpsimd_flush_task_state(struct task_struct *t)
> 
> [...]
> 
>>> +#ifdef CONFIG_ARM64_SVE
>>> +void sve_flush_cpu_state(void)
>>> +{
>>> +	struct fpsimd_state *const fpstate = __this_cpu_read(fpsimd_last_state);
>>> +	struct task_struct *tsk;
>>> +
>>> +	if (!fpstate)
>>> +		return;
>>> +
>>> +	tsk = container_of(fpstate, struct task_struct, thread.fpsimd_state);
>>> +	if (test_tsk_thread_flag(tsk, TIF_SVE))
>>> +		fpsimd_flush_cpu_state();
>>> +}
>>> +#endif /* CONFIG_ARM64_SVE */
>>
>> ... CONFIG_ARM64_SVE is not set? Fixing this should just be a matter of
>> moving the #ifdef/#endif inside the function...
> 
> Because sve_flush_cpu_state() is not in the same compilation unit it
> can't be static, and that means the compiler won't remove it
> automatically if it's unused -- hence the #ifdef.
> 
> Because the call site is optimised away, there is no link failure.
> 
> Don't we rely on this sort of thing all over the place?
Dunno. It just feels weird. But if you are sure that it won't break,
fine by me. I guess we'll find out pretty quickly how this fares,
specially with older toolchains.

	M.
-- 
Jazz is not dead. It just smells funny...
