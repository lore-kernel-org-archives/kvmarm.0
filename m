Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C45DC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08413610FE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 08413610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9F51401A2;
	Wed, 18 Aug 2021 16:00:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c6svep8FkBW8; Wed, 18 Aug 2021 16:00:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36C054B0F4;
	Wed, 18 Aug 2021 15:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A19E49F5F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CPDPw3P8liZD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:43:22 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1067E407A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:22 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 z127-20020a6265850000b029039e815e04d6so1774074pfb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xPoIZjuWep0XnVjE3RZ+lF+QPEA9z7qXvcODMX5rYnc=;
 b=i9ROhHHLC7+9XVDXCedC9jm56keI2vlEBmvdJN8VFYKW+DoVJfmSia7ZbiPQwaV13S
 m//FjRqZlmB/Q0f4AgFaoRaX/xkqgrcfzh/dhrvnHOiri2x2oUE9qLfITAOgxBFD8N1E
 zWJR3aoeJ3Iq1mFLBeDwgc9cD5oRixUA5X8I/zM/bpb4/NNLJIHYswIuAXFLy4yBf23X
 aPGFRZ+8oe74OomG/nGQt6VI031c3kuPNtvJUqpXAwYjFgJ9sRUDijE39mW4TJNA1O9H
 WB5ZV2iG5E5YREdy1Pt98gbJ8L5AQpYTJNd1flPj/DpVGCfmvdZo/707zZfa+nkMezBs
 Lc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xPoIZjuWep0XnVjE3RZ+lF+QPEA9z7qXvcODMX5rYnc=;
 b=gO+qKn7zr8tW7Si5qBUIMM1lxlkbTBb9zUq463+bKDmZ5Oks7ikfQNsOuH+tPShQKI
 T8oehvhQdALQXG7VvSenIvObMh1oBKvrmwWdQWKIgfrsI32puUd5jZ1ldPmUxHxnWHC4
 ssJ8VDgbHbvE+CLZiYnmHwC0OyOYOKXHAKXEIMgY3bBGuX0iB0epLHpGdwbQQb+h10Db
 1hagCliR7rJm5Hs34Dpit7mUrQmYVB2ZQGaS8qBnp4Sxjh2qbuhQkVIuNY+syuNGUAfC
 34ddHLXwyzlWnfIuMEwCheckxFtaaKSNPqpgKiT0zCmNVq1omQxWwNm44dsg3MHqgwLq
 pYnQ==
X-Gm-Message-State: AOAM533tB0iVFIRgK4yAtl/qPsl9k8/qyecO/cVnGNKiSwe22eKxS+ii
 zjPbflKBvLrFYw0UwnCdGBh+VXsIMPE+
X-Google-Smtp-Source: ABdhPJzx7O78WEN4MoFWpeiB6hWgg45bljg5ENDsoLX3FLeJ/Yl4YexADXJn8SvFup4tTD/118WwthhmvMgL
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:a503:b029:12b:2429:385e with SMTP
 id s3-20020a170902a503b029012b2429385emr8393704plq.64.1629312201293; Wed, 18
 Aug 2021 11:43:21 -0700 (PDT)
Date: Wed, 18 Aug 2021 18:43:03 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-3-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 02/10] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 18 Aug 2021 15:59:47 -0400
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
