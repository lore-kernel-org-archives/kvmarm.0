Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D17EC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 05:32:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9820B4B1F1;
	Tue, 30 Nov 2021 00:32:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 17-nw8H6NMJK; Tue, 30 Nov 2021 00:32:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69FC24B137;
	Tue, 30 Nov 2021 00:32:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F00D4B130
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 00:32:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sGx8VcBnuib0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Nov 2021 00:32:19 -0500 (EST)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 217FD4B11C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 00:32:19 -0500 (EST)
Received: by mail-pl1-f175.google.com with SMTP id u17so13997286plg.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 21:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QGmUKm3NhxCjFePG5xO2YhN6YsO3FoC7iXWsjnJHwHo=;
 b=PFdJDx1SbT8kd3PEwcKKljTxVqsslq0DJuyzEOVW3ilQguSRQwcELJjwXCrtM1KNoW
 qGYTXFUZSmHkKmgbn4wYkGekaiwSOn3Vp8mhRyOrWoqs7pZhWc6h4F74KuBpuZyJFBUO
 UG3HidICy3RFanV8sAP6OEiIVVdU7i9rLWUFb76Mld/rb5u90CTqpwH3af+fRSYnvzXM
 /yggRmDPpGDWiNXl9of2CdstKMrNc7wMNEn3J5hHufSI/WUXtSLDgc90XkjxZOJXO9yX
 2haM3H/HedA8EEZanDtIAPhjbxL+KMJROzhpvB8csFGXsNSwhAoDFPK2I3rffG6FIxiM
 Y4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QGmUKm3NhxCjFePG5xO2YhN6YsO3FoC7iXWsjnJHwHo=;
 b=qFL0mnu1T9LbsLLaXoT/69xG+foAMyck1PEINW89jqRJ3jZMh+E6ay83OPGLU1TdQH
 ItN9wIw5LZH8UGf5w4XMY+XYaUBJTiQim6/dmJVlTscJMiSEuZ1lEkyu9VUj0G9ayNrg
 iSuPkyoTNCJHjcWvLFnll+wXci4h8CsSyEtvH/SSXJp78EPNn50ipMQ6GzvsONUyvBIL
 WpMFNTBnSEvIGBmg1EOWz7jHrpx17cy3SRWgRsERBL8DxMJX8XtO9vcf8vsStZme1nGP
 2tNaFMBnnEYhX5UJk+qA/g+E3p9FT9jX8wFbGKJwTX9KvmrAFI5cm6cuxKsN0Z20J+do
 f5Qg==
X-Gm-Message-State: AOAM530PKP10itl/gMjPWX4ikJCD//BtZ1WTyN00JDly7nxH7co1ggBh
 uLq5ZGDcowL0Y/HHzJwXhYz1xrSPx9DWVjUKad4QybHsyWmr0A==
X-Google-Smtp-Source: ABdhPJzi7lZO+A4usdDJUDRkuM27dnjVekY7ejDZrKXSvifVE/ZQ5d0WxjFExBKgXMH0ur+dxWW9YAwhhOSI65DoXdg=
X-Received: by 2002:a17:902:ab47:b0:141:95b2:7eaf with SMTP id
 ij7-20020a170902ab4700b0014195b27eafmr64331524plb.40.1638250338059; Mon, 29
 Nov 2021 21:32:18 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
In-Reply-To: <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 29 Nov 2021 21:32:02 -0800
Message-ID: <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
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
> > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > expose the value for the guest as it is.  Since KVM doesn't support
> > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > exopse 0x0 (PMU is not implemented) instead.
> s/exopse/expose
> >
> > Change cpuid_feature_cap_perfmon_field() to update the field value
> > to 0x0 when it is 0xf.
> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> guest should not use it as a PMUv3?

> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> guest should not use it as a PMUv3?

For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
Arm ARM says:
  "IMPLEMENTATION DEFINED form of performance monitors supported,
   PMUv3 not supported."

Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
be exposed to guests (And this patch series doesn't allow userspace
to set the fields to 0xf for guests).

Thanks,
Reiji

>
> Eric
> >
> > Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index ef6be92b1921..fd7ad8193827 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
> >
> >       /* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
> >       if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
> > -             val = 0;
> > +             return (features & ~mask);
> >
> >       if (val > cap) {
> >               features &= ~mask;
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
