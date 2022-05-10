Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5081CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:39:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC5214B11E;
	Tue, 10 May 2022 02:39:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hyAhZ4wLAy8F; Tue, 10 May 2022 02:39:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 537AC4B137;
	Tue, 10 May 2022 02:39:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D19D44B11F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:39:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U1S5bIknHOJT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 02:39:09 -0400 (EDT)
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com
 [209.85.160.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85D9E4B11E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:39:09 -0400 (EDT)
Received: by mail-oa1-f52.google.com with SMTP id
 586e51a60fabf-ed9a75c453so17179579fac.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 23:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=UVMdzQ6jg8yR3HOs2R5eFoPReyvRoYAaYEFQBrwmbjo=;
 b=E8hj5rakz3+DwGtDVMQ5zaXey+1JCRL/qO1WIljqhko9ppH67gMmOS9ar/jVoibcHl
 XqQeuEhJnlOhI3z5jtpTppXnVYizBYGKcy8biMNm+PYBFwIu/Y3FDRkFWB+GyoUWdrcW
 9ZJWy80xhrLsRxHj/LtdSZB+AC9ZvgPNMxoswmtgyL/r+4GNNeuHTH4MyUgM6itvFi7A
 hn/wEF1AIZA2ZNbIgVhhT88O5Nv0P6Ve7Zc778oWZTv5mo5A6H3XK6OxSuN7+j8Mkghk
 3UJ1pX5erkzKz9GworsdgArTPUA+ZUL5oqm6aYSQ+PItcUhXpzlw8r6tjQlEkQyL6JIW
 PzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=UVMdzQ6jg8yR3HOs2R5eFoPReyvRoYAaYEFQBrwmbjo=;
 b=KCPv9pVo17vx8+e6FNPMyNv3YaUDT5HHdIdXkuwTg/j71FuSDXXDJmhsQDQr+X04c8
 6EzXGmrc4b7T4Rdo0KJDVZQhn5DgSlgCCvIgfxHOmn6nO+C0Yd5nJgAIqE5ETFB5i5vI
 aw/bzI3zFP0UnquiRhomwYLLe78Y/EzT0gCdiXuFksOrF3HjT8X6nP06bL376RI/YnnB
 VknzZWc3kljrUILCe2sgIXC5kADIrpUJ4kc/ri77FYzkeZRDP0bwgE5azfoHUbJzQ3VI
 J6Setp4Vqc7knxgFGNlwoadOQ0J9JUZKMULDsebON8FH1QByxv00dDfgmfVt+0LExQ+0
 TBUw==
X-Gm-Message-State: AOAM532cJ5CXICnVNZV69vE6gPLq20vTMKrA39Tk3dl9Lr9c2ZdHGFvL
 Kw3SsAvz6Ua+w3En4z/Ehbp6CaDl1ZAgsgH6CGY95w==
X-Google-Smtp-Source: ABdhPJxI0yeUpJNrhakXSuJFKJ3p5Tl50RIx12BNdcF2fxPF/gT50hVIPxmZrfJOypKbi+nNUZCMdZ8O28EX0YLxK10=
X-Received: by 2002:a05:6870:961b:b0:e2:ffb9:f526 with SMTP id
 d27-20020a056870961b00b000e2ffb9f526mr12585661oaq.146.1652164747452; Mon, 09
 May 2022 23:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220509120330.3043773-1-tabba@google.com>
 <20220509120330.3043773-3-tabba@google.com>
 <YnlyNPnwuxRcVlP8@google.com>
In-Reply-To: <YnlyNPnwuxRcVlP8@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 May 2022 07:38:31 +0100
Message-ID: <CA+EHjTyZfJJqJM1agOZVt07TjdrpP7JTa58KxzvgqFBCG4sNCg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] KVM: arm64: Repack struct kvm_pmu to reduce size
To: Oliver Upton <oupton@google.com>
Cc: will@kernel.org, maz@kernel.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Hi Oliver,

Thanks for your reviews.

On Mon, May 9, 2022 at 8:57 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, May 09, 2022 at 12:03:28PM +0000, Fuad Tabba wrote:
> > struct kvm_pmu has 2 holes using 10 bytes. This is instantiated
> > in all vcpus, so it adds up. This repacking removes all holes.
>
> nit: commit messages should be written in the imperative. So maybe
> 'Repack the structure to remove all holes'.

Will fix that when I respin this.

Cheers,
/fuad

>
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Otherwise:
>
> Reviewed-by: Oliver Upton <oupton@google.com>
>
> > ---
> >  include/kvm/arm_pmu.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 20193416d214..eaa8290b116f 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -21,12 +21,12 @@ struct kvm_pmc {
> >  };
> >
> >  struct kvm_pmu {
> > -     int irq_num;
> > +     struct irq_work overflow_work;
> >       struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
> >       DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
> > +     int irq_num;
> >       bool created;
> >       bool irq_level;
> > -     struct irq_work overflow_work;
> >  };
> >
> >  struct arm_pmu_entry {
> > --
> > 2.36.0.512.ge40c2bad7a-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
