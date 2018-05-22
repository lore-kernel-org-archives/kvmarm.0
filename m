From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/14] arm64: ssbd: Disable mitigation on CPU resume if
 required by user
Date: Tue, 22 May 2018 16:06:42 +0100
Message-ID: <20180522150648.28297-9-marc.zyngier@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180522150648.28297-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On a system where firmware can dynamically change the state of the
mitigation, the CPU will always come up with the mitigation enabled,
including when coming back from suspend.

If the user has requested "no mitigation" via a command line option,
let's enforce it by calling into the firmware again to disable it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 6 ++++++
 arch/arm64/kernel/cpu_errata.c      | 8 ++++----
 arch/arm64/kernel/suspend.c         | 8 ++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 1bacdf57f0af..d9dcb683259e 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,6 +553,12 @@ static inline int arm64_get_ssbd_state(void)
 #endif
 }
 
+#ifdef CONFIG_ARM64_SSBD
+void arm64_set_ssbd_mitigation(bool state);
+#else
+static inline void arm64_set_ssbd_mitigation(bool state) {}
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 8f686f39b9c1..b4c12e9140f0 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -297,7 +297,7 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 		*updptr = cpu_to_le32(aarch64_insn_gen_nop());
 }
 
-static void do_ssbd(bool state)
+void arm64_set_ssbd_mitigation(bool state)
 {
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
@@ -371,20 +371,20 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	switch (ssbd_state) {
 	case ARM64_SSBD_FORCE_DISABLE:
 		pr_info_once("%s disabled from command-line\n", entry->desc);
-		do_ssbd(false);
+		arm64_set_ssbd_mitigation(false);
 		required = false;
 		break;
 
 	case ARM64_SSBD_EL1_ENTRY:
 		if (required) {
 			__this_cpu_write(arm64_ssbd_callback_required, 1);
-			do_ssbd(true);
+			arm64_set_ssbd_mitigation(true);
 		}
 		break;
 
 	case ARM64_SSBD_FORCE_ENABLE:
 		pr_info_once("%s forced from command-line\n", entry->desc);
-		do_ssbd(true);
+		arm64_set_ssbd_mitigation(true);
 		required = true;
 		break;
 
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index a307b9e13392..70c283368b64 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -62,6 +62,14 @@ void notrace __cpu_suspend_exit(void)
 	 */
 	if (hw_breakpoint_restore)
 		hw_breakpoint_restore(cpu);
+
+	/*
+	 * On resume, firmware implementing dynamic mitigation will
+	 * have turned the mitigation on. If the user has forcefully
+	 * disabled it, make sure their wishes are obeyed.
+	 */
+	if (arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE)
+		arm64_set_ssbd_mitigation(false);
 }
 
 /*
-- 
2.14.2
