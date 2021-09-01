Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F7FC432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:43:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C443260FDA
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:43:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C443260FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43BCD4B0FC;
	Wed,  1 Sep 2021 18:43:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zf4-yybGFslf; Wed,  1 Sep 2021 18:43:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 525B94B11C;
	Wed,  1 Sep 2021 18:43:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEAD94B104
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:43:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uiLpeR-pXuQp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 18:43:37 -0400 (EDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com
 [209.85.219.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C23444B0FC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:43:37 -0400 (EDT)
Received: by mail-yb1-f169.google.com with SMTP id q70so1677670ybg.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 15:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=U+r4CwgKG+yEodhHzC7nFI5Y9Wnbyo4zL9qFFX9zlnM=;
 b=JOkMP8RXO6jdIjIDD6ZH3jrv9UvB6l279lUpP6filw3CBk6k1N1Hwj4bB+HLyMDRma
 boD3ZbnLqtdnNwuqesuS2HLMkqRyrZHeaia+pvNPCT5BKtEqWOmyEyiXQxJAyJC7Tf9q
 4ZnqybnkHfs+Ms/08GdCeE+nkY2Z4/6wD9jZtk51UPliBiGeD3r02osFUGdJfXWK+37N
 Rh2HJkrC41dh2GjZCh7Y9ajtEv3CGhIGQOw3dol55gzG/dj6A8DAPpPCYb1Sl+W+o/jy
 0sCXMnz+HIYSyDRFWFsuXdBSq+fQWnvW9N3oN7tIEn+y26OGONWz2qjuMjcUCQuC9gw/
 GLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=U+r4CwgKG+yEodhHzC7nFI5Y9Wnbyo4zL9qFFX9zlnM=;
 b=o+Yld80J107Xh3Xna61YCcJYWC7XBQ5FVkzsxpEMzXSndZCvgS2+LH08Qy/iNEmLrQ
 al1nDzbZM7yGQHR63H3Einz8GFBZg5LiDJXwccmWHPuP/HPikywsJrGsNhm7/slzWTkM
 T8aBNIhKXyx5M2kx1meNvTBOHGBT1KXCAa6PNRoVJGHVOURmwG7LtXSqaLJO1COVg426
 TGtrrKRRrjQBPIeqGBDxxzyf+aZz9jGFn8FcyhyYhMF92gr4NxXyI4FT0iWtq0m5W57H
 /kKmTVwdRioIdX3u6qzgscB/nYP87kwrGuoclHeK0QEMZZrb4aQ6OsAjrL6fLzuUf2dk
 lemw==
X-Gm-Message-State: AOAM533nyZcs6IOFpU6cl/ABLyv+iMg3Pg7gKiVP7HvE04eEqslDNXeM
 v8/m3y+dOC3FYE7cBwjG1pwHLTQbKabUZhDdJu3C+A==
X-Google-Smtp-Source: ABdhPJzi+Lf0Xejnkm0ckXhh2uNvzEvpcGrgx17PRpTaVpfoZFF6sLe4mbguXZjsOTaBLHIIADIlXq1Ey2THBjkzhnc=
X-Received: by 2002:a25:6507:: with SMTP id z7mr276648ybb.439.1630536217085;
 Wed, 01 Sep 2021 15:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-2-rananta@google.com>
 <YS/vTVPi7Iam+ZXX@google.com>
In-Reply-To: <YS/vTVPi7Iam+ZXX@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 1 Sep 2021 15:43:24 -0700
Message-ID: <CAJHc60wx=ZN_5e9Co_s_GyFs4ytLxncbYr2-CzmTUh5DvvuuNQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] KVM: arm64: selftests: Add MMIO readl/writel
 support
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 1, 2021 at 2:23 PM Oliver Upton <oupton@google.com> wrote:
>
> On Wed, Sep 01, 2021 at 09:14:01PM +0000, Raghavendra Rao Ananta wrote:
> > Define the readl() and writel() functions for the guests to
> > access (4-byte) the MMIO region.
> >
> > The routines, and their dependents, are inspired from the kernel's
> > arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
> >  1 file changed, 44 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index c0273aefa63d..3cbaf5c1e26b 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -130,6 +130,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
> >       val;                                                              \
> >  })
> >
> > -#define isb()        asm volatile("isb" : : : "memory")
> > +#define isb()                asm volatile("isb" : : : "memory")
>
> Is this a stray diff?
>
Oh no, that's intentional. Just trying to align with others below.

Regards,
Raghavendra
> Otherwise:
>
> Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
