Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9986C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jun 2022 08:16:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 540AD4B218;
	Tue, 14 Jun 2022 04:16:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GczkAJdmVKxy; Tue, 14 Jun 2022 04:16:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1984B21A;
	Tue, 14 Jun 2022 04:16:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 236824B288
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 13:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AMBAV6D-0x6u for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jun 2022 13:12:02 -0400 (EDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E93484B1BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 13:12:01 -0400 (EDT)
Received: by mail-wr1-f50.google.com with SMTP id h5so8005784wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 10:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=BwfpdGVZuLzhMRO0qDkUrzUSE4uGJ0s4izOa+gswkLc=;
 b=iyoFryyCEMOgC7rXLKu4nOmoJ4Ev3bSJmT6ed09FE5xCAAc5dBkkwtXxpcvvGQ+P+z
 ETT+TDFbc4w3QEtd0CSTtGopVeE/ROGO0WHkEbyE/LYwiv3H3TW3pyxouKMCLv+KqkYZ
 yNXDxA5s4wHBPNNleteRDWB0OVGKRy46fxusIatVg7fbsU3f8NuQHDDwXuooOAhihX5c
 apRzdEm4Qcxw1Vp4x8eHSJ0zk6RBYV1Jvu3JCqD8yM8Yczm4FlFHmh8FmzU3HH+SvYZl
 N0nY66gFj0te0BB1xSoY4rr990nbGbzyauUa8tb8y8DjQzQQuFKjHb8vPu4IK/5VClaZ
 mw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=BwfpdGVZuLzhMRO0qDkUrzUSE4uGJ0s4izOa+gswkLc=;
 b=Lz83IrCEXvUi45UPL02vQlX8tg8g7EuL9vXywz8yl7YrUKWpt9XoFEldWtzOsVTp4H
 EgFoCYmqm1tR8Pnyum6ggKF9UENZ08ZbbsLQvDArSpogia6T1eOYrbvpZPiNuvCMOUQQ
 1qlM/gZLo5938JqWApf2TzF66EEvPSHZLvgsEjU3edaiu2+O2rDjPVr1MEow/lRQBPei
 jna5I56/gE80qp68EwxKWf/zelw9p5aVOL/EC8b2DkUEixT4HieGrgUgeL17f7yxHvCM
 vF87TwuOVuhDXbcN8PbOwsigBM0V1VgJBcMCe65ohlw8FiMePgbGyVQ5ICvwUWl3PwLS
 1X+Q==
X-Gm-Message-State: AJIora8ELNxKO5MHzDrHS6Ni/bpgMQMwnoekdQ6Wr46EimKXEItz46Bi
 stFHMXLJRkMR7KKOssbLTVqj3sIaPZH2lav9jRq2YA==
X-Google-Smtp-Source: AGRyM1s6B0qb0T2WacCoWhhkywiiU+ZvFODg5mDtSwgELuEdOO1P7hQRTSX7NI4gasI6mKDBJY57NrqOabVTnciF7VA=
X-Received: by 2002:adf:f688:0:b0:215:6e4d:4103 with SMTP id
 v8-20020adff688000000b002156e4d4103mr802713wrp.372.1655140320646; Mon, 13 Jun
 2022 10:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
 <bdfea446-623c-d423-673f-496b3725ec2c@intel.com>
In-Reply-To: <bdfea446-623c-d423-673f-496b3725ec2c@intel.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 13 Jun 2022 10:11:23 -0700
Message-ID: <CAJD7tkbUXb7qBm1GAMDr29DcsC90_bPzwffkdtAu_Na+inVzVg@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: "Huang, Shaoqin" <shaoqin.huang@intel.com>
X-Mailman-Approved-At: Tue, 14 Jun 2022 04:16:17 -0400
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

On Sun, Jun 12, 2022 at 8:18 PM Huang, Shaoqin <shaoqin.huang@intel.com> wrote:
>
>
>
> On 6/7/2022 6:20 AM, Yosry Ahmed wrote:
> > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > KVM mmu. This provides more insights on the kernel memory used
> > by a workload.
> >
> > This stat will be used by subsequent patches to count KVM mmu
> > memory usage.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >   Documentation/admin-guide/cgroup-v2.rst | 5 +++++
> >   Documentation/filesystems/proc.rst      | 4 ++++
> >   drivers/base/node.c                     | 2 ++
> >   fs/proc/meminfo.c                       | 2 ++
> >   include/linux/mmzone.h                  | 1 +
> >   mm/memcontrol.c                         | 1 +
> >   mm/page_alloc.c                         | 6 +++++-
> >   mm/vmstat.c                             | 1 +
> >   8 files changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 69d7a6983f781..307a284b99189 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
> >         pagetables
> >                   Amount of memory allocated for page tables.
> >
> > +       sec_pagetables
> > +             Amount of memory allocated for secondary page tables,
> > +             this currently includes KVM mmu allocations on x86
> > +             and arm64.
> > +
> >         percpu (npn)
> >               Amount of memory used for storing per-cpu kernel
> >               data structures.
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index 061744c436d99..894d6317f3bdc 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -973,6 +973,7 @@ You may not have all of these fields.
> >       SReclaimable:   159856 kB
> >       SUnreclaim:     124508 kB
> >       PageTables:      24448 kB
> > +    SecPageTables:    0 kB
> >       NFS_Unstable:        0 kB
> >       Bounce:              0 kB
> >       WritebackTmp:        0 kB
> > @@ -1067,6 +1068,9 @@ SUnreclaim
> >   PageTables
> >                 amount of memory dedicated to the lowest level of page
> >                 tables.
> > +SecPageTables
> > +           amount of memory dedicated to secondary page tables, this
> > +           currently includes KVM mmu allocations on x86 and arm64.
>
> Just a notice. This patch in the latest 5.19.0-rc2+ have a conflict in
> Documentation/filesystems/proc.rst file. But that's not a problem.

Thanks for pointing this out. Let me know if a rebase and resend is necessary.

<snip>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
