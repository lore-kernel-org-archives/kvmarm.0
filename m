Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E35C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 10:21:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1BFF610FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 10:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F1BFF610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F43A4B20D;
	Tue,  7 Sep 2021 06:21:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VbBq+aVx38+c; Tue,  7 Sep 2021 06:21:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6654B22C;
	Tue,  7 Sep 2021 06:21:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BC94B20A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 06:21:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x+JylORKJGQ9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 06:21:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2FF64B1D5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 06:21:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631010099;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=f++tlxFdFC82weLDV66fZEVmzKayy0iCTttWnFQCXr8=;
 b=e6ZsVgtH6oRx1GPqy4h0nkawtKKqgyqd+P/u7N1oLUT3x15wm694WqmzVi4UKAiWDoK1kD
 FuaBKRSHBBE4HYWeEfLeBwB7qGA2WxCFrZ+uy1h9RMWoZEDzKgX3AsU/svPzPDAXs5dF0u
 AFBKlDZCxQ40VMtpyUQYb67I3BHOUHM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-bf5aejcjN_uHh_HmGK4U3w-1; Tue, 07 Sep 2021 06:21:38 -0400
X-MC-Unique: bf5aejcjN_uHh_HmGK4U3w-1
Received: by mail-wr1-f71.google.com with SMTP id
 p10-20020adfce0a000000b001572d05c970so1952197wrn.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 03:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=f++tlxFdFC82weLDV66fZEVmzKayy0iCTttWnFQCXr8=;
 b=SHsFhF+v4jZ4qzYcWtEymD10YRcCLrMw71mG32qOXMDcta70FC9C0eEwn9LYLDUWvJ
 539fI+0w+3YXnSV6wJ9xKm9b46eCpcl1EilwlyRc0W+sehCLBUAx5pTdc0f+wR1WrTFD
 GH9yrjVNOHtzm15Bjc/YL8Fp4a4A20MP1gwr687UKog0X24vuipCmC8S1qq0llQfePBE
 GuRx48tcHKrl0uo+QkQJCWx93zB+DaEbbyLuPWFgCY38fyjFmEzFzvymYlPrrAvMIm/I
 QhiuXBUEyaVcESAzhB0ZwTTdQkN2r9TLfPlzOQ6Q6elC6Zf5pwwpgH2U9zXgRpLUavqj
 ueyQ==
X-Gm-Message-State: AOAM531rOEGrLTVU1wIUSB10Txr1HF4Rdjq/c/OmlHJ+4J2chkPv81aN
 q1k7EXb7dOBYr/9X0owqudrYNXpkT1ezG8NKvgK83hmJx3HLi8R2STI24iEiDdNdGbXImcRsBS9
 5Kaw1NI5GGQdK+6H2oocdeqW8
X-Received: by 2002:a05:6000:1563:: with SMTP id
 3mr18583602wrz.139.1631010097382; 
 Tue, 07 Sep 2021 03:21:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVgROHRJDcbz9ILwMhdnSZ3oJA6YdR1KgI9MywkZ1Cjk4U3iVAKCDYVZQ+gA4/zuyHOdxqyQ==
X-Received: by 2002:a05:6000:1563:: with SMTP id
 3mr18583578wrz.139.1631010097179; 
 Tue, 07 Sep 2021 03:21:37 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id p5sm11270858wrd.25.2021.09.07.03.21.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Sep 2021 03:21:36 -0700 (PDT)
Date: Tue, 7 Sep 2021 12:21:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 4/5] scripts: Generate kvmtool
 standalone tests
Message-ID: <20210907102135.i2w3r7j4zyj736b5@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-5-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210702163122.96110-5-alexandru.elisei@arm.com>
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

On Fri, Jul 02, 2021 at 05:31:21PM +0100, Alexandru Elisei wrote:
> Add support for the standalone target when running kvm-unit-tests under
> kvmtool.
> 
> Example command line invocation:
> 
> $ ./configure --target=kvmtool
> $ make clean && make standalone
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/mkstandalone.sh | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 16f461c06842..d84bdb7e278c 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -44,6 +44,10 @@ generate_test ()
>  	config_export ARCH_NAME
>  	config_export PROCESSOR
>  
> +	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
> +		config_export TARGET
> +	fi

Should export unconditionally, since we'll want TARGET set
unconditionally.

> +
>  	echo "echo BUILD_HEAD=$(cat build-head)"
>  
>  	if [ ! -f $kernel ]; then
> @@ -59,7 +63,7 @@ generate_test ()
>  		echo 'export FIRMWARE'
>  	fi
>  
> -	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> +	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then

I think it would be better to ensure that ENVIRON_DEFAULT is "no" for
TARGET=kvmtool in configure.


>  		temp_file ERRATATXT "$ERRATATXT"
>  		echo 'export ERRATATXT'
>  	fi
> @@ -95,12 +99,8 @@ function mkstandalone()
>  	echo Written $standalone.
>  }
>  
> -if [ "$TARGET" = "kvmtool" ]; then
> -	echo "Standalone tests not supported with kvmtool"
> -	exit 2
> -fi
> -
> -if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> +if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
> +		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
>  	exit 2
>  fi
> -- 
> 2.32.0
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
