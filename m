Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26B4C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:48:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F8BC4B2E9;
	Mon,  9 May 2022 12:48:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I1pWslMhzhWS; Mon,  9 May 2022 12:48:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30E5F4B302;
	Mon,  9 May 2022 12:48:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 791E94B2E4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:38:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O-mAym6z2Mur for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:38:55 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44C614B150
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:38:55 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id d5so20271775wrb.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zHCy33IfC5TyILOeQkmukBylQEbte8TBRw0A+aY3Nnw=;
 b=H6nlUcikiCWMQ0NyQpEOvAX9YWAzxJVOMo8TCOD+MTF5x++KFtykM38ezcNgkrqf/k
 HsEf3EJd5U1zetXK4vcQ2qXVxKjVLLmxk64eVHzC1lhLd+csiUOWanUBOMc0ehk+lL8Z
 8kMOXwBH5hATNTPogQUXQIImHkrg03NEi/77hdTa1677HBxwaUfkv/QQ7yLseBE1HcJE
 YPtPpea4ak7+T4Dqx7q3oWEasv5JJswYYW1+IlWiL+SM1CpjXzbyzq9KKAOv4Z51ZAoC
 p4WvvEjdiEI05l2ZOHE80zU68Yi/ftR+9e3AoP2yMz5PBJyRJ0fD1vQ47PM6C0czbLOE
 9nDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zHCy33IfC5TyILOeQkmukBylQEbte8TBRw0A+aY3Nnw=;
 b=UhQaPGM+ewdT59uEgS+mfah4vQHBE7ndNS9DN1sbj2/2UnsooziGQ9VzgrK9vGk3aD
 DUR4MxHccEdZdtaYQ2b3P8ZdrlgZBwtsolIZIEek4Ijhz+nSgtrHhE2zQFp1VvzhmGGi
 IDYXrq6QYaEbqIs0eNh22M5x8g897W1polWaxqrJDIM2cG7zox4i/U1mgWG3RcqU7d71
 wK309+JxGa9jZeP2Ohl5vv/Cuo50k6NenNmfrmo1aL38NETSl/LeCOoF63i9N0gSf5tR
 G50zlptW4uHx/hBQS+rYkcRnod6snhwj/SvdEcwbXlAfw1sYYZoKLDLsPeAxWOdlKQbl
 2uyw==
X-Gm-Message-State: AOAM531XigGP4EsY/EEASeIv6Ov497d27+uJZbEie3Xgeg+FMS1K0TwD
 bbGWnzcKXmk9aQAbeTFT+RXhDh5YENM6pDcXgcBw7Q==
X-Google-Smtp-Source: ABdhPJzFCb2Pw91KP2O7w1MuAK0a7BY2JKborW82eGXzK/VRCy5OZV3s+PnflU0xod+JItQXe5EJnWI4vMeydL7hgKY=
X-Received: by 2002:a05:6000:230:b0:209:87ac:4cf5 with SMTP id
 l16-20020a056000023000b0020987ac4cf5mr14646217wrz.80.1652114333976; Mon, 09
 May 2022 09:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
In-Reply-To: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 9 May 2022 09:38:17 -0700
Message-ID: <CAJD7tkbfT-FRs3LE2GPddqrQSWw_eC1R6k3z04x=z9Zvt5yLpg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Mon, 09 May 2022 12:48:32 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
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

On Mon, May 2, 2022 at 11:46 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Fri, 29 Apr 2022 21:11:28 +0100,
> > Yosry Ahmed <yosryahmed@google.com> wrote:
> > >
> > > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > > KVM mmu. This provides more insights on the kernel memory used
> > > by a workload.
> > >
> > > This stat will be used by subsequent patches to count KVM mmu
> > > memory usage.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > ---
> > >  Documentation/admin-guide/cgroup-v2.rst | 5 +++++
> > >  Documentation/filesystems/proc.rst      | 4 ++++
> > >  drivers/base/node.c                     | 2 ++
> > >  fs/proc/meminfo.c                       | 2 ++
> > >  include/linux/mmzone.h                  | 1 +
> > >  mm/memcontrol.c                         | 1 +
> > >  mm/page_alloc.c                         | 6 +++++-
> > >  mm/vmstat.c                             | 1 +
> > >  8 files changed, 21 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > > index 69d7a6983f78..828cb6b6f918 100644
> > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > @@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
> > >         pagetables
> > >                  Amount of memory allocated for page tables.
> > >
> > > +       secondary_pagetables
> > > +             Amount of memory allocated for secondary page tables,
> > > +             this currently includes KVM mmu allocations on x86
> > > +             and arm64.
> >
> > Can you please explain what the rationale is for this? We already
> > account for the (arm64) S2 PTs as a userspace allocation (see
>
> This can be considered as continuation for that work. The mentioned
> commit accounts S2 PTs to the VM process cgroup kernel memory. We have
> stats for the total kernel memory, and some fine-grained categories of
> that, like (pagetables, stack, slab, etc.).
>
> This patch just adds another category to give further insights into
> what exactly is using kernel memory.
>
> > 115bae923ac8bb29ee635). You are saying that this is related to a
> > 'workload', but given that the accounting is global, I fail to see how
> > you can attribute these allocations on a particular VM.
>
> The main motivation is having the memcg stats, which give attribution
> to workloads. If you think it's more appropriate, we can add it as a
> memcg-only stat, like MEMCG_VMALLOC (see 4e5aa1f4c2b4 ("memcg: add
> per-memcg vmalloc stat")). The only reason I made this as a global
> stat too is to be consistent with NR_PAGETABLE.
>
> >
> > What do you plan to do for IOMMU page tables? After all, they serve
> > the exact same purpose, and I'd expect these to be handled the same
> > way (i.e. why is this KVM specific?).
>
> The reason this was named NR_SECONDARY_PAGTABLE instead of
> NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> account other types of secondary page tables to this stat. It is just
> that we are currently interested in the KVM MMU usage.
>


Any thoughts on this? Do you think MEMCG_SECONDARY_PAGETABLE would be
more appropriate here?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
