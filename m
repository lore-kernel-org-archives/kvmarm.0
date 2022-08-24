Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F95C32796
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 17:26:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDCA24D2C8;
	Wed, 24 Aug 2022 13:26:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h5YfN2dH6ZMm; Wed, 24 Aug 2022 13:26:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C62974D301;
	Wed, 24 Aug 2022 13:26:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C99014D2F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 13:26:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ixB5tEaX5znn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2022 13:26:21 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6C754D2C8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 13:26:21 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id d16so16325594wrr.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 10:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=PyL5R0h/l4gJt239ptqG1oF6MWjvvRhnBKs2TUqoy18=;
 b=jQo8Hnb2GH3hf1ONG3xswu3V43RapwZZQv/uLqocxPR835oyqTUFMASIxiUoHL6XPp
 EbyicGfCO/sXpp4HRUcZkK6eb5S/FJk3LCRWifleT2kwRNWUQdb3Pycb7gz+LLxmY/R5
 cAwAKSjcgIGBXG8vtmnslPBHLQtM2g3cCibWehD2SbdsVHqGT2G9+BKT5dnCmoA5yLS/
 NVGYZip8bdVm+/+hyVO7QlJ3mzWEUYz9x/mwMcK90WZe3i29zVqh6PZXN9gfUwGFhwoX
 BqhSoPB12QVEr5eJwWyR6ofuIoW/nLes2Q//tqKQFwWjS9S5Pc7b3jtbxpG9zRwoyvst
 uW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=PyL5R0h/l4gJt239ptqG1oF6MWjvvRhnBKs2TUqoy18=;
 b=7xYJk822/2r/gelNmp62sX87KanlrYTodHRU6HrN3udckpspTjn8pGfiff0hLyrqvC
 w8w43c7qtDaorx5+YrxnGA5xFS6V/6Xdnj6SDqIiHE338X3tZ7+2VnDmyGnGYyLRXa8K
 6NfvmwrWM2w82I5qIh2eQB84H8lveSjH1BQ+UYi1ffWkFabeeozC1UtekOpuxaW8oekP
 S6DEk/FMU7QoDouTND004oSGc4Tl5oJ91yYvwFKBAFG6YIt6zt1THt8iTrvqqlXiffHv
 8IlkRjfjektPTWIUcIVBx1VL9z2VwKVsAH040c3k20XvMqNbAT48XHqWtoRsu1ug9GOx
 lQPg==
X-Gm-Message-State: ACgBeo2bpGb2AFE7fpt1b/BeFt0e0r7A46kzRsycnfUsJaGOpR1RQPrK
 9QfZhKC5+JtDffKRoQyhhFKKXLkXvy5t88drwTe6BQ==
X-Google-Smtp-Source: AA6agR7iXw73BTfjDZ8jZn+Fm8FhmEI+9YASQfOV4iSJ8ZIWQgBMY6R5SVjUTupDZtCPK8fsP9gfgnCHrt3adgZF1rc=
X-Received: by 2002:adf:9ccf:0:b0:225:4934:53e3 with SMTP id
 h15-20020adf9ccf000000b00225493453e3mr158800wre.210.1661361980453; Wed, 24
 Aug 2022 10:26:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-2-yosryahmed@google.com>
 <5ac13c91-0e42-533b-42d0-c78573c7aef3@arm.com>
In-Reply-To: <5ac13c91-0e42-533b-42d0-c78573c7aef3@arm.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 24 Aug 2022 10:25:43 -0700
Message-ID: <CAJD7tkbn7mFvf0oiUKPZtu92GtuMht-s5iPBRfEuUfTxXC_j8Q@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 nd@arm.com, Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Andrew Morton <akpm@linux-foundation.org>,
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

On Wed, Aug 24, 2022 at 6:42 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
>
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index e7aafc82be99..898c99eae8e4 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -982,6 +982,7 @@ Example output. You may not have all of these fields.
> >       SUnreclaim:       142336 kB
> >       KernelStack:       11168 kB
> >       PageTables:        20540 kB
> > +    SecPageTables:         0 kB
> >       NFS_Unstable:          0 kB
> >       Bounce:                0 kB
> >       WritebackTmp:          0 kB
> > @@ -1090,6 +1091,9 @@ KernelStack
> >                 Memory consumed by the kernel stacks of all tasks
> >   PageTables
> >                 Memory consumed by userspace page tables
> > +SecPageTables
> > +              Memory consumed by secondary page tables, this currently
> > +              currently includes KVM mmu allocations on x86 and arm64.
>
> nit: I think you have a typo here: "currently currently".

Sorry I missed this, thanks for catching it. The below diff fixes it
(let me know if I need to send v8 for this, hopefully not).

diff --git a/Documentation/filesystems/proc.rst
b/Documentation/filesystems/proc.rst
index 898c99eae8e4..0b3778ec12e1 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1093,7 +1093,7 @@ PageTables
               Memory consumed by userspace page tables
 SecPageTables
               Memory consumed by secondary page tables, this currently
-              currently includes KVM mmu allocations on x86 and arm64.
+              includes KVM mmu allocations on x86 and arm64.
 NFS_Unstable
               Always zero. Previous counted pages which had been written to
               the server, but has not been committed to stable storage.

>
> Thanks,
> Ryan
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
