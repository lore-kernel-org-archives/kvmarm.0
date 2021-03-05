Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6854C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 20:22:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BD5F650A1
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 20:22:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BD5F650A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AE824B69F;
	Fri,  5 Mar 2021 15:22:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v6AVBf-jdTTf; Fri,  5 Mar 2021 15:22:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 760B24B6BD;
	Fri,  5 Mar 2021 15:22:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A38D4B6BD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 15:22:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVKTOvjm+hO1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 15:22:39 -0500 (EST)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CF144B69F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 15:22:39 -0500 (EST)
Received: by mail-pj1-f52.google.com with SMTP id h13so2812783pjt.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 12:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MgB9sUnmB+HDbU7JAxGibZcjoX4E3ntVPdJMz4KOYFw=;
 b=dLCXmMukcPtwoQkxr3n8IjcWmQ6q7PKDS4dt108Ep+Hg6xtKufWiaRfiYb+CxHR/HC
 qWKMfkrxZAMSD6QL8O9MUCKoSmwG/ZECasfaVxsuaSX2kBnGlXgijqIIG4MipL0UlkuP
 PEl4XvNYWvLojiZggWkziHss50vlyhTXkcdGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MgB9sUnmB+HDbU7JAxGibZcjoX4E3ntVPdJMz4KOYFw=;
 b=ZWPhxXWWBEn0ygkydSve57TBrnVghW+qALEzY3+Z2/ZMITMpyjmfE9EyzHGbxf5yEE
 CWeibw07yTW+VmfZJP2wgxw5CFyr+FlpYV5EThbyoafj9cLXtEXqylBchybhZLEv9/LC
 VO7cbYdQKURvIh0U8OYaxZABWXsoqAxcANRLsIq5ldCewvYysgTNVDQsZ/TBIYhL9knO
 6E8GsGk2eTMYm9accdxL4+HQPbJIaP3Hye12hPc12trcVumUm4f0xs0lnNzvFDId6JX4
 q8GMbFHmfpaJ+0zcvKLrdYXTzocQVRZYj6YxGtv+QHd+9dYnZP5/pdQ2tNjTOZyw5a1p
 exFg==
X-Gm-Message-State: AOAM532CWsaI9OoC4iaeRmhJXZLo2BzR678cUv5+Rvt/BEb0ol0cRgAC
 Pc93KCo4seLpCEzpt0iyQxD+Jw==
X-Google-Smtp-Source: ABdhPJz904H54bOFu7Tm3S02OXvw0Agtoa0McJF8goVZOFxdTDl2+pz3qI79jeBp+mKHGDstYs9PXQ==
X-Received: by 2002:a17:902:ee06:b029:e4:ba18:3726 with SMTP id
 z6-20020a170902ee06b02900e4ba183726mr10198402plb.17.1614975758196; 
 Fri, 05 Mar 2021 12:22:38 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id 63sm3854163pfg.187.2021.03.05.12.22.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Mar 2021 12:22:37 -0800 (PST)
Date: Fri, 5 Mar 2021 12:22:36 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't use cbz/adr with external symbols
Message-ID: <202103051222.1E08D7D31@keescook>
References: <20210305202124.3768527-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210305202124.3768527-1-samitolvanen@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Nathan Chancellor <nathan@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

On Fri, Mar 05, 2021 at 12:21:24PM -0800, Sami Tolvanen wrote:
> allmodconfig + CONFIG_LTO_CLANG_THIN=y fails to build due to following
> linker errors:
> 
>   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21CC):
>   relocation R_AARCH64_CONDBR19 out of range: 2031220 is not in
>   [-1048576, 1048575]; references hyp_panic
>   >>> defined in vmlinux.o
> 
>   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21E0):
>   relocation R_AARCH64_ADR_PREL_LO21 out of range: 2031200 is not in
>   [-1048576, 1048575]; references hyp_panic
>   >>> defined in vmlinux.o
> 
> This is because with LTO, the compiler ends up placing hyp_panic()
> more than 1MB away from __guest_enter(). Use an unconditional branch
> and adr_l instead to fix the issue.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1317
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
