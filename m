From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 08/25] KVM: arm64: vgic-v3: Add ICV_EOIR1_EL1 handler
Date: Mon, 5 Jun 2017 12:00:08 +0100
Message-ID: <318accb6-acaf-537c-e0a9-990c57da79d0@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-9-marc.zyngier@arm.com> <20170605103223.GJ9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170605103223.GJ9464@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/06/17 11:32, Christoffer Dall wrote:
> On Thu, Jun 01, 2017 at 11:21:00AM +0100, Marc Zyngier wrote:
>> Add a handler for writing the guest's view of the ICC_EOIR1_EL1
>> register. This involves dropping the priority of the interrupt,
>> and deactivating it if required (EOImode == 0).
>>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  include/linux/irqchip/arm-gic-v3.h |   2 +
>>  virt/kvm/arm/hyp/vgic-v3-sr.c      | 121 +++++++++++++++++++++++++++++++++++++
>>  2 files changed, 123 insertions(+)
>>
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index 401db585a534..e50ce5d416a3 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -417,6 +417,8 @@
>>  
>>  #define ICH_HCR_EN			(1 << 0)
>>  #define ICH_HCR_UIE			(1 << 1)
>> +#define ICH_HCR_EOIcount_SHIFT		27
>> +#define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
>>  
>>  #define ICH_VMCR_CBPR_SHIFT		4
>>  #define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
>> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> index 16a2eadc7a5c..3f04122a5d4d 100644
>> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
>> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> @@ -426,6 +426,26 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
>>  	return lr;
>>  }
>>  
>> +static int __hyp_text __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu,
>> +					       int intid, u64 *lr_val)
>> +{
>> +	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
>> +	int i;
>> +
>> +	for (i = 0; i < used_lrs; i++) {
>> +		u64 val = __gic_v3_get_lr(i);
>> +
>> +		if ((val & ICH_LR_VIRTUAL_ID_MASK) == intid &&
>> +		    (val & ICH_LR_ACTIVE_BIT)) {
>> +			*lr_val = val;
>> +			return i;
>> +		}
>> +	}
>> +
>> +	*lr_val = ICC_IAR1_EL1_SPURIOUS;
>> +	return -1;
>> +}
>> +
>>  static int __hyp_text __vgic_v3_get_highest_active_priority(void)
>>  {
>>  	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
>> @@ -506,6 +526,45 @@ static void __hyp_text __vgic_v3_set_active_priority(u8 pri, u32 vmcr, int grp)
>>  	__vgic_v3_write_ap1rn(val | BIT(ap % 32), apr);
>>  }
>>  
>> +static int __hyp_text __vgic_v3_clear_highest_active_priority(void)
>> +{
>> +	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
>> +	u8 nr_apr_regs = vtr_to_nr_apr_regs(read_gicreg(ICH_VTR_EL2));
>> +	u32 hap = 0;
>> +	int i;
>> +
>> +	for (i = 0; i < nr_apr_regs; i++) {
>> +		u32 ap0, ap1;
>> +		int c0, c1;
>> +
>> +		ap0 = __vgic_v3_read_ap0rn(i);
>> +		ap1 = __vgic_v3_read_ap1rn(i);
> 
> so reading a group 1 interrupt from the IAR and writing that value back
> to the EOIR1_EL1 register can somehow clear the priority of a group 0
> interrupt?

If you properly nest the IAR and EOI, nothing bad will happen (group
priorities are not supposed to overlap). If you decide to do weird
things, you'll be in UNPREDICTABLE territory, and some interrupts can be
left active while you deactivate the wrong one.

> Or did you just want a generic function that does what it's supposed to
> regardless of which register was written to etc.?

That's the goal indeed.

> 
>> +		if (!ap0 && !ap1) {
>> +			hap += 32;
>> +			continue;
>> +		}
>> +
>> +		c0 = ap0 ? __ffs(ap0) : 32;
>> +		c1 = ap1 ? __ffs(ap1) : 32;
>> +
>> +		/* Always clear the LSB, which is the highest priority */
>> +		if (c0 < c1) {
>> +			ap0 &= ~BIT(c0);
>> +			__vgic_v3_write_ap0rn(ap0, i);
>> +			hap += c0;
>> +		} else {
>> +			ap1 &= ~BIT(c1);
>> +			__vgic_v3_write_ap1rn(ap1, i);
>> +			hap += c1;
> 
> Can we ever have a situation where c0 == c1?  And in that case, should
> you prioritize clearing the group 1 apr ?

You shouldn't ever have this case. The spec says:

"Having the bit corresponding to a priority set to 1 in both
ICH_AP0R<n>_EL2 and ICH_AP1R<n>_EL2 might result in UNPREDICTABLE
behavior of the interrupt prioritization system for virtual interrupts."

>> +		}
>> +
>> +		/* Rescale to 8 bits of priority */
>> +		return hap << (8 - nr_pre_bits);
>> +	}
>> +
>> +	return GICv3_IDLE_PRIORITY;
>> +}
>> +
>>  static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>>  {
>>  	u64 lr_val;
>> @@ -542,6 +601,65 @@ static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int r
>>  	vcpu_set_reg(vcpu, rt, ICC_IAR1_EL1_SPURIOUS);
>>  }
>>  
>> +static void __hyp_text __vgic_v3_clear_active_lr(int lr, u64 lr_val)
>> +{
>> +	lr_val &= ~ICH_LR_ACTIVE_BIT;
>> +	if (lr_val & ICH_LR_HW) {
>> +		u32 pid;
>> +
>> +		pid = (lr_val & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT;
>> +		gic_write_dir(pid);
> 
> Yikes, scary.  I can't think of this breaking anything.  But, scary.

I know. a (slightly) less scary approach would be to go all the way back
to EL1 and to the DIR write there, but I don't thing this buys us
anything but wasted cycles...

> 
>> +	}
>> +
>> +	__gic_v3_set_lr(lr_val, lr);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_bump_eoicount(void)
>> +{
>> +	u32 hcr;
>> +
>> +	hcr = read_gicreg(ICH_HCR_EL2);
>> +	hcr += 1 << ICH_HCR_EOIcount_SHIFT;
>> +	write_gicreg(hcr, ICH_HCR_EL2);
>> +}
>> +
>> +static void __hyp_text __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>> +{
>> +	u32 vid = vcpu_get_reg(vcpu, rt);
>> +	u64 lr_val;
>> +	u8 lr_prio, act_prio;
>> +	int lr, grp;
>> +
>> +	grp = __vgic_v3_get_group(vcpu);
>> +
>> +	/* Drop priority in any case */
>> +	act_prio = __vgic_v3_clear_highest_active_priority();
>> +
>> +	/* If EOIing an LPI, no deactivate to be performed */
>> +	if (vid >= VGIC_MIN_LPI)
>> +		return;
>> +
>> +	/* EOImode == 1, nothing to be done here */
>> +	if (vmcr & ICH_VMCR_EOIM_MASK)
>> +		return;
>> +
>> +	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
>> +	if (lr == -1) {
>> +		__vgic_v3_bump_eoicount();
>> +		return;
>> +	}
>> +
>> +	lr_prio = (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
>> +
>> +	/* If priorities or group do not match, the guest has fscked-up. */
>> +	if (grp != !!(lr_val & ICH_LR_GROUP) ||
>> +	    __vgic_v3_pri_to_pre(lr_prio, vmcr, grp) != act_prio)
>> +		return;
> 
> Since we've cleared the highest priority above, is there any way for the
> guest to recover from this, or do this particular (v)GIC implementation
> have the implementation defined behavior of a write with something else
> than the last valid read from the IAR of the same group to the EOIR
> means that the system is toast?

The only way to recover from such a situation from a guest PoV is to
write its APRs to zero, turn everything off, reset the whole GIC, and
restart from scratch. Not pleasant...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
