From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/ARM updates for 5.0-rc6
Date: Thu,  7 Feb 2019 13:18:32 +0000
Message-ID: <20190207131843.157210-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Richard Henderson <richard.henderson@linaro.org>, Christoffer Dall <christoffer.dall@arm.com>, James Morse <james.morse@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

This is hopefully the last drop of KVM/ARM patches for 5.0. We have
fixes to the vcpu reset code, a fix for a corner case of the VGIC
init, better LORegion handling compliance, more configurations where
we allow PUD mappings, a set of kprobe exclusions, and the required
fixes to be able to run KVM with PREEMPT_RT.

Please pull,

	M.

The following changes since commit 49a57857aeea06ca831043acbb0fa5e0f50602fd:

  Linux 5.0-rc3 (2019-01-21 13:14:44 +1300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-for-5.0

for you to fetch changes up to 7d82602909ed9c73b34ad26f05d10db4850a4f8c:

  KVM: arm64: Forbid kprobing of the VHE world-switch code (2019-02-07 11:44:47 +0000)

----------------------------------------------------------------
KVM/ARM fixes for 5.0:

- Fix the way we reset vcpus, plugging the race that could happen on VHE
- Fix potentially inconsistent group setting for private interrupts
- Don't generate UNDEF when LORegion feature is present
- Relax the restriction on using stage2 PUD huge mapping
- Turn some spinlocks into raw_spinlocks to help RT compliance

----------------------------------------------------------------
Christoffer Dall (2):
      KVM: arm/arm64: Reset the VCPU without preemption and vcpu state loaded
      KVM: arm/arm64: vgic: Always initialize the group of private IRQs

James Morse (1):
      KVM: arm64: Forbid kprobing of the VHE world-switch code

Julien Thierry (3):
      KVM: arm/arm64: vgic: Make vgic_irq->irq_lock a raw_spinlock
      KVM: arm/arm64: vgic: Make vgic_dist->lpi_list_lock a raw_spinlock
      KVM: arm/arm64: vgic: Make vgic_cpu->ap_list_lock a raw_spinlock

Marc Zyngier (4):
      arm64: KVM: Don't generate UNDEF when LORegion feature is present
      arm/arm64: KVM: Allow a VCPU to fully reset itself
      arm/arm64: KVM: Don't panic on failure to properly reset system registers
      arm: KVM: Add missing kvm_stage2_has_pmd() helper

Suzuki K Poulose (1):
      KVM: arm64: Relax the restriction on using stage2 PUD huge mapping

 arch/arm/include/asm/kvm_host.h       |  10 +++
 arch/arm/include/asm/stage2_pgtable.h |   5 ++
 arch/arm/kvm/coproc.c                 |   4 +-
 arch/arm/kvm/reset.c                  |  24 +++++++
 arch/arm64/include/asm/kvm_host.h     |  11 ++++
 arch/arm64/kvm/hyp/switch.c           |   5 ++
 arch/arm64/kvm/hyp/sysreg-sr.c        |   5 ++
 arch/arm64/kvm/reset.c                |  50 +++++++++++++-
 arch/arm64/kvm/sys_regs.c             |  50 ++++++++------
 include/kvm/arm_vgic.h                |   6 +-
 virt/kvm/arm/arm.c                    |  10 +++
 virt/kvm/arm/mmu.c                    |   9 ++-
 virt/kvm/arm/psci.c                   |  36 +++++------
 virt/kvm/arm/vgic/vgic-debug.c        |   4 +-
 virt/kvm/arm/vgic/vgic-init.c         |  30 +++++----
 virt/kvm/arm/vgic/vgic-its.c          |  22 +++----
 virt/kvm/arm/vgic/vgic-mmio-v2.c      |  14 ++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c      |  12 ++--
 virt/kvm/arm/vgic/vgic-mmio.c         |  34 +++++-----
 virt/kvm/arm/vgic/vgic-v2.c           |   4 +-
 virt/kvm/arm/vgic/vgic-v3.c           |   8 +--
 virt/kvm/arm/vgic/vgic.c              | 118 +++++++++++++++++-----------------
 22 files changed, 303 insertions(+), 168 deletions(-)
