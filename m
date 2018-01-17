From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v3 08/41] KVM: arm/arm64: Introduce vcpu_el1_is_32bit
Date: Wed, 17 Jan 2018 14:44:32 +0000
Message-ID: <4a3fa63c-5925-e406-26dd-da4e9765e7fa@arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-9-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-9-christoffer.dall@linaro.org>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 12/01/18 12:07, Christoffer Dall wrote:
> We have numerous checks around that checks if the HCR_EL2 has the RW bit
> set to figure out if we're running an AArch64 or AArch32 VM.  In some
> cases, directly checking the RW bit (given its unintuitive name), is a
> bit confusing, and that's not going to improve as we move logic around
> for the following patches that optimize KVM on AArch64 hosts with VHE.
> 
> Therefore, introduce a helper, vcpu_el1_is_32bit, and replace existing
> direct checks of HCR_EL2.RW with the helper.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 7 ++++++-
>   arch/arm64/kvm/hyp/switch.c          | 8 ++------
>   arch/arm64/kvm/hyp/sysreg-sr.c       | 5 +++--
>   arch/arm64/kvm/inject_fault.c        | 6 +++---
>   4 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index b36aaa1fe332..e07bf463ac58 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -45,6 +45,11 @@ void kvm_inject_undef32(struct kvm_vcpu *vcpu);
>   void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr);
>   void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr);
>   
> +static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
> +{
> +	return !(vcpu->arch.hcr_el2 & HCR_RW);
> +}
> +

Just so I understand, the difference between this and vcpu_mode_is_32bit 
is that vcpu_mode_is_32bit might return true because an 
interrupt/exception occured while guest was executing 32bit EL0 but 
guest EL1 is still 64bits, is that correct?

Also, it seems the process controlling KVM is supposed to provide the 
information of whether the vcpu runs a 32bit el1, would it be better to do:

	return test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features);

instead of looking at the hcr? Or is there a case where those might differ?

Otherwise:

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Cheers,

-- 
Julien Thierry
