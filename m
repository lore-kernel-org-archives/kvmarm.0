Return-Path: <SRS0=JhWI=QC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889BBC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F9A861B72
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3F9A861B72
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7AD64B1C1;
	Mon, 15 Nov 2021 11:55:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v8Kysc020j-O; Mon, 15 Nov 2021 11:55:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 890FA4B1FC;
	Mon, 15 Nov 2021 11:55:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 744CF4B150
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LURRSTt7F+s5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Nov 2021 11:55:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 576AE4B1D4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 115041FB;
 Mon, 15 Nov 2021 08:55:36 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92CF53F766;
 Mon, 15 Nov 2021 08:55:34 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com
Subject: [PATCH kvmtool 6/9] util: Add basic cpumask functions
Date: Mon, 15 Nov 2021 16:57:02 +0000
Message-Id: <20211115165705.195736-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165705.195736-1-alexandru.elisei@arm.com>
References: <20211115165705.195736-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Add a handful of basic cpumask functions, some of which will be used when
dealing with different PMUs on heterogeneous systems.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/include/asm/kernel.h |  8 ++++++++
 arm/aarch64/include/asm/kernel.h |  8 ++++++++
 include/linux/bitmap.h           | 20 +++++++++++++++++++
 include/linux/cpumask.h          | 33 ++++++++++++++++++++++++++++++++
 include/linux/kernel.h           |  2 ++
 mips/include/asm/kernel.h        |  8 ++++++++
 powerpc/include/asm/kernel.h     |  8 ++++++++
 x86/include/asm/kernel.h         |  8 ++++++++
 8 files changed, 95 insertions(+)
 create mode 100644 arm/aarch32/include/asm/kernel.h
 create mode 100644 arm/aarch64/include/asm/kernel.h
 create mode 100644 include/linux/bitmap.h
 create mode 100644 include/linux/cpumask.h
 create mode 100644 mips/include/asm/kernel.h
 create mode 100644 powerpc/include/asm/kernel.h
 create mode 100644 x86/include/asm/kernel.h

diff --git a/arm/aarch32/include/asm/kernel.h b/arm/aarch32/include/asm/kernel.h
new file mode 100644
index 000000000000..61296094deb1
--- /dev/null
+++ b/arm/aarch32/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	32
+
+#endif /* __ASM_KERNEL_H */
diff --git a/arm/aarch64/include/asm/kernel.h b/arm/aarch64/include/asm/kernel.h
new file mode 100644
index 000000000000..4ab195fcb89d
--- /dev/null
+++ b/arm/aarch64/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	512
+
+#endif /* __ASM_KERNEL_H */
diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
new file mode 100644
index 000000000000..33b24520a576
--- /dev/null
+++ b/include/linux/bitmap.h
@@ -0,0 +1,20 @@
+#ifndef KVM__BITMAP_H
+#define KVM__BITMAP_H
+
+#include <string.h>
+
+#include <linux/bitops.h>
+
+#define DECLARE_BITMAP(name,bits) \
+	unsigned long name[BITS_TO_LONGS(bits)]
+
+#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
+#define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
+
+static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
+{
+	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+	memset(dst, 0, len);
+}
+
+#endif /* KVM__BITMAP_H */
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
new file mode 100644
index 000000000000..36959885aeff
--- /dev/null
+++ b/include/linux/cpumask.h
@@ -0,0 +1,33 @@
+#ifndef KVM__CPUMASK_H
+#define KVM__CPUMASK_H
+
+#include <stdbool.h>
+
+#include <linux/bitmap.h>
+#include <linux/kernel.h>
+
+typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
+
+#define cpumask_bits(maskp)	((maskp)->bits)
+
+static inline void cpumask_set_cpu(int cpu, cpumask_t *dstp)
+{
+	set_bit(cpu, cpumask_bits(dstp));
+}
+
+static inline void cpumask_clear_cpu(int cpu, cpumask_t *dstp)
+{
+	clear_bit(cpu, cpumask_bits(dstp));
+}
+
+static inline int cpumask_test_cpu(int cpu, const cpumask_t *cpumask)
+{
+	return test_bit(cpu, cpumask_bits((cpumask)));
+}
+
+static inline void cpumask_clear(cpumask_t *dstp)
+{
+	bitmap_zero(cpumask_bits(dstp), NR_CPUS);
+}
+
+#endif /* KVM__CPUMASK_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f2bff5f12b61..f3240e09a321 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -2,6 +2,8 @@
 #ifndef KVM__LINUX_KERNEL_H_
 #define KVM__LINUX_KERNEL_H_
 
+#include <asm/kernel.h>
+
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
diff --git a/mips/include/asm/kernel.h b/mips/include/asm/kernel.h
new file mode 100644
index 000000000000..cbceffd02acd
--- /dev/null
+++ b/mips/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	256
+
+#endif /* __ASM_KERNEL_H */
diff --git a/powerpc/include/asm/kernel.h b/powerpc/include/asm/kernel.h
new file mode 100644
index 000000000000..7b4fe88efd65
--- /dev/null
+++ b/powerpc/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_KERNEL_H
+#define __ASM_KERNEL_H
+
+#define NR_CPUS	2048
+
+#endif /* __ASM_KERNEL_H */
diff --git a/x86/include/asm/kernel.h b/x86/include/asm/kernel.h
new file mode 100644
index 000000000000..87fad2a0300a
--- /dev/null
+++ b/x86/include/asm/kernel.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _ASM_KERNEL_H
+#define _ASM_KERNEL_H
+
+#define NR_CPUS	8196
+
+#endif /* _ASM_KERNEL_H */
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
