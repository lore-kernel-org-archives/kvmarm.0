Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5642C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 16:00:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 680A2206A4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 16:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 680A2206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E43DB4B1B4;
	Thu, 11 Jun 2020 12:00:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8NUmPImhFWeT; Thu, 11 Jun 2020 12:00:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAE814B190;
	Thu, 11 Jun 2020 12:00:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CBDE4B18C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 11:59:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HvQLfbThyohr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2020 11:59:57 -0400 (EDT)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 887024B125
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 11:59:57 -0400 (EDT)
IronPort-SDR: JWWQIMJk7UGBhOBuHttRBav4XZXZKzrey5oyq836NrIyr6Na13wjMAbXF6V1ZAjIx0U4uY+rXq
 TBNAoK28LD1Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Jun 2020 08:59:55 -0700
IronPort-SDR: vlQ6xqosUXqm2IK2atrupqAhPka9ERniiyAolofQ9QLnlgU84Ttdpz9HijVivDLr/IVeArXiV+
 xSQxjn+bUQsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; d="scan'208";a="306964950"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.152])
 by orsmga008.jf.intel.com with ESMTP; 11 Jun 2020 08:59:54 -0700
Date: Thu, 11 Jun 2020 08:59:54 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 16/21] KVM: arm64: Drop @max param from
 mmu_topup_memory_cache()
Message-ID: <20200611155954.GH29918@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-17-sean.j.christopherson@intel.com>
 <CANgfPd-x=Af6Wdn9Wz=9r5CiHDCbxEgQhS2swALUMQd00oQ3jg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd-x=Af6Wdn9Wz=9r5CiHDCbxEgQhS2swALUMQd00oQ3jg@mail.gmail.com>
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

On Wed, Jun 10, 2020 at 03:00:47PM -0700, Ben Gardon wrote:
> On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Replace the @max param in mmu_topup_memory_cache() and instead use
> > ARRAY_SIZE() to terminate the loop to fill the cache.  This removes a
> > BUG_ON() and sets the stage for moving arm64 to the common memory cache
> > implementation.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index a1f6bc70c4e4..9398b66f8a87 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -124,15 +124,13 @@ static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
> >         put_page(virt_to_page(pudp));
> >  }
> >
> > -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> > -                                 int min, int max)
> > +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
> >  {
> >         void *page;
> >
> > -       BUG_ON(max > KVM_NR_MEM_OBJS);
> KVM_NR_MEM_OBJS should be undefined as of patch 14 in this series. I'd
> recommend changing this to use the new constant you defined in that
> patch.

My intent was to leave KVM_NR_MEM_OBJS defined by arm64 and MIPS until they
move to the common implementation, e.g. this should be defined in
arch/arm64/include/asm/kvm_host.h until patch 18.  I'll get cross-compiling
setup so I can properly test bisection before sending v2.

> >         if (cache->nobjs >= min)
> >                 return 0;
> > -       while (cache->nobjs < max) {
> > +       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> >                 page = (void *)__get_free_page(GFP_PGTABLE_USER);
> >                 if (!page)
> >                         return -ENOMEM;
> > @@ -1356,8 +1354,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >                         pte = kvm_s2pte_mkwrite(pte);
> >
> >                 ret = mmu_topup_memory_cache(&cache,
> > -                                            kvm_mmu_cache_min_pages(kvm),
> > -                                            KVM_NR_MEM_OBJS);
> See above, KVM_NR_MEM_OBJS is undefined as of patch 14.
> > +                                            kvm_mmu_cache_min_pages(kvm));
> >                 if (ret)
> >                         goto out;
> >                 spin_lock(&kvm->mmu_lock);
> > @@ -1737,8 +1734,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >         up_read(&current->mm->mmap_sem);
> >
> >         /* We need minimum second+third level pages */
> > -       ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
> > -                                    KVM_NR_MEM_OBJS);
> See above, KVM_NR_MEM_OBJS is undefined as of patch 14.
> > +       ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm));
> >         if (ret)
> >                 return ret;
> >
> > --
> > 2.26.0
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
