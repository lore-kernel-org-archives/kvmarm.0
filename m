From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v4] KVM: arm/arm64: fix the incompatible matching for external
 abort
Date: Mon, 30 Oct 2017 14:05:18 +0800
Message-ID: <1509343518-27137-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3860406D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 01:38:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8seu--pU8+nb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Oct 2017 01:38:04 -0400 (EDT)
Received: from huawei.com (unknown [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEE0A405F9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 01:38:03 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com
Cc: wuquanming@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

kvm_vcpu_dabt_isextabt() tries to match a full fault syndrome, but
calls kvm_vcpu_trap_get_fault_type() that only returns the fault class,
thus reducing the scope of the check. This doesn't cause any observable
bug yet as we end-up matching a closely related syndrome for which we
return the same value.

Using kvm_vcpu_trap_get_fault() instead fixes it for good.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
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
