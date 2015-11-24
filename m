From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/8] KVM/ARM Fixes for v4.4-rc3
Date: Tue, 24 Nov 2015 18:35:28 +0100
Message-ID: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38CA3412C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OuomncOIOPrs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 12:34:18 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40001411F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:17 -0500 (EST)
Received: by wmww144 with SMTP id w144so36427234wmw.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 09:35:16 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

Here's a set of fixes for KVM/ARM for v4.4-rc3 based on v4.4-rc2, because the
errata fixes don't apply on v4.4-rc1.  Let me know if you can pull this anyhow.

Thanks,
-Christoffer

The following changes since commit 1ec218373b8ebda821aec00bb156a9c94fad9cd4:

  Linux 4.4-rc2 (2015-11-22 16:45:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.4-rc3

for you to fetch changes up to fbb4574ce9a37e15a9872860bf202f2be5bdf6c4:

  arm64: kvm: report original PAR_EL1 upon panic (2015-11-24 18:20:58 +0100)

----------------------------------------------------------------
KVM/ARM Fixes for v4.4-rc3.

Includes some timer fixes, properly unmapping PTEs, an errata fix, and two
tweaks to the EL2 panic code.

----------------------------------------------------------------
Ard Biesheuvel (1):
      ARM/arm64: KVM: test properly for a PTE's uncachedness

Christoffer Dall (3):
      KVM: arm/arm64: Fix preemptible timer active state crazyness
      KVM: arm/arm64: arch_timer: Preserve physical dist. active state on LR.active
      KVM: arm/arm64: vgic: Trust the LR state for HW IRQs

Marc Zyngier (2):
      arm64: KVM: Fix AArch32 to AArch64 register mapping
      arm64: KVM: Add workaround for Cortex-A57 erratum 834220

Mark Rutland (2):
      arm64: kvm: avoid %p in __kvm_hyp_panic
      arm64: kvm: report original PAR_EL1 upon panic

 arch/arm/kvm/arm.c                   |  7 +----
 arch/arm/kvm/mmu.c                   | 15 +++++------
 arch/arm64/Kconfig                   | 21 +++++++++++++++
 arch/arm64/include/asm/cpufeature.h  |  3 ++-
 arch/arm64/include/asm/kvm_emulate.h |  8 +++---
 arch/arm64/kernel/cpu_errata.c       |  9 +++++++
 arch/arm64/kvm/hyp.S                 | 14 ++++++++--
 arch/arm64/kvm/inject_fault.c        |  2 +-
 include/kvm/arm_vgic.h               |  2 +-
 virt/kvm/arm/arch_timer.c            | 28 ++++++++++++--------
 virt/kvm/arm/vgic.c                  | 50 +++++++++++++++++-------------------
 11 files changed, 100 insertions(+), 59 deletions(-)
