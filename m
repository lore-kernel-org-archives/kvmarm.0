Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E31DC11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:59:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA2656128C
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA2656128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 687444A4C0;
	Thu,  1 Jul 2021 10:59:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hqTmxcN7DaJZ; Thu,  1 Jul 2021 10:59:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D4DB4A551;
	Thu,  1 Jul 2021 10:59:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8210B4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J8m4+xwsib+Q for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 10:59:32 -0400 (EDT)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com
 [209.85.167.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76BD340874
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:59:32 -0400 (EDT)
Received: by mail-oi1-f171.google.com with SMTP id w127so7545021oig.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 07:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ltmhFCjb1WelitfArWc9DX2nLRCgQFqidnyjLJbZMyU=;
 b=EkW9I5Hw9T7Mg3qzdaW7TNoGNc0FAw7z/Tz693senj6TSQVMaoO9C5+G8no3WO5QUQ
 L/3hqNEzTF6sgam0DWFKbhtrIjPGIDPyk/Raok4vgFbuOJr495w7U4MLaEwOmLFmIQFV
 ii7a5JdB0xwrhdXAC1RLPkqwhUOEina074K8j/o9J3k3aExEf6ttdrH/Pns2+zVcPSc/
 /pm9JxrevtuwcYWahKFxt7SLlH9PGvUHVy7NDOOw5PozStUs3Zjan5fhTN4Hj4cxZYm5
 0YZvxxFfmx3gQbeMrI5zR85IiPb87texys/4CID3lZIyineyDFZrp9QI9zdgTp90wU+6
 dCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ltmhFCjb1WelitfArWc9DX2nLRCgQFqidnyjLJbZMyU=;
 b=Kc1UtBcU0SxG0W8xFa1tvyTZx/E/cdYXRxIjtXMx6vh6OWK4n65KNH/TfEjQlyDwz0
 nfgc4m++Z90pnyNtcFa/VNsqWtCJnAydaVAkRXY7OnDSx+tDQwdFu2BDon9Xxg3/7D5Y
 3o/AhYenvi+oVN+4Wrt/YSIh0tZzY4i1yJnJduDy/dIUaQCQbU7VSwJB1olE0B6yMjTf
 7wqhG2XwPuKPTVq9gGE8eT0+SGmTMy3u8LzV+GeCogDtXMpGhDVMjkRR2PZjrXpbLeyp
 8OxIjtoUcki6//5k4v7R6qcIN3YOwwBoiCNhb95QwO6BW+1VtgG2x5FfRXX6apVSWSbe
 tpcw==
X-Gm-Message-State: AOAM532KTtI9GaoYZmFhQhRBpU+98h2yzvxGNCZqVXuQ6Uq0uXg9TFry
 fsJpSd0zhbr521vAC/PxlkAWDw2zOSvXOPJlc/KAOg==
X-Google-Smtp-Source: ABdhPJz7kZwgKADNdRptSCOhsnXccXkQQ52LRN1EzbPnXhsc9AMzr4LE8wtsRq7OyE83M21OVEMR1Sch+UK6Br6X3iE=
X-Received: by 2002:a05:6808:158b:: with SMTP id
 t11mr1261355oiw.8.1625151571717; 
 Thu, 01 Jul 2021 07:59:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-9-tabba@google.com>
 <20210701134823.GH9757@willie-the-truck>
In-Reply-To: <20210701134823.GH9757@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 15:58:55 +0100
Message-ID: <CA+EHjTzsx1jR9JWhN5iKENSi8ry-0-byF1wN_bTBmm3+qn6MdA@mail.gmail.com>
Subject: Re: [PATCH v2 08/13] KVM: arm64: Guest exit handlers for nVHE hyp
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

On Thu, Jul 1, 2021 at 2:48 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:45PM +0100, Fuad Tabba wrote:
> > Add an array of pointers to handlers for various trap reasons in
> > nVHE code.
> >
> > The current code selects how to fixup a guest on exit based on a
> > series of if/else statements. Future patches will also require
> > different handling for guest exists. Create an array of handlers
> > to consolidate them.
> >
> > No functional change intended as the array isn't populated yet.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 35 +++++++++++++++++++++++++
> >  2 files changed, 54 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index e4a2f295a394..f5d3d1da0aec 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -405,6 +405,18 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
> >       return true;
> >  }
> >
> > +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
> > +
> > +exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
> > +
> > +static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
> > +{
> > +     if (is_nvhe_hyp_code())
> > +             return kvm_get_nvhe_exit_handler(vcpu);
> > +     else
> > +             return NULL;
> > +}
>
> nit: might be a bit tidier with a ternary if (?:).

Sure thing.

Thanks,
/fuad

> But either way:
>
> Acked-by: Will Deacon <will@kernel.org>
>
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
