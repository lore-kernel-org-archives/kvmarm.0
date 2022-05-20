Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E46C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 08:15:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 602784B28B;
	Fri, 20 May 2022 04:15:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1THZ0YFZZYqI; Fri, 20 May 2022 04:15:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2269A4B2FC;
	Fri, 20 May 2022 04:15:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ADB84B2E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 21:57:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ftn0Ub-JHmDO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 21:57:32 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 263FF4B2DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 21:57:32 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id t6so9558356wra.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 18:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=h/NS3+bOivmdn/Z8oAqTayRG5MjC4lANEwiPrpSX5IA=;
 b=lC1A71c86K3b210P5MINYKI+0nEPTtRGK3LeWj2Npew4lX9mJGgrpWWegiuNtMwlJO
 P1IlUwgqu95jwD3J+mnRGelGqXz+HoaJ7VCJk9hhvvF66jPz+hrvF0dmKSe2LLL2Vgq/
 rwXqca2l71+mfz5tl8pRhTv4LCsg9QGocKsxdwCfWXbGVabJpfgNFG9+rBVSpj/uhude
 6hLQ+JpxChsTxgZBARTq2zFr80q+S2jttKKsRPO0P7o9moE/Iyx8K/oNzwHCGA7J5UxE
 CJjZ0hW/O6s0vTeoubWTNpA5gAfGug3OjBmx35+8T9dkzXFSpzM7/kEn0mCCEAR9GuP4
 zRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=h/NS3+bOivmdn/Z8oAqTayRG5MjC4lANEwiPrpSX5IA=;
 b=xyrsqA43ljc4H0shDMQTD/Ups9yeBuFnCqvXs6V4v///QQrv1HkMmgUad9KnKaCh+y
 LsLjGSy4zkJRVsr/01FFcm3QUSjb89Rt7zcgxVOlxv2F+w5q5SLaqBcbN3Cj5+2bD7ch
 uTmwApOft3fTtOrQHnPnjFgbyeBr0CmwxEyqOsPSTme3APFtRUUKXfcapiHCYd94naNd
 l05ESKuqqNcw75AetzC6Y8rEqxgQoKI+iBP0B/S+lP4hq3pdiNWRZbyVCN25dU15fBBh
 G4X13xP4vIBir586UkCt1QSIq0nAbujlgDVmJVOsy26yr+vN/bo/kY26gd2uLob/HBZ3
 //Iw==
X-Gm-Message-State: AOAM530rY4VhCJHxWs2oWx+wD8Yd/DWuuJXoj92BWmdRDtSZTzNMZdVD
 8YW/yzMbWw39EMTVooPVmA9fgkHvndLOtoZTll48cQ==
X-Google-Smtp-Source: ABdhPJwkT9Ky/oISspASS8FjtELCGMc/VI5WvnHs18qGYZT5kAwspcv3o3fkcjB+NGakAekQntgOyy/dXNI6HrW1Wu8=
X-Received: by 2002:adf:f042:0:b0:20e:5be7:f473 with SMTP id
 t2-20020adff042000000b0020e5be7f473mr6249346wro.80.1653011850753; Thu, 19 May
 2022 18:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
In-Reply-To: <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 19 May 2022 18:56:54 -0700
Message-ID: <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Shakeel Butt <shakeelb@google.com>
X-Mailman-Approved-At: Fri, 20 May 2022 04:15:35 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cgroups <cgroups@vger.kernel.org>,
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

On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> [...]
> >
> > It was mostly an honest question, I too am trying to understand what userspace
> > wants to do with this information.  I was/am also trying to understand the benefits
> > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > already has specific stats for the number of leaf pages mapped into a VM, why not
> > do the same for non-leaf pages?
>
> Let me answer why a more general stat is useful and the potential
> userspace reaction:
>
> For a memory type which is significant enough, it is useful to expose
> it in the general interfaces, so that the general data/stat collection
> infra can collect them instead of having workload dependent stat
> collectors. In addition, not necessarily that stat has to have a
> userspace reaction in an online fashion. We do collect stats for
> offline analysis which greatly influence the priority order of
> optimization workitems.
>
> Next the question is do we really need a separate stat item
> (secondary_pagetable instead of just plain pagetable) exposed in the
> stable API? To me secondary_pagetable is general (not kvm specific)
> enough and can be significant, so having a separate dedicated stat
> should be ok. Though I am ok with lump it with pagetable stat for now
> but we do want it to be accounted somewhere.

Any thoughts on this? Johannes?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
