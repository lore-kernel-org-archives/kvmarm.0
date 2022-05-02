Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BBCC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 13:31:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 616224B12E;
	Tue,  3 May 2022 09:31:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gMa0qT4JhwCI; Tue,  3 May 2022 09:31:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BD3D4B17C;
	Tue,  3 May 2022 09:31:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F05B449F3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 14:47:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5FTAJ2aA18cH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 14:47:02 -0400 (EDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D52B44B0C0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 14:47:02 -0400 (EDT)
Received: by mail-yw1-f177.google.com with SMTP id
 00721157ae682-2ebf4b91212so157895117b3.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 11:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=u9wSiuSwEdY5mnTnkaPbFc68dMNs+2B7Kv3x/mlBROY=;
 b=B5EJ0yX/6p4KphD4mHUJ1Rf/ah2ZGGbyCj3/Fg8jz6NZgaKjFGHXri9nWa56usJkQV
 i315aF1sZwZQCXuqR1GAJi/UydKqqqyJKrMK8NO2ltYq2E6LzRLcZv32EwENsp7gEeoz
 iSHMNZvgfxxeDjj5++SiliEGaOkXpt+a8RHyXVhO5DpOnU48kj++PVL3oUiAbWHvgwWt
 /8Cr6IfX5ViwgwukGvi0D67RRVTS2aaUOaOIh181LsfJrySzqwochKRZSrWUxxtwgj0X
 utkbg7G1h+72m4iLsTXSquLZ7P0i2NJO3VNDlb1N0tn+bpBJNirD0jDtdQa9nWw8JgOP
 HsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=u9wSiuSwEdY5mnTnkaPbFc68dMNs+2B7Kv3x/mlBROY=;
 b=WtkqIER4B39Rtn0KoGhagfTPEprA9vcwAfA4/BuDHqx7oSPsUmc3ZkAb0ISnpfnod5
 moX2l56Eqho1QLF/NdHKQ8QQCPxMM+fwaE0/ddJB/V+wNP0Z/OGYzrm1nrdkoTE1NCTO
 GKykAD5MW2WWGNxru7OC+JK1FS0XY+8mwsFm0dleYLmiJep5Fs/AbCD2jwopDUgy9o1Z
 WN4ZsQM6/88bU2kI5oAPoOTCrp0+r48JG2Jzb5AAQ85qfVJWiRJi6HknGVJO2UjYREUF
 XOkDRcu3NQjvQ7rIuSzluBTnm5sJ0/C3CAwOQIfKgEo4PSCRx5SAQK5xFx2TfFtaXjwQ
 09dw==
X-Gm-Message-State: AOAM531KR68W9mldajLniyPIPWVZL09STZ3UsaC5i6xUeVjlJWKEnNt0
 pkemxwpCDjXkHAMsp2uelcS2JJa2oF+nV/PxLnGXRw==
X-Google-Smtp-Source: ABdhPJwxpqbxXyab8ESki88sczGcbJxWGMwzL5arJQ5jrtTs062e6/AT9v4MrGSdRY/uVxIocNtDe7xab3HHmq5sxbI=
X-Received: by 2002:a81:dd07:0:b0:2eb:f701:286e with SMTP id
 e7-20020a81dd07000000b002ebf701286emr11872882ywn.341.1651517222179; Mon, 02
 May 2022 11:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
In-Reply-To: <87ilqoi77b.wl-maz@kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 2 May 2022 11:46:26 -0700
Message-ID: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Tue, 03 May 2022 09:31:31 -0400
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

On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 29 Apr 2022 21:11:28 +0100,
> Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > KVM mmu. This provides more insights on the kernel memory used
> > by a workload.
> >
> > This stat will be used by subsequent patches to count KVM mmu
> > memory usage.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 5 +++++
> >  Documentation/filesystems/proc.rst      | 4 ++++
> >  drivers/base/node.c                     | 2 ++
> >  fs/proc/meminfo.c                       | 2 ++
> >  include/linux/mmzone.h                  | 1 +
> >  mm/memcontrol.c                         | 1 +
> >  mm/page_alloc.c                         | 6 +++++-
> >  mm/vmstat.c                             | 1 +
> >  8 files changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 69d7a6983f78..828cb6b6f918 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
> >         pagetables
> >                  Amount of memory allocated for page tables.
> >
> > +       secondary_pagetables
> > +             Amount of memory allocated for secondary page tables,
> > +             this currently includes KVM mmu allocations on x86
> > +             and arm64.
>
> Can you please explain what the rationale is for this? We already
> account for the (arm64) S2 PTs as a userspace allocation (see

This can be considered as continuation for that work. The mentioned
commit accounts S2 PTs to the VM process cgroup kernel memory. We have
stats for the total kernel memory, and some fine-grained categories of
that, like (pagetables, stack, slab, etc.).

This patch just adds another category to give further insights into
what exactly is using kernel memory.

> 115bae923ac8bb29ee635). You are saying that this is related to a
> 'workload', but given that the accounting is global, I fail to see how
> you can attribute these allocations on a particular VM.

The main motivation is having the memcg stats, which give attribution
to workloads. If you think it's more appropriate, we can add it as a
memcg-only stat, like MEMCG_VMALLOC (see 4e5aa1f4c2b4 ("memcg: add
per-memcg vmalloc stat")). The only reason I made this as a global
stat too is to be consistent with NR_PAGETABLE.

>
> What do you plan to do for IOMMU page tables? After all, they serve
> the exact same purpose, and I'd expect these to be handled the same
> way (i.e. why is this KVM specific?).

The reason this was named NR_SECONDARY_PAGTABLE instead of
NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
account other types of secondary page tables to this stat. It is just
that we are currently interested in the KVM MMU usage.

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
