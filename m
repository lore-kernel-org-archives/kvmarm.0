Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4EDC433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 15:12:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D35DE22450
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 15:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PUU8fv2n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D35DE22450
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06B8E4B41C;
	Wed, 16 Sep 2020 11:12:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6QYLmbiU1Tbe; Wed, 16 Sep 2020 11:11:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0BB94B31D;
	Wed, 16 Sep 2020 11:11:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AEDE4B46B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 09:40:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 75DKXt23Wlhq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 09:40:38 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB6204B46C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 09:40:37 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id e11so2276100wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 06:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=uEjVdCuhEoV9lb5ls6kMmq0ECr43Rh1pbVRxVP/xc0E=;
 b=PUU8fv2nYs0tjxbo5vnP2us18PfVb1Xunkump0q2oq1WUGUGx/Lcgus2dW8plEctBu
 Qs795uckGKFqlBwaeJHxNgTa+zHUOIdMlaH3B20/ByLXLBl1QewIY26uQl3s6wxgl40X
 y7Sl4VoAKpf9y+O370S6csA9+tABN6AXQ9HcHeTZqbP97j+ZCcAFKfcYEXVp30f3T7oT
 AKvU83SX8xyIW8vmTdkzt38dQ3ZZvj9WB+i6K2xhG2tMsoEdmckLp5IrXXlCBCOLWG47
 PpIwBYRZreCvfOOlJ031bSRstEvlHX/qqXpdEFTM3AnwGbd4Y0lA6o8uLVziWP/yTVL3
 MYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=uEjVdCuhEoV9lb5ls6kMmq0ECr43Rh1pbVRxVP/xc0E=;
 b=GXrMs1+1Z/rqKdVFDM5BQhRzGUBQJYQRQV27zLGOvDN/2uyBLy7msDPmOx2vXiSbDI
 0kguw/WV6iFLJgZho7yz8ZkeeXflhX1l1FlJb2gCfzxg9FdchVShcVDE816fivpL0iRm
 BDQY1Nlhx1eVk70jCN0BUfmG8AEyKT8GnyxyN72rOKjPY/n6MgVW+IXw0naU2Bzjuzrt
 0w4vW/Z9zbXEAYe9Fa42D8cv7z8WIOYki0wv5LKtXdW9OvtzYBgc/t1JoPKXJpeOzjYz
 RR7n9EBKHJEi9oj7nmPTPdfwGhNzG+DLal/v5dAoDejeUoCs141C1x1IjwBPy5urmS4M
 LV+Q==
X-Gm-Message-State: AOAM530FPzDUtdMbkYG2NAD5j0Ic2ooFiiFb/2MT61QfPU2EDte2poue
 lR6VVgtvUghPdjmuXMfe42MG2g==
X-Google-Smtp-Source: ABdhPJwkYqBdHOlcj/6E3C/Hg3AY0p7Pq+MV0hPCUD7Q9dFfXQXlMg4ViJJ/8esSCNDeaapoa/urtw==
X-Received: by 2002:a1c:7714:: with SMTP id t20mr5048312wmi.55.1600263636710; 
 Wed, 16 Sep 2020 06:40:36 -0700 (PDT)
Received: from elver.google.com ([100.105.32.75])
 by smtp.gmail.com with ESMTPSA id o16sm31108612wrp.52.2020.09.16.06.40.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Sep 2020 06:40:35 -0700 (PDT)
Date: Wed, 16 Sep 2020 15:40:29 +0200
From: Marco Elver <elver@google.com>
To: George Popescu <georgepope@google.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
Message-ID: <20200916134029.GA1146904@elver.google.com>
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
 <CANpmjNOTcS_vvZ1swh1iHYaRbTvGKnPAe4Q2DpR1MGhk_oZDeA@mail.gmail.com>
 <20200915120105.GA2294884@google.com>
 <CANpmjNPpq7LfTHYesz2wTVw6Pqv0FQ2gc-vmSB6Mdov+XWPZiw@mail.gmail.com>
 <20200916074027.GA2946587@google.com>
 <CANpmjNMT9-a8qKZSvGWBPAb9x9y1DkrZMSvHGq++_TcEv=7AuA@mail.gmail.com>
 <20200916121401.GA3362356@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916121401.GA3362356@google.com>
User-Agent: Mutt/1.14.4 (2020-06-18)
X-Mailman-Approved-At: Wed, 16 Sep 2020 11:11:57 -0400
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Catalin Marinas <catalin.marinas@arm.com>, glider@google.com,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Fangrui Song <maskray@google.com>, maz@kernel.org,
 Masahiro Yamada <masahiroy@kernel.org>, kasan-dev@googlegroups.com,
 clang-built-linux <clang-built-linux@googlegroups.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
 andreyknvl@google.com, broonie@kernel.org,
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

On Wed, Sep 16, 2020 at 12:14PM +0000, George Popescu wrote:
> On Wed, Sep 16, 2020 at 10:32:40AM +0200, Marco Elver wrote:
> > On Wed, 16 Sep 2020 at 09:40, George Popescu <georgepope@google.com> wrote:
> > > On Tue, Sep 15, 2020 at 07:32:28PM +0200, Marco Elver wrote:
> > > > On Tue, 15 Sep 2020 at 14:01, George Popescu <georgepope@google.com> wrote:
> > > > > On Tue, Sep 15, 2020 at 01:18:11PM +0200, Marco Elver wrote:
> > > > > > On Tue, 15 Sep 2020 at 12:25, George Popescu <georgepope@google.com> wrote:
> > > > > > > On Mon, Sep 14, 2020 at 03:13:14PM -0700, Kees Cook wrote:
> > > > > > > > On Mon, Sep 14, 2020 at 05:27:42PM +0000, George-Aurelian Popescu wrote:
> > > > > > > > > From: George Popescu <georgepope@google.com>
> > > > > > > > >
> > > > > > > > > When the kernel is compiled with Clang, UBSAN_BOUNDS inserts a brk after
> > > > > > > > > the handler call, preventing it from printing any information processed
> > > > > > > > > inside the buffer.
> > > > > > > > > For Clang -fsanitize=bounds expands to -fsanitize=array-bounds and
> > > > > > > > > -fsanitize=local-bounds, and the latter adds a brk after the handler
> > > > > > > > > call
> > > > > > > >
> > > > > > > This would mean losing the local-bounds coverage. I tried to  test it without
> > > > > > > local-bounds and with a locally defined array on the stack and it works fine
> > > > > > > (the handler is called and the error reported). For me it feels like
> > > > > > > --array-bounds and --local-bounds are triggered for the same type of
> > > > > > > undefined_behaviours but they are handling them different.
> > > > > >
> > > > > > Does -fno-sanitize-trap=bounds help?
[...]
> > Your full config would be good, because it includes compiler version etc.
> My full config is:

Thanks. Yes, I can reproduce, and the longer I keep digging I start
wondering why we have local-bounds at all.

It appears that local-bounds finds a tiny subset of the issues that
KASAN finds:

	http://lists.llvm.org/pipermail/cfe-commits/Week-of-Mon-20131021/091536.html
	http://llvm.org/viewvc/llvm-project?view=revision&revision=193205

fsanitize=undefined also does not include local-bounds:

	https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html#available-checks

And the reason is that we do want to enable KASAN and UBSAN together;
but local-bounds is useless overhead if we already have KASAN.

I'm inclined to say that what you propose is reasonable (but the commit
message needs to be more detailed explaining the relationship with
KASAN) -- but I have no idea if this is going to break somebody's
usecase (e.g. find some OOB bugs, but without KASAN -- but then why not
use KASAN?!)

I'll ask some more people on LLVM side.

Thanks,
-- Marco
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
