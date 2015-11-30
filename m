From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 0/2] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Mon, 30 Nov 2015 12:40:43 +0300
Message-ID: <cover.1448874023.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch set brings back functionality which was broken in v4.0.
Unfortunately, currently it is impossible to take advantage of virtual
architected timer in this case, therefore guest, running in such
restricted mode, has to use some memory-mapped timer. But it is still
better than nothing.

Patch 0002 needs to be verified on PowerPC architecture, because i've
got an impression that KVM_CAP_IRQCHIP is forgotten there.

v4 => v5:
- Tested on top of kvmarm/next
- Dropped already applied part
- Fixed minor checkpatch issues

v3 => v4:
- Revert back to using switch on kvm_vgic_hyp_init() return code. I decided
  to leave 'vgic_present = false' statement because it helps to understand
  the code.

v2 => v3:
- Improved commit messages, added references to commits where the respective
  functionality was broken
- Explicitly specify that the solution currently affects only vGIC and has
  nothing to do with timer.
- Fixed code style according to previous notes
- Removed ARM64 save/restore patch introduced in v2 because it was already
  obsolete for linux-next
- Modify KVM_CAP_IRQFD handling in correct place

v1 => v2:
- Do not use defensive approach in patch 0001. Use correct conditions in
  callers instead
- Added ARM64-specific code, without which attempt to run a VM ends in a
  HYP crash because of unset vGIC save/restore function pointers



Pavel Fedin (2):
  arm/arm64: KVM: Detect vGIC presence at runtime
  KVM: Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP

 arch/arm/kvm/arm.c  | 22 ++++++++++++++++++++--
 virt/kvm/kvm_main.c |  6 ++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

-- 
2.4.4

