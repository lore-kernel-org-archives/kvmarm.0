From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 24/28] arm64/sve: KVM: Hide SVE from CPU features exposed to guests
Date: Thu, 31 Aug 2017 18:00:56 +0100
Message-ID: <1504198860-12951-25-git-send-email-Dave.Martin@arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

KVM guests cannot currently use SVE, because SVE is always
configured to trap to EL2.

However, a guest that sees SVE reported as present in
ID_AA64PFR0_EL1 may legitimately expect that SVE works and try to
use it.  Instead of working, the guest will receive an injected
undef exception, which may cause the guest to oops or go into a
spin.

To avoid misleading the guest into believing that SVE will work,
this patch masks out the SVE field from ID_AA64PFR0_EL1 when a
guest attempts to read this register.  No support is explicitly
added for ID_AA64ZFR0_EL1 either, so that is still emulated as
reading as zero, which is consistent with SVE not being
implemented.

This is a temporary measure, and will be removed in a later series
when full KVM support for SVE is implemented.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>

---

Changes since v1
----------------

Requested by Marc Zyngier:

* Use pr_err() instead inventing "kvm_info_once" ad-hoc.
---
 arch/arm64/kvm/sys_regs.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b1f7552..a0ee9b0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -23,6 +23,7 @@
 #include <linux/bsearch.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
+#include <linux/printk.h>
 #include <linux/uaccess.h>
 
 #include <asm/cacheflush.h>
@@ -897,8 +898,17 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
 
-	return raz ? 0 : read_sanitised_ftr_reg(id);
+	if (id == SYS_ID_AA64PFR0_EL1) {
+		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
+			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
+				    task_pid_nr(current));
+
+		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
+	}
+
+	return val;
 }
 
 /* cpufeature ID register access trap handlers */
-- 
2.1.4
