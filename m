Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109F8C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 06:51:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75A224B2E5;
	Wed, 25 May 2022 02:51:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id imG6PFehcVVo; Wed, 25 May 2022 02:51:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E9204B29A;
	Wed, 25 May 2022 02:51:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D86394B210
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2022 18:32:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QDn0v9vyCamC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2022 18:32:29 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 982774A10E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2022 18:32:29 -0400 (EDT)
Received: by mail-wr1-f52.google.com with SMTP id e28so27055770wra.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2022 15:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/hjeyXIou+bR7sgCBUUS9KBiw7ITkpAtyGQPK8WkjHQ=;
 b=E47CS0uk7HJ3B0+amVIKreQyHTGL6Id/MNM0NxjP7X6opvCgl1WcdBa5SnwKc3EDWw
 V2RSBPZ5PBv0+cdx0NAoNLXYDyjDup9mou8/UiOBU++4DVMVZrHzrWd+ZVhZFW2K8uMW
 p9b4jxU7DGV0i8n8hpbveKXjRPZjF7JZfelsg33lCxe6KvbM/3Kw2gy36RExYeMQcSnp
 QyMMPOr6T3TA59Xk7ew90wKydoDBGM28Fu7tgOmM6JcjUpxvmSbhb9njgSwtUUkrwV/Z
 SDvlO42njKkIejaVhIiCDGW4sF9Mf28i9mQR4sp9xyvJ2C1xtsrbm5Tfz8hGqHkzJQq/
 IEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/hjeyXIou+bR7sgCBUUS9KBiw7ITkpAtyGQPK8WkjHQ=;
 b=OtC4plLWYHfQ5OkyFChasW6WNq0pEWRYWJe+/jAokphOxsGd82e2ir4Z9lGg3fHjIT
 bIycllnoAhYp7D+oBVglOF5ZCkSo8inGHHDaEUTVp2045dmOGUMgiScKEv0elt9deA+r
 SefnBggN0L0uoa/T1aZ9Ucywg+l7q9qgplOwya7ysfQ2S17aoGA+mhLiZ+hqEx72t9mR
 W18vG5snbRmQ+hqcXz4aQ6LbkFOOBWi6RFU2hsr0H9E4V+owo/wbzWQ0i7XlDgqHNVlj
 p83V/CW/Wr+/vVnjAzg9V/kz/2coIAq65isRt54GLmC6C+9FDEfLJFkhI8tL5EjaloIV
 qeAA==
X-Gm-Message-State: AOAM531LcmqcXRZ/cxYC4+LzX403AWcc2BgDVR6EdUT8oPjvRTBPMoOg
 ESnfdmSCLTCoRiWeZDXh+y17jm/Hc+o1Btdkf9XMZQ==
X-Google-Smtp-Source: ABdhPJxT4ExN63oIrXSw4yucGOE3FdTxLSSWhIsKQP4q3l+uXQdQtcsiB0ShXvD15pANNDgeH4cCwpElZhKEPpNgNxo=
X-Received: by 2002:adf:fb05:0:b0:20a:e113:8f3f with SMTP id
 c5-20020adffb05000000b0020ae1138f3fmr25324902wrr.534.1653431548193; Tue, 24
 May 2022 15:32:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
In-Reply-To: <YoeoLJNQTam5fJSu@cmpxchg.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 24 May 2022 15:31:52 -0700
Message-ID: <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Johannes Weiner <hannes@cmpxchg.org>
X-Mailman-Approved-At: Wed, 25 May 2022 02:51:54 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 Cgroups <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
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

On Fri, May 20, 2022 at 7:39 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Thu, May 19, 2022 at 06:56:54PM -0700, Yosry Ahmed wrote:
> > On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
> > >
> > > On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > [...]
> > > >
> > > > It was mostly an honest question, I too am trying to understand what userspace
> > > > wants to do with this information.  I was/am also trying to understand the benefits
> > > > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > > > already has specific stats for the number of leaf pages mapped into a VM, why not
> > > > do the same for non-leaf pages?
> > >
> > > Let me answer why a more general stat is useful and the potential
> > > userspace reaction:
> > >
> > > For a memory type which is significant enough, it is useful to expose
> > > it in the general interfaces, so that the general data/stat collection
> > > infra can collect them instead of having workload dependent stat
> > > collectors. In addition, not necessarily that stat has to have a
> > > userspace reaction in an online fashion. We do collect stats for
> > > offline analysis which greatly influence the priority order of
> > > optimization workitems.
> > >
> > > Next the question is do we really need a separate stat item
> > > (secondary_pagetable instead of just plain pagetable) exposed in the
> > > stable API? To me secondary_pagetable is general (not kvm specific)
> > > enough and can be significant, so having a separate dedicated stat
> > > should be ok. Though I am ok with lump it with pagetable stat for now
> > > but we do want it to be accounted somewhere.
> >
> > Any thoughts on this? Johannes?
>
> I agree that this memory should show up in vmstat/memory.stat in some
> form or another.
>
> The arguments on whether this should be part of NR_PAGETABLE or a
> separate entry seem a bit vague to me. I was hoping somebody more
> familiar with KVM could provide a better picture of memory consumption
> in that area.
>
> Sean had mentioned that these allocations already get tracked through
> GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
> track, they should be represented in memory.stat in some form. Sean
> also pointed out though that those allocations tend to scale rather
> differently than the page tables, so it probably makes sense to keep
> those two things separate at least.
>
> Any thoughts on putting shadow page tables and iommu page tables into
> the existing NR_PAGETABLE item? If not, what are the cons?
>
> And creating (maybe later) a separate NR_VIRT for the other
> GPF_KERNEL_ACCOUNT allocations in kvm?

I agree with Sean that a NR_VIRT stat would be inaccurate by omission,
unless we account for all KVM allocations under this stat. This might
be an unnecessary burden according to what Sean said, as most other
allocations scale linearly with the number of vCPUs or the memory
assigned to the VM.

I don't have enough context to say whether we should piggyback KVM MMU
pages to the existing NR_PAGETABLE item, but from a high level it
seems like it would be more helpful if they are a separate stat.
Anyway, I am willing to go with whatever Sean thinks is best.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
