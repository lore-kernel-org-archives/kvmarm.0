From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 0/4] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Fri, 04 Dec 2015 13:25:56 +0300
Message-ID: <cover.1449224338.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

ARM64 CPU has zero register which is read-only, with a value of 0.
However, KVM currently incorrectly recognizes it being SP (because
Rt == 31, and in struct user_pt_regs 'regs' array is followed by SP),
resulting in invalid value being read, or even SP corruption on write.

The problem has been discovered by performing an operation

 *((volatile int *)reg) = 0;

which compiles as "str xzr, [xx]", and resulted in strange values being
written.

v1 => v2:
- Changed type of transfer value to u64 and store it directly in
  struct sys_reg_params instead of a pointer
- Use lower_32_bits()/upper_32_bits() where appropriate
- Fixed wrong usage of 'Rt' instead of 'Rt2' in kvm_handle_cp_64(),
  overlooked in v1
- Do not write value back when reading

Pavel Fedin (4):
  KVM: arm64: Correctly handle zero register during MMIO
  KVM: arm64: Remove const from struct sys_reg_params
  KVM: arm64: Correctly handle zero register in system register accesses
  KVM: arm64: Get rid of old vcpu_reg()

 arch/arm/include/asm/kvm_emulate.h   |  12 ++++
 arch/arm/kvm/mmio.c                  |   5 +-
 arch/arm/kvm/psci.c                  |  20 +++---
 arch/arm64/include/asm/kvm_emulate.h |  18 +++--
 arch/arm64/kvm/handle_exit.c         |   2 +-
 arch/arm64/kvm/sys_regs.c            | 126 +++++++++++++++++------------------
 arch/arm64/kvm/sys_regs.h            |  16 ++---
 arch/arm64/kvm/sys_regs_generic_v8.c |   4 +-
 8 files changed, 111 insertions(+), 92 deletions(-)

-- 
2.4.4

