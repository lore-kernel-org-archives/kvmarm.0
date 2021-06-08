Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE025C47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5494B6127A
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5494B6127A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08BB24086D;
	Tue,  8 Jun 2021 10:11:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bEYTeuY+3YTT; Tue,  8 Jun 2021 10:11:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB41040895;
	Tue,  8 Jun 2021 10:11:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 140914079A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sCZ0P6LRJFC0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:11:48 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12FBF40839
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:48 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 2-20020a0562140d62b02902357adaa890so2131063qvs.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lEQfWIvSuih1YUpi7yyWojQYEY8kugo/1cbYclEIxws=;
 b=uZjVhf+SaX5NhU2v+yADRB6IWcYIbpRYEopXUqQSA60vQ3K29QLZLD1tLPEmzp2rLT
 QS7kRl9HnYrcUA6EURzPaz3nS6EOeguVA/ymCgc83BhscaO9QAbHkT4T4DI54YU3nGx8
 q1QeXdnPGyRg6zso6ZZv3Yfoa10+GM1m5ECmbuAxIRUcH/OB2cRQA86CNPX+qVm/xTcB
 bbtxa7b+aiImVeFKmfXPTmr1OggH4VgwhlJEr2TY19UIPJgdeY/jZvVKRsCV1BAsufMo
 AE0EDeNeEnRNZ4QRBqjuCB15JWp2pZ2oRLOulBogJul267MYZsgQrSueFQy9S0VtcYrr
 sLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lEQfWIvSuih1YUpi7yyWojQYEY8kugo/1cbYclEIxws=;
 b=IXC3Whbe7BIlVCOR8tgRGfkE4a6DULkXlJ6A/jWYFSmpb4REOh85ww5ooz3SvxIeqU
 Kkv94IhIp3TQ5SKpm6RyeG/6dx0zx5+/UFrpbKX4miTU1hrtUawF//Q+C9wZEH3V1fF5
 Vs8VLAz94f9gzqzUDunmasa4sOkdlXL4kqeyio8zeaZhlOUlXiH9cBfnNkWFMqi+vaMo
 3K6tp6ZyLJhfjBUEmLlvq3NKWZz+oILBnNnBkE9dRHAHj3gmMHcgpq5HStId2JpK9zQd
 IK6/hCQgKPPQ4NM878mbMn4EDk+KZZjN7h0nFxyR4k1FmAYMcPf5vNQeC4+vIfu6K4cP
 echg==
X-Gm-Message-State: AOAM533ey316j8epx/Gd1efMau7ia8JFrjW4cfL/YP1EhhiLxSn++ss3
 sOYqv9DugKPyUZPaCbM05FVHtWph1aPpFm0MqXZ8vVRcDG4epnP1uVXPoVxhaXQp0rEUUfcuEgl
 0gn8YKpwK0IGsTZC1xZtSlAa5R/zsxux2uv88yVTb2DJOrfryAIETcRx/SXuxlDyWXHA=
X-Google-Smtp-Source: ABdhPJwH4/F7EqZH/DqsA6koDO/Z9s4b3+g7fIjDicnVAVuUF8cTid6FIpOoM2uvjjVN/hYL6pFF/jeutg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:e902:: with SMTP id
 a2mr23770510qvo.39.1623161507305; 
 Tue, 08 Jun 2021 07:11:47 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:30 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-3-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 02/13] KVM: arm64: MDCR_EL2 is a 64-bit register
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Fix the places in KVM that treat MDCR_EL2 as a 32-bit register.
More recent features (e.g., FEAT_SPEv1p2) use bits above 31.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h   | 20 ++++++++++----------
 arch/arm64/include/asm/kvm_asm.h   |  2 +-
 arch/arm64/include/asm/kvm_host.h  |  2 +-
 arch/arm64/kvm/debug.c             |  5 +++--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  2 +-
 arch/arm64/kvm/hyp/vhe/debug-sr.c  |  2 +-
 6 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 692c9049befa..25d8a61888e4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -280,18 +280,18 @@
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
-#define MDCR_EL2_TTRF		(1 << 19)
-#define MDCR_EL2_TPMS		(1 << 14)
+#define MDCR_EL2_TTRF		(UL(1) << 19)
+#define MDCR_EL2_TPMS		(UL(1) << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
-#define MDCR_EL2_TDRA		(1 << 11)
-#define MDCR_EL2_TDOSA		(1 << 10)
-#define MDCR_EL2_TDA		(1 << 9)
-#define MDCR_EL2_TDE		(1 << 8)
-#define MDCR_EL2_HPME		(1 << 7)
-#define MDCR_EL2_TPM		(1 << 6)
-#define MDCR_EL2_TPMCR		(1 << 5)
-#define MDCR_EL2_HPMN_MASK	(0x1F)
+#define MDCR_EL2_TDRA		(UL(1) << 11)
+#define MDCR_EL2_TDOSA		(UL(1) << 10)
+#define MDCR_EL2_TDA		(UL(1) << 9)
+#define MDCR_EL2_TDE		(UL(1) << 8)
+#define MDCR_EL2_HPME		(UL(1) << 7)
+#define MDCR_EL2_TPM		(UL(1) << 6)
+#define MDCR_EL2_TPMCR		(UL(1) << 5)
+#define MDCR_EL2_HPMN_MASK	(UL(0x1F))
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 5e9b33cbac51..d88a5550552c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -209,7 +209,7 @@ extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
 extern void __vgic_v3_init_lrs(void);
 
-extern u32 __kvm_get_mdcr_el2(void);
+extern u64 __kvm_get_mdcr_el2(void);
 
 #define __KVM_EXTABLE(from, to)						\
 	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5645af2a1431..45fdd0b7063f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -286,7 +286,7 @@ struct kvm_vcpu_arch {
 
 	/* HYP configuration */
 	u64 hcr_el2;
-	u32 mdcr_el2;
+	u64 mdcr_el2;
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index d5e79d7ee6e9..f7385bfbc9e4 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -21,7 +21,7 @@
 				DBG_MDSCR_KDE | \
 				DBG_MDSCR_MDE)
 
-static DEFINE_PER_CPU(u32, mdcr_el2);
+static DEFINE_PER_CPU(u64, mdcr_el2);
 
 /**
  * save/restore_guest_debug_regs
@@ -154,7 +154,8 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
 
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
-	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
+	unsigned long mdscr;
+	u64 orig_mdcr_el2 = vcpu->arch.mdcr_el2;
 
 	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 7d3f25868cae..df361d839902 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -109,7 +109,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	__debug_switch_to_host_common(vcpu);
 }
 
-u32 __kvm_get_mdcr_el2(void)
+u64 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index f1e2e5a00933..289689b2682d 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -20,7 +20,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	__debug_switch_to_host_common(vcpu);
 }
 
-u32 __kvm_get_mdcr_el2(void)
+u64 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
