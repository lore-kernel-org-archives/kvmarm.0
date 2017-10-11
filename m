From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2 3/3] arm64: Introduce command line parameter to disable CNP
Date: Wed, 11 Oct 2017 13:19:55 +0100
Message-ID: <1507724395-13735-4-git-send-email-vladimir.murzin@arm.com>
References: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3450C49D39
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 08:19:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8ZcM+7exSY4v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 08:19:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7322C49D6F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 08:19:34 -0400 (EDT)
In-Reply-To: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kbuild-all@01.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

There are cases when activating of Common Not Private (CNP) feature
might not be desirable; this patch allows to forcefully disable CNP
even it is supported by hardware.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 ++++
 arch/arm64/kernel/cpufeature.c                  | 16 +++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0549662..3c1e45d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2560,6 +2560,10 @@
 
 	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
 
+	nocnp		[ARM64]
+			Disable CNP (Common not Private translations)
+			even if it is supported by processor.
+
 	nodelayacct	[KNL] Disable per-task delay accounting
 
 	nodsp		[SH] Disable hardware DSP at boot time.
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 83809a8..9bceca3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -771,6 +771,20 @@ static bool has_no_hw_prefetch(const struct arm64_cpu_capabilities *entry, int _
 		MIDR_CPU_VAR_REV(1, MIDR_REVISION_MASK));
 }
 
+static bool nocnp;
+
+static int __init early_nocnp(char *p)
+{
+	nocnp = true;
+	return 0;
+}
+early_param("nocnp", early_nocnp);
+
+static bool has_useable_cnp(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	return has_cpuid_feature(entry, scope) && !nocmp;
+}
+
 static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused)
 {
 	return is_kernel_in_hyp_mode();
@@ -905,7 +919,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.desc = "Common not Private translations",
 		.capability = ARM64_HAS_CNP,
 		.def_scope = SCOPE_SYSTEM,
-		.matches = has_cpuid_feature,
+		.matches = has_useable_cnp,
 		.sys_reg = SYS_ID_AA64MMFR2_EL1,
 		.sign = FTR_UNSIGNED,
 		.field_pos = ID_AA64MMFR2_CNP_SHIFT,
-- 
2.0.0
