Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63CCC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 01:37:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA1864B93E;
	Mon, 12 Dec 2022 20:37:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id egriGD4IY7R5; Mon, 12 Dec 2022 20:37:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A478E4B925;
	Mon, 12 Dec 2022 20:37:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C5954B925
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:37:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MFd7b+6FHJo1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 20:37:10 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DF724B870
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:37:10 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id js9so1777052pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=iJwqdDN1RvNeTFiZyaSzmASJkDq0+IG5uFFQ0Vq+pIE=;
 b=UOLR4/D4l8GUzElS0sejD2JapJwiXXo2meP6+lJ4UUi6Oj9CCz+E9FE2qBHGrI7Utw
 7OokGhkdZbKxc3Ctt6ZZXN0i35uOg0peSR+0R+WVwqWr9OVFPJSib+WjKq5pQzui/58i
 Y8s1Y27VjQTtgwC7o5gYdWnjHddNTpRNWzMaZm5tNwUVmLRfMdVKxsEBBWh6ITeGtOW7
 gXOTqvopxiSjsYbG5ApbWUNiAL3dozmKHp10byFJU92ZP4hQWonUzETTShKtTRFN2+Hf
 tAOTXVSSNORLHBQ3eDPsuPXE6+G5eltxPXeLQCSKhU6J5/WfdMsaHX1ArV2nqpfebXr2
 dRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=iJwqdDN1RvNeTFiZyaSzmASJkDq0+IG5uFFQ0Vq+pIE=;
 b=xGQ3/F7PRCpiIb01fapcXzhR54sLrO2m/Zo7LnA1P1d2YCuEq0RGwgDgo6R1rQIXFJ
 UTpH9hfPXXZay8f5jhj/3Q2aHHoPZSk136cLXLv4R7FYTYD0hnXMd5AYDAkRhmCyGosN
 JUkqU1wy6PHTeD3xNDF/S5rbPvYWuN7NI9/SIdvAAUtWFH6DmH64xXzZGbZCTBAO1yG0
 i2iPJA0BhDSugHrVvBXNYmZepo69ONzFTg9NqQO7YfzmEZfVMEASDO1SHPCn6GdRwnOu
 fD4QsXffsBVzO5+NvodwP0am89edWl0+e6MgcxpZGJcrJbes9kUForvwG7TWJUSCvbQC
 4OpA==
X-Gm-Message-State: ANoB5pnjd8pYkWCCafI3IWPvO5f3mYv1l9+XdSJXYcHiC7y0FOpS1wl8
 xDaTMB/50SExPZGaOUIbqXCdDS4XPISm8kVtr8zMzA==
X-Google-Smtp-Source: AA0mqf59hLKHWHycEAofu9/939ZBb87HK2lBuOCJYN0Zs3K9cbu8MbXmw0OtELFZfn97VUt5D/c7xWXV2p8gd3eTyxg=
X-Received: by 2002:a17:902:f092:b0:189:9b43:a082 with SMTP id
 p18-20020a170902f09200b001899b43a082mr45842703pla.95.1670895428992; Mon, 12
 Dec 2022 17:37:08 -0800 (PST)
MIME-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-12-seanjc@google.com>
In-Reply-To: <20221213001653.3852042-12-seanjc@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 12 Dec 2022 17:36:58 -0800
Message-ID: <CAKwvOdnRQQb9YbH=MgDymBmmjYgajc8tkyjbJVxjpA5zDZpNTQ@mail.gmail.com>
Subject: Re: [PATCH 11/14] KVM: selftests: Disable
 "gnu-variable-sized-type-not-at-end" warning
To: Sean Christopherson <seanjc@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Aaron Lewis <aaronlewis@google.com>, Marc Zyngier <maz@kernel.org>,
 llvm@lists.linux.dev, Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
 Nathan Chancellor <nathan@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Dec 12, 2022 at 4:17 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Disable gnu-variable-sized-type-not-at-end so that tests and libraries
> can create overlays of variable sized arrays at the end of structs when
> using a fixed number of entries, e.g. to get/set a single MSR.
>
> It's possible to fudge around the warning, e.g. by defining a custom
> struct that hardcodes the number of entries, but that is a burden for
> both developers and readers of the code.
>
> lib/x86_64/processor.c:664:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> lib/x86_64/processor.c:772:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> lib/x86_64/processor.c:787:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> 3 warnings generated.
>
> x86_64/hyperv_tlb_flush.c:54:18: warning: field 'hv_vp_set' with variable sized type 'struct hv_vpset'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>         struct hv_vpset hv_vp_set;
>                         ^
> 1 warning generated.
>
> x86_64/xen_shinfo_test.c:137:25: warning: field 'info' with variable sized type 'struct kvm_irq_routing'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>         struct kvm_irq_routing info;
>                                ^
> 1 warning generated.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 2487db21b177..9cff99a1cb2e 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -196,6 +196,7 @@ else
>  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
>  endif
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> +       -Wno-gnu-variable-sized-type-not-at-end \

This is a clang-specific warning. This will need to be wrapped in a
cc-option check.

tools/build/Build.include seems to redefine that make macro, so be
sure to test it first.

>         -fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
>         -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>         -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
>


-- 
Thanks,
~Nick Desaulniers
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
