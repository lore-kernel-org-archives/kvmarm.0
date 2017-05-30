From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 15/31] KVM: arm64: vgic-v3: Add ICV_AP1Rn_EL1 handler
Date: Tue, 30 May 2017 10:02:20 +0200
Message-ID: <e07081cf-82c5-0878-52f9-930f1727574d@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-16-marc.zyngier@arm.com>
 <b672d790-738b-df50-06fc-8b72c7692abe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <b672d790-738b-df50-06fc-8b72c7692abe@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 30/05/2017 09:48, Auger Eric wrote:
> H Marc,
> 
> On 03/05/2017 12:45, Marc Zyngier wrote:
>> Add a handler for reading/writing the guest's view of the ICV_AP1Rn_EL1
>> registers. We just map them to the corresponding ICH_AP1Rn_EL2 registers.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/sysreg.h |  1 +
>>  virt/kvm/arm/hyp/vgic-v3-sr.c   | 94 +++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 95 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 15c142ce991c..aad46b8eea5e 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -180,6 +180,7 @@
>>  
>>  #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
>>  
>> +#define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
>>  #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
>>  #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
>>  #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
>> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> index a76351b3ad66..b6803989da1f 100644
>> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
>> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> @@ -684,6 +684,76 @@ static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int
>>  	__vgic_v3_write_vmcr(vmcr);
>>  }
>>  
>> +static void __hyp_text __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
> Shouldn't you test somewhere that n is correct given the number of
> implemented priority bits
>> +{
>> +	u32 val;
>> +
>> +	if (!__vgic_v3_get_group(vcpu))
> I don't really get how an access to AP1Rn can end up in AP0Rn. I am not
> able to find any related description in the spec?
Forget that one. This is simply a generic helper and an access from NS
world will access the AP1Rn reg.

so besides the comment on "n" check,

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> 
> Thanks
> 
> Eric
>> +		val = __vgic_v3_read_ap0rn(n);
> 
>> +	else
>> +		val = __vgic_v3_read_ap1rn(n);
>> +
>> +	vcpu_set_reg(vcpu, rt, val);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
>> +{
>> +	u32 val = vcpu_get_reg(vcpu, rt);
>> +
>> +	if (!__vgic_v3_get_group(vcpu))
>> +		__vgic_v3_write_ap0rn(val, n);
>> +	else
>> +		__vgic_v3_write_ap1rn(val, n);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
>> +					    u32 vmcr, int rt)
>> +{
>> +	__vgic_v3_read_apxrn(vcpu, rt, 0);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_read_apxr1(struct kvm_vcpu *vcpu,
>> +					    u32 vmcr, int rt)
>> +{
>> +	__vgic_v3_read_apxrn(vcpu, rt, 1);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_read_apxr2(struct kvm_vcpu *vcpu,
>> +					    u32 vmcr, int rt)
>> +{
>> +	__vgic_v3_read_apxrn(vcpu, rt, 2);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_read_apxr3(struct kvm_vcpu *vcpu,
>> +					    u32 vmcr, int rt)
>> +{
>> +	__vgic_v3_read_apxrn(vcpu, rt, 3);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_write_apxr0(struct kvm_vcpu *vcpu,
>> +					     u32 vmcr, int rt)
>> +{
>> +	__vgic_v3_write_apxrn(vcpu, rt, 0);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_write_apxr1(struct kvm_vcpu *vcpu,
>> +					     u32 vmcr, int rt)
>> +{
>> +	__vgic_v3_write_apxrn(vcpu, rt, 1);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_write_apxr2(struct kvm_vcpu *vcpu,
>> +					     u32 vmcr, int rt)
>> +{
>> +	__vgic_v3_write_apxrn(vcpu, rt, 2);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu,
>> +					     u32 vmcr, int rt)
>> +{
>> +	__vgic_v3_write_apxrn(vcpu, rt, 3);
>> +}
>> +
>>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>>  {
>>  	int rt = kvm_vcpu_sys_get_rt(vcpu);
>> @@ -722,6 +792,30 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>>  		else
>>  			fn = __vgic_v3_write_bpr1;
>>  		break;
>> +	case SYS_ICC_AP1Rn_EL1(0):
>> +		if (is_read)
>> +			fn = __vgic_v3_read_apxr0;
>> +		else
>> +			fn = __vgic_v3_write_apxr0;
>> +		break;
>> +	case SYS_ICC_AP1Rn_EL1(1):
>> +		if (is_read)
>> +			fn = __vgic_v3_read_apxr1;
>> +		else
>> +			fn = __vgic_v3_write_apxr1;
>> +		break;
>> +	case SYS_ICC_AP1Rn_EL1(2):
>> +		if (is_read)
>> +			fn = __vgic_v3_read_apxr2;
>> +		else
>> +			fn = __vgic_v3_write_apxr2;
>> +		break;
>> +	case SYS_ICC_AP1Rn_EL1(3):
>> +		if (is_read)
>> +			fn = __vgic_v3_read_apxr3;
>> +		else
>> +			fn = __vgic_v3_write_apxr3;
>> +		break;
>>  	default:
>>  		return 0;
>>  	}
>>
