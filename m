Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9C1C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 11:23:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D2DBB61107
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 11:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D2DBB61107
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 877074B13B;
	Thu, 23 Sep 2021 07:23:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1BeqC1+46J4k; Thu, 23 Sep 2021 07:23:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4310D4B12F;
	Thu, 23 Sep 2021 07:23:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA9794B0B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 07:23:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5PKxMxF17DNN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 07:23:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7650C4B136
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 07:23:12 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48B1B611C6;
 Thu, 23 Sep 2021 11:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632396191;
 bh=DMbPTWIl8l89NmtqiofRXVDto4/SgvGfTeCv5+IxVA4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=T/OpiqDkB5iYJpHJqk/+B4abVTRPILrHLDdWJlryB/ClPzMU8CK+I3YHhaCoZzZn0
 8qXgkRZ2gI27nc/uMjEU8Bzk5CTBt+jCt3FErFGARvy+26PJC6lkc+JdandGbF7FI1
 55DSPiiTxlgiJEwhxcSDbvwCgvfHEDZPcWJzdzueB7FJzFwNmmBUV6oe1vX9xLefdT
 0WII+ELVsQ4ViateeWNJznqiPcG11hwsB9LD07NHqDpQTYLBM74hhE9b6OJ0Zfm339
 nyQdoeJhQjJHyLT42dNT+oZUGXZ7s2jo8T7VR+w7YaIJ/AZOHsuxZAG8qNjX4EW6rg
 o21VPAp7L6n3w==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/5] KVM: arm64: Disable privileged hypercalls after pKVM
 finalisation
Date: Thu, 23 Sep 2021 12:22:56 +0100
Message-Id: <20210923112256.15767-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210923112256.15767-1-will@kernel.org>
References: <20210923112256.15767-1-will@kernel.org>
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
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 26 +++++++++++-------
 2 files changed, 39 insertions(+), 30 deletions(-)

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
index 2da6aa8da868..4120e34288e1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -165,36 +165,42 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
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
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
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
 
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		hcall_min = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize;
+
 	id -= KVM_HOST_SMCCC_ID(0);
 
-	if (unlikely(id >= ARRAY_SIZE(host_hcall)))
+	if (unlikely(id < hcall_min || id >= ARRAY_SIZE(host_hcall)))
 		goto inval;
 
 	hfn = host_hcall[id];
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
