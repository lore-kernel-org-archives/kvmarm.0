Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67E8C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 10:42:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36D4764E9D
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 10:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36D4764E9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 968DF4B3B5;
	Mon,  1 Feb 2021 05:42:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4YBwrvTJpFX8; Mon,  1 Feb 2021 05:42:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB0E94B2BE;
	Mon,  1 Feb 2021 05:42:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BB044B1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 05:42:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YHadwc-qFTA2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 05:42:54 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 699E34B159
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 05:42:54 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id q7so15982449wre.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2021 02:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KdljAzvVi5//s6op/UovX5xLDFP4TmnwHCTlJ043Sgk=;
 b=oDc7dLdep+fwQDEfn8GKNdZwRpnBo6pbFxId8749NzFRiSokjVe3DGWPKGRscTKK+K
 4uwbAOmL8cdT5tnvzsCWkSs17w/qwu2amo5Z3VgvXadbhwvMy/gOM08WBIcfdYRG+Fwf
 8/rN00FPZygg5ZVzcKauVFZnt6AtClTUkTAe+vOJ08sDUqm6VXcefnNio8jJswex+lkZ
 YpGywOvETDx/20tlLBCaFeJTUyiPAB7ttMps/767ajZUfsCgiWKWZNmPfpbW72jJu2h5
 hOea0XYe7cUUPfWv9aVdiuqCXNBrRZB/uBMqg8j5LUwlx9PaUOzVEXXgZCBtKYs+XwsF
 53/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KdljAzvVi5//s6op/UovX5xLDFP4TmnwHCTlJ043Sgk=;
 b=e5a6Ef/Gw8i1Xy/DwTPwv3tMy3XTJsGwrS8qHprhYNa/0UDH+mPJ551NPgotHGlYcu
 GhJ2ypMgYvEDzJA8AztiDJN6avl95LScschd1pPHceWtn2rT98cQP0rSWNx7Lm6xhva9
 ImqxX/eMOL8vyt1qRb7o2LzYMwydAHVcT9KjEneiGeK4tn5R1kXmDcoKOg9P1tOcNnZ4
 9BrqWUD6bDJ8QvwIHsgnWVMqXABdMi+B5W0hFdY+SKKc19BLmQLNkCVEWloe3Z9XW+ur
 LhJ/yHLGkJ5LiFM44k3pGAgG5ERuGvO3P/g52rPP0k9luyNuuqK+JNN+iwHjm+C2/Sej
 a5AA==
X-Gm-Message-State: AOAM531Pb+DSRcIHLTbsH4SgJOhzy/Pi++AVLP2tl+drc3z5Q3WtxoSe
 yfn918Ppd0orcvJhkZIv/5ZsgQ==
X-Google-Smtp-Source: ABdhPJydmzBGxSKJDIIxBGPgQq5UBMTmfHPMLAkRE0ySxb9liEtdsEzf3CE1EZZkSpxZNhIt/1nYkA==
X-Received: by 2002:adf:e90d:: with SMTP id f13mr17047307wrm.371.1612176173319; 
 Mon, 01 Feb 2021 02:42:53 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:1007:9eb8:9b35:92ae])
 by smtp.gmail.com with ESMTPSA id t15sm4716534wmi.48.2021.02.01.02.42.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 01 Feb 2021 02:42:52 -0800 (PST)
Date: Mon, 1 Feb 2021 10:42:51 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/8] KVM: arm64: Generate hyp relocation data
Message-ID: <20210201104251.5foc64qq3ewgnhuz@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
 <20210105180541.65031-5-dbrazdil@google.com>
 <20210129214325.GA195322@roeck-us.net>
 <87r1m2lets.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87r1m2lets.wl-maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Guenter Roeck <linux@roeck-us.net>
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

Thanks for writing the fix, Marc! There are no corner cases in this code so
if it boots, that should be a good indicator that all BE inputs were converted.

Just one little thing I noticed below, otherwise:
Acked-by: David Brazdil <dbrazdil@google.com>

>  arch/arm64/kvm/hyp/nvhe/Makefile     |  1 +
>  arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 57 ++++++++++++++++++++--------
>  2 files changed, 42 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 268be1376f74..09d04dd50eb8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -7,6 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
>  
>  hostprogs := gen-hyprel
> +HOST_EXTRACFLAGS += -I$(srctree)/include
This should be $(objtree), autoconf.h is generated.

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
