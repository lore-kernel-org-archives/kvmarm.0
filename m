From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 04/16] arm/arm64: KVM: Add PSCI_VERSION helper
Date: Tue, 30 Jan 2018 13:15:00 +0000
Message-ID: <818aa8cd-9fa3-3234-297b-dea8540e1bb2@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129174559.1866-5-marc.zyngier@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/18 17:45, Marc Zyngier wrote:
> As we're about to trigger a PSCI version explosion, it doesn't
> hurt to introduce a PSCI_VERSION helper that is going to be
> used everywhere.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   include/kvm/arm_psci.h | 5 +++--
>   virt/kvm/arm/psci.c    | 2 +-
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 2042bb909474..3a408c846c09 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -18,8 +18,9 @@
>   #ifndef __KVM_ARM_PSCI_H__
>   #define __KVM_ARM_PSCI_H__
>   
> -#define KVM_ARM_PSCI_0_1	1
> -#define KVM_ARM_PSCI_0_2	2
> +#define PSCI_VERSION(x,y)	((((x) & 0x7fff) << 16) | ((y) & 0xffff))

I see virt/kvm/arm/psci.c already pulls in uapi/linux/psci.h, so maybe 
this guy could go in there alongside the other PSCI_VERSION_* gubbins?

Robin.

> +#define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
> +#define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
>   
>   int kvm_psci_version(struct kvm_vcpu *vcpu);
>   int kvm_psci_call(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index b322e46fd142..c00bb324e14e 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -222,7 +222,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>   		 * Bits[31:16] = Major Version = 0
>   		 * Bits[15:0] = Minor Version = 2
>   		 */
> -		val = 2;
> +		val = KVM_ARM_PSCI_0_2;
>   		break;
>   	case PSCI_0_2_FN_CPU_SUSPEND:
>   	case PSCI_0_2_FN64_CPU_SUSPEND:
> 
