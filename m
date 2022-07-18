Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B00EC43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 10:26:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C157F4C844;
	Tue, 19 Jul 2022 06:26:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ObrimGaAf9qc; Tue, 19 Jul 2022 06:26:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6AF94C846;
	Tue, 19 Jul 2022 06:26:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D50854CEF7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 14:26:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mikGMdOkmatP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 14:26:38 -0400 (EDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1B9C4CEF3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 14:26:38 -0400 (EDT)
Received: by mail-wr1-f48.google.com with SMTP id bk26so18272448wrb.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WVvDU2AL8s0vVVLudVvrgZ7AYHAWM81ym6o0jyabuV4=;
 b=NQ0Qe4cWnPa0u8OvVOwy8y1gQzlLdYgCBimHOn9YHa4Latcfsm8LyZWdrE80LvfLNc
 tXy9exDSQ3Y8+XgnPNrfrHKHIK7WHqJjLLs4ZKL3zqZf6W5Xlj4yqoBEvXm+WpLrm0JK
 nc+V6DOQP5AGz2bXTOdUzCzQ1YAp4XOyOvKRo9GvABDJSc2/Y2J3ShxELHCOlHxEUJpo
 ti2ZhHov/v/Po0RulIPBMJvjoIktisJSzAOhmFKMTwaSDEisYz9bQgmq4q0t8npT63yx
 Y3MItMbE+E1nY/7Zk0F2qpNd3Q0ouCIublcith4nRKDQch7WB3I3FYuxo2LIS7fvtbtL
 9RXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WVvDU2AL8s0vVVLudVvrgZ7AYHAWM81ym6o0jyabuV4=;
 b=SQdWr1nBYtSpna5V4V507JuIbFhHhpXgTgE2vO22E2oB8pLvRA2UBT5UERlZlExAgl
 k+MxEWwDTaLdM/RpCbMRnhl9rz5NKn8t8iOfLVrTDM+XT3wku+UwEqwUneCZ0ANPuTrW
 XtS0Pu38uBHkcH448ESimH4BxNQFbOEtOfzhREJthzlaJ5A8WquwYYFX3hAY0RnbDejE
 CukhHEo0X6+M7di6XZ3ivn83wlnG49Nlmxbq13nwjn0OwW2kmKHING1elv0Pz7NFnBTk
 a53IaGqTm43TbtP5qmpdMnv0NMfgh6vVnwgybZnAOQTn8jZ8aK0EB0EZ7pQJPBDxod9+
 7huQ==
X-Gm-Message-State: AJIora/3XeCeUNsPZ1nLiUiFVxRF1hJarBX8d8F6ZZ6owJZrFQdxU7ax
 sUJfOtzy3YneZqzsk95cRl7FYr9kLopaV9UptHboPQ==
X-Google-Smtp-Source: AGRyM1vritCRy15xhjiGgheVI5ODnh3bq50PA2xHbfPtyQKW+GDSprNhKc2C1SNuU6IDGLnp3HBkT8HTXtmuIDMx9I4=
X-Received: by 2002:a5d:588b:0:b0:21d:a918:65a5 with SMTP id
 n11-20020a5d588b000000b0021da91865a5mr24265604wrf.210.1658168797460; Mon, 18
 Jul 2022 11:26:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com>
In-Reply-To: <Ys3+UTTC4Qgbm7pQ@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 18 Jul 2022 11:26:01 -0700
Message-ID: <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 19 Jul 2022 06:26:09 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Andrew Morton <akpm@linux-foundation.org>,
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

On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > Thanks for taking another look at this!
> >
> > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > index aab70355d64f3..13190d298c986 100644
> > > > --- a/include/linux/mmzone.h
> > > > +++ b/include/linux/mmzone.h
> > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > >  #endif
> > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > >
> > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > and potentially confusing.
> > >
> > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > stats the depend on a single feature seems to be the status quo for this code.
> > >
> >
> > I will #ifdef the stat, but I will emphasize in the docs that is
> > currently *only* used for KVM so that it makes sense if users without
> > KVM don't see the stat at all. I will also remove the stat from
> > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > #ifdefed stats show up there.
>
> It's might be worth getting someone from mm/ to weigh in before going through the
> trouble, my suggestion/question is based purely on the existing code.

Any mm folks with an opinion about this?

Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
with #ifdef CONFIG_KVM for now as it is currently the only source for
this stat?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
