Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4759C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 26 May 2022 00:39:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EEAB4B2F3;
	Wed, 25 May 2022 20:39:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wqkpvBgNGcQj; Wed, 25 May 2022 20:39:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 323364B2A7;
	Wed, 25 May 2022 20:39:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D90C4B210
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 20:38:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wpaN3zbItIu7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 20:38:58 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EB354B20F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 20:38:58 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id y1so395269pfr.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 17:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=7P8MdhBUHeNYERj02eaiVlo3+1akuXNgpyLjujYYpb0=;
 b=nGnImQMrxcKuAMPfn2cnaf9VK34koPZI6BdWd8L/dvJkOmKEczFMWc8Yx7hsQFZeVL
 9KLxd0tBqQk1/z15iyaTJQGyj+rpJcqO/oigF6/cI0x8g+X/Xo/VBfVgAonu8k6z7tAw
 rX3SONGBqur0M8KowUWh/wmc3aYT+yOgmGgvthbF1GbnQhkOPFYSCTfv0l7sg5kj2jls
 D/lYOdddeRohuY3mRJGYNVA5mDFRmRi5K+xU9HMyUH4O1+TPylZTZEwi6U0ynqv/r7ZQ
 PEcsEwLY3XMn7/TlPZPqXhp0uzspbOfW5miRUT3ck3ZbCGUmofEeJzc2ijyz7b5LJr0L
 9x9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7P8MdhBUHeNYERj02eaiVlo3+1akuXNgpyLjujYYpb0=;
 b=G5OTwozVMV/gH0v9JmmXJtEOyWpitRr5Rdp2sNYUTxevapXntuDtWbVVSU/uA8L1z9
 DU1rHWwBvnuzA5SewiH5iwSo4NiojvoLPGmI1eawdSD1DHZdnQOJ+ESXCQLIRjAlXO9/
 MIpVKt5swVXLAfsyaoN61cF/WYYLrMLJmyJtSWt4q3UHgoL3TOkbaS3LU5xaFPftScOP
 cCq2a5NeNF9plE9cuyvIOJjKCiin/MDEozvD5Fet2RJFmvWHSPCfE7J0X4CjOtcX1Jw5
 WedGu8x2jv9dsDbQaRfwT2fzxIRbC5euNkrgY003Kwno9zg8ZCL0hrdw7gWZnUHgV6OS
 R7TA==
X-Gm-Message-State: AOAM533UbcYWD7uOfb2yvb9tmjf9gM1pe4ySqr+tl8ahley97ELVcm82
 qu2XQcST2IjDKgUKMPKhBWIWMw==
X-Google-Smtp-Source: ABdhPJxQ2PEcWk8DK3E2AzHueuX2Pq6jI8vVF9DbxayvJeVzlRCPUepbJ8f3PDiOx87ktlbbZyxBrw==
X-Received: by 2002:a62:1413:0:b0:518:4259:200e with SMTP id
 19-20020a621413000000b005184259200emr34153334pfu.41.1653525537153; 
 Wed, 25 May 2022 17:38:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 bh8-20020a056a02020800b003f5cc9c31e2sm141353pgb.38.2022.05.25.17.38.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 May 2022 17:38:56 -0700 (PDT)
Date: Thu, 26 May 2022 00:38:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Yo7MHA2aUaprvgl8@google.com>
References: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org> <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
 <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Yosry Ahmed <yosryahmed@google.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
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

On Wed, May 25, 2022, Johannes Weiner wrote:
> On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> > I don't have enough context to say whether we should piggyback KVM MMU
> > pages to the existing NR_PAGETABLE item, but from a high level it
> > seems like it would be more helpful if they are a separate stat.
> > Anyway, I am willing to go with whatever Sean thinks is best.
> 
> Somebody should work this out and put it into a changelog. It's
> permanent ABI.

After a lot of waffling, my vote is to add a dedicated NR_SECONDARY_PAGETABLE.

It's somewhat redundant from a KVM perspective, as NR_SECONDARY_PAGETABLE will
scale with KVM's per-VM pages_{4k,2m,1g} stats unless the guest is doing something
bizarre, e.g. accessing only 4kb chunks of 2mb pages so that KVM is forced to
allocate a large number of page tables even though the guest isn't accessing that
much memory.

But, someone would need to either understand how KVM works to make that connection,
or know (or be told) to go look at KVM's stats if they're running VMs to better
decipher the stats.

And even in the little bit of time I played with this, I found having
nr_page_table_pages side-by-side with nr_secondary_page_table_pages to be very
informative.  E.g. when backing a VM with THP versus HugeTLB,
nr_secondary_page_table_pages is roughly the same, but nr_page_table_pages is an
order of a magnitude higher with THP.  I'm guessing the THP behavior is due to
something triggering DoubleMap, but now I want to find out why that's happening.

So while I'm pretty sure a clever user could glean the same info by cross-referencing
NR_PAGETABLE stats with KVM stats, I think having NR_SECONDARY_PAGETABLE will at the
very least prove to be helpful for understanding tradeoffs between VM backing types,
and likely even steer folks towards potential optimizations.

Baseline:
  # grep page_table /proc/vmstat 
  nr_page_table_pages 2830
  nr_secondary_page_table_pages 0

THP:
  # grep page_table /proc/vmstat 
  nr_page_table_pages 7584
  nr_secondary_page_table_pages 140

HugeTLB:
  # grep page_table /proc/vmstat
  nr_page_table_pages 3153
  nr_secondary_page_table_pages 153

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
