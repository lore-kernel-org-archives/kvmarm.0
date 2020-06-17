Return-Path: <SRS0=IB6K=76=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA1FC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 16:50:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2173921532
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 16:50:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="eawpKQDd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2173921532
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EF2B4B14B;
	Wed, 17 Jun 2020 12:50:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1ogkyKWdd5jY; Wed, 17 Jun 2020 12:50:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5A94B0BF;
	Wed, 17 Jun 2020 12:50:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AC684B0CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 12:36:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l-2NKdSLKYa3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2020 12:36:37 -0400 (EDT)
Received: from mail-vs1-f67.google.com (mail-vs1-f67.google.com
 [209.85.217.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 403A04B0C8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 12:36:37 -0400 (EDT)
Received: by mail-vs1-f67.google.com with SMTP id t132so1770432vst.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 09:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=L8DsS6xxyGZ4X1I2BsfKE5F+wl5+Bc0v/Cbn7ErCR3k=;
 b=eawpKQDd4c5bCWEDiwcn6BhRKGQcd5albFMeNaZdFKCB6O3sFwD2XAZx9LvvOYi87t
 Zd0041rw93VndgUPf5lk4RuZlA8dXcSVTpu7VYahKPZdbqv05KKeJ7LnJttdizTtluT5
 OYHgJdvNb8dH72kutypMPcXeLhyWIrRgMaS2iyuw/Lr6YD8+6DI8AvQtasmtlXDE9C7F
 FLi5DWCcWK7BKjDne7sZg/HbVdCiwosxxGZDthxyWacUQng42CxceziSSSXk8BO1AWeN
 BJDSiX2/zLffm0wAwppKnLGmoK/ndXvK8/qS5cg9IJUTWjiRKFGR6YFdm/zusqJzzUqC
 dKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=L8DsS6xxyGZ4X1I2BsfKE5F+wl5+Bc0v/Cbn7ErCR3k=;
 b=jddh9LhIOth5RYPPxvuE8mwP9W8PJUS/2Tvi3nqKQRW0mNFXgwOOg2Tb4yaAAu/dDR
 h318xH65KbGAshk7rkrcu1MgIEoTZLE1FSN+Rb+lBCr32mDiz8Jdp3MF4UdUwuSG1OnE
 81BNUmBHaeECTj+j2aeQqrLKQAWNcdxFiNK/VtOPeTh4sR5fsS22bwqyApfLLUyo8otN
 vxkr6zNpUh8WwcrnaGFZUUY8xYYSb9hShJa1AyQzu1I01DKpT4SgUXqIcogeZF7qSFXu
 pzGRXAsiokE5xKpfFcdLqUVwZqFdz5CenPw/seVj8/U4QrPAVfDjopqkn1JdwTLDMzy6
 jUZg==
X-Gm-Message-State: AOAM531y79ZXnI5hChLpVRBffmmJYYgKrg3c/TtmALhHXKoPc/Et5nZ0
 OBlp31l81oXCl7jVXT0YRCkK6wb2D7QrnhEDd0aLPw==
X-Google-Smtp-Source: ABdhPJz7oaun07TMv+zayNnAIYVTbbeP778/fuG5Ll7911G7zeLD5BHbO9dbHYGezneDNySTtZXTodF2yXRXfDK1+ZE=
X-Received: by 2002:a67:70c3:: with SMTP id l186mr6698034vsc.117.1592411796250; 
 Wed, 17 Jun 2020 09:36:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-6-sean.j.christopherson@intel.com>
 <CANgfPd8B5R9NRL5q_4v4xvvn_3Vo9N93Ms3EiUFANMzqAMedMw@mail.gmail.com>
 <20200617005309.GA19540@linux.intel.com>
In-Reply-To: <20200617005309.GA19540@linux.intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 17 Jun 2020 09:36:25 -0700
Message-ID: <CANgfPd8xkEotTJQPkMOrJNLOLXb4+TOA06wqO16UPdk_icF8tw@mail.gmail.com>
Subject: Re: [PATCH 05/21] KVM: x86/mmu: Try to avoid crashing KVM if a MMU
 memory cache is empty
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Wed, 17 Jun 2020 12:50:47 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On Tue, Jun 16, 2020 at 5:53 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Jun 10, 2020 at 03:12:04PM -0700, Ben Gardon wrote:
> > On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Attempt to allocate a new object instead of crashing KVM (and likely the
> > > kernel) if a memory cache is unexpectedly empty.  Use GFP_ATOMIC for the
> > > allocation as the caches are used while holding mmu_lock.  The immediate
> > > BUG_ON() makes the code unnecessarily explosive and led to confusing
> > > minimums being used in the past, e.g. allocating 4 objects where 1 would
> > > suffice.
> > >
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++------
> > >  1 file changed, 15 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index ba70de24a5b0..5e773564ab20 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1060,6 +1060,15 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> > >         local_irq_enable();
> > >  }
> > >
> > > +static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > > +                                              gfp_t gfp_flags)
> > > +{
> > > +       if (mc->kmem_cache)
> > > +               return kmem_cache_zalloc(mc->kmem_cache, gfp_flags);
> > > +       else
> > > +               return (void *)__get_free_page(gfp_flags);
> > > +}
> > > +
> > >  static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > >  {
> > >         void *obj;
> > > @@ -1067,10 +1076,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > >         if (mc->nobjs >= min)
> > >                 return 0;
> > >         while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > > -               if (mc->kmem_cache)
> > > -                       obj = kmem_cache_zalloc(mc->kmem_cache, GFP_KERNEL_ACCOUNT);
> > > -               else
> > > -                       obj = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> > > +               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > >                 if (!obj)
> > >                         return mc->nobjs >= min ? 0 : -ENOMEM;
> > >                 mc->objects[mc->nobjs++] = obj;
> > > @@ -1118,8 +1124,11 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> > >  {
> > >         void *p;
> > >
> > > -       BUG_ON(!mc->nobjs);
> > > -       p = mc->objects[--mc->nobjs];
> > > +       if (WARN_ON(!mc->nobjs))
> > > +               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> > Is an atomic allocation really necessary here? In most cases, when
> > topping up the memory cache we are handing a guest page fault. This
> > bug could also be removed by returning null if unable to allocate from
> > the cache, and then re-trying the page fault in that case.
>
> The whole point of these caches is to avoid having to deal with allocation
> errors in the low level MMU paths, e.g. propagating an error up from
> pte_list_add() would be a mess.
>
> > I don't know if this is necessary to handle other, non-x86 architectures more
> > easily, but I worry this could cause some unpleasantness if combined with
> > some other bug or the host was in a low memory situation and then this
> > consumed the atomic pool. Perhaps this is a moot point since we log a warning
> > and consider the atomic allocation something of an error.
>
> Yeah, it's the latter.  If we reach this point it's a guaranteed KVM bug.
> Because it's likely that the caller holds a lock, triggering the BUG_ON()
> has a high chance of hanging the system.  The idea is to take the path that
> _may_ crash the kernel instead of killing the VM and more than likely
> crashing the kernel.  And hopefully this code will never be exercised on a
> production kernel.

That makes sense to me. I agree it's definitely positive to replace a
BUG_ON with something else.

>
> > > +       else
> > > +               p = mc->objects[--mc->nobjs];
> > > +       BUG_ON(!p);
> > >         return p;
> > >  }
> > >
> > > --
> > > 2.26.0
> > >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
