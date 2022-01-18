Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FFAC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 04:19:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB24C407EB;
	Mon, 17 Jan 2022 23:19:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id konkfCC7BSGZ; Mon, 17 Jan 2022 23:19:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6409940BEE;
	Mon, 17 Jan 2022 23:19:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 681BB408F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 23:19:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UeJFrRh00iD9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 23:19:28 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C9D2408C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 23:19:28 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 135-20020a62198d000000b004bf3fe65e1fso7380060pfz.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=7d5dkNRV7Z5Lh/DgQH2Z8gK+62sCSwMNrg4mm/R+sRI=;
 b=W1/HEpLCqYopamCv1C+D78KwLF5KNh2crJJGrRkGxCrTcGz0NTvf8n8PfP6KmWbeIw
 xevSPj9TqjVmFLCPNU7Xmf0w5Qdi7TayKTGg7WuWBOdXfB1vf3YxnjWwUOJ1Zbw76Cgo
 EvS4ZQc6D/Kqu+u+zXLn3DFwkRc4zbRbqNDELZC/JHjKxAuMPM+gNgYo7Qt0IDZ0lBo6
 D4jbkSv56EbEa7JIIOGYrvWpbA80T4IL4GBQ6Q1C67q9RjxnbjvTPKMpUvlekDIC6rf1
 JzCHo/VXW+7q4L0GbkwMQaafvfDAWLtUwPa6mXjGHxj2zU4eYhosEwhCxbxnejWUgRgj
 LUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=7d5dkNRV7Z5Lh/DgQH2Z8gK+62sCSwMNrg4mm/R+sRI=;
 b=f+QXQxV0b4ADbv7oONyAeG2sHKyneOxbmybzTEh2C0tbyT7yww4ut8lfMJdJgwCTji
 ogAxvy1VcSAYdqJpQUjhX+9XzqSAmfpbG/pH/E4qeTxDq+X+LrTMidA8cRbdzQ9fBwlS
 PjsBYKtDqK7IYAZBHYBHtExby7YC7BDNO1Mw1JZvfo6DpgB7bOVLR6gHWclFV3xe3Yxs
 127/o2Zt+dq3DotAyM4iQWs5dZT5qrvNhBM8jls31r8s41ruBb5Zo1T1kJaO/P/i8W8P
 2ZcEbfEk5h53E1q0Xs8lIQ1ussk5tjgt16Wqg1tXxyc7hpbKoW5+j1GMCZ36t+k5NKIT
 SOVA==
X-Gm-Message-State: AOAM530kU299h72zVMUHjtQYLwGYdjEeTTXraC0NRnbTn6PBWj0VuvlR
 RCDYGpUNm9onpABU9i/0snA+d9Elqvg=
X-Google-Smtp-Source: ABdhPJw+dN/IuGWKz42PJMb+uayJ5wbs1m9yUVXC8noYxTBA1i0OR4szRr1ztrcGAl8wT7fu6cJMdnFiLFE=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:21c2:b0:4bc:fb2d:4b6f with SMTP id
 t2-20020a056a0021c200b004bcfb2d4b6fmr23853502pfj.62.1642479566921; Mon, 17
 Jan 2022 20:19:26 -0800 (PST)
Date: Mon, 17 Jan 2022 20:19:22 -0800
Message-Id: <20220118041923.3384602-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 1/2] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
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

KVM allows userspace to configure either all 32bit or 64bit vCPUs
for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
if the vcpu's register width is consistent with all other vCPUs'.
Since the checking is done even against vCPUs that are not initialized
(KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
are erroneously treated as 64bit vCPU, which causes the function to
incorrectly detect a mixed-width VM.

Introduce a new flag (el1_reg_width) in kvm_arch to indicates that
the guest needs to be configured with all 32bit or 64bit vCPUs,
and initialize it at the first KVM_ARM_VCPU_INIT for the guest.
Check vcpu's register width against the flag at the vcpu's
KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).

Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
 arch/arm64/kvm/arm.c              | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c            |  8 --------
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..c02b7caf2c82 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -102,6 +102,12 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+enum kvm_el1_reg_width {
+	EL1_WIDTH_UNINITIALIZED = 0,
+	EL1_32BIT,
+	EL1_64BIT,
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -137,6 +143,13 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/*
+	 * EL1 register width for the guest.
+	 * This is set at the first KVM_ARM_VCPU_INIT for the guest based
+	 * on whether the vcpu has KVM_ARM_VCPU_EL1_32BIT or not.
+	 */
+	enum kvm_el1_reg_width el1_reg_width;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e4727dc771bf..54ae8bf9d187 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1058,6 +1058,32 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 	return -EINVAL;
 }
 
+/*
+ * A guest can have either all 32bit or 64bit vcpus only.
+ * Either one the guest has is indicated in kvm->arch.el1_reg_width.
+ * Check if the vcpu's register width is consistent with
+ * kvm->arch.el1_reg_width.  If kvm->arch.el1_reg_width is not set yet,
+ * set it based on the vcpu's KVM_ARM_VCPU_EL1_32BIT configuration.
+ */
+static int kvm_register_width_check_or_init(struct kvm_vcpu *vcpu)
+{
+	bool is32bit;
+	bool allowed = true;
+	struct kvm *kvm = vcpu->kvm;
+
+	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm->arch.el1_reg_width == EL1_WIDTH_UNINITIALIZED)
+		kvm->arch.el1_reg_width = is32bit ? EL1_32BIT : EL1_64BIT;
+	else
+		allowed = (is32bit == (kvm->arch.el1_reg_width == EL1_32BIT));
+
+	mutex_unlock(&kvm->lock);
+	return allowed ? 0 : -EINVAL;
+}
+
 static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 			       const struct kvm_vcpu_init *init)
 {
@@ -1097,6 +1123,10 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
 	/* Now we know what it is, we can reset it. */
 	ret = kvm_reset_vcpu(vcpu);
+
+	if (!ret)
+		ret = kvm_register_width_check_or_init(vcpu);
+
 	if (ret) {
 		vcpu->arch.target = -1;
 		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 426bd7fbc3fd..dbf2939a6a96 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -168,9 +168,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 
 static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *tmp;
 	bool is32bit;
-	int i;
 
 	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
@@ -180,12 +178,6 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 	if (kvm_has_mte(vcpu->kvm) && is32bit)
 		return false;
 
-	/* Check that the vcpus are either all 32bit or all 64bit */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
-			return false;
-	}
-
 	return true;
 }
 

base-commit: 37144b2c855f9311c72f292125061d4a52d02856
-- 
2.34.1.703.g22d0c6ccf7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
