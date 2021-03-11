Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3E1C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 10:35:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6985564FCD
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 10:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6985564FCD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE5224B6D0;
	Thu, 11 Mar 2021 05:35:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6jL8ahLADRsH; Thu, 11 Mar 2021 05:35:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82654B6AB;
	Thu, 11 Mar 2021 05:35:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F584B69C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 05:35:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mPw9Y6xp2d1X for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 05:35:38 -0500 (EST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DA394B698
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 05:35:38 -0500 (EST)
Received: by mail-wr1-f45.google.com with SMTP id v15so1252844wrx.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 02:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=oAnUf1CH5SzdTuS1nSyHZ6w5rlc3CKaedIpD8SxcNGQ=;
 b=LJpdf/vnVX5zpBux70jAtz6DqJnUpfAERqSsRbGVD7vx9oDClhQE9CZeiEMyriatR7
 NZYOePAyzR0WmJSrzRMPLMxF5j3XZCr70tpy3H9Ly+vz+qxjbH0z8Za4GJsLXNDCr3k8
 tQ/Fl4nos6YrYh7RI56gT5/i+FxAUoQa0HKepjO3D8s758VCrIowvZzsVrsncK0rJ2WY
 H3m5apkfAL89rV3b2aZEpDuzAGnwNDoiAZy6PI/aRi0AKud0qNhWPJ3W0X0wKjTbD4pE
 IXpgwVY4GhyLBc/8ZsmACnmc54+DAEAiVxsom2uAJ7Oe9EjoGeAh3QBF0VhusaGNKKO7
 LRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oAnUf1CH5SzdTuS1nSyHZ6w5rlc3CKaedIpD8SxcNGQ=;
 b=Pi+S3qc8SCwFaqn/RbR1ygll80+y5Q1oIvlAT5NOkrc2cuzzbMUjpg2uXFDdOEH6UW
 psDWML/wZpCd9yjBWTpUDN5C2PUUG4ptTCxBFpDFSWzFx6Iti/uGofcjAy27BXhW0faR
 pXkJxnBXOXuU0etlgKWQ/Hp3hycw7Aepc8aCcf967pRSWnTA1dsiLZYCDOFualXceVGU
 UixDtF4z6K4+M8/Rw/iQkOB8ruTW4aueRhmzEHZK5liPB4eJQc65OdpWxGmhA+BFbtzD
 2OKQs/caRvgyTpoqaQUX9zOxsfL7uoOItXqs00VeHpPNAIYCPRWyG/lVXq+0VQ7/yb1F
 77wA==
X-Gm-Message-State: AOAM531eg+t/i9ntijHTWxYEJsL5o7qNZJWjPwvaI5G5VuuqN976mDiJ
 4LJUzHAtsxLC5CO/ja9ApsPLSg==
X-Google-Smtp-Source: ABdhPJziKk6n3CbuV6VCVcdBf8GUCaAnxY6upsHFEhXYh5NGciP7E+2rKQfhbIKJjtLc2qP+ga+Agg==
X-Received: by 2002:adf:9bd7:: with SMTP id e23mr7855141wrc.48.1615458937154; 
 Thu, 11 Mar 2021 02:35:37 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id z13sm3084085wrh.65.2021.03.11.02.35.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Mar 2021 02:35:36 -0800 (PST)
Date: Thu, 11 Mar 2021 10:35:34 +0000
From: Quentin Perret <qperret@google.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 04/10] KVM: arm64: Support smp_processor_id() in nVHE hyp
Message-ID: <YEnyds3LmQBWSeO4@google.com>
References: <20210304115454.3597879-1-ascull@google.com>
 <20210304115454.3597879-5-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210304115454.3597879-5-ascull@google.com>
Cc: kernel-team@android.com, maz@kernel.org, Dave.Martin@arm.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thursday 04 Mar 2021 at 11:54:47 (+0000), 'Andrew Scull' via kernel-team wrote:
> smp_procesor_id() works off of the cpu_number per-cpu variable. Create
> an nVHE hyp version of cpu_number and initialize it to the same value as
> the host when creating the hyp per-cpu regions.
> 
> Signed-off-by: Andrew Scull <ascull@google.com>
> ---
>  arch/arm64/kvm/arm.c              | 2 ++
>  arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 26ccc369cf11..e3edea8379f3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -54,6 +54,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
>  unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
>  DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> +DECLARE_KVM_NVHE_PER_CPU(int, cpu_number);
>  
>  /* The VMID used in the VTTBR */
>  static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
> @@ -1740,6 +1741,7 @@ static int init_hyp_mode(void)
>  		page_addr = page_address(page);
>  		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
>  		kvm_arm_hyp_percpu_base[cpu] = (unsigned long)page_addr;
> +		*per_cpu_ptr_nvhe_sym(cpu_number, cpu) = cpu;
>  	}
>  
>  	/*
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> index 879559057dee..86f952b1de18 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
> @@ -8,6 +8,8 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> +DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);

Is smp_processor_id() going to work at EL2 with CONFIG_DEBUG_PREEMPT=y ?
If not, then maybe we should have out own hyp_smp_processor_id() macro?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
