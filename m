From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v5 24/26] KVM: arm64: Add a capabillity to advertise SVE
 support
Date: Fri, 22 Feb 2019 09:10:46 +0000
Message-ID: <e1e048ff-dbe0-34fe-3318-d9c9ecbccf0e@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-25-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B6A4A2E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 04:10:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id haqGxszu1IaN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 04:10:57 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6B74A2AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 04:10:57 -0500 (EST)
In-Reply-To: <1550519559-15915-25-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 18/02/2019 19:52, Dave Martin wrote:
> To provide a uniform way to check for KVM SVE support amongst other
> features, this patch adds a suitable capability KVM_CAP_ARM_SVE,
> and reports it as present when SVE is available.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/kvm/reset.c   | 8 ++++++++
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index e67cd2e..f636b34 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -35,6 +35,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/virt.h>
>  
>  /* Maximum phys_shift supported for any VM on this host */
>  static u32 kvm_ipa_limit;
> @@ -93,6 +94,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_VM_IPA_SIZE:
>  		r = kvm_ipa_limit;
>  		break;
> +	case KVM_CAP_ARM_SVE:
> +		r = system_supports_sve();
> +		break;
>  	default:
>  		r = 0;
>  	}
> @@ -105,6 +109,10 @@ static int kvm_reset_sve(struct kvm_vcpu *vcpu)
>  	if (!system_supports_sve())
>  		return -EINVAL;
>  
> +	/* Verify that KVM startup enforced this when SVE was detected: */
> +	if (WARN_ON(!has_vhe()))
> +		return -EINVAL;

I'm wondering, wouldn't it make more sense to check for this when
userland tries to set KVM_ARM_VCPU_SVE?

Otherwise:

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Cheers,

-- 
Julien Thierry
