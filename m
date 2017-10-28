From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v3] KVM: arm/arm64: fix the incompatible matching for external
 abort
Date: Sat, 28 Oct 2017 14:45:59 +0800
Message-ID: <1509173159-30579-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CC1F40EA6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Oct 2017 02:18:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HXk9K0OvWTQ6 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 Oct 2017 02:18:55 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B18E405F9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Oct 2017 02:18:54 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, huangshaoyu@huawei.com, wuquanming@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

For this matching, switch expression uses fault type which is
not {I,D}FSC value, but the case expression uses {I,D}FSC,
they are incompatible. So change the switch expression to
use {I,D}FSC.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm/include/asm/kvm_emulate.h   | 2 +-
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 98089ff..7571b4e 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -203,7 +203,7 @@ static inline u8 kvm_vcpu_trap_get_fault_type(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_dabt_isextabt(struct kvm_vcpu *vcpu)
 {
-	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+	switch (kvm_vcpu_trap_get_fault(vcpu)) {
 	case FSC_SEA:
 	case FSC_SEA_TTW0:
 	case FSC_SEA_TTW1:
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index e5df3fc..8c918c5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -237,7 +237,7 @@ static inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
 {
-	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+	switch (kvm_vcpu_trap_get_fault(vcpu)) {
 	case FSC_SEA:
 	case FSC_SEA_TTW0:
 	case FSC_SEA_TTW1:
-- 
1.9.1
