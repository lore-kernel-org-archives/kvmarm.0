Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35E6C2D0E4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 12:57:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 154072076E
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 12:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="I3OXYWhB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 154072076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EAE04B8F6;
	Mon, 23 Nov 2020 07:57:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3k4FWPK9eoYR; Mon, 23 Nov 2020 07:57:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0C54B93D;
	Mon, 23 Nov 2020 07:57:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB0C4B8F6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 07:57:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X0BvQPWeIaJG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 07:57:28 -0500 (EST)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F6EA4B8E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 07:57:28 -0500 (EST)
Received: by mail-oi1-f193.google.com with SMTP id o25so19560712oie.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 04:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=exUXNPUBqsurzs6TF2YvQJu6wWbhf9lKT2IejTuCk6o=;
 b=I3OXYWhBSA+1mdoW0bKXVxLM3nK8o5rwHvWB5g9l7IGc+bV7qkL5+PU4hJ7b7NgL8z
 FXYI1z+65RYwIeIpZTVYS7zvkmm8FodW0mkraqyTAQcvv1C6iR1dTMAlpQi9gviXsaSE
 e/DtN+e5rUzphZT3+t1qAQx0pPq6QFj6Y5tH5Hdqqy8kTsJdyCnGszJY+13sD6iGoh07
 csHrxamprkhWDVgMDeYd6WO98tGoRH41ytiWYFy6xeBkP0bAKCKPLQkytzU591ldRU+5
 OXzeDkclqy+vcfGx6u3gaoLqNfgrmqKzKM2iJgvdZ5FBg/nm2nUts7VflWy4gL7iJqNO
 RCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=exUXNPUBqsurzs6TF2YvQJu6wWbhf9lKT2IejTuCk6o=;
 b=Oo/AtlmFF9YdKavvn1D+cIot2VCJKPKfSxoHhwYTGxrDPDMtZS+7ejYQHDjjQsMv3B
 PsjT4oUkfMXzX7iJdXohvMxGzQwb9vup7BjIWK8lBRo/RywgpkEPytC+qJFGAsoy9AXq
 5URTtwI5058/GQjSE7KDkm7vzDEi/5eXcRPkDmcAzy7+Me/hVqtH2mnP0HC3SJme6jhz
 nNmOzKLsR21JeIMSaAKyQrIj9dwNueRHo78BQqI3tlZySvWlrJ29vpc+Pb/fz/GXaqpQ
 GkcpTTqSb3D0hMZpMb0wqdFh8+yZgOhLnI3lICeObLV3TTAWRsK8OAXupDIoP9iGA6f3
 jrWQ==
X-Gm-Message-State: AOAM5320q6mgymzQHoheOsHa+YYOhxkE5ODNc85PhI+b/3yzQeX4E3AH
 ygoMY1I2bO8xql09BySo0aErNg==
X-Google-Smtp-Source: ABdhPJwzwpfeNQT89sLH3jtamJqzFPHhAkP5CxC0/IL/uG66e6CxjBbYWKqGxu2eQLKFnmXRE/oXZQ==
X-Received: by 2002:aca:6548:: with SMTP id j8mr15090532oiw.109.1606136247152; 
 Mon, 23 Nov 2020 04:57:27 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:acac:b2ef:c7d:fd8a])
 by smtp.gmail.com with ESMTPSA id j73sm6677293otj.37.2020.11.23.04.57.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 04:57:26 -0800 (PST)
Date: Mon, 23 Nov 2020 12:57:23 +0000
From: David Brazdil <dbrazdil@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 09/27] KVM: arm64: Allow using kvm_nvhe_sym() in hyp
 code
Message-ID: <20201123125723.4mnodg3tnal4q4v2@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-10-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201117181607.1761516-10-qperret@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Tue, Nov 17, 2020 at 06:15:49PM +0000, 'Quentin Perret' via kernel-team wrote:
> In order to allow the usage of code shared by the host and the hyp in
> static inline library function, allow the usage of kvm_nvhe_sym() at el2
> by defaulting to the raw symbol name.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/hyp_image.h | 4 ++++
>  arch/arm64/include/asm/kvm_asm.h   | 4 ++--
>  arch/arm64/kvm/arm.c               | 2 +-
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
> index daa1a1da539e..8b807b646b8f 100644
> --- a/arch/arm64/include/asm/hyp_image.h
> +++ b/arch/arm64/include/asm/hyp_image.h
> @@ -7,11 +7,15 @@
>  #ifndef __ARM64_HYP_IMAGE_H__
>  #define __ARM64_HYP_IMAGE_H__
>  
> +#ifndef __KVM_NVHE_HYPERVISOR__
>  /*
>   * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_,
>   * to separate it from the kernel proper.
>   */
>  #define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
> +#else
> +#define kvm_nvhe_sym(sym)	sym
> +#endif
>  
>  #ifdef LINKER_SCRIPT
>  
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 1a86581e581e..e4934f5e4234 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -173,11 +173,11 @@ struct kvm_s2_mmu;
>  DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
>  DECLARE_KVM_NVHE_SYM(__kvm_hyp_host_vector);
>  DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
> -DECLARE_KVM_NVHE_SYM(__kvm_hyp_psci_cpu_entry);
>  #define __kvm_hyp_init			CHOOSE_NVHE_SYM(__kvm_hyp_init)
>  #define __kvm_hyp_host_vector		CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
>  #define __kvm_hyp_vector		CHOOSE_HYP_SYM(__kvm_hyp_vector)
> -#define __kvm_hyp_psci_cpu_entry	CHOOSE_NVHE_SYM(__kvm_hyp_psci_cpu_entry)
> +
> +void kvm_nvhe_sym(__kvm_hyp_psci_cpu_entry)(void);
>  
>  extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
>  DECLARE_KVM_NVHE_SYM(__per_cpu_start);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 882eb383bd75..391cf6753a13 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1369,7 +1369,7 @@ static void cpu_prepare_hyp_mode(int cpu)
>  
>  	params->vector_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_host_vector));
>  	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
> -	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_psci_cpu_entry));
> +	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref_nvhe(__kvm_hyp_psci_cpu_entry));

Why is this change needed?

>  	params->pgd_pa = kvm_mmu_get_httbr();
>  
>  	/*
> -- 
> 2.29.2.299.gdc1121823c-goog
> 
> -- 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
