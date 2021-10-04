Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653A5C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:49:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C153611CA
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:49:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0C153611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B21DF4B2B5;
	Mon,  4 Oct 2021 13:49:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M8ELk2XuEaKX; Mon,  4 Oct 2021 13:49:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E91B44B2C5;
	Mon,  4 Oct 2021 13:49:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1470C4B2AE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:49:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pVJmpd3XmZlG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 13:49:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8FB34B29C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:49:02 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1CA6A61206;
 Mon,  4 Oct 2021 17:49:02 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mXS5E-00EhBv-FI; Mon, 04 Oct 2021 18:49:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/16] KVM: arm64: Add MMIO checking infrastructure
Date: Mon,  4 Oct 2021 18:48:37 +0100
Message-Id: <20211004174849.2831548-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com,
 tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org
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

Introduce the infrastructure required to identify an IPA region
that is expected to be used as an MMIO window.

This include mapping, unmapping and checking the regions. Nothing
calls into it yet, so no expected functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/kvm_mmu.h  |   5 ++
 arch/arm64/kvm/mmu.c              | 109 ++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f63ca8fb4e58..ba9781eb84d6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -125,6 +125,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
 	/* Memory Tagging Extension enabled for the guest */
 #define KVM_ARCH_FLAG_MTE_ENABLED			1
+	/* Gues has bought into the MMIO guard extension */
+#define KVM_ARCH_FLAG_MMIO_GUARD			2
 	unsigned long flags;
 
 	/*
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 02d378887743..454a6265d45d 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -170,6 +170,11 @@ phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(u32 *hyp_va_bits);
 
+/* MMIO guard */
+bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
+bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
+bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
+
 static inline void *__kvm_vector_slot2addr(void *base,
 					   enum arm64_hyp_spectre_vector slot)
 {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a94a7ca48f2..2470a55ca675 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1172,6 +1172,115 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 		kvm_set_pfn_accessed(pte_pfn(pte));
 }
 
+/* Replace this with something more structured once day */
+#define MMIO_NOTE	(('M' << 24 | 'M' << 16 | 'I' << 8 | 'O') << 1)
+
+bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
+{
+	struct kvm_mmu_memory_cache *memcache;
+	struct kvm_memory_slot *memslot;
+	struct kvm *kvm = vcpu->kvm;
+	int ret, idx;
+
+	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &kvm->arch.flags))
+		return false;
+
+	/* Must be page-aligned */
+	if (ipa & ~PAGE_MASK)
+		return false;
+
+	/*
+	 * The page cannot be in a memslot. At some point, this will
+	 * have to deal with device mappings though.
+	 */
+	idx = srcu_read_lock(&kvm->srcu);
+	mutex_lock(&kvm->slots_arch_lock);
+	memslot = gfn_to_memslot(kvm, ipa >> PAGE_SHIFT);
+	if (memslot) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Guest has direct access to the GICv2 virtual CPU interface */
+	if (irqchip_in_kernel(kvm) &&
+	    kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
+	    ipa == kvm->arch.vgic.vgic_cpu_base) {
+		ret = 0;
+		goto out;
+	}
+
+	memcache = &vcpu->arch.mmu_page_cache;
+	if (kvm_mmu_topup_memory_cache(memcache,
+				       kvm_mmu_cache_min_pages(kvm))) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock(&kvm->mmu_lock);
+	ret = kvm_pgtable_stage2_annotate(vcpu->arch.hw_mmu->pgt,
+					  ipa, PAGE_SIZE, memcache,
+					  MMIO_NOTE);
+	spin_unlock(&kvm->mmu_lock);
+
+out:
+	mutex_unlock(&kvm->slots_arch_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+	return ret == 0;
+}
+
+static bool __check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
+{
+	kvm_pte_t pte = 0;
+	u32 level = 0;
+	int ret;
+
+	lockdep_assert_held(&vcpu->kvm->mmu_lock);
+
+	ret = kvm_pgtable_get_leaf(vcpu->arch.hw_mmu->pgt, ipa, &pte, &level);
+	VM_BUG_ON(ret);
+	VM_BUG_ON(level >= KVM_PGTABLE_MAX_LEVELS);
+
+	/* Must be a PAGE_SIZE mapping with our annotation */
+	return (BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level)) == PAGE_SIZE &&
+		pte == MMIO_NOTE);
+}
+
+bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
+{
+	bool ret;
+
+	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
+		return false;
+
+	/* Keep the PT locked across the two walks */
+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	ret = __check_ioguard_page(vcpu, ipa);
+	if (ret)		/* Drop the annotation */
+		kvm_pgtable_stage2_unmap(vcpu->arch.hw_mmu->pgt,
+					 ALIGN_DOWN(ipa, PAGE_SIZE), PAGE_SIZE);
+
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	return ret;
+}
+
+bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
+{
+	bool ret;
+
+	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
+		return true;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	ret = __check_ioguard_page(vcpu, ipa & PAGE_MASK);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (!ret)
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+
+	return ret;
+}
+
 /**
  * kvm_handle_guest_abort - handles all 2nd stage aborts
  * @vcpu:	the VCPU pointer
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
