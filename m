Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14E2C2D0D2
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 13:56:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 643672465E
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 13:56:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 643672465E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B80FD4A94D;
	Tue, 17 Dec 2019 08:56:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HGV8Npj-jM3E; Tue, 17 Dec 2019 08:56:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E1A14A576;
	Tue, 17 Dec 2019 08:56:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EF084A576
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 08:56:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NQm2dwrW-l0n for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 08:56:34 -0500 (EST)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C06D4A3A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 08:56:34 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id C086CF8CE4FD6D29296B;
 Tue, 17 Dec 2019 21:56:30 +0800 (CST)
Received: from DESKTOP-1NISPDV.china.huawei.com (10.173.221.248) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 17 Dec 2019 21:56:24 +0800
From: <yezengruan@huawei.com>
To: <yezengruan@huawei.com>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <virtualization@lists.linux-foundation.org>
Subject: [PATCH 4/5] KVM: arm64: Add interface to support vcpu preempted check
Date: Tue, 17 Dec 2019 21:55:48 +0800
Message-ID: <20191217135549.3240-5-yezengruan@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20191217135549.3240-1-yezengruan@huawei.com>
References: <20191217135549.3240-1-yezengruan@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.221.248]
X-CFilter-Loop: Reflected
Cc: catalin.marinas@arm.com, daniel.lezcano@linaro.org, linux@armlinux.org.uk,
 steven.price@arm.com, maz@kernel.org, will@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Zengruan Ye <yezengruan@huawei.com>

This is to fix some lock holder preemption issues. Some other locks
implementation do a spin loop before acquiring the lock itself.
Currently kernel has an interface of bool vcpu_is_preempted(int cpu). It
takes the cpu as parameter and return true if the cpu is preempted.
Then kernel can break the spin loops upon the retval of vcpu_is_preempted.

As kernel has used this interface, So lets support it.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
---
 arch/arm64/include/asm/paravirt.h      | 12 ++++++++++++
 arch/arm64/include/asm/spinlock.h      |  7 +++++++
 arch/arm64/kernel/Makefile             |  2 +-
 arch/arm64/kernel/paravirt-spinlocks.c | 13 +++++++++++++
 arch/arm64/kernel/paravirt.c           |  4 +++-
 5 files changed, 36 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kernel/paravirt-spinlocks.c

diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index cf3a0fd7c1a7..7b1c81b544bb 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -11,8 +11,13 @@ struct pv_time_ops {
 	unsigned long long (*steal_clock)(int cpu);
 };
 
+struct pv_lock_ops {
+	bool (*vcpu_is_preempted)(int cpu);
+};
+
 struct paravirt_patch_template {
 	struct pv_time_ops time;
+	struct pv_lock_ops lock;
 };
 
 extern struct paravirt_patch_template pv_ops;
@@ -24,6 +29,13 @@ static inline u64 paravirt_steal_clock(int cpu)
 
 int __init pv_time_init(void);
 
+__visible bool __native_vcpu_is_preempted(int cpu);
+
+static inline bool pv_vcpu_is_preempted(int cpu)
+{
+	return pv_ops.lock.vcpu_is_preempted(cpu);
+}
+
 #else
 
 #define pv_time_init() do {} while (0)
diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
index b093b287babf..45ff1b2949a6 100644
--- a/arch/arm64/include/asm/spinlock.h
+++ b/arch/arm64/include/asm/spinlock.h
@@ -7,8 +7,15 @@
 
 #include <asm/qrwlock.h>
 #include <asm/qspinlock.h>
+#include <asm/paravirt.h>
 
 /* See include/linux/spinlock.h */
 #define smp_mb__after_spinlock()	smp_mb()
 
+#define vcpu_is_preempted vcpu_is_preempted
+static inline bool vcpu_is_preempted(long cpu)
+{
+	return pv_vcpu_is_preempted(cpu);
+}
+
 #endif /* __ASM_SPINLOCK_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index fc6488660f64..b23cdae433a4 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -50,7 +50,7 @@ obj-$(CONFIG_ARMV8_DEPRECATED)		+= armv8_deprecated.o
 obj-$(CONFIG_ACPI)			+= acpi.o
 obj-$(CONFIG_ACPI_NUMA)			+= acpi_numa.o
 obj-$(CONFIG_ARM64_ACPI_PARKING_PROTOCOL)	+= acpi_parking_protocol.o
-obj-$(CONFIG_PARAVIRT)			+= paravirt.o
+obj-$(CONFIG_PARAVIRT)			+= paravirt.o paravirt-spinlocks.o
 obj-$(CONFIG_RANDOMIZE_BASE)		+= kaslr.o
 obj-$(CONFIG_HIBERNATION)		+= hibernate.o hibernate-asm.o
 obj-$(CONFIG_KEXEC_CORE)		+= machine_kexec.o relocate_kernel.o	\
diff --git a/arch/arm64/kernel/paravirt-spinlocks.c b/arch/arm64/kernel/paravirt-spinlocks.c
new file mode 100644
index 000000000000..718aa773d45c
--- /dev/null
+++ b/arch/arm64/kernel/paravirt-spinlocks.c
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright(c) 2019 Huawei Technologies Co., Ltd
+ * Author: Zengruan Ye <yezengruan@huawei.com>
+ */
+
+#include <linux/spinlock.h>
+#include <asm/paravirt.h>
+
+__visible bool __native_vcpu_is_preempted(int cpu)
+{
+	return false;
+}
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 1ef702b0be2d..d8f1ba8c22ce 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -26,7 +26,9 @@
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
 
-struct paravirt_patch_template pv_ops;
+struct paravirt_patch_template pv_ops = {
+	.lock.vcpu_is_preempted		= __native_vcpu_is_preempted,
+};
 EXPORT_SYMBOL_GPL(pv_ops);
 
 struct pv_time_stolen_time_region {
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
