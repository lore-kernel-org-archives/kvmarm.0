Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7333F402452
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 12:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775046728; cv=none; b=J8LE8DuHjWr5in5SY9N+rR+O2PHNVdtzYkvkGYoGR3q3drEeBvETzOw0H/vsys6zHx2cwFpDNp5xvesqG9TVyr2kBVa/Qln6OBIVlYAymKpx1ihMDTxa7QpNb1eNuZ1lou4aKu5SDufPJO1X25v0uJI0IkFe9AKCQyNGdzyERbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775046728; c=relaxed/simple;
	bh=G4Yao6fDuq2DLugPKChKu/hAScXxcgM0sObQSmU35Ww=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YQj0P088EfBZBXIlOOczrmd83HRA0bzyyXBB/hVcxrkNWMYeF5L3jSbPE2gk79TyKpKLYFGHhOqu/VnMi+23PhBm6EPPYFmnLIvygjTGRoJsrANLrGbXzj1Pv3PHq00q2Uqwijl2xg0ypHWi8TDZ6NsnNZVWljHcnVQ7Ub8dxj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P7CRCsFZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P7CRCsFZ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4887fbb4dc8so10441875e9.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Apr 2026 05:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775046725; x=1775651525; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wm1IdxU+STCksWGBkUITwVrqTDoqeENYUSliBBXIr30=;
        b=P7CRCsFZJ4muaBSmJztwVJ/oCdjYy9KXyXlxYQdjxY5Iu2P7E7giUzuxHyzXSeHC3w
         HEH/kgs/9SwaHxeM0U5l7mPUlRpXQvIoYenPVG4TIht4RLeL33Uij9uFPLoaTkqxcasj
         F4OHIsZmC+CRDYrCb5OwJMz2gTERZPLQYynU0y8ioxC3OaUu+8KeyK+/iTyq5ki2pIFq
         sfMBCmP2t+j6FBW0OgLmaDWYkUkCG4x9geO4RdlVjGyXTgbTtyHwuEnEW17bdEH1ozFn
         0ijXCgO/6teoPn6gio3PtC9mNH4Htrm4oivhOfIynUnbzRwAh2BpSfxGFGEiLXzyu3vP
         WzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775046725; x=1775651525;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wm1IdxU+STCksWGBkUITwVrqTDoqeENYUSliBBXIr30=;
        b=PufDgL45RbeUNWwHg4cM6aEzJVDqz2EY9yps5EXz2SpJDM7eDVKv5Z3aWuYOPOFlEJ
         KLC9OmSbfTTrPaYHNx8cppsj1m2uipJIS6GY2ukkMTzctohhAwSbrSa8PniNsUTzBfOP
         lgHgemZmpImQnu1ZSFS6TN8yHNBF75QE93NzpE321FJXitrpeyrq32XjRdmHrNxSloZ/
         +/p1tivrOBCgYkVCUM1isc019wjKIm+F3UFi0mxiYJ3IgmzDLJT2keDil16SzflMYtTP
         EdX1zwKM2Aocd35tfPkOi8+hyq12ZU9TirV5P6Vy9hK3M0zfhpmkijs3Lg7Rwp1hUoyB
         zF1g==
X-Forwarded-Encrypted: i=1; AJvYcCXHtYO4hUC21IQHhrBuUP7Ak7DQzpvhlPx1tmjH7kuqw5dONLH+ipdbf17E0y9zfG4bCkB0U1o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw+sZbE75sS+jtaf8rhxep+Aw/4Zu7Cvqy/FxWMdOwI3IfL3WX
	NmSIpHLoWKF3DPqN85/1qrgHv29aX85zz91WA8ciTDOYuo37lrVYWJdJ83aHefyttrLQPuEVnmq
	PZdGk65SnmK/uoa+5+aGUsXz7wB73fA==
X-Received: from wmba9.prod.google.com ([2002:a05:600c:6dc9:b0:487:201c:8d57])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:354a:b0:485:49c5:8eb7 with SMTP id 5b1f17b1804b1-4888359205dmr51064615e9.22.1775046724497;
 Wed, 01 Apr 2026 05:32:04 -0700 (PDT)
Date: Wed,  1 Apr 2026 12:32:01 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1185.g05d4b7b318-goog
Message-ID: <20260401123201.389906-1-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Pass a 64bit function-id in the SMC handlers
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: joey.gouly@arm.com, korneld@google.com, maz@kernel.org, 
	mrigendra.chaubey@gmail.com, oupton@kernel.org, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Make the SMC handlers accept a 64bit value for the function-id to keep
it uniform with the rest of the code and prevent a u64 -> u32 -> u64
conversion as it currently happens when we handle PSCI.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h      | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/ffa.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 2 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 76ce2b94bd97..c9976425a85c 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -119,7 +119,7 @@ void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
-bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt, u32 func_id);
+bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt, u64 func_id);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/ffa.h b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
index 146e0aebfa1c..21afca11ae0b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/ffa.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
@@ -12,6 +12,6 @@
 #define FFA_MAX_FUNC_NUM 0xFF
 
 int hyp_ffa_init(void *pages);
-bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id);
+bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u64 func_id);
 
 #endif /* __KVM_HYP_FFA_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 94161ea1cd60..87e6d36f120a 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -862,7 +862,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
-bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
+bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u64 func_id)
 {
 	struct arm_smccc_1_2_regs res;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index c3e196fb8b18..79f390057c19 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -278,7 +278,7 @@ static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_
 	}
 }
 
-bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
+bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt, u64 func_id)
 {
 	unsigned long ret;
 
-- 
2.53.0.1185.g05d4b7b318-goog

