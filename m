Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B432EC3F6B0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 00:05:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 079C34CE00;
	Mon, 22 Aug 2022 20:05:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BQOMzO3n6nYD; Mon, 22 Aug 2022 20:05:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 341334CE17;
	Mon, 22 Aug 2022 20:05:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 585AA4CE0E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:05:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4MvWSfp6bAFq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Aug 2022 20:05:35 -0400 (EDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0ADEE4CE00
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:05:34 -0400 (EDT)
Received: by mail-wr1-f47.google.com with SMTP id u5so7265720wrt.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 17:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=qokcu5tCtpQLCQgO9pVTazHLwMpC9kMD5hOC340KS1I=;
 b=jBPLk8bHlDLGIvGVE4zL26EtBtv9avfUdg557Lw4E+XzpuWZRA6yrM8jemnayVxmTu
 HFUGMWr/PHR8LguRaK0GVi7w26Qnt3CxyVGcW0n7UF3R4pU31QDsJO6/jSpmu9xmtRvy
 GHEx+99kDAzCMm28iwalvBDKvUcqcKRg/skmcRT/eIrUVHr5GG/kBpafDR+G5cad3XCs
 SCh0iHzLtcfdouEA1DsVo0u8G4R8t2qE8/4a4DAj7CCMmsaTPR1R4XpS2cOFX5Kk+Ew+
 PN7CoifI1ft5ccWK48IE5B74fHCM7d5LD91G37VfgpN9TcT7S+yGetYQj7xs0JO8WSdi
 opgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=qokcu5tCtpQLCQgO9pVTazHLwMpC9kMD5hOC340KS1I=;
 b=IASaQ0l4b3QWhcCiyf6wZW/koJbIxLuucjHNkAsYv/GzLT/WQQ/aBvpFTvTWiWAqbu
 UGHsOda10hkjv5O9zQkPMQpnX7gnpgoFqc1RQ3GoLO42zPfu5qhjZP+CF1NHeyhLPKCx
 Ru+A8lR4kDdVLhi0101h14wdU2kIP0EjhN3Qa5M0NU+TKLTPn2v++JYG6N4E8QPaQB2v
 Ywopkl+oLoP4mkN+qYID8dBBYW9mXJSviLgOJxHbGGobF8usVBwOpoqwUKvblrgFrCni
 w+ynRQQzUoy7EJONWG6wSRPrv7OoIXGdDe5VquTieyF5tap9cSw0CyxiWf/H23Yibqgu
 nXdA==
X-Gm-Message-State: ACgBeo2Oxeok5NbaCmWygN0Qu2NFe2TMfDE1nVlz7VdaOJ5VSQNQamzv
 KfTc8kzVjVGU6mSpBV7vQs/b177TluOuX4ez9DKGhg==
X-Google-Smtp-Source: AA6agR5Lo8c+tVx21B5A2il5HGzGcfxxCY5VNzyOQ8xHSFF9B9ZhcgyTcMW2pafj/S8owJMHXTCJIeOP/v9Ei+X67uo=
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id
 g8-20020a056000118800b002206c20fbf6mr12350055wrx.372.1661213133858; Mon, 22
 Aug 2022 17:05:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
 <20220817102408.7b048f198a736f053ced2862@linux-foundation.org>
 <CAJD7tkZQ07dZtcTSirj0qLawaE3Ndyn-385m_kL09=gsfO9QwA@mail.gmail.com>
In-Reply-To: <CAJD7tkZQ07dZtcTSirj0qLawaE3Ndyn-385m_kL09=gsfO9QwA@mail.gmail.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 22 Aug 2022 17:04:57 -0700
Message-ID: <CAJD7tkYiVBsWfwQ6qZ3NVzW=3UPTAjSmR5aYgT2M3gk+5Hq0_Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>,
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

On Wed, Aug 17, 2022 at 3:27 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Wed, Aug 17, 2022 at 10:24 AM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 28 Jun 2022 22:09:35 +0000 Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > > We keep track of several kernel memory stats (total kernel memory, page
> > > tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> > > per-memcg, etc). These stats give insights to users to how much memory
> > > is used by the kernel and for what purposes.
> > >
> > > Currently, memory used by kvm mmu is not accounted in any of those
> > > kernel memory stats. This patch series accounts the memory pages
> > > used by KVM for page tables in those stats in a new
> > > NR_SECONDARY_PAGETABLE stat. This stat can be later extended to account
> > > for other types of secondary pages tables (e.g. iommu page tables).
> > >
> > > KVM has a decent number of large allocations that aren't for page
> > > tables, but for most of them, the number/size of those allocations
> > > scales linearly with either the number of vCPUs or the amount of memory
> > > assigned to the VM. KVM's secondary page table allocations do not scale
> > > linearly, especially when nested virtualization is in use.
> > >
> > > >From a KVM perspective, NR_SECONDARY_PAGETABLE will scale with KVM's
> > > per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> > > bizarre (e.g. accessing only 4kb chunks of 2mb pages so that KVM is
> > > forced to allocate a large number of page tables even though the guest
> > > isn't accessing that much memory). However, someone would need to either
> > > understand how KVM works to make that connection, or know (or be told) to
> > > go look at KVM's stats if they're running VMs to better decipher the stats.
> > >
> > > Furthermore, having NR_PAGETABLE side-by-side with NR_SECONDARY_PAGETABLE
> > > is informative. For example, when backing a VM with THP vs. HugeTLB,
> > > NR_SECONDARY_PAGETABLE is roughly the same, but NR_PAGETABLE is an order
> > > of magnitude higher with THP. So having this stat will at the very least
> > > prove to be useful for understanding tradeoffs between VM backing types,
> > > and likely even steer folks towards potential optimizations.
> > >
> > > The original discussion with more details about the rationale:
> > > https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org
> > >
> > > This stat will be used by subsequent patches to count KVM mmu
> > > memory usage.
> >
> > Nits and triviata:
> >
> > > --- a/Documentation/filesystems/proc.rst
> > > +++ b/Documentation/filesystems/proc.rst
> > > @@ -977,6 +977,7 @@ Example output. You may not have all of these fields.
> > >      SUnreclaim:       142336 kB
> > >      KernelStack:       11168 kB
> > >      PageTables:        20540 kB
> > > +    SecPageTables:         0 kB
> > >      NFS_Unstable:          0 kB
> > >      Bounce:                0 kB
> > >      WritebackTmp:          0 kB
> > > @@ -1085,6 +1086,9 @@ KernelStack
> > >                Memory consumed by the kernel stacks of all tasks
> > >  PageTables
> > >                Memory consumed by userspace page tables
> > > +SecPageTables
> > > +              Memory consumed by secondary page tables, this currently
> > > +           currently includes KVM mmu allocations on x86 and arm64.
> >
> > Something happened to the whitespace there.
>
> Yeah I have the fix for this queued for v7. Thanks!
>
> >
> > > +                          "Node %d SecPageTables:  %8lu kB\n"
> > > ...
> > > +                          nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
> >
> > The use of "sec" in the user-facing changes and "secondary" in the
> > programmer-facing changes is irksome.  Can we be consistent?  I'd
> > prefer "secondary" throughout.
> >
>
> SecondaryPageTables is too long (unfortunately), it messes up the
> formatting in node_read_meminfo() and meminfo_proc_show(). I would
> prefer "secondary" as well, but I don't know if breaking the format in
> this way is okay.

Any thoughts here Andrew? Change to SecondaryPageTables anyway? Change
all to use "sec" instead of "secondary"? Leave as-is?


>
> This is what I mean by breaking the format btw (the numbers become misaligned):
>
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 5ad56a0cd593..4f85750a0f8e 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -433,7 +433,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>                              "Node %d ShadowCallStack:%8lu kB\n"
>  #endif
>                              "Node %d PageTables:     %8lu kB\n"
> -                            "Node %d SecPageTables:  %8lu kB\n"
> +                            "Node %d SecondaryPageTables:  %8lu kB\n"
>                              "Node %d NFS_Unstable:   %8lu kB\n"
>                              "Node %d Bounce:         %8lu kB\n"
>                              "Node %d WritebackTmp:   %8lu kB\n"
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 208efd4fa52c..b7166d09a38f 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -115,7 +115,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  #endif
>         show_val_kb(m, "PageTables:     ",
>                     global_node_page_state(NR_PAGETABLE));
> -       show_val_kb(m, "SecPageTables:  ",
> +       show_val_kb(m, "SecondaryPageTables:    ",
>                     global_node_page_state(NR_SECONDARY_PAGETABLE));
>
>         show_val_kb(m, "NFS_Unstable:   ", 0);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
