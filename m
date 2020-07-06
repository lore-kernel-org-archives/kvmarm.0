Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D79C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 01:09:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EDCE20715
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 01:09:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EDCE20715
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B19644B2E1;
	Sun,  5 Jul 2020 21:09:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bvs9xcb2GeGB; Sun,  5 Jul 2020 21:09:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EE284B2E6;
	Sun,  5 Jul 2020 21:09:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1570E4B2E1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 21:09:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wfrCnspfVDQa for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2020 21:09:00 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BE6C4B2D6
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 21:09:00 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id ECC5E4AE219132BC0A92;
 Mon,  6 Jul 2020 09:08:54 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 6 Jul 2020 09:08:45 +0800
Subject: Re: [PATCH v2 6/8] KVM: arm64: Add KVM_CAP_ARM_HW_DIRTY_LOG capability
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
 <20200702135556.36896-7-zhukeqian1@huawei.com>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <5e6bb7ef-0f6a-d326-e386-ff87a671a39b@huawei.com>
Date: Mon, 6 Jul 2020 09:08:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200702135556.36896-7-zhukeqian1@huawei.com>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Steven Price <steven.price@arm.com>, liangpeng10@huawei.com,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On 2020/7/2 21:55, Keqian Zhu wrote:
> For that using arm64 DBM to log dirty pages has the side effect
> of long time dirty log sync, we should give userspace opportunity
> to enable or disable this feature, to realize some policy.
> 
> This feature is disabled by default.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/arm.c              | 35 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/mmu.c              | 22 +++++++++++++++++++
>  arch/arm64/kvm/reset.c            |  5 +++++
>  include/uapi/linux/kvm.h          |  1 +
>  tools/include/uapi/linux/kvm.h    |  1 +
>  6 files changed, 65 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 86b9c210ba43..69a5317c7049 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -481,6 +481,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
>  void force_vm_exit(const cpumask_t *mask);
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>  void kvm_mmu_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
> +void kvm_mmu_sync_dirty_log_all(struct kvm *kvm);
>  
>  int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		int exception_index);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fefa5406e037..9e3f765d5467 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -78,6 +78,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			    struct kvm_enable_cap *cap)
>  {
>  	int r;
> +#ifdef CONFIG_ARM64_HW_AFDBM
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +	bool enable_hw_dirty_log;
> +#endif
>  
>  	if (cap->flags)
>  		return -EINVAL;
> @@ -87,6 +92,36 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		kvm->arch.return_nisv_io_abort_to_user = true;
>  		break;
> +#ifdef CONFIG_ARM64_HW_AFDBM
> +	case KVM_CAP_ARM_HW_DIRTY_LOG:
> +		if (!arm_mmu_hw_dbm_supported() || (cap->args[0] & ~0x1))
> +			r = -EINVAL;
Miss "break" here :-( . Code is converted from "return -EINVAL".
> +
> +		enable_hw_dirty_log = !!(cap->args[0] & 0x1);
> +		if (!!(kvm->arch.vtcr & VTCR_EL2_HD) != enable_hw_dirty_log) {
> +			if (enable_hw_dirty_log)
> +				kvm->arch.vtcr |= VTCR_EL2_HD;
> +			else
> +				kvm->arch.vtcr &= ~VTCR_EL2_HD;
> +
> +			/*
> +			 * We should kick vcpus out of guest mode here to
> +			 * load new vtcr value to vtcr_el2 register when
> +			 * re-enter guest mode.
> +			 */
> +			kvm_for_each_vcpu(i, vcpu, kvm)
> +				kvm_vcpu_kick(vcpu);
> +
> +			if (!enable_hw_dirty_log) {
> +				mutex_lock(&kvm->slots_lock);
> +				kvm_mmu_sync_dirty_log_all(kvm);
> +				mutex_unlock(&kvm->slots_lock);
> +			}
> +		}
> +
> +		r = 0;
> +		break;
> +#endif
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index adfa62f1fced..1a48554accb0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2590,6 +2590,28 @@ void kvm_mmu_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  	spin_unlock(&kvm->mmu_lock);
>  	srcu_read_unlock(&kvm->srcu, srcu_idx);
>  }
> +
> +/**
> + * kvm_mmu_sync_dirty_log_all() - synchronize dirty log from PTEs for whole VM
> + * @kvm:	The KVM pointer
> + *
> + * Called with kvm->slots_lock mutex acquired
> + */
> +void kvm_mmu_sync_dirty_log_all(struct kvm *kvm)
> +{
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
> +	struct kvm_memory_slot *memslots = slots->memslots;
> +	struct kvm_memory_slot *memslot;
> +	int slot;
> +
> +	if (unlikely(!slots->used_slots))
> +		return;
> +
> +	for (slot = 0; slot < slots->used_slots; slot++) {
> +		memslot = &memslots[slot];
> +		kvm_mmu_sync_dirty_log(kvm, memslot);
> +	}
> +}
>  #endif /* CONFIG_ARM64_HW_AFDBM */
>  
>  void kvm_arch_commit_memory_region(struct kvm *kvm,
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index d3b209023727..a3be703dd54b 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -83,6 +83,11 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = has_vhe() && system_supports_address_auth() &&
>  				 system_supports_generic_auth();
>  		break;
> +#ifdef CONFIG_ARM64_HW_AFDBM
> +	case KVM_CAP_ARM_HW_DIRTY_LOG:
> +		r = arm_mmu_hw_dbm_supported();
> +		break;
> +#endif /* CONFIG_ARM64_HW_AFDBM */
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4fdf30316582..e0b12c43397b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
> +#define KVM_CAP_ARM_HW_DIRTY_LOG 184
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 4fdf30316582..e0b12c43397b 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
> +#define KVM_CAP_ARM_HW_DIRTY_LOG 184
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
