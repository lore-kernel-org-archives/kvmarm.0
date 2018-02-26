From: Alex Shi <alex.shi@linaro.org>
Subject: [PATCH 31/52] arm/arm64: KVM: Consolidate the PSCI include files
Date: Mon, 26 Feb 2018 16:20:05 +0800
Message-ID: <1519633227-29832-32-git-send-email-alex.shi@linaro.org>
References: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Russell King <linux@armlinux.org.uk>, "moderated list:KERNEL VIRTUAL
        MACHINE KVM FOR ARM" <linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE KVM
        FOR ARM" <kvmarm@lists.cs.columbia.edu>, "open list:KERNEL VIRTUAL MACHINE KVM" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

commit 1a2fb94e6a77 upstream.

As we're about to update the PSCI support, and because I'm lazy,
let's move the PSCI include file to include/kvm so that both
ARM architectures can find it.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Alex Shi <alex.shi@linaro.org>

Conflicts:
	need kvm/arm_psci.h in files:
	arch/arm64/kvm/handle_exit.c
	arch/arm/kvm/psci.c and arch/arm/kvm/arm.c
	no virt/kvm/arm/arm.c and virt/kvm/arm/psci.c
---
 arch/arm/include/asm/kvm_psci.h   | 27 ---------------------------
 arch/arm/kvm/arm.c                |  2 +-
 arch/arm/kvm/handle_exit.c        |  2 +-
 arch/arm/kvm/psci.c               |  2 +-
 arch/arm64/include/asm/kvm_psci.h | 27 ---------------------------
 arch/arm64/kvm/handle_exit.c      |  3 ++-
 include/kvm/arm_psci.h            | 27 +++++++++++++++++++++++++++
 7 files changed, 32 insertions(+), 58 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_psci.h
 delete mode 100644 arch/arm64/include/asm/kvm_psci.h
 create mode 100644 include/kvm/arm_psci.h

diff --git a/arch/arm/include/asm/kvm_psci.h b/arch/arm/include/asm/kvm_psci.h
deleted file mode 100644
index 6bda945..0000000
--- a/arch/arm/include/asm/kvm_psci.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2012 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __ARM_KVM_PSCI_H__
-#define __ARM_KVM_PSCI_H__
-
-#define KVM_ARM_PSCI_0_1	1
-#define KVM_ARM_PSCI_0_2	2
-
-int kvm_psci_version(struct kvm_vcpu *vcpu);
-int kvm_psci_call(struct kvm_vcpu *vcpu);
-
-#endif /* __ARM_KVM_PSCI_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 4e4ae07..8588e67 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -44,8 +44,8 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
-#include <asm/kvm_psci.h>
 #include <asm/sections.h>
+#include <kvm/arm_psci.h>
 
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 4e57ebc..0a2b758 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -21,7 +21,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_mmu.h>
-#include <asm/kvm_psci.h>
+#include <kvm/arm_psci.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index a08d7a9..18f9e9d 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -21,8 +21,8 @@
 
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_psci.h>
 #include <asm/kvm_host.h>
+#include <kvm/arm_psci.h>
 
 #include <uapi/linux/psci.h>
 
diff --git a/arch/arm64/include/asm/kvm_psci.h b/arch/arm64/include/asm/kvm_psci.h
deleted file mode 100644
index bc39e55..0000000
--- a/arch/arm64/include/asm/kvm_psci.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2012,2013 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __ARM64_KVM_PSCI_H__
-#define __ARM64_KVM_PSCI_H__
-
-#define KVM_ARM_PSCI_0_1	1
-#define KVM_ARM_PSCI_0_2	2
-
-int kvm_psci_version(struct kvm_vcpu *vcpu);
-int kvm_psci_call(struct kvm_vcpu *vcpu);
-
-#endif /* __ARM64_KVM_PSCI_H__ */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5b56b09..0231ebc 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -22,12 +22,13 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <kvm/arm_psci.h>
+
 #include <asm/esr.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
-#include <asm/kvm_psci.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
new file mode 100644
index 0000000..2042bb9
--- /dev/null
+++ b/include/kvm/arm_psci.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __KVM_ARM_PSCI_H__
+#define __KVM_ARM_PSCI_H__
+
+#define KVM_ARM_PSCI_0_1	1
+#define KVM_ARM_PSCI_0_2	2
+
+int kvm_psci_version(struct kvm_vcpu *vcpu);
+int kvm_psci_call(struct kvm_vcpu *vcpu);
+
+#endif /* __KVM_ARM_PSCI_H__ */
-- 
2.7.4
