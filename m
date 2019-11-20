Return-Path: <SRS0=7egO=ZM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB4BC432C0
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 03:44:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10BEA2244A
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 03:44:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10BEA2244A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BF2F4A5A6;
	Tue, 19 Nov 2019 22:44:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GFT806q9j-bM; Tue, 19 Nov 2019 22:44:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 808A64A8E8;
	Tue, 19 Nov 2019 22:44:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CAE04A5BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Nov 2019 22:44:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 13QAYyRWMkc1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Nov 2019 22:44:51 -0500 (EST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E6E44A5A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Nov 2019 22:44:51 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 19 Nov 2019 19:44:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,220,1571727600"; d="scan'208";a="204597622"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.41])
 by fmsmga008.fm.intel.com with ESMTP; 19 Nov 2019 19:44:48 -0800
Date: Tue, 19 Nov 2019 19:44:48 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: Memory regions and VMAs across architectures
Message-ID: <20191120034448.GC25890@linux.intel.com>
References: <20191108111920.GD17608@e113682-lin.lund.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191108111920.GD17608@e113682-lin.lund.arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
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

On Fri, Nov 08, 2019 at 12:19:20PM +0100, Christoffer Dall wrote:
> Hi,
> 
> I had a look at our relatively complicated logic in
> kvm_arch_prepare_memory_region(), and was wondering if there was room to
> unify some of this handling between architectures.
> 
> (If you haven't seen our implementation, you can find it in
> virt/kvm/arm/mmu.c, and it has lovely ASCII art!)
> 
> I then had a look at the x86 code, but that doesn't actually do anything
> when creating memory regions, which makes me wonder why the arhitectures
> differ in this aspect.
> 
> The reason we added the logic that we have for arm/arm64 is that we
> don't really want to take faults for I/O accesses.  I'm not actually
> sure if this is a corretness thing, or an optimization effort, and the
> original commit message doesn't really explain.  Ard, you wrote that
> code, do you recall the details?
> 
> In any case, what we do is to check for each VMA backing a memslot, we
> check if the memslot flags and vma flags are a reasonable match, and we
> try to detect I/O mappings by looking for the VM_PFNMAP flag on the VMA
> and pre-populate stage 2 page tables (our equivalent of EPT/NPT/...).
> However, there are some things which are not clear to me:
> 
> First, what prevents user space from messing around with the VMAs after
> kvm_arch_prepare_memory_region() completes?  If nothing, then what is
> the value of the cheks we perform wrt. to VMAs?

Arm's prepare_memory_region() holds mmap_sem and mmu_lock while processing
the VMAs and populating the stage 2 page tables.  Holding mmap_sem prevents
the VMAs from being invalidated while the stage 2 tables are populated,
e.g. prevents racing with the mmu notifier.  The VMAs could be modified
after prepare_memory_region(), but the mmu notifier will ensure they are
unmapped from stage2 prior the the host change taking effect.  So I think
you're safe (famous last words).

> Second, why would arm/arm64 need special handling for I/O mappings
> compared to other architectures, and how is this dealt with for
> x86/s390/power/... ?

As Ard mentioned, it looks like an optimization.  The "passthrough"
part from the changelog implies that VM_PFNMAP memory regions are exclusive
to the guest.  Mapping the entire thing would be a nice boot optimization
as it would save taking page faults on every page of the MMIO region.

As for how this is different from other archs... at least on x86, VM_PFNMAP
isn't guaranteed to be passthrough or even MMIO, e.g. prefaulting the
pages may actually trigger allocation, and remapping the addresses could be
flat out wrong.


  commit 8eef91239e57d2e932e7470879c9a504d5494ebb
  Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
  Date:   Fri Oct 10 17:00:32 2014 +0200

    arm/arm64: KVM: map MMIO regions at creation time

    There is really no point in faulting in memory regions page by page
    if they are not backed by demand paged system RAM but by a linear
    passthrough mapping of a host MMIO region. So instead, detect such
    regions at setup time and install the mappings for the backing all
    at once.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
