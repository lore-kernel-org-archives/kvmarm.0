From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 24/40] KVM: arm64: Rewrite system register accessors to
 read/write functions
Date: Thu, 22 Feb 2018 13:26:01 +0000
Message-ID: <58899246-54d1-77e8-2d7a-395cd6dcdfca@arm.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-25-christoffer.dall@linaro.org>
 <86a7w2lb7m.wl-marc.zyngier@arm.com> <20180222092237.GI29376@cbox>
 <86po4xjo5x.wl-marc.zyngier@arm.com> <20180222111005.GL29376@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180222111005.GL29376@cbox>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/02/18 11:10, Christoffer Dall wrote:
> On Thu, Feb 22, 2018 at 10:48:10AM +0000, Marc Zyngier wrote:
>> On Thu, 22 Feb 2018 09:22:37 +0000,
>> Christoffer Dall wrote:
>>>
>>> On Wed, Feb 21, 2018 at 01:32:45PM +0000, Marc Zyngier wrote:
>>>> On Thu, 15 Feb 2018 21:03:16 +0000,
>>>> Christoffer Dall wrote:
>>>>>
>>>>> From: Christoffer Dall <cdall@cs.columbia.edu>
>>>>>
>>>>> Currently we access the system registers array via the vcpu_sys_reg()
>>>>> macro.  However, we are about to change the behavior to some times
>>>>> modify the register file directly, so let's change this to two
>>>>> primitives:
>>>>>
>>>>>  * Accessor macros vcpu_write_sys_reg() and vcpu_read_sys_reg()
>>>>>  * Direct array access macro __vcpu_sys_reg()
>>>>>
>>>>> The first primitive should be used in places where the code needs to
>>>>> access the currently loaded VCPU's state as observed by the guest.  For
>>>>> example, when trapping on cache related registers, a write to a system
>>>>> register should go directly to the VCPU version of the register.
>>>>>
>>>>> The second primitive can be used in places where the VCPU is known to
>>>>> never be running (for example userspace access) or for registers which
>>>>> are never context switched (for example all the PMU system registers).
>>>>>
>>>>> This rewrites all users of vcpu_sys_regs to one of the two primitives
>>>>> above.
>>>>>
>>>>> No functional change.
>>>>>
>>>>> Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
>>>>> ---
>>>>>
>>>>> Notes:
>>>>>     Changes since v2:
>>>>>      - New patch (deferred register handling has been reworked)
>>>>>
>>>>>  arch/arm64/include/asm/kvm_emulate.h | 13 ++++---
>>>>>  arch/arm64/include/asm/kvm_host.h    | 13 ++++++-
>>>>>  arch/arm64/include/asm/kvm_mmu.h     |  2 +-
>>>>>  arch/arm64/kvm/debug.c               | 27 +++++++++-----
>>>>>  arch/arm64/kvm/inject_fault.c        |  8 ++--
>>>>>  arch/arm64/kvm/sys_regs.c            | 71 ++++++++++++++++++------------------
>>>>>  arch/arm64/kvm/sys_regs.h            |  4 +-
>>>>>  arch/arm64/kvm/sys_regs_generic_v8.c |  4 +-
>>>>>  virt/kvm/arm/pmu.c                   | 37 ++++++++++---------
>>>>>  9 files changed, 102 insertions(+), 77 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>>>>> index 3cc535591bdf..d313aaae5c38 100644
>>>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>>>> @@ -290,15 +290,18 @@ static inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
>>>>>  
>>>>>  static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>>>>>  {
>>>>> -	return vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>>>>> +	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>>>>>  }
>>>>>  
>>>>>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
>>>>>  {
>>>>> -	if (vcpu_mode_is_32bit(vcpu))
>>>>> +	if (vcpu_mode_is_32bit(vcpu)) {
>>>>>  		*vcpu_cpsr(vcpu) |= COMPAT_PSR_E_BIT;
>>>>> -	else
>>>>> -		vcpu_sys_reg(vcpu, SCTLR_EL1) |= (1 << 25);
>>>>> +	} else {
>>>>> +		u64 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>>>>> +		sctlr |= (1 << 25);
>>>>> +		vcpu_write_sys_reg(vcpu, SCTLR_EL1, sctlr);
>>>>
>>>> General comment: it is slightly annoying that vcpu_write_sys_reg takes
>>>> its parameters in an order different from that of write_sysreg
>>>> (register followed with value, instead of value followed with
>>>> register). Not a deal breaker, but slightly confusing.
>>>>
>>>
>>> Ah, I didn't compare to write_sysreg, I was thinking that
>>>
>>>   vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>>>   vcpu_write_sys_reg(vcpu, SCTLR_EL1, val);
>>>
>>> looked more symmetrical because the write just takes an extra value, but
>>> I can see your argument as well.
>>>
>>> I don't mind changing it if it matters to you?
>>
>> I'd like to see that changed, but it doesn't have to be as part of
>> this series if it is going to cause a refactoring mess. We can address
>> it as a blanket fix after this series.
>>
> 
> I think it's reasonably self-contained.
> 
> Just so I'm sure, are these the primitives you'd like to see?
> 
> vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg);
> vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);

That'd be my preference indeed.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
