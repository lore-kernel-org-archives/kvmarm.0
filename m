Return-Path: <SRS0=7IkQ=XF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD85C49ED9
	for <kvmarm@archiver.kernel.org>; Tue, 10 Sep 2019 17:07:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67A8B2089F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Sep 2019 17:07:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67A8B2089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C83314A5DC;
	Tue, 10 Sep 2019 13:07:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PiP-jK0fXyM2; Tue, 10 Sep 2019 13:07:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5FBE4A5E1;
	Tue, 10 Sep 2019 13:07:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95EB14A5DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 13:07:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id idwec7pMq7Db for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Sep 2019 13:07:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B81604A5DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 13:07:08 -0400 (EDT)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 945E269060
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 17:07:07 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id h6so6792056wrh.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 10:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=jS9SAbRa2McKy0qBG7wZ1CKPYnoi+vtu8q46fEjiV1s=;
 b=MYDTdwj4ty7o2BOvELDL8ji/Cdy+xRBoPttuliTbgFGUtxRAsKfLgwe+jA0TXE6qUV
 8hLRh5+1vBXLmDOFMiQs2NLz4/rn9izUtSJa594CuztZ4S4kjDeTspZehFzLaVkg+u5r
 NN+Z5HrJAkt4mEQNQ5CjxIlnz6xhcP4vluH5BjGyPUSqAwfG4mqqgbw/pt9GGRCsqtd5
 Ew0TBAM804gcb6wtzp2neAVxR45YGNx4iZPobZzdsVIC3K4q9elSzaN/jHO7kiW4XH+G
 OUE2jVV95SDWluRVkM/+tuj2A2TAauQDotJpv8M20ixN7wW8QLakUHq4ymcABCwkufZP
 Ymww==
X-Gm-Message-State: APjAAAU3mj142LCwf6ulWSdbJN9Im4/VjxXZ6HqQLHoBl52Oc1J3ogT8
 CI/F42/kmO26e8P4xYgr6lmWdjmwnNZg3cVLK+s7Ckp5Zh6LVWCI340tdyt0/CcIx2XFBmUrrxT
 AAF84nXTN6G4/S4lAJCLq0z+p
X-Received: by 2002:adf:ed42:: with SMTP id u2mr28596501wro.330.1568135226141; 
 Tue, 10 Sep 2019 10:07:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqziHLD37hPpi8Qki2QYlvEgSFjyeyGPvCTLz7nrsvsi7uErSFmOiRs+uNH8d9gpxHppa9ahhA==
X-Received: by 2002:adf:ed42:: with SMTP id u2mr28596480wro.330.1568135225854; 
 Tue, 10 Sep 2019 10:07:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1435:25df:c911:3338?
 ([2001:b07:6468:f312:1435:25df:c911:3338])
 by smtp.gmail.com with ESMTPSA id w10sm235582wmi.2.2019.09.10.10.07.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 10 Sep 2019 10:07:05 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm: prevent compiler from using unaligned
 accesses
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones <drjones@redhat.com>
References: <20190905171502.215183-1-andre.przywara@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cc8ca50b-1e66-1901-ad32-b4b196fb46bf@redhat.com>
Date: Tue, 10 Sep 2019 19:07:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905171502.215183-1-andre.przywara@arm.com>
Content-Language: en-US
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

On 05/09/19 19:15, Andre Przywara wrote:
> The ARM architecture requires all accesses to device memory to be
> naturally aligned[1][2]. Normal memory does not have this strict
> requirement, and in fact many systems do ignore unaligned accesses
> (by the means of clearing the A bit in SCTLR and accessing normal
> memory). So the default behaviour of GCC assumes that unaligned accesses
> are fine, at least if happening on the stack.
> 
> Now kvm-unit-tests runs some C code with the MMU off, which degrades the
> whole system memory to device memory. Now every unaligned access will
> fault, regardless of the A bit.
> In fact there is at least one place in lib/printf.c where GCC merges
> two consecutive char* accesses into one "strh" instruction, writing to
> a potentially unaligned address.
> This can be reproduced by configuring kvm-unit-tests for kvmtool, but
> running it on QEMU, which triggers an early printf that exercises this
> particular code path.
> 
> Add the -mstrict-align compiler option to the arm64 CFLAGS to fix this
> problem. Also add the respective -mno-unaligned-access flag for arm.
> 
> Thanks to Alexandru for helping debugging this.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> [1] ARMv8 ARM DDI 0487E.a, B2.5.2
> [2] ARMv7 ARM DDI 0406C.d, A3.2.1
> ---
>  arm/Makefile.arm   | 1 +
>  arm/Makefile.arm64 | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index a625267..43b4be1 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -12,6 +12,7 @@ KEEP_FRAME_POINTER := y
>  
>  CFLAGS += $(machine)
>  CFLAGS += -mcpu=$(PROCESSOR)
> +CFLAGS += -mno-unaligned-access
>  
>  arch_LDFLAGS = -Ttext=40010000
>  
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 02c24e8..35de5ea 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -7,6 +7,7 @@ bits = 64
>  ldarch = elf64-littleaarch64
>  
>  arch_LDFLAGS = -pie -n
> +CFLAGS += -mstrict-align
>  
>  define arch_elf_check =
>  	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
> 

Queued, thanks.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
