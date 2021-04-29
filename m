Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B3FC43461
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 14:41:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96E2A6145B
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 14:41:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96E2A6145B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 044FF4B377;
	Thu, 29 Apr 2021 10:41:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8gZ3A9HeuM5M; Thu, 29 Apr 2021 10:41:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAA504B36D;
	Thu, 29 Apr 2021 10:41:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFCB34B36A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 10:41:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ODgF1ARvTpI8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 10:41:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 934684B369
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 10:41:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619707293;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xuXI8WbytCjzlShJ6hpRX4oLXXWI11SEtwQvo6ESyvo=;
 b=TRSJMpwYsgVM3myrMidKLx44c/6Oxh6dob7raC2XG4aAMG2AwAEH/IG3Ebj76pdybvOqGZ
 2p2eguB4PHGrkdK6/9B8IEObtefAFwvspPm8EsVzpwcvUOo2riINo4NfSQTx+r6aCRHRiO
 +hSZdAdyfhmZx/BpMzUrvoY8mV1sDp8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-HAPvKMstMY2zhUm77u__8A-1; Thu, 29 Apr 2021 10:41:31 -0400
X-MC-Unique: HAPvKMstMY2zhUm77u__8A-1
Received: by mail-ed1-f70.google.com with SMTP id
 h13-20020a05640250cdb02903790a9c55acso28797122edb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 07:41:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xuXI8WbytCjzlShJ6hpRX4oLXXWI11SEtwQvo6ESyvo=;
 b=Ul7y7G6GOaEWWd9zOIVHqSCw9DhmavT+zRXp5ziPARCm8/k7YxM1YROPBfM4G6w7ac
 0NuuMNQOR1EOWo2Lq1HI1iZArGYnyZ5eqHAN4FceylEHxYvklK/RIahusKsGWXMn4SBn
 m7lKQ7DQH7XtNGp3QaeT8fXzh3CsG1/vH03ZRXptPU08VEnFT0aIBd9+RPqd/yxnLbuS
 qERuwyzOTG9RMrqIs7HWvsRqSNsyxjBesVXv73pNqtGfyJX0YkIanp3MWYWT4PPH43aV
 EEMXUth69SmFdjtMK0ENBpbE5rtl76kwqTBDHM93n2rro231PFlStgeUbGbvl1+TesZr
 HdQQ==
X-Gm-Message-State: AOAM532eE3VK5n/yyMNOrfZtQ2QUPfs/4PiNhBHjtSGWre5MPuHmLLQg
 JNZf/UkxdJS5Y7Lxtq1exo6RlTdS82a7lMdTAHgXbCt+cYjJLLle21CJRrvJ/kBNzMxD8PjaExj
 wFeZ4Lu2PAiK8esXxJQrcDGg+
X-Received: by 2002:a05:6402:5203:: with SMTP id
 s3mr18501778edd.360.1619707290373; 
 Thu, 29 Apr 2021 07:41:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrIL7coZCsSIfxJlhgbwG2Z8UKHVm79pl60hkgoMG718BNmVPQQZ8S+x3fVv7iMrnwUFgfzQ==
X-Received: by 2002:a05:6402:5203:: with SMTP id
 s3mr18501753edd.360.1619707290118; 
 Thu, 29 Apr 2021 07:41:30 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id g22sm99240ejz.46.2021.04.29.07.41.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Apr 2021 07:41:29 -0700 (PDT)
Date: Thu, 29 Apr 2021 16:41:27 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v3] configure: arm: Replace --vmm with
 --target
Message-ID: <20210429144127.anb26s7hrfpwarjf@gator>
References: <20210429141204.51848-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210429141204.51848-1-alexandru.elisei@arm.com>
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

On Thu, Apr 29, 2021 at 03:12:04PM +0100, Alexandru Elisei wrote:
> The --vmm configure option was added to distinguish between the two virtual
> machine managers that kvm-unit-tests supports for the arm and arm64
> architectures, qemu or kvmtool. There are plans to make kvm-unit-tests work
> as an EFI app, which will require changes to the way tests are compiled.
> Instead of adding a new configure option specifically for EFI and have it
> coexist with --vmm, or overloading the semantics of the existing --vmm
> option, let's replace --vmm with the more generic name --target.
> 
> Since --target is only valid for arm and arm64, reject the option when it's
> specified for another architecture, which is how --vmm should have behaved
> from the start.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Changes in v3:
> 
> * Using --target for any architecture other than arm and arm64 generates an
>   error.
> * Don't generate the TARGET variable in config.mak for other architectures.
> * Cosmetic changes to the commit message.
> 
> Changes in v2:
> 
> * Removed the RFC tag and cover letter.
> * Removed --vmm entirely.
> 
>  configure | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/configure b/configure
> index 01a0b262a9f2..d5d223fe3a90 100755
> --- a/configure
> +++ b/configure
> @@ -21,7 +21,7 @@ pretty_print_stacks=yes
>  environ_default=yes
>  u32_long=
>  wa_divide=
> -vmm="qemu"
> +target=
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
> @@ -146,6 +146,15 @@ arch_name=$arch
>  [ "$arch" = "aarch64" ] && arch="arm64"
>  [ "$arch_name" = "arm64" ] && arch_name="aarch64"
>  
> +if [ -z "$target" ]; then
> +    target="qemu"
> +else
> +    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
> +        echo "--target is not supported for $arch"
> +        usage
> +    fi
> +fi
> +
>  if [ -z "$page_size" ]; then
>      [ "$arch" = "arm64" ] && page_size="65536"
>      [ "$arch" = "arm" ] && page_size="4096"
> @@ -177,13 +186,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
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

I switched the quotes from " to ', e.g. 'qemu'.

>          usage
>      fi
>  
> @@ -318,6 +327,11 @@ WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
>  EOF
> +if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
> +cat <<EOF >> config.mak
> +TARGET=$target
> +EOF

I changed this to

    echo "TARGET=$target" >> config.mak

> +fi
>  
>  cat <<EOF > lib/config.h
>  #ifndef CONFIG_H
> -- 
> 2.31.1
> 

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
