From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH] arm64: KVM: debug: Remove spurious inline attributes
Date: Thu, 17 Dec 2015 20:21:44 +0000
Message-ID: <87mvt8g71j.fsf@linaro.org>
References: <1450280963-19985-1-git-send-email-marc.zyngier@arm.com> <87r3ilf3ad.fsf@linaro.org> <5672E81B.7010400@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <5672E81B.7010400@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Marc Zyngier <marc.zyngier@arm.com> writes:

> On 17/12/15 16:28, Alex Benn=C3=A9e wrote:
>>
>> Marc Zyngier <marc.zyngier@arm.com> writes:
>>
>>> The debug trapping code is pretty heavy on the "inline" attribute,
>>> but most functions are actually referenced in the sysreg tables,
>>> making the inlining imposible.
>>>
>>> Removing the useless inline qualifier seems the right thing to do,
>>> having verified that the output code is similar.
>>>
>>> Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  arch/arm64/kvm/sys_regs.c | 58 +++++++++++++++++++++++------------=
------------
>>>  1 file changed, 29 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 88adebf..eec3598 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -220,9 +220,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vc=
pu,
>>>   * All writes will set the KVM_ARM64_DEBUG_DIRTY flag to ensure th=
e
>>>   * hyp.S code switches between host and guest values in future.
>>>   */
>>> -static inline void reg_to_dbg(struct kvm_vcpu *vcpu,
>>> -			      struct sys_reg_params *p,
>>> -			      u64 *dbg_reg)
>>> +static void reg_to_dbg(struct kvm_vcpu *vcpu,
>>> +		       struct sys_reg_params *p,
>>> +		       u64 *dbg_reg)
>>>  {
>>>  	u64 val =3D p->regval;
>>>
>>> @@ -235,18 +235,18 @@ static inline void reg_to_dbg(struct kvm_vcpu=
 *vcpu,
>>>  	vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
>>>  }
>>>
>>> -static inline void dbg_to_reg(struct kvm_vcpu *vcpu,
>>> -			      struct sys_reg_params *p,
>>> -			      u64 *dbg_reg)
>>> +static void dbg_to_reg(struct kvm_vcpu *vcpu,
>>> +		       struct sys_reg_params *p,
>>> +		       u64 *dbg_reg)
>>>  {
>>>  	p->regval =3D *dbg_reg;
>>>  	if (p->is_32bit)
>>>  		p->regval &=3D 0xffffffffUL;
>>>  }
>>
>> Christoffer's "register keyword" comments not-withstanding I'd prefe=
r to
>> keep the reg_to_dbg/dbg_to_reg functions as inline because they real=
ly
>> are just boilerplate helpers I didn't want to repeat in the actual
>> access functions - although if you've looked at the code I assume th=
at
>> means GCC has been smart about it.
>
> Indeed, GCC is smart enough to directly inline it. In general, GCC is
> doing a pretty good job at inlining static functions that are small
> enough not to be worth jumping to. These days, "static inline" only
> really makes sense in an include file.

=46air enough.

>
>> The rest all make sense. I wonder why I was being so inline happy?
>>
>> Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> Thanks,
>
> 	M.


--
Alex Benn=C3=A9e
