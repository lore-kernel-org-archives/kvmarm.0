Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9554BC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 20 Feb 2022 19:04:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5264B1C3;
	Sun, 20 Feb 2022 14:04:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S-0w-vpTBaJX; Sun, 20 Feb 2022 14:04:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BFDD4B1BA;
	Sun, 20 Feb 2022 14:04:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B92949EE1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 17:36:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rKOQLh4nGc4L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Feb 2022 17:36:04 -0500 (EST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
 [209.85.218.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09B7049EDE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 17:36:03 -0500 (EST)
Received: by mail-ej1-f42.google.com with SMTP id p15so18082246ejc.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 14:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=u+sFcg1Jrzd7RdQxBiVyHyjcrIIMdAB2S95NaiORBYQ=;
 b=cGWMjVauB1J5Kz60+ee5aWzyXC1AM3YWk9YtVYIpDse5G74x18lvIyFkPja0Abo2BE
 x35vQ/IgynKUwIAXySKdR7gESn/FCFxB+0QwV5+MYdhS+G+r+74C3G2GEbQ/KuACKSPg
 FGOM54bwhNMTJiu59gOKFKakEbIm3IhB8DdsdONoBkbNGLPhaDpiI23vY1/A4LizwOr+
 GU08VQDrmHuVY4hMkqkbJYpHgIH3shY7nppq7yL8Dj1EXvF8eFWdALTYd9V78sQra+cQ
 a8jdHCxrpmXpRDydmzrnQYWMNvTubkLbi0lCjjinCA3Iw9u8kWX9ZB6pvn5soobO7Dtz
 bFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=u+sFcg1Jrzd7RdQxBiVyHyjcrIIMdAB2S95NaiORBYQ=;
 b=KgAn38A+a7yxWNIHfMIs6Co57ywOXKAzjV2M/UXmra9LHt53tdYsrU211eoPvYj836
 +423udUQd/5dSFBoFn8neXm1A4dOSwExv03zzgResaPjVB07h113edJZnYFu/QgDVHJ9
 4gR8pApwRATHugVbfCEasrp6vlQ9I5FdyAkIB0wrPGTR8qMYv75bkdLfaWu66eZ7DfOL
 J01vjyd8LZZM4NOQL9VNV9c5nx7wwsepK0KWQmRc9cn1f/Qr2s+z3bd3uRJnrmVdn1/C
 SxFN5G9xU6ib6+g2wtu0IQipLATSLBROqfnF1O5KOt4xkyOIGhs8It6jzYFx8u739CQf
 wzXA==
X-Gm-Message-State: AOAM533qSTD8nxZIQCaeAMXv/Iaiz9/qgxL4oGNsHR/rrcLcdgaaORde
 bH7q/8xAb2fKAFprsjdLPtTbElp8qWyDYH8z7oRD5w==
X-Google-Smtp-Source: ABdhPJxCAq71uudZo1yeq2i43zfSBGdz40+2gbUVJ11hY+5K5ovbv3z9+MmVE7/NFhdhZ2/awk1paWaMMa6UYaynntU=
X-Received: by 2002:a17:906:7751:b0:6ce:e3c:81a6 with SMTP id
 o17-20020a170906775100b006ce0e3c81a6mr7806909ejn.278.1645223762896; Fri, 18
 Feb 2022 14:36:02 -0800 (PST)
MIME-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
 <202202061011.A255DE55B@keescook>
 <YgAvhG4wvnslbTqP@hirez.programming.kicks-ass.net>
 <202202061854.B5B11282@keescook>
In-Reply-To: <202202061854.B5B11282@keescook>
From: Will McVicker <willmcvicker@google.com>
Date: Fri, 18 Feb 2022 14:35:47 -0800
Message-ID: <CABYd82ZmDbgmEGhdWOJ5Um8tiFd4TeQ-QZ2+xwxwqqQs6oi0xg@mail.gmail.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To: Kees Cook <keescook@chromium.org>
X-Mailman-Approved-At: Sun, 20 Feb 2022 14:04:07 -0500
Cc: kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
 LKML <linux-kernel@vger.kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
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

On Sun, Feb 6, 2022 at 6:56 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Sun, Feb 06, 2022 at 09:28:52PM +0100, Peter Zijlstra wrote:
> > On Sun, Feb 06, 2022 at 10:45:15AM -0800, Kees Cook wrote:
> >
> > > I'm digging through the macros to sort this out, but IIUC, an example of
> > > the problem is:
> > >
> >
> > > so the caller is expecting "unsigned int (*)(void)" but the prototype
> > > of __static_call_return0 is "long (*)(void)":
> > >
> > > long __static_call_return0(void);
> > >
> > > Could we simply declare a type-matched ret0 trampoline too?
> >
> > That'll work for this case, but the next case the function will have
> > arguments we'll need even more nonsense...
>
> Shouldn't the typeof() work there too, though? I.e. as long as the
> return value can hold a "0", it'd work.
>
> > And as stated in that other email, there's tb_stub_func() having the
> > exact same problem as well.
>
> Yeah, I'd need to go look at that again.
>
> > The x86_64 CFI patches had a work-around for this, that could trivially
> > be lifted I suppose.
>
> Yeah, I think it'd be similar. I haven't had a chance to go look at that
> again...
>
> --
> Kees Cook


Hi All,

I noticed that this thread kind of died out. Does anyone have any
action items that need to be followed up to help resolve this issue?
The offending patch is breaking the ARM64 Android Common Kernels
(Pixel 6 in particular) and I imagine it might also have an impact on
other ARM64 platforms upstream that just haven't hit this perf_trace
case yet.

If anyone needs help verifying any fixes, I'm happy to test it out.

Thanks,
Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
