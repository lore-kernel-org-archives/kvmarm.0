Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B0CC43461
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 21:17:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49B7D215A4
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 21:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gnDqleJF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49B7D215A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 828034B4A5;
	Mon, 14 Sep 2020 17:17:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mnVMbZ6EYeEq; Mon, 14 Sep 2020 17:17:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F17A4B5A4;
	Mon, 14 Sep 2020 17:17:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B9F4B59A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 17:17:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 57X-Kg23uQBE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 17:17:52 -0400 (EDT)
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
 [209.85.210.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 610D54B58D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 17:17:52 -0400 (EDT)
Received: by mail-pf1-f196.google.com with SMTP id w7so640460pfi.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 14:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=C7sgFtQoGvHj7+x9+CzUrIZAY69PKOdgVMUAIaHzDvk=;
 b=gnDqleJFU5cmc1mv/6wA2ZIagFuJ9D2lmUavjWv6EMmYdNLbqf6A5K8TJOdNg7N3FY
 mLuwcwvWwVMJQJrF2vg/ffFdc2javZdPcWINp34Ym7c19crbmYZ6x7dPhu+mEvQ/56Mt
 wXI10/4tolCDr+DmylqtpAkdoH72EKStTvyCo4DLIhzvt5QZhg6xpH43JtkExoMvKdNv
 LiH4JqsEpciJm2TR7hD6NTbttRz8qwE8OiW3LIT6n7PyHgKqCdDh80IzfCFVyqmWmdeJ
 ggSFYCBKX6oP4E5HLBAdw6dziC0aI3JUI14PFxwSd6FPjVSFMR3cn3pNJ4nX1aMKU4om
 qYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=C7sgFtQoGvHj7+x9+CzUrIZAY69PKOdgVMUAIaHzDvk=;
 b=tJkY9VcsvM8XTCGjt+P9eePo0os1AzkGnl/xrMoIifyHB5jZ6P8gWjYUm+eizImZEN
 8jIyuWFmruVlfo6yubmIWd+/T8n6QLL5EfKPZ9jO+kzdOrya3L/FRl8Vy11E9wFfMB6x
 R2b8hI76w8t0TJQQsvsvLu28kQgob3oZQtCfpBZeOrqA8q2iHgM6Qz4fBt3hKMKjWPFE
 I90YhY1LBUG5M4GMXqiuM2iLpTL1A7bsmJGsBNl6H6HIflxeQ6S2ya0iz5E95IhgSFtA
 QxeEWO7N1GAOOMhsNDiTSA+SQxvTsDHUPlNJnTjtljo+IzSm6csG3KOkbXBHgPbcxq/a
 9kOA==
X-Gm-Message-State: AOAM533/AE6t15joWNynFn17oFJjwTVrDasJ3uy1G3gdyrte3aLAS8Zv
 tXvgT5HkKnsEh59gvXCXlBC4GJp49A2YM5WLovTuXg==
X-Google-Smtp-Source: ABdhPJxjub95+5dDKi00tb/Da2i1oajSsikg4UGw9vf1zvL6UGwb/mS50BQN7Q/j8wmacDIAUdFy2S5MHc9JZU28vt0=
X-Received: by 2002:a63:7882:: with SMTP id t124mr2686911pgc.381.1600118271305; 
 Mon, 14 Sep 2020 14:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
In-Reply-To: <20200914172750.852684-7-georgepope@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 14 Sep 2020 14:17:39 -0700
Message-ID: <CAKwvOdmMAc5zhLQMr-6WvrJJ4vbzwMpav36Y6V_DBBVjf4i72g@mail.gmail.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
To: George-Aurelian Popescu <georgepope@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Fangrui Song <maskray@google.com>,
 Marc Zyngier <maz@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 kernel-dynamic-tools <kernel-dynamic-tools@google.com>,
 Marco Elver <elver@google.com>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
 Mark Brown <broonie@kernel.org>, Nathan Chancellor <natechancellor@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Michal Marek <michal.lkml@markovi.net>,
 LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
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

+ kernel-dynamic-tools to help review.

On Mon, Sep 14, 2020 at 10:28 AM George-Aurelian Popescu
<georgepope@google.com> wrote:
>
> From: George Popescu <georgepope@google.com>
>
> When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> the handler call, preventing it from printing any information processed
> inside the buffer.
> For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> -fsanitize=local-bounds, and the latter adds a brk after the handler
> call
>
> Signed-off-by: George Popescu <georgepope@google.com>
> ---
>  scripts/Makefile.ubsan | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile.ubsan b/scripts/Makefile.ubsan
> index 27348029b2b8..3d15ac346c97 100644
> --- a/scripts/Makefile.ubsan
> +++ b/scripts/Makefile.ubsan
> @@ -4,7 +4,14 @@ ifdef CONFIG_UBSAN_ALIGNMENT
>  endif
>
>  ifdef CONFIG_UBSAN_BOUNDS
> -      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> +      # For Clang -fsanitize=bounds translates to -fsanitize=array-bounds and
> +      # -fsanitize=local-bounds; the latter adds a brk right after the
> +      # handler is called.
> +      ifdef CONFIG_CC_IS_CLANG
> +            CFLAGS_UBSAN += $(call cc-option, -fsanitize=array-bounds)

You can remove the cc-option check above; Clang has supported this
option for many releases.  (One less compiler invocation at build
time, FWIW).

You cannot remove the below cc-option; GCC only implemented that
sanitizer in the 5.0+ releases; the kernel still support GCC 4.9.

> +      else
> +            CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> +      endif
>  endif
>
>  ifdef CONFIG_UBSAN_MISC
> --
> 2.28.0.618.gf4bc123cb7-goog
>


-- 
Thanks,
~Nick Desaulniers
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
