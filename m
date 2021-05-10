Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7B2C433ED
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 06:40:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C34A66143C
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 06:40:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C34A66143C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DE8F4B300;
	Mon, 10 May 2021 02:40:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PQ7oHwIdYGF5; Mon, 10 May 2021 02:40:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC8754B276;
	Mon, 10 May 2021 02:40:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6B6C4B276
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 02:40:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MEVVdGYjHuVR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 02:40:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C357A4B26C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 02:40:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620628854;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=AhkvvC0oMUJmsEQCW6Q1nd0/KwtGO4qGTTgVWNfA7vM=;
 b=Igt4ggngxHsZbauKxw5vh7cAinzcxm62D2vZwqr0uoIV54LBWzrgjWXnP9rv6NudvYw7rA
 rfLi1+waPi4eMP3iUPXcjbgW+cBKYBHFTW+98aJpMNRSkaZ/zcYFJOPBoZCRIyKDjHP1w3
 u0fPJw0W9wbR/3vHxAbhIWULqT2o2Yo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-ukc9ir8fOIaFkiZjK0lK0w-1; Mon, 10 May 2021 02:40:52 -0400
X-MC-Unique: ukc9ir8fOIaFkiZjK0lK0w-1
Received: by mail-ed1-f69.google.com with SMTP id
 w20-20020aa7dcd40000b02903886b9b0013so8531079edu.22
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 May 2021 23:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AhkvvC0oMUJmsEQCW6Q1nd0/KwtGO4qGTTgVWNfA7vM=;
 b=NF1nXoWLu3CDLnZALaMRKbuHwHOEigU7NMkoOzhFRljHm/5oTXiFh9N1HkO3xnjwat
 kngEPFlov6Xaa6s4w51hKhY6afHtIxprstahtioa4j1HnVG/kDPWjojFMxnXCd5QWu5X
 tFJUMVbvz5LPSzvGzLVNoonlUWeR7w1hra43ellxgCLZD9EGtW1PERBLUR5KQeN7gTIp
 +QY4dO6uKECTAJvaNYDcZznyoLaCxjQPNxmhBcnx8fn+WhoWkQXVC9pZ/SZVgCR6peOL
 Eer0WPo4v7rF64GwiKfUmCknkoJgezAWF0ojGqMV/r9+SH2EdplA936c6/E2cx6BHGMY
 dxQQ==
X-Gm-Message-State: AOAM533Im6mzjhAfi8VmH5P70m/lvYVQVVhd7oHdw0yzaK5TfqmISLJk
 ChyETDkXyKsyOpZrTmn5ACKerY7wRVfmPrK2a1AlL8gDr3qnsbccygBfvkwxC2GjdWed3dpD/JH
 X241yJvowb5OqNi3M3O6nxVCh
X-Received: by 2002:a05:6402:3585:: with SMTP id
 y5mr27515702edc.233.1620628851386; 
 Sun, 09 May 2021 23:40:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy79W7vGg+HWZl+58lL8SGrEdJrYPWGAcRD5CxRhKSms3qnClb4ZaME1e4VxVzhNQ90K2UDtw==
X-Received: by 2002:a05:6402:3585:: with SMTP id
 y5mr27515677edc.233.1620628851164; 
 Sun, 09 May 2021 23:40:51 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id g11sm2970883edt.85.2021.05.09.23.40.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 09 May 2021 23:40:50 -0700 (PDT)
Date: Mon, 10 May 2021 08:40:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 4/6] KVM: arm64: selftests: get-reg-list: Provide config
 selection option
Message-ID: <20210510064048.m7ezciiratbesqjj@gator>
References: <20210507200416.198055-1-drjones@redhat.com>
 <20210507200416.198055-5-drjones@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210507200416.198055-5-drjones@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, pbonzini@redhat.com
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

On Fri, May 07, 2021 at 10:04:14PM +0200, Andrew Jones wrote:
> Add a new command line option that allows the user to select a specific
> configuration, e.g. --config:sve will give the sve config. Also provide
> help text and the --help/-h options.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 76 +++++++++++++++++--
>  1 file changed, 70 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 68d3be86d490..f5e122b6b257 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -38,6 +38,17 @@
>  #define reg_list_sve() (false)
>  #endif
>  
> +enum {
> +	VREGS,
> +	SVE,
> +};
> +
> +static char * const vcpu_config_names[] = {
> +	[VREGS] = "vregs",
> +	[SVE] = "sve",
> +	NULL
> +};
> +
>  static struct kvm_reg_list *reg_list;
>  static __u64 *blessed_reg, blessed_n;
>  
> @@ -502,34 +513,87 @@ static void run_test(struct vcpu_config *c)
>  	kvm_vm_free(vm);
>  }
>  
> +static void help(void)
> +{
> +	char * const *n;
> +
> +	printf(
> +	"\n"
> +	"usage: get-reg-list [--config:<selection>[,<selection>...]] [--list] [--list-filtered] [--core-reg-fixup]\n\n"
> +	" --config:<selection>[,<selection>...] Used to select a specific vcpu configuration for the test/listing\n"

I just realized I left this <selection>[,<selection>...] help text and
some other kruft, like the vcpu_config_names[] array, from a different
design I scrapped. That design, which used getsubopt(), was more
complicated than it was worth.

I'll send a v2 to get this cleaned up, but I'll wait a day or so first
for more comments.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
