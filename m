Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE86C959
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 20:09:56 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9274B4B3;
	Thu, 23 Mar 2023 13:10:39 -0700 (PDT)
Received: from [192.168.122.164] (U203867.austin.arm.com [10.118.30.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6472D3F6C4;
	Thu, 23 Mar 2023 13:09:55 -0700 (PDT)
Message-ID: <5b355d9f-0191-2631-9745-5ed2d10af0e1@arm.com>
Date: Thu, 23 Mar 2023 15:09:54 -0500
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 2/4] KVM: arm64: Avoid lock inversion when setting the
 VM register width
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>
References: <20230316211412.2651555-1-oliver.upton@linux.dev>
 <20230316211412.2651555-3-oliver.upton@linux.dev>
Content-Language: en-US
From: Jeremy Linton <jeremy.linton@arm.com>
In-Reply-To: <20230316211412.2651555-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/16/23 16:14, Oliver Upton wrote:
> kvm->lock must be taken outside of the vcpu->mutex. Of course, the
> locking documentation for KVM makes this abundantly clear. Nonetheless,
> the locking order in KVM/arm64 has been wrong for quite a while; we
> acquire the kvm->lock while holding the vcpu->mutex all over the shop.
> 
> All was seemingly fine until commit 42a90008f890 ("KVM: Ensure lockdep
> knows about kvm->lock vs. vcpu->mutex ordering rule") caught us with our
> pants down, leading to lockdep barfing:

Thanks for looking at this! It had a bit of fuzz applying to -rc3, did I 
miss a required patch?

This patch makes the lockdep warnings I was seeing go away but I'm 
seeing similar lockdep problem while running the kvm kselftests. In 
particular I think it was "selftests: kvm: debug-exceptions" which threw 
the warning.

So, i'm not sure its completely fixed. I ran the previous one a couple 
weeks back before you respun it, and IIRC didn't see any errors.






> 
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   6.2.0-rc7+ #19 Not tainted
>   ------------------------------------------------------
>   qemu-system-aar/859 is trying to acquire lock:
>   ffff5aa69269eba0 (&host_kvm->lock){+.+.}-{3:3}, at: kvm_reset_vcpu+0x34/0x274
> 
>   but task is already holding lock:
>   ffff5aa68768c0b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x8c/0xba0
> 
>   which lock already depends on the new lock.
> 
> Add a dedicated lock to serialize writes to VM-scoped configuration from
> the context of a vCPU. Protect the register width flags with the new
> lock, thus avoiding the need to grab the kvm->lock while holding
> vcpu->mutex in kvm_reset_vcpu().
> 
> Reported-by: Jeremy Linton <jeremy.linton@arm.com>
> Link: https://lore.kernel.org/kvmarm/f6452cdd-65ff-34b8-bab0-5c06416da5f6@arm.com/
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_host.h |  3 +++
>   arch/arm64/kvm/arm.c              | 18 ++++++++++++++++++
>   arch/arm64/kvm/reset.c            |  6 +++---
>   3 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 917586237a4d..1f4b9708a775 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -185,6 +185,9 @@ struct kvm_protected_vm {
>   };
>   
>   struct kvm_arch {
> +	/* Protects VM-scoped configuration data */
> +	struct mutex config_lock;
> +
>   	struct kvm_s2_mmu mmu;
>   
>   	/* VTCR_EL2 value for this VM */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 731a78f85915..1478bec52767 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -128,6 +128,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   {
>   	int ret;
>   
> +	mutex_init(&kvm->arch.config_lock);
> +
> +#ifdef CONFIG_LOCKDEP
> +	/* Clue in lockdep that the config_lock must be taken inside kvm->lock */
> +	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.config_lock);
> +	mutex_unlock(&kvm->arch.config_lock);
> +	mutex_unlock(&kvm->lock);
> +#endif
> +
>   	ret = kvm_share_hyp(kvm, kvm + 1);
>   	if (ret)
>   		return ret;
> @@ -328,6 +338,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   	spin_lock_init(&vcpu->arch.mp_state_lock);
>   
> +#ifdef CONFIG_LOCKDEP
> +	/* Inform lockdep that the config_lock is acquired after vcpu->mutex */
> +	mutex_lock(&vcpu->mutex);
> +	mutex_lock(&vcpu->kvm->arch.config_lock);
> +	mutex_unlock(&vcpu->kvm->arch.config_lock);
> +	mutex_unlock(&vcpu->mutex);
> +#endif
> +
>   	/* Force users to call KVM_ARM_VCPU_INIT */
>   	vcpu->arch.target = -1;
>   	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index b874ec6a37c1..ee445a7a1ef8 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -205,7 +205,7 @@ static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
>   
>   	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
>   
> -	lockdep_assert_held(&kvm->lock);
> +	lockdep_assert_held(&kvm->arch.config_lock);
>   
>   	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
>   		/*
> @@ -262,9 +262,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   	bool loaded;
>   	u32 pstate;
>   
> -	mutex_lock(&vcpu->kvm->lock);
> +	mutex_lock(&vcpu->kvm->arch.config_lock);
>   	ret = kvm_set_vm_width(vcpu);
> -	mutex_unlock(&vcpu->kvm->lock);
> +	mutex_unlock(&vcpu->kvm->arch.config_lock);
>   
>   	if (ret)
>   		return ret;

