Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963ADC43217
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 21:19:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF54408B3;
	Tue, 26 Apr 2022 17:19:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D2BF91ocnvi2; Tue, 26 Apr 2022 17:19:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A42EA40C02;
	Tue, 26 Apr 2022 17:19:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 159494B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 15:28:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ey9OJrPX7CnK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 15:28:35 -0400 (EDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C584A49F5D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 15:28:35 -0400 (EDT)
Received: by mail-wm1-f48.google.com with SMTP id m62so1219815wme.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 12:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=iQFCk4jvRcDNbkwKt80r8M9Ev1zqOHCdGqGh5NtELGk=;
 b=kXX2A5pPeYzQ7cMHjUay8+MRco1JY+qcFRaRS08NAVmtfBRdvFVDmNjStpeUWkd6Zl
 vQU5f0FWDf6xsz3RbldyIy9/g5QXdZSQZuDeQifodlFGCf1YGsKpdQYyR2g9y7Y6oB7V
 /fsu0vO21DVFRug79wN6ff9wbCwuMNbpj0fPxn9wyJ+3cQTLW9PimSQ9f6xgnaxtH2fO
 AlrXyAXCzlK49e6n1Ju/HDLsl9jTbgxFH3GdBJYGeSidfswDSkOpdP8/KDLnQJLtqZUp
 IpGuwUWRrQLmAANIliRHGcWrJVnvTEjLAdmNwn2651HlpB30PBm/qWLfwGYSI3Qrg/mB
 i7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=iQFCk4jvRcDNbkwKt80r8M9Ev1zqOHCdGqGh5NtELGk=;
 b=LyDeon2VoxC0DVj65alKH33M/L5an2Jf2kIxhsERsHx/NJIvBpLy2OgtKNtimk9CeM
 C6VtgN8GqEj8NUjQQttR0oxMsgraWcnR9C/atZdzzD83NBJDsVQwKIqCa0EPIhUrQ3Gi
 XfzQODzHKdABE27N4qkjL9sIV0C6n5ZdDMKIhT5TLMXgRhb3dVw0aciM+DzGIliyQ5rq
 yOkErCG3Z7c17l95ATQ3LC+ySB1PjtVHajaUk2zRx8KUnV3pG6gxX4Xtveiq5tF3lexz
 G9DL4AuZNYdDHX4FlxFX/u+lwlcooea5P0T/Xkj1hj9lwJ5755oCjcO3hIbP3dTnfxj6
 SN3A==
X-Gm-Message-State: AOAM531hZBZmNJG0Gufcc7wprx0u9xymwer/oO3MIKSnpR2qfu0waV4X
 Wev8vJgiLMBkuS625oipVdusgDDPqReYNWdvcTSYuQ==
X-Google-Smtp-Source: ABdhPJxE4uF7k63kUhII0yfWNs5hqWLsW6+10S6JtH7VxMkI6vG6IvE9QqtG19aVEP77InoCW4FL0NJd1Gr2ps0f3PU=
X-Received: by 2002:a05:600c:1c90:b0:393:e5b9:b567 with SMTP id
 k16-20020a05600c1c9000b00393e5b9b567mr16137822wms.27.1651001314470; Tue, 26
 Apr 2022 12:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com> <YmegoB/fBkfwaE5z@google.com>
In-Reply-To: <YmegoB/fBkfwaE5z@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 26 Apr 2022 12:27:57 -0700
Message-ID: <CAJD7tkY-WZKcyer=TbWF0dVfOhvZO7hqPN=AYCDZe1f+2HA-QQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Tue, 26 Apr 2022 17:19:39 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>,
 Atish Patra <atishp@atishpatra.org>, cgroups@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, linux-mips@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kvm-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

Hi Oliver,
Thanks so much for taking the time to take a look at this!

On Tue, Apr 26, 2022 at 12:35 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Yosry,
>
> On Tue, Apr 26, 2022 at 05:39:02AM +0000, Yosry Ahmed wrote:
> > Count the pages used by KVM in arm64 for page tables in pagetable stats.
> >
> > Account pages allocated for PTEs in pgtable init functions and
> > kvm_set_table_pte().
> >
> > Since most page table pages are freed using put_page(), add a helper
> > function put_pte_page() that checks if this is the last ref for a pte
> > page before putting it, and unaccounts stats accordingly.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  arch/arm64/kernel/image-vars.h |  3 ++
> >  arch/arm64/kvm/hyp/pgtable.c   | 50 +++++++++++++++++++++-------------
> >  2 files changed, 34 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 241c86b67d01..25bf058714f6 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -143,6 +143,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
> >  /* pKVM static key */
> >  KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
> >
> > +/* Called by kvm_account_pgtable_pages() to update pagetable stats */
> > +KVM_NVHE_ALIAS(__mod_lruvec_page_state);
> > +
> >  #endif /* CONFIG_KVM */
> >
> >  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 2cb3867eb7c2..53e13c3313e9 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -152,6 +152,7 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
> >
> >       WARN_ON(kvm_pte_valid(old));
> >       smp_store_release(ptep, pte);
> > +     kvm_account_pgtable_pages((void *)childp, +1);
>
> What page tables do we want to account? KVM on ARM manages several page
> tables.
>
> For regular KVM, the host kernel manages allocations for the hyp stage 1
> tables in addition to the stage 2 tables used for a particular VM. The
> former is system overhead whereas the latter could be attributed to a
> guest VM.

Honestly I would love to get your input on this. The main motivation
here is to give users insights on the kernel memory usage on their
system (or in a cgroup). We currently have NR_PAGETABLE stats for
normal kernel page tables (allocated using
__pte_alloc_one()/pte_free()), this shows up in /proc/meminfo,
/path/to/cgroup/memory.stat, and node stats. The idea is to add
NR_SECONDARY_PAGETABLE that should include the memory used for kvm
pagetables, which should be a separate category (no overlap). What
gets included or not depends on the semantics of KVM and what exactly
falls under the category of secondary pagetables from the user's pov.

Currently it looks like s2 page table allocations get accounted to
kmem of memory control groups (GFP_KERNEL_ACCOUNT), while hyp page
table allocations do not (GFP_KERNEL). So we could either follow this
and only account s2 page table allocations in the stats, or make hyp
allocations use GFP_KERNEL_ACCOUNT as well and add them to the stats.
Let me know what you think.

>
> I imagine protected KVM is out of scope, since it actually manages its
> own allocations outside of the host kernel.
>
> Given this, I would recommend adding the accounting hooks to mmu.c as
> that is where we alloc/free table pages and it is in the host address
> space. kvm_s2_mm_ops and kvm_hyp_mm_ops point to all the relevant
> functions, though the latter is only relevant if we want to count system
> page tables too.

Yeah moving the accounting hooks to mmu.c is much cleaner, I will do
this in the next version. The only reason I did not do this is that I
found other kvm_pgtable_mm_ops structs (such as pkvm_pgtable_mm_ops),
but it looks like these may be irrelevant here.

>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
