Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814C9C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 16:57:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1933D20707
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 16:57:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1933D20707
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 719AE4B0C0;
	Mon, 22 Jun 2020 12:57:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C-SunEvqu2kc; Mon, 22 Jun 2020 12:57:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 740DF4B0D3;
	Mon, 22 Jun 2020 12:57:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DC054B0C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 12:57:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VXP3HHTjwmzS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 12:57:32 -0400 (EDT)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A16634B0A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 12:57:32 -0400 (EDT)
IronPort-SDR: GO28pfpj4bH4rm2obdSW8DCBGV7IG+Qp49OCue0IS6EnwhHo9jTfvS9deAvpwyK+lN5qp3lhu6
 D4bpIOU8CDkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="228474880"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="228474880"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Jun 2020 09:57:30 -0700
IronPort-SDR: S4VEirMcNhQ2lH0bAVvJJDP7s7VRkd36rpU/H5Pu+0zC5Ty7uMfI7DemqqyQV4/pP77ANcjPYf
 AXdGOcNkkbyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="384580750"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.152])
 by fmsmga001.fm.intel.com with ESMTP; 22 Jun 2020 09:57:30 -0700
Date: Mon, 22 Jun 2020 09:57:30 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 14/21] KVM: Move x86's version of struct
 kvm_mmu_memory_cache to common code
Message-ID: <20200622165730.GD5150@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-15-sean.j.christopherson@intel.com>
 <CANgfPd_v31zC5-mKsT14hd7W=X2Pvg3RBPjn2d4tFSChdbsr3A@mail.gmail.com>
 <CANgfPd-iH8AShSPPJiaDCxV1H76kfpTOQMZSMP_+nP3LoXbYBg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd-iH8AShSPPJiaDCxV1H76kfpTOQMZSMP_+nP3LoXbYBg@mail.gmail.com>
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

On Wed, Jun 10, 2020 at 02:58:21PM -0700, Ben Gardon wrote:
> On Wed, Jun 10, 2020 at 12:01 PM Ben Gardon <bgardon@google.com> wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index fb99e6776e27..8e8fea13b6c7 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -193,8 +193,6 @@ struct x86_exception;
> > >  enum x86_intercept;
> > >  enum x86_intercept_stage;
> > >
> > > -#define KVM_NR_MEM_OBJS 40
> > > -
> Oops I didn't catch this on my first read through, but in patch 16 in
> this series I see some references to KVM_NR_MEM_OBJS being removed. As
> a result I would not expect this patch to build. Other references to
> this value should probably replaced with
> KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE as well.

This patch intentionally uses a different name for the #define (see below)
so that the existing arm64 and MIPS declarations don't get picked up by
common KVM code.  This is required so that arm64 and MIPS continue to use
their versions of the cache implementation until they are converted to the
common implementation later in the series, e.g. in patch 16 when the
references to KVM_NR_MEM_OBJS are removed.

I confirmed the above (after sending v1) by compiling all non-x86 changes
on arm64, MIPS, s390 and PPC to verify that this doesn't break bisection.

> > >  #define KVM_NR_DB_REGS 4
> > >
> > >  #define DR6_BD         (1 << 13)
> > > @@ -245,17 +243,6 @@ enum x86_intercept_stage;
> > >
> > >  struct kvm_kernel_irq_routing_entry;

...

> > > +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> > > +/*
> > > + * Memory caches are used to preallocate memory ahead of various MMU flows,
> > > + * e.g. page fault handlers.  Gracefully handling allocation failures deep in
> > > + * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
> > > + * holding MMU locks.  Note, these caches act more like prefetch buffers than
> > > + * classical caches, i.e. objects are not returned to the cache on being freed.
> > > + */
> > > +struct kvm_mmu_memory_cache {
> > > +       int nobjs;
> > > +       gfp_t gfp_zero;
> > > +       struct kmem_cache *kmem_cache;
> > > +       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> > > +};
> > > +#endif
> > > +
> > > +
> > >  #endif /* __KVM_TYPES_H__ */
> > > --
> > > 2.26.0
> > >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
