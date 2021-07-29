Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFB3C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 14:00:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE7E261059
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 14:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE7E261059
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A55A4B0CE;
	Thu, 29 Jul 2021 10:00:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HvTWXN4Pvyal; Thu, 29 Jul 2021 10:00:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1025B4B0C6;
	Thu, 29 Jul 2021 10:00:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6FF4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 10:00:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uk51yQMRhr9B for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 10:00:10 -0400 (EDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82D704B0BC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 10:00:10 -0400 (EDT)
Received: by mail-wr1-f50.google.com with SMTP id r2so7119420wrl.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 07:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=liO5wucVGjUgl66CCyk5eCr9ee7CWFbOuaagBW74+qs=;
 b=EJ2F3ITFwEJ9rcPEvHQ6lQ2DOZnQ5vBtGtiPUiaEaUYZAeiKbLrc61I8wPZVT0mmce
 oMnATeCgB3nMSCmOY6JYICgTkdxdCA6cizvZWmE5FXgzbr/++FZUo4NbEvGTfoaVyNo1
 0azpBzwCzgho7Xydbwqhu4X7ssL0HYuQtBhcVrHshYeuX/tgsNM/hwhRAfj6VPIYKcNn
 SRdE5PgOBshCvRabzbztBxFP+svsg33eT/iYXEhNAvgVqbLfjYJ27YSZ+f2oEjLm1yDO
 AhQLpqmc/tmy1CFjkjoE2k7ynXOGtOgA9wC8FJHeG8CjoVUhMUY8rhuJgR4gWWk4TaFx
 BLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=liO5wucVGjUgl66CCyk5eCr9ee7CWFbOuaagBW74+qs=;
 b=SSb1Cum28JqlGXnJESUtd47yYtTEFg9wKIXbveCC8eByO3sAsbISPDRZPC5u4q/cLE
 NW5WaMxtfbKsEYvKjNTJIWcDyDMhFEcM4Nz+wlKai7NcfdE8cqToda1yUIWliJCzdV6r
 jcrpeqHkzRBX0RU8QDQGI7wLNIG9n45O5wU1uEVfd0F8r0W0Szit2YLaAZxXqimNTF6v
 I3dvhxRrpmVuRh1gFjCBDkQG95xtrv7+Drf5xiVnUzqTBCQFaNU08TE+03+0jTMjN55e
 34U8D0MmpgDWFyba5UhA2qV7pNJr2Ws4Z7VZwWAZnaO2Jtp1yCyGjorQTRHC6h9xuS6l
 sgFQ==
X-Gm-Message-State: AOAM532YeQZIxTLSJZdwq610wvK0trem9donwyQXZ96V0N85AL0lHNtF
 03DWwaitvQu5+5qWiW2/shGS9A==
X-Google-Smtp-Source: ABdhPJzb3jcmoJ3eeO2z7wKiK0sm764dKThMtyfcXT/S/xhsz1jMXke7rkEjfqjma4uFzTs051Dz9A==
X-Received: by 2002:a5d:64ac:: with SMTP id m12mr4942109wrp.89.1627567209287; 
 Thu, 29 Jul 2021 07:00:09 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:293a:bc89:7514:5218])
 by smtp.gmail.com with ESMTPSA id l18sm9913097wmq.0.2021.07.29.07.00.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Jul 2021 07:00:09 -0700 (PDT)
Date: Thu, 29 Jul 2021 15:00:05 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Unregister HYP sections from kmemleak in
 protected mode
Message-ID: <YQK0ZeRZY/53tWEZ@google.com>
References: <20210729135016.3037277-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210729135016.3037277-1-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, stable@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thursday 29 Jul 2021 at 14:50:16 (+0100), Marc Zyngier wrote:
> Booting a KVM host in protected mode with kmemleak quickly results
> in a pretty bad crash, as kmemleak doesn't know that the HYP sections
> have been taken away.
> 
> Make the unregistration from kmemleak part of marking the sections
> as HYP-private. The rest of the HYP-specific data is obtained via
> the page allocator, which is not subjected to kmemleak.
> 
> Fixes: 90134ac9cabb ("KVM: arm64: Protect the .hyp sections from the host")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: stable@vger.kernel.org # 5.13
> ---
>  arch/arm64/kvm/arm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..23f12e602878 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -15,6 +15,7 @@
>  #include <linux/fs.h>
>  #include <linux/mman.h>
>  #include <linux/sched.h>
> +#include <linux/kmemleak.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_irqfd.h>
>  #include <linux/irqbypass.h>
> @@ -1960,8 +1961,12 @@ static inline int pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
>  }
>  
>  #define pkvm_mark_hyp_section(__section)		\
> +({							\
> +	u64 sz = __section##_end - __section##_start;	\
> +	kmemleak_free_part(__section##_start, sz);	\
>  	pkvm_mark_hyp(__pa_symbol(__section##_start),	\
> -			__pa_symbol(__section##_end))
> +		      __pa_symbol(__section##_end));	\
> +})

At some point we should also look into unmapping these sections from
EL1 stage-1 as well, as that should lead to better error messages in
case the host accesses hyp-private memory some other way. But this
patch makes sense on its own, so:

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
