From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/55] arm64: KVM: Runtime detection of lower HYP offset
Date: Fri, 22 Jul 2016 18:28:32 +0100
Message-ID: <1469208552-4155-16-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Add the code that enables the switch to the lower HYP VA range.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 811773d..ffb3e14 100644
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
2.8.1

