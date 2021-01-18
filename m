Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8386C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 09:53:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1198320771
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 09:53:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1198320771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 429204B1E2;
	Mon, 18 Jan 2021 04:53:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a7o+Js5adXzL; Mon, 18 Jan 2021 04:53:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2392A4B237;
	Mon, 18 Jan 2021 04:53:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 002954B228
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 04:53:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GyW5HIadqecW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 04:53:53 -0500 (EST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A92D04B1E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 04:53:53 -0500 (EST)
Received: by mail-wm1-f45.google.com with SMTP id r4so13189656wmh.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 01:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=o6jQxvrdg4qy2EZL9N8xtit/ocZhA3/uVnMS0C547Vs=;
 b=bWs/iuftHz+PV+7azX+PPueBRNaKcm8Aswspr7cdp6br161cqyo1C3q0AZ6KRLiz5G
 +H+or0jMkO+QMHs9om3G6i/tq/3KotYssKySfHSuglxD8TzkkJJSsMrBs6IWxnJ0cWKk
 eZ+ZaXooYnj6U/NSv2cwee2gBg/F2TgUtchRWdKcQ8WGR9zRQTG+3fQ3zxH1jhnJpFih
 gV+j3huAbMfbXI6hzxt+7y9BHo79RhyhZyyKwlt8yc65jazDFJapmY4bVEduUfieBg9g
 Fh1TtWlLbWgESVKCtfOG1mRSEzmoKre3omZtsz9cuhRMzqhSq3h51RMNpiThwOLhNnnk
 AGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=o6jQxvrdg4qy2EZL9N8xtit/ocZhA3/uVnMS0C547Vs=;
 b=sTqA3Kc+OIVVM1BBg390Qa1BjlixMzqy0KUNsglaJZj8OktPBuoQ5XogcJfaQXOw6H
 N3ejSvKkiFV+vK1QXyjKdLL8dAOA+vrE2bnyOAVqDQ/dBwJ52EDMXG3mz44GodwARuD9
 ylvJROXQnZ6bREjIC74CJ765QtI1Mrft2ZDXPsasIZRMU6kEDiWMPD5LYCwhfUyroof8
 PM3E6GfNJAtA4hi7JVFzzSVxEteH5Y8yHOz+IstjR2FDHs1wwZHdvHhXPmv/5WY9b49Y
 PEX9jVayJ8GUZDAA+CPNsTCxuEyQf0ci0gr4XRRNkAqexSzkVim2DjsoSVgdpNjBwHPO
 WFmw==
X-Gm-Message-State: AOAM531DDQ/uG8Z0Bgbq+84cu95axZYFuQ9Iqfd6ik7vhmtocafGEbSo
 MU1xYoodm1TVpLl3D1EN9BImXg==
X-Google-Smtp-Source: ABdhPJzhvh9f1x5ilf1AmvBGKQ2Mc38ag05TWKgHPLr2/mNrAIPJWbDg+1F5AUFIqTqv+z6yQt/nqQ==
X-Received: by 2002:a1c:6283:: with SMTP id
 w125mr19819076wmb.155.1610963632505; 
 Mon, 18 Jan 2021 01:53:52 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id f68sm15081928wmf.6.2021.01.18.01.53.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 01:53:51 -0800 (PST)
Date: Mon, 18 Jan 2021 09:53:50 +0000
From: David Brazdil <dbrazdil@google.com>
To: Elena Petrova <lenaptr@google.com>
Subject: Re: [PATCH v3 1/9] KVM: arm64: Enable UBSan instrumentation in nVHE
 hyp code
Message-ID: <20210118095350.j5dy7om6dfn276cj@google.com>
References: <20210115171830.3602110-1-lenaptr@google.com>
 <20210115171830.3602110-2-lenaptr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210115171830.3602110-2-lenaptr@google.com>
Cc: George-Aurelian Popescu <georgepope@google.com>,
 Marc Zyngier <maz@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 kvmarm@lists.cs.columbia.edu, George Popescu <george.apopescu97@gmail.com>,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Jan 15, 2021 at 05:18:22PM +0000, Elena Petrova wrote:
> From: George-Aurelian Popescu <georgepope@google.com>
> 
> Implement UBSan handlers inside nVHe hyp code, as empty functions for the
> moment, so the undefined behaviours, that are triggered there, will be
> linked to them, not to the ones defined in kernel-proper lib/ubsan.c.
> 
> In this way, enabling UBSAN_MISC won't cause a link error.

The commit message needs to be updated - UBSAN_MISC does not exist any longer.
Also "nVHe" is a typo.

Other than that:
Acked-by: David Brazdil <dbrazdil@google.com>

> 
> Signed-off-by: Elena Petrova <lenaptr@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/ubsan.c  | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/ubsan.c
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 1f1e351c5fe2..2a683e7c6c5b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,6 +10,8 @@ obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
>  	 hyp-main.o hyp-smp.o psci-relay.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o ../exception.o
> +obj-$(CONFIG_UBSAN) += ubsan.o
> +CFLAGS_ubsan.nvhe.o += -I $(srctree)/lib/
>  
>  ##
>  ## Build rules for compiling nVHE hyp code
> @@ -61,7 +63,6 @@ KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAG
>  # cause crashes. Just disable it.
>  GCOV_PROFILE	:= n
>  KASAN_SANITIZE	:= n
> -UBSAN_SANITIZE	:= n
>  KCOV_INSTRUMENT	:= n
>  
>  # Skip objtool checking for this directory because nVHE code is compiled with
> diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> new file mode 100644
> index 000000000000..a5db6b61ceb2
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2020 Google LLC
> + * Author: George Popescu <georgepope@google.com>
> + */
> +#include <linux/ctype.h>
> +#include <linux/types.h>
> +#include <ubsan.h>
> +
> +void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
> +
> +void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs) {}
> +
> +void __ubsan_handle_mul_overflow(void *_data, void *lhs, void *rhs) {}
> +
> +void __ubsan_handle_negate_overflow(void *_data, void *old_val) {}
> +
> +void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs) {}
> +
> +void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
> +
> +void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
> +
> +void __ubsan_handle_out_of_bounds(void *_data, void *index) {}
> +
> +void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
> +
> +void __ubsan_handle_builtin_unreachable(void *_data) {}
> +
> +void __ubsan_handle_load_invalid_value(void *_data, void *val) {}
> -- 
> 2.30.0.296.g2bfb1c46d8-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
