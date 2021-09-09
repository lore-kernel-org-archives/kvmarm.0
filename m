Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2ECAC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:50:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7944F6113A
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7944F6113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0708F4B175;
	Thu,  9 Sep 2021 12:50:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lo80JkmVPzcg; Thu,  9 Sep 2021 12:50:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6EE64B129;
	Thu,  9 Sep 2021 12:50:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EF734B15B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:50:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xWn5lZrpJkbg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 12:50:02 -0400 (EDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com
 [209.85.219.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9157F4B0E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:50:02 -0400 (EDT)
Received: by mail-yb1-f177.google.com with SMTP id a93so5220003ybi.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 09:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pZZOGzt5oKbWLt2jfyo0/YulPHEm4sBwR6royMlN8x0=;
 b=NRaEOqyBM610pgGJsqTqL4Gdbp/NB5GTK4jCV/T1gFFYlvThnghqZylNnYIGe3OXV0
 fN1hbhdX7yXdr7kCCk4Tg2v6p0xlI7I1FEEKIu8mquddRmJ3eb5cwNTsoFUeX3108ilX
 cKRAXjtWECHFTSAm3CtzOPse6OECVtJvbuvPiG6jyJbmivIZB1NqupLU/BkMUN5+mxnu
 CBq4ATdHpCeZAPpoihGvjEVhOSQi/jJT9OksS+A7+Ep+BXpE1duD8YRrQnxRoJ8DJO06
 +T02alyunIml6+cqUxAbq2/82O3P2HKjWqBf/p28vKQGkbylTqKv6OOsXgwV+MzRelnV
 fnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pZZOGzt5oKbWLt2jfyo0/YulPHEm4sBwR6royMlN8x0=;
 b=sXI2g00brG9/+o5KvvLmpNT3Lg9YDyE6Gng89KLvjenYMKEmvqZ8ZGhdjHaltfY8Rp
 ANvxZ8xmvyUGlxG7AcjQ9lJjUedl6fz6F762LXWSdDqXFimUuNW6r2OzjspPege1CBdY
 jQz2k2FExfJEVFiTveCfCoZZTIac20EINfDBRofqYZu8w+mOzlJoK//0Jn4LoUbAkPQu
 /6UL+T5uguZB216nHajxs8dRNd+Qg6Tjp0KSVFsD0h8joDPlRgO7ztBn1xJE8GRMGLJV
 6IhFOQMSGgOluEQU3N5+IzsyaXrCfBxgbSPJDWzz0FJnSNEhemKyspd4+pNFbXO44pXq
 1SyA==
X-Gm-Message-State: AOAM533RZoo5S0JvuPyYDtAnT+VD86NWQusQC0eLGSEHjIMXpAGlGxcA
 CCdRiIF21HZZ57Fq4UJAsrVvcYJmq68QylQjk4MOqw==
X-Google-Smtp-Source: ABdhPJzWGqJzOaqHFiOaZZSFb/gHx+W2eWc2XTLC4gq0ldXwPD5pdi5JVNosEBPqyBM7wbyg4V3MzalTA9vcbJP2inM=
X-Received: by 2002:a25:cd82:: with SMTP id d124mr5134084ybf.491.1631206201951; 
 Thu, 09 Sep 2021 09:50:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-5-rananta@google.com>
 <20210909070423.5z4eg7wkmswpdi33@gator>
In-Reply-To: <20210909070423.5z4eg7wkmswpdi33@gator>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 09:49:50 -0700
Message-ID: <CAJHc60yU8ihjS9Y1aPOkjv8MpPy0x7=X7kQxnU2aXUjYTe3M7w@mail.gmail.com>
Subject: Re: [PATCH v4 04/18] KVM: arm64: selftests: Introduce
 ARM64_SYS_KVM_REG
To: Andrew Jones <drjones@redhat.com>
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

On Thu, Sep 9, 2021 at 12:04 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:04AM +0000, Raghavendra Rao Ananta wrote:
> > With the inclusion of sysreg.h, that brings in system register
> > encodings, it would be redundant to re-define register encodings
> > again in processor.h to use it with ARM64_SYS_REG for the KVM
> > functions such as set_reg() or get_reg(). Hence, add helper macro,
> > ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> > into ARM64_SYS_REG definitions.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h      | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index bed4ffa70905..ac8b63f8aab7 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -26,6 +26,20 @@
> >
> >  #define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
> >
> > +/*
> > + * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
> > + * SYS_* register definitions in sysreg.h to use in KVM
> > + * calls such as get_reg() and set_reg().
> > + */
> > +#define ARM64_SYS_KVM_REG(sys_reg_id)                        \
> > +({                                                   \
> > +     ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),          \
> > +                     sys_reg_Op1(sys_reg_id),        \
> > +                     sys_reg_CRn(sys_reg_id),        \
> > +                     sys_reg_CRm(sys_reg_id),        \
> > +                     sys_reg_Op2(sys_reg_id));       \
> > +})
>
>
> I don't think we need the ({ }), do we? Anyway,
>
I guess we don't. Must have left it there while I was trying a few
things. Will clean it up.

Regards,
Raghavendra
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> Thanks,
> drew
>
> > +
> >  /*
> >   * Default MAIR
> >   *                  index   attribute
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
