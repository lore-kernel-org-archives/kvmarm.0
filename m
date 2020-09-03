Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F89C433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47CB3208B3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PmRfby3h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47CB3208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E97264B2C9;
	Thu,  3 Sep 2020 09:53:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3GmtSn+ExESr; Thu,  3 Sep 2020 09:53:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B051E4B2B3;
	Thu,  3 Sep 2020 09:53:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6054B29D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zcg5VLP7ku-N for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:16 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 957CD4B29C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:16 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id y32so1881157qve.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=HMI50EVPzeYiaF7m1ikQ30B81RDqMtBiHFE/tVtsY8s=;
 b=PmRfby3hXid6gZ4VJt7FioQeg5+3eK9LDh3RE5BDeL2Hb7r3AjGS1aJzm9ov5o4S6x
 2sRRMrQ+1rbi/H7LLAKK8XACU734J58OA4r3vTTkfGy3SzH/pHJ5T8LWFudF5XP/0bBL
 2144S/NI+nUCyrTBwIhFLNfUybR5Wp0YYBQH1HazGExBTF8vcRkKFPJPLtYuEwU3L7Nc
 iaXV9YNP0NNYcCF/FDgUgaFYN7s2TrHL5AxIwyPJs3zMrhymXYuFR+kt86kX1GLnZzEu
 jUn5uBk71CsKViI48sIFYb4WPpFNYz61DeL3Wem6Nd9ne9z2VD36MWTs60rINOBY7hv0
 VJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HMI50EVPzeYiaF7m1ikQ30B81RDqMtBiHFE/tVtsY8s=;
 b=o/pknd34EURmY3uafgXrSNzx4do7YeyatseZ26WbksFFSxs+xaC9m8HJ65Q1ikeK//
 WK/lsKcqGu1S/9QR/hX6UEIL9QENgMOfGjCXIyRhv1hUK97COI94vbTtdJMUteSXrTe9
 z3oMrpkfk8nOpZJSPuTyvXsCpc7nl15clHqVUbkx4nde0w/0TRv+w12VIWxP3x2tCmss
 foJaIUIbMxUp/I+pkgNK0qp374q5v+S7TF+cTEFafTEN5XH/xjRKb2WmoxzFG8bti/5W
 G+OXR3A03G6h0wuDpahGk5DprwPx2R9EJDaQePkUqGKPSnTNdFT6KUUvYixP1f5fVBLv
 H2Yw==
X-Gm-Message-State: AOAM531vdKi2b0CGxx6jxub8spRfPIDyORhoTMT4B5netXE4Y8RPebD1
 qx3cM0GShgVAF8TwgdCUgGz3Wy/jvboVvjl41apHCF1x8OM0X8qYZ9ONlv1Cb5TO3cHzOlLJ3TS
 KgMa+IofjHB2RQU558d0y3thPyxgT0372jEOu0WIC4d9l5wSiQn8/E10iVxpTmfxdtLa6HQ==
X-Google-Smtp-Source: ABdhPJzGm97exg9+3Wae5DvDYOFZq8/kUwYyaJUF8OCkpkjtBu4H5CebmamII8OZ8XG1lG3ex60/Bqb09Lg=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:e892:: with SMTP id
 b18mr1984087qvo.5.1599141196120; 
 Thu, 03 Sep 2020 06:53:16 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:51 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-3-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 02/18] KVM: arm64: Remove hyp_panic arguments
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

hyp_panic is able to find all the context it needs from within itself so
remove the argument. The __hyp_panic wrapper becomes redundant so is
also removed.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h        | 2 +-
 arch/arm64/kvm/hyp/hyp-entry.S          | 7 +------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 +---
 arch/arm64/kvm/hyp/nvhe/switch.c        | 4 +++-
 arch/arm64/kvm/hyp/vhe/switch.c         | 4 +++-
 5 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 46689e7db46c..3de99b323061 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -89,7 +89,7 @@ void deactivate_traps_vhe_put(void);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt);
+void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(unsigned long, ...);
 #endif
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 46b4dab933d0..9cb3fbca5d79 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -210,12 +210,7 @@ SYM_FUNC_START(__hyp_do_panic)
 SYM_FUNC_END(__hyp_do_panic)
 #endif
 
-SYM_CODE_START(__hyp_panic)
-	get_host_ctxt x0, x1
-	b	hyp_panic
-SYM_CODE_END(__hyp_panic)
-
-.macro invalid_vector	label, target = __hyp_panic
+.macro invalid_vector	label, target = hyp_panic
 	.align	2
 SYM_CODE_START(\label)
 	b \target
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0864f88bc840..96ea3fdd0c20 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -510,13 +510,11 @@ static inline void __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
 static inline void __kvm_unexpected_el2_exception(void)
 {
 	unsigned long addr, fixup;
-	struct kvm_cpu_context *host_ctxt;
 	struct exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
 
 	entry = hyp_symbol_addr(__start___kvm_ex_table);
 	end = hyp_symbol_addr(__stop___kvm_ex_table);
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 
 	while (entry < end) {
 		addr = (unsigned long)&entry->insn + entry->insn;
@@ -531,7 +529,7 @@ static inline void __kvm_unexpected_el2_exception(void)
 		return;
 	}
 
-	hyp_panic(host_ctxt);
+	hyp_panic();
 }
 
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 3c9c065b3264..1e8a31b7c94c 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -242,11 +242,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
+	struct kvm_cpu_context *host_ctxt =
+		&__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	struct kvm_vcpu *vcpu = host_ctxt->__hyp_running_vcpu;
 	unsigned long str_va;
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 6636522a8529..835c2dfc7a9f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -208,8 +208,10 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par,
 }
 NOKPROBE_SYMBOL(__hyp_call_panic);
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(void)
 {
+	struct kvm_cpu_context *host_ctxt =
+		&__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
