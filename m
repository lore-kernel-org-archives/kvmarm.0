Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988D2C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 10:37:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D039264FC3
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 10:37:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D039264FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 190EE4B69C;
	Thu, 11 Mar 2021 05:37:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mXcui+T6qrga; Thu, 11 Mar 2021 05:37:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3AF94B6B8;
	Thu, 11 Mar 2021 05:37:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3120C4B6B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 05:37:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0lANLzXUo-Ww for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 05:37:32 -0500 (EST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E496D4B69C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 05:37:31 -0500 (EST)
Received: by mail-wm1-f44.google.com with SMTP id
 f22-20020a7bc8d60000b029010c024a1407so12889793wml.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 02:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=d5vrIndTZ2lv2NdxVGezWAABtG76rGC6Fvh6Su1kB3A=;
 b=dlMl54335PKInIXkaVThbGzlX/sK9Zt74GAgV9HTFTCXrZ7OrIrZOCnGItF8da9MxS
 IsFw8Gv1vWjdVrf7gtBQioR7Dff7rOQy85RjLqoi6Pv/mcBQIas6e7DRCvLzQF8tQCkc
 k5OxEgjj2ptidjFNp2KvbwzjRgdewns4NfeTJHIv9oVXwtDfS/hukP0GiNr0yMLIYxyI
 HNSnM7dilkdch3t8cZp/CAXjlXfo7UbjEr7kT9u8F8qNaQmH9ZLh8rH+8fR7qPbCU+VH
 2Od0mluLMbhZ6KKRue/6z0e8l6ZoFTBabh11klWHQ4CqzK+U/3B6hB8ku55jUrHv7nA1
 PkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=d5vrIndTZ2lv2NdxVGezWAABtG76rGC6Fvh6Su1kB3A=;
 b=CgB1Gr5btPcAjviwT73SY7WF+L1gP118pXMEt+kELmE+KCJGpjYtbdsPckumyYTGdw
 AQYwjqm5aIN25O6ZnnKl1ci8aUmR1vBvKNRMQ5LS9QUvuRA+0yIpm++FgZ+JYbey9/0s
 ksIL0wP/3uMO6r3/BJ/tuxkZ9gW4TVjUl0YZSu/zHj9j6/FTDf+f+/AsP6DekxWBlqVq
 2kZITdQ8Bd+7gNB7e3VgOB4vSCb+Rmj8Hs1+/F9XxxQAQc6OVaJgwW780pEkNtE+FQ6s
 IgfSNKtHmFSi+JHVqNAV0vPKTyWsTgfCiw2nD94as2bIMBUy3YsFTZq2Sr7bL7jqSPK2
 GYGQ==
X-Gm-Message-State: AOAM532iRUoaW90NnFisL160kTn5NDNXvN5KHJLp7tN6psPuVSECkQlr
 SJp42OI6zZbnSgkP89Eqf1Gb8w==
X-Google-Smtp-Source: ABdhPJxMPdANRx8htGsjavXxDqpa+6hh/LdqKJcJhoLytuL8LXurrc0P/UiDp1WAYPR8mRZvD3kzyg==
X-Received: by 2002:a1c:2390:: with SMTP id j138mr7448141wmj.72.1615459050791; 
 Thu, 11 Mar 2021 02:37:30 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id p27sm3295488wmi.12.2021.03.11.02.37.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Mar 2021 02:37:30 -0800 (PST)
Date: Thu, 11 Mar 2021 10:37:28 +0000
From: Quentin Perret <qperret@google.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 05/10] KVM: arm64: Track where vcpu FP state was last
 loaded
Message-ID: <YEny6LbBPmKpK95k@google.com>
References: <20210304115454.3597879-1-ascull@google.com>
 <20210304115454.3597879-6-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210304115454.3597879-6-ascull@google.com>
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

On Thursday 04 Mar 2021 at 11:54:48 (+0000), 'Andrew Scull' via kernel-team wrote:
> Keep track of the cpu that a vcpu's FP state was last loaded onto. This
> information is needed in order to tell whether a vcpu's latest FP state
> is already loaded on a cpu to avoid unnecessary reloading.
> 
> The method follows the pattern used by thread_struct whereby an
> fpsimd_cpu field is added and updated when the state is loaded.
> 
> Signed-off-by: Andrew Scull <ascull@google.com>
> Cc: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       | 1 +
>  arch/arm64/kvm/arm.c                    | 2 ++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 ++
>  3 files changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8a559fa2f237..a01194371ae5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -306,6 +306,7 @@ struct kvm_vcpu_arch {
>  	struct kvm_guest_debug_arch vcpu_debug_state;
>  	struct kvm_guest_debug_arch external_debug_state;
>  
> +	int fpsimd_cpu;
>  	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
>  
>  	struct {
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e3edea8379f3..87141c8d63e6 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -313,6 +313,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>  
> +	vcpu->arch.fpsimd_cpu = NR_CPUS;

Is this supposed to be an invalid CPU number? If so, then NR_CPUS + 1 ?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
