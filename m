Return-Path: <SRS0=IB6K=76=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A66C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 00:53:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B4682080D
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 00:53:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B4682080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9704D4B187;
	Tue, 16 Jun 2020 20:53:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ixfJjjp5UZvg; Tue, 16 Jun 2020 20:53:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CCA14B182;
	Tue, 16 Jun 2020 20:53:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 851144B17F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 20:53:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TNWq0T2Qcmhw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2020 20:53:12 -0400 (EDT)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F0EE4B17C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 20:53:12 -0400 (EDT)
IronPort-SDR: j6TxB5iD6/VuxDduhX7Vs26LxzTUe6p30PSunMS7e/zneHujrh64mSIpscHDEYsMNQZW16vW02
 8prfZngysVmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 16 Jun 2020 17:53:10 -0700
IronPort-SDR: SUBjWGuROTOrr9kwwyRCGbl/hrI+QkSJ1Q57v0iPCxSIqpvvppNJdDsU/RssN7WxgNYb+sJfYU
 HH4TrYIFT3hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,520,1583222400"; d="scan'208";a="309309155"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.152])
 by fmsmga002.fm.intel.com with ESMTP; 16 Jun 2020 17:53:09 -0700
Date: Tue, 16 Jun 2020 17:53:09 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 05/21] KVM: x86/mmu: Try to avoid crashing KVM if a MMU
 memory cache is empty
Message-ID: <20200617005309.GA19540@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-6-sean.j.christopherson@intel.com>
 <CANgfPd8B5R9NRL5q_4v4xvvn_3Vo9N93Ms3EiUFANMzqAMedMw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd8B5R9NRL5q_4v4xvvn_3Vo9N93Ms3EiUFANMzqAMedMw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
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

On Wed, Jun 10, 2020 at 03:12:04PM -0700, Ben Gardon wrote:
> On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Attempt to allocate a new object instead of crashing KVM (and likely the
> > kernel) if a memory cache is unexpectedly empty.  Use GFP_ATOMIC for the
> > allocation as the caches are used while holding mmu_lock.  The immediate
> > BUG_ON() makes the code unnecessarily explosive and led to confusing
> > minimums being used in the past, e.g. allocating 4 objects where 1 would
> > suffice.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++------
> >  1 file changed, 15 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ba70de24a5b0..5e773564ab20 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1060,6 +1060,15 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> >         local_irq_enable();
> >  }
> >
> > +static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > +                                              gfp_t gfp_flags)
> > +{
> > +       if (mc->kmem_cache)
> > +               return kmem_cache_zalloc(mc->kmem_cache, gfp_flags);
> > +       else
> > +               return (void *)__get_free_page(gfp_flags);
> > +}
> > +
> >  static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> >  {
> >         void *obj;
> > @@ -1067,10 +1076,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> >         if (mc->nobjs >= min)
> >                 return 0;
> >         while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > -               if (mc->kmem_cache)
> > -                       obj = kmem_cache_zalloc(mc->kmem_cache, GFP_KERNEL_ACCOUNT);
> > -               else
> > -                       obj = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> > +               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> >                 if (!obj)
> >                         return mc->nobjs >= min ? 0 : -ENOMEM;
> >                 mc->objects[mc->nobjs++] = obj;
> > @@ -1118,8 +1124,11 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> >  {
> >         void *p;
> >
> > -       BUG_ON(!mc->nobjs);
> > -       p = mc->objects[--mc->nobjs];
> > +       if (WARN_ON(!mc->nobjs))
> > +               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> Is an atomic allocation really necessary here? In most cases, when
> topping up the memory cache we are handing a guest page fault. This
> bug could also be removed by returning null if unable to allocate from
> the cache, and then re-trying the page fault in that case.

The whole point of these caches is to avoid having to deal with allocation
errors in the low level MMU paths, e.g. propagating an error up from
pte_list_add() would be a mess.

> I don't know if this is necessary to handle other, non-x86 architectures more
> easily, but I worry this could cause some unpleasantness if combined with
> some other bug or the host was in a low memory situation and then this
> consumed the atomic pool. Perhaps this is a moot point since we log a warning
> and consider the atomic allocation something of an error.

Yeah, it's the latter.  If we reach this point it's a guaranteed KVM bug.
Because it's likely that the caller holds a lock, triggering the BUG_ON()
has a high chance of hanging the system.  The idea is to take the path that
_may_ crash the kernel instead of killing the VM and more than likely
crashing the kernel.  And hopefully this code will never be exercised on a
production kernel.

> > +       else
> > +               p = mc->objects[--mc->nobjs];
> > +       BUG_ON(!p);
> >         return p;
> >  }
> >
> > --
> > 2.26.0
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
