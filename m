Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0FEC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:34:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8DCE361076
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:34:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8DCE361076
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 220434B27E;
	Thu,  7 Oct 2021 19:34:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sHObmgE1-vXF; Thu,  7 Oct 2021 19:34:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EACC94B2AA;
	Thu,  7 Oct 2021 19:34:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79FF64B273
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:34:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vZv1fZBjpASa for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 19:34:50 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3D2E4B259
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:34:49 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 z2-20020a254c02000000b005b68ef4fe24so10095485yba.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 16:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DBO4AQdntb3BVMd9aTch+KZ6AR9uCpH0bw1K04j1fDg=;
 b=ARpgMqWjWNVSj+8W7+010xBn3FW/tNskv+xQG3e0yz5gLrFEzDJ+2s/O7Y1fpERJ6P
 ppRhwdqaqHMsR6b71SAFtoHB+yaLu0Qgn80I9m9mjCpEEH5LlzQRrrpDcHSZUyASE01C
 bNGOidHNcdHHtOnt6eCdAAPfkFxjXBwoqH2Wuw+gbzyfVnQ49jkwEuXMk++6AuviLBWB
 oBJDsuahFDjhWuQKOfcY0HZaBnMokKPJVr0UfcXD61ZreD28i/1W6+6p5P56fHNSa+0y
 00ANJDmmc0UR2Qa2NX63DbccyUyB6NqkR0x1U/0gpVLompX9ca8U49vY6SxHxdo5xN5G
 rCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DBO4AQdntb3BVMd9aTch+KZ6AR9uCpH0bw1K04j1fDg=;
 b=q8+0Aw549H42AOmMjiathuOu2Pf5IklKOSo0g3bJIFR3ycGvrkRFWLL1t66ZBGC+fP
 dlAWp+loDkpZ3fkinwQUbuYBVcQ3GQbBOvA1R/nYlg+Aw2bW7nb6ZkBwwtbhIeLxX9D1
 WL7iobySqd7Ey7n/zygCMehdBMnnDtMZoPDdI1YRCzK6ww3poM0Xc53bLaGveddUqeml
 2JNGpQZefwlaA3CyqCTHCtyXAZTMsaZYz+2CAcreGLK/BmS2+hvn6FmxSgvzUes8mRYg
 JHuirEz65pSUD/5r5y4Purh1D+9sX3mB0CxWhHi1maD+2wa7V09VTLtHl7jgTqbY3w+e
 ONGA==
X-Gm-Message-State: AOAM531dc1sl3zmZIaWWQCqO8N22XOK1fV4Cc75/yia/a28CHUnBz5J+
 3yphiI396qXdMOdRo7u2q2B/quq/Xwd2
X-Google-Smtp-Source: ABdhPJwl5DFhG5Udcr24wfbo8ndztL2u+e+yHmwZAYy9o9DxoQ8DBaTdXFxSljDpoQjUMHomFNZy2ibYCFRr
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:38cc:: with SMTP id
 f195mr8368167yba.98.1633649689167; Thu, 07 Oct 2021 16:34:49 -0700 (PDT)
Date: Thu,  7 Oct 2021 23:34:25 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-2-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 01/15] KVM: arm64: selftests: Add MMIO readl/writel support
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Define the readl() and writel() functions for the guests to
access (4-byte) the MMIO region.

The routines, and their dependents, are inspired from the kernel's
arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 46 ++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c0273aefa63d..96578bd46a85 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -9,6 +9,7 @@
 
 #include "kvm_util.h"
 #include <linux/stringify.h>
+#include <linux/types.h>
 
 
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
@@ -130,6 +131,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
 	val;								  \
 })
 
-#define isb()	asm volatile("isb" : : : "memory")
+#define isb()		asm volatile("isb" : : : "memory")
+#define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
+#define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
+
+#define dma_wmb()	dmb(oshst)
+#define __iowmb()	dma_wmb()
+
+#define dma_rmb()	dmb(oshld)
+
+#define __iormb(v)							\
+({									\
+	unsigned long tmp;						\
+									\
+	dma_rmb();							\
+									\
+	/*								\
+	 * Courtesy of arch/arm64/include/asm/io.h:			\
+	 * Create a dummy control dependency from the IO read to any	\
+	 * later instructions. This ensures that a subsequent call	\
+	 * to udelay() will be ordered due to the ISB in __delay().	\
+	 */								\
+	asm volatile("eor	%0, %1, %1\n"				\
+		     "cbnz	%0, ."					\
+		     : "=r" (tmp) : "r" ((unsigned long)(v))		\
+		     : "memory");					\
+})
+
+static __always_inline void __raw_writel(u32 val, volatile void *addr)
+{
+	asm volatile("str %w0, [%1]" : : "rZ" (val), "r" (addr));
+}
+
+static __always_inline u32 __raw_readl(const volatile void *addr)
+{
+	u32 val;
+	asm volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
+	return val;
+}
+
+#define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
+#define readl_relaxed(c)	({ u32 __r = le32_to_cpu((__force __le32)__raw_readl(c)); __r; })
+
+#define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
+#define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
 
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
