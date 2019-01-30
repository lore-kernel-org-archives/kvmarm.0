From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 10/14] KVM: arm/arm64: consolidate arch timer trap handlers
Date: Wed, 30 Jan 2019 17:38:16 +0000
Message-ID: <b1e1a5e5-0abe-4a41-315d-526212caacd4@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
 <20190124140032.8588-11-christoffer.dall@arm.com>
 <d9e59695-bc87-e2b5-f0d0-7bc172d2d83c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FB494A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 12:38:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MUBA4qgKoLuS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 12:38:20 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3A384A1DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 12:38:19 -0500 (EST)
In-Reply-To: <d9e59695-bc87-e2b5-f0d0-7bc172d2d83c@arm.com>
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
To: Julien Thierry <julien.thierry@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 25/01/2019 12:33, Julien Thierry wrote:
> Hi,
> 
> I'm wondering, could this patch be split in two? One for the
> introduction of kvm_arm_timer_read_sysreg() +
> kvm_arm_timer_write_sysreg() and the other for merging the handlers into
> a single function?

Maybe. I'm not sure it brings us much though.

> 
> 
> 
> On 24/01/2019 14:00, Christoffer Dall wrote:
>> From: Andre Przywara <andre.przywara@arm.com>
>>
>> At the moment we have separate system register emulation handlers for
>> each timer register. Actually they are quite similar, and we rely on
>> kvm_arm_timer_[gs]et_reg() for the actual emulation anyways, so let's
>> just merge all of those handlers into one function, which just marshalls
>> the arguments and then hands off to a set of common accessors.
>> This makes extending the emulation to include EL2 timers much easier.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> [Fixed 32-bit VM breakage and reduced to reworking existing code]
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> [Fixed 32bit host, general cleanup]
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/kvm/coproc.c           |  23 +++---
>>  arch/arm64/include/asm/sysreg.h |   4 +
>>  arch/arm64/kvm/sys_regs.c       |  80 +++++++++++---------
>>  include/kvm/arm_arch_timer.h    |  23 ++++++
>>  virt/kvm/arm/arch_timer.c       | 129 +++++++++++++++++++++++++++-----
>>  5 files changed, 196 insertions(+), 63 deletions(-)
>>
>> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
>> index 222c1635bc7a..51863364f8d1 100644
>> --- a/arch/arm/kvm/coproc.c
>> +++ b/arch/arm/kvm/coproc.c
>> @@ -293,15 +293,16 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
>>  			     const struct coproc_params *p,
>>  			     const struct coproc_reg *r)
>>  {
>> -	u64 now = kvm_phys_timer_read();
>> -	u64 val;
>> +	u32 val;
>>  
>>  	if (p->is_write) {
>>  		val = *vcpu_reg(vcpu, p->Rt1);
>> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL, val + now);
>> +		kvm_arm_timer_write_sysreg(vcpu,
>> +					   TIMER_PTIMER, TIMER_REG_TVAL, val);
>>  	} else {
>> -		val = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
>> -		*vcpu_reg(vcpu, p->Rt1) = val - now;
>> +		val = kvm_arm_timer_read_sysreg(vcpu,
>> +						TIMER_PTIMER, TIMER_REG_TVAL);
>> +		*vcpu_reg(vcpu, p->Rt1) = val;
>>  	}
>>  
>>  	return true;
>> @@ -315,9 +316,11 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
>>  
>>  	if (p->is_write) {
>>  		val = *vcpu_reg(vcpu, p->Rt1);
>> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CTL, val);
>> +		kvm_arm_timer_write_sysreg(vcpu,
>> +					   TIMER_PTIMER, TIMER_REG_CTL, val);
>>  	} else {
>> -		val = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CTL);
>> +		val = kvm_arm_timer_read_sysreg(vcpu,
>> +						TIMER_PTIMER, TIMER_REG_CTL);
>>  		*vcpu_reg(vcpu, p->Rt1) = val;
>>  	}
>>  
>> @@ -333,9 +336,11 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>>  	if (p->is_write) {
>>  		val = (u64)*vcpu_reg(vcpu, p->Rt2) << 32;
>>  		val |= *vcpu_reg(vcpu, p->Rt1);
>> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL, val);
>> +		kvm_arm_timer_write_sysreg(vcpu,
>> +					   TIMER_PTIMER, TIMER_REG_CVAL, val);
>>  	} else {
>> -		val = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
>> +		val = kvm_arm_timer_read_sysreg(vcpu,
>> +						TIMER_PTIMER, TIMER_REG_CVAL);
>>  		*vcpu_reg(vcpu, p->Rt1) = val;
>>  		*vcpu_reg(vcpu, p->Rt2) = val >> 32;
>>  	}
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 3e5650903d6d..6482e8bcf1b8 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -392,6 +392,10 @@
>>  #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
>>  #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
>>  
>> +#define SYS_AARCH32_CNTP_TVAL		sys_reg(0, 0, 14, 2, 0)
>> +#define SYS_AARCH32_CNTP_CTL		sys_reg(0, 0, 14, 2, 1)
>> +#define SYS_AARCH32_CNTP_CVAL		sys_reg(0, 2, 0, 14, 0)
>> +
>>  #define __PMEV_op2(n)			((n) & 0x7)
>>  #define __CNTR_CRm(n)			(0x8 | (((n) >> 3) & 0x3))
>>  #define SYS_PMEVCNTRn_EL0(n)		sys_reg(3, 3, 14, __CNTR_CRm(n), __PMEV_op2(n))
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 1a5bea4285e4..65ea63366c67 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -990,44 +990,51 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>>  
>> -static bool access_cntp_tval(struct kvm_vcpu *vcpu,
>> -		struct sys_reg_params *p,
>> -		const struct sys_reg_desc *r)
>> +static bool access_arch_timer(struct kvm_vcpu *vcpu,
>> +			      struct sys_reg_params *p,
>> +			      const struct sys_reg_desc *r)
>>  {
>> -	u64 now = kvm_phys_timer_read();
>> -	u64 cval;
>> +	enum kvm_arch_timers tmr;
>> +	enum kvm_arch_timer_regs treg;
>> +	u64 reg = reg_to_encoding(r);
>>  
>> -	if (p->is_write) {
>> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL,
>> -				      p->regval + now);
>> -	} else {
>> -		cval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
>> -		p->regval = cval - now;
>> +	switch (reg) {
>> +	case SYS_CNTP_TVAL_EL0:
>> +	case SYS_CNTP_CTL_EL0:
>> +	case SYS_CNTP_CVAL_EL0:
>> +	case SYS_AARCH32_CNTP_TVAL:
>> +	case SYS_AARCH32_CNTP_CTL:
>> +	case SYS_AARCH32_CNTP_CVAL:
>> +		tmr = TIMER_PTIMER;
>> +		break;
>> +	default:
>> +		BUG();
>>  	}
>>  
>> -	return true;
>> -}
>> +	switch (reg) {
> 
> I find having two consecutive switch on the same element a bit weird
> (and takes a lot of space).
> 
> Either I'd merge the two since the valid cases are the same, or I'd put
> them in separate function "reg_get_timer(reg)",
> "reg_get_timer_reg(reg)". (Can probably fit those in
> include/kvm/arm_arch_timer.h)

Nah, I'll just merge them. I wrote it this way as it was just easier to
reason about one thing at a time, but in the end this is (as you
noticed) fairly pointless.

I guess I'll have more fun rebasing the NV stuff on top! ;-)

[...]

>> +static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>> +			      struct arch_timer_context *timer,
>> +			      enum kvm_arch_timer_regs treg)
>> +{
>> +	u64 val;
>> +
>> +	switch (treg) {
>> +	case TIMER_REG_TVAL:
>> +		val = kvm_phys_timer_read() - timer->cntvoff - timer->cnt_cval;
>> +		break;
>> +
>> +	case TIMER_REG_CTL:
>> +		val = read_timer_ctl(timer);
>> +		break;
>> +
>> +	case TIMER_REG_CVAL:
>> +		val = timer->cnt_cval;
>> +		break;
>> +
>> +	case TIMER_REG_CNT:
>> +		val = kvm_phys_timer_read() - timer->cntvoff;
> 
> Unless you really don't want people to read this register, you might
> want to add a "break;" here :) .

Timers are for wimps. Real hax0rz use a calibrated loop with interrupts
disabled! ;-)

Thanks for the heads up!

	M.
-- 
Jazz is not dead. It just smells funny...
