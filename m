Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6C2C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:25:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3790421D7F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="vbBJy4kw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3790421D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 774AE4B209;
	Tue, 15 Sep 2020 06:25:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A9xLiFge+hkT; Tue, 15 Sep 2020 06:25:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FBE24B2B7;
	Tue, 15 Sep 2020 06:25:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F5B84B1F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:25:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CYooSNS7yuvJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:25:02 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38F2F4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:25:02 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id w2so2828744wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=nCObEKoOnmpHrzYJFBm9pkBKEq9SNCMkpHaxOskN+KQ=;
 b=vbBJy4kwOuP8fps7ENGxPva5zUYL7ASA78U0Ik7uGtyQwbCdxLIDc5R+Lkce3LiyG9
 tLhWib3rO23PtT7aBoJi1Wh5s5YnYthzHConFQ9L9lfT5mJzO+PvYFbCpNkD3Y3Y5pV7
 ccjX2TexQXkFDZFRXCF4Vu7sGsVYCi2n6CfR+ga+FrmT/CM19VfdHrlV+uoAyQb7Wnux
 Ua6jN3ov5SDmM4C4t32H7+HFTozTlN8q3kPzjcNZy74cI/nUj7maUu2W1Xv0iRcsns8V
 7sMEIca6qA/KcCQnNsC8rCvlnSY3mxClh6VbPDZTXsnqTmoM6xWaK0XxddnzL4J3SJO6
 b+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nCObEKoOnmpHrzYJFBm9pkBKEq9SNCMkpHaxOskN+KQ=;
 b=CYpGvvAd1b+izYrUUG/38vWz+1mZvemEO/rs/DgUExw6ErMo1/Sv7PK9EK/SRTHPSV
 QMbBFJlzqwiJxwRjLqE8uP43qTYlv3PhExEX9bsaWBosHrW/eGmicu3kqvn1jq5+sK3U
 ajPG2BQcS4kUx3E+cDAcnBfdCZ6IuY9jdpwSThQdf2EbeHh5x258ChmdFAGnLo1htKee
 GlM1rFy6yIu4TREKkrLrvbbFRV/iH2q6y7rvRiOVcN2vK3wBOikC0JS/Y2ZQT5cqXjwa
 UxhkHsa9SWsOMdy2F9K4Nnho3RsxURwoVpgO/rePREPVBTgVBxmeMcESp5L7fAyL8ldX
 OAug==
X-Gm-Message-State: AOAM532ptGXuekMeuV+BX3NLAhlKsUnuDc+e/CF330zfzW9NBr0Wflqz
 LeC0iCssyydxKpSe/JsqTZR8Cw==
X-Google-Smtp-Source: ABdhPJyLkeeoM2ZZcrGWaota2zFMVO2kAkBf28Jt84EjulN5M4ljnumj2SEmrORUfgsijOJP5ZWZqg==
X-Received: by 2002:a1c:2e08:: with SMTP id u8mr4155025wmu.156.1600165500941; 
 Tue, 15 Sep 2020 03:25:00 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id w15sm27651716wro.46.2020.09.15.03.25.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Sep 2020 03:25:00 -0700 (PDT)
Date: Tue, 15 Sep 2020 10:24:58 +0000
From: George Popescu <georgepope@google.com>
To: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
Message-ID: <20200915102458.GA1650630@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <202009141509.CDDC8C8@keescook>
Cc: tglx@linutronix.de, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maskray@google.com, maz@kernel.org,
 masahiroy@kernel.org, clang-built-linux@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, elver@google.com, arnd@arndb.de,
 linux-kbuild@vger.kernel.org, broonie@kernel.org, natechancellor@gmail.com,
 dvyukov@google.com, michal.lkml@markovi.net, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
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

On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > From: George Popescu <georgepope@google.com>
> > 
> > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > the handler call, preventing it from printing any information processed
> > inside the buffer.
> > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > call
> 
> That sounds like a compiler bug?
Actually in clang 12 documentation is written that -fsanitize=bounds
expands to that. GCC  doesn't have those two options, only the
-fsanitize=bounds which looks similar to -fsanitize=array-bounds from
clang. So I don't see it as a compiler bug, just a misuse of flags.

> > Signed-off-by: George Popescu <georgepope@google.com>
> > ---
> >  scripts/Makefile.ubsan | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/scripts/Makefile.ubsan b/scripts/Makefile.ubsan
> > index 27348029b2b8..3d15ac346c97 100644
> > --- a/scripts/Makefile.ubsan
> > +++ b/scripts/Makefile.ubsan
> > @@ -4,7 +4,14 @@ ifdef CONFIG_UBSAN_ALIGNMENT
> >  endif
> >  
> >  ifdef CONFIG_UBSAN_BOUNDS
> > -      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> > +      # For Clang -fsanitize=bounds translates to -fsanitize=array-bounds and
> > +      # -fsanitize=local-bounds; the latter adds a brk right after the
> > +      # handler is called.
> > +      ifdef CONFIG_CC_IS_CLANG
> > +            CFLAGS_UBSAN += $(call cc-option, -fsanitize=array-bounds)
> 
> This would mean losing the local-bounds coverage? Isn't that for locally
> defined arrays on the stack?
This would mean losing the local-bounds coverage. I tried to  test it without
local-bounds and with a locally defined array on the stack and it works fine
(the handler is called and the error reported). For me it feels like
--array-bounds and --local-bounds are triggered for the same type of
undefined_behaviours but they are handling them different.

> > +      else
> > +            CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
> > +      endif
> >  endif
> >  
> >  ifdef CONFIG_UBSAN_MISC
> > -- 
> > 2.28.0.618.gf4bc123cb7-goog
> > 
> 
> --
Thanks,
George
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
