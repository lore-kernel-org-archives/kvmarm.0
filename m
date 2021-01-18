Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F88C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:15:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 063F722B49
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:15:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 063F722B49
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F42B4B29F;
	Mon, 18 Jan 2021 08:15:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y8mH3-Bm+A1V; Mon, 18 Jan 2021 08:15:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 523D64B2A1;
	Mon, 18 Jan 2021 08:15:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA894B272
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:15:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GimUZfSAGxVD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:15:00 -0500 (EST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96B0E4B24B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:15:00 -0500 (EST)
Received: by mail-wr1-f43.google.com with SMTP id q18so16447832wrn.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 05:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/8+eCjMadN4hEryRCq5t61h0Kw3XOPXiND7TB0YLFkM=;
 b=POEfM+et/dcTeVjJtAwq/2yXoy6V3wf7ul3s27ev5mHWELYMXtXCj7/gO6jo59jZVn
 cs5u23n+N+VtOZrULvMG1Q/dEXmAM6xLLHcc3B0s/Zay9YGRESfIMny06wivrXUKnB+X
 Fw/lmIJxeH1zTm5V+bkKESe2/3nYIfaBPfGjnqLUpQn2Co6f2TdJsPp6pGDzB69pPXXV
 WsI0Vis835YnO0tVbq9uo/yoKVMoOs2CI93pguLm3mYL1BvBYfpknR7l0LVn21222UHK
 ir8LfXPL4tlSTHEDH3+YxSGGb4KDBD29ojK6NhRpvKS/wKUTx8xqiM5fMY6IW2AP7VNB
 uisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/8+eCjMadN4hEryRCq5t61h0Kw3XOPXiND7TB0YLFkM=;
 b=RQLqfMMh46tqVEzQ/PAdQGb70YhKrbS8iPkSWplwylDboIFCzzzLdaWjF04LwgPiG8
 0fuYYvHABUZDPN0ltJpYmf/yEjjfV6JQwCNKonRTrFuf5oQZwGW43DcJpKLvVVFTP73p
 u4tf4IPa/ebO6/nDI71wE2em/8AE4Wu7KLOVuOHaK8GTJUosNIy5VvK3boOBHAfaTWIq
 AGG2Mnm9veovXkcj9S7Fc6DeDZk+PEzyuANdO1dP01YhHzkO+LrhrnT+s+wouJprDrqK
 eHSPCZxU7quzwK09WgP7zV69r5EwEeOUAYx+S85VZOqYd7KNddk1QIak0lTHTQ7vYFA+
 7m0Q==
X-Gm-Message-State: AOAM5318K8qHuyRsrlARczQBeqxz5iraCEVHc4yN8yi3Va1FB/2MAY1q
 PgrPi/KJ8UYdmliW2bZxzYivAw==
X-Google-Smtp-Source: ABdhPJzmPlfcSrGqBJwt+ReFSFMEuRuGZv6bGgz8c75Q6bbIP50Hu5TPT8/BskwWGDST3jm1ca0mEA==
X-Received: by 2002:adf:ae01:: with SMTP id x1mr25557426wrc.381.1610975699419; 
 Mon, 18 Jan 2021 05:14:59 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id h23sm4761819wmi.26.2021.01.18.05.14.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 05:14:58 -0800 (PST)
Date: Mon, 18 Jan 2021 13:14:57 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 14/21] arm64: Honor VHE being disabled from the
 command-line
Message-ID: <20210118131457.47ppbilsaq7cdtft@google.com>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-15-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-15-maz@kernel.org>
Cc: kernel-team@android.com, Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>, Will Deacon <will@kernel.org>,
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

On Mon, Jan 18, 2021 at 09:45:26AM +0000, Marc Zyngier wrote:
> Finally we can check whether VHE is disabled on the command line,
> and not enable it if that's the user's wish.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>

> ---
>  arch/arm64/kernel/hyp-stub.S | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 59820f9b8522..bbab2148a2a2 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -77,13 +77,24 @@ SYM_CODE_END(el1_sync)
>  SYM_CODE_START_LOCAL(mutate_to_vhe)
>  	// Sanity check: MMU *must* be off
>  	mrs	x0, sctlr_el2
> -	tbnz	x0, #0, 1f
> +	tbnz	x0, #0, 2f
>  
>  	// Needs to be VHE capable, obviously
>  	mrs	x0, id_aa64mmfr1_el1
>  	ubfx	x0, x0, #ID_AA64MMFR1_VHE_SHIFT, #4
> -	cbz	x0, 1f
> +	cbz	x0, 2f
>  
> +	// Check whether VHE is disabled from the command line
> +	adr_l	x1, id_aa64mmfr1_val
> +	ldr	x0, [x1]
> +	adr_l	x1, id_aa64mmfr1_mask
> +	ldr	x1, [x1]
super nit: There's a ldr_l macro

> +	ubfx	x0, x0, #ID_AA64MMFR1_VHE_SHIFT, #4
> +	ubfx	x1, x1, #ID_AA64MMFR1_VHE_SHIFT, #4
> +	cbz	x1, 1f
> +	and	x0, x0, x1
> +	cbz	x0, 2f
> +1:
>  	// Engage the VHE magic!
>  	mov_q	x0, HCR_HOST_VHE_FLAGS
>  	msr	hcr_el2, x0
> @@ -152,7 +163,7 @@ skip_spe:
>  	orr	x0, x0, x1
>  	msr	spsr_el1, x0
>  
> -1:	eret
> +2:	eret
>  SYM_CODE_END(mutate_to_vhe)
>  
>  .macro invalid_vector	label
> -- 
> 2.29.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
