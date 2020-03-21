Return-Path: <SRS0=E1LH=5G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0F5C41621
	for <kvmarm@archiver.kernel.org>; Sat, 21 Mar 2020 20:26:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9AD7A208C3
	for <kvmarm@archiver.kernel.org>; Sat, 21 Mar 2020 20:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AD7A208C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9464B0B3;
	Sat, 21 Mar 2020 16:26:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IHGrWy9Xp-mX; Sat, 21 Mar 2020 16:26:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E84BB4B0B4;
	Sat, 21 Mar 2020 16:26:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CB1D4B0A4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Mar 2020 16:26:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uRy3IsKH8QT1 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 21 Mar 2020 16:26:06 -0400 (EDT)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B20464AF1F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Mar 2020 16:26:06 -0400 (EDT)
IronPort-SDR: UP07CV7Sw1+yJiyWc2CjZDndwbpaSccvlmo+O6MxOUG+I1naOqu/MXwJxTwhYA45XtOJSrrKDJ
 OtH1UylORj/A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 21 Mar 2020 13:26:04 -0700
IronPort-SDR: wc7DG86xh4vPeKd3LZfA/TbWv8x9O/HuKQW/jGF3O4aUFN/qKwYCQ8SRM7iJWo2KoQnsDSJboM
 NHtSa3M5ZLog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; d="scan'208";a="280773532"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by fmsmga002.fm.intel.com with ESMTP; 21 Mar 2020 13:26:04 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 0/9]  KVM: Move x86 init ops to separate struct
Date: Sat, 21 Mar 2020 13:25:54 -0700
Message-Id: <20200321202603.19355-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

The non-x86 part of this series is wholly contained in patch 01.  Compared
to other recent kvm-wide changes, this one is very straightforward (famous
last words).

Like a few other architectures, e.g. PPC, x86 uses a set of global hooks
to call back into vendor code on demand.  A handlful of the x86 hooks are
used only within the scope of kvm_init().  This series moves the init-only
hooks to a separate struct, partly to clean up the code a bit, but mainly
so that the runtime hooks can be made available only after the x86 vendor
has completed its ->hardware_setup().  While working on a different series
I spent a fair bit of time scratching my as to why a kvm_x86_ops wasn't
working, and eventually realized VMX's callback wasn't "ready" because the
vmcs_config hadn't yet been populated.

Due to lack of a cross-compiling setup, the non-x86 changes in patch 01
are untested.

v3:
 - Rebase to kvm/queue, d55c9d4009c7 ("KVM: nSVM: check for EFER ... ").
   Conflicts galore, but all mechanical in nature.
 - Drop an SVM patch that was obsoleted by kvm/queue.
 - Collect an ack. [Marc]

v2:
  - Rebase to kvm/queue, 2c2787938512 ("KVM: selftests: Stop ...")
  - Collect tags. [Cornelia]
  - Add a patch to make kvm_x86_ops its own instance and copy
    {vmx,svm}_x86_ops by value, which saves a memory access on every
    invocation of a kvm_x86_ops hook. [Paolo]
  - Add patches to tag {vmx,svm}_x86_ops as __initdata after they're
    copied by value.


Sean Christopherson (9):
  KVM: Pass kvm_init()'s opaque param to additional arch funcs
  KVM: x86: Move init-only kvm_x86_ops to separate struct
  KVM: VMX: Move hardware_setup() definition below vmx_x86_ops
  KVM: VMX: Configure runtime hooks using vmx_x86_ops
  KVM: x86: Set kvm_x86_ops only after ->hardware_setup() completes
  KVM: x86: Copy kvm_x86_ops by value to eliminate layer of indirection
  KVM: x86: Drop __exit from kvm_x86_ops' hardware_unsetup()
  KVM: VMX: Annotate vmx_x86_ops as __initdata
  KVM: SVM: Annotate svm_x86_ops as __initdata

 arch/mips/kvm/mips.c            |   4 +-
 arch/powerpc/kvm/powerpc.c      |   4 +-
 arch/s390/kvm/kvm-s390.c        |   4 +-
 arch/x86/include/asm/kvm_host.h |  33 +--
 arch/x86/kvm/cpuid.c            |   4 +-
 arch/x86/kvm/hyperv.c           |   8 +-
 arch/x86/kvm/kvm_cache_regs.h   |  10 +-
 arch/x86/kvm/lapic.c            |  30 +--
 arch/x86/kvm/mmu.h              |   8 +-
 arch/x86/kvm/mmu/mmu.c          |  32 +--
 arch/x86/kvm/pmu.c              |  30 +--
 arch/x86/kvm/pmu.h              |   2 +-
 arch/x86/kvm/svm.c              |  19 +-
 arch/x86/kvm/trace.h            |   4 +-
 arch/x86/kvm/vmx/nested.c       |  17 +-
 arch/x86/kvm/vmx/nested.h       |   3 +-
 arch/x86/kvm/vmx/vmx.c          | 371 ++++++++++++++++----------------
 arch/x86/kvm/x86.c              | 370 +++++++++++++++----------------
 arch/x86/kvm/x86.h              |   4 +-
 include/linux/kvm_host.h        |   4 +-
 virt/kvm/arm/arm.c              |   4 +-
 virt/kvm/kvm_main.c             |  18 +-
 22 files changed, 507 insertions(+), 476 deletions(-)

-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
