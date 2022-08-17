Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4746DC00140
	for <kvmarm@archiver.kernel.org>; Thu, 18 Aug 2022 07:36:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C68704DF9E;
	Thu, 18 Aug 2022 03:36:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux-foundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QEIMlvEJxOSV; Thu, 18 Aug 2022 03:36:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7968E4DF9F;
	Thu, 18 Aug 2022 03:36:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE134CEAD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 13:24:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AqngOHVaz03j for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2022 13:24:13 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1E2D4CEA9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 13:24:13 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 93D0CB81EAE;
 Wed, 17 Aug 2022 17:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684EFC433B5;
 Wed, 17 Aug 2022 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1660757050;
 bh=h7rloNmTPwUDXGSYX5u3jVl/NrdFIyTwfIZuYDpyc+s=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=SCu1HHR6yDn0wowMIHnbsEbhjw3fO1TLcBcRSyKUXhWF/dl/GDPzQvg9LYQvU2YWP
 jBgUTXdC1VHSy6asKtLxxa4w4uLsVNSoZ57fahkuaNnkeeBRwR6GmBa/lfF6BHegwJ
 BaN4hOiavyPxE2PiZVXnb/b8vqfCGE1FVzDXR9rk=
Date: Wed, 17 Aug 2022 10:24:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count
 secondary page table uses.
Message-Id: <20220817102408.7b048f198a736f053ced2862@linux-foundation.org>
In-Reply-To: <20220628220938.3657876-2-yosryahmed@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
X-Mailman-Approved-At: Thu, 18 Aug 2022 03:36:12 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Huang@google.com,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
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

On Tue, 28 Jun 2022 22:09:35 +0000 Yosry Ahmed <yosryahmed@google.com> wrote:

> We keep track of several kernel memory stats (total kernel memory, page
> tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> per-memcg, etc). These stats give insights to users to how much memory
> is used by the kernel and for what purposes.
> 
> Currently, memory used by kvm mmu is not accounted in any of those
> kernel memory stats. This patch series accounts the memory pages
> used by KVM for page tables in those stats in a new
> NR_SECONDARY_PAGETABLE stat. This stat can be later extended to account
> for other types of secondary pages tables (e.g. iommu page tables).
> 
> KVM has a decent number of large allocations that aren't for page
> tables, but for most of them, the number/size of those allocations
> scales linearly with either the number of vCPUs or the amount of memory
> assigned to the VM. KVM's secondary page table allocations do not scale
> linearly, especially when nested virtualization is in use.
> 
> >From a KVM perspective, NR_SECONDARY_PAGETABLE will scale with KVM's
> per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> bizarre (e.g. accessing only 4kb chunks of 2mb pages so that KVM is
> forced to allocate a large number of page tables even though the guest
> isn't accessing that much memory). However, someone would need to either
> understand how KVM works to make that connection, or know (or be told) to
> go look at KVM's stats if they're running VMs to better decipher the stats.
> 
> Furthermore, having NR_PAGETABLE side-by-side with NR_SECONDARY_PAGETABLE
> is informative. For example, when backing a VM with THP vs. HugeTLB,
> NR_SECONDARY_PAGETABLE is roughly the same, but NR_PAGETABLE is an order
> of magnitude higher with THP. So having this stat will at the very least
> prove to be useful for understanding tradeoffs between VM backing types,
> and likely even steer folks towards potential optimizations.
> 
> The original discussion with more details about the rationale:
> https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org
> 
> This stat will be used by subsequent patches to count KVM mmu
> memory usage.

Nits and triviata:

> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -977,6 +977,7 @@ Example output. You may not have all of these fields.
>      SUnreclaim:       142336 kB
>      KernelStack:       11168 kB
>      PageTables:        20540 kB
> +    SecPageTables:         0 kB
>      NFS_Unstable:          0 kB
>      Bounce:                0 kB
>      WritebackTmp:          0 kB
> @@ -1085,6 +1086,9 @@ KernelStack
>                Memory consumed by the kernel stacks of all tasks
>  PageTables
>                Memory consumed by userspace page tables
> +SecPageTables
> +              Memory consumed by secondary page tables, this currently
> +	      currently includes KVM mmu allocations on x86 and arm64.

Something happened to the whitespace there.

> +			     "Node %d SecPageTables:  %8lu kB\n"
> ...
> +			     nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),

The use of "sec" in the user-facing changes and "secondary" in the
programmer-facing changes is irksome.  Can we be consistent?  I'd
prefer "secondary" throughout.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
