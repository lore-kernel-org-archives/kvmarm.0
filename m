Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098E1C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 13 May 2022 17:14:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CC364B132;
	Fri, 13 May 2022 13:14:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4PBajNU32VBP; Fri, 13 May 2022 13:14:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6924349EFB;
	Fri, 13 May 2022 13:14:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C532349EBE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:14:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9QWToHlFLwFp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 13:14:07 -0400 (EDT)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AEAF49EB2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:14:07 -0400 (EDT)
Received: by mail-pg1-f169.google.com with SMTP id 202so8059082pgc.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 10:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VM6L7CzHZq+DP15ACyDCNeBcnTiw96jhTORnn16Mcn8=;
 b=m7gQomUnSLOq+9pE4q9ffHGKLb3L3GE/tyqnZaMpqmJHNyG5wt5m5mpVnrt/R5fltk
 yK5RyYuw70QdsT3xpjionXDVduKVwIkENV/Mv5F0EHktzxJsXpmHkKAWfcOwy5gVtQvt
 Jb9aF197MUvc/8VfJWEKOA0A5W6r7Y5jyFAxdXtd+z7v8GihBIgqkMzUgDgmRLDEQBOl
 8CqLPCu3zlaWk59USw4+jqNDxNbSsUsyKPMu7PWzekJIARr0BRZnv82P4+e07sbtFdHd
 l7nGCtA297XhzYezBsDN16APQINq+JlpmHHYdQbrAp93SyhwC2tFFlzq6Ax51hV8P071
 YexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VM6L7CzHZq+DP15ACyDCNeBcnTiw96jhTORnn16Mcn8=;
 b=h7IjH5tF58GbX8HwYx1AHXJrpoYuit7RiL7s5uEMN9jE6Mmyuo0PylXeNukO1XAehk
 UTeIwIdlQ9XXPk+Xu0Uejxap3fI5EQAZgP2To7ilvFyKSIGzt7mrwaEeKPDFcNbDVPAi
 3aA2hK3cfqlICfF/nB4VbPwBbtJMqgmcwRtlYV4f3AC7aFHAlZFf+RYc/kCWa7dwdKaF
 Rq/qm9Ca6e4brAVhTJLZrPDUt7eTOLlj79l9na6A5slHm5Awuks5Gp62LqUe8VPyuAR3
 B0JEBPE17NFvpaDJnDPARMf4Nu3HbubcvhbjxB88Jfu3dBd3Q6u6NC617SPB6ZbMB65R
 9qrQ==
X-Gm-Message-State: AOAM530jDj+DGQUK4AQO2+4Ky2IzOwKNGIaqxAUiF+kHzREPLo6olSNk
 6z0Qb15UXEYCZr/Tv6XAtZHwNCut2ocM+oqUnJMFjA==
X-Google-Smtp-Source: ABdhPJzzJRHomgqXTbd3lMoRoFV7vbrkO5L/UrOYsIgvGq7U/iV65DcmY+1YVfkRJDcWOE7WzBlet9mYxMGwLWQyyE4=
X-Received: by 2002:a63:1866:0:b0:3db:4b04:9f56 with SMTP id
 38-20020a631866000000b003db4b049f56mr4750300pgy.509.1652462046391; Fri, 13
 May 2022 10:14:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
In-Reply-To: <Yn6DeEGLyR4Q0cDp@google.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Fri, 13 May 2022 10:13:54 -0700
Message-ID: <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Sean Christopherson <seanjc@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Yosry Ahmed <yosryahmed@google.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
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

On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
>
[...]
>
> It was mostly an honest question, I too am trying to understand what userspace
> wants to do with this information.  I was/am also trying to understand the benefits
> of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> already has specific stats for the number of leaf pages mapped into a VM, why not
> do the same for non-leaf pages?

Let me answer why a more general stat is useful and the potential
userspace reaction:

For a memory type which is significant enough, it is useful to expose
it in the general interfaces, so that the general data/stat collection
infra can collect them instead of having workload dependent stat
collectors. In addition, not necessarily that stat has to have a
userspace reaction in an online fashion. We do collect stats for
offline analysis which greatly influence the priority order of
optimization workitems.

Next the question is do we really need a separate stat item
(secondary_pagetable instead of just plain pagetable) exposed in the
stable API? To me secondary_pagetable is general (not kvm specific)
enough and can be significant, so having a separate dedicated stat
should be ok. Though I am ok with lump it with pagetable stat for now
but we do want it to be accounted somewhere.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
