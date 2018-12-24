From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH]  kvm/arm64 : reduce the size of kvm_vcpu
Date: Mon, 24 Dec 2018 18:42:24 +0800
Message-ID: <1545648144-64778-1-git-send-email-peng.hao2@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Peng Hao <peng.hao2@zte.com.cn>
List-Id: kvmarm@lists.cs.columbia.edu

According to adjust the position of variables in kvm_vcpu_arch,
the size of kvm_vcpu can reduce 16 bytes.
before:
cat /proc/slabinfo | grep kvm
kvm_vcpu  252    252   9120   28  ...

after:
cat /proc/slabinfo | grep kvm
kvm_vcpu   28     28   9104   28  ...

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 arch/arm64/include/asm/kvm_host.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 52fbc82..e805b7e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,16 +287,17 @@ struct kvm_vcpu_arch {
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
+	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
+	u64 vsesr_el2;
+
+	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
+
 	/* Target CPU and feature flags */
 	int target;
-	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
 
-	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
-	u64 vsesr_el2;
-
 	/* True when deferrable sysregs are loaded on the physical CPU,
 	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
 	bool sysregs_loaded_on_cpu;
-- 
1.8.3.1
