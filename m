Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B78DC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB4256137E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DB4256137E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ACDA4B0C5;
	Wed, 29 Sep 2021 03:12:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UIEW+msI+Qgf; Wed, 29 Sep 2021 03:12:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF464B13D;
	Wed, 29 Sep 2021 03:12:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 023FB4B0C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:28:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W0lSZWv3sFSE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 17:28:43 -0400 (EDT)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6848949F5F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:28:43 -0400 (EDT)
Received: by mail-pg1-f175.google.com with SMTP id n18so411867pgm.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=sgkqKqZf4QJoBijGu0IXklrb1nmzgsBtxZkYg5n9zxE=;
 b=J/EJ4mMJ3ZLZAbmeRAlX5LJfvMsNbbDSladhViolpZyY0+1iztMVpzcxSEAQeDq6Hb
 mvyL2HfTQknNFziPx2O/NaUg7lqWP2HXc6y9XjS+BMrWjIfCXVGhTl5tNNoD4iAKY8bs
 k5sJA3mLJxJfUZGqwHYVmudwHI2nlGY2BFaHOZKX9v+6isMjYS7zBZKnExN1gc8MNuJt
 31wt0QcrsYOB0p0OgRXkcoXO2xkePImj2IZEz4V8Fs50DasN0tCQTs2sJreXzyfRTFBI
 +cwtlvA0XsUCHLC26wA9+4sb2c0+wQTzSqiwHhjMedUUFArmYQNW9SEoQocvPXt33XKM
 cK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sgkqKqZf4QJoBijGu0IXklrb1nmzgsBtxZkYg5n9zxE=;
 b=eOJAH/4m8+FbazwxcRuYLSVRP8G9U2FXM4u06+UACHmu7fcokcniTAAELLsCWnaL7n
 r1hM7967QH+lOqdFgWc4YH84yKLUxQ2sRVRYfXTvTUKB3hflZsn8bN2bTHE1j0jgMgHF
 Jr/Uh/vXjhq7+W0OOhPRA4q2flymu43emQ6XL5k0nMy/jn9ZxrLOwnRQkKak+CFJlwzy
 FdTsKn2hhznPd4s1JnCp8yZ8HjIjfChcEaSfpL0seukdcAjPmq+wRJxgOfUKdwznak1e
 F2NiEkZx5S2L0ksD0zfdVbuFQdVdXsiaXiV8UsYdUwz2WyzvzI8ceWttIx54I54kB7de
 Fraw==
X-Gm-Message-State: AOAM532s+r2rSFGTVq9b6eeVlRQoZ+8RnEjs99ykXkfjkRzEg8CfS8hQ
 DCPR6FMOZPhPzO9GwZwTRJkbXA==
X-Google-Smtp-Source: ABdhPJyoYpfDFNYnSLw/O+H75z/7mXjFXxNDN9u9o430xttDbGkEBLyYdUk2WBhhjvuPbCzyN4dRVg==
X-Received: by 2002:a63:dd56:: with SMTP id g22mr6402024pgj.38.1632864522226; 
 Tue, 28 Sep 2021 14:28:42 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id c22sm68864pja.10.2021.09.28.14.28.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 14:28:41 -0700 (PDT)
Date: Tue, 28 Sep 2021 21:28:37 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 06/14] KVM: Drop obsolete kvm_arch_vcpu_block_finish()
Message-ID: <YVOJBVTlspSAh3ZL@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-7-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-7-seanjc@google.com>
X-Mailman-Approved-At: Wed, 29 Sep 2021 03:12:40 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Sep 24, 2021 at 05:55:20PM -0700, Sean Christopherson wrote:
> Drop kvm_arch_vcpu_block_finish() now that all arch implementations are
> nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/arm64/include/asm/kvm_host.h   | 1 -
>  arch/mips/include/asm/kvm_host.h    | 1 -
>  arch/powerpc/include/asm/kvm_host.h | 1 -
>  arch/s390/include/asm/kvm_host.h    | 2 --
>  arch/s390/kvm/kvm-s390.c            | 5 -----
>  arch/x86/include/asm/kvm_host.h     | 2 --
>  virt/kvm/kvm_main.c                 | 1 -
>  7 files changed, 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..4e0ad0fff540 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -716,7 +716,6 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
>  void kvm_arm_init_debug(void);
>  void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 696f6b009377..72b90d45a46e 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -897,7 +897,6 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>  int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 59cb38b04ede..8a84448d77a6 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -864,6 +864,5 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_exit(void) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
>  #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..a22c9266ea05 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1010,6 +1010,4 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
> -void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu);
> -
>  #endif
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 08ed68639a21..17fabb260c35 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5080,11 +5080,6 @@ static inline unsigned long nonhyp_mask(int i)
>  	return 0x0000ffffffffffffUL >> (nonhyp_fai << 4);
>  }
>  
> -void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
> -{
> -
> -}
> -
>  static int __init kvm_s390_init(void)
>  {
>  	int i;
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1e0e909b98b2..4e8c21083bdb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1916,8 +1916,6 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  	static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
>  }
>  
> -static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> -
>  static inline int kvm_cpu_get_apicid(int mps_cpu)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2ba22b68af3b..2015a1f532ce 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3301,7 +3301,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	}
>  
>  	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> -	kvm_arch_vcpu_block_finish(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_block);
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
