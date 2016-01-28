From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 1/5] arm64: KVM: Move kvm/hyp/hyp.h to include/asm/kvm_hyp.h
Date: Thu, 28 Jan 2016 15:56:01 +0000
Message-ID: <1453996565-19666-2-git-send-email-marc.zyngier@arm.com>
References: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to be able to move code outside of kvm/hyp, we need to make
the global hyp.h file accessible from a standard location.

include/asm/kvm_hyp.h seems good enough.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/{kvm/hyp/hyp.h => include/asm/kvm_hyp.h} | 0
 arch/arm64/kvm/hyp/debug-sr.c                       | 4 +---
 arch/arm64/kvm/hyp/switch.c                         | 3 +--
 arch/arm64/kvm/hyp/sysreg-sr.c                      | 4 +---
 arch/arm64/kvm/hyp/timer-sr.c                       | 4 +---
 arch/arm64/kvm/hyp/tlb.c                            | 2 +-
 arch/arm64/kvm/hyp/vgic-v2-sr.c                     | 4 +---
 arch/arm64/kvm/hyp/vgic-v3-sr.c                     | 4 +---
 8 files changed, 7 insertions(+), 18 deletions(-)
 rename arch/arm64/{kvm/hyp/hyp.h => include/asm/kvm_hyp.h} (100%)

diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/include/asm/kvm_hyp.h
similarity index 100%
rename from arch/arm64/kvm/hyp/hyp.h
rename to arch/arm64/include/asm/kvm_hyp.h
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index c9c1e97..053cf8b 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -19,9 +19,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_asm.h>
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 #define read_debug(r,n)		read_sysreg(r##n##_el1)
 #define write_debug(v,r,n)	write_sysreg(v, r##n##_el1)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index df2cce9..c5222da 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -17,8 +17,7 @@
 
 #include <linux/types.h>
 #include <asm/kvm_asm.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 36bbdec..8cc3872 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -19,9 +19,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_asm.h>
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /* Yes, this does nothing, on purpose */
 static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/timer-sr.c
index f276d9e..ea00d69 100644
--- a/arch/arm64/kvm/hyp/timer-sr.c
+++ b/arch/arm64/kvm/hyp/timer-sr.c
@@ -19,9 +19,7 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 2a7e0d8..be8177c 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -15,7 +15,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
index e717612..9514a7d 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
@@ -19,9 +19,7 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm_host.h>
 
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /* vcpu is already in the HYP VA space */
 void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 9142e082..3a26799 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -19,9 +19,7 @@
 #include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kvm_host.h>
 
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 #define vtr_to_max_lr_idx(v)		((v) & 0xf)
 #define vtr_to_nr_pri_bits(v)		(((u32)(v) >> 29) + 1)
-- 
2.1.4

