Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67F0C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Nov 2021 05:33:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ECAB4B10D;
	Thu, 25 Nov 2021 00:33:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wr1QJGRISC2M; Thu, 25 Nov 2021 00:33:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 500424B13E;
	Thu, 25 Nov 2021 00:33:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38A784B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 00:33:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KibxRmRgRBCo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Nov 2021 00:33:43 -0500 (EST)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 576764B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 00:33:43 -0500 (EST)
Received: by mail-pj1-f46.google.com with SMTP id gt5so4346868pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 21:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=F9g4xULBwZ+ZoDl9tIJMXCBnfTmSTJxIQ0HNhTAXC/I=;
 b=fb+3v4ffk4g5s+KvWydS5QdlR+7lURUkJlUA0vsYZyVV/03IP1SYtTmmVO3PLOU7PZ
 3HZkI9Evg/ca6OsxRLiP6FEPNyc6dFCgzCRrQfcDcd2EQrLuDcIv3+MXP2i1nQg4IFJ8
 iQ23tGUl8ZF76E8CNCXakDy//DCeYfRHz9TLeGtge+717P6PSWw3imuSdk3C71ripq/Z
 Q+VuSlKfNud7ln5leGQt920UtvwW7/sW4a++aRP+SYtEsmSilbwDLI5o/Xnz7ySE0die
 UYop0U6tXfzBnX1ghJcRfJuo9tvpKFA8OUNqYQZ56dRTl03CUlLc18RwGhR6Z+j0PGwB
 DvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=F9g4xULBwZ+ZoDl9tIJMXCBnfTmSTJxIQ0HNhTAXC/I=;
 b=pzMVee8CqZMgFCMJEhADpv48awjMx6GQW0JgmUQMrlczb8FMgPbj+Hok+SALAvDCZ7
 Q1gqhNyfSiYu5d0oq2ueXLda/AFy1EyASUyf85ocFp1jv0u7qtzTlBKEu74np+Flk3mJ
 vV17UK+ZLEGKFzUgwi9/tluBbGnpMshh37SnhK2TeoD5G06m8is6Wk/RaelqKci81HqT
 JKX6jyXPxkE2AgIA9+te9Ey0drZHlV2bu2p2hWVS9LrdfgtOQzVfBMsxVXyGgmkJ68K7
 R92sVHeyjiSCqgk9zbzh0/OS0yjqdTXgl4eG2FRPICCUFPWroBHOZynDVK+rAyZMAYoN
 0xHA==
X-Gm-Message-State: AOAM532MtDJISiJg4KNRnyM8W9c9kioacqmp6JKipoyYlooRJj8MbM+G
 pdA1CB2/VblQcgFgwLGEWSLJoRQ7j7fBTQpx8eqKTQ==
X-Google-Smtp-Source: ABdhPJxSwEoay0qQlzFoarAjVDlXI8Nd+iv7hTVgKv5MYQhPEnhjw+KnkNvlyZ+hMZ/rE7RdtbS4YCNKfxNC8WoF4ik=
X-Received: by 2002:a17:902:ab47:b0:141:95b2:7eaf with SMTP id
 ij7-20020a170902ab4700b0014195b27eafmr26064371plb.40.1637818422185; Wed, 24
 Nov 2021 21:33:42 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-12-reijiw@google.com>
 <cda3eb28-1cf6-da6e-1769-104c29f81d4a@redhat.com>
In-Reply-To: <cda3eb28-1cf6-da6e-1769-104c29f81d4a@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 24 Nov 2021 21:33:26 -0800
Message-ID: <CAAeT=Fz1vCJhypbiUbSkMGhf3mmn9gyaSJgXYETrBD0zyyHeSg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 11/29] KVM: arm64: Make ID_DFR0_EL1 writable
To: Eric Auger <eauger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Eric,

On Wed, Nov 24, 2021 at 5:46 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_DFR0_EL1 to make it writable
> > by userspace.
> >
> > Return an error if userspace tries to set PerfMon field of the
> > register to a value that conflicts with the PMU configuration.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 52 ++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 46 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 0faf458b0efb..fbd335ac5e6b 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -665,6 +665,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > +                             const struct id_reg_info *id_reg, u64 val)
> > +{
> > +     bool vcpu_pmu, dfr0_pmu;
> > +     unsigned int perfmon;
> > +
> > +     perfmon = cpuid_feature_extract_unsigned_field(val, ID_DFR0_PERFMON_SHIFT);
> > +     if (perfmon == 1 || perfmon == 2)
> > +             /* PMUv1 or PMUv2 is not allowed on ARMv8. */
> > +             return -EINVAL;
> > +
> > +     vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
> > +     dfr0_pmu = id_reg_has_pmu(val, ID_DFR0_PERFMON_SHIFT, ID_DFR0_PERFMON_8_0);
> > +
> > +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> > +     if (vcpu_pmu ^ dfr0_pmu)
> > +             return -EPERM;
> This breaks the migration on ThunderX v2 as vcpu_pmu == true and
> dfr0_pmu == false

Yes, this is the same (incorrect) assumption as the selftest.
I will fix this as well.

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
