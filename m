Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632ECC5DF60
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 11:19:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E942F21848
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 11:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E942F21848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B3E24ACD7;
	Fri,  8 Nov 2019 06:19:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tiJFoZD3H5cE; Fri,  8 Nov 2019 06:19:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39DD24ACF2;
	Fri,  8 Nov 2019 06:19:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 104DA4ACA0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 06:19:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vqp7zSwMyZp3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 06:19:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 063914A51E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 06:19:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8ADA631B;
 Fri,  8 Nov 2019 03:19:22 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DEB53F719;
 Fri,  8 Nov 2019 03:19:21 -0800 (PST)
Date: Fri, 8 Nov 2019 12:19:20 +0100
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvm@vger.kernel.org
Subject: Memory regions and VMAs across architectures
Message-ID: <20191108111920.GD17608@e113682-lin.lund.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, sean.j.christopherson@intel.com,
 borntraeger@de.ibm.com, Ard Biesheuvel <ard.biesheuvel@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi,

I had a look at our relatively complicated logic in
kvm_arch_prepare_memory_region(), and was wondering if there was room to
unify some of this handling between architectures.

(If you haven't seen our implementation, you can find it in
virt/kvm/arm/mmu.c, and it has lovely ASCII art!)

I then had a look at the x86 code, but that doesn't actually do anything
when creating memory regions, which makes me wonder why the arhitectures
differ in this aspect.

The reason we added the logic that we have for arm/arm64 is that we
don't really want to take faults for I/O accesses.  I'm not actually
sure if this is a corretness thing, or an optimization effort, and the
original commit message doesn't really explain.  Ard, you wrote that
code, do you recall the details?

In any case, what we do is to check for each VMA backing a memslot, we
check if the memslot flags and vma flags are a reasonable match, and we
try to detect I/O mappings by looking for the VM_PFNMAP flag on the VMA
and pre-populate stage 2 page tables (our equivalent of EPT/NPT/...).
However, there are some things which are not clear to me:

First, what prevents user space from messing around with the VMAs after
kvm_arch_prepare_memory_region() completes?  If nothing, then what is
the value of the cheks we perform wrt. to VMAs?

Second, why would arm/arm64 need special handling for I/O mappings
compared to other architectures, and how is this dealt with for
x86/s390/power/... ?


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
