Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257C9C43461
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7D3520771
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="jW8otPoo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7D3520771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 590224B590;
	Mon, 14 Sep 2020 13:28:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KBl4gj0jfoik; Mon, 14 Sep 2020 13:28:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 625794B5B4;
	Mon, 14 Sep 2020 13:28:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18DE24B163
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DLRUaCwwJvBG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:28 -0400 (EDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0BB84B188
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:27 -0400 (EDT)
Received: by mail-wm1-f45.google.com with SMTP id e17so828905wme.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=80sUfzO1ZftIFVscZ9nv5OunuS9GCgF/C+i0bRP7nsw=;
 b=jW8otPoov1Khx2LUvHQVCmuvY73d3lv+staZhypFM7PaTDqnYWOwAxWZuVOecCVq7S
 vu4asBNBaOc1VPCOdQdDJKYaUb+JX4H7d19I0+68AyC6TGKhvH2ipYYCW29UT7odHYq5
 itib7ImtZcY8zZGn47F0Jqev/Ht2LRLB/x1+veym+c4b+ELSLExiHtjRERUckezBaaFy
 80dcQuOiy52I+XEVxxnnXlNcdLqcHQrnPc8neBdQCGT15fQ2TvwmlDkNWCqX8JPC71Wo
 RnZvt2JYdae4/TYaC71W/VmbpSRqHKkPRlaS/Fzs2WZTAqGbI9vwZx6nDpohVFlSFy05
 T69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=80sUfzO1ZftIFVscZ9nv5OunuS9GCgF/C+i0bRP7nsw=;
 b=L4+vyRaxSUiUbCHVuYUSUnwMXOJSKtdcHvtpFxWcB1H6d+AA7olLZSLcsZkO0xoig0
 B6KhzOuJv6up0gzFi8U15cSjWXvbGwOPpG3Cmpv8gz1rZdfhNFmi5NY5n8iR9YTb6Oyb
 jXKiFTD0sAfscBpBj/nfu+7hauqAS5PxhJ1FAlKjnwcXbD1VPUCA3fZBYCJG529VGf0y
 drMWC6t6hTPrbtV7bYYrDgy0/yitMP7k2h1dZHNhwDKtZzqFX8WXjVB63k1RwP6HO481
 CVzRdyNPJtYHlYYMglgZ6ckm1WH4h29aM11Gvc79PU70q5ABqWYqen96Lj6QT/KMB7vO
 BFRw==
X-Gm-Message-State: AOAM53171y35DJwd81gXJ2KyEh7M6KvbZvfsH98EMUlru+oL6g6TLFzu
 o8YBxij5DV9snoIMKIjtccxpiQ==
X-Google-Smtp-Source: ABdhPJzbmBwXiCE6I0xucSZp+HgdOu9Gy5GeiJW6u2E8Bzpwxsz/xK+n4Xs62K/mJ7h3weUdTVHnyg==
X-Received: by 2002:a1c:6487:: with SMTP id y129mr490641wmb.90.1600104506813; 
 Mon, 14 Sep 2020 10:28:26 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id b11sm22135485wrt.38.2020.09.14.10.28.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:26 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 13/14] KVM: arm64: Enable the CONFIG_TEST UBSan for PKVM.
Date: Mon, 14 Sep 2020 17:27:49 +0000
Message-Id: <20200914172750.852684-14-georgepope@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200914172750.852684-1-georgepope@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
MIME-Version: 1.0
Cc: arnd@arndb.de, elver@google.com, tglx@linutronix.de, keescook@chromium.org,
 maskray@google.com, linux-kbuild@vger.kernel.org, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 clang-built-linux@googlegroups.com, broonie@kernel.org, dvyukov@google.com,
 natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
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

From: George Popescu <georgepope@google.com>

Test the UBsan functionality for the hyp/nVHE code.
Because modules are not supported inside of hyp/nVHE code, the default
testing module for UBSan can not be used. For this purpose new functions
are defined inside of hyp/nVHE.

Test UBSan only when the hypervisor is initialized to prevent spamming
the boot messages.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/kvm/Kconfig               |   3 +
 arch/arm64/kvm/arm.c                 |   8 ++
 arch/arm64/kvm/hyp/nvhe/Makefile     |   1 +
 arch/arm64/kvm/hyp/nvhe/ubsan_test.c | 115 +++++++++++++++++++++++++++
 4 files changed, 127 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ubsan_test.c

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 318c8f2df245..b6581f2512fb 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -60,6 +60,9 @@ config KVM_ARM_PMU
 config KVM_INDIRECT_VECTORS
 	def_bool HARDEN_BRANCH_PREDICTOR || RANDOMIZE_BASE
 
+config NVHE_KVM_TEST_UBSAN
+	def_bool (TEST_UBSAN != n)
+
 endif # KVM
 
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index eff57069e103..5468fa5599cf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1297,6 +1297,14 @@ static void cpu_init_hyp_mode(void)
 	BUG_ON(!system_capabilities_finalized());
 	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
 
+#ifdef CONFIG_NVHE_KVM_TEST_UBSAN
+	static bool test_ubsan_run;
+
+	if (!test_ubsan_run && (smp_processor_id() == 0)) {
+		test_ubsan_run = true;
+		kvm_call_hyp_nvhe(__kvm_test_ubsan);
+	}
+#endif
 	/*
 	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
 	 * at EL2.
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index cc082e516353..2b495fe41f2b 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -12,6 +12,7 @@ obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 
 CFLAGS_ubsan.hyp.tmp.o += -I $(srctree)/lib/
 obj-$(CONFIG_UBSAN) += ubsan.o
+obj-$(CONFIG_NVHE_KVM_TEST_UBSAN) += ubsan_test.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan_test.c b/arch/arm64/kvm/hyp/nvhe/ubsan_test.c
new file mode 100644
index 000000000000..f4e7b3ed3cf5
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan_test.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/percpu-defs.h>
+#include <asm/kvm_asm.h>
+
+typedef void(*test_ubsan_fp)(void);
+
+static void test_ubsan_add_overflow(void)
+{
+	volatile int val = INT_MAX;
+
+	val += 2;
+}
+
+static void test_ubsan_sub_overflow(void)
+{
+	volatile int val = INT_MIN;
+	volatile int val2 = 2;
+
+	val -= val2;
+}
+
+static void test_ubsan_mul_overflow(void)
+{
+	volatile int val = INT_MAX / 2;
+
+	val *= 3;
+}
+
+static void test_ubsan_negate_overflow(void)
+{
+	volatile int val = INT_MIN;
+
+	val = -val;
+}
+
+static void test_ubsan_divrem_overflow(void)
+{
+	volatile int val = 16;
+	volatile int val2 = 0;
+
+	val /= val2;
+}
+
+static void test_ubsan_shift_out_of_bounds(void)
+{
+	volatile int val = -1;
+	int val2 = 10;
+
+	val2 <<= val;
+}
+
+static void test_ubsan_out_of_bounds(void)
+{
+	volatile int i = 4, j = 5;
+	volatile int arr[4];
+
+	arr[j] = i;
+}
+
+static void test_ubsan_load_invalid_value(void)
+{
+	volatile char *dst, *src;
+	bool val, val2, *ptr;
+	char c = 4;
+
+	dst = (char *)&val;
+	src = &c;
+	*dst = *src;
+
+	ptr = &val2;
+	val2 = val;
+}
+
+static void test_ubsan_misaligned_access(void)
+{
+	volatile char arr[5] __aligned(4) = {1, 2, 3, 4, 5};
+	volatile int *ptr, val = 6;
+
+	ptr = (int *)(arr + 1);
+	*ptr = val;
+}
+
+static void test_ubsan_object_size_mismatch(void)
+{
+	/* "((aligned(8)))" helps this not into be misaligned for ptr-access. */
+	volatile int val __aligned(8) = 4;
+	volatile long long *ptr, val2;
+
+	ptr = (long long *)&val;
+	val2 = *ptr;
+}
+
+static const test_ubsan_fp test_ubsan_array[] = {
+	test_ubsan_out_of_bounds,
+	test_ubsan_add_overflow,
+	test_ubsan_sub_overflow,
+	test_ubsan_mul_overflow,
+	test_ubsan_negate_overflow,
+	test_ubsan_divrem_overflow,
+	test_ubsan_shift_out_of_bounds,
+	test_ubsan_load_invalid_value,
+	test_ubsan_misaligned_access,
+	test_ubsan_object_size_mismatch,
+};
+
+void __kvm_test_ubsan(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_ubsan_array); i++)
+		test_ubsan_array[i]();
+}
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
