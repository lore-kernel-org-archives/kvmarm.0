Received: from out-66.mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C242BA48
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 15:33:47 +0000 (UTC)
Message-ID: <b0d83c9d-01f4-2432-c685-6b81379bbbe5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1692027225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2z83Z7AAlfg2aJmhEVCpilSC/vkY0HO8xW/4lgpjv/I=;
	b=bh26xqCJH4JPI1/0xJSRsrxA7Gf/Pg06czxpzN3s/CEZoikKcOtNazjG6s0RK6ZQj/K+Hg
	7F1evmLOI7wpOcnW5Ok+eO4ohp1c9hER8Sb+o+o+ThQsMcUA4g9OzLP4iHSBIUElQDS9Dq
	7h4S5M7ecM3YvCCjR3RYg8qQfgOJ/+o=
Date: Mon, 14 Aug 2023 23:33:14 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH -next] KVM: arm64: Remove unused declarations
Content-Language: en-US
To: Yue Haibing <yuehaibing@huawei.com>, maz@kernel.org,
 oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 gshan@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20230814140636.45988-1-yuehaibing@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20230814140636.45988-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2023/8/14 22:06, Yue Haibing wrote:
> Commit 53692908b0f5 ("KVM: arm/arm64: vgic: Fix source vcpu issues for GICv2 SGI")
> removed vgic_v2_set_npie()/vgic_v3_set_npie() but not the declarations.
> Commit 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early") left behind
> kvm_arm_vcpu_ptrauth_trap(), remove it.
> Commit 2a0c343386ae ("KVM: arm64: Initialize trap registers for protected VMs")
> declared but never implemented kvm_init_protected_traps() and
> commit cf5d318865e2 ("arm/arm64: KVM: Turn off vcpus on PSCI shutdown/reboot")
> declared but never implemented force_vm_exit().
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 6 ------
>  arch/arm64/kvm/vgic/vgic.h        | 2 --
>  2 files changed, 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d7b1403a3fb2..7dbcee57f565 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -967,8 +967,6 @@ void kvm_arm_resume_guest(struct kvm *kvm);
>  #define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
>  #endif /* __KVM_NVHE_HYPERVISOR__ */
>  
> -void force_vm_exit(const cpumask_t *mask);
> -
>  int handle_exit(struct kvm_vcpu *vcpu, int exception_index);
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index);
>  
> @@ -1049,8 +1047,6 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
>  	return cpus_have_const_cap(ARM64_SPECTRE_V3A);
>  }
>  
> -void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
> -
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  
> @@ -1118,8 +1114,6 @@ static inline bool kvm_vm_is_protected(struct kvm *kvm)
>  	return false;
>  }
>  
> -void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
> -
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index f9923beedd27..0ab09b0d4440 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -199,7 +199,6 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
>  void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
> -void vgic_v2_set_npie(struct kvm_vcpu *vcpu);
>  int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
>  int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
> @@ -233,7 +232,6 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
> -void vgic_v3_set_npie(struct kvm_vcpu *vcpu);
>  void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v3_enable(struct kvm_vcpu *vcpu);

Looks good,

Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
