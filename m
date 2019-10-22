Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F58CA9EA0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 11:52:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7567C21783
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 11:52:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7567C21783
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D017A4A8B7;
	Tue, 22 Oct 2019 07:52:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hj06UV1m09W0; Tue, 22 Oct 2019 07:52:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EDAC4A80E;
	Tue, 22 Oct 2019 07:52:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0250F4A5C8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:52:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7sO3nlnkbyYZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 07:52:14 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D28C4A5A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:52:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11D8F1045;
 Tue, 22 Oct 2019 04:51:54 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98A073F71F;
 Tue, 22 Oct 2019 04:51:53 -0700 (PDT)
Date: Tue, 22 Oct 2019 13:51:52 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 00/45] KVM: Refactor vCPU creation
Message-ID: <20191022115152.GC2652@e113682-lin.lund.arm.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Hi Sean,

On Mon, Oct 21, 2019 at 06:58:40PM -0700, Sean Christopherson wrote:
> *************************** DISCLAIMER **********************************
> The non-x86 arch specific patches are completely untested.  Although the
> changes are conceptually straightforward, I'm not remotely confident that
> the patches are bug free, e.g. checkpatch caught several blatant typos
> that would break compilation.
> *************************************************************************
> 
> The end goal of this series is to strip down the interface between common
> KVM code and arch specific code so that there is precisely one arch hook
> for creating a vCPU and one hook for destroying a vCPU.  In addition to
> cleaning up the code base, simplifying the interface gives architectures
> more freedom to organize their vCPU creation code.
> 
> KVM's vCPU creation code is comically messy.  kvm_vm_ioctl_create_vcpu()
> calls three separate arch hooks: init(), create() and setup().  The init()
> call is especially nasty as it's hidden away in a common KVM function,
> kvm_init_vcpu(), that for all intents and purposes must be immediately
> invoked after the vcpu object is allocated.
> 
> Not to be outdone, vCPU destruction also has three arch hooks: uninit(),
> destroy() and free(), the latter of which isn't actually invoked by common
> KVM code, but the hook declaration still exists because architectures are
> relying on its forward declaration.
> 
> Eliminating the extra arch hooks is relatively straightforward, just
> tedious.  For the most part, there is no fundamental constraint that
> necessitated the proliferation of arch hooks, rather they crept in over
> time, usually when x86-centric code was moved out of generic KVM and into
> x86 code.
> 
> E.g. kvm_arch_vcpu_setup() was added to allow x86 to do vcpu_load(), which
> can only be done after preempt_notifier initialization, but adding setup()
> overlooked the fact that the preempt_notifier was only initialized after
> kvm_arch_vcpu_create() because preemption support was added when x86's MMU
> setup (the vcpu_load() user) was called from common KVM code.
> 
> For all intents and purposes, there is no true functional change in this
> series.  The order of some allocations will change, and a few memory leaks
> are fixed, but the actual functionality of a guest should be unaffected.
> 
> Patches 01-03 are bug fixes in error handling paths that were found by
> inspection when refactoring the associated code.
> 
> Patches 04-43 refactor each arch implementation so that the unwanted arch
> hooks can be dropped without a functional change, e.g. move code out of
> kvm_arch_vcpu_setup() so that all implementations are empty, then drop the
> functions and caller.
> 
> Patches 44-45 are minor clean up to eliminate kvm_vcpu_uninit().
> 
> 
> The net result is to go from this:
> 
>         vcpu = kvm_arch_vcpu_create(kvm, id);
>                |
>                |-> kvm_vcpu_init()
>                    |
>                    |-> kvm_arch_vcpu_init()
> 
>         if (IS_ERR(vcpu)) {
>                 r = PTR_ERR(vcpu);
>                 goto vcpu_decrement;
>         }
> 
>         preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
> 
>         r = kvm_arch_vcpu_setup(vcpu);
>         if (r)
>                 goto vcpu_destroy;
> 
> to this:
> 
>         r = kvm_arch_vcpu_precreate(kvm, id);
>         if (r)
>                 goto vcpu_decrement;
> 
>         vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
>         if (!vcpu) {
>                 r = -ENOMEM;
>                 goto vcpu_decrement;
>         }
> 
>         page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>         if (!page) {
>                 r = -ENOMEM;
>                 goto vcpu_free;
>         }
>         vcpu->run = page_address(page);
> 
>         kvm_vcpu_init(vcpu, kvm, id);
> 
>         r = kvm_arch_vcpu_create(vcpu);
>         if (r)
>                 goto vcpu_free_run_page;
> 

What a fantastically welcome piece of work!  Thanks for doing this,
many's the time I waded through all those calls to ensure a patch was
doing the right thing.

Modulo the nit in patch 42, the arm64 changes survive a guest boot +
hackbench and build fine.  The lack of changing the arm-specific destroy
function to a void also causes a series of warnings for a 32-bit arm
build, but otherwise builds fine.

You can add my:

  Acked-by: Christoffer Dall <christoffer.dall@arm.com>

To the arm/arm64 and generic parts.


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
