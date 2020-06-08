Return-Path: <SRS0=JvcX=7V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A40C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 15:00:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01584206C3
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 15:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="H4q0p6de"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01584206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 774E14B1BD;
	Mon,  8 Jun 2020 11:00:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Uulj-bMDh25c; Mon,  8 Jun 2020 11:00:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AFF44B1C1;
	Mon,  8 Jun 2020 11:00:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAB534B1C1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 11:00:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MuxgALlN9RQC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2020 11:00:41 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BD3E4B1BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 11:00:41 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id q25so16868674wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Jun 2020 08:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hjZu9HUiJ4ghbYbVLHHdJJBsYU84vEwMo6AWGQbzbMg=;
 b=H4q0p6dexKRAu9bVDnRSuBCRoRqXk6tNmInurnFg/yZIgEWNJZaxUzJp9X/7yxQx+E
 Kq2z1a4o455v0Lxpi92VdXUmx0hyUT0ay2fwkkHVS1FvMcpSIx7mbZvGiPS7WuQUjzAw
 +cq2dDek+N/qnt2G0nz9jyyORRXYAg2c+A2CWUB9l9QseFwiLsjbg2wasklnP4DkeOMi
 VOrKoLsghKd23Fp3h4gjM7oPG8kR6M86DVX4S1hH0lU785YYfm1JWSQXLe+LiIiogHW4
 nvA3eES0u3Nvu4q1p8fvq7vAiy3KGMlaVeuQ9lD+gmWKWTx46tvQi7eMxrKOD7Hmz7oz
 wKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hjZu9HUiJ4ghbYbVLHHdJJBsYU84vEwMo6AWGQbzbMg=;
 b=uV97xgJkji4nmixjh1j8jolV3Uac/SoKKQEWuB+H7ryDP3FYfanYSRTkU9gZi4Qcpi
 +/6xek7f6KCRMl1T9d5dFMTwGlIX+l0LaPviMCToyMkJ/Qn4PxGm1/OtRjPry9JyoYGX
 Haj/f99CBXM8zojN/mOAfhBJ9T4lT9t5p6OG260LN/3f+GGnnuVQ/jh15Jp0SkjQuJFG
 ravkXzdviMVgn5dP95BdyYtqL5aH+vw0aMOg3qu3+IZIXDfY/JIpnLXxRWMauWzU1AWE
 s9afs9J26f/A+j2S1UALvvXoliZiO41RkQfPcdSiP4syC8f8x1Hi1h4JykCwr6omdWTC
 9B8A==
X-Gm-Message-State: AOAM533ETcsEQkWJksTt+eLWU/hYeWBzPhX9s6igB+h7wuIHLqG1sxyx
 1nlWjxsJAc1Pq8sJy0RTh76X2A==
X-Google-Smtp-Source: ABdhPJwc83jEVUrsYqdet2/G/6Soma/d1TvTQMjyae5cRkkAfGcbkJMyoOVSLQRjigs4Bo6/5LNImQ==
X-Received: by 2002:a1c:29c4:: with SMTP id p187mr16901343wmp.73.1591628440198; 
 Mon, 08 Jun 2020 08:00:40 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id n1sm10397wrp.10.2020.06.08.08.00.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 Jun 2020 08:00:39 -0700 (PDT)
Date: Mon, 8 Jun 2020 16:00:35 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
Message-ID: <20200608150035.GB96714@google.com>
References: <20200608085731.1405854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200608085731.1405854-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jun 08, 2020 at 09:57:31AM +0100, Marc Zyngier wrote:
> Sparse complains that __hyp_this_cpu_ptr() returns something
> that is flagged noderef and not in the correct address space
> (both being the result of the __percpu annotation).
> 
> Pretend that __hyp_this_cpu_ptr() knows what it is doing by
> forcefully casting the pointer with __kernel __force.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 0c9b5fc4ba0a..82691406d493 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -81,12 +81,17 @@ extern u32 __kvm_get_mdcr_el2(void);
>  
>  extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
>  
> -/* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
> +/*
> + * Home-grown __this_cpu_{ptr,read} variants that always work at HYP,
> + * provided that sym is really a *symbol* and not a pointer obtained from

Look at `this_cpu_ptr` one thing that stood out was `__verify_pcpu_ptr`
that is documented to be suitable for used in custom per CPU macros. I
didn't get how it worked (a type check?) but maybe it would work here
to validate the argment was indeed a per CPU symbol?

> + * a data structure. As for SHIFT_PERCPU_PTR(), the creative casting keeps
> + * sparse quiet.
> + */
>  #define __hyp_this_cpu_ptr(sym)						\
>  	({								\
>  		void *__ptr = hyp_symbol_addr(sym);			\
>  		__ptr += read_sysreg(tpidr_el2);			\
> -		(typeof(&sym))__ptr;					\
> +		(typeof(sym) __kernel __force *)__ptr;			\
>  	 })
>  
>  #define __hyp_this_cpu_read(sym)					\
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
