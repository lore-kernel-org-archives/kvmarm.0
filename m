Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A1ECCA47E
	for <kvmarm@archiver.kernel.org>; Sat,  4 Jun 2022 08:02:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BEE54B2BD;
	Sat,  4 Jun 2022 04:02:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@cmpxchg-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id onoRMVAlKRC1; Sat,  4 Jun 2022 04:02:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7484B2F9;
	Sat,  4 Jun 2022 04:02:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 043894B2CA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2022 12:42:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CVuoOq7NDC1D for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2022 12:42:18 -0400 (EDT)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
 [209.85.222.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BAA14B2B3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2022 12:42:18 -0400 (EDT)
Received: by mail-qk1-f170.google.com with SMTP id k6so3342200qkf.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jun 2022 09:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=pZiq+DaP0uIJbqmhpHEQocGuha+dXUbZZZqTwIB2IaE=;
 b=rrQxT3vbT7GMAWiBE8NKh82hTKWmXoBOIgjSoB8gWHlxJCtpicQfJi6YHcKEu0Skmg
 abttTcfRqmTOcz4L3ohQC6WWhlA31fuHxoEfeuJpbUAg7kX6/vtplGcJ9j4IrzJVxD9O
 vdLoYfObodGls9T269h7hJyDm997n4snH1eyk5q8lGm0DuwzVfKoDQFEQSeKxajjX2Yz
 5TiL9zM/J27+HT1KqOA1cB9necDYn5jb3A6o3ARG7LxeA2ES2j5uBkLAZdLyHaiO4lvt
 ER/oF7LY8Hxyq/pFtt8IclZxYPm5bLZuRep0Ojk6gIJnuU/og9qHiw7H4aRy54/0OtvI
 pIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pZiq+DaP0uIJbqmhpHEQocGuha+dXUbZZZqTwIB2IaE=;
 b=sALQKvdtSwXf5kpF3O0AB5H1nXJI2Jk+FMn8eDV5lr84SK1Ie7IsRW+cFBKeINnTqa
 C99QyB8YAq1GyGlsR0Z+gQOZsoB6lkj/ZCG9HraPeNuRCy3+8HrXZcs+UUTXCE8ZH2EF
 204KEuCZJQlcFwc5UEjRmWGrcimoghug1HXhyxEeJc6aXSp/d7Pt8uSQLnTGXnp2ZLxx
 qEsPAc3fzJeAE5uVFNAeex/FWaMaDS7TBxZddaut5wjLAYyOiRrjJjRTN/TW7AX3l47i
 q3P/k4v2zwCnfslsdrPWV/3t2x+jZ2W+LkEAFw4xqVWT9f8yOTotzkf9sgHd1FDqGTtX
 zu6A==
X-Gm-Message-State: AOAM530KbdK2N9y6SAOaJPocOlCrvMibv1wjsAYAo6eV+9/MsT7xzDah
 Asy1Dvg+lsvUjrz/pE4g9cD91g==
X-Google-Smtp-Source: ABdhPJwD1IT8PgvyiFpaFJ0oQgGHCzkg9tknn5j7X5fVKzbiMKtPXk1vgrTU2p+vhNcLbOMRztlAVw==
X-Received: by 2002:a05:620a:2845:b0:6a3:646f:9ba8 with SMTP id
 h5-20020a05620a284500b006a3646f9ba8mr7509475qkp.56.1654274537770; 
 Fri, 03 Jun 2022 09:42:17 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:1d66])
 by smtp.gmail.com with ESMTPSA id
 w184-20020a3794c1000000b006a098381abcsm5550650qkd.114.2022.06.03.09.42.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 03 Jun 2022 09:42:17 -0700 (PDT)
Date: Fri, 3 Jun 2022 12:42:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Ypo550pGxmnJnGBe@cmpxchg.org>
References: <Yn2YYl98Vhh/UL0w@google.com> <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
 <Yo4Ze+DZrLqn0PeU@cmpxchg.org> <Yo7MHA2aUaprvgl8@google.com>
 <CAJD7tkYoz=rYvBV3tcp4aLgiyEtr-sBwbncFduZsOq+c8wk5sA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJD7tkYoz=rYvBV3tcp4aLgiyEtr-sBwbncFduZsOq+c8wk5sA@mail.gmail.com>
X-Mailman-Approved-At: Sat, 04 Jun 2022 04:02:12 -0400
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

On Fri, May 27, 2022 at 11:33:27AM -0700, Yosry Ahmed wrote:
> On Wed, May 25, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, May 25, 2022, Johannes Weiner wrote:
> > > On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> > > > I don't have enough context to say whether we should piggyback KVM MMU
> > > > pages to the existing NR_PAGETABLE item, but from a high level it
> > > > seems like it would be more helpful if they are a separate stat.
> > > > Anyway, I am willing to go with whatever Sean thinks is best.
> > >
> > > Somebody should work this out and put it into a changelog. It's
> > > permanent ABI.
> >
> > After a lot of waffling, my vote is to add a dedicated NR_SECONDARY_PAGETABLE.
> >
> > It's somewhat redundant from a KVM perspective, as NR_SECONDARY_PAGETABLE will
> > scale with KVM's per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> > bizarre, e.g. accessing only 4kb chunks of 2mb pages so that KVM is forced to
> > allocate a large number of page tables even though the guest isn't accessing that
> > much memory.
> >
> > But, someone would need to either understand how KVM works to make that connection,
> > or know (or be told) to go look at KVM's stats if they're running VMs to better
> > decipher the stats.
> >
> > And even in the little bit of time I played with this, I found having
> > nr_page_table_pages side-by-side with nr_secondary_page_table_pages to be very
> > informative.  E.g. when backing a VM with THP versus HugeTLB,
> > nr_secondary_page_table_pages is roughly the same, but nr_page_table_pages is an
> > order of a magnitude higher with THP.  I'm guessing the THP behavior is due to
> > something triggering DoubleMap, but now I want to find out why that's happening.
> >
> > So while I'm pretty sure a clever user could glean the same info by cross-referencing
> > NR_PAGETABLE stats with KVM stats, I think having NR_SECONDARY_PAGETABLE will at the
> > very least prove to be helpful for understanding tradeoffs between VM backing types,
> > and likely even steer folks towards potential optimizations.
> >
> > Baseline:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 2830
> >   nr_secondary_page_table_pages 0
> >
> > THP:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 7584
> >   nr_secondary_page_table_pages 140
> >
> > HugeTLB:
> >   # grep page_table /proc/vmstat
> >   nr_page_table_pages 3153
> >   nr_secondary_page_table_pages 153
> >
> 
> Interesting findings! Thanks for taking the time to look into this, Sean!
> I will refresh this patchset and summarize the discussion in the
> commit message, and also fix some nits on the KVM side. Does this
> sound good to everyone?

Yes, thanks for summarizing this. Sounds good to me!

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
