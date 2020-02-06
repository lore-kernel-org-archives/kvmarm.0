Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2872C35247
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:21:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 610C921775
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:21:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 610C921775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2D134A542;
	Thu,  6 Feb 2020 16:21:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6wo--CQY3nk8; Thu,  6 Feb 2020 16:21:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7524A4A4;
	Thu,  6 Feb 2020 16:21:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9EA84A4A4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:21:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xcnaedSe-jRg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 16:21:22 -0500 (EST)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18FE64A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:21:22 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 06 Feb 2020 13:21:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; d="scan'208";a="250191235"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 06 Feb 2020 13:21:20 -0800
Date: Thu, 6 Feb 2020 13:21:20 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200206212120.GF13067@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200206200200.GC700495@xz-x1>
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

On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
> On Tue, Jan 21, 2020 at 02:31:53PM -0800, Sean Christopherson wrote:
> 
> [...]
> 
> > -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> > +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
> > +				  struct kvm_memory_slot *memslot)
> 
> If it's to flush TLB for a memslot, shall we remove the "dirty_log" in
> the name of the function, because it has nothing to do with dirty
> logging any more?  And...

I kept the "dirty_log" to allow arch code to implement logic specific to a
TLB flush during dirty logging, e.g. x86's lockdep assert on slots_lock.
And similar to the issue with MIPS below, to deter usage of the hook for
anything else, i.e. to nudge people to using kvm_flush_remote_tlbs()
directly.

> >  {
> > -	struct kvm_memslots *slots;
> > -	struct kvm_memory_slot *memslot;
> > -	bool flush = false;
> > -	int r;
> > -
> > -	mutex_lock(&kvm->slots_lock);
> > -
> > -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> > -
> > -	if (flush) {
> > -		slots = kvm_memslots(kvm);
> > -		memslot = id_to_memslot(slots, log->slot);
> > -
> > -		/* Let implementation handle TLB/GVA invalidation */
> > -		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> > -	}
> > -
> > -	mutex_unlock(&kvm->slots_lock);
> > -	return r;
> > +	/* Let implementation handle TLB/GVA invalidation */
> > +	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> 
> ... This may not directly related to the current patch, but I'm
> confused on why MIPS cannot use kvm_flush_remote_tlbs() to flush TLBs.
> I know nothing about MIPS code, but IIUC here flush_shadow_memslot()
> is a heavier operation that will also invalidate the shadow pages.
> Seems to be an overkill here when we only changed write permission of
> the PTEs?  I tried to check the first occurance (2a31b9db15353) but I
> didn't find out any clue of it so far.
> 
> But that matters to this patch because if MIPS can use
> kvm_flush_remote_tlbs(), then we probably don't need this
> arch-specific hook any more and we can directly call
> kvm_flush_remote_tlbs() after sync dirty log when flush==true.

Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
that prevents calling kvm_flush_remote_tlbs() directly, but I have no
clue as to the important of that code.

> >  }
> >  
> >  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> > diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> > index 97ce6c4f7b48..0adaf4791a6d 100644
> > --- a/arch/powerpc/kvm/book3s.c
> > +++ b/arch/powerpc/kvm/book3s.c
> > @@ -799,6 +799,11 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
> >  	return vcpu->kvm->arch.kvm_ops->check_requests(vcpu);
> >  }
> >  
> > +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> 
> Since at it, maybe we can start to use __weak attribute for new hooks
> especially when it's empty for most archs?
> 
> E.g., define:
> 
> void __weak kvm_arch_sync_dirty_log(...) {}
> 
> In the common code, then only define it again in arch that has
> non-empty implementation of this method?

I defer to Paolo, I'm indifferent at this stage.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
