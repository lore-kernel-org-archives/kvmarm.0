From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 17/30] arm64: cpufeature: Move sys_caps_initialised declarations
Date: Tue, 31 Oct 2017 15:51:09 +0000
Message-ID: <1509465082-30427-18-git-send-email-Dave.Martin@arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

update_cpu_features() currently cannot tell whether it is being
called during early or late secondary boot.  This doesn't
desperately matter for anything it currently does.

However, SVE will need to know here whether the set of available
vector lengths is known or still to be determined when booting a
CPU, so that it can be updated appropriately.

This patch simply moves the sys_caps_initialised stuff to the top
of the file so that it can be used more widely.  There doesn't seem
to be a more obvious place to put it.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a011a5a..e226799 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -51,6 +51,21 @@ unsigned int compat_elf_hwcap2 __read_mostly;
 DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
 EXPORT_SYMBOL(cpu_hwcaps);
 
+/*
+ * Flag to indicate if we have computed the system wide
+ * capabilities based on the boot time active CPUs. This
+ * will be used to determine if a new booting CPU should
+ * go through the verification process to make sure that it
+ * supports the system capabilities, without using a hotplug
+ * notifier.
+ */
+static bool sys_caps_initialised;
+
+static inline void set_sys_caps_initialised(void)
+{
+	sys_caps_initialised = true;
+}
+
 static int dump_cpu_hwcaps(struct notifier_block *self, unsigned long v, void *p)
 {
 	/* file-wide pr_fmt adds "CPU features: " prefix */
@@ -1050,21 +1065,6 @@ void __init enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
 }
 
 /*
- * Flag to indicate if we have computed the system wide
- * capabilities based on the boot time active CPUs. This
- * will be used to determine if a new booting CPU should
- * go through the verification process to make sure that it
- * supports the system capabilities, without using a hotplug
- * notifier.
- */
-static bool sys_caps_initialised;
-
-static inline void set_sys_caps_initialised(void)
-{
-	sys_caps_initialised = true;
-}
-
-/*
  * Check for CPU features that are used in early boot
  * based on the Boot CPU value.
  */
-- 
2.1.4
