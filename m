Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37ABEC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 08:58:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ABEEB2065F
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 08:58:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HbVh+hzk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABEEB2065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A82B4B0F5;
	Mon, 15 Jun 2020 04:58:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id weMFlIahdATu; Mon, 15 Jun 2020 04:58:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D48FF4B0F1;
	Mon, 15 Jun 2020 04:58:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAB194B0B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 04:58:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JkKL-NzT8VzH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 04:58:13 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED2144B0EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 04:58:12 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id u26so13599345wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 01:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5ShxQ/p8QgWJk316YAyJ/2tQifOc4oxip3xhjWlqJEQ=;
 b=HbVh+hzk5EMCxM8HGK4hG1KrtSz8Nm/Y6fwcA3KHzRcyUFMqNhJy20y/BVVd2vSQvW
 AErfOfpMe734o02wktzcMFgR2BX2dgnZYwJBZBldKTZIq5SUyVfg6nNP/80txEzIAfmr
 +gb9uCi7jZtYrv0+/5lGpjxNz/DoagX/I2qFwY72TakjZb6Sh35Zd0czsvw7EDfJ5z3k
 EN/5hItz0s1wsQl+L0hGFE+IoKsaUbQoG012t9KJh2NbSfJwm8+qau8Y2Q6Scr/2YEur
 DwiK8g9gUopMHDDNckOxXOcZH1JVHtGStDfFIanwt5BVtw+qlwkJWamTCGWX3ZrDsgTi
 aTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5ShxQ/p8QgWJk316YAyJ/2tQifOc4oxip3xhjWlqJEQ=;
 b=fKg8u5RkWaZE4//GE7WMo9bHPp/1Qr8KLv4ZDsa9wCGv+X32e9WWISek8pG89JbotT
 NFE3emhTh0sKWMsawcf5ki2jowMpyFU4BajHjRW6TezfeThCmi1zWlsHb9PySSTUHp4w
 CamtkG9mpMUADAt0NbmlaZ7z587/KlCaIqhlxWC+MZVL50V5NJxEv4F4YNI1BcVKEPys
 REzsLdLu58g9bFEPU2FAf2g/uNkE8wHDBkMSMT48rwbjwvblWU+hZo0XnPmu7rv0d6KC
 ZoaMl46rbD5YJ/QAGxjg7j42uXjUEJ/jhTNm9LVgirRhRkNDKATwDLpnvPH4sHYHFFJT
 REOw==
X-Gm-Message-State: AOAM532os8PV40F7AXPpirRhmaDtWSB3AuyVM9BI/Q4ouwZk/4eBYldl
 Q78uYekpor/zhJlc5zymBJpF5w==
X-Google-Smtp-Source: ABdhPJwLOxCm//URtwLoljmFofuNMfLd0PKuFSaN0kqqtlnaKFsHDaMnEqPiaGR8skUD0V+QZBoTjA==
X-Received: by 2002:a1c:7d4c:: with SMTP id y73mr11858831wmc.188.1592211491868; 
 Mon, 15 Jun 2020 01:58:11 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id y80sm21776273wmc.34.2020.06.15.01.58.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 15 Jun 2020 01:58:11 -0700 (PDT)
Date: Mon, 15 Jun 2020 09:58:06 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/4] KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
Message-ID: <20200615085806.GE177680@google.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-3-maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jun 15, 2020 at 09:19:52AM +0100, Marc Zyngier wrote:
> We currently prevent PtrAuth from even being built if KVM is selected,
> but VHE isn't. It is a bit of a pointless restriction, since we also
> check this at run time (rejecting the enabling of PtrAuth for the
> vcpu if we're not running with VHE).
> 
> Just drop this apparently useless restriction.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/Kconfig | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 31380da53689..d719ea9c596d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1516,7 +1516,6 @@ menu "ARMv8.3 architectural features"
>  config ARM64_PTR_AUTH
>  	bool "Enable support for pointer authentication"
>  	default y
> -	depends on !KVM || ARM64_VHE
>  	depends on (CC_HAS_SIGN_RETURN_ADDRESS || CC_HAS_BRANCH_PROT_PAC_RET) && AS_HAS_PAC
>  	# GCC 9.1 and later inserts a .note.gnu.property section note for PAC
>  	# which is only understood by binutils starting with version 2.33.1.
> @@ -1543,8 +1542,7 @@ config ARM64_PTR_AUTH
>  
>  	  The feature is detected at runtime. If the feature is not present in
>  	  hardware it will not be advertised to userspace/KVM guest nor will it
> -	  be enabled. However, KVM guest also require VHE mode and hence
> -	  CONFIG_ARM64_VHE=y option to use this feature.
> +	  be enabled.
>  
>  	  If the feature is present on the boot CPU but not on a late CPU, then
>  	  the late CPU will be parked. Also, if the boot CPU does not have

...and we just got the patch to let EL2 use the ptrauth instructions for
the save restore in hyp/entry.S!

Acked-by: Andrew Scull <ascull@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
