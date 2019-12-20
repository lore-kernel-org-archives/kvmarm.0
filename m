Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5AFC2D0D2
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 15:53:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0004221D7E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 15:53:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0004221D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 576F64A523;
	Fri, 20 Dec 2019 10:53:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y+r+4sdVF4JQ; Fri, 20 Dec 2019 10:53:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A46B4A830;
	Fri, 20 Dec 2019 10:53:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5594A523
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 10:53:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qb4I-1kX9+fF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 10:53:32 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 726794A95D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 10:53:32 -0500 (EST)
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 20 Dec 2019 07:53:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,336,1571727600"; d="scan'208";a="222513815"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 20 Dec 2019 07:53:30 -0800
Date: Fri, 20 Dec 2019 07:53:30 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 30/45] KVM: Move vcpu alloc and init invocation to
 common code
Message-ID: <20191220155330.GA21021@linux.intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-31-sean.j.christopherson@intel.com>
 <20191220103325.34fc2bf0.cohuck@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191220103325.34fc2bf0.cohuck@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, James Hogan <jhogan@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Fri, Dec 20, 2019 at 10:33:25AM +0100, Cornelia Huck wrote:
> On Wed, 18 Dec 2019 13:55:15 -0800
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > +int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  {
> > -	struct kvm_vcpu *vcpu;
> >  	struct sie_page *sie_page;
> >  	int rc;
> >  
> > -	rc = -ENOMEM;
> > -
> > -	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> > -	if (!vcpu)
> > -		goto out;
> > -
> > -	rc = kvm_vcpu_init(vcpu, kvm, id);
> > -	if (rc)
> > -		goto out_free_cpu;
> > -
> > -	rc = -ENOMEM;
> > -
> >  	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
> >  	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
> >  	if (!sie_page)
> > -		goto out_uninit_vcpu;
> > +		return -ENOMEM;
> >  
> >  	vcpu->arch.sie_block = &sie_page->sie_block;
> >  	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
> > @@ -3087,15 +3070,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
> >  		 vcpu->arch.sie_block);
> >  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
> >  
> > -	return vcpu;
> > +	return 0;
> > +
> >  out_free_sie_block:
> >  	free_page((unsigned long)(vcpu->arch.sie_block));
> > -out_uninit_vcpu:
> > -	kvm_vcpu_uninit(vcpu);
> > -out_free_cpu:
> > -	kmem_cache_free(kvm_vcpu_cache, vcpu);
> > -out:
> > -	return ERR_PTR(rc);
> > +	return rc;
> 
> This is getting a bit hard to follow across the patches, but I think rc
> is now only set for ucontrol guests. So this looks correct right now,
> but feels a bit brittle... should we maybe init rc to 0 and always
> return rc instead?

Yes, but only for a few patches until kvm_s390_vcpu_setup() is introduced,
at which point @rc is unconditionally set at the end.

        rc = kvm_s390_vcpu_setup(vcpu);
        if (rc)
                goto out_free_ucontrol_gmap;
        return 0;

My personal preference is to use "return 0;" when the return is known to
be zero as it makes the success path obvious at a glance.  I also didn't
want to intialize @rc at he beginning because then the sie_page allocation
would look a bit funky:

	int rc = 0;

        BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
        sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
        if (!sie_page)
                return -ENOMEM;


An alternative would be to init @rc to -ENOMEM:

        int rc = -ENOMEM;

        BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
        sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
        if (!sie_page)
                return rc;

This would be my preference if you'd prefer to init @rc right away,
especially if  __kvm_ucontrol_vcpu_init() is open coded here (discussion
in patch 35, "KVM: s390: Manually invoke vcpu setup during 
kvm_arch_vcpu_create()", e.g.:

        int rc = -ENOMEM;

        BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
        sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
        if (!sie_page)
                return rc;

	...

        if (kvm_is_ucontrol(vcpu->kvm)) {
                vcpu->arch.gmap = gmap_create(current->mm, -1UL);
                if (!vcpu->arch.gmap)
                        goto out_free_sie_block;
                vcpu->arch.gmap->private = vcpu->kvm;
        }

        VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
                 vcpu->arch.sie_block);
        trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);

        rc = kvm_s390_vcpu_setup(vcpu);
        if (rc)
                goto out_free_ucontrol_gmap;
        return 0;

out_free_ucontrol_gmap:
        if (kvm_is_ucontrol(vcpu->kvm))
                gmap_remove(vcpu->arch.gmap);
out_free_sie_block:
        free_page((unsigned long)(vcpu->arch.sie_block));
        return rc;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
