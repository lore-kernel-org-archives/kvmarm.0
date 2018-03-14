From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v6 26/26] arm64: Enable ARM64_HARDEN_EL2_VECTORS on Cortex-A57
 and A72
Date: Wed, 14 Mar 2018 16:50:49 +0000
Message-ID: <20180314165049.30105-27-marc.zyngier@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ADA04043C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Mar 2018 12:48:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QFk4ATw7+A2a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Mar 2018 12:48:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98E0D4A025
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Mar 2018 12:44:30 -0400 (EDT)
In-Reply-To: <20180314165049.30105-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Cortex-A57 and A72 are vulnerable to the so-called "variant 3a" of
Meltdown, where an attacker can speculatively obtain the value
of a privileged system register.

By enabling ARM64_HARDEN_EL2_VECTORS on these CPUs, obtaining
VBAR_EL2 is not disclosing the hypervisor mappings anymore.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/cpu_errata.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 8cf6b60a085a..aacdc118c4c9 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -424,6 +424,18 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
 		.enable = enable_smccc_arch_workaround_1,
 	},
+#endif
+#ifdef CONFIG_HARDEN_EL2_VECTORS
+	{
+		.desc = "Cortex-A57 EL2 vector hardening",
+		.capability = ARM64_HARDEN_EL2_VECTORS,
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+	},
+	{
+		.desc = "Cortex-A72 EL2 vector hardening",
+		.capability = ARM64_HARDEN_EL2_VECTORS,
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	},
 #endif
 	{
 	}
-- 
2.14.2
