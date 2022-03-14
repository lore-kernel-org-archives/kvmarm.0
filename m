Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54218C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 08:42:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A9E549EC1;
	Mon, 14 Mar 2022 04:42:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oH5UzkWDhN4N; Mon, 14 Mar 2022 04:42:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5301549E44;
	Mon, 14 Mar 2022 04:42:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A024049E3F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 04:42:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f6wHmU39Pih4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 04:41:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD0440BDC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 04:41:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647247316;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=M3D+kmvpUzavdeadIHI+7mtJKsMBrFU+PHp7YJEyOeA=;
 b=HURdRCT+qRzn/BfCAVSZajmLjBafJdKGVxDLty4vCt3oZ+Yp+TVFiAKMDUEEyn4rHHxaO7
 a3CRjE+LNFj4olQa3+Qv0VRxiP9x5xEfCfZkC645pP75Nb+2KCFb9SpF339Osce19PMBKr
 Enol6lRScpx4MUHe5DLaG01USe5p71A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-4PKhYTqBMcaa7ubEDiXD4Q-1; Mon, 14 Mar 2022 04:41:53 -0400
X-MC-Unique: 4PKhYTqBMcaa7ubEDiXD4Q-1
Received: by mail-wm1-f70.google.com with SMTP id
 r133-20020a1c448b000000b00385c3f3defaso5431556wma.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 01:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=M3D+kmvpUzavdeadIHI+7mtJKsMBrFU+PHp7YJEyOeA=;
 b=iQWmVsJTycm0BhJ1gebulTZOsVIwwjRL0dyQm+JBn9Gk3QCukVAcZBcHKsuLlZoBJW
 ofJQXMYmYXqiSfnS2lmxx5lzMiJhWv1vLL4e5GkI9oh81KXtT11FQ8ghaISu6Vie6Nkq
 GDImL30m/eNTE5/dCeMGBAnT8Wys+xnW8G/uc1qNHDDwZDh+k5s7e7+jfPOMjiu/GyUo
 +yvvYKMwxnUSh4lEn/FLOwiFPT+t/e6RXzhGqTcOELwbAFOf8CIltmmQ4ZAd/pIXureH
 4IpgBm4lXOVX6+72c1ekpj6WUU12R7yafh2VBk2kjXL3dQiba1sqEL3+BUVE0hQg1gy7
 7g0A==
X-Gm-Message-State: AOAM532beHb9cFS+OqiVChmvhCbaTDtMBLZ95zhgrfORFTHGLmjZdx6W
 DOKMJ8hrJPNOqGIOss5VLrEQrP5y+UP7awjdXii3FUhp9gFMRqQk7F47K4+GCks3OrxhfaL1EQj
 M6L4afde22XAOlhAPlf8iWBc+
X-Received: by 2002:a05:6000:1682:b0:203:9380:abb1 with SMTP id
 y2-20020a056000168200b002039380abb1mr12241041wrd.484.1647247311799; 
 Mon, 14 Mar 2022 01:41:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWBeQDPBJCLBl+4A2igfAKGP0tax9FakuuYz2eay80du3+AIGhsA/k41Upzwe4YooQCZG8jQ==
X-Received: by 2002:a05:6000:1682:b0:203:9380:abb1 with SMTP id
 y2-20020a056000168200b002039380abb1mr12241019wrd.484.1647247311452; 
 Mon, 14 Mar 2022 01:41:51 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 k12-20020adfb34c000000b001f1e13df54dsm12841674wrd.89.2022.03.14.01.41.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Mar 2022 01:41:51 -0700 (PDT)
Date: Mon, 14 Mar 2022 09:41:49 +0100
From: Andrew Jones <drjones@redhat.com>
To: Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Fix typos
Message-ID: <20220314084149.tgrs2cbzp7ttsftg@gator>
References: <20220311170850.2911898-1-thuth@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220311170850.2911898-1-thuth@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Fri, Mar 11, 2022 at 06:08:50PM +0100, Thomas Huth wrote:
> Correct typos which were discovered with the "codespell" utility.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/cstart.S              | 2 +-
>  arm/gic.c                 | 2 +-
>  arm/micro-bench.c         | 2 +-
>  lib/arm64/asm/assembler.h | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 2401d92..7036e67 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -44,7 +44,7 @@ start:
>  
>  	/*
>  	 * set stack, making room at top of stack for cpu0's
> -	 * exception stacks. Must start wtih stackptr, not
> +	 * exception stacks. Must start with stackptr, not
>  	 * stacktop, so the thread size masking (shifts) work.
>  	 */
>  	ldr	sp, =stackptr
> diff --git a/arm/gic.c b/arm/gic.c
> index 1e3ea80..60457e2 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -909,7 +909,7 @@ static void test_its_pending_migration(void)
>  	gicv3_lpi_rdist_disable(pe0);
>  	gicv3_lpi_rdist_disable(pe1);
>  
> -	/* lpis are interleaved inbetween the 2 PEs */
> +	/* lpis are interleaved between the 2 PEs */
>  	for (i = 0; i < 256; i++) {
>  		struct its_collection *col = i % 2 ? collection[0] :
>  						     collection[1];
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index c731b1d..8436612 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -265,7 +265,7 @@ static void timer_post(uint64_t ntimes, uint64_t *total_ticks)
>  {
>  	/*
>  	 * We use a 10msec timer to test the latency of PPI,
> -	 * so we substract the ticks of 10msec to get the
> +	 * so we subtract the ticks of 10msec to get the
>  	 * actual latency
>  	 */
>  	*total_ticks -= ntimes * (cntfrq / 100);
> diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
> index a271e4c..aa8c65a 100644
> --- a/lib/arm64/asm/assembler.h
> +++ b/lib/arm64/asm/assembler.h
> @@ -32,7 +32,7 @@
>   * kvm-unit-tests has no concept of scheduling.
>   *
>   * 	op:		operation passed to dc instruction
> - * 	domain:		domain used in dsb instruciton
> + * 	domain:		domain used in dsb instruction
>   * 	addr:		starting virtual address of the region
>   * 	size:		size of the region
>   * 	Corrupts:	addr, size, tmp1, tmp2
> -- 
> 2.27.0
>

Applied to arm/queue.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
