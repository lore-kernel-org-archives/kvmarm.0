Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C793EC433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 12:01:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A08621D7B
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 12:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Zb9L1job"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A08621D7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 933B34B1EB;
	Tue, 15 Sep 2020 08:01:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8lRXOo5Sl6A7; Tue, 15 Sep 2020 08:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A764B163;
	Tue, 15 Sep 2020 08:01:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7487C4B163
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 08:01:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3-GSKn3Loq+d for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 08:01:08 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 624184B161
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 08:01:08 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id e16so3050739wrm.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 05:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=D1RHl8ABdhn5KjoXJVQFbK3lZzim3prS8WaJzdIy+Zo=;
 b=Zb9L1jobJQn7TM+/5qKmWs5QBd2EXGxISO/ZkcumPM8Vro0Vr55MmlKUwUifKoKJg+
 zl/iDbZ2w5XqrlxmJkjZgmmZP5NI1934atyy561Ay2MXa+FnuuynbncFOlg6j1nAM8ei
 nQJq5CvBO8QomgfteMuJPONS1P+ZZCvCiP3bLKVjNIYXIcqQgdzXgAjr3TShuD/NTpLq
 WK/qwY8X5PijIrR+U2tADWCc41LFvUI6wRrhWcMVNdBvt24fQOuGsuHn/kO9UmXlrJl9
 lA14MFwIiIxLtPEKAUDzC+4CdfxeTGre++QHrUGZAZncOeGJWO14UVlnAnY/vdGLIltr
 bPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=D1RHl8ABdhn5KjoXJVQFbK3lZzim3prS8WaJzdIy+Zo=;
 b=mMkSf2WE95i6N64GT5Z1WzOIq9sczYRzophhDOs3EYNYwQq+JvRdr+TiKDCmrk9LgW
 Nh5amk5LuMmJtW62Ua3yhXd5iLXDxAFxDAxn4ly8vyN+8I0SRvlfok60dTKmL+szaXf1
 yO5k1KNQjl3hbsz4TAu7UJaRm3KOgMXAmZTSBNV//eC85YMYLb/S1fzIS55YUnD+cAa9
 8KZWmjBtWThq56JxTwb9m4iVtdSLl9nSVDo9JbFMBThNFBkKgnpxwrX+WMJZFqdQ9qYJ
 09TFKXiYAMgsc/GyZtLLs9qx7iDhldi0QAidqAD3iI6kUSPiwPke5aEWyYRyzuAMI3Y/
 a8SQ==
X-Gm-Message-State: AOAM5333aXwdB2vISXg8qg7RzTmV67Hy5+qZXrI7w7WJRN5jqMSWytFo
 MstOxjY7Tf4ghGGASJpJIYE6bQ==
X-Google-Smtp-Source: ABdhPJw9xzBTkm1ex/SpXs3gzQoe/wJz8pjYJNPqDjhDGb9ai+C4+hJhDspqERQLDE8pW/IN0QMg9Q==
X-Received: by 2002:adf:91c2:: with SMTP id 60mr22458843wri.292.1600171267204; 
 Tue, 15 Sep 2020 05:01:07 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id s124sm25145526wme.29.2020.09.15.05.01.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Sep 2020 05:01:06 -0700 (PDT)
Date: Tue, 15 Sep 2020 12:01:05 +0000
From: George Popescu <georgepope@google.com>
To: Marco Elver <elver@google.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
Message-ID: <20200915120105.GA2294884@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
 <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, maskray@google.com, maz@kernel.org,
 Masahiro Yamada <masahiroy@kernel.org>,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, broonie@kernel.org,
 Nathan Chancellor <natechancellor@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Michal Marek <michal.lkml@markovi.net>,
 Nick Desaulniers <ndesaulniers@google.com>,
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

On Tue, Sep 15, 2020 at 01:18:11PM +0200, Marco Elver wrote:
> On Tue, 15 Sep 2020 at 12:25, George Popescu <georgepope@google.com> wrote:
> > On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> > > On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > > > From: George Popescu <georgepope@google.com>
> > > >
> > > > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > > > the handler call, preventing it from printing any information processed
> > > > inside the buffer.
> > > > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > > > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > > > call
> > >
> > This would mean losing the local-bounds coverage. I tried to  test it without
> > local-bounds and with a locally defined array on the stack and it works fine
> > (the handler is called and the error reported). For me it feels like
> > --array-bounds and --local-bounds are triggered for the same type of
> > undefined_behaviours but they are handling them different.
> 
> Does -fno-sanitize-trap=bounds help?>

I tried replacing it with:
      ifdef CONFIG_CC_IS_CLANG
            CFLAGS_UBSAN += $(call cc-option, -fno-sanitize-trap=bounds)
            CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
      else
            CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
      endif

The code traps.

Thanks,
George
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
