Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5494DC4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E979360C40
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E979360C40
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1554B111;
	Sun, 15 Aug 2021 13:01:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dwgkefUK6mlE; Sun, 15 Aug 2021 13:01:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A2F74B136;
	Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5C504AC78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wXyw1Pcw1olt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 17:12:32 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6BCB49FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:32 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 h9-20020a17090a470900b001791c0352aaso4967744pjg.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 14:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xPoIZjuWep0XnVjE3RZ+lF+QPEA9z7qXvcODMX5rYnc=;
 b=tLRfwvEqQSqyt/QVk9wx8D1i5roaNJZj6Y5mrjVxRY1cOOFHxbrnZv08XP9BH1L505
 05zkQ7DDsCBnd64vOSatbSX7cA8NSLqLruoPgASiB/BO1N2h6DZRagt1p4QxemUYGpf8
 pFeogUFdUJgq3Nvf0WICqVvniiaK9AQW4t0+qXpXB5AfXgw/YUR57FXcBRFk6emIyfRE
 /bW1BmjYPUuzPzqKaumRv++9fULqs4udzSu66BBt2d3b3tH4uNyKZFJPyCDG+RlyGzpt
 C/OSN8S6lvFDoJZp03cISdKkVneS4Nn3S7zrGvVHVYSzyHyNDizFt5H9kcG0JxxG4FjL
 G5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xPoIZjuWep0XnVjE3RZ+lF+QPEA9z7qXvcODMX5rYnc=;
 b=I9DfPxQO+9f36bd06j+302fOZ5LqeeYv0jsJadfSNvfTnqozNk4uM5gEuse8QlPvWM
 kEEgKKqKThxyNre6AsKVdHVSAIojLQZJulxNMEgBnxevw2h/WZ+ACHTEb6jHLciKGNTo
 r9XVRhmdLd255khNRS0s6YyIk6S+RAi6QtNByJOVTjU7VFtsqSWsg7D6BCvkXlPgFQ3O
 S6GkcTJ7UUEZMI9A7JvpQm75tOcPIPGHEe0nYHpe4jO7aMIdS6tnTW3PzJG9L0jFUePX
 Cu5zdvE8hTxwmP9PmbS7BVWs0PTyoLW46HJN7ywpPJaCYKcZr2ncaMWiAZJFTDp/1Ji2
 17ig==
X-Gm-Message-State: AOAM530Ed/SIwL5T3Dqko6me30A/fxnt402BDSSEJDOUlR7GUK4J9I2/
 vnRBovzuxzD4I4dRItb6xqoIrDlXCTce
X-Google-Smtp-Source: ABdhPJzbmFEd2uQqU/4nZgMWFmmHA0gDdgA66TV1ZI72XcP1aFw7BHbaSHbuUfx6jZt0qaPY36m5ZWdfn0jK
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:ea91:b0:12d:7aa6:1e46 with SMTP id
 x17-20020a170902ea9100b0012d7aa61e46mr3558910plb.58.1628889151981; Fri, 13
 Aug 2021 14:12:31 -0700 (PDT)
Date: Fri, 13 Aug 2021 21:12:03 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-3-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 02/10] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Sun, 15 Aug 2021 13:01:04 -0400
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.cs.columbia.edu
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

For register names that are unsupported by the assembler or the ones
without architectural names, add the macros write_sysreg_s and
read_sysreg_s to support them.

The functionality is derived from kvm-unit-tests and kernel's
arch/arm64/include/asm/sysreg.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 14f68bf55036..b4bbce837288 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -115,6 +115,67 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+/*
+ * ARMv8 ARM reserves the following encoding for system registers:
+ * (Ref: ARMv8 ARM, Section: "System instruction class encoding overview",
+ *  C5.2, version:ARM DDI 0487A.f)
+ *	[20-19] : Op0
+ *	[18-16] : Op1
+ *	[15-12] : CRn
+ *	[11-8]  : CRm
+ *	[7-5]   : Op2
+ */
+#define Op0_shift	19
+#define Op0_mask	0x3
+#define Op1_shift	16
+#define Op1_mask	0x7
+#define CRn_shift	12
+#define CRn_mask	0xf
+#define CRm_shift	8
+#define CRm_mask	0xf
+#define Op2_shift	5
+#define Op2_mask	0x7
+
+/*
+ * When accessed from guests, the ARM64_SYS_REG() doesn't work since it
+ * generates a different encoding for additional KVM processing, and is
+ * only suitable for userspace to access the register via ioctls.
+ * Hence, define a 'pure' sys_reg() here to generate the encodings as per spec.
+ */
+#define sys_reg(op0, op1, crn, crm, op2) \
+	(((op0) << Op0_shift) | ((op1) << Op1_shift) | \
+	 ((crn) << CRn_shift) | ((crm) << CRm_shift) | \
+	 ((op2) << Op2_shift))
+
+asm(
+"	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
+"	.equ	.L__reg_num_x\\num, \\num\n"
+"	.endr\n"
+"	.equ	.L__reg_num_xzr, 31\n"
+"\n"
+"	.macro	mrs_s, rt, sreg\n"
+"	.inst	0xd5200000|(\\sreg)|(.L__reg_num_\\rt)\n"
+"	.endm\n"
+"\n"
+"	.macro	msr_s, sreg, rt\n"
+"	.inst	0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
+"	.endm\n"
+);
+
+/*
+ * read_sysreg_s() and write_sysreg_s()'s 'reg' has to be encoded via sys_reg()
+ */
+#define read_sysreg_s(reg) ({						\
+	u64 __val;							\
+	asm volatile("mrs_s %0, "__stringify(reg) : "=r" (__val));	\
+	__val;								\
+})
+
+#define write_sysreg_s(reg, val) do {					\
+	u64 __val = (u64)val;						\
+	asm volatile("msr_s "__stringify(reg) ", %x0" : : "rZ" (__val));\
+} while (0)
+
 #define write_sysreg(reg, val)						  \
 ({									  \
 	u64 __val = (u64)(val);						  \
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
