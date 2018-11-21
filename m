From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 2/4] arm64: KVM: add accessors to track guest/host only
 counters
Date: Wed, 21 Nov 2018 16:04:03 +0000
Message-ID: <da549a51-9b85-f94c-07d6-91140c542ec7@arm.com>
References: <1542723322-42536-1-git-send-email-andrew.murray@arm.com>
 <1542723322-42536-3-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AFC64A2AE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 11:04:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id neWgXhx4ylSN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Nov 2018 11:04:07 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D50454A262
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 11:04:06 -0500 (EST)
In-Reply-To: <1542723322-42536-3-git-send-email-andrew.murray@arm.com>
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
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 20/11/2018 14:15, Andrew Murray wrote:
> In order to effeciently enable/disable guest/host only perf counters
> at guest entry/exit we add bitfields to kvm_cpu_context for guest and
> host only events as well as accessors for updating them.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1550192..b6f998b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -203,6 +203,8 @@ struct kvm_cpu_context {
>  	};
>  
>  	struct kvm_vcpu *__hyp_running_vcpu;
> +	u32 events_host_only;
> +	u32 events_guest_only;
>  };
>  
>  typedef struct kvm_cpu_context kvm_cpu_context_t;
> @@ -472,6 +474,24 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_arch_vcpu_run_map_fp(vcpu);
>  }
> +static inline void kvm_set_clr_host_pmu_events(u32 clr, u32 set)

nit: keep the arguments in an order that match the function name (saves
a lot of brain power...)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
