From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 06/16] arm64/sve: Determine virtualisation-friendly vector
 lengths
Date: Thu, 21 Jun 2018 15:57:30 +0100
Message-ID: <1529593060-542-7-git-send-email-Dave.Martin@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAA604A0D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wBIl03o6d9QC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:46:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 304A149FA8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:46:50 -0400 (EDT)
In-Reply-To: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Software at EL1 is permitted to assume that when programming
ZCR_EL1.LEN, the effective vector length is nonetheless a vector
length supported by the CPU.  Thus, software may rely on the
effective vector length being different from that programmed via
ZCR_EL1.LEN in some situations.

However, KVM does not tightly bind vcpus to individual underlying
physical CPUs.  As a result, vcpus can migrate from one CPU to
another.  This means that in order to preserve the guarantee
described in the previous paragraph, the set of supported vector
lengths must appear to be the same for the vcpu at all times,
irrespective of which physical CPU the vcpu is currently running
on.

The Arm SVE architecture allows the maximum vector length visible
to EL1 to be restricted by programming ZCR_EL2.LEN.  This provides
a means to hide from guests any vector lengths that are not
supported by every physical CPU in the system.  However, there is
no way to hide a particular vector length while some greater vector
length is exposed to EL1.

This patch determines the maximum vector length
(sve_max_virtualisable_vl) for which the set of supported vector
lengths not exceeding it is identical for all CPUs.  When KVM is
available, the set of vector lengths supported by each late
secondary CPU is verified to be consistent with those of the early
CPUs, in order to ensure that the value chosen for
sve_max_virtualisable_vl remains globally valid, and ensure that
all created vcpus continue to behave correctly.

sve_secondary_vq_map is used as scratch space for these
computations, rendering its name misleading.  This patch renames
this bitmap to sve_tmp_vq_map in order to make its purpose clearer.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimd.h |  1 +
 arch/arm64/kernel/cpufeature.c  |  2 +-
 arch/arm64/kernel/fpsimd.c      | 86 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 75 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index fa92747..3ad4607 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -85,6 +85,7 @@ extern void sve_kernel_enable(const struct arm64_cpu_capabilities *__unused);
 extern u64 read_zcr_features(void);
 
 extern int __ro_after_init sve_max_vl;
+extern int __ro_after_init sve_max_virtualisable_vl;
 
 #ifdef CONFIG_ARM64_SVE
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d2856b1..f493a2f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1511,7 +1511,7 @@ static void verify_sve_features(void)
 	unsigned int len = zcr & ZCR_ELx_LEN_MASK;
 
 	if (len < safe_len || sve_verify_vq_map()) {
-		pr_crit("CPU%d: SVE: required vector length(s) missing\n",
+		pr_crit("CPU%d: SVE: vector length support mismatch\n",
 			smp_processor_id());
 		cpu_die_early();
 	}
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 6b1ddae..390afb4 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/bitmap.h>
+#include <linux/bitops.h>
 #include <linux/bottom_half.h>
 #include <linux/bug.h>
 #include <linux/cache.h>
@@ -48,6 +49,7 @@
 #include <asm/sigcontext.h>
 #include <asm/sysreg.h>
 #include <asm/traps.h>
+#include <asm/virt.h>
 
 #define FPEXC_IOF	(1 << 0)
 #define FPEXC_DZF	(1 << 1)
@@ -130,14 +132,18 @@ static int sve_default_vl = -1;
 
 /* Maximum supported vector length across all CPUs (initially poisoned) */
 int __ro_after_init sve_max_vl = SVE_VL_MIN;
+int __ro_after_init sve_max_virtualisable_vl = SVE_VL_MIN;
 /* Set of available vector lengths, as vq_to_bit(vq): */
 static __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
+/* Set of vector lengths present on at least one cpu: */
+static __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
 static void __percpu *efi_sve_state;
 
 #else /* ! CONFIG_ARM64_SVE */
 
 /* Dummy declaration for code that will be optimised out: */
 extern __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
+extern __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
 extern void __percpu *efi_sve_state;
 
 #endif /* ! CONFIG_ARM64_SVE */
@@ -642,11 +648,8 @@ int sve_get_current_vl(void)
 	return sve_prctl_status(0);
 }
 
-/*
- * Bitmap for temporary storage of the per-CPU set of supported vector lengths
- * during secondary boot.
- */
-static DECLARE_BITMAP(sve_secondary_vq_map, SVE_VQ_MAX);
+/* Bitmaps for temporary storage during manipulation of vector length sets */
+static DECLARE_BITMAP(sve_tmp_vq_map, SVE_VQ_MAX);
 
 static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
 {
@@ -669,6 +672,7 @@ static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
 void __init sve_init_vq_map(void)
 {
 	sve_probe_vqs(sve_vq_map);
+	bitmap_copy(sve_vq_partial_map, sve_vq_map, SVE_VQ_MAX);
 }
 
 /*
@@ -677,24 +681,60 @@ void __init sve_init_vq_map(void)
  */
 void sve_update_vq_map(void)
 {
-	sve_probe_vqs(sve_secondary_vq_map);
-	bitmap_and(sve_vq_map, sve_vq_map, sve_secondary_vq_map, SVE_VQ_MAX);
+	sve_probe_vqs(sve_tmp_vq_map);
+	bitmap_and(sve_vq_map, sve_vq_map, sve_tmp_vq_map,
+		   SVE_VQ_MAX);
+	bitmap_or(sve_vq_partial_map, sve_vq_partial_map, sve_tmp_vq_map,
+		  SVE_VQ_MAX);
 }
 
 /* Check whether the current CPU supports all VQs in the committed set */
 int sve_verify_vq_map(void)
 {
-	int ret = 0;
+	int ret = -EINVAL;
+	unsigned long b;
 
-	sve_probe_vqs(sve_secondary_vq_map);
-	bitmap_andnot(sve_secondary_vq_map, sve_vq_map, sve_secondary_vq_map,
-		      SVE_VQ_MAX);
-	if (!bitmap_empty(sve_secondary_vq_map, SVE_VQ_MAX)) {
+	sve_probe_vqs(sve_tmp_vq_map);
+
+	bitmap_complement(sve_tmp_vq_map, sve_tmp_vq_map, SVE_VQ_MAX);
+	if (bitmap_intersects(sve_tmp_vq_map, sve_vq_map, SVE_VQ_MAX)) {
 		pr_warn("SVE: cpu%d: Required vector length(s) missing\n",
 			smp_processor_id());
-		ret = -EINVAL;
+		goto error;
 	}
 
+	if (!IS_ENABLED(CONFIG_KVM) || !is_hyp_mode_available())
+		goto ok;
+
+	/*
+	 * For KVM, it is necessary to ensure that this CPU doesn't
+	 * support any vector length that guests may have probed as
+	 * unsupported.
+	 */
+
+	/* Recover the set of supported VQs: */
+	bitmap_complement(sve_tmp_vq_map, sve_tmp_vq_map, SVE_VQ_MAX);
+	/* Find VQs supported that are not globally supported: */
+	bitmap_andnot(sve_tmp_vq_map, sve_tmp_vq_map, sve_vq_map, SVE_VQ_MAX);
+
+	/* Find the lowest such VQ, if any: */
+	b = find_last_bit(sve_tmp_vq_map, SVE_VQ_MAX);
+	if (b >= SVE_VQ_MAX)
+		goto ok; /* no mismatches */
+
+	/*
+	 * Mismatches above sve_max_virtualisable_vl are fine, since
+	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
+	 */
+	if (sve_vl_from_vq(bit_to_vq(b)) <= sve_max_virtualisable_vl) {
+		pr_warn("SVE: cpu%d: Unsupported vector length(s) present\n",
+			smp_processor_id());
+		goto error;
+	}
+
+ok:
+	ret = 0;
+error:
 	return ret;
 }
 
@@ -762,6 +802,7 @@ u64 read_zcr_features(void)
 void __init sve_setup(void)
 {
 	u64 zcr;
+	unsigned long b;
 
 	if (!system_supports_sve())
 		return;
@@ -790,10 +831,29 @@ void __init sve_setup(void)
 	 */
 	sve_default_vl = find_supported_vector_length(64);
 
+	bitmap_andnot(sve_tmp_vq_map, sve_vq_partial_map, sve_vq_map,
+		      SVE_VQ_MAX);
+
+	b = find_last_bit(sve_tmp_vq_map, SVE_VQ_MAX);
+	if (b >= SVE_VQ_MAX)
+		/* No non-virtualisable VLs found */
+		sve_max_virtualisable_vl = SVE_VQ_MAX;
+	else if (WARN_ON(b == SVE_VQ_MAX - 1))
+		/* No virtualisable VLs?  This is architecturally forbidden. */
+		sve_max_virtualisable_vl = SVE_VQ_MIN;
+	else /* b + 1 < SVE_VQ_MAX */
+		sve_max_virtualisable_vl = sve_vl_from_vq(bit_to_vq(b + 1));
+
+	if (sve_max_virtualisable_vl > sve_max_vl)
+		sve_max_virtualisable_vl = sve_max_vl;
+
 	pr_info("SVE: maximum available vector length %u bytes per vector\n",
 		sve_max_vl);
 	pr_info("SVE: default vector length %u bytes per vector\n",
 		sve_default_vl);
+	if (sve_max_virtualisable_vl < sve_max_vl)
+		pr_info("SVE: vector lengths greater than %u bytes not virtualisable\n",
+			sve_max_virtualisable_vl);
 
 	sve_efi_setup();
 }
-- 
2.1.4
