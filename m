From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 0/4] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Fri, 04 Dec 2015 14:42:55 +0300
Message-ID: <cover.1449229272.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD5CB499B4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 06:41:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfLhpVHA2Cg2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2015 06:41:31 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26B6D49852
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 06:41:30 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYU00DIR0JSQ9A0@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 04 Dec 2015 11:43:04 +0000 (GMT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
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

v2 => v3:
- Brought back some const modifiers in unaffected functions

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
 arch/arm64/kvm/sys_regs.c            | 124 +++++++++++++++++------------------
 arch/arm64/kvm/sys_regs.h            |   8 +--
 arch/arm64/kvm/sys_regs_generic_v8.c |   4 +-
 8 files changed, 106 insertions(+), 87 deletions(-)

-- 
2.4.4
