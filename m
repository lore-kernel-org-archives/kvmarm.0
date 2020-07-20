Return-Path: <SRS0=coVF=A7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2EBC433E4
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 15:40:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 129E22176B
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 15:40:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ACSVjrYn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 129E22176B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48CEA4B0FF;
	Mon, 20 Jul 2020 11:40:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rHebLxM1iB0W; Mon, 20 Jul 2020 11:40:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38CDC4B16C;
	Mon, 20 Jul 2020 11:40:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4A44B0FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 11:40:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xXzBGFA0SqDB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jul 2020 11:40:28 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31EA64B0F9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 11:40:28 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id g10so268414wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 08:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=FDDBFmqlBVCnbr6XQsto5ehKBZMHj8foEmeFFHwu7G0=;
 b=ACSVjrYnQSrDDL3Ij2F+EhxKBhzhAwxA4VRmvdH1eRyBzhjKFWhP6+5772Ce0W4/5V
 h1LZ4GbfoJ1mQVyyWmuj2aLe35bNZHd8wVeJ+abFNL1TqjMoj7Z9MkBU05lcGkQGeuvy
 oDSnkYDamZ/rvw8TeSsOv1u4CxDcygCUzVS0t+2Ul3tr6XyZ/17K7XqMQa5u4xfmsKKZ
 +0CLCAWaR+V7EKGhLfnvQ8EwkEhEUcwNbPmuA/Qiw3GdYrjn/iBu/vda+SKVBjLMC6rF
 3DsCy/WRyZtYSjk/boM29Q1dpaTkMC4oT+adOy1JaKzJ9twmjxUwaVLeEUc4ZnKJqXMJ
 vCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FDDBFmqlBVCnbr6XQsto5ehKBZMHj8foEmeFFHwu7G0=;
 b=cpfhg98b2JIo8KG9KGmpzg41InJIqo6iow/rD4eMSPggowy+JH+dVshTObBYI+42uR
 dPQc3EdUIEO8jtU/svbB78jAi7ZZmVYK9ZsKv8yKoLcfQKSfqNTEbn+lT0tY0Kc+oxSw
 q9uelFirvEvlpjCuVQaFMVYMrg/plsomLgajkGHT/zq7uy8tNPSE/22mX6QWfpR7ZtVN
 HvQ/GFW0HYan2E4N9n5bFVQ6RFwg9NEOSk/3VcY6+MepJyMz8ffuVv0sGTzpL9FZJWt1
 /hLT1EPZil5AHiP/ldZ8hQtRFXEc5AmFXEqT0E6t5QIYKZ4ufTOLJLJZNu0fQ8f7qWSU
 GI8w==
X-Gm-Message-State: AOAM533BqBPrBNABIGU8z5QZA64EAoeUQoeM7RL2z5RB0chA864aFVFM
 9/SMNvAi7ekAxyUTr/boti4h+88sYBA=
X-Google-Smtp-Source: ABdhPJx6AaQ6Q8FW3C83d5yBxYs6ooX+cO24DxhcJhGBkrvbtKFh+VTJ5HW/4Hg1uioc/Ph8rdOMBA==
X-Received: by 2002:a1c:2402:: with SMTP id k2mr22119343wmk.138.1595259626689; 
 Mon, 20 Jul 2020 08:40:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id u20sm6328432wmc.42.2020.07.20.08.40.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 08:40:26 -0700 (PDT)
Date: Mon, 20 Jul 2020 16:40:21 +0100
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 07/37] KVM: arm64: Separate SError detection from VAXorcism
Message-ID: <20200720154021.GA2383032@google.com>
References: <20200715184438.1390996-1-ascull@google.com>
 <20200715184438.1390996-8-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200715184438.1390996-8-ascull@google.com>
Cc: maz@kernel.org
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

On Wed, Jul 15, 2020 at 07:44:08PM +0100, Andrew Scull wrote:
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index e727bee8e110..c441aabb8ab0 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -177,7 +177,6 @@ el2_error:
>  	adr	x1, abort_guest_exit_end
>  	ccmp	x0, x1, #4, ne
>  	b.ne	__hyp_panic
> -	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
>  	eret
>  	sb

Having looked at this again, I also meant to remove the hunk below. It
used to check that the SError had actually been taken through the
exception vector but I am removing that.

However, do I need to continue doing that check to make sure the SError
didn't get cancelled (if that is possible) or some other architectural
phenomenon happened that I haven't factored in to my thinking?

--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -210,13 +222,8 @@ abort_guest_exit_end:
 
         msr     daifset, #4     // Mask aborts
	  
-       // If the exception took place, restore the EL1 exception
-       // context so that we can report some information.
-       // Merge the exception code with the SError pending bit.
-       tbz     x0, #ARM_EXIT_WITH_SERROR_BIT, 1f
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
