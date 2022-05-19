Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11F0C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CE714B426;
	Thu, 19 May 2022 09:46:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xiE1sGIdKXCB; Thu, 19 May 2022 09:46:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 316F84B425;
	Thu, 19 May 2022 09:46:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6AF24B3D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id prxoWHq0-eZe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:33 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E34C4B344
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 78C41B824AB;
 Thu, 19 May 2022 13:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69ECC36AE3;
 Thu, 19 May 2022 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967991;
 bh=f/t2sfwXE6qndGFlrn//t91O5QPLvKErMyl+kkmPMXg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=K8tAIMGoLjRHyFe80/Nh8CQ5mIO2bCVGA8Lh6GU6deOuOYaGS8esw60c2cndn1UNl
 c5IGGuscx8ub3Z55ykvIopOpWUcYsGzdRsccVQwm7DDqlbX/Oh6hd1w7Coc7KTvzZ9
 9aRAQ7fyUO3sfut2vdOCtawqZzM+qJeTRS9+0Sk6uLK+LzDbYbcOGLD/eDhbklvrE8
 nhheBr9UBFhQVadsX2iDmuq8Sdh7xPPFL82k7k430TfoUGRlFxA/eAJ0KmBpBfRrAg
 YukCFN2DtLdFz3rQe9H/ZQjhXjfr/AjcuqxICNO1v43irPRC8GnKLyffLVYX5YKwgx
 UWPqqdwTisDqQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 62/89] KVM: arm64: Move pkvm_vcpu_init_traps to shadow vcpu
 init
Date: Thu, 19 May 2022 14:41:37 +0100
Message-Id: <20220519134204.5379-63-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Move the initialization of traps to the initialization of the
shadow vcpu, and remove the associated hypercall.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h               | 1 -
 arch/arm64/kvm/arm.c                           | 8 --------
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h | 2 --
 arch/arm64/kvm/hyp/nvhe/hyp-main.c             | 8 --------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                 | 4 +++-
 5 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ea3b3a60bedb..7af0b7695a2c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -73,7 +73,6 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
-	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_shadow,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8a1b4ba1dfa7..65af1757e73a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -664,14 +664,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
-	/*
-	 * Initialize traps for protected VMs.
-	 * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
-	 * the code is in place for first run initialization at EL2.
-	 */
-	if (kvm_vm_is_protected(kvm))
-		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
-
 	mutex_lock(&kvm->lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
 	mutex_unlock(&kvm->lock);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
index 45a84f0ade04..1e6d995968a1 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -15,6 +15,4 @@
 #define DECLARE_REG(type, name, ctxt, reg)	\
 				type name = (type)cpu_reg(ctxt, (reg))
 
-void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu);
-
 #endif /* __ARM64_KVM_NVHE_TRAP_HANDLER_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 0f1c9d27f6eb..c1939dd2294f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -620,13 +620,6 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
 }
 
-static void handle___pkvm_vcpu_init_traps(struct kvm_cpu_context *host_ctxt)
-{
-	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
-
-	__pkvm_vcpu_init_traps(kern_hyp_va(vcpu));
-}
-
 static void handle___pkvm_init_shadow(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
@@ -674,7 +667,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
-	HANDLE_FUNC(__pkvm_vcpu_init_traps),
 	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__pkvm_init_shadow),
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index cd0712e13ab0..2c13ba0f2bf2 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -188,7 +188,7 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 /*
  * Initialize trap register values for protected VMs.
  */
-void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
 	pvm_init_trap_regs(vcpu);
 	pvm_init_traps_aa64pfr0(vcpu);
@@ -363,6 +363,8 @@ static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 		shadow_vcpu->vcpu_idx = i;
 
 		shadow_vcpu->arch.hw_mmu = &vm->kvm.arch.mmu;
+
+		pkvm_vcpu_init_traps(shadow_vcpu);
 	}
 
 	return 0;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
