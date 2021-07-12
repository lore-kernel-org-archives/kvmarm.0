Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D09C07E99
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 16:36:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 759B161221
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 16:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 759B161221
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A2F40870;
	Mon, 12 Jul 2021 12:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pCN6VUVtawwv; Mon, 12 Jul 2021 12:36:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C81F64083E;
	Mon, 12 Jul 2021 12:36:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 864D240821
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 12:36:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jZKphhJpNCkb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jul 2021 12:36:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 867C1407F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 12:36:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626107812;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=MtrPeL1MW5g9H7qmJOUpT+3Y4CWR41HGQODgw/zxeBs=;
 b=gRVYqrRYr/O0Xs8gh7WUoBjPIfvrJs0fyabPdf3ks++Wj1nPANLMChPL0eQLhAdeHU/p10
 o9qmLGAZ7xRxCPopJ5w+vk9E4gG4ZGU9LnWPoIVd2DyIF1r6SABVO7mMO5FH2k0nyfx3Hp
 DFqvO9n0FGFo/dEunRiIGMEOcwHlKYc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-Sxoj3lI7Oxqb1UaqPt_kjw-1; Mon, 12 Jul 2021 12:36:50 -0400
X-MC-Unique: Sxoj3lI7Oxqb1UaqPt_kjw-1
Received: by mail-io1-f72.google.com with SMTP id
 i13-20020a5d88cd0000b02904e5ab8bdc6cso12196633iol.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 09:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MtrPeL1MW5g9H7qmJOUpT+3Y4CWR41HGQODgw/zxeBs=;
 b=NsjAk37woh3htfa2Lg4etsnsO/deGCAls6uRTGN+5SUB6X+iYc6JFyy6E/1tg5DCzi
 UGIfgEuCfwH0RrRxXuSDubRKPrzR2XOhhrQL/tWfRDPi1pqaQoPEoIhu607pU3pxsBfg
 al9aU3f2oRzrlCHILo5N1LydG2o92tRcyKY6Nm7qd4j8MOQSZrXZkAOUcNVLnGVF8R5O
 MOBgTNhQFf8CH1dcFjxXG4oY74MQQwg7rRh5jbN1Qh9ynIt0G84FkxhXO7B8yn8MHKDv
 rWcPdfg6W+FI6OUPpOjSDr+JsnX+sRlCZGMZ0LnuqDyVOvjqVBLE5G6WaGZy8F2duxuE
 dalQ==
X-Gm-Message-State: AOAM531CfrjKpTSKWQSke2ZNZtuYP65OJLbB6c9OGICCtAGTiA/mBvJK
 j6ItSMaGNEnqcoyJJccBMrtWM+ZexYkm5EhfbfzW7DBB7K2xwyxiDXmzhfnpvFDpb9srXJrMwJn
 z6gBrz0OJ5I766otG2tt1C+D2
X-Received: by 2002:a05:6638:3594:: with SMTP id
 v20mr44398399jal.25.1626107810377; 
 Mon, 12 Jul 2021 09:36:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfZs7GgsE/lzYFDtyQMKvJJdBgqUsxHSeDXSOj4Dft5q8ck5jfD4jmnOq1o4WYVKlXhNT6cA==
X-Received: by 2002:a05:6638:3594:: with SMTP id
 v20mr44398375jal.25.1626107810195; 
 Mon, 12 Jul 2021 09:36:50 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id m24sm8288360ion.3.2021.07.12.09.36.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Jul 2021 09:36:49 -0700 (PDT)
Date: Mon, 12 Jul 2021 18:36:47 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Message-ID: <20210712163647.oxntpjapur4z23sl@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210702163122.96110-2-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com,
 frankja@linux.ibm.com, kvm@vger.kernel.org, david@redhat.com,
 andre.przywara@arm.com, cohuck@redhat.com, kvm-ppc@vger.kernel.org,
 vivek.gautam@arm.com, maz@kernel.org, pbonzini@redhat.com,
 imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Jul 02, 2021 at 05:31:18PM +0100, Alexandru Elisei wrote:
> The arm64 tests can be run under kvmtool, which doesn't emulate a
> chr-testdev device. In preparation for adding run script support for
> kvmtool, print the test exit status so the scripts can pick it up and
> correctly mark the test as pass or fail.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/chr-testdev.h |  1 +
>  lib/arm/io.c      | 10 +++++++++-
>  lib/chr-testdev.c |  5 +++++
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
> index ffd9a851aa9b..09b4b424670e 100644
> --- a/lib/chr-testdev.h
> +++ b/lib/chr-testdev.h
> @@ -11,4 +11,5 @@
>   */
>  extern void chr_testdev_init(void);
>  extern void chr_testdev_exit(int code);
> +extern bool chr_testdev_available(void);
>  #endif
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 343e10822263..9e62b571a91b 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -125,7 +125,15 @@ extern void halt(int code);
>  
>  void exit(int code)
>  {
> -	chr_testdev_exit(code);
> +	if (chr_testdev_available()) {
> +		chr_testdev_exit(code);

chr_testdev_exit() already has a 'if !vcon goto out' in it, so you can
just call it unconditionally. No need for chr_testdev_available().

> +	} else {
> +		/*
> +		 * Print the test return code in the format used by chr-testdev
> +		 * so the runner script can parse it.
> +		 */
> +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> +	}
>  	psci_system_off();
>  	halt(code);
>  	__builtin_unreachable();
> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> index b3c641a833fe..301e73a6c064 100644
> --- a/lib/chr-testdev.c
> +++ b/lib/chr-testdev.c
> @@ -68,3 +68,8 @@ void chr_testdev_init(void)
>  	in_vq = vqs[0];
>  	out_vq = vqs[1];
>  }
> +
> +bool chr_testdev_available(void)
> +{
> +	return vcon != NULL;
> +}
> -- 
> 2.32.0
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
