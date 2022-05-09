Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD86C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 22:57:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E8AC4B132;
	Mon,  9 May 2022 18:57:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VE0b0xs9gLt2; Mon,  9 May 2022 18:57:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF7174B0B9;
	Mon,  9 May 2022 18:57:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B28E49F3D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 18:57:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pT0dCnlKsVUu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 18:57:03 -0400 (EDT)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED0EF49F2E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 18:57:02 -0400 (EDT)
Received: by mail-pl1-f173.google.com with SMTP id j14so15221767plx.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 15:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=cyz9tulYjjoPlqL/KyMBr2cr526E/FbUGIe/SucGFmg=;
 b=grLQrLP7ejbiRHexQT7PQYQ7lzWo6AkBKPhUCpNagMVYqHnAc+3s9EzWnczkci8U9T
 x0CDMY8JYKuCbt1+SulS+AXwIWvH90zQPVSYGBwdV3dMyJmNQzZ1BveU220IQBuCLLzO
 IjmdvKpP5ZXQHIeTShNvYcKExMHAF7QKL4ECgoUPWvNE19+YdjxPemP6m+8x79QmI2jn
 ivkApIfUWLr/yCQkhuSvkYtjxYyLyAQ567smHX0zm4TcX4IhSEwwfENF9v7BVcee33Qb
 2wCbZMj25Hxzb2WLAfYU0q8GJVDtcIrlsIda+iPeZ7soBfZexXpzYkuy7Px5UOuBDyzH
 pBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cyz9tulYjjoPlqL/KyMBr2cr526E/FbUGIe/SucGFmg=;
 b=qLg9QPVe/kJwHUR9zLHI2PmxQ1YJXW5QvJ08I3XFtfrvHitvEYajXShHMiXJK24cKL
 U6NRgK7qKSmzxMjMMQ+Sl5KuGcb7W5ZXHf1e+7NSyuSlhTYzCl8LePF/5ZkdM+LccbRJ
 kBmO77y5Wn46HI/NinFr49uaS5uOyuTV/pJtiX+mcT4GQkwqp7/q1+nFL9k1a0Q/Au8W
 nwHgMTrunW40Ms7fC3RD3WelqkxW5aF3ysdt+23b/evfuUMYeDPBM3Y2qRt4nAK6pf4w
 b6RbXqKnFAZEXlzqoLDxkA/xxmKGC/iVws/vGmYXxJL0vPoGX2xchbKnqSXnzBPFbE2i
 NW3Q==
X-Gm-Message-State: AOAM530k4fJBQHOPnwzMl2eGphZ4OxwwFgt3EnNAoekZcoiiRqGlR3D7
 9377RHo7phHJS6U8Ar8IRTiQjA==
X-Google-Smtp-Source: ABdhPJx05y8bnmEfbnKZzU7mDZxHDicGOkpEGJYcw60iVRQzZoyIVrNyM6mO9JBa501S5piekC0NJQ==
X-Received: by 2002:a17:902:ccc1:b0:15a:24df:a7cc with SMTP id
 z1-20020a170902ccc100b0015a24dfa7ccmr18081599ple.42.1652137021345; 
 Mon, 09 May 2022 15:57:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 a25-20020aa780d9000000b0050dc7628182sm9392409pfn.92.2022.05.09.15.57.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 15:57:00 -0700 (PDT)
Date: Mon, 9 May 2022 22:56:57 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 11/20] KVM: x86/mmu: Allow for NULL vcpu pointer in
 __kvm_mmu_get_shadow_page()
Message-ID: <YnmcOdZILo2LqhAW@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-12-dmatlack@google.com>
 <YnRerE5+FpwkUdQE@google.com>
 <CALzav=de1=euis3WocTNBi+xNn1Ypo-GRROQNqmtAKk6q1NUqg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=de1=euis3WocTNBi+xNn1Ypo-GRROQNqmtAKk6q1NUqg@mail.gmail.com>
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

On Mon, May 09, 2022, David Matlack wrote:
> On Thu, May 5, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Apr 22, 2022, David Matlack wrote:
> > > Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
> > > it to vcpu_or_null to prevent future commits from accidentally taking
> > > dependency on it without first considering the NULL case.
> > >
> > > The vcpu pointer is only used for syncing indirect shadow pages in
> > > kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
> > > correctness since unsync pages can simply be zapped. But this should
> > > never occur in practice, since the only use-case for passing a NULL vCPU
> > > pointer is eager page splitting which will only request direct shadow
> > > pages (which can never be unsync).
> > >
> > > Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
> > > vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
> > > called to get an indirect shadow page with a NULL vCPU pointer, since
> > > zapping unsync SPs is a performance overhead that should be considered.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
> > >  1 file changed, 32 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 04029c01aebd..21407bd4435a 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
> > >         &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])     \
> > >               if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
> > >
> > > -static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > > -                      struct list_head *invalid_list)
> > > +static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
> > > +                        struct kvm_mmu_page *sp,
> > > +                        struct list_head *invalid_list)
> > >  {
> > > -     int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
> > > +     int ret = -1;
> > > +
> > > +     if (vcpu_or_null)
> >
> > This should never happen.  I like the idea of warning early, but I really don't
> > like that the WARN is far removed from the code that actually depends on @vcpu
> > being non-NULL. Case in point, KVM should have bailed on the WARN and never
> > reached this point.  And the inner __kvm_sync_page() is completely unnecessary.
> 
> Yeah that's fair.
> 
> >
> > I also don't love the vcpu_or_null terminology; I get the intent, but it doesn't
> > really help because understand why/when it's NULL.
> 
> Eh, I don't think it needs to encode why or when. It just needs to
> flag to the reader (and future code authors) that this vcpu pointer
> (unlike all other vcpu pointers in KVM) is NULL in certain cases.

My objection is that without the why/when, developers that aren't familiar with
this code won't know the rules for using vcpu_or_null.  E.g. I don't want to end
up with

	if (vcpu_or_null)
		do x;
	else
		do y;

because inevitably it'll become unclear whether or not that code is actually _correct_.
It might not #GP on a NULL pointer, but it doesn't mean it's correct.

> > I played around with casting, e.g. to/from an unsigned long or void *, to prevent
> > usage, but that doesn't work very well because 'unsigned long' ends up being
> > awkward/confusing, and 'void *' is easily lost on a function call.  And both
> > lose type safety :-(
> 
> Yet another shortcoming of C :(

And lack of closures, which would work very well here.

> (The other being our other discussion about the RET_PF* return codes
> getting easily misinterpreted as KVM's magic return-to-user /
> continue-running-guest return codes.)
> 
> Makes me miss Rust!
> 
> >
> > All in all, I think I'd prefer this patch to simply be a KVM_BUG_ON() if
> > kvm_mmu_find_shadow_page() encounters an unsync page.  Less churn, and IMO there's
> > no real loss in robustness, e.g. we'd really have to screw up code review and
> > testing to introduce a null vCPU pointer dereference in this code.
> 
> Agreed about moving the check here and dropping __kvm_sync_page(). But
> I would prefer to retain the vcpu_or_null name (or at least something
> other than "vcpu" to indicate there's something non-standard about
> this pointer).

The least awful idea I've come up with is wrapping the vCPU in a struct, e.g.

	struct sync_page_info {
		void *vcpu;
	}

That provides the contextual information I want, and also provides the hint that
something is odd about the vcpu, which you want.  It's like a very poor man's closure :-)
	
The struct could even be passed by value to avoid the miniscule overhead, and to
make readers look extra hard because it's that much more wierd.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3d102522804a..068be77a4fff 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2003,8 +2003,13 @@ static void clear_sp_write_flooding_count(u64 *spte)
        __clear_sp_write_flooding_count(sptep_to_sp(spte));
 }

+/* Wrapper to make it difficult to dereference a potentially NULL @vcpu. */
+struct sync_page_info {
+       void *vcpu;
+};
+
 static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
-                                                    struct kvm_vcpu *vcpu,
+                                                    struct sync_page_info spi,
                                                     gfn_t gfn,
                                                     struct hlist_head *sp_list,
                                                     union kvm_mmu_page_role role)
@@ -2041,6 +2046,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
                        goto out;

                if (sp->unsync) {
+                       /*
+                        * Getting indirect shadow pages without a valid @spi
+                        * is not supported, i.e. this should never happen.
+                        */
+                       if (KVM_BUG_ON(!spi.vcpu, kvm))
+                               break;
+
                        /*
                         * The page is good, but is stale.  kvm_sync_page does
                         * get the latest guest state, but (unlike mmu_unsync_children)
@@ -2053,7 +2065,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
                         * If the sync fails, the page is zapped.  If so, break
                         * in order to rebuild it.
                         */
-                       ret = kvm_sync_page(vcpu, sp, &invalid_list);
+                       ret = kvm_sync_page(spi.vcpu, sp, &invalid_list);
                        if (ret < 0)
                                break;

@@ -2120,7 +2132,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 }

 static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
-                                                     struct kvm_vcpu *vcpu,
+                                                     struct sync_page_info spi,
                                                      struct shadow_page_caches *caches,
                                                      gfn_t gfn,
                                                      union kvm_mmu_page_role role)
@@ -2131,7 +2143,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,

        sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];

-       sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
+       sp = kvm_mmu_find_shadow_page(kvm, spi, gfn, sp_list, role);
        if (!sp) {
                created = true;
                sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
@@ -2151,7 +2163,11 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
                .gfn_array_cache = &vcpu->arch.mmu_gfn_array_cache,
        };

-       return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
+       struct sync_page_info spi = {
+               .vcpu = vcpu,
+       };
+
+       return __kvm_mmu_get_shadow_page(vcpu->kvm, spi, &caches, gfn, role);
 }

 static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
