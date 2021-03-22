Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC5CC433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 17:40:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA8436188B
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 17:40:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA8436188B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C804B30D;
	Mon, 22 Mar 2021 13:40:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wMMqBvWfXDeL; Mon, 22 Mar 2021 13:40:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C5454B352;
	Mon, 22 Mar 2021 13:40:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84A914B2CA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 13:40:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21BElWfNtxdw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 13:40:44 -0400 (EDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80F624B2AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 13:40:44 -0400 (EDT)
Received: by mail-wr1-f50.google.com with SMTP id j18so18047532wra.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 10:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+fO8q0q5J+d7OtGdbjb3cUlxaHCNevc3CNJXbnhrioc=;
 b=iqx4aHW7FNF4wyHYPNIxseKctlq/hpv2wK6Dm4zP9Tm/R4vtJuDBdYLnpsXx7vRvl5
 29DRkgQ0flZpLqhEWVQF+YDhsqwjyVHk9Kvze/AiJZjbPlu7s/j/P21LjcE8WT6+FCA/
 T6MzgN0XxviMCYwiIIlm3Xms3t6SW+FWzrAAz6WmTD9+buffDPXNPy3XgjT/T/6LNnww
 dz4ze9nLU2jgndXpnCn+7uJTD7KOzUP1Qg+DZxaOCa1GkylEgeUItff0Oip8TwrR6hix
 VKsxwdpQila6uZCigkSXOny68RWCrG0mlOb9U8kdycED+PLzsttKS1heAJ78rtygNuDT
 gOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+fO8q0q5J+d7OtGdbjb3cUlxaHCNevc3CNJXbnhrioc=;
 b=GgKcVQAiuX1k2u2693cXYEBorn0vOXvK2+sdttNZ0ZDOVMWKlxNgy8PevUsiENAKZS
 mCmwiwfdfqzmMEkrziqMDlkyJsAdfm7OzZa6gAH3/AxtWDKHQNRsoe7URiLPzIUxVyp3
 SznTHTIhHqnHaEHto37ukTaLQ9aK5HMOiksM1SFeq4BUfNE0wNHzyq4zKjMLohvyiSaQ
 UZdGywkN+mwdc2FfjBVNJTVQW3mD8Tqs+gjxm0i7S60ew4RQslTWLIQk/nBr8canBnk+
 w8bTKhPY/JYHJgmeRo48gbUmrxed5OCsLKfWW+GzgGM91S0V923zWuqhYY33owQsNN6x
 xbug==
X-Gm-Message-State: AOAM5317UEkCxQ1owX/QheFomENW5/JjgkmW/YJ0qFaKQyXz68AsJQxN
 AqBQE1Txs/z93nPTjkxd5KnZ4w==
X-Google-Smtp-Source: ABdhPJwlW8Sko8nIrzPZMUnI95OPH4WRWyOCvQ0v+YlPw7MwCNpZVFd7Scuq1pqSBTH9xLCYIArLHQ==
X-Received: by 2002:adf:f0c1:: with SMTP id x1mr656464wro.7.1616434843381;
 Mon, 22 Mar 2021 10:40:43 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id b131sm105865wmb.34.2021.03.22.10.40.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Mar 2021 10:40:43 -0700 (PDT)
Date: Mon, 22 Mar 2021 17:40:40 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Generate final CTR_EL0 value when
 running in Protected mode
Message-ID: <YFjWmHerKk7+9d7N@google.com>
References: <20210322164828.800662-1-maz@kernel.org>
 <20210322164828.800662-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210322164828.800662-3-maz@kernel.org>
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 tabba@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, seanjc@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

Hey Marc,

On Monday 22 Mar 2021 at 16:48:27 (+0000), Marc Zyngier wrote:
> In protected mode, late CPUs are not allowed to boot (enforced by
> the PSCI relay). We can thus specialise the read_ctr macro to
> always return a pre-computed, sanitised value.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/assembler.h | 9 +++++++++
>  arch/arm64/kernel/image-vars.h     | 1 +
>  arch/arm64/kvm/va_layout.c         | 7 +++++++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index fb651c1f26e9..1a4cee7eb3c9 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -270,12 +270,21 @@ alternative_endif
>   * provide the system wide safe value from arm64_ftr_reg_ctrel0.sys_val
>   */
>  	.macro	read_ctr, reg
> +#ifndef __KVM_NVHE_HYPERVISOR__
>  alternative_if_not ARM64_MISMATCHED_CACHE_TYPE
>  	mrs	\reg, ctr_el0			// read CTR
>  	nop
>  alternative_else
>  	ldr_l	\reg, arm64_ftr_reg_ctrel0 + ARM64_FTR_SYSVAL
>  alternative_endif
> +#else
> +alternative_cb kvm_compute_final_ctr_el0
> +	movz	\reg, #0
> +	movk	\reg, #0, lsl #16
> +	movk	\reg, #0, lsl #32
> +	movk	\reg, #0, lsl #48
> +alternative_cb_end
> +#endif
>  	.endm

So, FWIW, if we wanted to make _this_ macro BUG in non-protected mode
(and drop patch 01), I think we could do something like:

alternative_cb kvm_compute_final_ctr_el0
	movz	\reg, #0
	ASM_BUG()
	nop
	nop
alternative_cb_end

and then make kvm_compute_final_ctr_el0() check that we're in protected
mode before patching. That would be marginally better as that would
cover _all_ users of read_ctr and not just __flush_dcache_area, but that
first movz is a bit yuck (but necessary to keep generate_mov_q() happy I
think?), so I'll leave the decision to you.

No objection from me for the current implementation, and if you decide to
go with it:

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
