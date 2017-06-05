From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 05/25] KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
Date: Mon, 5 Jun 2017 10:58:57 +0100
Message-ID: <5b8acdaf-e5a5-25fd-fffe-5ff42d501ee0@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-6-marc.zyngier@arm.com> <20170604202528.GH9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170604202528.GH9464@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/06/17 21:25, Christoffer Dall wrote:
> On Thu, Jun 01, 2017 at 11:20:57AM +0100, Marc Zyngier wrote:
>> Add a handler for reading/writing the guest's view of the ICC_BPR1_EL1
>> register, which is located in the ICH_VMCR_EL2.BPR1 field.
>>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/hyp/vgic-v3-sr.c | 51 +++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 51 insertions(+)
>>
>> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> index 943bf11252d9..6254eaf72a77 100644
>> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
>> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> @@ -375,6 +375,51 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
>>  
>>  #ifdef CONFIG_ARM64
>>  
>> +static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
>> +{
>> +	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
>> +}
>> +
>> +static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
>> +{
>> +	unsigned int bpr;
>> +
>> +	if (vmcr & ICH_VMCR_CBPR_MASK) {
>> +		bpr = __vgic_v3_get_bpr0(vmcr);
>> +		if (bpr < 7)
>> +			bpr++;
>> +	} else {
>> +		bpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
>> +	}
>> +
>> +	return bpr;
>> +}
>> +
>> +static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>> +{
>> +	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
>> +}
>> +
>> +static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>> +{
>> +	u64 val = vcpu_get_reg(vcpu, rt);
>> +	u8 bpr_min = 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> 
> I can't seem to find where this behavior is documented, is it that 8 is
> the theoretical max, and it's the upper preemption levels that apply, so
> it must be 8 - number supported?

I took inspiration from the VPriorityGroup() helper in the GICv3
pseudocode. You can also deduct this from the table described in the
ICC_BPR0_EL1 documentation, though that's admittedly not very clear.

>> +
>> +	if (vmcr & ICH_VMCR_CBPR_MASK)
>> +		return;
>> +
>> +	/* Enforce BPR limiting */
>> +	if (val < bpr_min)
>> +		val = bpr_min;
> 
> Are we not implying that the reset value here also means bpr_min?  I
> also can't seem to find this behavior in the spec and it appears we rely
> on the underlying hardware to set a reset value (by setting vmcr=0 on
> first run).  Could this result in a guest observing one reset value,
> writing 0 to this register, and observing another one?

>From the ICC_BPR0_EL1 documentation:

"An attempt to program the binary point field to a value less than the
minimum value sets the field to the minimum value."

That's the only way you can find out about the minimum value (and the
kernel also uses this functionality to be in a known state, even if it
doesn't use preemption yet).

> 
>> +
>> +	val <<= ICH_VMCR_BPR1_SHIFT;
>> +	val &= ICH_VMCR_BPR1_MASK;
>> +	vmcr &= ~ICH_VMCR_BPR1_MASK;
>> +	vmcr |= val;
>> +
>> +	__vgic_v3_write_vmcr(vmcr);
>> +}
>> +
>>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>>  {
>>  	int rt;
>> @@ -397,6 +442,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
>>  
>>  	switch (sysreg) {
>> +	case SYS_ICC_BPR1_EL1:
>> +		if (is_read)
>> +			fn = __vgic_v3_read_bpr1;
>> +		else
>> +			fn = __vgic_v3_write_bpr1;
>> +		break;
> 
> Did you consider a lookup table with the sysreg encoding, the read
> function, and the right function as each entry?  It may compress the
> code a bit, but I'm not sure if it's nicer or worth it.

I did think of it, but I wasn't sure how much nicer that would be. Happy
to try it and see if that's an improvement though.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
