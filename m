From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 2/4] arm64: KVM: add accessors to track guest/host
 only counters
Date: Mon, 3 Dec 2018 14:31:14 +0000
Message-ID: <20181203143114.GA26831@arm.com>
References: <1542885950-23816-3-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E91B74A2BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 09:30:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ajRTECAgLhw4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 09:30:55 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DF814A214
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 09:30:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1542885950-23816-3-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 22, 2018 at 11:25:48AM +0000, Andrew Murray wrote:
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
> index 1550192..4a828eb 100644
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
> +static inline void kvm_clr_set_host_pmu_events(u32 clr, u32 set)
> +{
> +	kvm_cpu_context_t *ctx = this_cpu_ptr(&kvm_host_cpu_state);
> +
> +	ctx->events_host_only &= ~clr;
> +	ctx->events_host_only |= set;
> +}

Do you actually need this clr/set function, or can you just use the
facilities provided by bitfield.h at the callsites?

Will
