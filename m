Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C61FC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 10:25:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8AFE5610FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 10:25:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8AFE5610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02DF44B1FE;
	Tue,  7 Sep 2021 06:25:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x3FNgG2NonCS; Tue,  7 Sep 2021 06:25:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 011194B20D;
	Tue,  7 Sep 2021 06:25:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E49B4B1D5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 06:25:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ByqF9mvqA-1g for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 06:25:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 258E94B1A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 06:25:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631010340;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=YkR6zwo7S5sLkEP3Hl3y8Gt+KIK6HBJlddNqv1cks4k=;
 b=cfwsFXwEPTJ6sEweVQxvKrjHf84Somzk53aAWWZtPeEuL+0ZicFJta/XDrUTOFZ2oLoiMF
 gg9wzVF5eQl9zV2yo5EoeFZ610krN50Ti03B1rRcQHR/x2CVVerNy4541CnRiEGS8JiUZI
 +JQCpw+bkbOMHImcDDS/YfhlRG08RSU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-ceTigRwGOGytZT7AJXw-Og-1; Tue, 07 Sep 2021 06:25:39 -0400
X-MC-Unique: ceTigRwGOGytZT7AJXw-Og-1
Received: by mail-wr1-f72.google.com with SMTP id
 v6-20020adfe4c6000000b001574f9d8336so1952461wrm.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 03:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=YkR6zwo7S5sLkEP3Hl3y8Gt+KIK6HBJlddNqv1cks4k=;
 b=Y/HZLKiWN1Ca9HNgCcv0zo5cwy942FS0ZHrPaYmX9vtPiG8FNICYBtNEZbQgvgKdD9
 DUKXMLBo9R5sX7a9pDhls/Mee8sq+R6OVaSbbq1fnKp8vIROYAM72RcJwgqF+7uHKzlg
 EQNg97Pb+HU4lifhSuJRNfbRL0m2GifLy7jfSTVCKtlJHc1HbJjYyGx6KKGdkc4XLdsR
 daqqlb8u1uKz0bfwVTlYH+1uq5lUg21Xf0Z3fwsPckHxiyVhLkOjVp2IHyFXfW2W4hKs
 sN2nuo3WCyzOdQ2ZPq5u37CddSbGlbNnBBtfziR3tHBznXh1VERPT53GymTNqrU0sOFZ
 91Eg==
X-Gm-Message-State: AOAM533fJo1N3TR94zMz74Q750W4sUIXHWY+zO8GESCAvgEQEKiMV+5K
 aQdBLx2eZ3J1oUBxorekriLCwhsXFzzK8NiCrCW97OV8ZH26KMbKcNaoe+aYNwnxpCj9b0yWYUH
 +YySFWdvB8VCUc8ZBGXVv1efz
X-Received: by 2002:a5d:6486:: with SMTP id o6mr17366328wri.193.1631010338753; 
 Tue, 07 Sep 2021 03:25:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSuexDTec5nPjCkxud+p5tgz5pAvum9LG2zR+d+af/JuudrOVT+AYs0JNtNTuoPUbk+lGqwQ==
X-Received: by 2002:a5d:6486:: with SMTP id o6mr17366315wri.193.1631010338595; 
 Tue, 07 Sep 2021 03:25:38 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id t11sm2252710wmi.23.2021.09.07.03.25.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Sep 2021 03:25:38 -0700 (PDT)
Date: Tue, 7 Sep 2021 12:25:36 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 5/5] configure: Ignore --erratatxt
 when --target=kvmtool
Message-ID: <20210907102536.jhycvnazlmj7qyto@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-6-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210702163122.96110-6-alexandru.elisei@arm.com>
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

On Fri, Jul 02, 2021 at 05:31:22PM +0100, Alexandru Elisei wrote:
> kvmtool runs a test using the -f/--firmware argument, which doesn't load an
> initrd, making specifying an errata file useless. Instead, configure forces
> all erratas to be enabled via the CONFIG_ERRATA_FORCE define in
> lib/config.h.
> 
> Forbid the --erratatxt option when kvm-unit-tests is configured for kvmtool
> and let the user know that all erratas are enabled by default.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> I'm not sure if printing an error is too strong here and a simple warning would
> suffice. Suggestions welcome!
> 
>  configure | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/configure b/configure
> index 395c809c9c02..acd288239f80 100755
> --- a/configure
> +++ b/configure
> @@ -24,7 +24,8 @@ u32_long=
>  wa_divide=
>  target=
>  errata_force=0
> -erratatxt="$srcdir/errata.txt"
> +erratatxt_default="$srcdir/errata.txt"
> +erratatxt="_NO_FILE_4Uhere_"
>  host_key_document=
>  page_size=
>  earlycon=
> @@ -50,7 +51,8 @@ usage() {
>  	                           enable or disable the generation of a default environ when
>  	                           no environ is provided by the user (enabled by default)
>  	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
> -	                           '--erratatxt=' to ensure no file is used.
> +	                           '--erratatxt=' to ensure no file is used. This option is
> +	                           invalid for arm/arm64 when target=kvmtool.

Do we need to always specifiy arm/arm64 when talking about target=kvmtool?
How much more effort would an x86 kvmtool target be to add?

>  	    --host-key-document=HOST_KEY_DOCUMENT
>  	                           Specify the machine-specific host-key document for creating
>  	                           a PVM image with 'genprotimg' (s390x only)
> @@ -147,11 +149,6 @@ if [ -n "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
>      exit 1
>  fi
>  
> -if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
> -    echo "erratatxt: $erratatxt does not exist or is not a regular file"
> -    exit 1
> -fi
> -
>  arch_name=$arch
>  [ "$arch" = "aarch64" ] && arch="arm64"
>  [ "$arch_name" = "arm64" ] && arch_name="aarch64"
> @@ -184,6 +181,21 @@ else
>      fi
>  fi
>  
> +if [ "$target" = "kvmtool" ]; then
> +    if [ "$erratatxt" ] && [ "$erratatxt" != "_NO_FILE_4Uhere_" ]; then
> +        echo "--erratatxt is not supported for target=kvmtool (all erratas enabled by default)"
> +        usage
> +    fi
> +else
> +    if [ "$erratatxt" = "_NO_FILE_4Uhere_" ]; then
> +        erratatxt=$erratatxt_default
> +    fi
> +    if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
> +        echo "erratatxt: $erratatxt does not exist or is not a regular file"
> +        exit 1
> +    fi
> +fi

switch

> +
>  [ -z "$processor" ] && processor="$arch"
>  
>  if [ "$processor" = "arm64" ]; then
> -- 
> 2.32.0
>

Otherwise looks good to me.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
