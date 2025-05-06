Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91B928B4E0
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550163; cv=none; b=ZSyiH6dZf5URZuWA8hAEyIL7fHSQTo7f9CUDU7AoV5CkPo0jWLYuq+Y0USu5KPCyRO30SH77pVi4GV1Tyr1jzydRGhXAptuKKorXgaW65GFdzB6cpgp/dMQHPesNhLiNHtCTBzkMT/mT5hwnFQqeughLgXN1dPFZf5VeP6f/bmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550163; c=relaxed/simple;
	bh=torEYCq9v46z/4CnJ0hFeX5w0LCijhb9CNJxYaNikPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=itKy8xyMI3VfpEIIZLsDZgj+yafkOhHEc6B8GZVbt+MlAY3bzL4imCg8ckRIeJvJ/EpZmdvPNafp79KSA4xYsA3+KFY+dW12So+oTymbZ8V8dNrPBUETpksMhcd+o8tBmI24DwpqBhOIK+yATzU3axCBjY9rGpPHyzQdB4nVnr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PuPyKCJ0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PuPyKCJ0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43f251dc364so33774545e9.2
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550160; x=1747154960; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sP0+o0uEsWOaDtIvEsCo5unr0sfd3Il5igHJZ3qKciY=;
        b=PuPyKCJ0jA5o+QTKj7RabrIBgilp9/ySlVd+kBHsM9Q7sNSBPCXWShXVyQtY21LLM7
         CLO/ZY8ZIBAUIocsNzZOlhxzOoPYgeL1Ipr+skmox2PxyJJrsvJorpwLHlFmAjDCcVQl
         H+mEfaGGHx3jG7t6kS0AirPPhOjzPXT20plwqkNBPhYr8VKl3iuy16sIlEK9BVIOT/jU
         Ph6AiGW/qOGpGk9aJ1mtvQ7UHCTeOV7P6l2d0miyNg8W9HAaBr1g9AA/ZvFjNSkPZjzG
         1PZFu9mPRCvwGQf0WCP1G0wmY8K3afuXS53AYJo3gzDeAORomxAlIA/kXXzYhJiItPFB
         qgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550160; x=1747154960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sP0+o0uEsWOaDtIvEsCo5unr0sfd3Il5igHJZ3qKciY=;
        b=jO5s0NNMUcXVe2gH3e6Pf2JNspn9CdBlDtTenAeCypvqVBro4JyHCeBf6rieYZP/ZC
         F8IUsoHEfsTXd+yT5d+jFTgB08/EZfPg0fLy9O0+xZM/YFr1J2L6AbHZwXeIbgkThIlZ
         u9SOu014vvAiqc2FA/ndUQeU07xWiG/nKJUNqio9w/MM5u0guW9jtURcy5GQKElHc/HZ
         fqpHiAClmpDIGF/S4DEa4FV2PPeEaMX0YsJTcettoiXoKmeM7JRqf+WgiBqYQW41QLVO
         XgHNJ2dbDk2/29WkQevARnYFAZvCy7YIGfAW4s/TzVRj26VEznjeacSvH4Jc5X074bD3
         wykA==
X-Gm-Message-State: AOJu0Yy80hvmQ0OhfYlZWtiGxMN3cqSQXRX6YVkrIN1guMsGk1Bl1Z6r
	Bq6TpFkXt3fE39oiwzdDR9fUsuU4LCAEe5+vak9gIf7beEuGuCdlzSRvYuL7H/LcShUeH1XpoYo
	p4120jqiLjzHXOPCBnw==
X-Google-Smtp-Source: AGHT+IHUuqs+r3rhJxv97f89Ad2Z2eXd2asFXzm6hFHj+5AyVi1/wxB573CGibob8tbRu/wOxVh8rL3Ar7Iep4nH
X-Received: from wmben3.prod.google.com ([2002:a05:600c:8283:b0:43e:9aac:5a49])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3494:b0:43c:f5fe:5c26 with SMTP id 5b1f17b1804b1-441c48aa314mr122683335e9.4.1746550160430;
 Tue, 06 May 2025 09:49:20 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:18 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-23-vdonnefort@google.com>
Subject: [PATCH v4 22/24] KVM: arm64: Add hyp_enter/hyp_exit events to pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The hyp_enter and hyp_exit events are logged by the hypervisor any time
it is entered and exited.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index d6e033c96c52..ce3953bc884a 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -7,4 +7,21 @@
 #include <nvhe/trace.h>
 #endif
 
+HYP_EVENT(hyp_enter,
+	HE_PROTO(void),
+	HE_STRUCT(
+	),
+	HE_ASSIGN(
+	),
+	HE_PRINTK()
+);
+
+HYP_EVENT(hyp_exit,
+	HE_PROTO(void),
+	HE_STRUCT(
+	),
+	HE_ASSIGN(
+	),
+	HE_PRINTK()
+);
 #endif
diff --git a/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h b/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
new file mode 100644
index 000000000000..4b69d33e4f2d
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include <asm/kvm_hypevents.h>
+
+#include <linux/arm-smccc.h>
+
+#undef arm_smccc_1_1_smc
+#define arm_smccc_1_1_smc(...)					\
+	do {							\
+		trace_hyp_exit();				\
+		__arm_smccc_1_1(SMCCC_SMC_INST, __VA_ARGS__);	\
+		trace_hyp_enter();				\
+	} while (0)
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 3369dd0c4009..e00931fd194f 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -26,10 +26,10 @@
  * the duration and are therefore serialised.
  */
 
-#include <linux/arm-smccc.h>
 #include <linux/arm_ffa.h>
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/arm-smccc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3d36be6d94ca..7d7d0c07a6d4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -12,6 +12,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 
 #include <nvhe/ffa.h>
@@ -713,7 +714,9 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 
 static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
 {
+	trace_hyp_exit();
 	__kvm_hyp_host_forward_smc(host_ctxt);
+	trace_hyp_enter();
 }
 
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
@@ -737,6 +740,8 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
 
+	trace_hyp_enter();
+
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_HVC64:
 		handle_host_hcall(host_ctxt);
@@ -751,4 +756,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	default:
 		BUG();
 	}
+
+	trace_hyp_exit();
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index c3e196fb8b18..64d1d418df1d 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -6,11 +6,12 @@
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
-#include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
 #include <uapi/linux/psci.h>
 
+#include <nvhe/arm-smccc.h>
 #include <nvhe/memory.h>
 #include <nvhe/trap_handler.h>
 
@@ -205,6 +206,7 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 	struct psci_boot_args *boot_args;
 	struct kvm_cpu_context *host_ctxt;
 
+	trace_hyp_enter();
 	host_ctxt = host_data_ptr(host_ctxt);
 
 	if (is_cpu_on)
@@ -221,6 +223,7 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
 
+	trace_hyp_exit();
 	__host_enter(host_ctxt);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7d2ba6ef0261..bbe035acda89 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -7,7 +7,6 @@
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
 
-#include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
@@ -21,6 +20,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
@@ -349,10 +349,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest(vcpu);
 
 	do {
+		trace_hyp_exit();
+
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
+		trace_hyp_enter();
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
-- 
2.49.0.967.g6a0df3ecc3-goog

