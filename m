From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 05/18] arm/arm64: KVM: Add PSCI_VERSION helper
Date: Fri, 2 Feb 2018 13:33:14 +0100
Message-ID: <20180202123314.GH21802@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180201114657.7323-6-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Jon Masters <jcm@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>, Jayachandran C <jnair@caviumnetworks.com>, Hanjun Guo <guohanjun@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 01, 2018 at 11:46:44AM +0000, Marc Zyngier wrote:
> As we're about to trigger a PSCI version explosion, it doesn't
> hurt to introduce a PSCI_VERSION helper that is going to be
> used everywhere.
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_psci.h    | 6 ++++--
>  include/uapi/linux/psci.h | 3 +++
>  virt/kvm/arm/psci.c       | 4 +---
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 2042bb909474..5659343580a3 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -18,8 +18,10 @@
>  #ifndef __KVM_ARM_PSCI_H__
>  #define __KVM_ARM_PSCI_H__
>  
> -#define KVM_ARM_PSCI_0_1	1
> -#define KVM_ARM_PSCI_0_2	2
> +#include <uapi/linux/psci.h>
> +
> +#define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
> +#define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
>  
>  int kvm_psci_version(struct kvm_vcpu *vcpu);
>  int kvm_psci_call(struct kvm_vcpu *vcpu);
> diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
> index 760e52a9640f..b3bcabe380da 100644
> --- a/include/uapi/linux/psci.h
> +++ b/include/uapi/linux/psci.h
> @@ -88,6 +88,9 @@
>  		(((ver) & PSCI_VERSION_MAJOR_MASK) >> PSCI_VERSION_MAJOR_SHIFT)
>  #define PSCI_VERSION_MINOR(ver)			\
>  		((ver) & PSCI_VERSION_MINOR_MASK)
> +#define PSCI_VERSION(maj, min)						\
> +	((((maj) << PSCI_VERSION_MAJOR_SHIFT) & PSCI_VERSION_MAJOR_MASK) | \
> +	 ((min) & PSCI_VERSION_MINOR_MASK))
>  
>  /* PSCI features decoding (>=1.0) */
>  #define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT	1
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index b322e46fd142..999f94d6bb98 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -25,8 +25,6 @@
>  
>  #include <kvm/arm_psci.h>
>  
> -#include <uapi/linux/psci.h>
> -
>  /*
>   * This is an implementation of the Power State Coordination Interface
>   * as described in ARM document number ARM DEN 0022A.
> @@ -222,7 +220,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>  		 * Bits[31:16] = Major Version = 0
>  		 * Bits[15:0] = Minor Version = 2
>  		 */
> -		val = 2;
> +		val = KVM_ARM_PSCI_0_2;
>  		break;
>  	case PSCI_0_2_FN_CPU_SUSPEND:
>  	case PSCI_0_2_FN64_CPU_SUSPEND:
> -- 
> 2.14.2
> 
