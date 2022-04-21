Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7753DC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 17:50:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BC154B28B;
	Fri, 22 Apr 2022 13:50:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Hxkr5rnKXU4; Fri, 22 Apr 2022 13:50:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D5E4B293;
	Fri, 22 Apr 2022 13:50:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF2B4B208
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:31:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ByJrvGOQZa1W for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:31:03 -0400 (EDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com
 [209.85.219.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1F394B10C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:31:03 -0400 (EDT)
Received: by mail-yb1-f179.google.com with SMTP id g14so6371027ybj.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=85KhqeJYci7KtDV6WnG3kCKWzEDclQTTPrHp0DkW/4I=;
 b=S7qrv0c9ibm9ObfrK3N2O6JQD0lgfWJP3iX06KjZsLuEmxFHObUR5eAz8SdwO5Nm3p
 vzT/oJjHKWXzpWA73Q/qJMuaOnsvvJEvki+yBtUMKAnOjGXxv+NNRJyegojLmEymoMPN
 X+A9ktZZ9XWy4cgPZ3cvSqhIkvpuTZDdzkL7qF3Myx6sorEGHfPtcFmVMP4oAcJY1+Ou
 FKxllXtwprwzxlaOy1GKs6996L7ExTBCTRz1YZpPIv7zWcGJqJ1GpYN9HZvWn9vjrmdq
 qfEMwiV9qAwvWzx2jdBivNrjiXTrlNhvAaO1SW+++UfneqJ8yeSipAyPGWyA0pZL8gZY
 8X1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=85KhqeJYci7KtDV6WnG3kCKWzEDclQTTPrHp0DkW/4I=;
 b=MbESLfO7pNK5SrQYKF+7NDlkUldznxOPZPPREavS6Q6Vd6ZOvrXQnGc6Sy359chjWT
 RO0KhyT6Fv3+W7IWXLX84zCalxwrL9ib36BxyHokr9MiUuXSP9Ue9JWhTUHlmfJUMPq1
 GTIhiijbysWTvDSQ3h8Jk0xs64x5gkSLwLNlbfiuGOBNnjQdWYU2k3vffEv9FPSRoUVx
 1S42z1zrynmmjadMLkGKF8Q7Ai+kbsnUvMSKuBElOVS4YZhjPRyTBfzrwlwuuQTY3Xsp
 8w0Y5vKmODgpHTabuuC3AAB6Y7knM2tQKZsxdJpH41ayl+iVdGc4rLtwQQqo0mdFlw+u
 rzrw==
X-Gm-Message-State: AOAM532+zM59pigNeVRnij2HiR/JKrWxZWlcH6HbfmcStEwPhSS9G/1i
 Jwz4EJ529+8V4kc3qWZORWa+HjaoDHGwtlM17ABgHg==
X-Google-Smtp-Source: ABdhPJxI3f+nxc2oRFOpDB/a5OEQMffl8ehlvKNFIdsC9CIQ+joF/lNpYwk0ZFH/AYir2u09DHK53XcQqGK8liK6Wj8=
X-Received: by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr451287ybn.259.1650558662967; Thu, 21 Apr
 2022 09:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
 <CAOQ_QsieUXOFXLkZ=ya0RUpU8Mv2sd9hmskwEW99tH26cjjX_A@mail.gmail.com>
In-Reply-To: <CAOQ_QsieUXOFXLkZ=ya0RUpU8Mv2sd9hmskwEW99tH26cjjX_A@mail.gmail.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 21 Apr 2022 09:30:52 -0700
Message-ID: <CANgfPd80wTYX92Q9dP7irMdZW+Y0_VNFQ19xJaf5DvndEaa7dw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Fri, 22 Apr 2022 13:50:47 -0400
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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

On Tue, Apr 19, 2022 at 11:36 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Apr 19, 2022 at 10:57 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Presently KVM only takes a read lock for stage 2 faults if it believes
> > > the fault can be fixed by relaxing permissions on a PTE (write unprotect
> > > for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> > > predictably can pile up all the vCPUs in a sufficiently large VM.
> > >
> > > The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> > > MMU protected by the combination of a read-write lock and RCU, allowing
> > > page walkers to traverse in parallel.
> > >
> > > This series is strongly inspired by the mechanics of the TDP MMU,
> > > making use of RCU to protect parallel walks. Note that the TLB
> > > invalidation mechanics are a bit different between x86 and ARM, so we
> > > need to use the 'break-before-make' sequence to split/collapse a
> > > block/table mapping, respectively.
> > >
> > > Nonetheless, using atomics on the break side allows fault handlers to
> > > acquire exclusive access to a PTE (lets just call it locked). Once the
> > > PTE lock is acquired it is then safe to assume exclusive access.
> > >
> > > Special consideration is required when pruning the page tables in
> > > parallel. Suppose we are collapsing a table into a block. Allowing
> > > parallel faults means that a software walker could be in the middle of
> > > a lower level traversal when the table is unlinked. Table
> > > walkers that prune the paging structures must now 'lock' all descendent
> > > PTEs, effectively asserting exclusive ownership of the substructure
> > > (no other walker can install something to an already locked pte).
> > >
> > > Additionally, for parallel walks we need to punt the freeing of table
> > > pages to the next RCU sync, as there could be multiple observers of the
> > > table until all walkers exit the RCU critical section. For this I
> > > decided to cram an rcu_head into page private data for every table page.
> > > We wind up spending a bit more on table pages now, but lazily allocating
> > > for rcu callbacks probably doesn't make a lot of sense. Not only would
> > > we need a large cache of them (think about installing a level 1 block)
> > > to wire up callbacks on all descendent tables, but we also then need to
> > > spend memory to actually free memory.
> >
> > FWIW we used a similar approach in early versions of the TDP MMU, but
> > instead of page->private used page->lru so that more metadata could be
> > stored in page->private.
> > Ultimately that ended up being too limiting and we decided to switch
> > to just using the associated struct kvm_mmu_page as the list element.
> > I don't know if ARM has an equivalent construct though.
>
> ARM currently doesn't have any metadata it needs to tie with the table
> pages. We just do very basic page reference counting for every valid
> PTE. I was going to link together pages (hence the page header), but
> we actually do not have a functional need for it at the moment. In
> fact, struct page::rcu_head would probably fit the bill and we can
> avoid extra metadata/memory for the time being.

Ah, right! I page::rcu_head was the field I was thinking of.

>
> Perhaps best to keep it simple and do the rest when we have a genuine
> need for it.

Completely agree. I'm surprised that ARM doesn't have a need for a
metadata structure associated with each page of the stage 2 paging
structure, but if you don't need it, that definitely makes things
simpler.

>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
