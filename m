Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B805C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 15:20:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 843FE408F4;
	Wed, 25 May 2022 11:20:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@cmpxchg-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gOjDIrvzAM3c; Wed, 25 May 2022 11:20:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D596401DD;
	Wed, 25 May 2022 11:20:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE52D4B092
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 07:56:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QaBq9wzx55x7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 07:56:45 -0400 (EDT)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67B4649EB4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 07:56:45 -0400 (EDT)
Received: by mail-qt1-f174.google.com with SMTP id hh4so16699543qtb.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 04:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=lEk6v60gkjFT68Gj4bJNaNs7k2gNzwxPhiEY5nNwaQQ=;
 b=XXcCcSNfXU4ZumvEofzKMhDBd7cN4uUTScIpzCQEM+hzYYKUfsKNiF4P7UVF51FKtd
 5RMh2GAnDESjADbuXOd1AqGedzaXh0w5A9T12BqTWJPxR4mUsbYzVpqI1DeLqcj+jRCv
 g4Mbz8Isqpigexjq2xgBfxvEZ6XOCfbhrEWV/D3mKfrw49MZYSOCSMLcFNY4bPWoBIIQ
 R5QYWFwAz8og1bHFYOMrTQ4s+e/PEPEozRRHKxlX3pJQbF9dxpvlI9pbg9wJj7C5geki
 qkYRTvMTxuO0dTaFgb5ZebuX4LpE/ZIxHighxOWhBpx05saqXnbfuwd4MPhQ1tJOvxUj
 hZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lEk6v60gkjFT68Gj4bJNaNs7k2gNzwxPhiEY5nNwaQQ=;
 b=O8Z38qC2dYftANL/i9e5yJniTnL+3ezAepKVWhb8by1c537kx1v+H+fz/fDt0HZneJ
 Wyx4S7PlUqawl/NNzuHuu3vST69++SzxjFwoPi7gHSVYiSLB1lSQ5wjndcDB8EEmEWDB
 dl3TmnxpzuD6bpUI2wf1yZcwKgpaAp/kjW/p0w8jDzLTVjl+i+KYArKPWfFtdT1q++se
 9f+8+Pl1ZYkq0zmHEZQotPi8iMH5tQfjoFPJhxbncpFvy/cBOljGAXd2v1qx4wS1XquM
 3LkCN628x6koyhStItV/FwZGSXYxb8j80DQqSmiqTPbCCfmZf6QOVsM8k4NW4q0PbEQm
 QyWQ==
X-Gm-Message-State: AOAM533c82Vv4tVLbKSDHq1hu87zuqKEECpS8YatvhtsqK1vSlNky2Pq
 5O27dnFxfnzlrizRJk9xz3bo7g==
X-Google-Smtp-Source: ABdhPJwFHUkIBHNUiY22IoYqV5QV59CSwCqYRuCiU7sPHckigA3yOeAfSHjhUNo+n/aWFHPqKI7LJA==
X-Received: by 2002:ac8:4e81:0:b0:2f9:34e4:8955 with SMTP id
 1-20020ac84e81000000b002f934e48955mr11600672qtp.459.1653479804938; 
 Wed, 25 May 2022 04:56:44 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:741f])
 by smtp.gmail.com with ESMTPSA id
 m25-20020ac84459000000b002f94737333bsm1152559qtn.21.2022.05.25.04.56.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 May 2022 04:56:44 -0700 (PDT)
Date: Wed, 25 May 2022 07:56:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
References: <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
X-Mailman-Approved-At: Wed, 25 May 2022 11:20:15 -0400
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

On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> On Fri, May 20, 2022 at 7:39 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > I agree that this memory should show up in vmstat/memory.stat in some
> > form or another.
> >
> > The arguments on whether this should be part of NR_PAGETABLE or a
> > separate entry seem a bit vague to me. I was hoping somebody more
> > familiar with KVM could provide a better picture of memory consumption
> > in that area.
> >
> > Sean had mentioned that these allocations already get tracked through
> > GFP_KERNEL_ACCOUNT. That's good, but if they are significant enough to
> > track, they should be represented in memory.stat in some form. Sean
> > also pointed out though that those allocations tend to scale rather
> > differently than the page tables, so it probably makes sense to keep
> > those two things separate at least.
> >
> > Any thoughts on putting shadow page tables and iommu page tables into
> > the existing NR_PAGETABLE item? If not, what are the cons?
> >
> > And creating (maybe later) a separate NR_VIRT for the other
> > GPF_KERNEL_ACCOUNT allocations in kvm?
> 
> I agree with Sean that a NR_VIRT stat would be inaccurate by omission,
> unless we account for all KVM allocations under this stat. This might
> be an unnecessary burden according to what Sean said, as most other
> allocations scale linearly with the number of vCPUs or the memory
> assigned to the VM.

I think it's fine to table the addition of NR_VIRT for now. My
conclusion from this discussion was just that if we do want to add
more KVM-related allocation sites later on, they likely would be
something separate and not share an item with the shadow tables. This
simplifies the discussion around how to present the shadow tables.

That said, stats can be incremental and still useful. memory.current
itself lies by ommission. It's more important to catch what's of
significance and allow users to narrow down pathological cases.

> I don't have enough context to say whether we should piggyback KVM MMU
> pages to the existing NR_PAGETABLE item, but from a high level it
> seems like it would be more helpful if they are a separate stat.
> Anyway, I am willing to go with whatever Sean thinks is best.

Somebody should work this out and put it into a changelog. It's
permanent ABI.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
