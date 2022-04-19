Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F64C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 18:36:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8EFA4B25F;
	Tue, 19 Apr 2022 14:36:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xVjIUjNJvqGb; Tue, 19 Apr 2022 14:36:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3424B24D;
	Tue, 19 Apr 2022 14:36:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1644B1EC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:36:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b8KIZ2oUrvIC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 14:36:41 -0400 (EDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
 [209.85.208.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 613E34B18A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:36:41 -0400 (EDT)
Received: by mail-lj1-f175.google.com with SMTP id o16so21628506ljp.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 11:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=igrepIlJhovin1ZitPt/fwfo5UFpiMUyDj9kpyJCGUE=;
 b=Z9B5FbZM8I02OP9Qkj77nY3yfcEmO1xlNXbWFQ8NlS0+aiVDthPvSdWH7VxST/i0V5
 Yfyt479QC07Kp9fubFhV4Mx6rBmGcjCtjtgQ4ZXdJU9kTXtYu1Hm8tsO0FxS3A083qOT
 yn7nYPAtNLFgmLYWPpkCsZJbK0TWcsyL62rL8cDupXnEJF2vNtkyBe1NA3FyW61aLCG+
 n+mU/tOOkT/Qse06ANMN0vsSRoqXPFKJeujuK6WhAEQwPtHqRzfLx4/kXLx9Nkz/nhZA
 nA4YbXbaxh6KC3olCzZq7amawJHZOFs5S41FMCyvcEC3qRuZgWWHbcJJGgD4n54B2C4l
 dagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=igrepIlJhovin1ZitPt/fwfo5UFpiMUyDj9kpyJCGUE=;
 b=WugBA0NayLuXG0dg2mt2D8oEFqitDetOpqZmHTt5SXF5dTt/IH90zi/fFIGjskmKQJ
 cqtiHLqaK3sQmihmxiVmFN6eOPp5v5D9fw9FXcguf19JDDC0GRwY2StYdk/UcDa5Roj9
 OJ9cXTJsSSHmiT979Apj1Mo9FD8Bo43xj3PouzoEAe+18LjxgD7n8u7CfayJ+C6FAbmv
 6MczRH53Fhq1mh4ZPKa0/csMhaH1lcin0jis3o2EKulPmKQDF8FivOdi8gpPHENA68yl
 OCp5djlphToVlFFtXKysvR2wA4C5qS7jLw3uI2xveTPmavesJ765+nUt/IcFV3j70DmH
 wLqg==
X-Gm-Message-State: AOAM531bfX4rpDmEc2hBnT+pN2xPYRZ//3aW9duZjQnt6fsbxXwzgH53
 MrnzdhweIB5Kcn/A/SyjmVnzOIBoM+9mxzfiM7E+LQ==
X-Google-Smtp-Source: ABdhPJyJ4/g7pwfK7Ecm19c7JGK2gaZy4Nc/2tlPzIbimaLm3zH663J4xaxf7hSCk7oZ9W+AfJ0gXfmbRSIibpBngRo=
X-Received: by 2002:a05:651c:1a0c:b0:24d:c538:d504 with SMTP id
 by12-20020a05651c1a0c00b0024dc538d504mr3532020ljb.479.1650393399468; Tue, 19
 Apr 2022 11:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
In-Reply-To: <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 19 Apr 2022 11:36:28 -0700
Message-ID: <CAOQ_QsieUXOFXLkZ=ya0RUpU8Mv2sd9hmskwEW99tH26cjjX_A@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To: Ben Gardon <bgardon@google.com>
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Apr 19, 2022 at 10:57 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Presently KVM only takes a read lock for stage 2 faults if it believes
> > the fault can be fixed by relaxing permissions on a PTE (write unprotect
> > for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> > predictably can pile up all the vCPUs in a sufficiently large VM.
> >
> > The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> > MMU protected by the combination of a read-write lock and RCU, allowing
> > page walkers to traverse in parallel.
> >
> > This series is strongly inspired by the mechanics of the TDP MMU,
> > making use of RCU to protect parallel walks. Note that the TLB
> > invalidation mechanics are a bit different between x86 and ARM, so we
> > need to use the 'break-before-make' sequence to split/collapse a
> > block/table mapping, respectively.
> >
> > Nonetheless, using atomics on the break side allows fault handlers to
> > acquire exclusive access to a PTE (lets just call it locked). Once the
> > PTE lock is acquired it is then safe to assume exclusive access.
> >
> > Special consideration is required when pruning the page tables in
> > parallel. Suppose we are collapsing a table into a block. Allowing
> > parallel faults means that a software walker could be in the middle of
> > a lower level traversal when the table is unlinked. Table
> > walkers that prune the paging structures must now 'lock' all descendent
> > PTEs, effectively asserting exclusive ownership of the substructure
> > (no other walker can install something to an already locked pte).
> >
> > Additionally, for parallel walks we need to punt the freeing of table
> > pages to the next RCU sync, as there could be multiple observers of the
> > table until all walkers exit the RCU critical section. For this I
> > decided to cram an rcu_head into page private data for every table page.
> > We wind up spending a bit more on table pages now, but lazily allocating
> > for rcu callbacks probably doesn't make a lot of sense. Not only would
> > we need a large cache of them (think about installing a level 1 block)
> > to wire up callbacks on all descendent tables, but we also then need to
> > spend memory to actually free memory.
>
> FWIW we used a similar approach in early versions of the TDP MMU, but
> instead of page->private used page->lru so that more metadata could be
> stored in page->private.
> Ultimately that ended up being too limiting and we decided to switch
> to just using the associated struct kvm_mmu_page as the list element.
> I don't know if ARM has an equivalent construct though.

ARM currently doesn't have any metadata it needs to tie with the table
pages. We just do very basic page reference counting for every valid
PTE. I was going to link together pages (hence the page header), but
we actually do not have a functional need for it at the moment. In
fact, struct page::rcu_head would probably fit the bill and we can
avoid extra metadata/memory for the time being.

Perhaps best to keep it simple and do the rest when we have a genuine
need for it.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
