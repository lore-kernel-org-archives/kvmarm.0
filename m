Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00CFC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 05:22:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F6774B132;
	Tue, 30 Nov 2021 00:22:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JXTTpm8Fqsda; Tue, 30 Nov 2021 00:22:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D49E54B173;
	Tue, 30 Nov 2021 00:22:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5D714B13A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 00:22:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p4xlgi1Q0pEH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Nov 2021 00:22:15 -0500 (EST)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A34384B139
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 00:22:15 -0500 (EST)
Received: by mail-pg1-f175.google.com with SMTP id s137so18525923pgs.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 21:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nMzdk7WdQ8L/HP0hzBLAG2QVUEAIjcUDryoTsnqwXLE=;
 b=j1EfdfUnVBej9nEQbRyBAto+p5BeBeWJB5e/BtcbuTktC5IOpismY9XzOhyKnFuW/G
 CwvztOqzmum15yJxT13kcTqhT4ia1tLNBmSMKuLRFCozTTrtMODetJAZBtw+fnBP/b6X
 NM3yo9jBcjgrtJoUeGv3TlE5GFjizOtXpkzwoEm98Gj6HKnENHmF7KxuU4TVJyTilia9
 H4VcjlkC3x0I4qAjgwJ09Ayiww35c8Lz+oYzSbOyoNwxUq/OePB2UrK7AZG3noeDAdQt
 1Rv0PbBAxE3NYTCCmtu6qmPeM5Uj+MJ/yzYYDwmiJe8D86fuXEOFKiGn+B+r/T3XwULn
 daww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nMzdk7WdQ8L/HP0hzBLAG2QVUEAIjcUDryoTsnqwXLE=;
 b=ipc+mxcakz4vOpMb02F1WoG8jECev4cfPHgEiflBpBmK9ghM1pPLk9gJC3H+V37OCA
 EKM+nGdtblpkBlCExTKdzZb6/ld3H2LJPqwzE/93J4gZ0n8OOhGOB74RB7lhyOrit8e8
 xDusSdxi7B9UqA5CqXmvuXf1WbSvT9PoC7dKUKzWue8ZsCylxoE50WXobxQIxNHAoZxO
 6MaK7aAcPxJUm9wkdYpfS4NhQeSW2Pu06Iafm4BqE+hp9lfm0llfKBg1kcJSKrqRC+nZ
 UjJaLbldH2ZdPKajqnZBGclWrZ6faqK8iyVpHNbzfSfXpKsi+oh+T+rRb5UVS0TAGHzG
 M54A==
X-Gm-Message-State: AOAM5335nVSldaXOzwtbRddHfj/NKUIjBEHX+zHpvb9e8IrOfDb2Jt+o
 lw8jSHf5/giQ0O7V5yI+r3muCUmMVFLJ07sTbXDPZA==
X-Google-Smtp-Source: ABdhPJxWZ/PB1tDWrTWrdQnIfBdcsVY7+Ir97BsmQlGLYsjIg2R5RFwEdXK4R9zRLS/FQk9SU8UmlTgMNk2bjt6aIMI=
X-Received: by 2002:aa7:9d9e:0:b0:4a0:25d0:a06f with SMTP id
 f30-20020aa79d9e000000b004a025d0a06fmr45090946pfq.82.1638249734570; Mon, 29
 Nov 2021 21:22:14 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-11-reijiw@google.com>
 <bb557b85-8d28-486e-d22c-b3021888bcf8@redhat.com>
In-Reply-To: <bb557b85-8d28-486e-d22c-b3021888bcf8@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 29 Nov 2021 21:21:58 -0800
Message-ID: <CAAeT=FwBpc0Ue=rUiCaL=7p7e_SmKPLG=74EK+GZN4kftdJJtA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 10/29] KVM: arm64: Make ID_AA64DFR0_EL1 writable
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

On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_AA64DFR0_EL1 to make it writable
> > by userspace.
> >
> > Return an error if userspace tries to set PMUVER field of the
> > register to a value that conflicts with the PMU configuration.
> >
> > Since number of context-aware breakpoints must be no more than number
> > of supported breakpoints according to Arm ARM, return an error
> > if userspace tries to set CTX_CMPS field to such value.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 84 ++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 73 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 772e3d3067b2..0faf458b0efb 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -626,6 +626,45 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +static bool id_reg_has_pmu(u64 val, u64 shift, unsigned int min)
> I would rename the function as the name currently is misleading. The
> function validate the val filed @shift againt @min

Thank you for the comment.

The @min is the minimum value that indicates PMUv3 support.
So, if the field value is >= @min, it means PMUv3 is supported.
I want the function to check whether or not @val indicates PMUv3 support,
and that's how the function is used.
I can see what you meant focusing on the function though.
But, if we renaming it to xxx_validate, that would be misleading in the
codes that use the function.

> > +{
> > +     unsigned int pmu = cpuid_feature_extract_unsigned_field(val, shift);
> > +
> > +     /*
> > +      * Treat IMPLEMENTATION DEFINED functionality as unimplemented for
> > +      * ID_AA64DFR0_EL1.PMUVer/ID_DFR0_EL1.PerfMon.
> > +      */
> > +     if (pmu == 0xf)
> > +             pmu = 0;
> Shouldn't we simply forbid the userspace to set 0xF?

This function is to check whether or not the field value indicates PMUv3.
Setting the field to 0xf is forbidden by arm64_check_features().
Having said that, since arm64_check_features() will be implemented by
using arm64_ftr_bits, which treats AA64DFR0.PMUVER and DFR0.PERFMON
as signed fields.
So, it will be forbidden in a different way in the next version.

Thanks,
Reiji

> > +
> > +     return (pmu >= min);
> > +}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
