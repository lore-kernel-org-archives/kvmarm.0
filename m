Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4CDC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 16:08:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2755C60EBB
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 16:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2755C60EBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93CE44A98B;
	Mon, 11 Oct 2021 12:08:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4rvQMs3SMndI; Mon, 11 Oct 2021 12:08:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E49E4ACC9;
	Mon, 11 Oct 2021 12:08:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E90FB4A49C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 12:08:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H7MfXClhoqpM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 12:08:47 -0400 (EDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com
 [209.85.219.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7D23407D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 12:08:47 -0400 (EDT)
Received: by mail-yb1-f170.google.com with SMTP id s4so40184310ybs.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 09:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=R1IZZmHpZJEGprcsYAoU/nu0GgHlWLkOakQbKNK/k+g=;
 b=mlNCnyY4+Gk9mJudvL1KHNimChN7ceAZU9hjGcP5sZ7iTcoagcnLWxwUeYVNAyM+vp
 p/piW8IlvILBF5cUKYWqNUaWI66sa3uFU9Naizabxy2GVKcfUqgGMfsuB1mgpZel2lo+
 szN7rwYLncZl2e/VXu26Ms3xhLiS8ymdIKMG9t1YfF2F5bxGN/wcMZRdt+brJj568bcP
 qH5wo6vjFzazyqt79hptbGV3TRra5D1HsJN1T6gSj3jv9NoaVr4pjCXprrPHV4KVI9vf
 6yWPNM6BteQ3qVlijR70EhltzdADxwVmmDrTEcyaCdTtckBo3z5eSUX84kL88do0j+sH
 WNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=R1IZZmHpZJEGprcsYAoU/nu0GgHlWLkOakQbKNK/k+g=;
 b=mGVCK//AZ13HLjEiUukB/Rf8AL/bvrZos/rOdOOskMa/Vxt/MX5RkjthLmsKUVbFr4
 KUWzVV9ncrSuhFwGknNRaz9gCBbI6uydvGEBuxaTubEKQhiZ9BwCc6otZgAtTj4WQd5m
 GPYiWOZTKUnyvW2FANCjTNgWZboyhJz1+JOz2XakbY/Bk4dFVpxUtAaY0gjlySldkeJy
 yEvBDcLPqj4jpk/tId1RxAtr3x4N6lEIqbypqpcV10x0SszciqAXNDbxC27vkxYC+dpe
 etn4upJw+Hb5cWT3ZyOdRczYEqJdaNUnETSRjrGfxrS6I2KmfsoOnfunqYK4d9X6EpCX
 Bo+w==
X-Gm-Message-State: AOAM53071SD5ZlaHdOhWpMjNxB3yx/xpKoC7vLF64IzPYjIeDln3tbg3
 JD7nrq/VoDEWlS7fezVn38Cq1sdNGiBkrun7CPi8/w==
X-Google-Smtp-Source: ABdhPJxoWeF/9UsD/zG3Z5AIQx5G4xvBwCI4PzBsciydwuujm6dRP5CD4YLqtZKa5iw/bktpgnu/NNxz4ay1XCAt02I=
X-Received: by 2002:a25:2f8e:: with SMTP id
 v136mr22214178ybv.350.1633968527209; 
 Mon, 11 Oct 2021 09:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
 <20211007233439.1826892-4-rananta@google.com>
 <87y270ou3y.wl-maz@kernel.org>
In-Reply-To: <87y270ou3y.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 11 Oct 2021 09:08:36 -0700
Message-ID: <CAJHc60w1JVHH0SGq8WiebbRNQKeZzavdO6S701yTjmmA=NHqHg@mail.gmail.com>
Subject: Re: [PATCH v8 03/15] KVM: arm64: selftests: Use read/write
 definitions from sysreg.h
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

Hi Marc,

On Mon, Oct 11, 2021 at 1:15 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Raghavendra,
>
> On Fri, 08 Oct 2021 00:34:27 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Make use of the register read/write definitions from
> > sysreg.h, instead of the existing definitions. A syntax
> > correction is needed for the files that use write_sysreg()
> > to make it compliant with the new (kernel's) syntax.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
> >  .../selftests/kvm/include/aarch64/processor.h | 13 +--------
> >  2 files changed, 15 insertions(+), 26 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index e5e6c92b60da..11fd23e21cb4 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -34,16 +34,16 @@ static void reset_debug_state(void)
> >  {
> >       asm volatile("msr daifset, #8");
> >
> > -     write_sysreg(osdlr_el1, 0);
> > -     write_sysreg(oslar_el1, 0);
> > +     write_sysreg(0, osdlr_el1);
> > +     write_sysreg(0, oslar_el1);
>
> The previous patch has obviously introduced significant breakage which
> this patch is now fixing. In the interval, the build is broken, which
> isn't great.
>
> You can either rework this series to work around the issue, or I can
> squash patches #2 and #3 together.

Thanks. I didn't realize this. I'm fine with you squashing the patches
together (I guess I would do the same).

Regards,
Raghavendra
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
