Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C91C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 17:45:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3784A49EAE;
	Thu, 17 Mar 2022 13:45:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ceTP1ik4kw-N; Thu, 17 Mar 2022 13:45:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 157F949EC2;
	Thu, 17 Mar 2022 13:45:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D492F49EAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 13:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PzIr5WFa9eaL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 13:45:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 908FF49E17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 13:45:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647539112;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=2jSZntopo5lj3lX97AHm+Bt3POGDsH+Rw9wQ2NJBUtQ=;
 b=aR+dRsi2GVNS+dVSdjY/fFYG0R7ey+2VMGIclYSkVUSWPEoLPu9wTTzPVAbhaLo5mSijKJ
 4mVavy8lTJI3lbGIbpgR5wy79/p3QCuJw8+jld4OnpDcj/opWhx1cukwwmfJTOZlDcCftC
 BwCn9+eky40unW3QeK5e2odDYe/OR8g=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-KIHSkYGxNR6NaLHpkKLh7Q-1; Thu, 17 Mar 2022 13:45:10 -0400
X-MC-Unique: KIHSkYGxNR6NaLHpkKLh7Q-1
Received: by mail-ej1-f72.google.com with SMTP id
 hy26-20020a1709068a7a00b006dfa034862cso1064206ejc.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 10:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2jSZntopo5lj3lX97AHm+Bt3POGDsH+Rw9wQ2NJBUtQ=;
 b=G66f5oSWQMgRpuqi568khJqZkHAe82apH6PLNmnQ059/gQCfL0LG1zGkVdcF25jcvj
 PcGbxqO2BuH332p0IOXNHKaZjeXAcRqw7AUusq+2ltXR+Z9iNnrQJLwGEYOgKRgFmSSw
 Y5Tw+gp5GUnHMVcK5BE2BajL/4qweASIus1ms51ojJJbDQkv3qZKMTm9X+4Qz+SCTN6H
 NJexP4MTq0uIHh9jsJz7i/1Oau3QBtcFLiwcTjXnoNwjp7CG/1zAoRFuXYath3xhGyTL
 WgrU2WaCZtlmOvC7VzKYUZIzKO2LiHQt+W6dvp8/HDAXMHVsmV8W9wPzS5odubnHP+gs
 Am9g==
X-Gm-Message-State: AOAM531rJKiey+Cx8JZIWLjYDBvX2hWwu6w/1bGF+26uGvBjDH08nmG/
 5IAUhuCfJqt62KKH415BT7kYtyi2HzZkr81JFrn99D9+zwcKUeN7HChBstGFvrzAybWmFvlb5CR
 PmTCi6lNj4nG3SM548sE37q/t
X-Received: by 2002:a17:907:3f86:b0:6db:b745:f761 with SMTP id
 hr6-20020a1709073f8600b006dbb745f761mr5351772ejc.610.1647539109574; 
 Thu, 17 Mar 2022 10:45:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw07m+uKi8TwSUle9H2N2prBjnYvm79oDP4Lqt9N6Gdp5ucxXVDZSzZrzPZTYFL8YPxAdRODw==
X-Received: by 2002:a17:907:3f86:b0:6db:b745:f761 with SMTP id
 hr6-20020a1709073f8600b006dbb745f761mr5351757ejc.610.1647539109354; 
 Thu, 17 Mar 2022 10:45:09 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 w14-20020a170906d20e00b006cee22553f7sm2715187ejz.213.2022.03.17.10.45.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Mar 2022 10:45:09 -0700 (PDT)
Date: Thu, 17 Mar 2022 18:45:07 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm/run: Use TCG with qemu-system-arm on
 arm64 systems
Message-ID: <20220317174507.jt2rattmtetddvsq@gator>
References: <20220317165601.356466-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20220317165601.356466-1-alexandru.elisei@arm.com>
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

On Thu, Mar 17, 2022 at 04:56:01PM +0000, Alexandru Elisei wrote:
> From: Andrew Jones <drjones@redhat.com>
> 
> If the user sets QEMU=qemu-system-arm on arm64 systems, the tests can only
> be run by using the TCG accelerator. In this case use TCG instead of KVM.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> [ Alex E: Added commit message ]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/run | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index 28a0b4ad2729..128489125dcb 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
>  fi
>  processor="$PROCESSOR"
>  
> -ACCEL=$(get_qemu_accelerator) ||
> +accel=$(get_qemu_accelerator) ||
>  	exit $?
>  
> -if [ "$ACCEL" = "kvm" ]; then
> +if [ "$accel" = "kvm" ]; then
>  	QEMU_ARCH=$HOST
>  fi
>  
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> +if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> +   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> +   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> +	accel=tcg
> +fi
> +
> +ACCEL=$accel
> +
>  if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
>  	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
>  	exit 2
> -- 
> 2.35.1
>

Ha, OK, I guess you posting this is a strong vote in favor of this
behavior. I've queued it

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
