Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000B6C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 20:18:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6637A61131
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 20:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6637A61131
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D76AC4B118;
	Thu,  2 Sep 2021 16:18:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OMV0MJ2eYxPw; Thu,  2 Sep 2021 16:18:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C25B94B0DF;
	Thu,  2 Sep 2021 16:18:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFF44B0CD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 16:18:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dvxQFNnXA9pC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 16:18:05 -0400 (EDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34FBA4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 16:18:05 -0400 (EDT)
Received: by mail-lf1-f46.google.com with SMTP id m28so6991857lfj.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 13:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kzEtkuBtgfdvovJGx2vNeyWTM6t8k4a79v7QJawW9b8=;
 b=czGzwIMYk81Mo1UJ4KLBEMDUAJvz72+tHL59F2iqeJk960mlsaXhCo6R022M2B07In
 duNGe9KfQKyTsvzzYDEE/6gpDpJScLS3A22Ghj96PHMr8rHTCQBBGbl41GBkkuIH0/bC
 aIpH1wwpwOHtICD6ACln6eiZiMIz45skiZ40YUinZUOhCBApaFAZJOCiHd1r4WWJm/o1
 7QsFY/sTTBnpybIyL0Xz0VGaPF9lVWBtEoOwLm+P8CNil6/2RGI8w24dBMv7qFwq3jAM
 lz/+xaiQHFvLPsxv2B3l2NkKzpM66+Qt5K1VslIIIf23xOqBi9Y4kM+tJsi1OjA6+ES4
 +RLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kzEtkuBtgfdvovJGx2vNeyWTM6t8k4a79v7QJawW9b8=;
 b=ablQwAUHSsN121tMsE8mgWq0vpG7Simw4JxqlLj8rjlxli0gc57lwMHPHOQaXjqYkf
 /oISMSs1NTc6fM2W6Z6dXYk9f1tJu3pZdnfcHlbNJduaIWyNm0Fj9S39vOkYOVAh/bR8
 cP90qCZ1tnOzRdRb77tz3Tb1ee6h/LA5c5mKqYQ78aRsqR7gfgbDgx4lXy9eMs83EJSL
 PBasvhFBjVsRzh3nj/BwxQTffCFxoCZZ7SmxgL6Y3/tiG/dJrLo/4IZKMqHkKay3dW8j
 puHaRAyunB79kp3cLtVM4YqD7zS4Q9Oqsw9YLg0Y8eLKWn84/tLF0OdJocAKINGnvEei
 vTvQ==
X-Gm-Message-State: AOAM530tz/px2wcLpdt8sTNKeKjdH8dGQV0GLf2IJI25mFiqMuG7m4H0
 zH5t4hOTWO41AglKX4zR/nwOJ+eAZFa1lVWYdYhkAw==
X-Google-Smtp-Source: ABdhPJzwP18p+J/0zyaKhKGt7l6t2j60BMaCA6xIyB2Wj57888oDOG4H3w28g6Q09+bAJl5bJu0e7lkzr6X+zUIG2KE=
X-Received: by 2002:ac2:43b6:: with SMTP id t22mr4052lfl.0.1630613883673; Thu,
 02 Sep 2021 13:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-2-rananta@google.com>
 <YS/vTVPi7Iam+ZXX@google.com>
 <CAJHc60wx=ZN_5e9Co_s_GyFs4ytLxncbYr2-CzmTUh5DvvuuNQ@mail.gmail.com>
In-Reply-To: <CAJHc60wx=ZN_5e9Co_s_GyFs4ytLxncbYr2-CzmTUh5DvvuuNQ@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 2 Sep 2021 13:17:49 -0700
Message-ID: <CAOQ_QsgQongwOuj2FCTB-iRsscMYV2myN5Czae2B_vmasMOvnA@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] KVM: arm64: selftests: Add MMIO readl/writel
 support
To: Raghavendra Rao Ananta <rananta@google.com>
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

On Wed, Sep 1, 2021 at 3:43 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Wed, Sep 1, 2021 at 2:23 PM Oliver Upton <oupton@google.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 09:14:01PM +0000, Raghavendra Rao Ananta wrote:
> > > Define the readl() and writel() functions for the guests to
> > > access (4-byte) the MMIO region.
> > >
> > > The routines, and their dependents, are inspired from the kernel's
> > > arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
> > >  1 file changed, 44 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > index c0273aefa63d..3cbaf5c1e26b 100644
> > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > @@ -130,6 +130,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
> > >       val;                                                              \
> > >  })
> > >
> > > -#define isb()        asm volatile("isb" : : : "memory")
> > > +#define isb()                asm volatile("isb" : : : "memory")
> >
> > Is this a stray diff?
> >
> Oh no, that's intentional. Just trying to align with others below.

You are of course right, I read the diff wrong and didn't think it was
correctly aligned.

Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
