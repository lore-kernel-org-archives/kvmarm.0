From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 0131/1529] Fix typo
Date: Sat, 21 May 2016 13:53:22 +0200
Message-ID: <20160521115322.6241-1-andrea.gelmini@gelma.net>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: andrea.gelmini@gelma.net
Cc: trivial@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm64/kvm/guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 32fad75..3f9e157 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -211,7 +211,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 /**
  * kvm_arm_copy_reg_indices - get indices of all registers.
  *
- * We do core registers right here, then we apppend system regs.
+ * We do core registers right here, then we append system regs.
  */
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-- 
2.8.2.534.g1f66975

