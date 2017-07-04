From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 2/3] arm64: kvm: route synchronous external abort
 exceptions to el2
Date: Tue, 4 Jul 2017 14:30:21 +0800
Message-ID: <8ce52b7e-e5bd-8a4e-bc4e-bb046d19c2f5@huawei.com>
References: <1498481156-23572-1-git-send-email-gengdongjiu@huawei.com>
 <3862ccaf-a669-17b0-4cfb-ce15fce361a1@huawei.com>
 <20170703082345.GD4066@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170703082345.GD4066@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@linaro.org>
Cc: corbet@lwn.net, wuquanming@huawei.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, rkrcmar@redhat.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 2017/7/3 16:23, Christoffer Dall wrote:
> On Tue, Jun 27, 2017 at 08:15:49PM +0800, gengdongjiu wrote:
>> correct the commit message:
>>
>>  In the firmware-first RAS solution, OS receives an synchronous
>>  external abort, then trapped to EL3 by SCR_EL3.EA. Firmware inspects
>>  the HCR_EL2.TEA and chooses the target to send APEI's SEA notification.
>>  If the SCR_EL3.EA is set, delegates the error exception to the hypervisor,
>>  otherwise it delegates to the host OS kernel
> 
> This commit text has nothing (directly) to do with the content of the
> patch.  Whether or not seting these bits are used by firmware to emulate
> injecting an exception or by the CPU raising a an exception is not the
> core of the issue.
> 
> Please describe your change, then provide rationale.

(1)Below hcr_el2.TEA/TERR two field is introduced by armv8.2, RAS extension.

TEA, bit [37]
	Route synchronous External Abort exceptions to EL2. The possible values of this bit are:
	0 Do not route synchronous External Abort exceptions from Non-secure EL0 and EL1 to EL2.
	1 Route synchronous External Abort exceptions from Non-secure EL0 and EL1 to EL2, if not routed
	to EL3.
	This bit is RES0 if the RAS extension is not implemented.
TERR, bit [36]
	Trap Error record accesses. The possible values of this bit are:
	0 Do not trap accesses to error record registers from Non-secure EL1 to EL2.
	1 Accesses to the ER* registers from Non-secure EL1 generate a Trap exception to EL2.
	This bit is RES0 if the RAS extension is not implemented.

(2) when synchronous External Abort(SEA) OS happen SEA, it trap to EL3 firmware.
then the firmware needs to do by faking an exception entry to  hypervisor EL2; or
by faking an exception entry to EL1
so if the hcr_el2.TEA is set, firmware will eret to EL2; otherwise, eret to EL1.
hcr_el2.TEA is only set for the guest OS.
not set for the host OS.


(3) setting hcr_el2.HCR_TERR want to trap the EL1 error record access to EL2.


> 
> Thanks,
> -Christoffer
> 
> 
>>
>>
>> On 2017/6/26 20:45, Dongjiu Geng wrote:
>>> In the firmware-first RAS solution, guest OS receives an synchronous
>>> external abort, then trapped to EL3 by SCR_EL3.EA. Firmware inspects
>>> the HCR_EL2.TEA and chooses the target to send APEI's SEA notification.
>>> If the SCR_EL3.EA is set, delegates the error exception to the hypervisor,
>>> otherwise it delegates to the guest OS kernel
>>>
>>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>>> ---
>>>  arch/arm64/include/asm/kvm_arm.h     | 2 ++
>>>  arch/arm64/include/asm/kvm_emulate.h | 7 +++++++
>>>  2 files changed, 9 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>>> index 61d694c..1188272 100644
>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>> @@ -23,6 +23,8 @@
>>>  #include <asm/types.h>
>>>  
>>>  /* Hyp Configuration Register (HCR) bits */
>>> +#define HCR_TEA		(UL(1) << 37)
>>> +#define HCR_TERR	(UL(1) << 36)
>>>  #define HCR_E2H		(UL(1) << 34)
>>>  #define HCR_ID		(UL(1) << 33)
>>>  #define HCR_CD		(UL(1) << 32)
>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>>> index f5ea0ba..5f64ab2 100644
>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>> @@ -47,6 +47,13 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>>>  	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
>>>  	if (is_kernel_in_hyp_mode())
>>>  		vcpu->arch.hcr_el2 |= HCR_E2H;
>>> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
>>> +		/* route synchronous external abort exceptions to EL2 */
>>> +		vcpu->arch.hcr_el2 |= HCR_TEA;
>>> +		/* trap error record accesses */
>>> +		vcpu->arch.hcr_el2 |= HCR_TERR;
>>> +	}
>>> +
>>>  	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>>>  		vcpu->arch.hcr_el2 &= ~HCR_RW;
>>>  }
>>>
>>
> 
> .
> 
