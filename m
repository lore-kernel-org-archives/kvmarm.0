From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v6 25/27] KVM: arm64: Add a capability to advertise SVE
 support
Date: Wed, 27 Mar 2019 15:16:25 +0000
Message-ID: <3af0f011-57f7-e429-9ce4-633b4b2f3b34@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <1553017938-710-26-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 397F74A32E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 11:16:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YGEicNY6uaSL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Mar 2019 11:16:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0824C4A319
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 11:16:31 -0400 (EDT)
In-Reply-To: <1553017938-710-26-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 19/03/2019 17:52, Dave Martin wrote:
> To provide a uniform way to check for KVM SVE support amongst other
> features, this patch adds a suitable capability KVM_CAP_ARM_SVE,
> and reports it as present when SVE is available.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Cheers,

Julien

> ---
> 
> Changes since v5:
> 
>  * [Julien Thierry] Strip out has_vhe() sanity-check, which wasn't in
>    the most logical place, and anyway doesn't really belong in this
>    patch.
> 
>    Moved to KVM: arm64/sve: Allow userspace to enable SVE for vcpus
>    instead.
> ---
>  arch/arm64/kvm/reset.c   | 3 +++
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 4f04dbf..180d7a5 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -98,6 +98,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_VM_IPA_SIZE:
>  		r = kvm_ipa_limit;
>  		break;
> +	case KVM_CAP_ARM_SVE:
> +		r = system_supports_sve();
> +		break;
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c3b8e7a..1d56444 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -988,6 +988,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_VM_IPA_SIZE 165
>  #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
>  #define KVM_CAP_HYPERV_CPUID 167
> +#define KVM_CAP_ARM_SVE 168
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> 

-- 
Julien Thierry
