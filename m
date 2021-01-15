Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61017C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F10CB2396D
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F10CB2396D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A07C04B266;
	Fri, 15 Jan 2021 12:19:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LZ2Vw1EDe2jd; Fri, 15 Jan 2021 12:19:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36CB04B176;
	Fri, 15 Jan 2021 12:19:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E80D4B22B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bx0WJvR0dVkJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:19:16 -0500 (EST)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D0444B270
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:16 -0500 (EST)
Received: by mail-qk1-f202.google.com with SMTP id e25so8659720qka.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=iHVLKT2GDoD/bWysfKR91nfDSkdEIEEwPqsvUiYvewQ=;
 b=unnSOFGbj7bYH0H/CfqTTqhAsljbi+sSDonzIXbCfRF7iewo4PeFFpUK1S/em2X+rM
 j25bv/JtA6hqRivqRMgcMz19priFMFir91PJUhurQyaOkM8RiGvFvKWAq7DkCDnGa0/d
 lyTgIzQCS7p2tbDvRrmCjFWjy7UotZMN/lSOkRw/V6XAxApNu567s/4SqTMsBrdVvCiv
 zUL0lupK+jpd7pGMBLTK4gzWD8XztaGs1pHD2xlqn1fQduPBYYBvFZcjVkRuFQI+2euZ
 XYrgSPaqNhC7sxidOiyX/h1owrXH0fmG4y2m123yVDR4BZafeYTogGXsrwJNXvlvXNSX
 9Q4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iHVLKT2GDoD/bWysfKR91nfDSkdEIEEwPqsvUiYvewQ=;
 b=LZZdVDBpkIBKZMsqKjCEu8KzcUvHEBmlBRjEagIzfbdMaoiKqT++lj05m1Q2onno7v
 Z0uIFpcAKl3F5KnNTqpHlEnFA2U1mSVdt8fEjuj7qSCGIHG3QDntPWjOAZA8kWqI0WHg
 ZIg4/iqa5xrZY0HaJD3Y22hTAmw44TWiH8nPkQyaoq5KuyAyQg6u/HM6LbQoHldtgn2o
 DWl3pTKPoggl7Ks5PeQBUeqI4AVIBK1AGW8B22OSW5UUp4FNbP86qiS9BOXaRklDx2VP
 58feSFrZE8Q2WMBFzzKfZ9rOUsf99ofiAlRR11s9VBkt6pU+OX7uzInRTtj6bBvTu7Ec
 OF7A==
X-Gm-Message-State: AOAM532geaEkDVZjcs3Fb1ZAQdr8iD8UNalY1UEdyKBmiA+81oOSaWqH
 Z1VszkQpPQHVOMuwL7GZ3jagrZ2nExezRpxXNmRXhY45HWaq1XrBSZIm2jp48pEG79n8jfh2rvZ
 plvIeKgFF6WSsVpETaImPwY3P2F5BcX3Rn+zZf5Ce23TYRDtDWagX2T6jvvohiaCPmFh+rEGX
X-Google-Smtp-Source: ABdhPJxRGiugW2lCtf26zO/nfxMa2RoqN+pB/rzgJWom5N/4mvf0M7cLCSVGq7QosXUMoERXi86lNP0vt9AC
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a05:6214:321:: with SMTP id
 j1mr13395636qvu.32.1610731155510; Fri, 15 Jan 2021 09:19:15 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:30 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-10-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 9/9] KVM: arm64: Add UBSan tests for PKVM.
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: George-Aurelian Popescu <georgepope@google.com>,
 Elena Petrova <lenaptr@google.com>, Marc Zyngier <maz@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
 George Popescu <george.apopescu97@gmail.com>
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

From: George-Aurelian Popescu <georgepope@google.com>

Test the UBsan functionality inside hyp/nVHE.
Because modules are not supported inside of hyp/nVHE code, the default
testing module for UBSan can not be used.
New functions have to be defined inside of hyp/nVHE.
They are called in kvm_get_mdcr_el2, to test UBSAN whenever a VM starts.

Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/assembler.h          |  17 ++-
 arch/arm64/include/asm/kvm_debug_buffer.h   |  10 +-
 arch/arm64/include/asm/kvm_ubsan.h          |   2 +-
 arch/arm64/kvm/hyp/include/hyp/test_ubsan.h | 112 ++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c          |   3 +
 arch/arm64/kvm/kvm_ubsan_buffer.c           |   1 -
 6 files changed, 128 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/test_ubsan.h

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index ebc18a8a0e1f..8422b0d925e8 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -259,16 +259,15 @@ alternative_endif
 	.endm
 
 	/*
-         * @sym: The name of the per-cpu variable
-         * @reg: value to store
-         * @tmp1: scratch register
-         * @tmp2: scratch register
-         */
-        .macro str_this_cpu sym, reg, tmp1, tmp2
-        adr_this_cpu \tmp1, \sym, \tmp2
+	 * @sym: The name of the per-cpu variable
+	 * @reg: value to store
+	 * @tmp1: scratch register
+	 * @tmp2: scratch register
+	 */
+	.macro str_this_cpu sym, reg, tmp1, tmp2
+	adr_this_cpu \tmp1, \sym, \tmp2
         str \reg, [\tmp1]
-        .endm
-
+	.endm
 /*
  * vma_vm_mm - get mm pointer from vma pointer (vma->vm_mm)
  */
diff --git a/arch/arm64/include/asm/kvm_debug_buffer.h b/arch/arm64/include/asm/kvm_debug_buffer.h
index e5375c2cff1a..361b473bb004 100644
--- a/arch/arm64/include/asm/kvm_debug_buffer.h
+++ b/arch/arm64/include/asm/kvm_debug_buffer.h
@@ -3,10 +3,8 @@
  * Copyright 2020 Google LLC
  * Author: George Popescu <georgepope@google.com>
  */
-
 #include <linux/percpu-defs.h>
 
-
 #define KVM_DEBUG_BUFFER_SIZE 1000
 
 #ifdef __KVM_NVHE_HYPERVISOR__
@@ -20,17 +18,17 @@
 #else
 #define DECLARE_KVM_DEBUG_BUFFER(type_name, buffer_name, write_ind, size)\
 	DECLARE_KVM_NVHE_PER_CPU(type_name, buffer_name)[size]; 	\
-        DECLARE_KVM_NVHE_PER_CPU(unsigned long, write_ind);
+	DECLARE_KVM_NVHE_PER_CPU(unsigned long, write_ind);
 #endif //__KVM_NVHE_HYPERVISOR__
 
 #ifdef __ASSEMBLY__
 #include <asm/assembler.h>
 
 .macro clear_buffer tmp1, tmp2, tmp3
-        mov \tmp1, 0
+	mov \tmp1, 0
 #ifdef CONFIG_UBSAN
-        str_this_cpu kvm_ubsan_buff_wr_ind, \tmp1, \tmp2, \tmp3
+	str_this_cpu kvm_ubsan_buff_wr_ind, \tmp1, \tmp2, \tmp3
 #endif //CONFIG_UBSAN
 .endm
 
-#endif
\ No newline at end of file
+#endif
diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index da4a3b4e28e0..0b8bed08d48e 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -9,7 +9,6 @@
 #define UBSAN_MAX_TYPE 6
 #define KVM_UBSAN_BUFFER_SIZE 1000
 
-
 struct ubsan_values {
 	void *lval;
 	void *rval;
@@ -18,6 +17,7 @@ struct ubsan_values {
 
 struct kvm_ubsan_info {
 	enum {
+		UBSAN_NONE,
 		UBSAN_OUT_OF_BOUNDS,
 		UBSAN_UNREACHABLE_DATA,
 		UBSAN_SHIFT_OUT_OF_BOUNDS,
diff --git a/arch/arm64/kvm/hyp/include/hyp/test_ubsan.h b/arch/arm64/kvm/hyp/include/hyp/test_ubsan.h
new file mode 100644
index 000000000000..07759c0d1e0e
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/test_ubsan.h
@@ -0,0 +1,112 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include <linux/ctype.h>
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
+static void test_ubsan(void)
+{
+	unsigned int i;
+	
+	for (i = 0; i < ARRAY_SIZE(test_ubsan_array); i++)
+		test_ubsan_array[i]();
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a906f9e2ff34..939600e9fdd6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_mmu.h>
 
 #include <nvhe/trap_handler.h>
+#include <hyp/test_ubsan.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
@@ -90,6 +91,8 @@ static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
 {
 	cpu_reg(host_ctxt, 1) = __kvm_get_mdcr_el2();
+	if (IS_ENABLED(CONFIG_TEST_UBSAN))
+		test_ubsan();
 }
 
 static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index 2c7060cbb48b..49bedc9de139 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -11,7 +11,6 @@
 #include <asm/kvm_asm.h>
 #include <kvm/arm_pmu.h>
 
-#include <ubsan.h>
 #include <asm/kvm_ubsan.h>
 
 DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
-- 
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
