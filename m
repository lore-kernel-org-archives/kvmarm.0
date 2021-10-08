Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA15C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:59:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69A1761056
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:59:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 69A1761056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 204804B0BE;
	Fri,  8 Oct 2021 09:59:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sRbyFJStlr7x; Fri,  8 Oct 2021 09:59:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C55CC4B149;
	Fri,  8 Oct 2021 09:59:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1EA94B175
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 83J6nnqlqdOK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 09:59:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52F5F4B18A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:59:02 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05C2061042;
 Fri,  8 Oct 2021 13:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633701541;
 bh=JTv2hBMDVb25nVPPPEEoEpoPB6xSLc/jUtJnXV0tdVQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=jZnrC7Gk+glAbDKycPWsmETvhrpPe47c8jrns35zukWVGjdziwzckCHd5BUVOM/ik
 YP4GjWUemj95E1y7zEh10eE1S7Er1H5ox734i0PZHDbh0xxtziaUKtJ9zVglifuKBF
 LXdchp+8W3ruKiBr0VeMpnW6RaxqUv8bqEHKgdAzaabN4Th41ulNpyRbvX+dcNb587
 +fX4ogzTnjrqhFfH5z2ylJdKBZH7xD/hVNpWIpogQ/xvJe9ziyWkbrpImacdZ8Dyjz
 hrs5tDcvaMJM/u6Bxw83e0DVeiMOXi/X+EYUmyiEgGrQoz6Ao8KVleL7o1VX52FCuP
 fy0X6rm0eQ7LA==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 6/6] KVM: arm64: Disable privileged hypercalls after pKVM
 finalisation
Date: Fri,  8 Oct 2021 14:58:39 +0100
Message-Id: <20211008135839.1193-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211008135839.1193-1-will@kernel.org>
References: <20211008135839.1193-1-will@kernel.org>
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
 arch/arm64/include/asm/kvm_asm.h   | 25 +++++++++++---------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 37 +++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43b5e213ae43..4654d27fd221 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -50,27 +50,30 @@
 #include <linux/mm.h>
 
 enum __kvm_host_smccc_func {
+	/* Hypercalls available only prior to pKVM finalisation */
 	/* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
-	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
+	__KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2 = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
+	__KVM_HOST_SMCCC_FUNC___pkvm_init,
+	__KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
+	__KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector,
+	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
+	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
+
+	/* Hypercalls available after pKVM finalisation */
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
+	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
+	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
-	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
-	__KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs,
-	__KVM_HOST_SMCCC_FUNC___pkvm_init,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
-	__KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector,
-	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
-	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
