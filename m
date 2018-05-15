From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v12 4/4] arm64: handle NOTIFY_SEI notification by the APEI driver
Date: Wed, 16 May 2018 04:58:07 +0800
Message-ID: <1526417887-25843-5-git-send-email-gengdongjiu@huawei.com>
References: <1526417887-25843-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526417887-25843-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@arm.com, marc.zyngier@arm.com, james.morse@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: gengdongjiu@huawei.com, huangshaoyu@huawei.com, zhengxiang9@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Add a helper to handle the NOTIFY_SEI notification, when kernel
gets the NOTIFY_SEI notification, call this helper and let APEI
driver to handle this notification.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/kernel/traps.c            |  4 ++++
 arch/arm64/mm/fault.c                | 10 ++++++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 07aa8e3..9ee13ad 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -57,6 +57,7 @@ void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
 })
 
 int handle_guest_sea(phys_addr_t addr, unsigned int esr);
+int handle_guest_sei(void);
 
 #endif	/* __ASSEMBLY__ */
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index bbb0fde..d888eb2 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -681,6 +681,10 @@ bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned int esr)
 {
 	u32 aet = arm64_ras_serror_get_severity(esr);
 
+	/* The APEI driver may handle this RAS error. */
+	if (!handle_guest_sei())
+		return false;
+
 	switch (aet) {
 	case ESR_ELx_AET_CE:	/* corrected error */
 	case ESR_ELx_AET_UEO:	/* restartable, not yet consumed */
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index f76bb2c..8f29bd8 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -683,6 +683,16 @@ int handle_guest_sea(phys_addr_t addr, unsigned int esr)
 	return ret;
 }
 
+int handle_guest_sei(void)
+{
+	int ret = -ENOENT;
+
+	if (IS_ENABLED(CONFIG_ACPI_APEI_SEI))
+		ret = ghes_notify_sei();
+
+	return ret;
+}
+
 asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
 					 struct pt_regs *regs)
 {
-- 
1.9.1
