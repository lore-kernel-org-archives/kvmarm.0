Return-Path: <SRS0=XU7X=JY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06F5C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 17:10:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3518C613E5
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 17:10:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3518C613E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 978C74B16D;
	Tue, 27 Apr 2021 13:10:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i1W3cX8R5-r6; Tue, 27 Apr 2021 13:10:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A9934B172;
	Tue, 27 Apr 2021 13:10:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD044B15F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 13:10:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pRvgMnspVJGp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Apr 2021 13:10:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 445774B15A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 13:10:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619543417;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=C2Sf4ABwZ69tuh9yBcDqXJGyy1ZZ54o5G9Q7ZZIQnos=;
 b=DhkmgBXt3cerMLAQnITvjbEB/RAKAhH281O8fBYrEWFkn4qbVm3gfcCVcaGoBM4ULLQnIs
 EpC6pLpu5koGILrbyOZ9MeA5bQSqsTweaVoEFvVfJGDzjSTg2skzd2rLmawuT+qFbq4Akk
 SgRF20H67uyCOMHR+gzPOKzvtvQJSi8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-DI83jIicOjqpMjXxND50kw-1; Tue, 27 Apr 2021 13:10:15 -0400
X-MC-Unique: DI83jIicOjqpMjXxND50kw-1
Received: by mail-ej1-f72.google.com with SMTP id
 yh1-20020a17090706e1b029038d0f848c7aso2200805ejb.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 10:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=C2Sf4ABwZ69tuh9yBcDqXJGyy1ZZ54o5G9Q7ZZIQnos=;
 b=n9Fs9fE9uW7gkwW1Q5SYsrKNzDi0dFRY7q3oJUEwJnSnYDcwSlLas36t42s4rJXAN7
 clxlt3euh6BlLasGM4xN/A5MXKfAb1CrlFV8HG5dEyqjrDyMTaPoI1WUKQZm2/u8F5eZ
 9rk4dqiMupy1BD6C825yaIcYqbqvI9q2bLz0OENzqvFncQL5vXPEzyQHGdny0OWiwURw
 M2GKXts1f0b63ifcrpdssA/OkQ57A+Jes8qgA6zElGPnh2mMgkGi/jWwNW9U+d0/pDEu
 VVFCY7ntRLUqZqTQl0JWG22GnlBV/XZtb9o2P6rM0A7hatgrkkzru1woKoPv4UKS7+Yx
 OyFQ==
X-Gm-Message-State: AOAM533T8u9sJCydQIffB10sItTTR7yHR+JF4PvXhVMlcOoNUk21MxZS
 ct9uSbqFU5AuBJoit/5zTkQA4ESjRzXNOimHSxMQ/muOdEUq4YPJXfvXYDpRET/7hE1GviVX1zq
 tEz0ObM+8EqhZ8mf8D5EcZfc/
X-Received: by 2002:a05:6402:3109:: with SMTP id
 dc9mr5677613edb.13.1619543413979; 
 Tue, 27 Apr 2021 10:10:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB1bTSrBv7eL5ESsqyHUsok/cKDQZo8Jx2cXyrR0WSAdcEfUJ7kBZIiCmgxEChxnhyKT/ArA==
X-Received: by 2002:a05:6402:3109:: with SMTP id
 dc9mr5677588edb.13.1619543413796; 
 Tue, 27 Apr 2021 10:10:13 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id hd30sm270127ejc.59.2021.04.27.10.10.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Apr 2021 10:10:13 -0700 (PDT)
Date: Tue, 27 Apr 2021 19:10:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v2] configure: arm: Replace --vmm with
 --target
Message-ID: <20210427171011.ymu7j5sen76c4xb3@gator.home>
References: <20210427163437.243839-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210427163437.243839-1-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Apr 27, 2021 at 05:34:37PM +0100, Alexandru Elisei wrote:
> The --vmm configure option was added to distinguish between the two virtual
> machine managers that kvm-unit-tests supports, qemu or kvmtool. There are
> plans to make kvm-unit-tests work as an EFI app, which will require changes
> to the way tests are compiled. Instead of adding a new configure option
> specifically for EFI and have it coexist with --vmm, or overloading the
> semantics of the existing --vmm option, let's replace --vmm with the more
> generic name --target.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Changes in v2:
> 
> * Removed the RFC tag and cover letter.
> * Removed --vmm entirely.
> 
>  configure | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/configure b/configure
> index 01a0b262a9f2..08c6afdf952c 100755
> --- a/configure
> +++ b/configure
> @@ -21,7 +21,7 @@ pretty_print_stacks=yes
>  environ_default=yes
>  u32_long=
>  wa_divide=
> -vmm="qemu"
> +target="qemu"
>  errata_force=0
>  erratatxt="$srcdir/errata.txt"
>  host_key_document=
> @@ -35,8 +35,8 @@ usage() {
>  	Options include:
>  	    --arch=ARCH            architecture to compile for ($arch)
>  	    --processor=PROCESSOR  processor to compile for ($arch)
> -	    --vmm=VMM              virtual machine monitor to compile for (qemu
> -	                           or kvmtool, default is qemu) (arm/arm64 only)
> +	    --target=TARGET        target platform that the tests will be running on (qemu or
> +	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
>  	    --cc=CC		   c compiler to use ($cc)
>  	    --ld=LD		   ld linker to use ($ld)
> @@ -58,7 +58,7 @@ usage() {
>  	    --earlycon=EARLYCON
>  	                           Specify the UART name, type and address (optional, arm and
>  	                           arm64 only). The specified address will overwrite the UART
> -	                           address set by the --vmm option. EARLYCON can be one of
> +	                           address set by the --target option. EARLYCON can be one of
>  	                           (case sensitive):
>  	               uart[8250],mmio,ADDR
>  	                           Specify an 8250 compatible UART at address ADDR. Supported
> @@ -88,8 +88,8 @@ while [[ "$1" = -* ]]; do
>          --processor)
>  	    processor="$arg"
>  	    ;;
> -	--vmm)
> -	    vmm="$arg"
> +	--target)
> +	    target="$arg"
>  	    ;;
>  	--cross-prefix)
>  	    cross_prefix="$arg"
> @@ -177,13 +177,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>      testdir=x86
>  elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      testdir=arm
> -    if [ "$vmm" = "qemu" ]; then
> +    if [ "$target" = "qemu" ]; then
>          arm_uart_early_addr=0x09000000
> -    elif [ "$vmm" = "kvmtool" ]; then
> +    elif [ "$target" = "kvmtool" ]; then
>          arm_uart_early_addr=0x3f8
>          errata_force=1
>      else
> -        echo '--vmm must be one of "qemu" or "kvmtool"!'
> +        echo '--target must be one of "qemu" or "kvmtool"!'
>          usage
>      fi
>  
> @@ -317,6 +317,7 @@ U32_LONG_FMT=$u32_long
>  WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
> +TARGET=$target

We should only emit this TARGET=qemu to the config.mak when we're
arm/arm64, since that's what the help text says. Also, because the help
text says that the --target option is only for arm/arm64, then configure
should error out if it's used with another architecture. The nice thing
about this rename is that we can get that right this time. We didn't error
out with --vmm, but we should have. Erroring out on an unsupported
feature allows us to add support for it later without the users having
to guess if it'll work or not.

Thanks,
drew

>  EOF
>  
>  cat <<EOF > lib/config.h
> -- 
> 2.31.1
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
