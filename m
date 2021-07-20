Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58AAC07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 11:00:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 586AD6113C
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 11:00:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 586AD6113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B183349E57;
	Tue, 20 Jul 2021 07:00:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Im7UQJa4kTdI; Tue, 20 Jul 2021 07:00:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E214B0B5;
	Tue, 20 Jul 2021 07:00:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89D7949E57
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:00:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IbhXzk3LUhiN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 07:00:05 -0400 (EDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com
 [209.85.167.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BB5B4B0B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:00:04 -0400 (EDT)
Received: by mail-oi1-f178.google.com with SMTP id w194so24083015oie.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 04:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FVn1SYmkQB3M7v69VF2he/NUlW4fKKcfsWY+DKqff6A=;
 b=Wy82mBov5LjHgcaRRiO3uSMxaLw2FeoKQvcia10TJnBdtBGL9IZSGjxDGX5omGEgDT
 nJh+G6Jfrn8+kvbeqa0NNd4uBsEq6fmqDFBP3pSD0fKZVNjsIB+SGAEEDPxzzPltefb4
 TbrGVgW+jrLjVChYoTUTA01fM0N3fPz6u2SHtPCZaKkDO9XgnJAZlGRfrhShxAb3WRcA
 KoGRFzcIC1HYR8G0Pv8fyy5KMFGFTqWbp33gLJ1HMxfFP3D1OVrjOReZ0PoE23EjMw/P
 BnIsWaeoQZSOTrN7575vP0mrGMcF3D62Z1G684aC+T1NcM5IS6FFk1MvgttlPpmbWWec
 edlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FVn1SYmkQB3M7v69VF2he/NUlW4fKKcfsWY+DKqff6A=;
 b=kBA2TTskBVtWkM8hV40YO/xc1UVWr73uP+DPTKtlOZQCX0djYcem0nUai0XWf4gcR/
 vhZPEs5nS4GxVh/QXnKZKZ2g6Vm+uNT6O5FoSIpjzPg26xTDpIVmgO+vSjcMY/aQlTYZ
 bmUclU0s81acutPpVtl+s94XKbnWgHDkgQ6kHcUEe1kb494K7VzQkTN8guBqma4PV4E6
 mSxgabcqpGQ0dnRHyhwsWdkcR0qeoHq+MSeE1deh/S2ro8mwtaiTEDiAqUomr0mmy8/F
 POALjQDrFvjAX9yIMTMOYQ2/5juEAkBi4vUraYb9BX5AKbaTAwdFd92Vj4cUJUwTIa6H
 v9DA==
X-Gm-Message-State: AOAM530XBmVhgPb03vVHn+rzbdHwFuxGVHm4+RG6TT+5qHEImpLTyH/u
 A2gh0PM1+FNZjPfS2GVkciA19mJBmJifyf3HUHmQPg==
X-Google-Smtp-Source: ABdhPJwifz6pu5NBhio7NwidX7Z1fxHFB/vsZ48ZpYgUwL+dzCzouBKLdEAxyuGStD1hj4hu7q+1YBk4sq1EMVSS+wg=
X-Received: by 2002:a05:6808:5a:: with SMTP id
 v26mr11589545oic.90.1626778803869; 
 Tue, 20 Jul 2021 04:00:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-7-qperret@google.com>
 <CA+EHjTzjT2iv=9jsTNquSAD-_AWqpyCKVPiuCBWGzpxcAkWf9w@mail.gmail.com>
 <YPalr09gA6tGYVtl@google.com>
In-Reply-To: <YPalr09gA6tGYVtl@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 20 Jul 2021 11:59:27 +0100
Message-ID: <CA+EHjTz__zjYY2D8+nEPq2F8__saxC0kApnn7_rs0r2VCR2Nzg@mail.gmail.com>
Subject: Re: [PATCH 06/14] KVM: arm64: Tolerate re-creating hyp mappings to
 set ignored bits
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Quentin,

On Tue, Jul 20, 2021 at 11:30 AM 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
>
> Hi Fuad,
>
> On Tuesday 20 Jul 2021 at 11:17:03 (+0100), Fuad Tabba wrote:
> > Hi Quentin,
> >
> >
> > On Mon, Jul 19, 2021 at 11:47 AM Quentin Perret <qperret@google.com> wrote:
> > >
> > > The current hypervisor stage-1 mapping code doesn't allow changing an
> > > existing valid mapping. Relax this condition by allowing changes that
> > > only target ignored bits, as that will soon be needed to annotate shared
> > > pages.
> > >
> > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/pgtable.c | 18 ++++++++++++++++--
> > >  1 file changed, 16 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index a0ac8c2bc174..34cf67997a82 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -362,6 +362,17 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> > >         return 0;
> > >  }
> > >
> > > +static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
> > > +{
> > > +       if (old == new)
> > > +               return false;
> > > +
> > > +       if (!kvm_pte_valid(old))
> > > +               return true;
> > > +
> > > +       return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_IGNORED);
> >
> > Wouldn't this return false if both ignored and non-ignored bits were
> > different, or is that not possible (judging by the WARN_ON)?
>
> Correct, but that is intentional, see below ;)
>
> > If it is, then it would need an update, wouldn't it?
>
> Maybe, but if you look at what the existing code does, we do skip the
> update if the old mapping is valid and not equal to new. So I kept the
> behaviour as close as possible to this -- if you change any bits outside
> of SW bits you get a WARN and we skip the update, as we already do
> today. But if you touch only SW bits and nothing else, then I let the
> update go through.
>
> That said, I don't think warning and then proceeding to update would be
> terribly wrong, it's just that a change of behaviour felt a bit
> unnecessary for this particular patch.

Thanks for the clarification. It makes sense to preserve the existing
behavior, but I was wondering if a comment would be good, describing
what merits a "needs update"?

Cheers,
/fuad

> Thanks,
> Quentin
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
