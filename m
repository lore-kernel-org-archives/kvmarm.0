From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v8 2/5] arm64: KVM: encapsulate kvm_cpu_context in
 kvm_host_data
Date: Wed, 12 Dec 2018 10:37:54 +0000
Message-ID: <c31a1e2b-511a-4441-1fb2-8bf32691656f@arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-3-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D8864A2BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:37:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PmaeyBLYmMLO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 05:37:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4DFD4A1DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:37:57 -0500 (EST)
In-Reply-To: <1544610573-28446-3-git-send-email-andrew.murray@arm.com>
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
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 12/12/2018 10:29, Andrew Murray wrote:
> The virt/arm core allocates a kvm_cpu_context_t percpu, at present this is
> a typedef to kvm_cpu_context and is used to store host cpu context. The
> kvm_cpu_context structure is also used elsewhere to hold vcpu context.
> In order to use the percpu to hold additional future host information we
> encapsulate kvm_cpu_context in a new structure and rename the typedef and
> percpu to match.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>   arch/arm/include/asm/kvm_host.h   |  8 ++++++--
>   arch/arm64/include/asm/kvm_asm.h  |  4 ++--
>   arch/arm64/include/asm/kvm_host.h | 15 ++++++++++-----
>   arch/arm64/kernel/asm-offsets.c   |  2 +-
>   virt/kvm/arm/arm.c                | 10 ++++++----
>   5 files changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 79906ce..71645ba 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -145,7 +145,11 @@ struct kvm_cpu_context {
>   	u32 cp15[NR_CP15_REGS];
>   };
>   
> -typedef struct kvm_cpu_context kvm_cpu_context_t;
> +struct kvm_host_data {
> +	struct kvm_cpu_context host_ctxt;
> +};
> +
> +typedef struct kvm_host_data kvm_host_data_t;
>   
>   struct kvm_vcpu_arch {
>   	struct kvm_cpu_context ctxt;
> @@ -163,7 +167,7 @@ struct kvm_vcpu_arch {
>   	struct kvm_vcpu_fault_info fault;
>   
>   	/* Host FP context */
> -	kvm_cpu_context_t *host_cpu_context;
> +	struct kvm_cpu_context *host_cpu_context;
>   
>   	/* VGIC state */
>   	struct vgic_cpu vgic_cpu;
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 102b5a5..6a9bfd4 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -102,12 +102,12 @@ extern u32 __init_stage2_translation(void);
>   .endm
>   
>   .macro get_host_ctxt reg, tmp
> -	hyp_adr_this_cpu \reg, kvm_host_cpu_state, \tmp
> +	hyp_adr_this_cpu \reg, kvm_host_data, \tmp
>   .endm
>   
>   .macro get_vcpu_ptr vcpu, ctxt
>   	get_host_ctxt \ctxt, \vcpu
> -	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
> +	ldr	\vcpu, [\ctxt, #HOST_DATA_VCPU]
>   	kern_hyp_va	\vcpu
>   .endm
>   
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1550192..1d3ca91 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -205,7 +205,12 @@ struct kvm_cpu_context {
>   	struct kvm_vcpu *__hyp_running_vcpu;
>   };
>   
> -typedef struct kvm_cpu_context kvm_cpu_context_t;
> +struct kvm_host_data {
> +	struct kvm_cpu_context host_ctxt;
> +	struct kvm_pmu_events pmu_events;
> +};
> +

Unfortunately this would fail to build as we don't have the kvm_pmu_events
defined in this patch and will break the git bisects.

Otherwise looks good to me.


Cheers
Suzuki
