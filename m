Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C728C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Apr 2022 17:33:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F395840F9C;
	Wed, 13 Apr 2022 13:33:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id owGDTi1srDuP; Wed, 13 Apr 2022 13:33:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E768C40DE6;
	Wed, 13 Apr 2022 13:33:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 168F540F9C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 13:33:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LIVjLXXF2eKO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 13:33:37 -0400 (EDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E593240CDE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 13:33:37 -0400 (EDT)
Received: by mail-yw1-f177.google.com with SMTP id
 00721157ae682-2eba37104a2so31109177b3.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 10:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=EUnyNdRKdjadDVWbLbSBbs4tv5nFop0mFUm/kQpcegc=;
 b=JHg+qGW4VjvrvMYp74vPHEk3ocTrygLHiYLeXeHCXxO9Xw+NyQgbk/cFH5mf8tsXyJ
 k5lWMkz2OCxERXnXRnpPUkKnulMz22Wie1UCSvT+zfLgv5+lqejuWr7g+te0dsgkgA9o
 k2qWZ/6NmvWhV/k81jC1OLYDc7h9WXfxYnf3dSCTA6NOOAz3G0/KPZWDTtLGqdkEHh6z
 wSdrismoIzHhYNLsNQ8tfx7g9qKAJiZOWsAsd4MKvgjaH8rSXzDr8bkZEcNq0vFxJYQB
 dKpb3L9pEOn3QD+XA8HbXIQIrHH+SuYoJWyVZG3nqFm75OsjBPpTTteEGPxPQ5ikZQMX
 WFfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=EUnyNdRKdjadDVWbLbSBbs4tv5nFop0mFUm/kQpcegc=;
 b=K0nWi97C99cEaZweHjm5/jpX3XWZSk0lK/fsUv8CXdznjOk8zNQVF9rWUnOsvTQJ8y
 vUTeZJ7bLvKyxEuf8Jf+CB+y9gnV1VBcH3vDSmgi2E2Y4WiEYgj9hJqns9FIYYqg4Mrt
 tT0mFrtOYbEMcRgwRi8Zz+Z/i/8P/NxBJKSciD3BWOoDth7vSxphwi1GY52xv/F+paQK
 pP50WHfkrkMM+BT7ARH2Qn1YQIBKtUVuFhnzAbBa1jEXOgXzy7wKGSZ2Q2JiIP+CqOv5
 XoEvvDS4i6reBQdYGTEZ/lFL1aNAI8FNbny52l6htMf+ORkpIle1g0gHiSKr2jZkcwe1
 mcJA==
X-Gm-Message-State: AOAM532OKVGBftiJ+qfqSiozgW+JNKUulESaBvybd/pwBEkBNMT458p/
 PlBJVhpiJG1symhqYmnJMyF6KhJCEn6yWzSarCG64A==
X-Google-Smtp-Source: ABdhPJxMsdUTKsiAhyJ/g2oojWzrjB+GtmrzMkEpK7B//XBmgkCAjkrTP3zFdicJiWibleet6HYKAe1qZE//TEuxCso=
X-Received: by 2002:a81:6b02:0:b0:2ee:e2d:12f5 with SMTP id
 g2-20020a816b02000000b002ee0e2d12f5mr12242ywc.200.1649871217246; Wed, 13 Apr
 2022 10:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
 <20220407011605.1966778-11-rananta@google.com>
 <b3cfe975-de18-ea21-f174-1124803f314d@redhat.com>
In-Reply-To: <b3cfe975-de18-ea21-f174-1124803f314d@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 13 Apr 2022 10:33:26 -0700
Message-ID: <CAJHc60w3KMGB5k7qG9bWtGGha5_fSqcGHubF8JsXigQDmfR76g@mail.gmail.com>
Subject: Re: [PATCH v5 10/10] selftests: KVM: aarch64: Add
 KVM_REG_ARM_FW_REG(3) to get-reg-list
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Apr 13, 2022 at 2:22 AM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Raghavendra,
>
> On 4/7/22 9:16 AM, Raghavendra Rao Ananta wrote:
> > Add the register KVM_REG_ARM_FW_REG(3)
> > (KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3) to the base_regs[] of
> > get-reg-list.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > index 281c08b3fdd2..7049c31aa443 100644
> > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > @@ -691,6 +691,7 @@ static __u64 base_regs[] = {
> >       KVM_REG_ARM_FW_REG(0),
> >       KVM_REG_ARM_FW_REG(1),
> >       KVM_REG_ARM_FW_REG(2),
> > +     KVM_REG_ARM_FW_REG(3),
> >       KVM_REG_ARM_FW_FEAT_BMAP_REG(0),        /* KVM_REG_ARM_STD_BMAP */
> >       KVM_REG_ARM_FW_FEAT_BMAP_REG(1),        /* KVM_REG_ARM_STD_HYP_BMAP */
> >       KVM_REG_ARM_FW_FEAT_BMAP_REG(2),        /* KVM_REG_ARM_VENDOR_HYP_BMAP */
> >
>
> It seems the same fixup has been done in another patch.
>
> https://www.mail-archive.com/kvmarm@lists.cs.columbia.edu/msg38027.html
>
Yes, Andrew won the race :(
I'll drop this patch.

> Thanks,
> Gavin
>

Regards,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
