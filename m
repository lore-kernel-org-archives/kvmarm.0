Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E4DC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 08:41:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A0F49EE6;
	Sat, 28 May 2022 04:41:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pm0R75coEu+Z; Sat, 28 May 2022 04:41:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25C334B224;
	Sat, 28 May 2022 04:41:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D43824B1BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 14:34:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zMR8q4Xqs2zH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 14:34:05 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6787249ED2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 14:34:05 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id u3so6893368wrg.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 11:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ZMRaR78nxxjwROTv5Xv0uCrlGpUNKsmrgGJVBdvr8Ow=;
 b=MkzqrGgvYlJnACcMhuImZMacQWLHV1sfIdXNuvsTHnrOm/OtJW/K9hyD3QxlczsLoT
 y8wk264wphMEIWY/RDJ7JWPjvXefBQcB7eVBOUBhZ+RsMwz/xaX7hq5oPUFVoNm6gk+9
 ECC8TXoBKcjMQzd/Lx+VaeiZUjV0ikBmp5ZprAw/qhOBi6WaPZolyclGk7kbaG4wUmNU
 +mIFZCiGrm+cA09ar5e2i9xVloL7GuFnwLMsoJoJXN3aAZ1DbrqnVYdqcioLJkScP577
 ZEsHAj7/WcJolt2zrK/cc8Q5BlFMYbDm2Oga3A+8NHOYgCiMkGz8pf41smTE0Irti5Jf
 eM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ZMRaR78nxxjwROTv5Xv0uCrlGpUNKsmrgGJVBdvr8Ow=;
 b=bUDlymClrCmx1/oLGf/FVPcuv5rhOmkiZDjD2wQByaUrDtUQqVhgnlIJDo6FKmyTvs
 UCLabJYMeoD+rcOk5CG20FXsRoi/ldPuAuHsFiKJaeEwnqbG0aGmlR688OPkP6/7Noxg
 zHIKZ/QbFGnogTGte0i4FmtViE8Zwu2cS3Ql1xFDGPUI0FGr5j5idOrt27FOID+Wc9OP
 C5n/jGi5TvnK8b2bls4i1V4tA6N9bv/ALxSkya0H8VukQIn23B1aJPxqtt9qnBimIk4V
 3Kuacdrk28qxujMz9bQVhrtAek8kOARnuee26hhgB/cUBXp0cwbHfhg+bpN/f/dQ4t6J
 3qWg==
X-Gm-Message-State: AOAM532EdnSKGl42pOogT75eKS+4fe1LgnwX8uTQ9sAWOB+whCAwGaEa
 H04sGeXCereKfJh1DZHAh9E59EgFBGRyKZ6XMLmnEw==
X-Google-Smtp-Source: ABdhPJxUkKLq8UKhcdaeqCHY4EBxsrPSLnU5/L22u7NUw4uGgA00AplmrdnobCWk7FoVQrgXmXTGsKhVFFO9PCXmQT8=
X-Received: by 2002:a05:6000:544:b0:20f:ca41:cc4c with SMTP id
 b4-20020a056000054400b0020fca41cc4cmr26548956wrf.582.1653676444165; Fri, 27
 May 2022 11:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
 <Yo4Ze+DZrLqn0PeU@cmpxchg.org> <Yo7MHA2aUaprvgl8@google.com>
In-Reply-To: <Yo7MHA2aUaprvgl8@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Fri, 27 May 2022 11:33:27 -0700
Message-ID: <CAJD7tkYoz=rYvBV3tcp4aLgiyEtr-sBwbncFduZsOq+c8wk5sA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Sat, 28 May 2022 04:41:03 -0400
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

On Wed, May 25, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 25, 2022, Johannes Weiner wrote:
> > On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> > > I don't have enough context to say whether we should piggyback KVM MMU
> > > pages to the existing NR_PAGETABLE item, but from a high level it
> > > seems like it would be more helpful if they are a separate stat.
> > > Anyway, I am willing to go with whatever Sean thinks is best.
> >
> > Somebody should work this out and put it into a changelog. It's
> > permanent ABI.
>
> After a lot of waffling, my vote is to add a dedicated NR_SECONDARY_PAGETABLE.
>
> It's somewhat redundant from a KVM perspective, as NR_SECONDARY_PAGETABLE will
> scale with KVM's per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> bizarre, e.g. accessing only 4kb chunks of 2mb pages so that KVM is forced to
> allocate a large number of page tables even though the guest isn't accessing that
> much memory.
>
> But, someone would need to either understand how KVM works to make that connection,
> or know (or be told) to go look at KVM's stats if they're running VMs to better
> decipher the stats.
>
> And even in the little bit of time I played with this, I found having
> nr_page_table_pages side-by-side with nr_secondary_page_table_pages to be very
> informative.  E.g. when backing a VM with THP versus HugeTLB,
> nr_secondary_page_table_pages is roughly the same, but nr_page_table_pages is an
> order of a magnitude higher with THP.  I'm guessing the THP behavior is due to
> something triggering DoubleMap, but now I want to find out why that's happening.
>
> So while I'm pretty sure a clever user could glean the same info by cross-referencing
> NR_PAGETABLE stats with KVM stats, I think having NR_SECONDARY_PAGETABLE will at the
> very least prove to be helpful for understanding tradeoffs between VM backing types,
> and likely even steer folks towards potential optimizations.
>
> Baseline:
>   # grep page_table /proc/vmstat
>   nr_page_table_pages 2830
>   nr_secondary_page_table_pages 0
>
> THP:
>   # grep page_table /proc/vmstat
>   nr_page_table_pages 7584
>   nr_secondary_page_table_pages 140
>
> HugeTLB:
>   # grep page_table /proc/vmstat
>   nr_page_table_pages 3153
>   nr_secondary_page_table_pages 153
>

Interesting findings! Thanks for taking the time to look into this, Sean!
I will refresh this patchset and summarize the discussion in the
commit message, and also fix some nits on the KVM side. Does this
sound good to everyone?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
