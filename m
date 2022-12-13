Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D7CC4708E
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 02:13:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16C7B4B935;
	Mon, 12 Dec 2022 21:13:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GqFafD1qjcjD; Mon, 12 Dec 2022 21:13:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04DD54B87A;
	Mon, 12 Dec 2022 21:13:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 573C44B87A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 21:13:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bzdvSr40qA5r for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 21:13:30 -0500 (EST)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBDAD4B877
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 21:13:29 -0500 (EST)
Received: by mail-pj1-f43.google.com with SMTP id fy4so1889919pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=dytxSctGH3/JU5+VUvCXKRl3djDPMXaOjikH1n5CrMU=;
 b=CBf3R1fmXIZ45yTb+WHxJdiyNOFL2h5rhe7iuVz+maaKt1rkPLuLZ1Vg6SAm23HMHG
 vQ6uXPH/ty7wkcdAYuV/Lh/0nTI9cyJfrD99XFzYtkzgINZ5bTa5LBeoIBAsqfn4QDC3
 6SVFH94xQAmltYML5ctohPuMu25umC/aZZCO6gUijQK+8crcDBG5bvbVDVdxF3bugd0O
 rtoRLMRfttq4YtD01i5HrnVdRJstwarVuJG/T6s79sxcBeqvrkLe9Nt+5avTs3+UOplZ
 FkjJ/F9aFkiOlaZ3Av0iqu9jA/E5UOfBI4ocgDHSNbxKS74BDaooa/RlqBvBkybckhx2
 eXVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=dytxSctGH3/JU5+VUvCXKRl3djDPMXaOjikH1n5CrMU=;
 b=JiiNKAxdddraCjtxnG1Aor7ETwfSd5NygIkP3YMNUNmlbWT0nEvVyZdxh1ttGP7rsh
 a28/7gNoeQjvkQUsl/KnPtNsOY6HsUimc+oQOLecd3sJWw14QN4Qkeseg/ZPUZRj/38a
 uhVOqBep0XSGwZi9Fp5dWTu3kAF4y9aYzfHvlGViulrgKXd88gIKiCJIErRWWzdQoEor
 GsOBS5l4yeWxhZwKO5euvgJ87K1KVsLt8Ml7rD9CIkKOvOMuKRdqIIWF0PqAJk2EKPqm
 Eo9nHBJelIs3tXtzkawZ1P1UWCm5UcFYodUDU7RU2sVyMmHGjb6vVF6MGykiZZkHt3ZA
 duhQ==
X-Gm-Message-State: ANoB5pkwF4FG7tLABjAjOLRqkASRq9/UiQ/4kJMoTCQJdwQjBwh7qNAo
 7IA698MX0MQbN3L9aqzjR2tDtQ==
X-Google-Smtp-Source: AA0mqf5lyAQrJvHm7xnE6hLi9O52SD019Oq6Ie+uJ0eyRDJIM2Xscc/SexS//WPdt/sgq2p4vlI/tg==
X-Received: by 2002:a17:902:7b96:b0:189:858f:b5c0 with SMTP id
 w22-20020a1709027b9600b00189858fb5c0mr90604pll.0.1670897608745; 
 Mon, 12 Dec 2022 18:13:28 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 d9-20020a170902654900b00176b63535adsm7060787pln.260.2022.12.12.18.13.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 18:13:28 -0800 (PST)
Date: Tue, 13 Dec 2022 02:13:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH 11/14] KVM: selftests: Disable
 "gnu-variable-sized-type-not-at-end" warning
Message-ID: <Y5ffxebJ/eRzEXh+@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-12-seanjc@google.com>
 <CAKwvOdnRQQb9YbH=MgDymBmmjYgajc8tkyjbJVxjpA5zDZpNTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKwvOdnRQQb9YbH=MgDymBmmjYgajc8tkyjbJVxjpA5zDZpNTQ@mail.gmail.com>
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

On Mon, Dec 12, 2022, Nick Desaulniers wrote:
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 2487db21b177..9cff99a1cb2e 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -196,6 +196,7 @@ else
> >  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
> >  endif
> >  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> > +       -Wno-gnu-variable-sized-type-not-at-end \
> 
> This is a clang-specific warning. This will need to be wrapped in a
> cc-option check.

Not that I'm against guarding this code, but I don't think cc-option() will do
anything in this case.

AFAICT, gcc stopped treating unknown "-Wno" flags as unconditional errors starting
with gcc-4.4, and the kernel's min supported version is 5.1.  gcc-4.4 through
gcc-9.5 all print a mild warning if there's a different error, but otherwise
silently ignore the uknown "-Wno".

  cc1: warning: unrecognized command line option '-Wno-gnu-variable-sized-type-not-at-end'

gcc-10.1 is even friendlier and notes that the unknown flag may have been related
to the error.

  cc1: note: unrecognized command-line option '-Wno-gnu-variable-sized-type-not-at-end'
  may have been intended to silence earlier diagnostics

Because cc-option() doesn't have errors in its probing code, it will return "true"
on gcc for literally any "-Wno-*" input that gcc deems syntacially valid, e.g.
gcc barfs on

  depends on $(cc-option,-Wno-)
  depends on $(cc-option,-Wno)

but happily succeeds with

  depends on $(cc-option,-Wno-lol-gcc)

Various man pages suggest -Wunknown-warnings is a thing, but no gcc version
supported by godbolt recognizes it.

So unless I'm missing something, trying to detect lack of support will be non-trivial,
and the worst case scenario is that users of older gcc version will see a potentially
confusing warning when the build fails.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
