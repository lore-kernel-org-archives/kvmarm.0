Return-Path: <SRS0=lrOB=GC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BF9C433E6
	for <kvmarm@archiver.kernel.org>; Wed, 30 Dec 2020 09:09:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4375421D94
	for <kvmarm@archiver.kernel.org>; Wed, 30 Dec 2020 09:09:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4375421D94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCEDB4B167;
	Wed, 30 Dec 2020 04:09:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q2kZvtCMbmXg; Wed, 30 Dec 2020 04:09:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B78C4B1CB;
	Wed, 30 Dec 2020 04:09:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF704B31A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 17:34:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dhXqyDymBBl8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Dec 2020 17:34:38 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1A364B2C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 17:34:37 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id l23so2275496pjg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 14:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+puKxIHEHRO9Frraw+Ib5C3MtagJB4PPbY1dXGI0aMY=;
 b=Db/Bz0oUEsAEjotOi2aizjGW63kjeIkKxMbizlvrZhlT1mYxBo60/kirR5KhgAnPHi
 TQTO7bpvyRZ2D0sreSTAohT6HJe+R7TvOT5/CFTwil+LEAv/L6gYGzB/N0bq9NeLzvdv
 xAQ4AsPT5uMN0rD1hBTtW/s7HLqo8CQ3O3a6T/NbE2Wf3hiy/MzL3thsDyNRLhAWgjSC
 +8Xd7DayLQqfU3818hC6mZVO3OpV8zLNIBhQfYRFkXSd6NH3WN2ZSBzQpUQr5A3GorJC
 gKcahwW6EqxRf0kG3G6rG0wF8fiS6KS3M7M8YccSTy/QAa+GdeLAXzCcaVewpJkJSRfk
 aoig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+puKxIHEHRO9Frraw+Ib5C3MtagJB4PPbY1dXGI0aMY=;
 b=JNeNjDymZyLWs13Ifbt+K/mwUj4qIbOt12XbbmqqwYGGZJYz6i5yq2RQsl6q2iBcJy
 huwU7wEXZujZWF9T5pl6lasFEbqa0UB/yJ5b2uEYCk3ydN06zoQEnU7OJKSIvivkVg6n
 NxXkvS3lffmAxM9B9a3abl23U0vfBf3m8wmQqz9WOLhhRN4MIVv/H/+WPG/V5ErIVLuw
 grkJ5Hkp9a/3ZuvU0quWGI302DJ+kAzywdOirIspOe2yKwS/yiJ+KEwtLWC0V7iPbkLr
 yNU0N0Lzlaod+UUBlgqr7ZgFkUaMkVPlEUAMxBN+RhT1NF1HIJnl9BK8JiZH1V8LfaZ0
 nlQA==
X-Gm-Message-State: AOAM531zDgIFmyZdq+7+EhKq9IP4Y93MebuOR0KlmVvIewb0ffcV0Myx
 w6wAKqjEeuKS/3lrNd8A7Zw=
X-Google-Smtp-Source: ABdhPJwO6+EhBdPbyeSEtZ8LGB13rmvcKxcwf9DtbsdqsocsaBED8zHWm/Uchykqky/r/A3M2vvv1A==
X-Received: by 2002:a17:90b:2244:: with SMTP id
 hk4mr5693301pjb.222.1609281277010; 
 Tue, 29 Dec 2020 14:34:37 -0800 (PST)
Received: from Ryzen-9-3900X.localdomain (ip68-104-204-241.ph.ph.cox.net.
 [68.104.204.241])
 by smtp.gmail.com with ESMTPSA id a136sm43067302pfd.149.2020.12.29.14.34.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 29 Dec 2020 14:34:36 -0800 (PST)
Date: Tue, 29 Dec 2020 15:34:34 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix hyp_cpu_pm_{init,exit} __init annotation
Message-ID: <20201229223434.GA255@Ryzen-9-3900X.localdomain>
References: <20201223120854.255347-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201223120854.255347-1-maz@kernel.org>
X-Mailman-Approved-At: Wed, 30 Dec 2020 04:09:16 -0500
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Dec 23, 2020 at 12:08:54PM +0000, Marc Zyngier wrote:
> The __init annotations on hyp_cpu_pm_{init,exit} are obviously incorrect,
> and the build system shouts at you if you enable DEBUG_SECTION_MISMATCH.
> 
> Nothing really bad happens as we never execute that code outside of the
> init context, but we can't label the callers as __int either, as kvm_init
> isn't __init itself. Oh well.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/arm64/kvm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6e637d2b4cfb..71a49eae9ea0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1574,12 +1574,12 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
>  	.notifier_call = hyp_init_cpu_pm_notifier,
>  };
>  
> -static void __init hyp_cpu_pm_init(void)
> +static void hyp_cpu_pm_init(void)
>  {
>  	if (!is_protected_kvm_enabled())
>  		cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
>  }
> -static void __init hyp_cpu_pm_exit(void)
> +static void hyp_cpu_pm_exit(void)
>  {
>  	if (!is_protected_kvm_enabled())
>  		cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
> -- 
> 2.29.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
