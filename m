Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E314156676
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 10:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728901461; cv=none; b=fogFhwAb7l7pEI/xq6m87TVeNaizew0O08tH5WPmmIAisgmb8dY6tnIYLW0jGl2HSVN+x4oc9A8/7kWHx1Mi20JAYx2/khfSpUmVfeERbQ4jHH/to/8hvGkzYLZuJ2j6UF6JEoC9RDjHmGrEjcst3SaC3E3wO3yrvaZ060SSYCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728901461; c=relaxed/simple;
	bh=xHzrQ6Ei63uHqB6mawAXDVEupKgRqThCAAkQgkwpmR4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DI0enJJ4ltgOIysRZM6bwcjC8GmZXs/M+UMp6v6WRyrsz++qQFdSmubf+P6CA4qUW9kMyfGTQVOJMVdFFTMC+DmmbsAwbmUK91c8BT9tAIhC2tgYNjpc8xXZaBEEHbH5ahcEVUAjzZLNYssxLlz/v0aqtAn+n6naHkLmiCtypFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bKZGMzZZ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bKZGMzZZ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-37d5ca192b8so1286286f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 03:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728901458; x=1729506258; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfP2Wkaa1K6/7fTY6d/L/bOSBL8Udspd9Tr/mEaw9/o=;
        b=bKZGMzZZjDzEvhDcUUmGV13H9okQfKAVBmEEo/QI1oSxEl9AW7yIQIEq0cGoHV6Ois
         WolF+65YQoc2mW5CnbBoZjWMs/fjSHPCs272gixM8pt2S8/yBs4W8oCGVKP45Z7kQdja
         WVbZ7NdfOn9gfUfGkvz4uX4GA8sdykm0LHqEUPBNSAEW5Q4qKaxPy4IDSfL21/pMdT3Q
         gOk2STYDgKBliUfFTVVq+AMjtbLRY0Tfv8zCt7o4c5SCWuqTgvt6yTLChMvhaBNo1wKZ
         zy9D52wgrfhC4+E0AvvNwMqhQmWaiUdaVgLm47X07swBvJqw0ofBLvmhLLphBrW+iMv+
         ao/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728901458; x=1729506258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfP2Wkaa1K6/7fTY6d/L/bOSBL8Udspd9Tr/mEaw9/o=;
        b=FW/gvRNjH/rRUvQPoevRumOHobcNp/ZMuAmKdcCEseqNcQJ3LHNCI7aRlsDxpFucCX
         g0DJVPpuPXpKKEhYaxKGXRs6N53qrMUyfjaSKEnPjvq8W25kelMv/JWU6GI6v7nMnv+k
         EKpC5yOMo9ErzkfN5KlCoXz1D7RxKpwbb1/mrTT8w2V9Yg0pdzN8YhTIBurZU1fv2Iam
         lijvXBm9I6enFMsiJdtb8fFqpOvSv4mrbqfA8aElDS8CY2/ZiuIe4uXT7Ci7O1b78zhu
         XieHf6ZHGV7IQRVdfIcQM7z8V73du+JrGlMs0vINoYHCLUC7cGTolRtyvJGC/LiUZW0t
         WDMw==
X-Gm-Message-State: AOJu0Yzo1Y9fi+HdbWdTJfSzqC9/HH3Jw04Ne++cQeNP3HMXSYDf/tAv
	n/vj1INhzfRyx2ar1VpaZKhtNJws0UfffVH1MD/dKQO0qQlfcbkH3owJVN0R+Qm8xX+dbR06un1
	BPxdNg4v76mld2NLFBpKfPjUi3GjHVpNQAXlfUsU9OMDdkM3QuwXx1DJVIppor+mKv08HBFfg/D
	CNN9xbIDMBqrYkuhvjlyYkngoLCUg=
X-Google-Smtp-Source: AGHT+IEW7lllj3xUtBPWTOeyGfdo4pRsOVJ6sfAnvboWZXQl2+leEG6jBuETyu3euibW10qOi3H/JR/KTw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e5cd:0:b0:37c:ccdf:b69a with SMTP id
 ffacd0b85a97d-37d55262a22mr23460f8f.3.1728901457519; Mon, 14 Oct 2024
 03:24:17 -0700 (PDT)
Date: Mon, 14 Oct 2024 11:24:09 +0100
In-Reply-To: <20241014102413.4092725-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241014102413.4092725-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014102413.4092725-2-tabba@google.com>
Subject: [PATCH v1 1/4] KVM: arm64: Move pkvm_vcpu_init_traps() to init_pkvm_hyp_vcpu()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Move pkvm_vcpu_init_traps() to the initialization of the
hypervisor's vcpu state in init_pkvm_hyp_vcpu(), and remove the
associated hypercall.

In protected mode, traps need to be initialized whenever a VCPU
is initialized anyway, and not only for protected VMs. This also
saves an unnecessary hypercall.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h               | 1 -
 arch/arm64/kvm/arm.c                           | 8 --------
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h | 2 --
 arch/arm64/kvm/hyp/nvhe/hyp-main.c             | 8 --------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                 | 4 +++-
 5 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index b36a3b6cc011..7f7866d2bfc2 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -76,7 +76,6 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
-	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a0d01c46e408..ece934bb4531 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -856,14 +856,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
index fefc89209f9e..1a224d5df207 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -349,13 +349,6 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
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
@@ -411,7 +404,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
-	HANDLE_FUNC(__pkvm_vcpu_init_traps),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 077d4098548d..869955e551a0 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -204,7 +204,7 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 /*
  * Initialize trap register values in protected mode.
  */
-void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
 	pvm_init_trap_regs(vcpu);
 	pvm_init_traps_aa64pfr0(vcpu);
@@ -335,6 +335,8 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
+
+	pkvm_vcpu_init_traps(&hyp_vcpu->vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.47.0.rc1.288.g06298d1525-goog

