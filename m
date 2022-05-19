Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF67C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:48:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 770384B4D0;
	Thu, 19 May 2022 09:48:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 44fMe26sGPyP; Thu, 19 May 2022 09:48:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DCCD4B4CC;
	Thu, 19 May 2022 09:48:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB354B4DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:48:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EqcWYAW-fw3k for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:48:17 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57CF04B4C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:48:16 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 8BB33B824AB;
 Thu, 19 May 2022 13:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3E8C34116;
 Thu, 19 May 2022 13:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968094;
 bh=yfv/vQKADWjGkdBJvYkXwUJ0o4vv6c5SpCbBBPRGgJ8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=enJFxxMLTdCW1oDtkbsEEik4y7sHN9Bev+iph2vEztvwtIMBc8d1+tbGlXB8quSpT
 UL2qz4FhDigx3GQig5rWvxsVwLdbMi6wKOzZ/NCW/0jkQwtTpTaxawnSkOa20oOorA
 wYKhGCD5N+iJq73s8m+s3PqHFb3HZ8oevAhX7T+QRhsRS4FxAxPWG6PebGOhrKXqc2
 7zRBSaoCSJbRRQwz18nrpYH/qLrdBYYo2qq9A00PUrT5nvoN+0VOLrEvTScBhAMdZS
 nJ1nQKRgPxOC3qQ6EI0XALxal/qEMkfEUUT4LjIgKl2ZAWmodutx8VrYZT/wZdHbcv
 maBd7eqbeoo/g==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 88/89] KVM: arm64: Introduce KVM_VM_TYPE_ARM_PROTECTED machine
 type for PVMs
Date: Thu, 19 May 2022 14:42:03 +0100
Message-Id: <20220519134204.5379-89-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

Introduce a new virtual machine type, KVM_VM_TYPE_ARM_PROTECTED, which
specifies that the guest memory pages are to be unmapped from the host
stage-2 by the hypervisor.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h |  2 +-
 arch/arm64/kvm/arm.c              |  5 ++++-
 arch/arm64/kvm/mmu.c              |  3 ---
 arch/arm64/kvm/pkvm.c             | 10 +++++++++-
 include/uapi/linux/kvm.h          |  6 ++++++
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 062ae2ffbdfb..952e3c3fa32d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -16,7 +16,7 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
-int kvm_init_pvm(struct kvm *kvm);
+int kvm_init_pvm(struct kvm *kvm, unsigned long type);
 int kvm_shadow_create(struct kvm *kvm);
 void kvm_shadow_destroy(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5a935a9a73..26fd69727c81 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -141,11 +141,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	if (type & ~KVM_VM_TYPE_MASK)
+		return -EINVAL;
+
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
 
-	ret = kvm_init_pvm(kvm);
+	ret = kvm_init_pvm(kvm, type);
 	if (ret)
 		goto err_unshare_kvm;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 137d4382ed1c..392ff7b2362d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -652,9 +652,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 67aad91dc3e5..ebf93ff6a77e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -218,8 +218,16 @@ void kvm_shadow_destroy(struct kvm *kvm)
 	}
 }
 
-int kvm_init_pvm(struct kvm *kvm)
+int kvm_init_pvm(struct kvm *kvm, unsigned long type)
 {
 	mutex_init(&kvm->arch.pkvm.shadow_lock);
+
+	if (!(type & KVM_VM_TYPE_ARM_PROTECTED))
+		return 0;
+
+	if (!is_protected_kvm_enabled())
+		return -EINVAL;
+
+	kvm->arch.pkvm.enabled = true;
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 91a6fe4e02c0..fdb0289cfecc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -887,6 +887,12 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
+#define KVM_VM_TYPE_ARM_PROTECTED	(1UL << 8)
+
+#define KVM_VM_TYPE_MASK	(KVM_VM_TYPE_ARM_IPA_SIZE_MASK | \
+				 KVM_VM_TYPE_ARM_PROTECTED)
+
 /*
  * ioctls for /dev/kvm fds:
  */
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
