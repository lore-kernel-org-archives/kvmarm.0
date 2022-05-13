Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0446EC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:08:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89BFC4B1CB;
	Sat, 14 May 2022 06:08:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gFgXevwUBJi5; Sat, 14 May 2022 06:08:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 663FB4B1D2;
	Sat, 14 May 2022 06:08:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EBE349F3C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 12:23:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oAOs1izpg7Ub for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 12:23:34 -0400 (EDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47F5F49F21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 12:23:34 -0400 (EDT)
Received: by mail-wm1-f48.google.com with SMTP id
 m2-20020a1ca302000000b003943bc63f98so5017756wme.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 09:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=P05jhA0WcF/hZv6hPGGv+IwSy9Etnh2buB8vtD3ctaw=;
 b=NbGqMSBPXMT8N2S9Mb/Dsg5lSZ+Q1JehG0g27ajHeCVpig2+23Km9JoVFr/ImPYFoO
 wJmh2nXKIDIII/vXFSfau8UNbJ5DJy18o9CrYBc7a9/NtK/YuUaf3AolOoaNxUrDOM7q
 Q6bqIo+8/dE7bkyPlhCmEkjd6AnOrD2OhH0pNxkmwIETys/pp9IK8GjEeaFuFYivzvmD
 gdTf3d0+GG/ftL3jXg8rtu2aDumAzRDQYSjyUvkD+w5EoHcKd9GNvo5O8R6/JDd1Mi60
 2jyTWDR3yNwOUThXmrpBuS7lvNeRMKW2aCC5EP/QH/EPpkCTf5DhQlw8Sa6acajQ+nyC
 /GXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=P05jhA0WcF/hZv6hPGGv+IwSy9Etnh2buB8vtD3ctaw=;
 b=K2rk2rd/8DfNH04AYgQG1Gkf/bs6T+Fyr8iE2g37NlN2J7gwGqzADlfFsl2I1kXIPk
 hdDdJ1GEZEdVQXlmQzS1xEdLFvght45BhErvkUScy+tocX5jcGhUCNEvfPTGQridHXho
 B9SAlX24cweNy/fxdY/YK/gzNXPJBvYF/DvcaTmVGyuNdiiwNHh8NtgL/FgfyYwopR6I
 W2UpinhMu10kOsB0JTD8PEXyiNPBvGcZLy6fGqpGcUzszSTBksyADalbNWiluSOArIjw
 KoN/Gm9T57c6HbL8OMnme35+bU2UUNnvfWUmUSTuaHG+xxHIMRGzxSOl3hQUpZ+SJ980
 cYfg==
X-Gm-Message-State: AOAM530CipZP4JiqZ7/n2zm2OjfrsWGtNT1FepWcRVKUr7j2Qq9rtjmF
 JsnhO7aOW1VBo3mVFO/qyrsYLpMHbhgIh+sRlzwP4Q==
X-Google-Smtp-Source: ABdhPJwMQHR1rV6RBNYyN9NXTYzZlmwu+UcKsnVAZ7vLR8pJMUCcm4gmI2KWG3egFgrVcfmqBhhxtSll0QHpKEJ76pM=
X-Received: by 2002:a05:600c:3490:b0:394:5616:ac78 with SMTP id
 a16-20020a05600c349000b003945616ac78mr5401973wmq.80.1652459013025; Fri, 13
 May 2022 09:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
In-Reply-To: <Yn6DeEGLyR4Q0cDp@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Fri, 13 May 2022 09:22:56 -0700
Message-ID: <CAJD7tkZ-pLKu=pY54DoUP7cX_Yn=XgTCpfFK+w+81D9WgbWRsA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
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

Thanks everyone for participating in this discussion and looking into this.

On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, May 13, 2022, Johannes Weiner wrote:
> > On Thu, May 12, 2022 at 11:29:38PM +0000, Sean Christopherson wrote:
> > > On Thu, May 12, 2022, Johannes Weiner wrote:
> > > > On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > > > > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > > > What do you plan to do for IOMMU page tables? After all, they serve
> > > > > > the exact same purpose, and I'd expect these to be handled the same
> > > > > > way (i.e. why is this KVM specific?).
> > > > >
> > > > > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > > > > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > > > > account other types of secondary page tables to this stat. It is just
> > > > > that we are currently interested in the KVM MMU usage.
> > > >
> > > > Do you actually care at the supervisor level that this memory is used
> > > > for guest page tables?
> > >
> > > Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
> > > for page tables, but except for page tables, the number/size of those allocations
> > > scales linearly with either the number of vCPUs or the amount of memory assigned
> > > to the VM (with no room for improvement barring KVM changes).
> > >
> > > Off the top of my head, KVM's secondary page tables are the only allocations that
> > > don't scale linearly, especially when nested virtualization is in use.
> >
> > Thanks, that's useful information.
> >
> > Are these other allocations accounted somewhere? If not, are they
> > potential containment holes that will need fixing eventually?
>
> All allocations that are tied to specific VM/vCPU are tagged GFP_KERNEL_ACCOUNT,
> so we should be good on that front.
>
> > > > It seems to me you primarily care that it is reported *somewhere*
> > > > (hence the piggybacking off of NR_PAGETABLE at first). And whether
> > > > it's page tables or iommu tables or whatever else allocated for the
> > > > purpose of virtualization, it doesn't make much of a difference to the
> > > > host/cgroup that is tracking it, right?
> > > >
> > > > (The proximity to nr_pagetable could also be confusing. A high page
> > > > table count can be a hint to userspace to enable THP. It seems
> > > > actionable in a different way than a high number of kvm page tables or
> > > > iommu page tables.)
> > >
> > > I don't know about iommu page tables, but on the KVM side a high count can also
> > > be a good signal that enabling THP would be beneficial.
> >
> > Well, maybe.
> >
> > It might help, but ultimately it's the process that's in control in
> > all cases: it's unmovable kernel memory allocated to manage virtual
> > address space inside the task.
> >
> > So I'm still a bit at a loss whether these things should all be lumped
> > in together or kept separately. meminfo and memory.stat are permanent
> > ABI, so we should try to establish in advance whether the new itme is
> > really a first-class consumer or part of something bigger.
> >
> > The patch initially piggybacked on NR_PAGETABLE. I found an email of
> > you asking why it couldn't be a separate item, but it didn't provide a
> > reasoning for that decision. Could you share your thoughts on that?
>
> It was mostly an honest question, I too am trying to understand what userspace
> wants to do with this information.  I was/am also trying to understand the benefits
> of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> already has specific stats for the number of leaf pages mapped into a VM, why not
> do the same for non-leaf pages?

Let me cast some light on this. The reason this started being
piggybacked on NR_PAGETABLE is that we had a remnant of an old
internal implementation of NR_PAGETABLE before it was introduced
upstream, that accounted KVM secondary page tables as normal page
tables. This made me think this behavior was preferable. Personally, I
wanted to make it a separate thing since the beginning. When I found
opinions here that also suggested a separate stat I went ahead for
that.

As for where to put this information, it does not have to be
NR_SECONDARY_PAGETABLE. Ultimately, people working on KVM are the ones
that will interpret and act upon this data, so if you have somewhere
else in mind please let me know, Sean.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
