From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 00/18] arm/arm64: KVM: Merge boot and runtime page tables
Date: Thu, 30 Jun 2016 18:40:33 +0100
Message-ID: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83A2349B5A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dkI5bflGYBnV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 13:35:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 431DA49B54
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:43 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Until now, we've been setting up KVM using two sets of page tables:
one for the "boot" where we perform the basic MMU setup, and one for
the runtime.

Switching between the two was though to be safe, but we've recently
realized that it is not: it is not enough to ensure that the VA->PA
mapping is consistent when switching TTBR0_EL2, but we also have to
ensure that the intermediate translations are the same as well. If the
TLB can return two different values for intermediate translations,
we're screwed (TLB conflicts).

At that point, the only safe thing to do is to never change TTBR0_EL2,
which means that we need to make the idmap page part of the runtime
page tables.

The series starts with a bit of brain dumping explaining what we're
trying to do. This might not be useful as a merge candidate, but it
was useful for me to put this somewhere. It goes on revamping the
whole notion of HYP VA range, making it runtime patchable. It then
always merge idmap and runtime page table into one set, leading to
quite a lot of simplification in the init/teardown code. In the
process, 32bit KVM gains the ability to teardown the HYP page-tables
and vectors, which makes kexec a bit closer.

This has been tested on Seattle, Juno, the FVP model (both v8.0 and
v8.1), Cubietruck and Midway, and is based on the current
kvmarm/queue.

Thanks,

	M.

* From v1:
  - Small changes to documentation patch, thanks to Christoffer
  - Removed hyp_kern_va altogether
  - Removed KERN_TO_HYP and used kern_hyp_va everywhere
  - Rebased on top of kvmarm/queue as of today

Marc Zyngier (18):
  arm64: KVM: Merged page tables documentation
  arm64: KVM: Always reference __hyp_panic_string via its kernel VA
  arm/arm64: KVM: Remove hyp_kern_va helper
  arm64: KVM: Kill HYP_PAGE_OFFSET
  arm64: Add ARM64_HYP_OFFSET_LOW capability
  arm64: KVM: Define HYP offset masks
  arm64: KVM: Refactor kern_hyp_va to deal with multiple offsets
  arm/arm64: KVM: Export __hyp_text_start/end symbols
  arm64: KVM: Runtime detection of lower HYP offset
  arm/arm64: KVM: Always have merged page tables
  arm64: KVM: Simplify HYP init/teardown
  arm/arm64: KVM: Drop boot_pgd
  arm/arm64: KVM: Kill free_boot_hyp_pgd
  arm: KVM: Simplify HYP init
  arm: KVM: Allow hyp teardown
  arm/arm64: KVM: Prune unused #defines
  arm/arm64: KVM: Check that IDMAP doesn't intersect with VA range
  arm/arm64: Get rid of KERN_TO_HYP

 arch/arm/include/asm/kvm_asm.h      |   2 +
 arch/arm/include/asm/kvm_host.h     |  25 +++----
 arch/arm/include/asm/kvm_hyp.h      |   3 -
 arch/arm/include/asm/kvm_mmu.h      |  13 +---
 arch/arm/include/asm/virt.h         |   4 ++
 arch/arm/kvm/arm.c                  |  20 ++----
 arch/arm/kvm/init.S                 |  56 ++++++---------
 arch/arm/kvm/mmu.c                  | 137 ++++++++++++++++--------------------
 arch/arm64/include/asm/cpufeature.h |   3 +-
 arch/arm64/include/asm/kvm_host.h   |  17 ++---
 arch/arm64/include/asm/kvm_hyp.h    |  23 ------
 arch/arm64/include/asm/kvm_mmu.h    |  94 ++++++++++++++++++++-----
 arch/arm64/include/asm/virt.h       |   4 ++
 arch/arm64/kernel/cpufeature.c      |  19 +++++
 arch/arm64/kvm/hyp-init.S           |  61 +++-------------
 arch/arm64/kvm/hyp/entry.S          |  19 -----
 arch/arm64/kvm/hyp/hyp-entry.S      |  15 ++++
 arch/arm64/kvm/hyp/switch.c         |  11 ++-
 arch/arm64/kvm/reset.c              |  28 --------
 19 files changed, 238 insertions(+), 316 deletions(-)

-- 
2.1.4
