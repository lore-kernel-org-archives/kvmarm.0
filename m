From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 05/41] KVM: arm64: Move HCR_INT_OVERRIDE to default
 HCR_EL2 guest flag
Date: Fri, 9 Feb 2018 11:38:50 +0000
Message-ID: <ffb7df11-b304-25f7-f3f4-b55cb106b747@arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-6-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-6-christoffer.dall@linaro.org>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 01/12/2018 12:07 PM, Christoffer Dall wrote:
> From: Shih-Wei Li <shihwei@cs.columbia.edu>
> 
> We always set the IMO and FMO bits in the HCR_EL2 when running the
> guest, regardless if we use the vgic or not.  By moving these flags to
> HCR_GUEST_FLAGS we can avoid one of the extra save/restore operations of
> HCR_EL2 in the world switch code, and we can also soon get rid of the
> other one.
> 
> This is safe, because even though the IMO and FMO bits control both
> taking the interrupts to EL2 and remapping ICC_*_EL1 to ICV_*_EL1
> executed at EL1, as long as we ensure that these bits are clear when
> running the EL1 host, as defined in the HCR_HOST_[VHE_]FLAGS, we're OK.

NIT: I was a bit confused by the end of the sentence because 
HCR_HOST_FLAGS define does not seem to exist.

> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>   arch/arm64/include/asm/kvm_arm.h | 4 ++--
>   arch/arm64/kvm/hyp/switch.c      | 3 ---
>   2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 715d395ef45b..656deeb17bf2 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -79,9 +79,9 @@
>    */
>   #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
>   			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
> -			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
> +			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | \
> +			 HCR_FMO | HCR_IMO)
>   #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
> -#define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
>   #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
>   
>   /* TCR_EL2 Registers bits */
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 71700ecee308..f6189d08753e 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -167,8 +167,6 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
>   		__vgic_v3_save_state(vcpu);
>   	else
>   		__vgic_v2_save_state(vcpu);
> -
> -	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
>   }
>   
>   static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
> @@ -176,7 +174,6 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
>   	u64 val;
>   
>   	val = read_sysreg(hcr_el2);
> -	val |= 	HCR_INT_OVERRIDE;
>   	val |= vcpu->arch.irq_lines;
>   	write_sysreg(val, hcr_el2);
>   
> 

Cheers,

-- 
Julien Grall
