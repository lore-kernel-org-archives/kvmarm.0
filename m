Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13848C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFC264B262;
	Tue, 19 Apr 2022 02:57:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nYRMVfyLLhqw; Tue, 19 Apr 2022 02:57:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EF314B20C;
	Tue, 19 Apr 2022 02:57:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3F84B1BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ovbJfA-B3hH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:48 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84FD94B202
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:47 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 u5-20020a17090282c500b00158e301f407so5000245plz.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7Pq8Qbz+GZ4aCCwOdPqx7ETMJ7/k84zERQoGVmKMUzo=;
 b=QNfVA35wFG6vpNs0B+FJaG2Jr6kdDJEcSIeBdn6dvuqTMajbbwxpwfkMCdT+sKXeUp
 oU3lbXu3dbwakRDJWAlNENKOGeRMwfbY+NbveA1eik6b+jyDSYM5ufu3vN1j6UmkCAUL
 yBXxITvbqA6RyJ0QdhO+9+JN9TIvKNApWgb6RroL/23xKGZPE8NtuXO1GviHy6km+f4C
 R/Rt2o16kJwISopgbNVjgGk2phPo+JBiR1S8Khug1JxR2xZVRFG2l13UoK1ZFep5CZJO
 QthN1tJsAmuY5+6ywiIefC81TvGQhFA5pQ3XAl435GpscoPaBz5CeYlP9CEbZoe/aFuv
 9/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7Pq8Qbz+GZ4aCCwOdPqx7ETMJ7/k84zERQoGVmKMUzo=;
 b=QUskRv2+2gbtJT+Nuwws5GgUSs7wPnVdlpUito49PoMhklgNSwvpbOrKdFq2igDPN2
 K8wk3kzzy1KNjo+vDvpeo4yQx7u9R6mTBx6U7KCh7KFOCYlJF2xYj0U7Lj67VC5QEubh
 wJURkzx/SQJMUDNhlWXqOAZF/bZIngq97F3Dq0EBOkOILpzI+TBq2RiTa2LnJPdHe5Ap
 RuikaumTqxBsQrfFtTsTRmXu50Lr0Su2XXUKuRMyF0S8YGKnthW/Fj0eaS4tAWRRfdiM
 R9+klNiCyi9GWbw8QfGVGKWa2WfPQGg09HA0Saf9+WSpnoEuFRYbX+5pgtnZXop+BUOJ
 Me5w==
X-Gm-Message-State: AOAM533xu7LbHOosW3KY6SdwePOqvnSzkpUjMm3mbUsbJiJ6y4Wrzm4L
 DfHW+sorIWxa1eY+UyJMpFWJm0MSfzk=
X-Google-Smtp-Source: ABdhPJz3oa3JnqAQ9/dpcAbeHIo2jnXfGftCZIoVA3FwRIwngBUtuauyy2Rle18y+lJm7ZVHOsW6cwBm1qM=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP id
 k5-20020a17090a910500b001d29e987e1emr277645pjo.0.1650351466369; Mon, 18 Apr
 2022 23:57:46 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:31 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-26-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 25/38] KVM: arm64: Use vcpu->arch.mdcr_el2 to track value
 of mdcr_el2
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Track the baseline guest value for mdcr_el2 in struct kvm_vcpu_arch.
Use this value when setting mdcr_el2 for the guest.

Currently this value is unchanged, but the following patches will set
trapping bits based on features supported for the guest.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/debug.c           | 13 ++++---------
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3f74fb16104e..90be933b5f08 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -333,6 +333,22 @@
 				 BIT(18) |		\
 				 GENMASK(16, 15))
 
+/*
+ * The default value for the guest below also clears MDCR_EL2_E2PB_MASK
+ * and MDCR_EL2_E2TB_MASK to disable guest access to the profiling and
+ * trace buffers.
+ */
+#define MDCR_GUEST_FLAGS_DEFAULT				\
+	(MDCR_EL2_TPM  | MDCR_EL2_TPMS | MDCR_EL2_TTRF |	\
+	 MDCR_EL2_TPMCR | MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
+
+/* Bits that are copied from vcpu->arch.mdcr_el2 to set mdcr_el2 for guest. */
+#define MDCR_GUEST_FLAGS_TRACKED_MASK				\
+	(MDCR_EL2_TPM  | MDCR_EL2_TPMS | MDCR_EL2_TTRF |	\
+	 MDCR_EL2_TPMCR | MDCR_EL2_TDRA | MDCR_EL2_TDOSA |	\
+	 (MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT))
+
+
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
 #define FSC_ACCESS	ESR_ELx_FSC_ACCESS
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e80c059b41d5..69189907579c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1123,6 +1123,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
+	vcpu->arch.mdcr_el2 = MDCR_GUEST_FLAGS_DEFAULT;
 	if (has_vhe())
 		vcpu->arch.cptr_el2 = CPTR_EL2_VHE_GUEST_DEFAULT;
 	else
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 6eb146d908f8..8e1243972804 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -84,16 +84,11 @@ void kvm_arm_init_debug(void)
 static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
-	 * to disable guest access to the profiling and trace buffers
+	 * Keep the vcpu->arch.mdcr_el2 bits that are specified by
+	 * MDCR_GUEST_FLAGS_TRACKED_MASK.
 	 */
-	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
-				MDCR_EL2_TTRF |
-				MDCR_EL2_TPMCR |
-				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+	vcpu->arch.mdcr_el2 &= MDCR_GUEST_FLAGS_TRACKED_MASK;
+	vcpu->arch.mdcr_el2 |= __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
 
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
