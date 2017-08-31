From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 21/28] arm64/sve: Add sysctl to set the default vector length for new processes
Date: Thu, 31 Aug 2017 18:00:53 +0100
Message-ID: <1504198860-12951-22-git-send-email-Dave.Martin@arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Because of the effect of SVE on the size of the signal frame, the
default vector length used for new processes involves a tradeoff
between performance of SVE-enabled software on the one hand, and
reliability of non-SVE-aware software on the other hand.

For this reason, the best choice depends on the repertoire of
userspace software in use and is thus best left up to distro
maintainers, sysadmins and developers.

If CONFIG_SYSCTL is enabled, this patch exposes the default vector
length in /proc/sys/abi/sve_default_vector_length, where boot
scripts or the adventurous can poke it.

In common with other arm64 ABI sysctls, this control is currently
global: setting it requires CAP_SYS_ADMIN in the root user
namespace, but the value set is effective for subsequent execs in
all namespaces.  The control only affects _new_ processes, however:
changing it does not affect the vector length of any existing
process.

The intended usage model is that if userspace is known to be fully
SVE-tolerant (or a developer is curious to find out) then init
scripts can crank this up during startup.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Alex Bennée <alex.bennee@linaro.org>

---

Changes since v1
----------------

Changes requested by Alex Bennée:

* Thin out BUG_ON()s:
Redundant BUG_ON()s and ones that just check invariants are removed.
Important sanity-checks are migrated to WARN_ON()s, with some
minimal best-effort patch-up code.
---
 arch/arm64/kernel/fpsimd.c | 62 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 42e8331..b430ee0 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -34,6 +34,7 @@
 #include <linux/sched/signal.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
+#include <linux/sysctl.h>
 
 #include <asm/fpsimd.h>
 #include <asm/cputype.h>
@@ -244,6 +245,65 @@ static unsigned int find_supported_vector_length(unsigned int vl)
 	return sve_vl_from_vq(bit_to_vq(bit));
 }
 
+#ifdef CONFIG_SYSCTL
+
+static int sve_proc_do_default_vl(struct ctl_table *table, int write,
+				  void __user *buffer, size_t *lenp,
+				  loff_t *ppos)
+{
+	int ret;
+	int vl = sve_default_vl;
+	struct ctl_table tmp_table = {
+		.data = &vl,
+		.maxlen = sizeof(vl),
+	};
+
+	ret = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (ret || !write)
+		return ret;
+
+	/* Writing -1 has the special meaning "set to max": */
+	if (vl == -1) {
+		/* Fail safe if sve_max_vl wasn't initialised */
+		if (WARN_ON(!sve_vl_valid(sve_max_vl)))
+			vl = SVE_VL_MIN;
+		else
+			vl = sve_max_vl;
+
+		goto chosen;
+	}
+
+	if (!sve_vl_valid(vl))
+		return -EINVAL;
+
+	vl = find_supported_vector_length(vl);
+chosen:
+	sve_default_vl = vl;
+	return 0;
+}
+
+static struct ctl_table sve_default_vl_table[] = {
+	{
+		.procname	= "sve_default_vector_length",
+		.mode		= 0644,
+		.proc_handler	= sve_proc_do_default_vl,
+	},
+	{ }
+};
+
+static int __init sve_sysctl_init(void)
+{
+	if (system_supports_sve())
+		if (!register_sysctl("abi", sve_default_vl_table))
+			return -EINVAL;
+
+	return 0;
+}
+
+#else /* ! CONFIG_SYSCTL */
+static int __init sve_sysctl_init(void) { return 0; }
+#endif /* ! CONFIG_SYSCTL */
+
 #define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
 	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
 
@@ -1030,6 +1090,6 @@ static int __init fpsimd_init(void)
 	if (!(elf_hwcap & HWCAP_ASIMD))
 		pr_notice("Advanced SIMD is not implemented\n");
 
-	return 0;
+	return sve_sysctl_init();
 }
 late_initcall(fpsimd_init);
-- 
2.1.4
