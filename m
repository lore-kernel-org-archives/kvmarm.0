From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 01/14] arm64/sve: Clarify vq map semantics
Date: Fri, 12 Apr 2019 17:28:05 +0100
Message-ID: <1555086498-26691-2-git-send-email-Dave.Martin@arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3577D4A4BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZpZHs9eoeKCW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Apr 2019 12:29:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D65E84A4B9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:07 -0400 (EDT)
In-Reply-To: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently the meanings of sve_vq_map and the ancillary helpers
__bit_to_vq() and __vq_to_bit() are not clearly explained.

This patch makes the explanatory comment clearer, and removes the
duplicate comment from fpsimd.h.

The WARN_ON() currently present in __bit_to_vq() confuses the
intended use of this helper.  Since these are low-level helpers not
intended for general-purpose use anyway, it is better not to make
guesses about how these functions will be used: rather, this patch
removes the WARN_ON() and relies on callers to use the helpers
sensibly.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimd.h | 4 ----
 arch/arm64/kernel/fpsimd.c      | 7 ++++++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index ad6d2e4..df62bbd 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -92,7 +92,6 @@ extern u64 read_zcr_features(void);
 
 extern int __ro_after_init sve_max_vl;
 extern int __ro_after_init sve_max_virtualisable_vl;
-/* Set of available vector lengths, as vq_to_bit(vq): */
 extern __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 
 /*
@@ -107,9 +106,6 @@ static inline unsigned int __vq_to_bit(unsigned int vq)
 
 static inline unsigned int __bit_to_vq(unsigned int bit)
 {
-	if (WARN_ON(bit >= SVE_VQ_MAX))
-		bit = SVE_VQ_MAX - 1;
-
 	return SVE_VQ_MAX - bit;
 }
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 577296b..56afa40 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -135,10 +135,15 @@ static int sve_default_vl = -1;
 /* Maximum supported vector length across all CPUs (initially poisoned) */
 int __ro_after_init sve_max_vl = SVE_VL_MIN;
 int __ro_after_init sve_max_virtualisable_vl = SVE_VL_MIN;
-/* Set of available vector lengths, as vq_to_bit(vq): */
+
+/*
+ * Set of available vector lengths,
+ * where length vq encoded as bit __vq_to_bit(vq):
+ */
 __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 /* Set of vector lengths present on at least one cpu: */
 static __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
+
 static void __percpu *efi_sve_state;
 
 #else /* ! CONFIG_ARM64_SVE */
-- 
2.1.4
