Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950A4C433E7
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 10:01:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50F352068F
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 10:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50F352068F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 080A34B318;
	Mon, 13 Jul 2020 06:01:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aWW0zqJf3BYa; Mon, 13 Jul 2020 06:01:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF9134B32F;
	Mon, 13 Jul 2020 06:01:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C9F94B324
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 06:01:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2QHgFeQZq4JO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 06:01:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C87BA4B31C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 06:01:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D6F631B;
 Mon, 13 Jul 2020 03:01:23 -0700 (PDT)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C28DA3F7D8;
 Mon, 13 Jul 2020 03:01:21 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 2/2] arm64: kvm: Introduce MTE VCPU feature
Date: Mon, 13 Jul 2020 11:01:02 +0100
Message-Id: <20200713100102.53664-3-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200713100102.53664-1-steven.price@arm.com>
References: <20200713100102.53664-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Add a new VCPU features 'KVM_ARM_VCPU_MTE' which enables memory tagging
on a VCPU. When enabled on any VCPU in the virtual machine this causes
all pages that are faulted into the VM to have the PG_mte_tagged flag
set (and the tag storage cleared if this is the first use).

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  3 +++
 arch/arm64/include/asm/kvm_host.h    |  2 +-
 arch/arm64/include/uapi/asm/kvm.h    |  1 +
 arch/arm64/kvm/mmu.c                 | 15 +++++++++++++++
 arch/arm64/kvm/reset.c               |  8 ++++++++
 arch/arm64/kvm/sys_regs.c            |  3 ++-
 6 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4d0f8ea600ba..1e4280f9a5ce 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -79,6 +79,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID2;
+
+	if (test_bit(KVM_ARM_VCPU_MTE, vcpu->arch.features))
+		vcpu->arch.hcr_el2 |= HCR_ATA;
 }
 
 static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1fc306705193..586b250f683b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -37,7 +37,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 8
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ba85bb23f060..2677e1ab8c16 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_MTE		7 /* VCPU supports Memory Tagging */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c0035cab6b6..8d405701f534 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1940,6 +1940,21 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (vma_pagesize == PAGE_SIZE && !force_pte)
 		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
 							   &pfn, &fault_ipa);
+	if (system_supports_mte() && kvm->arch.vcpu_has_mte && pfn_valid(pfn)) {
+		/*
+		 * VM will be able to see the page's tags, so we must ensure
+		 * they have been initialised.
+		 */
+		struct page *page = pfn_to_page(pfn);
+		long i, nr_pages = compound_nr(page);
+
+		/* if PG_mte_tagged is set, tags have already been initialised */
+		for (i = 0; i < nr_pages; i++, page++) {
+			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+				mte_clear_page_tags(page_address(page));
+		}
+	}
+
 	if (writable)
 		kvm_set_pfn_dirty(pfn);
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 6ed36be51b4b..39fdd95441df 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -275,6 +275,14 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (test_bit(KVM_ARM_VCPU_MTE, vcpu->arch.features)) {
+		if (!system_supports_mte()) {
+			ret = -EINVAL;
+			goto out;
+		}
+		vcpu->kvm->arch.vcpu_has_mte = true;
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5ca974c93bd4..0c3c577f98fe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1105,7 +1105,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
 		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
 	} else if (id == SYS_ID_AA64PFR1_EL1) {
-		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
+		if (!test_bit(KVM_ARM_VCPU_MTE, vcpu->arch.features))
+			val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
 	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
 		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
 			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
