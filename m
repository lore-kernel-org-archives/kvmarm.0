Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33BBC56202
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 17:59:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F1DF20665
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 17:59:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="waEzZM9v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F1DF20665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AE494B965;
	Mon,  9 Nov 2020 12:59:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LZDw1ss4bgLn; Mon,  9 Nov 2020 12:59:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D0E44B9B0;
	Mon,  9 Nov 2020 12:59:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 115994B902
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 12:59:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tj+4RJ+QaPLG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 12:59:31 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 666514B82C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 12:59:31 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6A83B2067D;
 Mon,  9 Nov 2020 17:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604944770;
 bh=nGVW/NiwG8KzPVzwo3qIsfuk1pq1h3XDKPnw04oTURI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=waEzZM9ve6jspeN4wZ2KJ4dc41WrmnWpvUAgJAdCw3j3f/cAhTNpG8ZR/2G/S7Q+m
 st7DL7xwxHju8qqFdpX6ffWExdj5Zxx2HJJAqHCcqX0Ni82d7R9Bc5lErTa5/OTUwU
 5589mK0CxmFzXjFdlFzpxqKFiqQZryPuM9gvd9lM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcBRw-009BQs-KS; Mon, 09 Nov 2020 17:59:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 2/5] KVM: arm64: Turn host HVC handling into a dispatch
 table
Date: Mon,  9 Nov 2020 17:59:20 +0000
Message-Id: <20201109175923.445945-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201109175923.445945-1-maz@kernel.org>
References: <20201109175923.445945-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, ascull@google.com, will@kernel.org,
 qperret@google.com, ndesaulniers@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 ndesaulniers@google.com
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

Now that we can use function pointer, use a dispatch table to call
the individual HVC handlers, leading to more maintainable code.

Further improvements include helpers to declare the mapping of
local variables to values passed in the host context.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/image-vars.h     |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 228 +++++++++++++++++------------
 2 files changed, 135 insertions(+), 94 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c615b285ff5b..e8c194f8de88 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -64,6 +64,7 @@ __efistub__ctype		= _ctype;
 /* Alternative callbacks for init-time patching of nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
+KVM_NVHE_ALIAS(kvm_update_kimg_phys_offset);
 
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e2eafe2c93af..c0543b2e760e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -12,106 +12,146 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-#include <kvm/arm_hypercalls.h>
-
-static void handle_host_hcall(unsigned long func_id,
-			      struct kvm_cpu_context *host_ctxt)
-{
-	unsigned long ret = 0;
-
-	switch (func_id) {
-	case KVM_HOST_SMCCC_FUNC(__kvm_vcpu_run): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct kvm_vcpu *vcpu = (struct kvm_vcpu *)r1;
-
-		ret = __kvm_vcpu_run(kern_hyp_va(vcpu));
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_flush_vm_context):
-		__kvm_flush_vm_context();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid_ipa): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
-		phys_addr_t ipa = host_ctxt->regs.regs[2];
-		int level = host_ctxt->regs.regs[3];
-
-		__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
-
-		__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
-
-		__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
-		u64 cntvoff = host_ctxt->regs.regs[1];
-
-		__kvm_timer_set_cntvoff(cntvoff);
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_enable_ssbs):
-		__kvm_enable_ssbs();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_get_ich_vtr_el2):
-		ret = __vgic_v3_get_ich_vtr_el2();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_read_vmcr):
-		ret = __vgic_v3_read_vmcr();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_write_vmcr): {
-		u32 vmcr = host_ctxt->regs.regs[1];
-
-		__vgic_v3_write_vmcr(vmcr);
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_init_lrs):
-		__vgic_v3_init_lrs();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__kvm_get_mdcr_el2):
-		ret = __kvm_get_mdcr_el2();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_save_aprs): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct vgic_v3_cpu_if *cpu_if = (struct vgic_v3_cpu_if *)r1;
-
-		__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_restore_aprs): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct vgic_v3_cpu_if *cpu_if = (struct vgic_v3_cpu_if *)r1;
-
-		__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
-		break;
-	}
-	default:
-		/* Invalid host HVC. */
-		host_ctxt->regs.regs[0] = SMCCC_RET_NOT_SUPPORTED;
-		return;
-	}
-
-	host_ctxt->regs.regs[0] = SMCCC_RET_SUCCESS;
-	host_ctxt->regs.regs[1] = ret;
+#define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
+#define DECLARE_REG(type, name, ctxt, reg)	\
+				type name = (type)cpu_reg(ctxt, (reg))
+
+static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
+}
+
+static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
+{
+	__kvm_flush_vm_context();
+}
+
+static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
+	DECLARE_REG(int, level, host_ctxt, 3);
+
+	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
+}
+
+static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+
+	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
+}
+
+static void handle___kvm_tlb_flush_local_vmid(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+
+	__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
+}
+
+static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
+{
+	__kvm_timer_set_cntvoff(cpu_reg(host_ctxt, 1));
+}
+
+static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
+{
+	__kvm_enable_ssbs();
+}
+
+static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = __vgic_v3_get_ich_vtr_el2();
+}
+
+static void handle___vgic_v3_read_vmcr(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = __vgic_v3_read_vmcr();
+}
+
+static void handle___vgic_v3_write_vmcr(struct kvm_cpu_context *host_ctxt)
+{
+	__vgic_v3_write_vmcr(cpu_reg(host_ctxt, 1));
+}
+
+static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
+{
+	__vgic_v3_init_lrs();
+}
+
+static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = __kvm_get_mdcr_el2();
+}
+
+static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
+}
+
+typedef void (*hcall_t)(struct kvm_cpu_context *);
+
+#define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = kimg_fn_ptr(handle_##x)
+
+static const hcall_t *host_hcall[] = {
+	HANDLE_FUNC(__kvm_vcpu_run),
+	HANDLE_FUNC(__kvm_flush_vm_context),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid),
+	HANDLE_FUNC(__kvm_tlb_flush_local_vmid),
+	HANDLE_FUNC(__kvm_timer_set_cntvoff),
+	HANDLE_FUNC(__kvm_enable_ssbs),
+	HANDLE_FUNC(__vgic_v3_get_ich_vtr_el2),
+	HANDLE_FUNC(__vgic_v3_read_vmcr),
+	HANDLE_FUNC(__vgic_v3_write_vmcr),
+	HANDLE_FUNC(__vgic_v3_init_lrs),
+	HANDLE_FUNC(__kvm_get_mdcr_el2),
+	HANDLE_FUNC(__vgic_v3_save_aprs),
+	HANDLE_FUNC(__vgic_v3_restore_aprs),
+};
+
+static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned long, id, host_ctxt, 0);
+	const hcall_t *kfn;
+	hcall_t hfn;
+
+	id -= KVM_HOST_SMCCC_ID(0);
+
+	if (unlikely(id >= ARRAY_SIZE(host_hcall)))
+		goto inval;
+
+	kfn = host_hcall[id];
+	if (unlikely(!kfn))
+		goto inval;
+
+	cpu_reg(host_ctxt, 0) = SMCCC_RET_SUCCESS;
+
+	hfn = kimg_fn_hyp_va(kfn);
+	hfn(host_ctxt);
+
+	return;
+inval:
+	cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
 }
 
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
-	unsigned long func_id;
 
-	if (ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64)
+	if (unlikely(ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64))
 		hyp_panic();
 
-	func_id = host_ctxt->regs.regs[0];
-	handle_host_hcall(func_id, host_ctxt);
+	handle_host_hcall(host_ctxt);
 }
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
