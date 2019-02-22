From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 06/14] KVM: arm/arm64: Factor out VMID into struct kvm_vmid
Date: Fri, 22 Feb 2019 12:14:16 +0000
Message-ID: <20190222121416.6ec76543@why.wild-wind.fr.eu.org>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
 <20190124140032.8588-7-christoffer.dall@arm.com>
 <1978ee57-c7bd-e55a-4e77-ad0b4b62d1d1@arm.com>
 <20190222091848.21f7f8e6@why.wild-wind.fr.eu.org>
 <44bd2df6-8011-c77f-a83a-95c3529287c0@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C3C24A32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 07:14:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ODLj24mtxhlx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 07:14:23 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE4774A2B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 07:14:22 -0500 (EST)
In-Reply-To: <44bd2df6-8011-c77f-a83a-95c3529287c0@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 22 Feb 2019 11:42:46 +0000
Julien Grall <julien.grall@arm.com> wrote:

> Hi Marc,
> 
> On 22/02/2019 09:18, Marc Zyngier wrote:
> > On Thu, 21 Feb 2019 11:02:56 +0000
> > Julien Grall <Julien.Grall@arm.com> wrote:
> > 
> > Hi Julien,
> >   
> >> Hi Christoffer,
> >>
> >> On 24/01/2019 14:00, Christoffer Dall wrote:  
> >>> Note that to avoid mapping the kvm_vmid_bits variable into hyp, we
> >>> simply forego the masking of the vmid value in kvm_get_vttbr and rely on
> >>> update_vmid to always assign a valid vmid value (within the supported
> >>> range).  
> >>
> >> [...]
> >>  
> >>> -	kvm->arch.vmid = kvm_next_vmid;
> >>> +	vmid->vmid = kvm_next_vmid;
> >>>    	kvm_next_vmid++;
> >>> -	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
> >>> -
> >>> -	/* update vttbr to be used with the new vmid */
> >>> -	pgd_phys = virt_to_phys(kvm->arch.pgd);
> >>> -	BUG_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm));
> >>> -	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
> >>> -	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid | cnp;
> >>> +	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;  
> >>
> >> The arm64 version of kvm_get_vmid_bits does not look cheap. Indeed it required
> >> to read the sanitized value of SYS_ID_AA64MMFR1_EL1 that is implemented using
> >> the function bsearch.
> >>
> >> So wouldn't it be better to keep kvm_vmid_bits variable for use in update_vttbr()?  
> > 
> > How often does this happen? Can you measure this overhead at all?
> > 
> > My understanding is that we hit this path on rollover only, having IPIed
> > all CPUs and invalidated all TLBs. I seriously doubt you can observe
> > any sort of overhead at all, given that it is so incredibly rare. But
> > feel free to prove me wrong!  
> 
> That would happen on roll-over and the first time you allocate VMID for the VM.
> 
> I am planning to run some test with 3-bit VMIDs and provide them next week.

Sure, but who implements 3 bit VMIDs? I'm only interested in
performance on real HW, and the minimal implementation allowed is
8bits.

So don't bother testing this with such contrived conditions. Test it
for real, on a system that can run enough stuff concurrently to quickly
exhaust its VMID space and provoke rollovers.

Alternatively, measure the time it takes to create a single VM that
exits immediately. On its own, that'd be a useful unit test for
extremely short-lived VMs.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
