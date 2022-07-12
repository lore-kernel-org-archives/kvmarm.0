Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D4EC43334
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jul 2022 08:19:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3A74BEF0;
	Wed, 13 Jul 2022 04:19:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tRNCHrOto9TD; Wed, 13 Jul 2022 04:18:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC88A4BEF6;
	Wed, 13 Jul 2022 04:18:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B51CD4BC28
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 19:03:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FGqB6G26YEvP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 19:03:39 -0400 (EDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com
 [209.85.167.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90CDA4BC19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 19:03:39 -0400 (EDT)
Received: by mail-oi1-f178.google.com with SMTP id o133so12354496oig.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 16:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qHwuHViFSN86tj0ChYoibxcY4E2c7D4JyTppJFZI4so=;
 b=Lhh55GnSdOjPhbJGduTnxEGnWccw6kHOeEeY08jAZgJe0VqjmPoBdTPnONumi/pAun
 p+cHg4gHnhGSvibmw9wIMHwGbOMlbmWVVet0lyBNoQFKw49iIOLl44zlrlp+lgOkWr4N
 nI06n4Ji3hwluei1aEEzHQyZHr8WFbhVYRiJlwQVHmUD64NqpTZjoyhfvNHbS2GCc5aR
 uNpAcmjt7Eo2ZLV4iQ/jGK1hfJ4aVbxJui0znZqX9547wQXUukqWF8+PFEtZcDsj6osq
 cNrlBGb2ZoHRdeHJDRKTLI+onjdNABpheW4De5nAankciyk7viUqVbyzzoaaEs5liuGY
 qvhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qHwuHViFSN86tj0ChYoibxcY4E2c7D4JyTppJFZI4so=;
 b=gX4GTR/g2QChgWfOW1x/9gGxalNgNqk3U6iqWTPb0tOHwia7ph5/PHfutP7DKER0GQ
 aVOfLmi0YHPOqWtbRFen3QKoDey+c5FFIN1ZndSLxI8WH1qQh7X2XTbUpAUiIKC61xAQ
 kOfN5bRzWNyfiNRu/OshjlsbICCGDar7JkIq9CnctqEoYJmLNLKc3ph0me42QlpQnw8X
 nNMI33RjRUROO9INahepGdj/MC6bv/r5BiZOAj0zWICnbrH30QlKsfBMT6zIqr96BdaH
 2D1JTozbGcoj2SmLdiplkTZCTiRru2HuA6szXjeRUrmvqWGhHhycKpmjC2FFf/j/TevS
 kFyw==
X-Gm-Message-State: AJIora/n3H7l6yCqJvjbt9lh/EGe78n3yJcPLWoNNozesDzbA/NsU60g
 mMLK80eq4SJf8rJE0A5YCoVydN0koJlCpFUjcx9SOg==
X-Google-Smtp-Source: AGRyM1sv6/a3j0mcFzaoNZorrDTb4kx9QsLkQ7zFGrGqxGPqVxoEEPKoh5NgLCA2o5UhH33aMTJl+s4tUNJhAnFoewI=
X-Received: by 2002:aca:e043:0:b0:32e:1ad1:2d4 with SMTP id
 x64-20020acae043000000b0032e1ad102d4mr3357976oig.235.1657667018762; Tue, 12
 Jul 2022 16:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
In-Reply-To: <YsdJPeVOqlj4cf2a@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 12 Jul 2022 16:03:02 -0700
Message-ID: <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Wed, 13 Jul 2022 04:18:58 -0400
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

Thanks for taking another look at this!

On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > We keep track of several kernel memory stats (total kernel memory, page
> > tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> > per-memcg, etc). These stats give insights to users to how much memory
> > is used by the kernel and for what purposes.
> >
> > Currently, memory used by kvm mmu is not accounted in any of those
>
> Nit, capitalize KVM (mainly to be consistent).
>
> > @@ -1085,6 +1086,9 @@ KernelStack
> >                Memory consumed by the kernel stacks of all tasks
> >  PageTables
> >                Memory consumed by userspace page tables
> > +SecPageTables
> > +              Memory consumed by secondary page tables, this currently
> > +           currently includes KVM mmu allocations on x86 and arm64.
>
> Nit, this line has a tab instead of eight spaces.  Not sure if it actually matters,
> there are plenty of tabs elsewhere in the file, but all the entries in this block
> use only spaces.
>

Will fix it.

> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index aab70355d64f3..13190d298c986 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -216,6 +216,7 @@ enum node_stat_item {
> >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> >  #endif
> >       NR_PAGETABLE,           /* used for pagetables */
> > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
>
> Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> is messy, so I totally understand why you included it, but in this case it's unnecessary
> and potentially confusing.
>
> And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> stats the depend on a single feature seems to be the status quo for this code.
>

I will #ifdef the stat, but I will emphasize in the docs that is
currently *only* used for KVM so that it makes sense if users without
KVM don't see the stat at all. I will also remove the stat from
show_free_areas() in mm/page_alloc.c as it seems like none of the
#ifdefed stats show up there.

> >  #ifdef CONFIG_SWAP
> >       NR_SWAPCACHE,
> >  #endif
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
