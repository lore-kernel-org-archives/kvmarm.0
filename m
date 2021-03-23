Return-Path: <SRS0=T+on=IV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A093C433C1
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 09:47:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D26E6619C0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 09:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D26E6619C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46FCE4B401;
	Tue, 23 Mar 2021 05:47:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hKZvsCwvAe1d; Tue, 23 Mar 2021 05:47:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 474D94B3E8;
	Tue, 23 Mar 2021 05:47:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C7924B3E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 05:47:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OULiGgk9UEix for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Mar 2021 05:47:13 -0400 (EDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE5484B3B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 05:47:12 -0400 (EDT)
Received: by mail-wr1-f48.google.com with SMTP id v4so20054934wrp.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 02:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=oEiL3agt/74r7enmoTbEE0QlFnF8CJn1Y4avzKhgTiU=;
 b=YUFx/qgDiqyZgnG8fBQV5CEOQ9+BCRiJTNLw0U/Sjtwv7xDzYaCvOnt/DijlqjJDeq
 4gQ1ijgTeZbWSdb+trVyRWjQKbmgFIyw4kGzPHLfck/FJdRXsv6bJpcjqeUqY7ghYvwq
 pRcEi12K2xC6zj3zsdQHR7GQAz649sWNk0M5X3vcihlgBrPbW/ysFTU3zhgqPGfOiyln
 Ce/J3a+l+5yKFk7jm7otSR8CvCnQGsnVqlJVGNBKTlVXojSRlpjhpm+gC9AtYVeX6D4+
 uJijgatuuL+mfS0/3DkfrCgbc1Hn0xyCXdplBpsN8aHekogkBv5nmPi8VJ893Vsd2gbg
 iDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oEiL3agt/74r7enmoTbEE0QlFnF8CJn1Y4avzKhgTiU=;
 b=oPGdRgDf7oDEEma4uE4ZGRCpRFwfwAInqG29cTVXatt7x3difMuPiqAGK64Vx2ZB89
 n7Z6urWseoMRYWHDTztT4x2CWoA7UZAsyBlRKOgk21pkuVGgrBADm1pRPyITvSBN5HA6
 ZVWz1PRIOvI4WksOhyISkK7IAvdEzabAFk7NeuiIpJ5C/iptLqM4A+86hHrBXrzExv1Y
 AW1uM4FT3pKLDaY4O/PHMqPhCt0+cuL0xG6pId4s43RuNGs5WEMVDHVM0DvBzpW1Ghlt
 gPjzASvnOr6xtcpc+Ir+R+a/m7EsB4IGUBbNZXe5dzAWB6hXTVvSHsuh4R6H8pYPDIh+
 41Vg==
X-Gm-Message-State: AOAM532CoP6YCCb5Sc3bQv2GLv2rgTgHvG5Gz/1Bd2IeXAcyexgRMZ5c
 2mn0l0oYp6PgtfYzHhbyTDS2Cw==
X-Google-Smtp-Source: ABdhPJwZod2yQE1XjdtryqkkNyVhfuXXaVYhV4/ZQg1dkULLQ1uIrVQJ3DN+46T9qwKAV2wA8h4DIw==
X-Received: by 2002:adf:ee4f:: with SMTP id w15mr3039063wro.199.1616492831791; 
 Tue, 23 Mar 2021 02:47:11 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id k4sm29442912wrd.9.2021.03.23.02.47.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Mar 2021 02:47:11 -0700 (PDT)
Date: Tue, 23 Mar 2021 09:47:08 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Generate final CTR_EL0 value when
 running in Protected mode
Message-ID: <YFm5HIC/2Toowhnx@google.com>
References: <20210322164828.800662-1-maz@kernel.org>
 <20210322164828.800662-3-maz@kernel.org>
 <YFjWmHerKk7+9d7N@google.com> <87k0pzghlx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k0pzghlx.wl-maz@kernel.org>
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

Hi Marc,

On Monday 22 Mar 2021 at 18:37:14 (+0000), Marc Zyngier wrote:
> Can't say I'm keen on the yucky bit, but here's an alternative (ha!)
> for you:
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 1a4cee7eb3c9..7582c3bd2f05 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -278,6 +278,9 @@ alternative_else
>  	ldr_l	\reg, arm64_ftr_reg_ctrel0 + ARM64_FTR_SYSVAL
>  alternative_endif
>  #else
> +alternative_if_not ARM64_KVM_PROTECTED_MODE
> +	ASM_BUG()
> +alternative_else_nop_endif
>  alternative_cb kvm_compute_final_ctr_el0
>  	movz	\reg, #0
>  	movk	\reg, #0, lsl #16
> 
> Yes, it is one more instruction, but it is cleaner and allows us to
> from the first patch of the series.
> 
> What do you think?

Yes, I think having the ASM_BUG() in this macro is bit nicer and I doubt
the additional nop will make any difference, so this is looking good to
me!

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
