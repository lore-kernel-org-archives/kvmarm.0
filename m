Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731EBC19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 05:57:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9F974CFEF;
	Tue,  9 Aug 2022 01:57:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5-MT8qlKlIxM; Tue,  9 Aug 2022 01:57:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9074D4D041;
	Tue,  9 Aug 2022 01:57:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E264CECA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Aug 2022 16:06:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0HYNjK3yY53N for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Aug 2022 16:06:54 -0400 (EDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C45604CECC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Aug 2022 16:06:54 -0400 (EDT)
Received: by mail-wr1-f53.google.com with SMTP id l4so12026840wrm.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Aug 2022 13:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0j4dwLC8wxMrSAowWiy7rSpW5tCFJnoA4YLc0AuNUGg=;
 b=gld9078CrBQZkkr4yLFP8JyPjvlRn+4NpBrX7b60hIKWn28bkVbenIdUCbRuLNTTV0
 1L/39r5DQ4UKsm46WbkBiD46ElgQhpGCrV3dL2IjRNVKWzoh4RcLMsGeUceFQUKOwfSS
 lKuidI5W5eLJW4bvDU6NCAaZbpFulFWfNzi8pT0hS8wUhPwdVnzf53hNGbSb8efC0kW5
 rAbRal6FivNDSIIFBYuhcY/SU+U3x4tV9f7yNkVkf0A8JI0x7IsYbZ2z7W64UW/k7roj
 9D+5xVc9ZcwERLaDE3Stw31kBjsL/lFxJJhjsNTXENCu2Y/ZofRg5BFreVtm2omGqwjq
 /cdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0j4dwLC8wxMrSAowWiy7rSpW5tCFJnoA4YLc0AuNUGg=;
 b=ZxB1ZPD6BOUI5E9txggPcb1uHIpVFEzqlHVgf59/c1GrEJ1PTRjjlRjAe5UCg5WEFi
 WDbM4jCZY5d6Z2uFNzRU733dTizzf5lYjrOvdtBhf04Dq3uGoymMpMzzKdPls4xOpRFq
 u6kFIMRDHR3d+01sRC+PaMBNjEeC3R6+eA/0/YjraifTo6DRLw30HAozMDLK+Umt5Bk3
 J6fi5S4ZCEevAv0lbCqF9QTbw6V/cVD5T42o4tKf4v58HI5PJdmUoMDi5iCCwOPOmTIe
 5CU9SOgz7fB73Uj62sg4vO7rtVw0L22Z8n5+krchgivqwGKmjCUs0vxGBOTJc0v92JnU
 pRog==
X-Gm-Message-State: ACgBeo1JdgnOfHk6wd1NtAy3bQ7wjdtzrtuJvowbfLjL1eGVCXv+jqRa
 S0E4RWevIqLVLWT680Qp9FJbAij0S6VmrMPFKind1Q==
X-Google-Smtp-Source: AA6agR44E4ypoC5H9UBmr2E8FlvOT73br0ors/jVWYMC79q6xf+bqy0nmcGD1ZQ8O3weskn+aiRibfX/QNtndGD1TnE=
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id
 g8-20020a056000118800b002206c20fbf6mr12635954wrx.372.1659989213525; Mon, 08
 Aug 2022 13:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com>
 <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
In-Reply-To: <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 8 Aug 2022 13:06:15 -0700
Message-ID: <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 09 Aug 2022 01:57:45 -0400
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

On Mon, Jul 18, 2022 at 11:26 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > > Thanks for taking another look at this!
> > >
> > > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > index aab70355d64f3..13190d298c986 100644
> > > > > --- a/include/linux/mmzone.h
> > > > > +++ b/include/linux/mmzone.h
> > > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > > >  #endif
> > > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > > >
> > > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > > and potentially confusing.
> > > >
> > > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > > stats the depend on a single feature seems to be the status quo for this code.
> > > >
> > >
> > > I will #ifdef the stat, but I will emphasize in the docs that is
> > > currently *only* used for KVM so that it makes sense if users without
> > > KVM don't see the stat at all. I will also remove the stat from
> > > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > > #ifdefed stats show up there.
> >
> > It's might be worth getting someone from mm/ to weigh in before going through the
> > trouble, my suggestion/question is based purely on the existing code.
>
> Any mm folks with an opinion about this?
>
> Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
> with #ifdef CONFIG_KVM for now as it is currently the only source for
> this stat?

Any input here?

Johannes, you have been involved in discussions in earlier versions of
this series, any thoughts here?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
