Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C62F14D447
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561044; cv=none; b=JuUQuQzzzFt1dD3JN12shHaDrR/QDjU0b0l3mXb7Le4+5BOr6XSfCF3w0kwTOASGqjHc8cQM7PPUFyYWvbobgJv4G0b8/Gz+5XCxIG4I5V9+pzSZMMQ2vJ7qdsMZUHg+B7B8ewPoDBrrW7bxsCzG8OsbKgug7BxyE2RGWCZGEPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561044; c=relaxed/simple;
	bh=zeT7SPD/X6oBtV0+cZoDpp/U1bTFhwIJ8F+0AiRFn3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bK0CNzdP9j2PURQngJa8VUDCTOWb4e+KijUTGRXUKnYUc4Cxtpk/zcGj0ZAJNlRpcLQLVjUsMZs9eHj2j5pDY3N/MRknykJxH2RYvC+HQIlZZabn5oYd2/7bx/59ZUALHrkgQ/edievvU3+RdVsIb9f/zZ7Wlihi5g1iokVqE6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qReYWet+; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qReYWet+"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcd1779adbeso54199276.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561042; x=1712165842; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+TRVA/IgQSGV2qeoj3EsAU29Tyl7au9mn/pO7KYj6Ac=;
        b=qReYWet+a/xg7trv3O3jSxl+vnmkieH9teHWUmjxu9qTPwS5w+VlgG+gJ35jEeutIg
         QPfmHIyCCbVaiopLPn/OqBJZEvaOpHZ1uH0PUlIQ3wSoBaKek49/bIJBPCzZORjbfJ4v
         jsBTDsqEkozWNm0dtvZ12AxI6yIQRcOQc2Oqd2H0lGMD5XSrDUpNPtP0aycwVGL6OlBN
         XXjNd/8WKfRPXxUeI3reojagdWKWs3wjk5K/mnCtfeKGL82yDbVfUKY+U6xg+exBinOm
         0ecObqNl20ArHKrwnYkvPazkMzYy8dCMbFfqy93a5fdo4YWgC2LzlxA84YA+2jHnOFEE
         K/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561042; x=1712165842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+TRVA/IgQSGV2qeoj3EsAU29Tyl7au9mn/pO7KYj6Ac=;
        b=fi9UnFdle91G1m2PGhTJvMcmjesHm0yZTzjptNg7CeIMtQh+SiES/nTphnKwmzpwT3
         p2cYVxOI+l272AGt1re/deCPiiPhtJiI5FMCf0146jQT6qcd1o70rCf6Auk39bn4tUTS
         659KLk8BcPTwchlEzB2MaxhLP8yFYEVp/h1Ultgm3OvXz1xr64etbSxmLuW6kqb28sAH
         qw2SohL8JoyI4+D5awHYk7fmqwYTx7lVkOntTyPzE33RQE34iX45IuIxEPIlUgt/flVs
         imfbvMbOB7KvrchmYl5FsXSg2/h6dLszgyYFcVIugh8Fr1t9rbh6f3qPJIqkfJ/4v4Yt
         pBbw==
X-Gm-Message-State: AOJu0YwYhXBAPtOUBEILIkGWvbxEt25i4TDbng4gckcxJ2c/VkVgaNBd
	s+4CHOKfvGmQhwlJ6ATlMS6fr8riWq7HiRa0kXdkhdBTmzpXBoy//wc1H/+1Nxibrz0VtJUrmFj
	SkAsF8ImJIh+/4LwzjyVncdeWlLjqVAr08sRA6law9QwYYzGcgwUktsl3MwFPaMNgRRVjoWMlpK
	IoJJAATz+nHmqRToJ3Y+tlpw9bZP4=
X-Google-Smtp-Source: AGHT+IFPrVWn4/swa4PD16PBI0EEHoExrw1/qfALYAtV1Y/6x7gohcz0KbjEdlvxUzsrQ9BgvOeo1ON2Hg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1009:b0:dc6:ff2b:7e1b with SMTP id
 w9-20020a056902100900b00dc6ff2b7e1bmr159090ybt.4.1711561042515; Wed, 27 Mar
 2024 10:37:22 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:28 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-42-tabba@google.com>
Subject: [PATCH v1 41/44] KVM: arm64: Move pkvm_vcpu_init_traps() to hyp vcpu init
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index 79783db5dac8..828bbd9e2d94 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -776,14 +776,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
index b7d7ca966f2e..aa50f2cb9d09 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -270,13 +270,6 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
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
@@ -332,7 +325,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
-	HANDLE_FUNC(__pkvm_vcpu_init_traps),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 59c6b4317f29..bc520f9f6d07 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -201,7 +201,7 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 /*
  * Initialize trap register values in protected mode.
  */
-void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
 	pvm_init_trap_regs(vcpu);
 	pvm_init_traps_aa64pfr0(vcpu);
@@ -332,6 +332,8 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
+
+	pkvm_vcpu_init_traps(&hyp_vcpu->vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.44.0.478.gd926399ef9-goog

