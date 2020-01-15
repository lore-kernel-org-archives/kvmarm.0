Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F97C32771
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 18:11:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E31CA2187F
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 18:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OCogq7LA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E31CA2187F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19DA24B13C;
	Wed, 15 Jan 2020 13:10:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1VEiKARUX6PA; Wed, 15 Jan 2020 13:10:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 832174B15E;
	Wed, 15 Jan 2020 13:10:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C7F74B14D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 13:10:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jOi25pDWUrg1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 13:10:47 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 678D64B13C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 13:10:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579111847;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=F3aO5PkILN1crhSTaPEdvT5WmQo42DjPqkjHlLcxuT4=;
 b=OCogq7LAO9bP3QkZlbNK7oBhw96PsyGCBIN1yaz7G8zGL7iML5cvvPndCfSrCex4FGvmYO
 wYKNv20mwMddC1Ck0Or9zu9feUWYxo+aEPM6gDZebtZMMWRVkUHbgdM9ujlYqJ7rWbIACH
 SppltAnQMUCie8xtUntnU0Q/U9uaNk8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-NPHwe2oWO_eyHsGFCTBgkw-1; Wed, 15 Jan 2020 13:10:45 -0500
Received: by mail-wr1-f72.google.com with SMTP id b13so8251757wrx.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 10:10:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=F3aO5PkILN1crhSTaPEdvT5WmQo42DjPqkjHlLcxuT4=;
 b=fFnRujjA394ddmayFFGI7yvARUggdVmRGyioVk6TW6o1doRlBnWKZ8Jxg8Jm6TRQun
 RCjVeqoGIXIHpdP7WWvRPW160+11GFUd8WfcLcl2FZsl/lkQclTVYiPPRFSFWZMjEHmo
 iCfOHnuvZgsAQv3y+eg/FZpyB/ahEnxXhF3OEEC0CckhzWBpyE0785zr4a/NTOfUpamX
 tM9d5M7+fzMeD9n2+m3orCcRLqfPilNkzgBoetW79iau3V2mrKlftAPc05C2VPNrcPQ/
 6Nhl6U6XslAdXZsLCIRqahlFABoQa14ijrKLOSMzihMNkEQvIOdARLJRN7IxeQ7tU8Qv
 jEMQ==
X-Gm-Message-State: APjAAAWg3+rVxJtgOEDFCaJ/JjzBcP60rAQo00AwRitopNAH/AKwEf9d
 RKUwY2YhxT8Me+8J48T/xtKsqxdlNGFSd9rJeWMl0z57PEOGMtPF2nb7FV4fvc/iKl+a/cIf4/7
 6YRCXKoVcyPtxjUXOrhhtWv7r
X-Received: by 2002:adf:cd0a:: with SMTP id w10mr31982365wrm.107.1579111843296; 
 Wed, 15 Jan 2020 10:10:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8x3DkVeTz18rgSm4jyxO1ipgrVjTCJXipQWmAHuXPHQsuhP0bjqS5Dn7vgMZER6uxOHdYzQ==
X-Received: by 2002:adf:cd0a:: with SMTP id w10mr31982336wrm.107.1579111842954; 
 Wed, 15 Jan 2020 10:10:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a?
 ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
 by smtp.gmail.com with ESMTPSA id x11sm26263134wre.68.2020.01.15.10.10.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 15 Jan 2020 10:10:41 -0800 (PST)
Subject: Re: [PATCH 1/7] KVM: Pass mmu_notifier_range down to
 kvm_unmap_hva_range()
To: Marc Zyngier <maz@kernel.org>
References: <20191213182503.14460-1-maz@kernel.org>
 <20191213182503.14460-2-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0e2290e4-287f-f3fc-98e0-082056c91511@redhat.com>
Date: Wed, 15 Jan 2020 19:10:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213182503.14460-2-maz@kernel.org>
Content-Language: en-US
X-MC-Unique: NPHwe2oWO_eyHsGFCTBgkw-1
X-Mimecast-Spam-Score: 0
Cc: kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paul Mackerras <paulus@ozlabs.org>, linux-arm-kernel@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On 13/12/19 19:24, Marc Zyngier wrote:
> kvm_unmap_hva_range() is currently passed both start and end
> fields from the mmu_notifier_range structure. As this struct
> now contains important information about the reason of the
> unmap (the event field), replace the start/end parameters
> with the range struct, and update all architectures.
> 
> No functionnal change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm/include/asm/kvm_host.h     | 2 +-
>  arch/arm64/include/asm/kvm_host.h   | 2 +-
>  arch/mips/include/asm/kvm_host.h    | 2 +-
>  arch/mips/kvm/mmu.c                 | 6 ++++--
>  arch/powerpc/include/asm/kvm_host.h | 2 +-
>  arch/powerpc/kvm/book3s.c           | 5 +++--
>  arch/powerpc/kvm/e500_mmu_host.c    | 4 ++--
>  arch/x86/include/asm/kvm_host.h     | 3 ++-
>  arch/x86/kvm/mmu/mmu.c              | 5 +++--
>  arch/x86/kvm/x86.c                  | 4 ++--
>  include/linux/kvm_host.h            | 2 +-
>  virt/kvm/arm/mmu.c                  | 8 ++++----
>  virt/kvm/kvm_main.c                 | 7 +++----
>  13 files changed, 28 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 556cd818eccf..621c71594499 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -276,7 +276,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  int kvm_unmap_hva_range(struct kvm *kvm,
> -			unsigned long start, unsigned long end);
> +			const struct mmu_notifier_range *range);
>  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>  
>  unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c61260cf63c5..dd850f5e81e3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -441,7 +441,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  int kvm_unmap_hva_range(struct kvm *kvm,
> -			unsigned long start, unsigned long end);
> +			const struct mmu_notifier_range *range);
>  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
>  int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 41204a49cf95..0ed065870f1b 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -935,7 +935,7 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
>  
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  int kvm_unmap_hva_range(struct kvm *kvm,
> -			unsigned long start, unsigned long end);
> +			const struct mmu_notifier_range *range);
>  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
>  int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 7dad7a293eae..32ef868258b9 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -518,9 +518,11 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
>  	return 1;
>  }
>  
> -int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
> +int kvm_unmap_hva_range(struct kvm *kvm,
> +			const struct mmu_notifier_range *range)
>  {
> -	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
> +	handle_hva_to_gpa(kvm, range->start, range->end,
> +			  &kvm_unmap_hva_handler, NULL);
>  
>  	kvm_mips_callbacks->flush_shadow_all(kvm);
>  	return 0;
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 0a398f2321c2..8cef585e0abe 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -58,7 +58,7 @@
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  
>  extern int kvm_unmap_hva_range(struct kvm *kvm,
> -			       unsigned long start, unsigned long end);
> +			       const struct mmu_notifier_range *range);
>  extern int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
>  extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  extern int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 58a59ee998e2..a1529a0dd656 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -842,9 +842,10 @@ void kvmppc_core_commit_memory_region(struct kvm *kvm,
>  	kvm->arch.kvm_ops->commit_memory_region(kvm, mem, old, new, change);
>  }
>  
> -int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
> +int kvm_unmap_hva_range(struct kvm *kvm,
> +			const struct mmu_notifier_range *range)
>  {
> -	return kvm->arch.kvm_ops->unmap_hva_range(kvm, start, end);
> +	return kvm->arch.kvm_ops->unmap_hva_range(kvm, range->start, range->end);
>  }
>  
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
> diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
> index 425d13806645..5a7211901063 100644
> --- a/arch/powerpc/kvm/e500_mmu_host.c
> +++ b/arch/powerpc/kvm/e500_mmu_host.c
> @@ -734,10 +734,10 @@ static int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
>  	return 0;
>  }
>  
> -int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
> +int kvm_unmap_hva_range(struct kvm *kvm, const struct mmu_notifier_range *range)
>  {
>  	/* kvm_unmap_hva flushes everything anyways */
> -	kvm_unmap_hva(kvm, start);
> +	kvm_unmap_hva(kvm, range->start);
>  
>  	return 0;
>  }
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b79cd6aa4075..c479fa845d72 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1569,7 +1569,8 @@ asmlinkage void kvm_spurious_fault(void);
>  	_ASM_EXTABLE(666b, 667b)
>  
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
> -int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
> +int kvm_unmap_hva_range(struct kvm *kvm,
> +			const struct mmu_notifier_range *range);
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
>  int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..86831be07c17 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2040,9 +2040,10 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
>  	return kvm_handle_hva_range(kvm, hva, hva + 1, data, handler);
>  }
>  
> -int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
> +int kvm_unmap_hva_range(struct kvm *kvm,
> +			const struct mmu_notifier_range *range);
>  {
> -	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> +	return kvm_handle_hva_range(kvm, range->start, range->end, 0, kvm_unmap_rmapp);
>  }
>  
>  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf917139de6b..c1a238f4ee35 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7942,7 +7942,7 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
>  }
>  
>  int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> -		unsigned long start, unsigned long end,
> +		const struct mmu_notifier_range *range,
>  		bool blockable)
>  {
>  	unsigned long apic_address;
> @@ -7952,7 +7952,7 @@ int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>  	 * Update it when it becomes invalid.
>  	 */
>  	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> -	if (start <= apic_address && apic_address < end)
> +	if (range->start <= apic_address && apic_address < range->end)
>  		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
>  
>  	return 0;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7ed1e2f8641e..d6e2ae2accc4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1391,7 +1391,7 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  #endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
>  
>  int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> -		unsigned long start, unsigned long end, bool blockable);
> +		const struct mmu_notifier_range *range, bool blockable);
>  
>  #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
>  int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 38b4c910b6c3..078e10c5650e 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -2035,14 +2035,14 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *dat
>  	return 0;
>  }
>  
> -int kvm_unmap_hva_range(struct kvm *kvm,
> -			unsigned long start, unsigned long end)
> +int kvm_unmap_hva_range(struct kvm *kvm, const struct mmu_notifier_range *range)
>  {
>  	if (!kvm->arch.pgd)
>  		return 0;
>  
> -	trace_kvm_unmap_hva_range(start, end);
> -	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
> +	trace_kvm_unmap_hva_range(range->start, range->end);
> +	handle_hva_to_gpa(kvm, range->start, range->end,
> +			  &kvm_unmap_hva_handler, NULL);
>  	return 0;
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 00268290dcbd..7c3665ad1035 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -158,7 +158,7 @@ static unsigned long long kvm_createvm_count;
>  static unsigned long long kvm_active_vms;
>  
>  __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> -		unsigned long start, unsigned long end, bool blockable)
> +		const struct mmu_notifier_range *range, bool blockable)
>  {
>  	return 0;
>  }
> @@ -415,7 +415,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  	 * count is also read inside the mmu_lock critical section.
>  	 */
>  	kvm->mmu_notifier_count++;
> -	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end);
> +	need_tlb_flush = kvm_unmap_hva_range(kvm, range);
>  	need_tlb_flush |= kvm->tlbs_dirty;
>  	/* we've to flush the tlb before the pages can be freed */
>  	if (need_tlb_flush)
> @@ -423,8 +423,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  
>  	spin_unlock(&kvm->mmu_lock);
>  
> -	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range->start,
> -					range->end,
> +	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range,
>  					mmu_notifier_range_blockable(range));
>  
>  	srcu_read_unlock(&kvm->srcu, idx);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
