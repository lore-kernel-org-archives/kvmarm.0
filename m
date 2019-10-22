Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE6FCA9EA0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 11:44:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81061207FC
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 11:44:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81061207FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E30F4A997;
	Tue, 22 Oct 2019 07:44:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l2YSj65LC2GR; Tue, 22 Oct 2019 07:44:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82AC4A972;
	Tue, 22 Oct 2019 07:44:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2FAC4A96E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:44:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EFiovyWNml-c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 07:44:04 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 628AB4A968
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:44:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09D031576;
 Tue, 22 Oct 2019 04:43:44 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 900613F71F;
 Tue, 22 Oct 2019 04:43:43 -0700 (PDT)
Date: Tue, 22 Oct 2019 13:43:42 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 42/45] KVM: arm64: Free sve_state via arm specific hook
Message-ID: <20191022114342.GB2652@e113682-lin.lund.arm.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
 <20191022015925.31916-43-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191022015925.31916-43-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 James Hogan <jhogan@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Mon, Oct 21, 2019 at 06:59:22PM -0700, Sean Christopherson wrote:
> Add an arm specific hook to free the arm64-only sve_state.  Doing so
> eliminates the last functional code from kvm_arch_vcpu_uninit() across
> all architectures and paves the way for removing kvm_arch_vcpu_init()
> and kvm_arch_vcpu_uninit() entirely.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 1 +
>  arch/arm64/include/asm/kvm_host.h | 1 +
>  arch/arm64/kvm/reset.c            | 5 +++++
>  virt/kvm/arm/arm.c                | 2 ++
>  4 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 8a37c8e89777..cc414de5acd3 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -333,6 +333,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> +static inline int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu) {}
>  
>  static inline void kvm_arm_init_debug(void) {}
>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f656169db8c3..92d7c384a4ed 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -52,6 +52,7 @@ int kvm_arm_init_sve(void);
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> +int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
>  int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
>  void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index f4a8ae918827..98abc4278f42 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -205,6 +205,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>  }
>  
>  void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
> +{
> +
> +}
> +
> +int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	kfree(vcpu->arch.sve_state);
>  }

nit: warning: control reaches end of non-void function

> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index aac4e5a1a521..b38088415cde 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -298,6 +298,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	kvm_mmu_free_memory_caches(vcpu);
>  	kvm_timer_vcpu_terminate(vcpu);
>  	kvm_pmu_vcpu_destroy(vcpu);
> +
> +	kvm_arm_vcpu_destroy(vcpu);
>  }
>  
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> -- 
> 2.22.0
> 
> _______________________________________________

Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
