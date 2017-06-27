From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 2/3] arm64: kvm: route synchronous external abort
 exceptions to el2
Date: Tue, 27 Jun 2017 20:15:49 +0800
Message-ID: <3862ccaf-a669-17b0-4cfb-ce15fce361a1@huawei.com>
References: <1498481156-23572-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498481156-23572-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: marc.zyngier@arm.com, james.morse@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, wuquanming@huawei.com, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, linux@armlinux.org.uk, will.deacon@arm.com, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

correct the commit message:

 In the firmware-first RAS solution, OS receives an synchronous
 external abort, then trapped to EL3 by SCR_EL3.EA. Firmware inspects
 the HCR_EL2.TEA and chooses the target to send APEI's SEA notification.
 If the SCR_EL3.EA is set, delegates the error exception to the hypervisor,
 otherwise it delegates to the host OS kernel


On 2017/6/26 20:45, Dongjiu Geng wrote:
> In the firmware-first RAS solution, guest OS receives an synchronous
> external abort, then trapped to EL3 by SCR_EL3.EA. Firmware inspects
> the HCR_EL2.TEA and chooses the target to send APEI's SEA notification.
> If the SCR_EL3.EA is set, delegates the error exception to the hypervisor,
> otherwise it delegates to the guest OS kernel
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h     | 2 ++
>  arch/arm64/include/asm/kvm_emulate.h | 7 +++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 61d694c..1188272 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -23,6 +23,8 @@
>  #include <asm/types.h>
>  
>  /* Hyp Configuration Register (HCR) bits */
> +#define HCR_TEA		(UL(1) << 37)
> +#define HCR_TERR	(UL(1) << 36)
>  #define HCR_E2H		(UL(1) << 34)
>  #define HCR_ID		(UL(1) << 33)
>  #define HCR_CD		(UL(1) << 32)
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f5ea0ba..5f64ab2 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -47,6 +47,13 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
>  	if (is_kernel_in_hyp_mode())
>  		vcpu->arch.hcr_el2 |= HCR_E2H;
> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
> +		/* route synchronous external abort exceptions to EL2 */
> +		vcpu->arch.hcr_el2 |= HCR_TEA;
> +		/* trap error record accesses */
> +		vcpu->arch.hcr_el2 |= HCR_TERR;
> +	}
> +
>  	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>  		vcpu->arch.hcr_el2 &= ~HCR_RW;
>  }
> 
