Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1216C11F67
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:53:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CF7661420
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:53:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CF7661420
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0954A4BE;
	Thu,  1 Jul 2021 10:53:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SMOm6bxjefAu; Thu,  1 Jul 2021 10:53:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A01AD4AEDC;
	Thu,  1 Jul 2021 10:53:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 426A54A95C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:53:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T8LdH09xmDO5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 10:53:07 -0400 (EDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com
 [209.85.210.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3498F4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:53:07 -0400 (EDT)
Received: by mail-ot1-f44.google.com with SMTP id
 o13-20020a9d404d0000b0290466630039caso6770917oti.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 07:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=5EFDBeL4wmuZzEbs7W+rIl4VyjBJBLY3vyT7h6elrGA=;
 b=vV25TS8DGjTcLhoaG8JoSVRTN137gfLNlZwE6Q4PMet7uinfsLarQeqamk5xjmNLrh
 cTR7RTrlksJg+LwmIePOuAHbuEv/z2xx8+uHUX0jEdGxHg1H3ycgdcEeLVWj7p/JF06i
 ZxbbESPoOqDKqPjLul4K1iiCCOYUVM1r0xlFoae6ujZqLzzyq0HiIFOqxrBw+i6HWVlX
 5VP0div0jR4WLPf7Vnq8Pmy/HHs1TG7E7eEtikRNETJq44JHSa3CLcnOaIdYBk35lvWQ
 Y1GU2i/WF1zz+Is7N4CCjH9u1R0QAAjljxQl9D1dFcEy9byfiLPoYIxn+9rp1BLklEjA
 Sm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=5EFDBeL4wmuZzEbs7W+rIl4VyjBJBLY3vyT7h6elrGA=;
 b=gntOJna4pYv6sm70h3cVaC1Llayr+iWXnd7qjzTXzS758gKm83tvginiAT+JpmneFy
 5IiSXkC6d+Kh/6Z5qq1IC5cS3YE0oyafgS0eYokpENYdnWkPrCWVsljxUzTI6tW6FFUC
 uRYPqX/rHorkbzDwSv+cYVEnUy8D/7rGjJRthEDsqksvtsJxf85Q4d6SeG/GgWYr9oNf
 2XVsCikqZiCMrdNIw7GfyZJf75bLuMjIoTiKLz3gHrjV1pCqaQd8JI8ts8wXXEDYDql3
 j93YshO9ADcgnLiR1eGjKYLj63RSOkqHLGBMdyqeffsTQ8PxJjPY5gtnxu0WEBPV2/Dw
 m3MQ==
X-Gm-Message-State: AOAM530qiPM2yo0DvdSOwk2izrOGAzvWF3zxb7UXgjBWBidp0AiBc1Mj
 5Hs3Fr9HLQBUZhg8o8uQf9/6Qq18W+TnYA3Ozq4K+A==
X-Google-Smtp-Source: ABdhPJyWv/g4Ufw9xByzk3S6K4RbKA13wD+M2R4G/yMkrndH3boaDzw5iojn1U42XqhCK2L7/zSG9LMBVCOlJuZFVHw=
X-Received: by 2002:a9d:17c5:: with SMTP id j63mr354113otj.52.1625151186279;
 Thu, 01 Jul 2021 07:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-8-tabba@google.com>
 <20210701133311.GG9757@willie-the-truck>
In-Reply-To: <20210701133311.GG9757@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 15:52:30 +0100
Message-ID: <CA+EHjTzssPziK9Vj3i7iUN5jtf=dRJdm+QoKJR7RTFzfbwB2Wg@mail.gmail.com>
Subject: Re: [PATCH v2 07/13] KVM: arm64: Add config register bit definitions
To: Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Thu, Jul 1, 2021 at 2:33 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:44PM +0100, Fuad Tabba wrote:
> > Add hardware configuration register bit definitions for HCR_EL2
> > and MDCR_EL2. Future patches toggle these hyp configuration
> > register bits to trap on certain accesses.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index bee1ba6773fb..a78090071f1f 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -12,7 +12,11 @@
> >  #include <asm/types.h>
> >
> >  /* Hyp Configuration Register (HCR) bits */
> > +#define HCR_TID5     (UL(1) << 58)
> > +#define HCR_DCT              (UL(1) << 57)
> >  #define HCR_ATA              (UL(1) << 56)
> > +#define HCR_AMVOFFEN (UL(1) << 51)
> > +#define HCR_FIEN     (UL(1) << 47)
> >  #define HCR_FWB              (UL(1) << 46)
> >  #define HCR_API              (UL(1) << 41)
> >  #define HCR_APK              (UL(1) << 40)
> > @@ -55,6 +59,7 @@
> >  #define HCR_PTW              (UL(1) << 2)
> >  #define HCR_SWIO     (UL(1) << 1)
> >  #define HCR_VM               (UL(1) << 0)
> > +#define HCR_RES0     ((UL(1) << 48) | (UL(1) << 39))
> >
> >  /*
> >   * The bits we set in HCR:
> > @@ -276,11 +281,21 @@
> >  #define CPTR_EL2_TZ  (1 << 8)
> >  #define CPTR_NVHE_EL2_RES1   0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
> >  #define CPTR_EL2_DEFAULT     CPTR_NVHE_EL2_RES1
> > +#define CPTR_NVHE_EL2_RES0   (GENMASK_ULL(63, 32) |  \
> > +                              GENMASK_ULL(29, 21) |  \
> > +                              GENMASK_ULL(19, 14) |  \
> > +                              (UL(1) << 11))
> >
> >  /* Hyp Debug Configuration Register bits */
> >  #define MDCR_EL2_E2TB_MASK   (UL(0x3))
> >  #define MDCR_EL2_E2TB_SHIFT  (UL(24))
> > +#define MDCR_EL2_HPMFZS              (UL(1) << 36)
> > +#define MDCR_EL2_HPMFZO              (UL(1) << 29)
> > +#define MDCR_EL2_MTPME               (UL(1) << 28)
> > +#define MDCR_EL2_TDCC                (UL(1) << 27)
> > +#define MDCR_EL2_HCCD                (UL(1) << 23)
> >  #define MDCR_EL2_TTRF                (UL(1) << 19)
> > +#define MDCR_EL2_HPMD                (UL(1) << 17)
> >  #define MDCR_EL2_TPMS                (UL(1) << 14)
> >  #define MDCR_EL2_E2PB_MASK   (UL(0x3))
> >  #define MDCR_EL2_E2PB_SHIFT  (UL(12))
> > @@ -292,6 +307,12 @@
> >  #define MDCR_EL2_TPM         (UL(1) << 6)
> >  #define MDCR_EL2_TPMCR               (UL(1) << 5)
> >  #define MDCR_EL2_HPMN_MASK   (UL(0x1F))
> > +#define MDCR_EL2_RES0                (GENMASK_ULL(63, 37) |  \
> > +                              GENMASK_ULL(35, 30) |  \
> > +                              GENMASK_ULL(25, 24) |  \
> > +                              GENMASK_ULL(22, 20) |  \
> > +                              (UL(1) << 18) |        \
> > +                              GENMASK_ULL(16, 15))
>
> There's an inconsistent mix of ULL and UL here. Given we're on arm64,
> maybe just use GENMASK() and BIT() for these RES0 regions?

The reason I use GENMASK_ULL instead of GENMASK, and UL()<< instead of
BIT is to remain consistent with the rest of this file. It would
definitely be clearer here, as you point out. I'll fix it.

> Anyway, the bit positions all look fine. You're missing HLP in bit 26,
> but I guess that's not something you care about?

I don't need that bit. I could add it for completeness, but there are
a few others that aren't here either...

Cheers,
/fuad

> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
