Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5601D8627D
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261494; cv=none; b=UrPAwfWfGzNe+HrpOFXa6eCyAiSYL7i21bm4p7dvLWN+RWXMdmvFL2scgF2Zdz9Wfv1r7wrtmxVqEtMLn66R29eiuTw2D8L0UKQKBwvMXjI9TnBJ1A4KDyFJgycnsMq2NOhHBrsoSHkmQSMtm85j7ZkPe/2IyujJZnD4nY/HOD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261494; c=relaxed/simple;
	bh=pVqjW6eWs3iQ9PHmleMFtRZMGsv8l3Z8Cxp0iq6cdo4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ptcZJbZ5hylAxPNIbHasAUF4puT8v9whDgqZwjZTgHWl9qorqNUqeKPtte2WT6q/cThBpnOg1Roh0zdywzI97W8X9qB6miBknG3rGWvP3OR/Y1wNVe+vdGk/1vN2EoPCFKtCLyrozdseLw40WLI25aRWX07ep6/QyzwhvFMbFXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OJRBBrBw; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OJRBBrBw"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd169dd4183so5553953276.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261492; x=1713866292; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oIxGU7X64+X4Rbhl1gtbMSyi9sGUgHVVnQ1S66RM5OU=;
        b=OJRBBrBwgAmCdmAlr+KEmiBTeTRTPlRCu12856RIMuJo4zd2fTSI5z7QAF3i2blF9F
         y6AuIFP1m4UY2Isbb1qyVqiW9f6Hoi81nw5xHXtMrxWpB9uKDSuaF/Qi4D1Hdj0jn3/6
         yW8A7hYlT+nRUckb1GCsZogEs5W6eFuGw5VfziBoP+ltEIn4mV8FJ4OOnemOleveZSKN
         bIXFXeT0wvp4jOb7+nL9Efjpi5qrDGyh6KgDelM0QPJqAuwj1F1B42TCV4qxk5k7e+Nw
         xgTLowQccC0cXCA7Ilfi3DwsHTCrn21PjbyZLAF4/KjKKCbz4rzunWI53vXH1hR2iR2Y
         bsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261492; x=1713866292;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oIxGU7X64+X4Rbhl1gtbMSyi9sGUgHVVnQ1S66RM5OU=;
        b=Z1Y6kHqC8pTwV6G9jXwmlKa/QFiOmT0ikWs7FWlx8bR2yKscZAGhgui0sVNqOiCKiY
         D4R1XxNRKm9Ni9W8OH9j7otRdUnGW3el2xaDsfV+I0Ftb9dwZTVkkbQA+zuYs+B8ZOZi
         cofIbMLifLyjY8czD65aYgG47kX23NO1IdelMPuwnXqLz3t3BrKm5TP7YggiJNdY0Sl0
         IIkA449bANFSkuSzyznE8rMnISoqnv7rilS0/g8by+Q00uiTjkpfbWG0CakQjtg5uzwz
         A1zl1ViaMIjUBk06aQtTbaeBMxnoCGsY9n6QB3dUfMgLUNDllvbA4oFXNXv+R+WFkvDp
         H5qg==
X-Gm-Message-State: AOJu0YziI9rek1DOQTqT3MMkD3K5DTXsvwjxo2MCiEAA+DM62eKJfOZW
	E9Pdd+pCF64JnLNHPeE7bDB/AtqIbg5V/CdE676oJlyR3uZ6d+jftTAxLEN7dQLiwH15GlQutk/
	8fvQzCOHTvRRbWsChasTnEnnzXIr/DnaYS/OisFmeZFyPcP25of+4Ni8VcK5BQgMDnqhltzapsw
	dJsun7N/IAW1r3N5MeCX1SOZ/JLG0=
X-Google-Smtp-Source: AGHT+IFEJ0QHcA6I9wKy8JCmsVQ78TPBMz5FBtToGQGz9IIRY4TcpjTyIN1/Biex1pcd+tvn1s6oc5PkXQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:c0c:b0:dc2:5273:53f9 with SMTP id
 fs12-20020a0569020c0c00b00dc2527353f9mr1376329ybb.1.1713261492309; Tue, 16
 Apr 2024 02:58:12 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:31 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-41-tabba@google.com>
Subject: [PATCH v2 40/47] KVM: arm64: Move pkvm_vcpu_init_traps() to hyp vcpu init
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Move pkvm_vcpu_init_traps() to the initialization of the hyp
vcpu, and remove the associated hypercall. Traps need to be
initialized at every vcpu init. This simplifies the code and
saves a hypercall per vcpu initialization.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h               | 1 -
 arch/arm64/kvm/arm.c                           | 8 --------
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h | 2 --
 arch/arm64/kvm/hyp/nvhe/hyp-main.c             | 8 --------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                 | 4 +++-
 5 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a6330460d9e5..f8caa2520903 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -75,7 +75,6 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
-	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cddb4c3061cb..293a830d7c28 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -770,14 +770,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
 	mutex_lock(&kvm->arch.config_lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
 	mutex_unlock(&kvm->arch.config_lock);
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
index d5c48dc98f67..b97ebadec3d4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -267,13 +267,6 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
 }
 
-static void handle___pkvm_vcpu_init_traps(struct kvm_cpu_context *host_ctxt)
-{
-	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
-
-	__pkvm_vcpu_init_traps(kern_hyp_va(vcpu));
-}
-
 static void handle___pkvm_init_vm(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
@@ -329,7 +322,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
-	HANDLE_FUNC(__pkvm_vcpu_init_traps),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a29e9efa850d..19d514c4ea2e 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -209,7 +209,7 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 /*
  * Initialize trap register values in protected mode.
  */
-void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
 	pvm_init_trap_regs(vcpu);
 	pvm_init_traps_aa64pfr0(vcpu);
@@ -350,6 +350,8 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
+
+	pkvm_vcpu_init_traps(&hyp_vcpu->vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.44.0.683.g7961c838ac-goog

