Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FE6CA9EA0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 18:41:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 507552184C
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 18:41:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 507552184C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3514A990;
	Tue, 22 Oct 2019 14:41:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I73bTcngWGsf; Tue, 22 Oct 2019 14:41:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F3534A993;
	Tue, 22 Oct 2019 14:41:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72A4A4A98F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 14:41:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VE-nNjzZI8SF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 14:41:42 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C39984A98E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 14:41:41 -0400 (EDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 22 Oct 2019 11:41:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; d="scan'208";a="222915653"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.41])
 by fmsmga004.fm.intel.com with ESMTP; 22 Oct 2019 11:41:39 -0700
Date: Tue, 22 Oct 2019 11:41:39 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 42/45] KVM: arm64: Free sve_state via arm specific hook
Message-ID: <20191022184139.GK2343@linux.intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
 <20191022015925.31916-43-sean.j.christopherson@intel.com>
 <20191022114342.GB2652@e113682-lin.lund.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191022114342.GB2652@e113682-lin.lund.arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 James Hogan <jhogan@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Tue, Oct 22, 2019 at 01:43:42PM +0200, Christoffer Dall wrote:
> On Mon, Oct 21, 2019 at 06:59:22PM -0700, Sean Christopherson wrote:
> > Add an arm specific hook to free the arm64-only sve_state.  Doing so
> > eliminates the last functional code from kvm_arch_vcpu_uninit() across
> > all architectures and paves the way for removing kvm_arch_vcpu_init()
> > and kvm_arch_vcpu_uninit() entirely.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   | 1 +
> >  arch/arm64/include/asm/kvm_host.h | 1 +
> >  arch/arm64/kvm/reset.c            | 5 +++++
> >  virt/kvm/arm/arm.c                | 2 ++
> >  4 files changed, 9 insertions(+)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 8a37c8e89777..cc414de5acd3 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -333,6 +333,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> >  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> >  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> > +static inline int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu) {}
> >  
> >  static inline void kvm_arm_init_debug(void) {}
> >  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f656169db8c3..92d7c384a4ed 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -52,6 +52,7 @@ int kvm_arm_init_sve(void);
> >  
> >  int __attribute_const__ kvm_target_cpu(void);
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> > +int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
> >  int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
> >  void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index f4a8ae918827..98abc4278f42 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -205,6 +205,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
> >  }
> >  
> >  void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
> > +{
> > +
> > +}
> > +
> > +int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  {
> >  	kfree(vcpu->arch.sve_state);
> >  }
> 
> nit: warning: control reaches end of non-void function

Doh, fixed.  Thanks for the quick review!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
