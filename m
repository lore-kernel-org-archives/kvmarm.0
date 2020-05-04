Return-Path: <SRS0=W6Rg=6S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4913BC3A5A9
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 13:26:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B803D2073E
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 13:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kwvVnxsK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B803D2073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 320EE4B3E6;
	Mon,  4 May 2020 09:26:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s7imdXvLGSPS; Mon,  4 May 2020 09:26:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2568D4B3BA;
	Mon,  4 May 2020 09:26:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCEA24B35A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 09:26:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id roZ7+NXffHbL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2020 09:26:53 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9B944B359
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 09:26:53 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id z6so9046956wml.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2020 06:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=33pkChYD7LRAV3nJqXmcztwY7L3ow37tVUm2UQkyz90=;
 b=kwvVnxsK1R4pAUawSofRbWm8njcmT48vygwQNSBmOdmrN5kmzdAGSOjW/WdVM5wO3G
 /P4Iq64N4iVT9VfRvKkUyZcCxH5mxxZSqHD4kRvCctVcR2NL6wNvMzCsLPgwjEKuqmp5
 CFXDE/2w3IJoi5dTRX56zZTLcEH9dS/IcqBWvmgqzSyVcz8WLskEYL5NEC0jFQxDfcAc
 brnCR4msKHAOOhuTzuvmG3uXo1a//gJ53RXZv9qHWLqBG50idPSD6Uaz7Uy6WFxjxqFk
 Dk7FigDZpWQ/MoK4b59iKWK4NQmIRXva5Yf+zERJ3uPJ9XpiXKkQSZXHJHLASbf7qK9I
 4l1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=33pkChYD7LRAV3nJqXmcztwY7L3ow37tVUm2UQkyz90=;
 b=Dp+oqB8fzKns0HDhhNPDXOWyzQPtxFRlf5UgOdSFymJLFbMBLEYbA+nWGJqomxzFJc
 ggDx7Y18DdKb/Al0ToAtLI2RnNAWW72zf2nemzf/gRLoc4JjkzPj+fmrNWkoMzGy5OD/
 RpyhQEq4ri47xzLbsBcsgpoi7IkCpmK+C0gb1utSI0qBX6lDyQXTGZ+cw6RjGDyeL1Ns
 GofDnZ50RrAbKGEdtuzXElbRsYL4VYSvSPyJ+cFQsiEs+6So6c614pfIN+OtGaEGdeN0
 Gak0FdvGScvVzvNbe6au7Co3QvRw2rU9xORWeD6wstA1oCIKGj4NwjyRKLldxFDNfeo0
 nfVg==
X-Gm-Message-State: AGi0PuZe7dvsVBCgmL/JD4kyHZXgnletNmkOKN+bOUh66oef6jUejEzC
 Xcdz6vEoRfXJ3CEp08H0HpNivQ==
X-Google-Smtp-Source: APiQypIcEaNIlR2r2uifAcSNxheTVZ+5pLg/bxvLAmCy3jkxacHldceB7teRqq6cww9uFS5IvBCxCQ==
X-Received: by 2002:a1c:b757:: with SMTP id h84mr14629721wmf.188.1588598812383; 
 Mon, 04 May 2020 06:26:52 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:d6cc:2030:37c1:9964])
 by smtp.gmail.com with ESMTPSA id f23sm12887772wml.4.2020.05.04.06.26.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 May 2020 06:26:51 -0700 (PDT)
Date: Mon, 4 May 2020 14:26:48 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 4/4] KVM: arm64: Clean up kvm makefiles
Message-ID: <20200504132648.GA65651@google.com>
References: <20200421131734.141766-1-tabba@google.com>
 <20200421131734.141766-5-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200421131734.141766-5-tabba@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Fuad,

On Tuesday 21 Apr 2020 at 14:17:34 (+0100), Fuad Tabba wrote:
> Consolidate references to the CONFIG_KVM configuration item to encompass
> entire folders rather than per line.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/Makefile     | 40 ++++++++++++-------------------------
>  arch/arm64/kvm/hyp/Makefile | 15 ++++----------
>  2 files changed, 17 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 419696e615b3..5354ca1b1bfb 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -10,30 +10,16 @@ KVM=../../../virt/kvm
>  obj-$(CONFIG_KVM) += kvm.o
>  obj-$(CONFIG_KVM) += hyp/
>  
> -kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> -kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
> -kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
> -kvm-$(CONFIG_KVM) += psci.o perf.o
> -kvm-$(CONFIG_KVM) += hypercalls.o
> -kvm-$(CONFIG_KVM) += pvtime.o
> -
> -kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
> -kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
> -kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
> -kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
> -kvm-$(CONFIG_KVM) += aarch32.o
> -kvm-$(CONFIG_KVM) += arch_timer.o
> -kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
> -
> -kvm-$(CONFIG_KVM) += vgic/vgic.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-init.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-its.o
> -kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
> +kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
> +	 $(KVM)/vfio.o $(KVM)/irqchip.o \
> +	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
> +	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
> +	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
> +	 vgic-sys-reg-v3.o fpsimd.o pmu.o pmu-emul.o \

Should we keep pmu-emul.o conditional on CONFIG_KVM_ARM_PMU?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
