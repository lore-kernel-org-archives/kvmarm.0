From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 1/8] arm64: hwcaps: Cleanup naming
Date: Thu, 25 Feb 2016 09:52:41 +0000
Message-ID: <1456393968-17386-2-git-send-email-suzuki.poulose@arm.com>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 350E6411F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cgAxkOVIjmBV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2016 04:46:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 304BE411AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:14 -0500 (EST)
In-Reply-To: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, ynorov@caviumnetworks.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We use hwcaps for referring to ELF hwcaps capability information.
However this can be confusing with 'cpu_hwcaps' which stands for the
CPU capability bit field. This patch cleans up the names to make it
a bit more readable.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kernel/cpufeature.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f29d63c..a3c254b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -682,7 +682,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.hwcap = cap,					\
 	}
 
-static const struct arm64_cpu_capabilities arm64_hwcaps[] = {
+static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_AES_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_PMULL),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_AES_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_AES),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA1_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA1),
@@ -701,7 +701,7 @@ static const struct arm64_cpu_capabilities arm64_hwcaps[] = {
 	{},
 };
 
-static void __init cap_set_hwcap(const struct arm64_cpu_capabilities *cap)
+static void __init cap_set_elf_hwcap(const struct arm64_cpu_capabilities *cap)
 {
 	switch (cap->hwcap_type) {
 	case CAP_HWCAP:
@@ -722,7 +722,7 @@ static void __init cap_set_hwcap(const struct arm64_cpu_capabilities *cap)
 }
 
 /* Check if we have a particular HWCAP enabled */
-static bool __maybe_unused cpus_have_hwcap(const struct arm64_cpu_capabilities *cap)
+static bool cpus_have_elf_hwcap(const struct arm64_cpu_capabilities *cap)
 {
 	bool rc;
 
@@ -746,14 +746,14 @@ static bool __maybe_unused cpus_have_hwcap(const struct arm64_cpu_capabilities *
 	return rc;
 }
 
-static void __init setup_cpu_hwcaps(void)
+static void __init setup_elf_hwcaps(void)
 {
 	int i;
-	const struct arm64_cpu_capabilities *hwcaps = arm64_hwcaps;
+	const struct arm64_cpu_capabilities *hwcaps = arm64_elf_hwcaps;
 
 	for (i = 0; hwcaps[i].desc; i++)
 		if (hwcaps[i].matches(&hwcaps[i]))
-			cap_set_hwcap(&hwcaps[i]);
+			cap_set_elf_hwcap(&hwcaps[i]);
 }
 
 void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
@@ -889,8 +889,8 @@ void verify_local_cpu_capabilities(void)
 			caps[i].enable(NULL);
 	}
 
-	for (i = 0, caps = arm64_hwcaps; caps[i].desc; i++) {
-		if (!cpus_have_hwcap(&caps[i]))
+	for (i = 0, caps = arm64_elf_hwcaps; caps[i].desc; i++) {
+		if (!cpus_have_elf_hwcap(&caps[i]))
 			continue;
 		if (!feature_matches(__raw_read_system_reg(caps[i].sys_reg), &caps[i])) {
 			pr_crit("CPU%d: missing HWCAP: %s\n",
@@ -913,7 +913,7 @@ void __init setup_cpu_features(void)
 
 	/* Set the CPU feature capabilies */
 	setup_feature_capabilities();
-	setup_cpu_hwcaps();
+	setup_elf_hwcaps();
 
 	/* Advertise that we have computed the system capabilities */
 	set_sys_caps_initialised();
-- 
1.7.9.5
