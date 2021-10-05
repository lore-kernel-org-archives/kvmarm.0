Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AF7C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:37:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFC456137F
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:37:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AFC456137F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62FB74B2AF;
	Tue,  5 Oct 2021 07:37:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bFLsz8H9J4UJ; Tue,  5 Oct 2021 07:37:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 809474B2F6;
	Tue,  5 Oct 2021 07:37:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0CC14B2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:37:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N+hmhTxw5sVG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 07:37:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B2544B2F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:37:46 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43EC4610A2;
 Tue,  5 Oct 2021 11:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633433865;
 bh=vZRSH0NmMYFtmmfRnRM8uIc0XaXXLPFQu8SIAIVXB84=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=MtlNbx1hrLBB4VAPkGP/dzRH81Mxihkni1QtwXOYOd+6Ol0jAd8+w5IMwxqgZ/2Ou
 1M4WFuYVjYkSxuWHBE5VBe6eUhl5OgaXKsvtlrNoYpKdBYebottdQ3ZnsrlKTppYoF
 oyDT7BiIXGGzIhZydkgpHNj1lSFD6Qw7Lwpi1UZaBOGQ4JEVEnfHJYw3zxSaS85ef+
 065Wt8S93UPutzj8H/FKVTY2CDKyP71ApgIe169+8iDSd7Og+3m5oZrR+n0s6IJzDi
 hpGYR0y0ySfkTebC7DennjS4clly8BAH3fGu6k+YqIRNHG1nIgxxIT5NLQWecMgzUG
 7MtcdG6fd4xcw==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 5/5] KVM: arm64: Disable privileged hypercalls after pKVM
 finalisation
Date: Tue,  5 Oct 2021 12:37:21 +0100
Message-Id: <20211005113721.29441-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211005113721.29441-1-will@kernel.org>
References: <20211005113721.29441-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

After pKVM has been 'finalised' using the __pkvm_prot_finalize hypercall,
the calling CPU will have a Stage-2 translation enabled to prevent access
to memory pages owned by EL2.

Although this forms a significant part of the process to deprivilege the
host kernel, we also need to ensure that the hypercall interface is
reduced so that the EL2 code cannot, for example, be re-initialised using
a new set of vectors.

Re-order the hypercalls so that only a suffix remains available after
finalisation of pKVM.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   | 43 ++++++++++++++++--------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 37 +++++++++++++++++--------
 2 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e86045ac43ba..68630fd382c5 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -43,27 +43,30 @@
 
 #define KVM_HOST_SMCCC_FUNC(name) KVM_HOST_SMCCC_ID(__KVM_HOST_SMCCC_FUNC_##name)
 
+/* Hypercalls available only prior to pKVM finalisation */
 #define __KVM_HOST_SMCCC_FUNC___kvm_hyp_init			0
-#define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			1
-#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		2
-#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		3
-#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		4
-#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		5
-#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		6
-#define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config		8
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		9
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		10
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		11
-#define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
-#define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
-#define __KVM_HOST_SMCCC_FUNC___pkvm_init			15
-#define __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp		16
-#define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
-#define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
-#define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
-#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			20
+#define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		1
+#define __KVM_HOST_SMCCC_FUNC___pkvm_init			2
+#define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	3
+#define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		4
+#define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			5
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		6
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config		7
+#define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		8
+
+/* Hypercalls available after pKVM finalisation */
+#define __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp		9
+#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			10
+#define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			11
+#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		12
+#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		13
+#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		14
+#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		15
+#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		16
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		17
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		18
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		19
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		20
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..8566805ef62c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -165,36 +165,51 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
 
 static const hcall_t host_hcall[] = {
-	HANDLE_FUNC(__kvm_vcpu_run),
+	/* ___kvm_hyp_init */
+	HANDLE_FUNC(__kvm_get_mdcr_el2),
+	HANDLE_FUNC(__pkvm_init),
+	HANDLE_FUNC(__pkvm_create_private_mapping),
+	HANDLE_FUNC(__pkvm_cpu_set_vector),
+	HANDLE_FUNC(__kvm_enable_ssbs),
+	HANDLE_FUNC(__vgic_v3_init_lrs),
+	HANDLE_FUNC(__vgic_v3_get_gic_config),
+	HANDLE_FUNC(__pkvm_prot_finalize),
+
+	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__kvm_adjust_pc),
+	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
-	HANDLE_FUNC(__kvm_enable_ssbs),
-	HANDLE_FUNC(__vgic_v3_get_gic_config),
 	HANDLE_FUNC(__vgic_v3_read_vmcr),
 	HANDLE_FUNC(__vgic_v3_write_vmcr),
-	HANDLE_FUNC(__vgic_v3_init_lrs),
-	HANDLE_FUNC(__kvm_get_mdcr_el2),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_aprs),
-	HANDLE_FUNC(__pkvm_init),
-	HANDLE_FUNC(__pkvm_cpu_set_vector),
-	HANDLE_FUNC(__pkvm_host_share_hyp),
-	HANDLE_FUNC(__pkvm_create_private_mapping),
-	HANDLE_FUNC(__pkvm_prot_finalize),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, id, host_ctxt, 0);
+	unsigned long hcall_min = 0;
 	hcall_t hfn;
 
+	/*
+	 * If pKVM has been initialised then reject any calls to the
+	 * early "privileged" hypercalls. Note that we cannot reject
+	 * calls to __pkvm_prot_finalize for two reasons: (1) The static
+	 * key used to determine initialisation must be toggled prior to
+	 * finalisation and (2) finalisation is performed on a per-CPU
+	 * basis. This is all fine, however, since __pkvm_prot_finalize
+	 * returns -EPERM after the first call for a given CPU.
+	 */
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		hcall_min = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize;
+
 	id -= KVM_HOST_SMCCC_ID(0);
 
-	if (unlikely(id >= ARRAY_SIZE(host_hcall)))
+	if (unlikely(id < hcall_min || id >= ARRAY_SIZE(host_hcall)))
 		goto inval;
 
 	hfn = host_hcall[id];
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
