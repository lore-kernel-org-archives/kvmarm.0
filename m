From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: Re: [PATCH v4 13/15] KVM: arm: keep track of guest use of the debug
 registers
Date: Tue, 29 Sep 2015 13:36:15 +0800
Message-ID: <560A234F.9050702@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org> <1439213167-8988-14-git-send-email-zhichao.huang@linaro.org> <20150902160103.GP10991@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150902160103.GP10991@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/9/3 0:01, Christoffer Dall wrote:
> On Mon, Aug 10, 2015 at 09:26:05PM +0800, Zhichao Huang wrote:
>>  
>> -static bool trap_debug32(struct kvm_vcpu *vcpu,
>> +/* Indicate whether the guest has enabled any break/watch points or not. */
>> +static bool guest_debug_in_use(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < ARM_MAX_BRP; i++)
>> +		if (vcpu->arch.cp14[cp14_DBGBCR0 + i] & 0x1)
>> +			return true;
>> +	for (i = 0; i < ARM_MAX_WRP; i++)
>> +		if (vcpu->arch.cp14[cp14_DBGWCR0 + i] & 0x1)
>> +			return true;
>> +
>> +	return false;
>> +}
>> +
>> +static bool __trap_debug32(struct kvm_vcpu *vcpu,
>>  			const struct coproc_params *p,
>>  			const struct coproc_reg *r)
>>  {
>> @@ -232,6 +247,56 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
>>  	return true;
>>  }
>>  

>> +static bool trap_debug32(struct kvm_vcpu *vcpu,
>> +			const struct coproc_params *p,
>> +			const struct coproc_reg *r)
>> +{
>> +	__trap_debug32(vcpu, p, r);
>> +
>> +	if (p->is_write) {
>> +		if ((vcpu->arch.cp14[r->reg] & 0x1) ||
>> +		    guest_debug_in_use(vcpu))
>> +			vcpu->arch.debug_flags |= KVM_ARM_DEBUG_GUEST_INUSE;
>> +		else
>> +			vcpu->arch.debug_flags &= ~KVM_ARM_DEBUG_GUEST_INUSE;
> 
> I don't understand this logic, if we are enabling one of the w/b points
> or if there was already an enabled w/b point, then we set the flag, but
> if you disable a single one then you clear the flag?
> 
> It looks to me like you're mixing two approaches here;  either read
> through all the registers whenever you need to know to set the flag or
> not, or you keep track of this on every read/write of the registers.
> 

I did it in the function guest_debug_in_use(), which will read through all the
registers.


> 
> So __trap_debug32 is for the non-control registers and trap-debug32 is
> for the control registers?
> 
> I think specifically naming the control register function
> trap_debug_cr would be cleaner in that case.
> 

OK.

> Thanks,
> -Christoffer
> 
