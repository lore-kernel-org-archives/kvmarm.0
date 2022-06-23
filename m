Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BF6C43334
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 07:30:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7911B4B2E0;
	Thu, 23 Jun 2022 03:30:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AH-8m+kdm-uH; Thu, 23 Jun 2022 03:30:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9144A4B3E3;
	Thu, 23 Jun 2022 03:30:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5757A4B278
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 22:19:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CpHPA5Hrg1xF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 22:19:42 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D53AF4B3B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 22:19:42 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 b11-20020a5b008b000000b00624ea481d55so16160704ybp.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 19:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9RRfGBQ63xQ/DdrDFnljmoGGtNK2WWXmVlcIowX+5Eg=;
 b=PV3Ep9cdQbVSaBsuR1M4h4hPUpnJOpS9PDHgZkbjrc1w8cQjLCjkQPCHzOeNgT9q7/
 O+l3GoolI9kSpOJ2B4ayD6iZcOWewtp9fPkzuvtw9ICyv3pE01NHqOO/lRAeT0LGplxr
 AFE0lS0mvWvMkw1JaGQLmYgu82p7rKcbrlZbcWLFzj1EL1yRcd6oKUrS+S3zN+O5xJAb
 8sGEc2DaI/5Vs/LgaKH784z6icQ86E7tzibHduCF77Cv8AA4gYQQSKTp9EyCP2TTQKaJ
 eiDmWy4/DwF3Lol9Q5avrghJoAy/6G640V2zHlxniozM6/RiXpR+sNyoarfHV1H0gdml
 bdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9RRfGBQ63xQ/DdrDFnljmoGGtNK2WWXmVlcIowX+5Eg=;
 b=E81zpMxl2LK5vT46t0YZmuALdv5GRGpKLiSPyUcpHmnuKtAKwDiJT/H1m00HA23iYn
 ypkrZlLHIcSguECRnMIIEH8u8u6Pj/GrvVm9c7+YgdaivJ8l4HVeYOJv5pyeAPJfszVy
 2WePaQ5O/+8g7k7+9lP3AAjAc8ZHPOP3uQ4TV1tv6TyAWslvbDfM0TR0zSCksGqso2Dy
 3fWHic+QPvlDKJNJlHBDwLiWoMtAHjUPMLZqKMUQXM/5zbY27mcCwnsNqy0/ZKvpqRW2
 gqiqQxQrcIwRIHOSWBeZ8exAdSp58sAmCFJO4ZwijIMPZZbS+3mDLIVM3NvmNxRky0bK
 JAwg==
X-Gm-Message-State: AJIora9TcNMm+WR0CnX5Kc5Ui6yLsIeYg/NRZ6U+g+jpOtMbvz3njYCA
 ZVKSWGRev1fttK0LNRrCHlYU/kVpRry6sCdMseoljlK8geqMje4eAnzAjeFl9INReufEqwwrDlM
 /6NsvT0nTrE/eWSY05TuAnGEIOvmU22wPCWcJp8Hb+0ZtSQf/eDpPGUhf74rihQ==
X-Google-Smtp-Source: AGRyM1tktBOoS27VjciOGpSivbIhryk+M35R2Pac1IEIC38+L0K8WXfaVlMRjhkCUF6vj4Cunslz+Wg=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:ba6f:123c:d287:a160])
 (user=pcc job=sendgmr) by 2002:a25:6609:0:b0:668:e2b4:f7fd with SMTP id
 a9-20020a256609000000b00668e2b4f7fdmr7353464ybc.226.1655950782391; Wed, 22
 Jun 2022 19:19:42 -0700 (PDT)
Date: Wed, 22 Jun 2022 19:19:26 -0700
In-Reply-To: <20220623021926.3443240-1-pcc@google.com>
Message-Id: <20220623021926.3443240-4-pcc@google.com>
Mime-Version: 1.0
References: <20220623021926.3443240-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 3/3] KVM: arm64: allow MTE in protected VMs if the tag storage
 is known
From: Peter Collingbourne <pcc@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 23 Jun 2022 03:30:27 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Will Deacon <will@kernel.org>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org
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

Because the host may corrupt a protected guest's tag storage unless
protected by stage 2 page tables, we can't expose MTE to protected guests
if the location of the tag storage is not known.

Therefore, only allow protected VM guests to use MTE if the location of
the tag storage is described in the device tree, and only after disowning
any physical memory accessible tag storage regions.

To avoid exposing MTE tags from the host to protected VMs, sanitize
tags before donating pages.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  6 +++++
 arch/arm64/include/asm/kvm_pkvm.h |  4 +++-
 arch/arm64/kernel/image-vars.h    |  3 +++
 arch/arm64/kvm/arm.c              | 37 ++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  8 ++++---
 arch/arm64/kvm/mmu.c              |  4 +++-
 6 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0fd184b816b3..973ab0378d01 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -930,6 +930,12 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
+DECLARE_STATIC_KEY_FALSE(pkvm_mte_supported);
+
+#define kvm_supports_mte(kvm)                                                  \
+	(system_supports_mte() &&                                              \
+	 (!kvm_vm_is_protected(kvm) ||                                         \
+	  static_branch_unlikely(&pkvm_mte_supported)))
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
 	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index cd56438a34be..ef5d4870c043 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -73,10 +73,12 @@ void kvm_shadow_destroy(struct kvm *kvm);
  * Allow for protected VMs:
  * - Branch Target Identification
  * - Speculative Store Bypassing
+ * - Memory Tagging Extension
  */
 #define PVM_ID_AA64PFR1_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR1_BT) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) \
+	ARM64_FEATURE_MASK(ID_AA64PFR1_SSBS) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR1_MTE) \
 	)
 
 /*
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 2d4d6836ff47..26a9b31478aa 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -84,6 +84,9 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
 KVM_NVHE_ALIAS(arm64_const_caps_ready);
 KVM_NVHE_ALIAS(cpu_hwcap_keys);
 
+/* Kernel symbol needed for kvm_supports_mte() check. */
+KVM_NVHE_ALIAS(pkvm_mte_supported);
+
 /* Static keys which are set if a vGIC trap should be handled in hyp. */
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
 KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 38f0900b7ddb..5a780a0f59e3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -60,6 +60,7 @@ static bool vgic_present;
 
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
+DEFINE_STATIC_KEY_FALSE(pkvm_mte_supported);
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
@@ -96,9 +97,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() ||
-		    kvm_vm_is_protected(kvm) ||
-		    kvm->created_vcpus) {
+		if (!kvm_supports_mte(kvm) || kvm->created_vcpus) {
 			r = -EINVAL;
 		} else {
 			r = 0;
@@ -334,6 +333,9 @@ static int pkvm_check_extension(struct kvm *kvm, long ext, int kvm_cap)
 	case KVM_CAP_ARM_VM_IPA_SIZE:
 		r = kvm_cap;
 		break;
+	case KVM_CAP_ARM_MTE:
+		r = kvm_cap && static_branch_unlikely(&pkvm_mte_supported);
+		break;
 	case KVM_CAP_GUEST_DEBUG_HW_BPS:
 		r = min(kvm_cap, pkvm_get_max_brps());
 		break;
@@ -1948,9 +1950,36 @@ static void kvm_reserved_memory_init(void)
 		if (!of_get_property(node, "compatible", NULL) &&
 		    of_get_property(node, "no-map", NULL))
 			disown_reserved_memory(node);
+
+		if (of_device_is_compatible(node, "arm,mte-tag-storage"))
+			disown_reserved_memory(node);
 	}
 }
 
+static void kvm_mte_init(void)
+{
+	struct device_node *memory;
+
+	if (!system_supports_mte() || !acpi_disabled ||
+	    !is_protected_kvm_enabled())
+		return;
+
+	/*
+	 * It is only safe to turn on MTE for protected VMs if we can protect
+	 * the guests from host accesses to their tag storage. If every memory
+	 * region has an arm,mte-alloc property we know that all tag storage
+	 * regions exposed to physical memory, if any, are described by a
+	 * reserved-memory compatible with arm,mte-tag-storage. We can use these
+	 * descriptions to unmap these regions from the host's stage 2 page
+	 * tables (see kvm_reserved_memory_init).
+	 */
+	for_each_node_by_type(memory, "memory")
+		if (!of_get_property(memory, "arm,mte-alloc", NULL))
+			return;
+
+	static_branch_enable(&pkvm_mte_supported);
+}
+
 static int init_subsystems(void)
 {
 	int err = 0;
@@ -1993,6 +2022,8 @@ static int init_subsystems(void)
 
 	kvm_reserved_memory_init();
 
+	kvm_mte_init();
+
 out:
 	if (err || !is_protected_kvm_enabled())
 		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index e81a6dd676d0..dcc3084161b3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -88,7 +88,7 @@ static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
 	/* Memory Tagging: Trap and Treat as Untagged if not supported. */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), feature_ids)) {
 		hcr_set |= HCR_TID5;
-		hcr_clear |= HCR_DCT | HCR_ATA;
+		hcr_clear |= HCR_ATA;
 	}
 
 	vcpu->arch.hcr_el2 |= hcr_set;
@@ -179,8 +179,8 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	 * - Feature id registers: to control features exposed to guests
 	 * - Implementation-defined features
 	 */
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS |
-			     HCR_TID3 | HCR_TACR | HCR_TIDCP | HCR_TID1;
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS | HCR_TID3 | HCR_TACR | HCR_TIDCP |
+			     HCR_TID1 | HCR_ATA;
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
 		/* route synchronous external abort exceptions to EL2 */
@@ -459,6 +459,8 @@ static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 	vm->host_kvm = kvm;
 	vm->kvm.created_vcpus = nr_vcpus;
 	vm->kvm.arch.vtcr = host_kvm.arch.vtcr;
+	if (kvm_supports_mte(kvm) && test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags))
+		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &vm->kvm.arch.flags);
 	vm->kvm.arch.pkvm.enabled = READ_ONCE(kvm->arch.pkvm.enabled);
 	vm->kvm.arch.mmu.last_vcpu_ran = last_ran;
 	vm->last_ran_size = last_ran_size;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bca90b7354b9..5e079daf2d8e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1228,8 +1228,10 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto dec_account;
 	}
 
-	write_lock(&kvm->mmu_lock);
 	pfn = page_to_pfn(page);
+	sanitise_mte_tags(kvm, pfn, PAGE_SIZE);
+
+	write_lock(&kvm->mmu_lock);
 	ret = pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT);
 	if (ret) {
 		if (ret == -EAGAIN)
-- 
2.37.0.rc0.104.g0611611a94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
