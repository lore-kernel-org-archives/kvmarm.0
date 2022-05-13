Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A47C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B446049EE9;
	Sat, 14 May 2022 06:09:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IXGwabx8Mutq; Sat, 14 May 2022 06:08:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D5704B1E9;
	Sat, 14 May 2022 06:08:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E30E49EAA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 14:26:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5+d7i7XNTlJN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 14:26:58 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFE4A49EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 14:26:57 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id x23so8369359pff.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 11:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=f3nBn1LwcriRtnTdKkMxJqrXvUJa99h1XpX9rIbmPsc=;
 b=RhJ/oVsdfQd/xDIXzKmKW89BkOLc+aB9PbcUuGD8DhE/r1xIp+zmzF5kbvsJgECked
 iIDCEwz4polbRa9Kza2tvUk6jUn+c10xHR6SCkOweNd9d/plenEL5MksTH2Zx6zNGeKz
 VBz7ICQbeCFH4zDwa7cyQ5r9phyax2KPG0XaKgy/L4Fae3lWJOYMoavacX6i60ivO2OH
 Y0H7NAccqvn8wLt+movJmmQXzSIItkXTeqicXrylSCSAfE8CxKsphG4sNpJoRcLavqjo
 5pjxkAIUhwC6CNq/bIGLGGwFkhGx74uXQXnbfxeKgn7oRxrBFscg5wrIvz11H3AXtWFf
 EifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=f3nBn1LwcriRtnTdKkMxJqrXvUJa99h1XpX9rIbmPsc=;
 b=kRR/4kKYyJrZ4dJYy60aH90Ewy4wkgXB/ET1/zX0a7mk11qyKd49qXHTTlmTmTnyiK
 i93vT7cMZTVcWfMrSsQNgYT4IH+F3yDQn1yvWQLpBaPyH3KRvBuG0QFtJiihBx/JtxYP
 02ruW0LvMK6DdksXBtTIe3vF03JZwLyG2i9PZphY/WJoClBkNhM+J0KkniooOfwfjfgN
 r+gRhxQy6yjxi+iC/jECdqVzkgvWkilorWpxuPc0CPA115WFw6ZOxQPF/TXwxbsCc2E4
 pyy4RxIN3GNIlPcif6dNkuogOzyQYil0A/TYEZGd4wEnRVCFzCWaNbD1BktpljsAGkqc
 pJNg==
X-Gm-Message-State: AOAM533B/QetPoEGz9AxmVUC/EX1cPC2pL29jU6MndAzJqqZnCKWsUzG
 ATy3f/zCLCHkUS0Iz69BEgquwA==
X-Google-Smtp-Source: ABdhPJx9wMHQkLxpxX6sjpmk8QGYH6lnHrQ2Dj8+GdFaKMu4dvSUQ4p0vrU3A0yjKp68wJ49odGJsA==
X-Received: by 2002:a63:d747:0:b0:3db:74a9:ff92 with SMTP id
 w7-20020a63d747000000b003db74a9ff92mr5012769pgi.293.1652466416498; 
 Fri, 13 May 2022 11:26:56 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254]) by smtp.gmail.com with ESMTPSA id
 i12-20020a17090ad34c00b001d96bc27a57sm1896907pjx.54.2022.05.13.11.26.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 13 May 2022 11:26:55 -0700 (PDT)
Date: Fri, 13 May 2022 18:26:51 +0000
From: David Matlack <dmatlack@google.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <Yn6i6yUkIKyzXb+j@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
 <75fbbcb6-d9bb-3d30-0bf4-fbf925517d09@gmail.com>
 <CALzav=dmseUw6khErkiSV7T5K88QvaRvWvBpvrb6VNOQTE3bQQ@mail.gmail.com>
 <CAJhGHyDQn=atFmn5o2TREW9cSY5Tv1F1vsSekzor6uYQxDgcfQ@mail.gmail.com>
 <CALzav=e0VnYar=jUr+C=uhVf9O6NDXaHx2rW-+yUocdHVk39Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=e0VnYar=jUr+C=uhVf9O6NDXaHx2rW-+yUocdHVk39Mg@mail.gmail.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Thu, May 12, 2022 at 09:10:59AM -0700, David Matlack wrote:
> On Mon, May 9, 2022 at 7:58 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> > On Tue, May 10, 2022 at 5:04 AM David Matlack <dmatlack@google.com> wrote:
> > > On Sat, May 7, 2022 at 1:28 AM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> > > > On 2022/4/23 05:05, David Matlack wrote:
> > > > > +     /*
> > > > > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > > > > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > > > > +      * directories, each mapping 1/4 of the guest's linear address space
> > > > > +      * (1GiB). The shadow pages for those 4 page directories are
> > > > > +      * pre-allocated and assigned a separate quadrant in their role.
> > > >
> > > >
> > > > It is not going to be true in patchset:
> > > > [PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots
> > > >
> > > > https://lore.kernel.org/lkml/20220503150735.32723-1-jiangshanlai@gmail.com/
> > > >
> > > > The shadow pages for those 4 page directories are also allocated on demand.
> > >
> > > Ack. I can even just drop this sentence in v5, it's just background information.
> >
> > No, if one-off special shadow pages are used.
> >
> > kvm_mmu_child_role() should be:
> >
> > +       if (role.has_4_byte_gpte) {
> > +               if (role.level == PG_LEVEL_4K)
> > +                       role.quadrant = (sptep - parent_sp->spt) % 2;
> > +               if (role.level == PG_LEVEL_2M)
> > +                       role.quadrant = (sptep - parent_sp->spt) % 4;
> > +       }
> >
> >
> > And if one-off special shadow pages are merged first.  You don't
> > need any calculation in mmu_alloc_root(), you can just directly use
> >     sp = kvm_mmu_get_page(vcpu, gfn, vcpu->arch.mmu->root_role);
> > because vcpu->arch.mmu->root_role is always the real role of the root
> > sp no matter if it is a normall root sp or an one-off special sp.
> >
> > I hope you will pardon me for my touting my patchset and asking
> > people to review them in your threads.
> 
> I see what you mean now. If your series is queued I will rebase on top
> with the appropriate changes. But for now I will continue to code
> against kvm/queue.

Here is what I'm going with for v5:

        /*
         * If the guest has 4-byte PTEs then that means it's using 32-bit,
         * 2-level, non-PAE paging. KVM shadows such guests with PAE paging
         * (i.e. 8-byte PTEs). The difference in PTE size means that
         * KVM must shadow each guest page table with multiple shadow page
         * tables, which requires extra bookkeeping in the role.
         *
         * Specifically, to shadow the guest's page directory (which covers a
         * 4GiB address space), KVM uses 4 PAE page directories, each mapping
         * 1GiB of the address space. @role.quadrant encodes which quarter of
         * the address space each maps.
         *
         * To shadow the guest's page tables (which each map a 4MiB region),
         * KVM uses 2 PAE page tables, each mapping a 2MiB region. For these,
         * @role.quadrant encodes which half of the region they map.
         *
         * Note, the 4 PAE page directories are pre-allocated and the quadrant
         * assigned in mmu_alloc_root(). So only page tables need to be handled
         * here.
         */
        if (role.has_4_byte_gpte) {
                WARN_ON_ONCE(role.level != PG_LEVEL_4K);
                role.quadrant = (sptep - parent_sp->spt) % 2;
        }

Then to make it work with your series we can just apply this diff:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f7c4f08e8a69..0e0e2da2f37d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2131,14 +2131,10 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 a
         * To shadow the guest's page tables (which each map a 4MiB region),
         * KVM uses 2 PAE page tables, each mapping a 2MiB region. For these,
         * @role.quadrant encodes which half of the region they map.
-        *
-        * Note, the 4 PAE page directories are pre-allocated and the quadrant
-        * assigned in mmu_alloc_root(). So only page tables need to be handled
-        * here.
         */
        if (role.has_4_byte_gpte) {
-               WARN_ON_ONCE(role.level != PG_LEVEL_4K);
-               role.quadrant = (sptep - parent_sp->spt) % 2;
+               WARN_ON_ONCE(role.level > PG_LEVEL_2M);
+               role.quadrant = (sptep - parent_sp->spt) % (1 << role.level);
        }

        return role;

If your series is queued first, I can resend a v6 with this change or Paolo can
apply it. If mine is queued first then you can include this as part of your
series.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
