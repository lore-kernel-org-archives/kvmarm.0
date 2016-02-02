From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 14/21] arm64: KVM: VHE: Implement VHE
 activate/deactivate_traps
Date: Tue, 2 Feb 2016 11:27:09 +0000
Message-ID: <56B0928D.8020003@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-15-git-send-email-marc.zyngier@arm.com>
 <20160201142045.GT1478@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160201142045.GT1478@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/16 14:20, Christoffer Dall wrote:
> On Mon, Jan 25, 2016 at 03:53:48PM +0000, Marc Zyngier wrote:
>> Running the kernel in HYP mode requires the HCR_E2H bit to be set
>> at all times, and the HCR_TGE bit to be set when running as a host
>> (and cleared when running as a guest). At the same time, the vector
>>  must be set to the current role of the kernel (either host or
>> hypervisor), and a couple of system registers differ between VHE
>> and non-VHE.
>>
>> We implement these by using another set of alternate functions
>> that get dynamically patched.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_arm.h     |  1 +
>>  arch/arm64/include/asm/kvm_emulate.h |  3 +++
>>  arch/arm64/kvm/hyp/switch.c          | 52 +++++++++++++++++++++++++++++++++---
>>  3 files changed, 53 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 738a95f..73d3826 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -23,6 +23,7 @@
>>  #include <asm/types.h>
>>  
>>  /* Hyp Configuration Register (HCR) bits */
>> +#define HCR_E2H		(UL(1) << 34)
>>  #define HCR_ID		(UL(1) << 33)
>>  #define HCR_CD		(UL(1) << 32)
>>  #define HCR_RW_SHIFT	31
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 3066328..5ae0c69 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -29,6 +29,7 @@
>>  #include <asm/kvm_mmio.h>
>>  #include <asm/ptrace.h>
>>  #include <asm/cputype.h>
>> +#include <asm/virt.h>
>>  
>>  unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
>>  unsigned long *vcpu_spsr32(const struct kvm_vcpu *vcpu);
>> @@ -43,6 +44,8 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
>>  static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>>  {
>>  	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
>> +	if (is_kernel_in_hyp_mode())
>> +		vcpu->arch.hcr_el2 |= HCR_E2H;
>>  	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>>  		vcpu->arch.hcr_el2 &= ~HCR_RW;
>>  }
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index 6f264dc..77f7c94 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -15,6 +15,8 @@
>>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>   */
>>  
>> +#include <asm/kvm_asm.h>
>> +
>>  #include "hyp.h"
>>  
>>  static bool __hyp_text __fpsimd_enabled_nvhe(void)
>> @@ -36,6 +38,27 @@ bool __hyp_text __fpsimd_enabled(void)
>>  	return __fpsimd_is_enabled()();
>>  }
>>  
>> +static void __hyp_text __activate_traps_vhe(void)
>> +{
>> +	u64 val;
>> +
>> +	val = read_sysreg(cpacr_el1);
>> +	val |= 1 << 28;
>> +	val &= ~(3 << 20);
> 
> could you define these bitfields as well?

Sure.

> 
>> +	write_sysreg(val, cpacr_el1);
>> +
>> +	write_sysreg(__kvm_hyp_vector, vbar_el1);
>> +}
>> +
>> +static void __hyp_text __activate_traps_nvhe(void)
>> +{
>> +	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
>> +}
>> +
>> +static hyp_alternate_select(__activate_traps_arch,
>> +			    __activate_traps_nvhe, __activate_traps_vhe,
>> +			    ARM64_HAS_VIRT_HOST_EXTN);
>> +
>>  static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>>  {
>>  	u64 val;
>> @@ -55,16 +78,39 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>>  	write_sysreg(val, hcr_el2);
>>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>>  	write_sysreg(1 << 15, hstr_el2);
>> -	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
>>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>> +	__activate_traps_arch()();
>>  }
>>  
>> -static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>> +static void __hyp_text __deactivate_traps_vhe(void)
>> +{
>> +	extern char vectors[];	/* kernel exception vectors */
>> +	u64 val;
>> +
>> +	write_sysreg(HCR_RW | HCR_TGE | HCR_E2H, hcr_el2);
> 
> perhaps we should define the EL2_HOST_HCR bit settings somewhere
> globally and reuse that here?

I'm going for HCR_HOST_VHE_FLAGS, as a pendant to HCR_GUEST_FLAGS.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
