From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v3 26/41] KVM: arm64: Introduce framework for accessing
 deferred sysregs
Date: Thu, 18 Jan 2018 13:39:16 +0000
Message-ID: <48d6c906-d3b3-5566-5be9-b4cbc99b202d@arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-27-christoffer.dall@linaro.org>
 <dce891ed-3e43-a136-9d7b-c7186fe2ff3c@arm.com> <20180118130823.GC27865@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 560ED49E1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 08:34:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kgzoz6SiwUoP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jan 2018 08:34:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BAB249E09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 08:34:15 -0500 (EST)
In-Reply-To: <20180118130823.GC27865@cbox>
Content-Language: en-US
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



On 18/01/18 13:08, Christoffer Dall wrote:
> On Wed, Jan 17, 2018 at 05:52:21PM +0000, Julien Thierry wrote:
>>
>>
>> On 12/01/18 12:07, Christoffer Dall wrote:
>>> We are about to defer saving and restoring some groups of system
>>> registers to vcpu_put and vcpu_load on supported systems.  This means
>>> that we need some infrastructure to access system registes which
>>> supports either accessing the memory backing of the register or directly
>>> accessing the system registers, depending on the state of the system
>>> when we access the register.
>>>
>>> We do this by defining a set of read/write accessors for each system
>>> register, and letting each system register be defined as "immediate" or
>>> "deferrable".  Immediate registers are always saved/restored in the
>>> world-switch path, but deferrable registers are only saved/restored in
>>> vcpu_put/vcpu_load when supported and sysregs_loaded_on_cpu will be set
>>> in that case.
>>>
>>
>> The patch is fine, however I'd suggest adding a comment in the pointing out
>> that the IMMEDIATE/DEFERRABLE apply to save/restore to the vcpu struct.
>> Instinctively I would expect the deferrable/immediate to apply to the actual
>> hardware register access, so a comment would prevent people like me to get
>> on the wrong track.
>>
> 
> I tried to explain that a bit in the first sentence of the commit
> message, but I can try to make it more clear that we introduce
> terminology.
> 

The commit message is fine, I just think it would be nice to have it in 
the code so you don't have to look for the commit to understand.

>>> Not that we don't use the deferred mechanism yet in this patch, but only
>>> introduce infrastructure.  This is to improve convenience of review in
>>> the subsequent patches where it is clear which registers become
>>> deferred.
>>>
>>>   [ Most of this logic was contributed by Marc Zyngier ]
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
>>
>>> ---
>>>   arch/arm64/include/asm/kvm_host.h |   8 +-
>>>   arch/arm64/kvm/sys_regs.c         | 160 ++++++++++++++++++++++++++++++++++++++
>>>   2 files changed, 166 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 91272c35cc36..4b5ef82f6bdb 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -281,6 +281,10 @@ struct kvm_vcpu_arch {
>>>   	/* Detect first run of a vcpu */
>>>   	bool has_run_once;
>>> +
>>> +	/* True when deferrable sysregs are loaded on the physical CPU,
>>> +	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
>>> +	bool sysregs_loaded_on_cpu;
>>>   };
>>>   #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>>> @@ -293,8 +297,8 @@ struct kvm_vcpu_arch {
>>>    */
>>>   #define __vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
>>> -#define vcpu_read_sys_reg(v,r)	__vcpu_sys_reg(v,r)
>>> -#define vcpu_write_sys_reg(v,r,n)	do { __vcpu_sys_reg(v,r) = n; } while (0)
>>> +u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg);
>>> +void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val);
>>>   /*
>>>    * CP14 and CP15 live in the same array, as they are backed by the
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 96398d53b462..9d353a6a55c9 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -35,6 +35,7 @@
>>>   #include <asm/kvm_coproc.h>
>>>   #include <asm/kvm_emulate.h>
>>>   #include <asm/kvm_host.h>
>>> +#include <asm/kvm_hyp.h>
>>>   #include <asm/kvm_mmu.h>
>>>   #include <asm/perf_event.h>
>>>   #include <asm/sysreg.h>
>>> @@ -76,6 +77,165 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>>>   	return false;
>>>   }
>>> +struct sys_reg_accessor {
>>> +	u64	(*rdsr)(struct kvm_vcpu *, int);
>>> +	void	(*wrsr)(struct kvm_vcpu *, int, u64);
>>
>> Nit:
>>
>> Why use a signed integer for the register index argument?
>>
> 
> The type name is short? ;)  No particular reason, could be an unsigned
> int, but I don't think it matters here does it?
> 

Probably not, just personal preference I guess.

>>> +};
>>> +
>>> +#define DECLARE_IMMEDIATE_SR(i)						\
>>> +	static u64 __##i##_read(struct kvm_vcpu *vcpu, int r)		\
>>> +	{								\
>>> +		return __vcpu_sys_reg(vcpu, r);				\
>>> +	}								\
>>> +									\
>>> +	static void __##i##_write(struct kvm_vcpu *vcpu, int r, u64 v)	\
>>> +	{								\
>>> +		__vcpu_sys_reg(vcpu, r) = v;				\
>>> +	}								\
>>> +
>>> +#define DECLARE_DEFERRABLE_SR(i, s)					\
>>> +	static u64 __##i##_read(struct kvm_vcpu *vcpu, int r)		\
>>> +	{								\
>>> +		if (vcpu->arch.sysregs_loaded_on_cpu) {			\
>>> +			WARN_ON(kvm_arm_get_running_vcpu() != vcpu);	\
>>> +			return read_sysreg_s((s));			\
>>> +		}							\
>>> +		return __vcpu_sys_reg(vcpu, r);				\
>>> +	}								\
>>> +									\
>>> +	static void __##i##_write(struct kvm_vcpu *vcpu, int r, u64 v)	\
>>> +	{								\
>>> +		if (vcpu->arch.sysregs_loaded_on_cpu) {			\
>>> +			WARN_ON(kvm_arm_get_running_vcpu() != vcpu);	\
>>> +			write_sysreg_s(v, (s));				\
>>> +		} else {						\
>>> +			__vcpu_sys_reg(vcpu, r) = v;			\
>>> +		}							\
>>> +	}								\
>>> +
>>> +
>>> +#define SR_HANDLER_RANGE(i,e)						\
>>> +	[i ... e] =  (struct sys_reg_accessor) {			\
>>> +		.rdsr = __##i##_read,					\
>>> +		.wrsr = __##i##_write,					\
>>
>> Nit:
>> Could we have __vcpu_##i##_read and __vcpu_##i##_write?
>>
> 
> They don't necessarily read from the vcpu do they?
> 

Hmmm, from my understanding they do, but the action the vcpu can be 
immediate or deferred. But from the semantics you give to 
IMMEDIATE/DEFERRABLE, I'd say the actions are related to vcpu.

I don't know if that makes sense.

> Unrelated: I also thought about just having a single function a switch
> statement instead, which may make it easier to follow the code as there
> would be no macros generating functions, but it would be slightly less
> declarative.
> 
> For example:
> 
> u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
> {
> 	if (!vcpu->arch.sysregs_loaded_on_cpu)
> 		goto immediate_read;
> 	
> 	/*
> 	 * All system registers listed in the switch are deferred
> 	 * save/restored on VHE systems.
> 	 */
> 	switch (reg) {
> 	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1));
> 	case SCTLR_EL1:		return read_sysreg_s(sctlr_EL12));
> 	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1));
> 	case CPACR_EL1:		return read_sysreg_s(cpacr_EL12));
> 	case TTBR0_EL1:		return read_sysreg_s(ttbr0_EL12));
> 	case TTBR1_EL1:		return read_sysreg_s(ttbr1_EL12));
> 	case TCR_EL1:		return read_sysreg_s(tcr_EL12));
> 	case ESR_EL1:		return read_sysreg_s(esr_EL12));
> 	case AFSR0_EL1:		return read_sysreg_s(afsr0_EL12));
> 	case AFSR1_EL1:		return read_sysreg_s(afsr1_EL12));
> 	case FAR_EL1:		return read_sysreg_s(far_EL12));
> 	case MAIR_EL1:		return read_sysreg_s(mair_EL12));
> 	case VBAR_EL1:		return read_sysreg_s(vbar_EL12));
> 	case CONTEXTIDR_EL1:	return read_sysreg_s(contextidr_EL12));
> 	case TPIDR_EL0:		return read_sysreg_s(SYS_TPIDR_EL0));
> 	case TPIDRRO_EL0:	return read_sysreg_s(SYS_TPIDRRO_EL0));
> 	case TPIDR_EL1:		return read_sysreg_s(SYS_TPIDR_EL1));
> 	case AMAIR_EL1:		return read_sysreg_s(amair_EL12));
> 	case CNTKCTL_EL1:	return read_sysreg_s(cntkctl_EL12));
> 	case PAR_EL1:		return read_sysreg_s(SYS_PAR_EL1));
> 	case DACR32_EL2:	return read_sysreg_s(SYS_DACR32_EL2));
> 	case IFSR32_EL2:	return read_sysreg_s(SYS_IFSR32_EL2));
> 	case DBGVCR32_EL2:	return read_sysreg_s(SYS_DBGVCR32_EL2));
> 	}
> 
> immediate_read:
> 	return __vcpu_sys_reg(vcpu, reg);
> }
> 
> Since you're having a look at this, what are your thoughts?

I like that suggestion, very easy to follow. Of course negative side is 
that you'll need two of those switch... But yes I still prefer this new 
suggestion.

So if you go with this you can ignore my other comments ;) .

Thanks,

-- 
Julien Thierry
