From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 03/11] KVM: arm64: Change hyp_panic()s dependency on
 tpidr_el2
Date: Tue, 6 Jun 2017 21:45:25 +0200
Message-ID: <20170606194525.GK9464@cbox>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170515174400.29735-4-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF7A40C55
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 15:41:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vsL7ONkmqiOq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 15:41:33 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5766408EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 15:41:33 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id 7so104518429wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 12:45:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170515174400.29735-4-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 15, 2017 at 06:43:51PM +0100, James Morse wrote:
> KVM calls hyp_panic() when anything unexpected happens. This may occur
> while a guest owns the EL1 registers. KVM stashes the vcpu pointer in
> tpidr_el2, which it uses to find the host context in order to restore
> the host EL1 registers before parachuting into the host's panic().
> 
> The host context is a struct kvm_cpu_context allocated in the per-cpu
> area, and mapped to hyp. Given the per-cpu offset for this CPU, this is
> easy to find. Change hyp_panic() to take a pointer to the
> struct kvm_cpu_context. Wrap these calls with an asm function that
> retrieves the struct kvm_cpu_context from the host's per-cpu area.
> 
> Copy the per-cpu offset from the hosts tpidr_el1 into tpidr_el2 during
> kvm init. (Later patches will make this unnecessary for VHE hosts)
> 
> We print out the vcpu pointer as part of the panic message. Add a back
> reference to the 'running vcpu' in the host cpu context to preserve this.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/hyp/hyp-entry.S    |  7 +++++++
>  arch/arm64/kvm/hyp/s2-setup.c     |  3 +++
>  arch/arm64/kvm/hyp/switch.c       | 25 +++++++++++++------------
>  4 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5e19165c5fa8..1407bfc81e9e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -188,6 +188,8 @@ struct kvm_cpu_context {
>  		u64 sys_regs[NR_SYS_REGS];
>  		u32 copro[NR_COPRO_REGS];
>  	};
> +
> +	struct kvm_vcpu *__hyp_running_vcpu;
>  };
>  
>  typedef struct kvm_cpu_context kvm_cpu_context_t;
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index fce7cc507e0a..0f83e7e402ad 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -163,6 +163,13 @@ ENTRY(__hyp_do_panic)
>  	eret
>  ENDPROC(__hyp_do_panic)
>  
> +ENTRY(__hyp_panic)
> +	ldr	x0, =kvm_host_cpu_state

Why is this guaranteed to give us a valid EL2 address?

> +	mrs	x1, tpidr_el2
> +	add	x0, x0, x1
> +	b	hyp_panic
> +ENDPROC(__hyp_panic)
> +

Thanks,
-Christoffer
