From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 09/18] arm64: KVM: Runtime detection of lower HYP offset
Date: Thu, 30 Jun 2016 18:40:42 +0100
Message-ID: <1467308451-13365-10-git-send-email-marc.zyngier@arm.com>
References: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4389249B94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aGLXXu+2r0GK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 13:35:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6869749B53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:51 -0400 (EDT)
In-Reply-To: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add the code that enables the switch to the lower HYP VA range.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 811773d..ffb3e14d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -726,6 +726,19 @@ static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused
 	return is_kernel_in_hyp_mode();
 }
 
+static bool hyp_offset_low(const struct arm64_cpu_capabilities *entry,
+			   int __unused)
+{
+	phys_addr_t idmap_addr = virt_to_phys(__hyp_idmap_text_start);
+
+	/*
+	 * Activate the lower HYP offset only if:
+	 * - the idmap doesn't clash with it,
+	 * - the kernel is not running at EL2.
+	 */
+	return idmap_addr > GENMASK(VA_BITS - 2, 0) && !is_kernel_in_hyp_mode();
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -803,6 +816,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR0_EL0_SHIFT,
 		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
 	},
+	{
+		.desc = "Reduced HYP mapping offset",
+		.capability = ARM64_HYP_OFFSET_LOW,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = hyp_offset_low,
+	},
 	{},
 };
 
-- 
2.1.4
