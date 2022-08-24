Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166A8C00140
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 16:45:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA2D4D47F;
	Wed, 24 Aug 2022 12:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qOTczxePjang; Wed, 24 Aug 2022 12:45:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A654D475;
	Wed, 24 Aug 2022 12:45:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67FFB4D472
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 12:45:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KLjEHjm3wkAl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2022 12:45:09 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45ABA4D462
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 12:45:09 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id
 m10-20020a17090a730a00b001fa986fd8eeso2250934pjk.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 09:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=tU1yBnqhlu3GqyKX52PVBbY7hfY440wN3o9LUS939qw=;
 b=dMwaDYcQTBZEUAz6w9NArwGUlxFWdZ3Pss5DJq8kQ35DIDbNM2J2BoG/fLJUW7rAsk
 0QkvfhDnsJ4GpqK+iwL2pNU8/iNzBW0S4Vz8aXQDoTWy5C9oPqxuTmJv7ilJjJwJHmXc
 Kev/YZH83qJsfs9xjvwGtRFhUI4Bn2u9JNj2hZfiZhr8jSp1vQlhxBzwpdAzhlIPp+ak
 VdN83DtNcVMzLg9ICJmdmqkTLFRdO/ClUvv+FlSKobXzKj/BQ7yWjJaL7hLXxQelxtQj
 1Fmqnu76cf5fKgdgEA7VgO+8MnkMbKLlJsxV3HeCVq8ipj8XaQFvLBn7h+plvbH4rhDk
 TO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=tU1yBnqhlu3GqyKX52PVBbY7hfY440wN3o9LUS939qw=;
 b=oNpduPWkjbFYD1cNV0WWcagE1ohvVSQGKfWhNbIdkBc+oOqyzOkUC5cwc25iRlg22y
 t0zFMAYBxFppakTYbwH20Bxi7yChVXT8yWQKrVYNINRYfYGxUcmfPSWG1t6STW+DADjR
 GOepYqx0tq6/yqgkNKpdbVnaT3drVWeJNHiNNUTI5Ua7xqIk47RP0NcGT0RN8+m5h8IL
 oNHv6+nm6Ki3XB2jQql2uwLBl8TffcyGFP1lNcyuxb5RvUdlllhXEVYHTYzAi0KrIa7Y
 AyErdOV4F9L/MIXY8mRU3xW0mFJipMfJdx6PrDrULpKu+YCyVNh8afvtQIJd3/I+qten
 +DLA==
X-Gm-Message-State: ACgBeo243hE8+cQARgVMuxTiYzx/ZJtXdDPoheJ71d6xEES2etrhxHy+
 Y4M8Svo6DELhLvlVyohP/m3Dgg==
X-Google-Smtp-Source: AA6agR6mRl2fzdjX6KtKC9JWf9pNY+kiiRoR9PXpwCPuruebJXijTYHgPAAsuT/LODAzP52270zQ/w==
X-Received: by 2002:a17:90b:3684:b0:1fa:f48e:abd0 with SMTP id
 mj4-20020a17090b368400b001faf48eabd0mr28499pjb.180.1661359507905; 
 Wed, 24 Aug 2022 09:45:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 o19-20020aa79793000000b005364944e538sm9721693pfp.99.2022.08.24.09.45.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Aug 2022 09:45:07 -0700 (PDT)
Date: Wed, 24 Aug 2022 16:45:03 +0000
From: Sean Christopherson <seanjc@google.com>
To: Will McVicker <willmcvicker@google.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YwZVj+8H4rGjEHyH@google.com>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
 <202202061011.A255DE55B@keescook>
 <YgAvhG4wvnslbTqP@hirez.programming.kicks-ass.net>
 <202202061854.B5B11282@keescook>
 <CABYd82ZmDbgmEGhdWOJ5Um8tiFd4TeQ-QZ2+xwxwqqQs6oi0xg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABYd82ZmDbgmEGhdWOJ5Um8tiFd4TeQ-QZ2+xwxwqqQs6oi0xg@mail.gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Fri, Feb 18, 2022, Will McVicker wrote:
> On Sun, Feb 6, 2022 at 6:56 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Sun, Feb 06, 2022 at 09:28:52PM +0100, Peter Zijlstra wrote:
> > > On Sun, Feb 06, 2022 at 10:45:15AM -0800, Kees Cook wrote:
> > >
> > > > I'm digging through the macros to sort this out, but IIUC, an example of
> > > > the problem is:
> > > >
> > >
> > > > so the caller is expecting "unsigned int (*)(void)" but the prototype
> > > > of __static_call_return0 is "long (*)(void)":
> > > >
> > > > long __static_call_return0(void);
> > > >
> > > > Could we simply declare a type-matched ret0 trampoline too?
> > >
> > > That'll work for this case, but the next case the function will have
> > > arguments we'll need even more nonsense...
> >
> > Shouldn't the typeof() work there too, though? I.e. as long as the
> > return value can hold a "0", it'd work.
> >
> > > And as stated in that other email, there's tb_stub_func() having the
> > > exact same problem as well.
> >
> > Yeah, I'd need to go look at that again.
> >
> > > The x86_64 CFI patches had a work-around for this, that could trivially
> > > be lifted I suppose.
> >
> > Yeah, I think it'd be similar. I haven't had a chance to go look at that
> > again...

Peter and/or Kees, can you provide a pointer to the patches that could potentially
be used as a basis for fixing ARM CFI?  Or even better, send a patch to actually
fix this?  :-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
