From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 8/8] KVM: arm64: Avoid accessing ICH registers
Date: Wed, 10 Feb 2016 16:47:24 +0000
Message-ID: <56BB699C.8060908@arm.com>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-9-git-send-email-marc.zyngier@arm.com>
 <20160210124513.GO5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160210124513.GO5171@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/02/16 12:45, Christoffer Dall wrote:
> On Mon, Feb 08, 2016 at 11:40:22AM +0000, Marc Zyngier wrote:
>> Just like on GICv2, we're a bit hammer-happy with GICv3, and access
>> them more often than we should.
>>
>> Adopt a policy similar to what we do for GICv2, only save/restoring
>> the minimal set of registers. As we don't access the registers
>> linearly anymore (we may skip some), the convoluted accessors become
>> slightly simpler, and we can drop the ugly indexing macro that
>> tended to confuse the reviewers.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 288 ++++++++++++++++++++++++----------------
>>  include/kvm/arm_vgic.h          |   6 -
>>  virt/kvm/arm/vgic-v3.c          |   4 +-
>>  3 files changed, 176 insertions(+), 122 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> index 9142e082..d3813f5 100644
>> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> @@ -39,12 +39,104 @@
>>  		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
>>  	} while (0)
>>  
>> -/* vcpu is already in the HYP VA space */
>> +static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
>> +{
>> +	switch (lr & 0xf) {
>> +	case 0:
>> +		return read_gicreg(ICH_LR0_EL2);
>> +	case 1:
>> +		return read_gicreg(ICH_LR1_EL2);
>> +	case 2:
>> +		return read_gicreg(ICH_LR2_EL2);
>> +	case 3:
>> +		return read_gicreg(ICH_LR3_EL2);
>> +	case 4:
>> +		return read_gicreg(ICH_LR4_EL2);
>> +	case 5:
>> +		return read_gicreg(ICH_LR5_EL2);
>> +	case 6:
>> +		return read_gicreg(ICH_LR6_EL2);
>> +	case 7:
>> +		return read_gicreg(ICH_LR7_EL2);
>> +	case 8:
>> +		return read_gicreg(ICH_LR8_EL2);
>> +	case 9:
>> +		return read_gicreg(ICH_LR9_EL2);
>> +	case 10:
>> +		return read_gicreg(ICH_LR10_EL2);
>> +	case 11:
>> +		return read_gicreg(ICH_LR11_EL2);
>> +	case 12:
>> +		return read_gicreg(ICH_LR12_EL2);
>> +	case 13:
>> +		return read_gicreg(ICH_LR13_EL2);
>> +	case 14:
>> +		return read_gicreg(ICH_LR14_EL2);
>> +	case 15:
>> +		return read_gicreg(ICH_LR15_EL2);
>> +	}
>> +
>> +	unreachable();
>> +}
>> +
>> +static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
>> +{
>> +	switch (lr & 0xf) {
>> +	case 0:
>> +		write_gicreg(val, ICH_LR0_EL2);
>> +		break;
>> +	case 1:
>> +		write_gicreg(val, ICH_LR1_EL2);
>> +		break;
>> +	case 2:
>> +		write_gicreg(val, ICH_LR2_EL2);
>> +		break;
>> +	case 3:
>> +		write_gicreg(val, ICH_LR3_EL2);
>> +		break;
>> +	case 4:
>> +		write_gicreg(val, ICH_LR4_EL2);
>> +		break;
>> +	case 5:
>> +		write_gicreg(val, ICH_LR5_EL2);
>> +		break;
>> +	case 6:
>> +		write_gicreg(val, ICH_LR6_EL2);
>> +		break;
>> +	case 7:
>> +		write_gicreg(val, ICH_LR7_EL2);
>> +		break;
>> +	case 8:
>> +		write_gicreg(val, ICH_LR8_EL2);
>> +		break;
>> +	case 9:
>> +		write_gicreg(val, ICH_LR9_EL2);
>> +		break;
>> +	case 10:
>> +		write_gicreg(val, ICH_LR10_EL2);
>> +		break;
>> +	case 11:
>> +		write_gicreg(val, ICH_LR11_EL2);
>> +		break;
>> +	case 12:
>> +		write_gicreg(val, ICH_LR12_EL2);
>> +		break;
>> +	case 13:
>> +		write_gicreg(val, ICH_LR13_EL2);
>> +		break;
>> +	case 14:
>> +		write_gicreg(val, ICH_LR14_EL2);
>> +		break;
>> +	case 15:
>> +		write_gicreg(val, ICH_LR15_EL2);
>> +		break;
>> +	}
>> +}
>> +
>>  void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>>  	u64 val;
>> -	u32 max_lr_idx, nr_pri_bits;
>>  
>>  	/*
>>  	 * Make sure stores to the GIC via the memory mapped interface
>> @@ -53,68 +145,50 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>>  	dsb(st);
>>  
>>  	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
>> -	cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
>> -	cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
>> -	cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
>>  
>> -	write_gicreg(0, ICH_HCR_EL2);
>> -	val = read_gicreg(ICH_VTR_EL2);
>> -	max_lr_idx = vtr_to_max_lr_idx(val);
>> -	nr_pri_bits = vtr_to_nr_pri_bits(val);
>> +	if (vcpu->arch.vgic_cpu.live_lrs) {
>> +		int i;
>> +		u32 max_lr_idx, nr_pri_bits;
>>  
>> -	switch (max_lr_idx) {
>> -	case 15:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(15)] = read_gicreg(ICH_LR15_EL2);
>> -	case 14:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(14)] = read_gicreg(ICH_LR14_EL2);
>> -	case 13:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(13)] = read_gicreg(ICH_LR13_EL2);
>> -	case 12:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(12)] = read_gicreg(ICH_LR12_EL2);
>> -	case 11:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(11)] = read_gicreg(ICH_LR11_EL2);
>> -	case 10:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(10)] = read_gicreg(ICH_LR10_EL2);
>> -	case 9:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(9)] = read_gicreg(ICH_LR9_EL2);
>> -	case 8:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(8)] = read_gicreg(ICH_LR8_EL2);
>> -	case 7:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(7)] = read_gicreg(ICH_LR7_EL2);
>> -	case 6:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(6)] = read_gicreg(ICH_LR6_EL2);
>> -	case 5:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(5)] = read_gicreg(ICH_LR5_EL2);
>> -	case 4:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(4)] = read_gicreg(ICH_LR4_EL2);
>> -	case 3:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(3)] = read_gicreg(ICH_LR3_EL2);
>> -	case 2:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(2)] = read_gicreg(ICH_LR2_EL2);
>> -	case 1:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(1)] = read_gicreg(ICH_LR1_EL2);
>> -	case 0:
>> -		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(0)] = read_gicreg(ICH_LR0_EL2);
>> -	}
>> +		cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
>> +		cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
>> +		cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
>>  
>> -	switch (nr_pri_bits) {
>> -	case 7:
>> -		cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
>> -		cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
>> -	case 6:
>> -		cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
>> -	default:
>> -		cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
>> -	}
>> +		write_gicreg(0, ICH_HCR_EL2);
>> +		val = read_gicreg(ICH_VTR_EL2);
> 
> can't we cache the read of ICH_VTR_EL2 then?

We can (this is an invariant anyway). I don't expect it to be slow
though, as this doesn't have to go deep into the GIC, and stays at the
CPU level. I'll benchmark it anyway.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
