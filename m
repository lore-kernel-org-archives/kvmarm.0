From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 08/17] arm64: ssbd: Restore mitigation status on CPU resume
Date: Tue, 29 May 2018 13:11:12 +0100
Message-ID: <20180529121121.24927-9-marc.zyngier@arm.com>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529121121.24927-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>, Randy Dunlap <rdunlap@infradead.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On a system where firmware can dynamically change the state of the
mitigation, the CPU will always come up with the mitigation enabled,
including when coming back from suspend.

If the user has requested "no mitigation" via a command line option,
let's enforce it by calling into the firmware again to disable it.

Similarily, for a resume from hibernate, the mitigation could have
been disabled by the boot kernel. Let's ensure that it is set
back on in that case.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  6 ++++++
 arch/arm64/kernel/cpu_errata.c      |  2 +-
 arch/arm64/kernel/hibernate.c       | 11 +++++++++++
 arch/arm64/kernel/suspend.c         |  8 ++++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index b0fc3224ce8a..55bc1f073bfb 100644
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
index 2fef634e6953..2b9a31a6a16a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -303,7 +303,7 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 		*updptr = cpu_to_le32(aarch64_insn_gen_nop());
 }
 
-static void arm64_set_ssbd_mitigation(bool state)
+void arm64_set_ssbd_mitigation(bool state)
 {
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 1ec5f28c39fc..6b2686d54411 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -313,6 +313,17 @@ int swsusp_arch_suspend(void)
 
 		sleep_cpu = -EINVAL;
 		__cpu_suspend_exit();
+
+		/*
+		 * Just in case the boot kernel did turn the SSBD
+		 * mitigation off behind our back, let's set the state
+		 * to what we expect it to be.
+		 */
+		switch (arm64_get_ssbd_state()) {
+		case ARM64_SSBD_FORCE_ENABLE:
+		case ARM64_SSBD_KERNEL:
+			arm64_set_ssbd_mitigation(true);
+		}
 	}
 
 	local_daif_restore(flags);
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
