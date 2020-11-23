Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F1FC6379D
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 12:34:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 391272076E
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 12:34:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="M992dxd2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 391272076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6698D4BB1B;
	Mon, 23 Nov 2020 07:34:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nKEmJXjDRTLp; Mon, 23 Nov 2020 07:34:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6291A4BA30;
	Mon, 23 Nov 2020 07:34:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 045C54B844
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 07:34:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q3hJ3FhFRWoy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 07:34:28 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A35BE4B80F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 07:34:28 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id x13so7604673wmj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 04:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=9ZjO/kg/ZyQBzHgAo7+6n9tS4H4jKirnAxxmVXvH/yc=;
 b=M992dxd2tit7xNFnltCm7IKEDMdlnmQGCe8L5HxLpyARAZse097Av2j/VAIWecNH3m
 bJD+3EDrsh/k+G08pWWz5IJCJd1iwyLpBdfnINWsvXgBH0tfbK2u04BrazZWO+Jo49zy
 yh3iWmzRhuMtjd2JI7q+Gb5w9cjBK3HqqCmSre9UFgSOna7kNL626foIzmVYCIrYe/93
 Qp5+sKy4TAindANud2ZsE1u/VMhU0+QZZ4fy+VOQ5k8mbFKCyHOL4BGH/49geVbGKALP
 aed65X9OM2QRaPt6uBOY49PSxEmgZcC/XdnzywKBaD0U8jyA3urZlDqlFsWzPdOkG0nh
 VjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9ZjO/kg/ZyQBzHgAo7+6n9tS4H4jKirnAxxmVXvH/yc=;
 b=DRUTW62vLRL3Pq77iG2ji4Nousd4yjK54iVhtzMGZvYnVJ9Exhvcw8eSbB3zOlcuAS
 PcArNh5daioxxVFL/BseA3UtiQl4BRCXFHwIRjLx3t6413eKfWp9yUVSox9vkwGr8sCY
 J4xW6/XlTIKZ81eEQodlhDOGrifEKjmh3RbLSYxdNfteVi7F+N1lGvafds5nk0dpwI5F
 pF6SCccvfFYBWc6fMP+tgyQXolj/0g8GFu7t859BrCA5NEyE/QUtCvmUBxGX9cbapWOD
 FGNgZpJSrjCaI8HlkszdXI94gkoaLxEE1xwqKT6n6VOF7IkmlERW9Rslf8N6EoLBNQ2d
 eWkg==
X-Gm-Message-State: AOAM530jEte6wnwh3oqNXay5Z2BJAG9cFBWGKJxFqb5dqdQKWhqOSdC4
 v4L5tr9z2xgox7Dx85SsKMk1XQ==
X-Google-Smtp-Source: ABdhPJwSjPl1MftPJmQUSt0CDAQ26Ikg4YZNe+FEtt3uYPrzCayTOdXmpbrYKg2gwpnbE1eL73qqnQ==
X-Received: by 2002:a1c:7e87:: with SMTP id
 z129mr23400394wmc.176.1606134867262; 
 Mon, 23 Nov 2020 04:34:27 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:acac:b2ef:c7d:fd8a])
 by smtp.gmail.com with ESMTPSA id j71sm16889889wmj.10.2020.11.23.04.34.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 04:34:26 -0800 (PST)
Date: Mon, 23 Nov 2020 12:34:25 +0000
From: David Brazdil <dbrazdil@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 02/27] KVM: arm64: Link position-independent string
 routines into .hyp.text
Message-ID: <20201123123425.uzfuk3pmwgzuijwn@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-3-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201117181607.1761516-3-qperret@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Tue, Nov 17, 2020 at 06:15:42PM +0000, 'Quentin Perret' via kernel-team wrote:
> From: Will Deacon <will@kernel.org>
> 
> Pull clear_page(), copy_page(), memcpy() and memset() into the nVHE hyp
> code and ensure that we always execute the '__pi_' entry point on the
> offchance that it changes in future.
> 
> [ qperret: Commit title nits ]
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kernel/image-vars.h   | 11 +++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile |  4 ++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 8539f34d7538..dd8ccc9efb6a 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -105,6 +105,17 @@ KVM_NVHE_ALIAS(__stop___kvm_ex_table);
>  /* Array containing bases of nVHE per-CPU memory regions. */
>  KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
>  
> +/* Position-independent library routines */
> +__kvm_nvhe_clear_page			= __kvm_nvhe___pi_clear_page;
> +__kvm_nvhe_copy_page			= __kvm_nvhe___pi_copy_page;
> +__kvm_nvhe_memcpy			= __kvm_nvhe___pi_memcpy;
> +__kvm_nvhe_memset			= __kvm_nvhe___pi_memset;
> +
> +#ifdef CONFIG_KASAN
> +__kvm_nvhe___memcpy			= __kvm_nvhe___pi_memcpy;
> +__kvm_nvhe___memset			= __kvm_nvhe___pi_memset;
> +#endif
> +
>  #endif /* CONFIG_KVM */

Nit: Would be good to use the kvm_nvhe_sym() helper for the namespacing.
And feel free to define something like KVM_NVHE_ALIAS for PI in hyp-image.h.

>  
>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 1f1e351c5fe2..590fdefb42dd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -6,10 +6,14 @@
>  asflags-y := -D__KVM_NVHE_HYPERVISOR__
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
>  
> +lib-objs := clear_page.o copy_page.o memcpy.o memset.o
> +lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> +
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
>  	 hyp-main.o hyp-smp.o psci-relay.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o ../exception.o
> +obj-y += $(lib-objs)
>  
>  ##
>  ## Build rules for compiling nVHE hyp code
> -- 
> 2.29.2.299.gdc1121823c-goog
> 
> -- 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
