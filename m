Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56754C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:08:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 987C54B226;
	Sat, 14 May 2022 06:08:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@cmpxchg-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h2JvyHQ1azcE; Sat, 14 May 2022 06:08:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E314B1BA;
	Sat, 14 May 2022 06:08:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCDCD49EFB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 19:07:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X-2XtNHqiwgt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2022 19:07:06 -0400 (EDT)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 365EF49EF6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 19:07:06 -0400 (EDT)
Received: by mail-qk1-f172.google.com with SMTP id v11so5939392qkf.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2022 16:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=cUck+cVE4Zxuay2oogDnSAcnKGvRjnTdnpV0Wo1py44=;
 b=Dj1JULLJRgmUJGyzT66YmWR2bXmVOPWjKovt19K15mjhXg3HwFYBwEJuzTGwKaAq9s
 UlYZ0/IUYcAg2aRR26LgYG0/HAiOUXbRTrjNR+Wc4SxPVT5MXbauCdL2/WDBI7QN0Gh0
 c2v6RoCDtzZcEzCwRaxfIkuXKgKFQmfp7WteHFGn9yxB7UXbRpwFXrmu9mN6KLIniXYn
 E6Ng4kcGK1aHvRPzZUSVA18lIbBd/twXGFM4i7KmkNJcxCIrUG0eta5gQ+Zhk4sMsbTs
 bfvIMBQOMEqF/RWs5LYTgoZiIZ4OfdOx64M8r+ZkVp/WNmWSvYEJZ9cPVzcTwYawUn43
 j07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cUck+cVE4Zxuay2oogDnSAcnKGvRjnTdnpV0Wo1py44=;
 b=qDrzAwEQ/OBT7+7MqUk+cfH6GOdrKPVG24UaXEezBBgsiPOetvdAnbIDd0Jwg2f89U
 9G+1LuvH8P3pFfUxxU0TSN/YqtvUc8pCqqxx39WfWFr1FMxh8Rp9Y/VcPfhrec/zum+J
 Cw0WNOE/CIC3MZRYWHwShlHvdaUgh1vKC+Gq5c3vqMVy529TMmXK3ImJZr6om/0bPjYP
 mRct97yPvC9WFLccrX/5rzJ/G5aI0CKdUM7jLtRKhmsXwaD3490XPCg4KiNbGIC+x5iZ
 /2WseYCsWWwfzMByypTFu3BxC+yG209vXSlqdJAfdMHOIq4zgfL3GST9/YIvK0x3zfyV
 +yyQ==
X-Gm-Message-State: AOAM531Q9uOVjOb12YGScxzxvEDUDdh9u9zTsHL3k7e6rLXJcwwMxwMx
 FFiH4Y6FmLJb1LaqW646Te8J/w==
X-Google-Smtp-Source: ABdhPJzPe/f2XnvNR7HBy1hfb2wAJ55PWzG5ke4OAfKWdYulxV6DryUEgezu1lF0L4l4p+1B2aoJOQ==
X-Received: by 2002:a05:620a:4553:b0:6a0:5280:defd with SMTP id
 u19-20020a05620a455300b006a05280defdmr1763977qkp.165.1652396825764; 
 Thu, 12 May 2022 16:07:05 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:14fe])
 by smtp.gmail.com with ESMTPSA id
 w13-20020ac86b0d000000b002f39b99f677sm545833qts.17.2022.05.12.16.07.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 12 May 2022 16:07:05 -0700 (PDT)
Date: Thu, 12 May 2022 19:07:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
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

Hey Yosry,

On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > 115bae923ac8bb29ee635). You are saying that this is related to a
> > 'workload', but given that the accounting is global, I fail to see how
> > you can attribute these allocations on a particular VM.
> 
> The main motivation is having the memcg stats, which give attribution
> to workloads. If you think it's more appropriate, we can add it as a
> memcg-only stat, like MEMCG_VMALLOC (see 4e5aa1f4c2b4 ("memcg: add
> per-memcg vmalloc stat")). The only reason I made this as a global
> stat too is to be consistent with NR_PAGETABLE.

Please no memcg-specific stats if a regular vmstat item is possible
and useful at the system level as well, like in this case. It's extra
memcg code, extra callbacks, and it doesn't have NUMA node awareness.

> > What do you plan to do for IOMMU page tables? After all, they serve
> > the exact same purpose, and I'd expect these to be handled the same
> > way (i.e. why is this KVM specific?).
> 
> The reason this was named NR_SECONDARY_PAGTABLE instead of
> NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> account other types of secondary page tables to this stat. It is just
> that we are currently interested in the KVM MMU usage.

Do you actually care at the supervisor level that this memory is used
for guest page tables?

It seems to me you primarily care that it is reported *somewhere*
(hence the piggybacking off of NR_PAGETABLE at first). And whether
it's page tables or iommu tables or whatever else allocated for the
purpose of virtualization, it doesn't make much of a difference to the
host/cgroup that is tracking it, right?

(The proximity to nr_pagetable could also be confusing. A high page
table count can be a hint to userspace to enable THP. It seems
actionable in a different way than a high number of kvm page tables or
iommu page tables.)

How about NR_VIRT? It's shorter, seems descriptive enough, less room
for confusion, and is more easily extensible in the future.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
