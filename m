Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1492DC2D0B1
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 05:05:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FE8420838
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 05:05:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FE8420838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB08B4A49F;
	Thu,  6 Feb 2020 00:05:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zYLMzLsoC7M1; Thu,  6 Feb 2020 00:05:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C459C4A534;
	Thu,  6 Feb 2020 00:05:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 533FF4A534
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 00:05:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8KIDpt+WF3zr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 00:05:22 -0500 (EST)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 430F54A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 00:05:22 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 05 Feb 2020 21:05:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; d="scan'208";a="254987822"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga004.fm.intel.com with ESMTP; 05 Feb 2020 21:05:19 -0800
Date: Wed, 5 Feb 2020 21:05:19 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 01/19] KVM: x86: Allocate new rmap and large page
 tracking when moving memslot
Message-ID: <20200206050518.GA9401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-2-sean.j.christopherson@intel.com>
 <20200205214952.GD387680@xz-x1>
 <20200205235533.GA7631@linux.intel.com>
 <20200206020031.GJ387680@xz-x1>
 <20200206021714.GB7631@linux.intel.com>
 <20200206025858.GK387680@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200206025858.GK387680@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
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

On Wed, Feb 05, 2020 at 09:58:58PM -0500, Peter Xu wrote:
> On Wed, Feb 05, 2020 at 06:17:15PM -0800, Sean Christopherson wrote:
> > On Wed, Feb 05, 2020 at 09:00:31PM -0500, Peter Xu wrote:
> > > On Wed, Feb 05, 2020 at 03:55:33PM -0800, Sean Christopherson wrote:
> > > > On Wed, Feb 05, 2020 at 04:49:52PM -0500, Peter Xu wrote:
> > > > > Instead of calling kvm_arch_create_memslot() explicitly again here,
> > > > > can it be replaced by below?
> > > > > 
> > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > index 72b45f491692..85a7b02fd752 100644
> > > > > --- a/virt/kvm/kvm_main.c
> > > > > +++ b/virt/kvm/kvm_main.c
> > > > > @@ -1144,7 +1144,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > > > >                 new.dirty_bitmap = NULL;
> > > > >  
> > > > >         r = -ENOMEM;
> > > > > -       if (change == KVM_MR_CREATE) {
> > > > > +       if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
> > > > >                 new.userspace_addr = mem->userspace_addr;
> > > > >  
> > > > >                 if (kvm_arch_create_memslot(kvm, &new, npages))
> > > > 
> > > > No, because other architectures don't need to re-allocate new metadata on
> > > > MOVE and rely on __kvm_set_memory_region() to copy @arch from old to new,
> > > > e.g. see kvmppc_core_create_memslot_hv().
> > > 
> > > Yes it's only required in x86, but iiuc it also will still work for
> > > ppc?  Say, in that case ppc won't copy @arch from old to new, and
> > > kvmppc_core_free_memslot_hv() will free the old, however it should
> > > still work.
> > 
> > No, calling kvm_arch_create_memslot() for MOVE will result in PPC leaking
> > memory due to overwriting slot->arch.rmap with a new allocation.
> 
> Why?  For the MOVE case, kvm_arch_create_memslot() will create a new
> rmap for the "new" memslot.  If the whole procedure succeeded,
> kvm_free_memslot() will free the old rmap.  If it failed,
> kvm_free_memslot() will free the new rmap if !NULL.  Looks fine?

Oh, I see what you're suggesting.   Please god no.

This is a bug fix that needs to be backported to stable.  Arbitrarily
changing PPC behavior is a bad idea, especially since I don't know squat
about the PPC rmap behavior.

If it happens to fix a PPC rmap bug, then PPC should get an explicit fix.
If it's not a bug fix, then at best it is a minor performance hit due to an
extra allocation and the need to refill the rmap.  Worst case scenario it
breaks PPC.

And unless this were a temporary change, which would be silly, I would have
to carry forward the change into "KVM: PPC: Move memslot memory allocation
into prepare_memory_region()", and again, I don't know squat about PPC.

I also don't want to effectively introduce a misnamed function, even if
only temporarily, e.g. it's kvm_arch_create_memslot(), not
kvm_arch_create_or_move_memslot(), because the whole flow gets reworked a
few patches later.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
