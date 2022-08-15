Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F82C25B0E
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 15:40:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CDD54DAAE;
	Mon, 15 Aug 2022 11:40:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FxYg-NNs7uZy; Mon, 15 Aug 2022 11:40:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F5E54DCF7;
	Mon, 15 Aug 2022 11:40:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0586E4DC68
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 11:40:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hofSqdTlm7x for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 11:40:00 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA3044DAAE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 11:40:00 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id p10so9498504wru.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 08:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=VP31WSY65QEYHmGKkheHdJtit2IxlAC3C/GTNPT6J3M=;
 b=KDR20vjhDq0om+BbSpgVjbjIEfKyM9hzqellnZMBbjPYhKfqx8ikJsySttFwFlY2Hw
 oiDxEt4RpXxN6hUaJW8OuaENfYZOafXkSDkX1vb9dg7V/aG4QsRJ6TYY0F9WUlTLn6Vf
 NHF+LgUaJFpui1g9qC+Rv3LypInoC1lE1hsrJ8BiNxbEAPP6tn3XdJyY/w0KbBw7PpJD
 oH77RjEzfa5ost8upGE9k1u6DJriI0mcBtWbmFcq9KC94GZZe4EqzVQ4aUBaXW6zABOk
 ZIGRqcpIb5HIHOLH2gv1bH3WqUBDiCE5BvLQ/x7yySs3uf1w5ktkzspTtUNcCnzYJQEj
 8w1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=VP31WSY65QEYHmGKkheHdJtit2IxlAC3C/GTNPT6J3M=;
 b=ucv1vFNiHrBMfMQpouK+XBMrB1gN3zJQqvS0/pmgX5ZtMiP6ZE/EOQG+bCOl6kf+M0
 9d8vNjrnclquvfcVuxBQNwPohJuBQDBX4s0a6URncMu6Izq8seJtWtZcmOA3/3XS5+3T
 NYHFw8jqL8CQYmgqQTvQSJ5DD6JmKMMVdZ3MXXogVKdLw9MEI1ljUvnHFybv4TFyJwY+
 JToOIcDMoMYdcpWKh3U3kBHqhZpRcQY+ZYYLojdx+xW5dWZ5DAgfJHeQWASI0zAfDe/o
 G1DuCR4FW9ztizFQoT0f2xkgezAYrdaQcsKwakbYKQRXkw0n8Ltnkmv77BewnaimQ1gg
 Sseg==
X-Gm-Message-State: ACgBeo30B9/Hws8BIIs5U4n6QFJ15IcfMKLy7voum8BXKFxInogYHaxH
 TCguRsS8sGPOEQW2buxtyjzFb0rMpHL8dikCdHtpnQ==
X-Google-Smtp-Source: AA6agR7zuuSgDdcz2wd92uz0ytguGNdoZjdF2d8ZPVqoybSSwNN8/GwgwCl+M3WDqdInbEa6zFZJ4DJNkrQDuxI0MHA=
X-Received: by 2002:a5d:5a82:0:b0:224:f744:1799 with SMTP id
 bp2-20020a5d5a82000000b00224f7441799mr1748341wrb.582.1660577999491; Mon, 15
 Aug 2022 08:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com>
 <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
 <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
 <Yvpir0nWuTsXz322@cmpxchg.org>
In-Reply-To: <Yvpir0nWuTsXz322@cmpxchg.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 15 Aug 2022 08:39:23 -0700
Message-ID: <CAJD7tkYJcsSvCUCkNgcWvi2Xoa3GDZk81p5GUptZzkOkrhrTWQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Aug 15, 2022 at 8:13 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Aug 08, 2022 at 01:06:15PM -0700, Yosry Ahmed wrote:
> > On Mon, Jul 18, 2022 at 11:26 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> > >
> > > On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > > > > Thanks for taking another look at this!
> > > > >
> > > > > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > >
> > > > > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > > > index aab70355d64f3..13190d298c986 100644
> > > > > > > --- a/include/linux/mmzone.h
> > > > > > > +++ b/include/linux/mmzone.h
> > > > > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > > > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > > > > >  #endif
> > > > > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > > > > >
> > > > > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > > > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > > > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > > > > and potentially confusing.
> > > > > >
> > > > > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > > > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > > > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > > > > stats the depend on a single feature seems to be the status quo for this code.
> > > > > >
> > > > >
> > > > > I will #ifdef the stat, but I will emphasize in the docs that is
> > > > > currently *only* used for KVM so that it makes sense if users without
> > > > > KVM don't see the stat at all. I will also remove the stat from
> > > > > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > > > > #ifdefed stats show up there.
> > > >
> > > > It's might be worth getting someone from mm/ to weigh in before going through the
> > > > trouble, my suggestion/question is based purely on the existing code.
> > >
> > > Any mm folks with an opinion about this?
> > >
> > > Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
> > > with #ifdef CONFIG_KVM for now as it is currently the only source for
> > > this stat?
> >
> > Any input here?
> >
> > Johannes, you have been involved in discussions in earlier versions of
> > this series, any thoughts here?
>
> No super strong feelings here. Most major distros have CONFIG_KVM=y/n,
> so it'll be a common fixture anyway, and the ifdef is proooobably not
> worth it for hiding it from people. OTOH, the ifdef is useful for
> documenting the code.
>
> If you've already ifdeffed it now, I'd say go ahead with
> it. Otherwise, don't :) My 2c.

Thanks a lot, Johannes! I haven't ifdeffed it yet so I'll send a v7
with a few nits and collect ACKs. Andrew, would you prefer me to
rebase on top of mm-unstable? Or will this go in through the kvm tree?
(currently it's based on an old-ish kvm/queue).
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
