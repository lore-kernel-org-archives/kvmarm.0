Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B587C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Feb 2022 04:52:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B978E49EFE;
	Tue,  8 Feb 2022 23:52:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yqFJsTkvz77m; Tue,  8 Feb 2022 23:52:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B91F549EFF;
	Tue,  8 Feb 2022 23:52:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F036549ED8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 23:52:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pv+z7tkphR1t for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 23:52:04 -0500 (EST)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97AA749EBE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 23:52:04 -0500 (EST)
Received: by mail-pf1-f170.google.com with SMTP id i186so2357642pfe.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Feb 2022 20:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PR9huqMPKoKBRfN5n+K9Fdcj8rjbPiaTb5ftDSq6ZW8=;
 b=tQaAa/Eoya61ibJVdVxszqGG/UfmlZZiGR7xPsfkCDCEkdWlPtzGXjJApJX5e+FU9+
 wmn39wUvZIjraVZ+MZFPURdjeDgkcL2Ky+XpOYKD90Qr2JSLE4h7QDc8WD8aboPNBK4z
 74YHsm0O699dnj3zabAnBzANeZ0MyIJAj140UZqIxCqL5aOnbKkBgiAQ40c+6rjuzah7
 Mih047zYSw7TfkZGwqxqvV7SeHajB7IsYZRetsE9/ZBa+GFsdGgdPyQyoxkbvYKat+jh
 OqHjGLs+zpREYER9xZHySaCZ1+bLpAFxt3vfiHtS2RL3UtVB/y9BrkN58Kh1nsUx25hr
 mbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PR9huqMPKoKBRfN5n+K9Fdcj8rjbPiaTb5ftDSq6ZW8=;
 b=DpARItimj4vYtIaD0T8e6hzlZGWi2KkdHlibqC6ic+fHVz+wbhePtVOLUk4ZDWycvE
 Q1wLaEeZv0d+saZE52WYtTEiJth4Dkcvqyx+lWgCQ82RH4c/I5Vz059m/YmAX8bhRExJ
 C5k8yw1Th24ejTD79++cRMl/4qIMUcyfcsrKxRfb79epwH0CRfqIVjJaQcBWQ6BygqQB
 BaFQuRO+e1lhs+qQ+pbDSO1XuLmd90g2zO+Y7V7MjzWIONzXhwz6fuDzot8Mdi/1YLOY
 s/cXlJ17hcqoh3zGznKrh44qwse33LuJ6Y9ooNi6WQSPwE+sfcb6TtuZy2NAHQUUM1Wo
 ei6w==
X-Gm-Message-State: AOAM533OWuoSoURg+I9XOtD9a9TZbXwKnxy0bI6zdXXDCuJ+YMhQ1xwN
 GXFNeKQQAz3a81wWZigEVUC8bBwP7kCPBd9og6DHLQ==
X-Google-Smtp-Source: ABdhPJyJlqEofZ7FNvhCVWK/Fj3kLxyOD4l5cf2Tx4Vqf1uOnZGRpCs5oYUnLgprJaxq8w4j07PtbuNWc1rPBvp8/4I=
X-Received: by 2002:a63:2b4d:: with SMTP id r74mr547546pgr.514.1644382323360; 
 Tue, 08 Feb 2022 20:52:03 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-24-reijiw@google.com>
 <CA+EHjTxYqPvyUz96hoJWe43raST1X7oKhdR7PeZDuwuuD9QcYQ@mail.gmail.com>
 <CAAeT=FxKgH_a7vthT3ai_TiCu9UCj+PNJ6SarHDF+R5tcR--Dg@mail.gmail.com>
In-Reply-To: <CAAeT=FxKgH_a7vthT3ai_TiCu9UCj+PNJ6SarHDF+R5tcR--Dg@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 8 Feb 2022 20:51:47 -0800
Message-ID: <CAAeT=Fz5noen=eFJZVAsRdzJY98Gno27U4kv_sLDBHXY_ZVKRA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 23/26] KVM: arm64: Trap disabled features of
 ID_AA64MMFR1_EL1
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Fuad,

> > The series might be missing an entry for ID_AA64MMFR0_EL1, Debug
> > Communications Channel registers, ID_AA64MMFR0_FGT -> MDCR_EL2_TDCC.

Looking at Arm ARM, it appears any of the registers that can be
trapped by MDCR_EL2_TDCC are present even when FEAT_FGT is not
implemented (I understand MDCR_EL2_TDCC is available when FEAT_FGT
is implemented though).  So, this is not something that the
framework is trying to address.

Thanks,
Reiji

>
> I will add them in v5 series.
> Thank you so much for all the review comments!
>
> Thanks,
> Reiji
>
>
> >
> > Cheers,
> > /fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
