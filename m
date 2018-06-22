From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/arm updates for 4.18-rc2
Date: Fri, 22 Jun 2018 13:49:45 +0100
Message-ID: <20180622124953.12355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 989D94A0DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jun 2018 08:38:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lM4SQrc1j5CB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jun 2018 08:38:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E2140192
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jun 2018 08:38:25 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, jia.he@hxt-semitech.com, Christian Borntraeger <borntraeger@de.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Radim, Paolo,

This is the first batch of fixes for 4.18, mostly dealing with the
fallout from Dave's lazy FPSIMD handling. We also have the disabling
of the compat interface on arm64 (it never had it the first place),
and a relaxation on the alignment of the GICv3 compatibility
interface.

Please pull.

	M.

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-4.18-1

for you to fetch changes up to 37b65db85f9b2fc98267eee4a18d7506492e6e8c:

  KVM: arm64: Prevent KVM_COMPAT from being selected (2018-06-21 17:17:50 +0100)

----------------------------------------------------------------
KVM/arm fixes for 4.18, take #1

- Lazy FPSIMD switching fixes
- Really disable compat ioctls on architectures that don't want it
- Disable compat on arm64 (it was never implemented...)
- Rely on architectural requirements for GICV on GICv3
- Detect bad alignments in unmap_stage2_range

----------------------------------------------------------------
Ard Biesheuvel (1):
      KVM: arm/arm64: Drop resource size check for GICV window

Dave Martin (3):
      KVM: arm64: Don't mask softirq with IRQs disabled in vcpu_put()
      KVM: arm64/sve: Fix SVE trap restoration for non-current tasks
      KVM: arm64: Avoid mistaken attempts to save SVE state for vcpus

Jia He (1):
      KVM: arm/arm64: add WARN_ON if size is not PAGE_SIZE aligned in unmap_stage2_range

Marc Zyngier (2):
      KVM: Enforce error in ioctl for compat tasks when !KVM_COMPAT
      KVM: arm64: Prevent KVM_COMPAT from being selected

Mark Rutland (1):
      arm64: Introduce sysreg_clear_set()

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/sysreg.h   | 11 +++++++++++
 arch/arm64/kvm/fpsimd.c           | 36 +++++++++++++++++++++++++++---------
 virt/kvm/Kconfig                  |  2 +-
 virt/kvm/arm/mmu.c                |  2 ++
 virt/kvm/arm/vgic/vgic-v3.c       |  5 -----
 virt/kvm/kvm_main.c               | 19 +++++++++----------
 7 files changed, 51 insertions(+), 25 deletions(-)
