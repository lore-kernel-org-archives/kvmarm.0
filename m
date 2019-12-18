Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527A8C4741C
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:55:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11C6624688
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 21:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11C6624688
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADDD84A586;
	Wed, 18 Dec 2019 16:55:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mUdVYVzsxFeM; Wed, 18 Dec 2019 16:55:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AD464A982;
	Wed, 18 Dec 2019 16:55:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CA434A5A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DsO8JqZDMiI1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 16:55:33 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77AB24A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 16:55:33 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Dec 2019 13:55:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; d="scan'208";a="222107997"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:31 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 00/45]  KVM: Refactor vCPU creation
Date: Wed, 18 Dec 2019 13:54:45 -0800
Message-Id: <20191218215530.2280-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Cc: kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
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

The end goal of this series is to strip down the interface between common
KVM code and arch specific code so that there is precisely one arch hook
for creating a vCPU and one hook for destroying a vCPU.  In addition to
cleaning up the code base, simplifying the interface gives architectures
more freedom to organize their vCPU creation code.  Details below.

v2:
  - Rebase to commit e41a90be9659 ("KVM: x86/mmu: WARN if root_hpa is
    invalid when handling a page fault").  A few minor x86 (VMX) conflicts,
    and one straightforward arm conflict with commit 8564d6372a7d ("KVM:
    arm64: Support stolen time reporting via shared structure") in patch
    "KVM: ARM: Move all vcpu init code into kvm_arch_vcpu_create()".
  - Collect Reviews and Acks [Christoffer, Greg].
  - Fix a warning in "KVM: arm64: Free sve_state via arm specific hook"
    by using a "void" return type [Christoffer].
  - Fix a bug in "KVM: PPC: Move kvm_vcpu_init() invocation to common code"
    where the call in kvmppc_core_vcpu_create_e500mc() was inadvertantly
    left behind.


KVM's vCPU creation code is comically messy.  kvm_vm_ioctl_create_vcpu()
calls three separate arch hooks: init(), create() and setup().  The init()
call is especially nasty as it's hidden away in a common KVM function,
kvm_init_vcpu(), that for all intents and purposes must be immediately
invoked after the vcpu object is allocated.

Not to be outdone, vCPU destruction also has three arch hooks: uninit(),
destroy() and free(), the latter of which isn't actually invoked by common
KVM code, but the hook declaration still exists because architectures are
relying on its forward declaration.

Eliminating the extra arch hooks is relatively straightforward, just
tedious.  For the most part, there is no fundamental constraint that
necessitated the proliferation of arch hooks, rather they crept in over
time, usually when x86-centric code was moved out of generic KVM and into
x86 code.

E.g. kvm_arch_vcpu_setup() was added to allow x86 to do vcpu_load(), which
can only be done after preempt_notifier initialization, but adding setup()
overlooked the fact that the preempt_notifier was only initialized after
kvm_arch_vcpu_create() because preemption support was added when x86's MMU
setup (the vcpu_load() user) was called from common KVM code.

For all intents and purposes, there is no true functional change in this
series.  The order of some allocations will change, and a few memory leaks
are fixed, but the actual functionality of a guest should be unaffected.

Patches 01-03 are bug fixes in error handling paths that were found by
inspection when refactoring the associated code.

Patches 04-43 refactor each arch implementation so that the unwanted arch
hooks can be dropped without a functional change, e.g. move code out of
kvm_arch_vcpu_setup() so that all implementations are empty, then drop the
functions and caller.

Patches 44-45 are minor clean up to eliminate kvm_vcpu_uninit().

The net result is to go from this:

        vcpu = kvm_arch_vcpu_create(kvm, id);
               |
               |-> kvm_vcpu_init()
                   |
                   |-> kvm_arch_vcpu_init()

        if (IS_ERR(vcpu)) {
                r = PTR_ERR(vcpu);
                goto vcpu_decrement;
        }

        preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);

        r = kvm_arch_vcpu_setup(vcpu);
        if (r)
                goto vcpu_destroy;


Sean Christopherson (45):
  KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
  KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
  KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
  KVM: VMX: Allocate VPID after initializing VCPU
  KVM: VMX: Use direct vcpu pointer during vCPU create/free
  KVM: SVM: Use direct vcpu pointer during vCPU create/free
  KVM: x86: Allocate vcpu struct in common x86 code
  KVM: x86: Move FPU allocation to common x86 code
  KVM: x86: Move allocation of pio_data page down a few lines
  KVM: x86: Move kvm_vcpu_init() invocation to common code
  KVM: PPC: e500mc: Add build-time assert that vcpu is at offset 0
  KVM: PPC: Allocate vcpu struct in common PPC code
  KVM: PPC: Book3S PR: Allocate book3s and shadow vcpu after common init
  KVM: PPC: e500mc: Move reset of oldpir below call to kvm_vcpu_init()
  KVM: PPC: Move kvm_vcpu_init() invocation to common code
  KVM: MIPS: Use kvm_vcpu_cache to allocate vCPUs
  KVM: MIPS: Drop kvm_arch_vcpu_free()
  KVM: PPC: Drop kvm_arch_vcpu_free()
  KVM: arm: Drop kvm_arch_vcpu_free()
  KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path
  KVM: x86: Remove spurious clearing of async #PF MSR
  KVM: x86: Drop kvm_arch_vcpu_free()
  KVM: Remove kvm_arch_vcpu_free() declaration
  KVM: Add kvm_arch_vcpu_precreate() to handle pre-allocation issues
  KVM: s390: Move guts of kvm_arch_vcpu_init() into
    kvm_arch_vcpu_create()
  KVM: s390: Invoke kvm_vcpu_init() before allocating sie_page
  KVM: MIPS: Invoke kvm_vcpu_uninit() immediately prior to freeing vcpu
  KVM: x86: Invoke kvm_vcpu_uninit() immediately prior to freeing vcpu
  KVM: Introduce kvm_vcpu_destroy()
  KVM: Move vcpu alloc and init invocation to common code
  KVM: Unexport kvm_vcpu_cache and kvm_vcpu_{un}init()
  KVM: Move initialization of preempt notifier to kvm_vcpu_init()
  KVM: x86: Move guts of kvm_arch_vcpu_setup() into
    kvm_arch_vcpu_create()
  KVM: MIPS: Move .vcpu_setup() call to kvm_arch_vcpu_create()
  KVM: s390: Manually invoke vcpu setup during kvm_arch_vcpu_create()
  KVM: PPC: BookE: Setup vcpu during kvmppc_core_vcpu_create()
  KVM: Drop kvm_arch_vcpu_setup()
  KVM: x86: Move all vcpu init code into kvm_arch_vcpu_create()
  KVM: MIPS: Move all vcpu init code into kvm_arch_vcpu_create()
  KVM: ARM: Move all vcpu init code into kvm_arch_vcpu_create()
  KVM: PPC: Move all vcpu init code into kvm_arch_vcpu_create()
  KVM: arm64: Free sve_state via arm specific hook
  KVM: Drop kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit()
  KVM: Move putting of vcpu->pid to kvm_vcpu_destroy()
  KVM: Move vcpu->run page allocation out of kvm_vcpu_init()

 arch/arm/include/asm/kvm_host.h    |   2 +-
 arch/arm/kvm/guest.c               |   5 -
 arch/arm64/include/asm/kvm_host.h  |   2 +-
 arch/arm64/kvm/guest.c             |   5 -
 arch/arm64/kvm/reset.c             |   2 +-
 arch/mips/kvm/mips.c               |  84 ++++-------
 arch/powerpc/include/asm/kvm_ppc.h |   6 +-
 arch/powerpc/kvm/book3s.c          |   9 +-
 arch/powerpc/kvm/book3s_hv.c       |  27 +---
 arch/powerpc/kvm/book3s_pr.c       |  33 ++---
 arch/powerpc/kvm/booke.c           |  65 ++++----
 arch/powerpc/kvm/e500.c            |  34 +----
 arch/powerpc/kvm/e500mc.c          |  28 +---
 arch/powerpc/kvm/powerpc.c         |  70 ++++-----
 arch/s390/include/asm/kvm_host.h   |   1 -
 arch/s390/kvm/kvm-s390.c           | 110 +++++++-------
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/svm.c                 |  52 +------
 arch/x86/kvm/vmx/vmx.c             |  72 +++------
 arch/x86/kvm/x86.c                 | 230 ++++++++++++++---------------
 include/linux/kvm_host.h           |  13 +-
 virt/kvm/arm/arm.c                 |  80 ++++------
 virt/kvm/kvm_main.c                |  71 +++++----
 23 files changed, 385 insertions(+), 618 deletions(-)

-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
