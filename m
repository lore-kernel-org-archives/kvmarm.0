Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168ADC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 23 May 2022 06:30:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 611E04B08F;
	Mon, 23 May 2022 02:30:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@cmpxchg-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WZckPbAEd-9e; Mon, 23 May 2022 02:30:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D170649F49;
	Mon, 23 May 2022 02:30:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C4614B246
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 10:39:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AB4CS8UKCspF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 10:39:42 -0400 (EDT)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CB724B1FB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 10:39:42 -0400 (EDT)
Received: by mail-qv1-f50.google.com with SMTP id v5so6780063qvs.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 07:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=TTmi/1xkgT1AjVxJzskAr+COf/0zmPlsvxgfjW6STHE=;
 b=Gxvhl+k8BBXk02rLhNHh59M59iKaZySmrURL5ViwDbexkz4AQDcT1PrTxGRwwIA9b6
 /1f2ADWNgafFMzN43IhcFiyinqNnehHn/mS0YJbtMR6z731PyisnndoOkG4QNw19YD3d
 5k+xSboSMaMN7QvahZpDuaMGQOESeBd5F4Bx3mh8jgB1uyY3ssyoK0Xq2S2xeP72/K83
 PKpXip7h0Y+PpB3dm95FI4ngwmEccKM7+EXoqGyFtJ1eCsv33X6U8TW4FvS5JNrN09KR
 w9b5Y7kbJX4XTJASFVGfGrpW2a4CWNMPykU0xVE8Gyft/WvrlN09/Biji8rIPx+RUWjW
 tCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TTmi/1xkgT1AjVxJzskAr+COf/0zmPlsvxgfjW6STHE=;
 b=GjQL+RLPrf6bG7OuiCs+NmL9J/JtuumOvjW0uau9sD7ilYa8agIQa7PgyaiUnFBfz6
 vVnP922+FUIziPaKwVNK4X8jSH5y0ZaYJBLJ2N2CXRsfCOqqGLfE5pMxQNKIEi4kUzsp
 F9zoJuaaooOCuYgaCum88S0e8mSa+Rh/CUTskV/F9zbsS/SHbf7REURLKJRzBV+Pexaq
 Lvpd9NmJ57ZbqVFf7YAX2KRyS3R9/dVOqjJxdwqLd51zhwAnB5cnaQimZr56o13Scoi8
 m8scIDojRv7A1DoBz6T5h37mlcVGI/Q7bZVwsBSAFC/h2yuqrEqXiXcvj+wceP0AmMSK
 Z/Ug==
X-Gm-Message-State: AOAM533L9Zzg7DEZeKsIbTmnVEILfm/5eAZBvEjg4sd0KOAqqIENJfsw
 /eUPm5a/AwMhHwLHLtpGyAvN4Q==
X-Google-Smtp-Source: ABdhPJzkvB4GuJsVQAvtAye6NIsbWLxTJ8yuyfKdI6Dpev7Y/X++dkHVcr1QgV/boWcwi159jErlrw==
X-Received: by 2002:ad4:4208:0:b0:461:d262:7842 with SMTP id
 k8-20020ad44208000000b00461d2627842mr8117176qvp.113.1653057582042; 
 Fri, 20 May 2022 07:39:42 -0700 (PDT)
Received: from localhost (cpe-98-15-154-102.hvc.res.rr.com. [98.15.154.102])
 by smtp.gmail.com with ESMTPSA id
 196-20020a3706cd000000b0069fd12a957bsm3076730qkg.17.2022.05.20.07.39.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 20 May 2022 07:39:41 -0700 (PDT)
Date: Fri, 20 May 2022 10:39:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <YoeoLJNQTam5fJSu@cmpxchg.org>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
X-Mailman-Approved-At: Mon, 23 May 2022 02:30:55 -0400
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

On Thu, May 19, 2022 at 06:56:54PM -0700, Yosry Ahmed wrote:
> On Fri, May 13, 2022 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Fri, May 13, 2022 at 9:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > [...]
> > >
> > > It was mostly an honest question, I too am trying to understand what userspace
> > > wants to do with this information.  I was/am also trying to understand the benefits
> > > of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
> > > already has specific stats for the number of leaf pages mapped into a VM, why not
> > > do the same for non-leaf pages?
> >
> > Let me answer why a more general stat is useful and the potential
> > userspace reaction:
> >
> > For a memory type which is significant enough, it is useful to expose
> > it in the general interfaces, so that the general data/stat collection
> > infra can collect them instead of having workload dependent stat
> > collectors. In addition, not necessarily that stat has to have a
> > userspace reaction in an online fashion. We do collect stats for
> > offline analysis which greatly influence the priority order of
> > optimization workitems.
> >
> > Next the question is do we really need a separate stat item
> > (secondary_pagetable instead of just plain pagetable) exposed in the
> > stable API? To me secondary_pagetable is general (not kvm specific)
> > enough and can be significant, so having a separate dedicated stat
> > should be ok. Though I am ok with lump it with pagetable stat for now
> > but we do want it to be accounted somewhere.
> 
> Any thoughts on this? Johannes?

I agree that this memory should show up in vmstat/memory.stat in some
form or another.

The arguments on whether this should be part of NR_PAGETABLE or a
separate entry seem a bit vague to me. I was hoping somebody more
familiar with KVM could provide a better picture of memory consumption
in that area.

Sean had mentioned that these allocations already get tracked through
GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
track, they should be represented in memory.stat in some form. Sean
also pointed out though that those allocations tend to scale rather
differently than the page tables, so it probably makes sense to keep
those two things separate at least.

Any thoughts on putting shadow page tables and iommu page tables into
the existing NR_PAGETABLE item? If not, what are the cons?

And creating (maybe later) a separate NR_VIRT for the other
GPF_KERNEL_ACCOUNT allocations in kvm?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
