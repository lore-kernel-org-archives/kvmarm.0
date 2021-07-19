Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534E2C12002
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0236561482
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0236561482
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABBA04A1AF;
	Mon, 19 Jul 2021 12:04:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i-8GGutqMhCN; Mon, 19 Jul 2021 12:04:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E25F40FC7;
	Mon, 19 Jul 2021 12:04:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FF6B4B0BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Ql6hbqvyTfT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:04:20 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02DC24B093
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:20 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 d16-20020a1c73100000b02901f2d21e46efso170578wmb.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wr4M5V9fqDifu4W3yqELoDlyD/QsVKGAaDZe0uH90bk=;
 b=h91JnRYTdlcPoijWgxxAfjtdJIrm6H6BOcmFAhwd9pay0PJJ4cC6n1M9vbvnZ6znbT
 nS/1gN8idExqyOnrE/Bmz/LLcTPnhqFfeS+t1mMiO1wdPBzQPExNqThRPzw01XZUA+H7
 gdwMr0REM1mgF7ETdQ3FRIuAdUu2tv277ykNrgB5DnSPRjpGP76y9D0y5p/veJSbXPaC
 4CPTxA7GU2+sLTqJORcgVZ7s3n6pyJ/1grd2vbUGVhIssCG9VpF9EJsTsBHAfdzO6UJm
 4rntEOyEpDDnjgVG6RdAynoK+s7ZurB1veuHFd8Ap9cmHCr6tOSp+897JO54o+IABZLh
 QPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wr4M5V9fqDifu4W3yqELoDlyD/QsVKGAaDZe0uH90bk=;
 b=ZF1BYYWBN04noj4ofmPnKltHYv/pyNh3YM5YOl/PuFoMr5xbgZak4ETlQtXyC1SkTl
 lc3P7rUQIQXUwoZQlpprn508rQaLgl9LDHt+kFaXn1TKAa683/sm1vP0i92pyMFjCztW
 hS9+WNx6D8eCBgId3LxDLasKrYnkVuFK2Mk0CGYsXf+u4VtAikxqs27DskXoMiGlkVCQ
 G3iBeRpk3nlfKNG6tIe7wcdKzPrsc/q8fuqwKsfCVPvVaLMHI6Is7ZZciAV0i0DU3LZu
 qAiGc71cQzPZFpcYbXWPGTBi55veG2kOxxiatJVbXD6W0xSslylMPRAvu0OFl+wLUPev
 3MIA==
X-Gm-Message-State: AOAM5315N6g0RXEEHEMZcfG3PEc9dcRDNiOLAHqbNL6nyDEnSzpLOT+B
 EDvZyLmKgZcB8lIWvfP772FEnTiJQiFTKdeQpiSVa4uVnY7TD/0149JHnKUgdVmrHWwrVKgkbnu
 uGw5oJTBwKq+tn7+k8YvklO6oAH/uoCV9MIUpAX6BIPu90vekxiaLu72pNim8oa/HTNc=
X-Google-Smtp-Source: ABdhPJzzYFHkSS+rg5cJ0eIx8EjkgLZ9WyOnX41eM+jzRisgCK/ewgy3OonzA0LHza8N9WIoUOHe3/73yw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:530c:: with SMTP id
 e12mr29810469wrv.130.1626710659125; 
 Mon, 19 Jul 2021 09:04:19 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:46 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-16-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 15/15] KVM: arm64: Restrict protected VM capabilities
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

Restrict protected VM capabilities based on the
fixed-configuration for protected VMs.

No functional change intended in current KVM-supported modes
(nVHE, VHE).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_fixed_config.h | 10 ++++
 arch/arm64/kvm/arm.c                      | 63 ++++++++++++++++++++++-
 arch/arm64/kvm/pkvm.c                     | 30 +++++++++++
 3 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_fixed_config.h b/arch/arm64/include/asm/kvm_fixed_config.h
index b39a5de2c4b9..14310b035bf7 100644
--- a/arch/arm64/include/asm/kvm_fixed_config.h
+++ b/arch/arm64/include/asm/kvm_fixed_config.h
@@ -175,4 +175,14 @@
  */
 #define PVM_ID_AA64ISAR1_ALLOW (~0ULL)
 
+/*
+ * Returns the maximum number of breakpoints supported for protected VMs.
+ */
+int kvm_arm_pkvm_get_max_brps(void);
+
+/*
+ * Returns the maximum number of watchpoints supported for protected VMs.
+ */
+int kvm_arm_pkvm_get_max_wrps(void);
+
 #endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3f28549aff0d..bc41e3b71fab 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -34,6 +34,7 @@
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
@@ -188,9 +189,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	atomic_set(&kvm->online_vcpus, 0);
 }
 
-int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+static int kvm_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
+
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 		r = vgic_present;
@@ -281,6 +283,65 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+static int pkvm_check_extension(struct kvm *kvm, long ext, int kvm_cap)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_ARM_PSCI:
+	case KVM_CAP_ARM_PSCI_0_2:
+	case KVM_CAP_NR_VCPUS:
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+		r = kvm_cap;
+		break;
+	case KVM_CAP_ARM_EL1_32BIT:
+		r = kvm_cap &&
+		    (FIELD_GET(FEATURE(ID_AA64PFR0_EL1), PVM_ID_AA64PFR0_ALLOW) >=
+		     ID_AA64PFR0_ELx_32BIT_64BIT);
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_BPS:
+		r = min(kvm_cap, kvm_arm_pkvm_get_max_brps());
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_WPS:
+		r = min(kvm_cap, kvm_arm_pkvm_get_max_wrps());
+		break;
+	case KVM_CAP_ARM_PMU_V3:
+		r = kvm_cap &&
+		    FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), PVM_ID_AA64DFR0_ALLOW);
+		break;
+	case KVM_CAP_ARM_SVE:
+		r = kvm_cap &&
+		    FIELD_GET(FEATURE(ID_AA64PFR0_SVE), PVM_ID_AA64PFR0_ALLOW);
+		break;
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+		r = kvm_cap &&
+		    FIELD_GET(FEATURE(ID_AA64ISAR1_API), PVM_ID_AA64ISAR1_ALLOW) &&
+		    FIELD_GET(FEATURE(ID_AA64ISAR1_APA), PVM_ID_AA64ISAR1_ALLOW);
+		break;
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+		r = kvm_cap &&
+		    FIELD_GET(FEATURE(ID_AA64ISAR1_GPI), PVM_ID_AA64ISAR1_ALLOW) &&
+		    FIELD_GET(FEATURE(ID_AA64ISAR1_GPA), PVM_ID_AA64ISAR1_ALLOW);
+		break;
+	default:
+		r = 0;
+		break;
+	}
+
+	return r;
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r = kvm_check_extension(kvm, ext);
+
+	if (unlikely(kvm && kvm_vm_is_protected(kvm)))
+		r = pkvm_check_extension(kvm, ext, r);
+
+	return r;
+}
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b8430b3d97af..d41553594d08 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -181,3 +181,33 @@ void kvm_init_protected_traps(struct kvm_vcpu *vcpu)
 	pvm_init_traps_aa64mmfr0(vcpu);
 	pvm_init_traps_aa64mmfr1(vcpu);
 }
+
+int kvm_arm_pkvm_get_max_brps(void)
+{
+	int num = FIELD_GET(FEATURE(ID_AA64DFR0_BRPS), PVM_ID_AA64DFR0_ALLOW);
+
+	/*
+	 * If breakpoints are supported, the maximum number is 1 + the field.
+	 * Otherwise, return 0, which is not compliant with the architecture,
+	 * but is reserved and is used here to indicate no debug support.
+	 */
+	if (num)
+		return 1 + num;
+	else
+		return 0;
+}
+
+int kvm_arm_pkvm_get_max_wrps(void)
+{
+	int num = FIELD_GET(FEATURE(ID_AA64DFR0_WRPS), PVM_ID_AA64DFR0_ALLOW);
+
+	/*
+	 * If breakpoints are supported, the maximum number is 1 + the field.
+	 * Otherwise, return 0, which is not compliant with the architecture,
+	 * but is reserved and is used here to indicate no debug support.
+	 */
+	if (num)
+		return 1 + num;
+	else
+		return 0;
+}
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
