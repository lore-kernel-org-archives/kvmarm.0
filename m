From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 7/7] ARM: KVM: Unlock vgic-v3 support
Date: Tue, 6 Sep 2016 14:18:10 +0100
Message-ID: <57CEC212.401@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-8-git-send-email-vladimir.murzin@arm.com>
 <20160905112927.GL26366@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02D9C49B47
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:09:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K8b-vseYZgbq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 09:09:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A3749B46
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:09:48 -0400 (EDT)
In-Reply-To: <20160905112927.GL26366@cbox>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/09/16 12:29, Christoffer Dall wrote:
> On Tue, Aug 16, 2016 at 11:46:58AM +0100, Vladimir Murzin wrote:
>> It is time to get access to common version of vgic-v3.
> 
> common version?
> 

Since patch#2 it not private to arm64 or I should rephrase this?

>>
>> We basically would need to tell build system how to pick it up and
>> undo KVM_ARM_VGIC_V3 guarding introduced in 4f64cb6 ("arm/arm64: KVM:
>> Only allow 64bit hosts to build VGICv3") and remove stubs. However,
>> since vgic got ITS support KVM_ARM_VGIC_V3 tend to protect a little
>> bit more than just plain vgic-v3 - this guard is used for ITS too
>> which is not supported in 32-bit world yet.  So, along with removal of
>> KVM_ARM_VGIC_V3 guard introduce the new one - KVM_ARM_VGIC_V3_ITS to
>> protect ITS related code.
> 
> I don't find this paragraph particularly helpful, I'm afraid.
> 

Sorry for that. It seems to much for one patch, I'll split it per your
suggestion bellow.

>>
>> The only unpleasant part is how we decide which save/restore sequence to
>> use under __vgic_save_state() - we don't have patching framework in hand
>> like arm64, so have to check runtime on every invocation.
> 
> Do static keys work on 32-bit arm?
> 

I'll try to use them.

>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_host.h     |    4 +++
>>  arch/arm/include/asm/kvm_hyp.h      |    5 ++++
>>  arch/arm/kvm/Makefile               |    2 ++
>>  arch/arm/kvm/hyp/Makefile           |    1 +
>>  arch/arm/kvm/hyp/switch.c           |   20 +++++++++++--
>>  arch/arm64/kvm/Kconfig              |    4 +--
>>  include/kvm/arm_vgic.h              |    8 ------
>>  virt/kvm/arm/vgic/vgic-kvm-device.c |   10 ++-----
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |    2 ++
>>  virt/kvm/arm/vgic/vgic-mmio.c       |    2 --
>>  virt/kvm/arm/vgic/vgic-mmio.h       |    3 --
>>  virt/kvm/arm/vgic/vgic.h            |   54 ++---------------------------------
>>  12 files changed, 38 insertions(+), 77 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index de338d9..1312597 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -39,7 +39,11 @@
>>  
>>  #include <kvm/arm_vgic.h>
>>  
>> +#ifdef CONFIG_ARM_GIC_V3
>> +#define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>> +#else
>>  #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
>> +#endif
>>  
>>  #define KVM_REQ_VCPU_EXIT	8
>>  
>> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
>> index e604ad68..95669b3 100644
>> --- a/arch/arm/include/asm/kvm_hyp.h
>> +++ b/arch/arm/include/asm/kvm_hyp.h
>> @@ -88,6 +88,8 @@
>>  
>>  #define VFP_FPEXC	__ACCESS_VFP(FPEXC)
>>  
>> +#define ID_PFR1		__ACCESS_CP15(c0, 0, c1, 1)
>> +
>>  /* AArch64 compatibility macros, only for the timer so far */
>>  #define read_sysreg_el0(r)		read_sysreg(r##_el0)
>>  #define write_sysreg_el0(v, r)		write_sysreg(v, r##_el0)
>> @@ -103,6 +105,9 @@ void __timer_restore_state(struct kvm_vcpu *vcpu);
>>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>>  
>> +void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>> +void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>> +
>>  void __sysreg_save_state(struct kvm_cpu_context *ctxt);
>>  void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
>>  
>> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
>> index 10d77a6..043d817f 100644
>> --- a/arch/arm/kvm/Makefile
>> +++ b/arch/arm/kvm/Makefile
>> @@ -26,8 +26,10 @@ obj-y += $(KVM)/arm/vgic/vgic.o
>>  obj-y += $(KVM)/arm/vgic/vgic-init.o
>>  obj-y += $(KVM)/arm/vgic/vgic-irqfd.o
>>  obj-y += $(KVM)/arm/vgic/vgic-v2.o
>> +obj-y += $(KVM)/arm/vgic/vgic-v3.o
>>  obj-y += $(KVM)/arm/vgic/vgic-mmio.o
>>  obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
>> +obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
>>  obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
>>  obj-y += $(KVM)/irqchip.o
>>  obj-y += $(KVM)/arm/arch_timer.o
>> diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
>> index 8dfa5f7..3023bb5 100644
>> --- a/arch/arm/kvm/hyp/Makefile
>> +++ b/arch/arm/kvm/hyp/Makefile
>> @@ -5,6 +5,7 @@
>>  KVM=../../../../virt/kvm
>>  
>>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
>> +obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
>>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
>>  
>>  obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
>> diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
>> index b13caa9..9666bae 100644
>> --- a/arch/arm/kvm/hyp/switch.c
>> +++ b/arch/arm/kvm/hyp/switch.c
>> @@ -15,6 +15,8 @@
>>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>   */
>>  
>> +#include <linux/irqchip/arm-gic-v3.h>
>> +
>>  #include <asm/kvm_asm.h>
>>  #include <asm/kvm_hyp.h>
>>  
>> @@ -74,14 +76,28 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
>>  	write_sysreg(read_sysreg(MIDR), VPIDR);
>>  }
>>  
>> +static bool __hyp_text __has_useable_gicv3_cpuif(void)
>> +{
>> +	if (IS_ENABLED(CONFIG_ARM_GIC_V3) && (read_sysreg(ID_PFR1) >> 28))
> 
> Do we have a define for bit 28 we could use?
> 
> Does this actually work on all v7 boards?  The v7 ARM ARM seems to state
> that this bitfield is Reserved, UNK.  Does that somehow mean 'is going
> to be zero'?
> 
>> +		return !!(read_sysreg(ICC_HSRE) & ICC_SRE_EL2_SRE);
>> +	else
>> +		return false;
>> +}
>> +
>>  static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
>>  {
>> -	__vgic_v2_save_state(vcpu);
>> +	if (__has_useable_gicv3_cpuif())
>> +		__vgic_v3_save_state(vcpu);
>> +	else
>> +		__vgic_v2_save_state(vcpu);
>>  }
>>  
>>  static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
>>  {
>> -	__vgic_v2_restore_state(vcpu);
>> +	if (__has_useable_gicv3_cpuif())
>> +		__vgic_v3_restore_state(vcpu);
>> +	else
>> +		__vgic_v2_restore_state(vcpu);
>>  }
>>  
>>  static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 9c9edc9..6eaf12c 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -16,7 +16,7 @@ menuconfig VIRTUALIZATION
>>  
>>  if VIRTUALIZATION
>>  
>> -config KVM_ARM_VGIC_V3
>> +config KVM_ARM_VGIC_V3_ITS
> 
> I feel like this could have been simplified with adding the new ITS
> guard in a separate patch.
> 
> In fact, you could then have a separate patch that enables compilation
> of the gicv3 code and removes the static inlines etc., and then finally
> a patch that adds in the logic for the world switch.

Agree. Will rework this patch.

Thanks
Vladimir
