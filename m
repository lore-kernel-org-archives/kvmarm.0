Return-Path: <SRS0=7egO=ZM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9168C432C3
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 11:53:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52CB7223D0
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 11:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52CB7223D0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B44154AEAB;
	Wed, 20 Nov 2019 06:53:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4fM00mZKNLaO; Wed, 20 Nov 2019 06:53:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BDE04AEAC;
	Wed, 20 Nov 2019 06:53:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B0C34AEA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 06:53:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 065l8h2IWWxB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Nov 2019 06:52:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A5DB4A5C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 06:52:19 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D83C328;
 Wed, 20 Nov 2019 03:52:18 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4E603F703;
 Wed, 20 Nov 2019 03:52:17 -0800 (PST)
Date: Wed, 20 Nov 2019 12:52:16 +0100
From: Christoffer Dall <christoffer.dall@arm.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: Memory regions and VMAs across architectures
Message-ID: <20191120115216.GL8317@e113682-lin.lund.arm.com>
References: <20191108111920.GD17608@e113682-lin.lund.arm.com>
 <20191120034448.GC25890@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191120034448.GC25890@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, borntraeger@de.ibm.com,
 Ard Biesheuvel <ard.biesheuvel@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Nov 19, 2019 at 07:44:48PM -0800, Sean Christopherson wrote:
> On Fri, Nov 08, 2019 at 12:19:20PM +0100, Christoffer Dall wrote:
> > Hi,
> > 
> > I had a look at our relatively complicated logic in
> > kvm_arch_prepare_memory_region(), and was wondering if there was room to
> > unify some of this handling between architectures.
> > 
> > (If you haven't seen our implementation, you can find it in
> > virt/kvm/arm/mmu.c, and it has lovely ASCII art!)
> > 
> > I then had a look at the x86 code, but that doesn't actually do anything
> > when creating memory regions, which makes me wonder why the arhitectures
> > differ in this aspect.
> > 
> > The reason we added the logic that we have for arm/arm64 is that we
> > don't really want to take faults for I/O accesses.  I'm not actually
> > sure if this is a corretness thing, or an optimization effort, and the
> > original commit message doesn't really explain.  Ard, you wrote that
> > code, do you recall the details?
> > 
> > In any case, what we do is to check for each VMA backing a memslot, we
> > check if the memslot flags and vma flags are a reasonable match, and we
> > try to detect I/O mappings by looking for the VM_PFNMAP flag on the VMA
> > and pre-populate stage 2 page tables (our equivalent of EPT/NPT/...).
> > However, there are some things which are not clear to me:
> > 
> > First, what prevents user space from messing around with the VMAs after
> > kvm_arch_prepare_memory_region() completes?  If nothing, then what is
> > the value of the cheks we perform wrt. to VMAs?
> 
> Arm's prepare_memory_region() holds mmap_sem and mmu_lock while processing
> the VMAs and populating the stage 2 page tables.  Holding mmap_sem prevents
> the VMAs from being invalidated while the stage 2 tables are populated,
> e.g. prevents racing with the mmu notifier.  The VMAs could be modified
> after prepare_memory_region(), but the mmu notifier will ensure they are
> unmapped from stage2 prior the the host change taking effect.  So I think
> you're safe (famous last words).
> 

So we for example check:

	writeable = !(memslot->falgs & KVM_MEM_READONLY);
	if (writeable && !(vma->vm_flags & VM_WRITE))
		return -EPERM;

And yes, user space can then unmap the VMAs and MMU notifiers will
unmap the stage 2 entries, but user space can then create a new
read-only VMA covering the area of the memslot and the fault-handling
path will have to deal with this same check later.  Only, the fault
handling path, via gfn_to_pfn_prot(), returns an address based on an
entirely different set of mechanics, than our prepare_memory_region,
which I think indicates we are doing something wrong somewhere, and we
should have a common path for faulting things in, for I/O, both if we do
this up-front or if we do this at fault time.


> > Second, why would arm/arm64 need special handling for I/O mappings
> > compared to other architectures, and how is this dealt with for
> > x86/s390/power/... ?
> 
> As Ard mentioned, it looks like an optimization.  The "passthrough"
> part from the changelog implies that VM_PFNMAP memory regions are exclusive
> to the guest.  Mapping the entire thing would be a nice boot optimization
> as it would save taking page faults on every page of the MMIO region.
> 
> As for how this is different from other archs... at least on x86, VM_PFNMAP
> isn't guaranteed to be passthrough or even MMIO, e.g. prefaulting the
> pages may actually trigger allocation, and remapping the addresses could be
> flat out wrong.

What does VM_PFNMAP mean on x86?  I didn't think we were relying on
anything architecture specific in their meaning in the arm code, and I
thought the VM_PFNMAP was a generic mm flag with generic mm meaning,
but I could be wrong here?

Is there any valid semantics for creating a memslot backed by a
VM_PFNMAP on x86, and if so, what are those?

Similarly, if you do map a device region straight to the guest on x86,
how is that handled?  (A pointer to the right place in the myriad of EPT
and shadow code in x86 would be much appreciated.)


Thanks!

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
