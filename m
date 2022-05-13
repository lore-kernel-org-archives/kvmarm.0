Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEFCC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:08:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 722C24B1BD;
	Sat, 14 May 2022 06:08:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@cmpxchg-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i8S8qrKALlOz; Sat, 14 May 2022 06:08:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4936C4B1C6;
	Sat, 14 May 2022 06:08:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 937B840AEA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 11:50:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jyqRBKwg3nMu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 11:50:20 -0400 (EDT)
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com
 [209.85.219.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2FB5401D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 11:50:19 -0400 (EDT)
Received: by mail-qv1-f45.google.com with SMTP id eq14so6958407qvb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 08:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Kye4TfWEBKeNkvsN1Z8PpM0cIuVevPyfJP2pQ+b2OJ0=;
 b=ZZ/JJCRDz3yE4ILSty048bcbPErmsDUK3HlgCxPZevGvO0s7lKzzyxYdFDw1dJf9ph
 MIp+dwz/aXhjTfmLJaPj/lFR5KENnPsRIaVfRdKCuXnMx6qMaG0uPs9glvL+IiheyQV+
 I8N0k1bffzWgc5Xm+tBeTXdy8CbQJfgCaMsHgTm1sfLVt/+VGnsbnrEpzH2RKA967Lgp
 i0c6ZYtdpmtmfZZuTg2GnWU+ABJlGS07aIDJN1CLeOQkEF/JyGUWyE+RbOazEYEr/CaR
 3SpCLEHRQ4pi9gjxDfMWcHE6xNgzt5GERI+gy2A1oDXWEszhLZUV5HDLMnSPDj/P5+Pq
 xL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Kye4TfWEBKeNkvsN1Z8PpM0cIuVevPyfJP2pQ+b2OJ0=;
 b=L5gAgvTHvvWCoxhaRkeIovfBA4x1Q8BcG5+X7l/xU+UEkp8f3xnpG6eTjzJ2K71WWZ
 bXgqZY7pzUjFtQOuEvFCMJmd8FrkgINemZFKD7fwZJz5kKRAZVhMvZIaYWIyoDeMQBsM
 YPg3dme3gP2G6mnXhSEXwdR6pgXijYLOQhtnU2GR/zVlpPGz9PkF3RUuZU4iUzO/V0Yw
 O0nv0fkDcq7bmd48pOe8a0OUI9ND7SiSUe35dTW7LiOwJ+Nq/uCCC3732gmnApiGGC9w
 wuFN4/lcwZFVMl8BPmlvNKR1gkkRF0Zi62dtDWaxSFYOm1rB9a5F630rJvLhajzZrSIy
 tenA==
X-Gm-Message-State: AOAM531w/POITKEjs/nnBDcmzk2jDYC4z71o6jhlkTVnfiA3qtLiUGtw
 FJPbE/6uUiLQDVJkpv4kV7tWcw==
X-Google-Smtp-Source: ABdhPJyktZGo/sFqunY+AGQMbzOIwUczaPGJ0N+6rs6ilDbZkXUx75C2yJo+GV2MPE1GxzwaNcDQ8A==
X-Received: by 2002:a05:6214:401a:b0:459:5a57:ba6f with SMTP id
 kd26-20020a056214401a00b004595a57ba6fmr4923590qvb.96.1652457019420; 
 Fri, 13 May 2022 08:50:19 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:14fe])
 by smtp.gmail.com with ESMTPSA id
 f6-20020a05622a114600b002f39b99f69esm1622685qty.56.2022.05.13.08.50.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 13 May 2022 08:50:18 -0700 (PDT)
Date: Fri, 13 May 2022 11:50:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Yn5+OtZSSUZZgTQj@cmpxchg.org>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yn2YYl98Vhh/UL0w@google.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
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

On Thu, May 12, 2022 at 11:29:38PM +0000, Sean Christopherson wrote:
> On Thu, May 12, 2022, Johannes Weiner wrote:
> > On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > What do you plan to do for IOMMU page tables? After all, they serve
> > > > the exact same purpose, and I'd expect these to be handled the same
> > > > way (i.e. why is this KVM specific?).
> > > 
> > > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > > account other types of secondary page tables to this stat. It is just
> > > that we are currently interested in the KVM MMU usage.
> > 
> > Do you actually care at the supervisor level that this memory is used
> > for guest page tables?
> 
> Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
> for page tables, but except for page tables, the number/size of those allocations
> scales linearly with either the number of vCPUs or the amount of memory assigned
> to the VM (with no room for improvement barring KVM changes).
> 
> Off the top of my head, KVM's secondary page tables are the only allocations that
> don't scale linearly, especially when nested virtualization is in use.

Thanks, that's useful information.

Are these other allocations accounted somewhere? If not, are they
potential containment holes that will need fixing eventually?

> > It seems to me you primarily care that it is reported *somewhere*
> > (hence the piggybacking off of NR_PAGETABLE at first). And whether
> > it's page tables or iommu tables or whatever else allocated for the
> > purpose of virtualization, it doesn't make much of a difference to the
> > host/cgroup that is tracking it, right?
> > 
> > (The proximity to nr_pagetable could also be confusing. A high page
> > table count can be a hint to userspace to enable THP. It seems
> > actionable in a different way than a high number of kvm page tables or
> > iommu page tables.)
> 
> I don't know about iommu page tables, but on the KVM side a high count can also
> be a good signal that enabling THP would be beneficial.

Well, maybe.

It might help, but ultimately it's the process that's in control in
all cases: it's unmovable kernel memory allocated to manage virtual
address space inside the task.

So I'm still a bit at a loss whether these things should all be lumped
in together or kept separately. meminfo and memory.stat are permanent
ABI, so we should try to establish in advance whether the new itme is
really a first-class consumer or part of something bigger.

The patch initially piggybacked on NR_PAGETABLE. I found an email of
you asking why it couldn't be a separate item, but it didn't provide a
reasoning for that decision. Could you share your thoughts on that?

Thanks
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
