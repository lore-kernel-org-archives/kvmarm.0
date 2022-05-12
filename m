Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C13C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 12 May 2022 23:29:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DA0749F1F;
	Thu, 12 May 2022 19:29:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FqJ90idXFGAC; Thu, 12 May 2022 19:29:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E54B849F14;
	Thu, 12 May 2022 19:29:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49CB249F09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 19:29:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vYsxd+pL9pLD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2022 19:29:44 -0400 (EDT)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0724B49F07
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 19:29:43 -0400 (EDT)
Received: by mail-pg1-f177.google.com with SMTP id r71so5597090pgr.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 16:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/iy7DvZiK8nafA5XKuXqSqcNqBCZjj9/qjUXXJFqGpQ=;
 b=cWZf8gG13SFYJAbym+C3jUQYUcEqHiEmBSGcMRkGeKtHJpoPVjCJpboc2DabP5dHl4
 t2pGv+CgDWDeHxJP9tx6pCY9dSjjnguG4ekrfcrEUPi+LIH60qOBWqDT9YCyqkQV8C4/
 dSaySBo05+qtz5foTJQ9KZOVML5d+2f0Q7XlTuBAcMKJyVliAc9S9Hsa6xjkW2Sp6kD0
 1UgaKp+HBuU30LUTW23SGQf4o5bUWN8CesvUXR+7waPEQ995rJuJyEfEpi5J8hby+7Aj
 Cx1uoQ+692VdjLzjahYMHQzslw6xA739laCwIfxc6iaGRPPEF0WSqEC8fNXQchv8WP2x
 CzyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/iy7DvZiK8nafA5XKuXqSqcNqBCZjj9/qjUXXJFqGpQ=;
 b=Pj+Hlbj4IyGeUjmhxa+K4igbOKlu7n0WW+rINn9HrGgL+Ij1vLr9MMuyzIk9wDZD2o
 F5wXWdR+UT4lVTmddozrQhttie2h4i9BROZswTUhNFW6z/90AWndw24bHfE8UOZ4G815
 IXPknl9RSie+OA/I/QyLjHW5bKtpf7gXGR9P+zlQCYYXmiZ6VLhSYGpwBahNAXyckE7W
 D/CjnpgKIe8b0vqb9WXtLHAxkD4O0MTmoMcykhHQjKOAnoPDVHgxZHdm5vAiFLgBda3V
 trfjtkS+hJ44RyJkG+G9nlExMlvG68ZdsSXAU4nrq4ndzXqKSsV40o+SG+tSyd57l2ZW
 uiUQ==
X-Gm-Message-State: AOAM532A/ddMkIz99LO51+VIf0vOZYxwQnREFNNgfd5f9qe9nDwPRCyV
 xLgPGG6xJ5pXmeR6IACk4EJcrw==
X-Google-Smtp-Source: ABdhPJxxG6YUzPEUM5+g1vu/KK0sSWSbi9F/X2ppQRyP6w4zTtX0HAmpJ+CS2CQNyEouYPVZqp8oog==
X-Received: by 2002:a63:d20e:0:b0:3db:5e25:26c with SMTP id
 a14-20020a63d20e000000b003db5e25026cmr1559604pgg.200.1652398182635; 
 Thu, 12 May 2022 16:29:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 n2-20020a622702000000b0050dc76281e7sm333832pfn.193.2022.05.12.16.29.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 12 May 2022 16:29:42 -0700 (PDT)
Date: Thu, 12 May 2022 23:29:38 +0000
From: Sean Christopherson <seanjc@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Yn2YYl98Vhh/UL0w@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Yosry Ahmed <yosryahmed@google.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
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

On Thu, May 12, 2022, Johannes Weiner wrote:
> Hey Yosry,
> 
> On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > 115bae923ac8bb29ee635). You are saying that this is related to a
> > > 'workload', but given that the accounting is global, I fail to see how
> > > you can attribute these allocations on a particular VM.
> > 
> > The main motivation is having the memcg stats, which give attribution
> > to workloads. If you think it's more appropriate, we can add it as a
> > memcg-only stat, like MEMCG_VMALLOC (see 4e5aa1f4c2b4 ("memcg: add
> > per-memcg vmalloc stat")). The only reason I made this as a global
> > stat too is to be consistent with NR_PAGETABLE.
> 
> Please no memcg-specific stats if a regular vmstat item is possible
> and useful at the system level as well, like in this case. It's extra
> memcg code, extra callbacks, and it doesn't have NUMA node awareness.
> 
> > > What do you plan to do for IOMMU page tables? After all, they serve
> > > the exact same purpose, and I'd expect these to be handled the same
> > > way (i.e. why is this KVM specific?).
> > 
> > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > account other types of secondary page tables to this stat. It is just
> > that we are currently interested in the KVM MMU usage.
> 
> Do you actually care at the supervisor level that this memory is used
> for guest page tables?

Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
for page tables, but except for page tables, the number/size of those allocations
scales linearly with either the number of vCPUs or the amount of memory assigned
to the VM (with no room for improvement barring KVM changes).

Off the top of my head, KVM's secondary page tables are the only allocations that
don't scale linearly, especially when nested virtualization is in use.

> It seems to me you primarily care that it is reported *somewhere*
> (hence the piggybacking off of NR_PAGETABLE at first). And whether
> it's page tables or iommu tables or whatever else allocated for the
> purpose of virtualization, it doesn't make much of a difference to the
> host/cgroup that is tracking it, right?
> 
> (The proximity to nr_pagetable could also be confusing. A high page
> table count can be a hint to userspace to enable THP. It seems
> actionable in a different way than a high number of kvm page tables or
> iommu page tables.)

I don't know about iommu page tables, but on the KVM side a high count can also
be a good signal that enabling THP would be beneficial.  It's definitely actionable
in a different way though too.

> How about NR_VIRT? It's shorter, seems descriptive enough, less room
> for confusion, and is more easily extensible in the future.

I don't like NR_VIRT because VFIO/iommu can be used for non-virtualization things,
and we'd be lying by omission unless KVM (and other users) updates all of its
large-ish allocations to account them correctly.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
