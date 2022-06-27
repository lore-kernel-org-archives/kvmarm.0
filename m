Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209FECCA47F
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jun 2022 11:24:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA5B34B389;
	Tue, 28 Jun 2022 07:24:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wwKXEUxu5KD0; Tue, 28 Jun 2022 07:24:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59F554B3B7;
	Tue, 28 Jun 2022 07:24:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B717C4B12C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:29:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BqnJMjWE2SCQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2022 12:29:13 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8999840597
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:29:13 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id v14so13834416wra.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 09:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gq7iVePtX9OMXEUxruOPEde6hXUmiczdKpj9eXTuegY=;
 b=Ub1BAIMzdKFr+whCpBiAWhp0s8tYt12ZNPKk99qiMYNRD5+OYUzq488SqpH/xgr25t
 tP6UW3BBP+BkhP4WSdd4xXE6Ci/tsk2iyT5Bhr9RQbir03Oa/iDHCs+QNPuMohYTUcPi
 walxvoBGdCuOHpz56cewOoIomTU+g774SkXfUalipYiRJMVJoZ3pkUJWKDtxaJOUs9Wp
 z0yK72oV7D8umgBnfJqMPVe0CbYroH1c27oYPHH9DprMH4CUrxPNoWI6SVXsXvOIGR2j
 g7f70C02303LI4FevNbv4LB2Bfe3rGsWoe0WkiFs0zaMl+gMi3egdBS6vCi70LctvgjH
 FSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gq7iVePtX9OMXEUxruOPEde6hXUmiczdKpj9eXTuegY=;
 b=ZemMbQMSbYlfKjgom2ODT48UmmW0+/pINJc2M3kaxocmNzPyiNY3fvV0kSCvGmFHYM
 6axPs+Rhn8Ax63HEbBxu9qpZC4gveg22K8bZE9UsFLknOZRqpHSZ/SVS3QWdvwAY88DX
 S+b9hZ7MbR05RBuCsuqtwAl87igSZ08TVdaBR6YTnQraC+/HvbIVnM+xFBy9ORs64sXx
 0BvFolXAxIVG4U9X0m1DXAtqRRRzc2Qvgg8/2gbqwzeXF5CRK6rKO4b6nbKI0aL2YYLU
 87hVX6JHgC+1Z9FTdK4YQyRadIHLuZzdMcaJwvtjaUldNzS/ZEkWRC4Wi+dmRYI2/vtV
 HaLQ==
X-Gm-Message-State: AJIora8K6GIYliOZw1sowRBy8ZsemEWarSlyxH5nj0x4Xd4dHG11o0xJ
 FhF1esFDNqs/21fTrPc77aEDBqdzTAhaOSmynyaStQ==
X-Google-Smtp-Source: AGRyM1uGAMC8S/HveHGgFfIt33JanygNnC6EqBWAtLcqKvSeXaHFdpGJHdDoPIAbhtZxeIi7YUBzjamq9VMTyn+dDKo=
X-Received: by 2002:a5d:4308:0:b0:219:e5a4:5729 with SMTP id
 h8-20020a5d4308000000b00219e5a45729mr13879267wrq.210.1656347352384; Mon, 27
 Jun 2022 09:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-3-yosryahmed@google.com>
 <YrnYtMGmGDxCrwdv@google.com>
In-Reply-To: <YrnYtMGmGDxCrwdv@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 27 Jun 2022 09:28:36 -0700
Message-ID: <CAJD7tkbqAignkN-Vh3A3gyBV_n_gZDBpM56r9HiXrYG+F0v8wg@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 28 Jun 2022 07:24:17 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 Cgroups <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 27, 2022 at 9:20 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> > Add a helper to account pages used by KVM for page tables in secondary
> > pagetable stats. This function will be used by subsequent patches in
> > different archs.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  include/linux/kvm_host.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 883e86ec8e8c4..645585f3a4bed 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2246,6 +2246,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
> >  }
> >  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
> >
> > +/*
> > + * If nr > 1, we assume virt is the address of the first page of a block of
>
> But what if @nr is -2, which is technically less than 1?  :-)
>
> > + * pages that were allocated together (i.e accounted together).
>
> Don't document assumptions, document the rules.  And avoid "we", pronouns are
> ambiguous, e.g. is "we" the author, or KVM, or something else entirely?
>
> /*
>  * If more than one page is being (un)accounted, @virt must be the address of
>  * the first page of a block of pages what were allocated together.
>  */
>

Looks much better, I will use that in the next version.

Thanks!

>
> > + */
> > +static inline void kvm_account_pgtable_pages(void *virt, int nr)
> > +{
> > +     mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
> > +}
> > +
> >  /*
> >   * This defines how many reserved entries we want to keep before we
> >   * kick the vcpu to the userspace to avoid dirty ring full.  This
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
