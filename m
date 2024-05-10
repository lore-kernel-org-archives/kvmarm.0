Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EB317A91B
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340468; cv=none; b=XQySgMQGD7++E8X5EMJ33pF0cqZccipFgNAuqYJhXFhpHvsMN9YtF5BuAOzxfG+dfUR7KVQQdKWqlg753myEYfwUzVfmafe0AWB0t9sQZFZS6vse8h9Wh4CRtLxKs1CRInS+3KQadnqM4Js1TdNl2AyOcEZwn3hNBgf5KxIn13k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340468; c=relaxed/simple;
	bh=eUzR7xK0G/IZ2Tzlbr0ebewMNKwloXKEQrAq+oA2ljE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O0+drD0XMBcxC/8K4qnfceQmwA4rXEGkPB3yXZPj9lhCYA3YNHbcUQZj3dw2dWukogpWwyYWyrjOrVGhqZjms4D4dDMfS4E212WLafijEErgRc9GNUXZxWty+7000ECMedt17Zyp3jUbeNqhGYWcl+2p1+E1PDUIKPCn2NVbjxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+RQ+KcS; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+RQ+KcS"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a59a5b06802so110451066b.1
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340464; x=1715945264; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n1ymwJj0J6YIOfbRVTRhLBZ520J+M8M3fYhLYcu4SBQ=;
        b=J+RQ+KcS/niCnX2yQVG3PjFJcAkUrMRDxGKWnlIDiCoaSX4217+mMYbq0ED9sPMXeq
         vuvzHKk86zgpA9iWQE0GJq/sNOwEEUkKcJiUvEH08Jx4zVqwkuMXxxey0dUmucU75URw
         Ycmom/BRWEWSukSLAFBuBSI7SbVgxRmChsg/5ov7gsN1khXONhbU17i5FlbQWVth5YjU
         FNL/oUGO143+F+6KTRz5SAF3v47DZlxusfdQfMkNKuTDpB198E1rfnWRSQ6IBzefN+an
         Q2C+PA8VqOqLX0pErpxKVUd4jt09hMqB+SWwtT4fZxYNcWVFDLUirxoLXBhf4Gh7hPmh
         Ji9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340464; x=1715945264;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n1ymwJj0J6YIOfbRVTRhLBZ520J+M8M3fYhLYcu4SBQ=;
        b=HiUrQkv+uD7Uy8qcgC7EL/oYnxo91t7IF8kYYwoir8xtEZdygDDBxivkurbmRpmaIy
         wi+Rg1/XA2++ASIYLk9RNvIhwTmIXiHvBCLLDQeEAgIMp6qTnoSLnKT/b64vU1O6iNkq
         ASMDzigHNHwPQJbO+RaQFd/X+y9XMCe84YZDI7PmWohtmih455rydYFECHhj4QqoEwld
         XJAWrb3g/hTiWWJ2GAXH01DCdY6/ABtot7DAmF8slKh4LGYkL3NBaKPxJWR5yTiplzk6
         doUEEsqomp06vmgXzFRumsPiNb10mXDcxrliHNMUOYe3E3MZgDcCTf2+gb31ddyEqkuH
         fIVQ==
X-Gm-Message-State: AOJu0YwJxJ1k3S7Y9szCHtNqun/+lbbBx8t68JeNUPgtNh1Gt1su/pp1
	ZXgeh3VWZL5T6wsgT3Ka6IyIdZJM9HnijU0dBGlXS59XDRHxPcohLNBYW0kiAbYzPaSqrac5nVv
	97aGl/WgAamjq0n2aaz3Dfkn6OKzuxPMFIm6Sqibg9IqnJ3HGTNrSn30TRE+zsMfnIQK5Q1pRdh
	29io9HGs5IoWhpqwfh3kJQ8CHOwGs=
X-Google-Smtp-Source: AGHT+IH0RrjjfZ++WGHYEq92ODwn6HK5Otkgd5vcXO+mNguBfs2v+NnqgUGPVhO4xg5oozparmcLaLbhaQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:907:940f:b0:a59:cafe:85b6 with SMTP id
 a640c23a62f3a-a5a2d53fafbmr224066b.2.1715340464190; Fri, 10 May 2024 04:27:44
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:40 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-12-ptosi@google.com>
Subject: [PATCH v3 11/12] KVM: arm64: nVHE: Support test module for hyp kCFI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Extend support for the kCFI test module to nVHE by replicating the hooks
on the KVM_RUN handler path currently existing in VHE in the nVHE code,
exporting the equivalent callback targets for triggering built-in hyp
kCFI faults, and exposing a new CONFIG_HYP_CFI_TEST-only host HVC to
implement callback registration.

Update the test module to register the nVHE equivalent callback for test
case '1' (i.e. both EL2 hyp caller and callee are built-in) and document
that other cases are not supported outside of VHE, as they require EL2
symbols in the module, which is not currently supported for nVHE.

Note that a kernel in protected mode that doesn't support HYP_CFI_TEST
will prevent the module from registering nVHE callbacks both by not
exporting the necessary symbols (similar to VHE) but also by rejecting
the corresponding HVC, if the module tries to issue it directly.

Also note that the test module will run in pKVM (with HYP_CFI_TEST)
independently of other debug Kconfig flags but that not stacktrace will
be printed without PROTECTED_NVHE_STACKTRACE. This allows testing kCFI
under conditions closer to release builds, if desired.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_asm.h     |  3 ++
 arch/arm64/include/asm/kvm_cfi.h     |  6 ++--
 arch/arm64/kvm/Kconfig               |  2 --
 arch/arm64/kvm/hyp/{vhe =3D> }/cfi.c   |  0
 arch/arm64/kvm/hyp/nvhe/Makefile     |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 19 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c     |  7 +++++
 arch/arm64/kvm/hyp/vhe/Makefile      |  2 +-
 arch/arm64/kvm/hyp_cfi_test.c        | 44 ++++++++++++++++++++++++----
 arch/arm64/kvm/hyp_cfi_test_module.c | 24 ++++++++-------
 10 files changed, 86 insertions(+), 22 deletions(-)
 rename arch/arm64/kvm/hyp/{vhe =3D> }/cfi.c (100%)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index 24b5e6b23417..3256c91ff234 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,6 +81,9 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
+	__KVM_HOST_SMCCC_FUNC___kvm_register_cfi_test_cb,
+#endif
 };
=20
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_cfi.h b/arch/arm64/include/asm/kvm_=
cfi.h
index 13cc7b19d838..ed6422eebce5 100644
--- a/arch/arm64/include/asm/kvm_cfi.h
+++ b/arch/arm64/include/asm/kvm_cfi.h
@@ -12,8 +12,8 @@
=20
 #ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
=20
-int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void));
-int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void));
+int kvm_cfi_test_register_host_ctxt_cb(void (*vhe_cb)(void), void *nvhe_cb=
);
+int kvm_cfi_test_register_guest_ctxt_cb(void (*vhe_cb)(void), void *nvhe_c=
b);
=20
 #else
=20
@@ -31,6 +31,8 @@ static inline int kvm_cfi_test_register_guest_ctxt_cb(voi=
d (*cb)(void))
=20
 /* Symbols which the host can register as hyp callbacks; see <hyp/cfi.h>. =
*/
 void hyp_trigger_builtin_cfi_fault(void);
+DECLARE_KVM_NVHE_SYM(hyp_trigger_builtin_cfi_fault);
 void hyp_builtin_cfi_fault_target(int unused);
+DECLARE_KVM_NVHE_SYM(hyp_builtin_cfi_fault_target);
=20
 #endif /* __ARM64_KVM_CFI_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 5daa8079a120..715c85088c06 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -75,8 +75,6 @@ config HYP_CFI_TEST
 	  Say M here to also build a module which registers callbacks triggering
 	  faults and selected by userspace through its parameters.
=20
-	  Note that this feature is currently only supported in VHE mode.
-
 	  If unsure, say N.
=20
 config HYP_SUPPORTS_CFI_TEST
diff --git a/arch/arm64/kvm/hyp/vhe/cfi.c b/arch/arm64/kvm/hyp/cfi.c
similarity index 100%
rename from arch/arm64/kvm/hyp/vhe/cfi.c
rename to arch/arm64/kvm/hyp/cfi.c
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index 2eb915d8943f..09039d351726 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -25,6 +25,7 @@ hyp-obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o=
 tlb.o hyp-init.o host.o
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../en=
try.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+hyp-obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) +=3D ../cfi.o
 hyp-obj-$(CONFIG_LIST_HARDENED) +=3D list_debug.o
 hyp-obj-y +=3D $(lib-objs)
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index 2385fd03ed87..431860e8a98d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -5,6 +5,7 @@
  */
=20
 #include <hyp/adjust_pc.h>
+#include <hyp/cfi.h>
=20
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
@@ -13,6 +14,8 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
=20
+#include <linux/compiler.h>
+
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -314,6 +317,19 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_c=
ontext *host_ctxt)
 	cpu_reg(host_ctxt, 1) =3D __pkvm_teardown_vm(handle);
 }
=20
+#ifndef CONFIG_HYP_SUPPORTS_CFI_TEST
+__always_unused
+#endif
+static void handle___kvm_register_cfi_test_cb(struct kvm_cpu_context *host=
_ctxt)
+{
+	DECLARE_REG(phys_addr_t, cb_phys, host_ctxt, 1);
+	DECLARE_REG(bool, in_host_ctxt, host_ctxt, 2);
+
+	void (*cb)(void) =3D cb_phys ? __hyp_va(cb_phys) : NULL;
+
+	cpu_reg(host_ctxt, 1) =3D __kvm_register_cfi_test_cb(cb, in_host_ctxt);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -348,6 +364,9 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
+#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
+	HANDLE_FUNC(__kvm_register_cfi_test_cb),
+#endif
 };
=20
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index c50f8459e4fc..160311bf367b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -4,6 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
=20
+#include <hyp/cfi.h>
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
=20
@@ -253,6 +254,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	bool pmu_switch_needed;
 	u64 exit_code;
=20
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_host_ct=
xt_cfi))
+		hyp_test_host_ctxt_cfi();
+
 	/*
 	 * Having IRQs masked via PMR when entering the guest means the GIC
 	 * will not signal the CPU of interrupts of lower priority, and the
@@ -313,6 +317,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
=20
 	__debug_switch_to_guest(vcpu);
=20
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_guest_c=
txt_cfi))
+		hyp_test_guest_ctxt_cfi();
+
 	do {
 		/* Jump in the fire! */
 		exit_code =3D __guest_enter(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makef=
ile
index 19ca584cc21e..951c8c00a685 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -9,4 +9,4 @@ ccflags-y :=3D -D__KVM_VHE_HYPERVISOR__
 obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.=
o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
-obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) +=3D cfi.o
+obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) +=3D ../cfi.o
diff --git a/arch/arm64/kvm/hyp_cfi_test.c b/arch/arm64/kvm/hyp_cfi_test.c
index da7b25ca1b1f..6a02b43c45f6 100644
--- a/arch/arm64/kvm/hyp_cfi_test.c
+++ b/arch/arm64/kvm/hyp_cfi_test.c
@@ -6,6 +6,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_cfi.h>
 #include <asm/kvm_host.h>
+#include <asm/kvm_mmu.h>
 #include <asm/virt.h>
=20
 #include <linux/export.h>
@@ -15,29 +16,60 @@
 /* For calling directly into the VHE hypervisor; see <hyp/cfi.h>. */
 int __kvm_register_cfi_test_cb(void (*)(void), bool);
=20
-static int kvm_register_cfi_test_cb(void (*vhe_cb)(void), bool in_host_ctx=
t)
+static int kvm_register_nvhe_cfi_test_cb(void *cb, bool in_host_ctxt)
+{
+	extern void *kvm_nvhe_sym(hyp_test_host_ctxt_cfi);
+	extern void *kvm_nvhe_sym(hyp_test_guest_ctxt_cfi);
+
+	if (is_protected_kvm_enabled()) {
+		phys_addr_t cb_phys =3D cb ? virt_to_phys(cb) : 0;
+
+		/* Use HVC as only the hyp can modify its callback pointers. */
+		return kvm_call_hyp_nvhe(__kvm_register_cfi_test_cb, cb_phys,
+					 in_host_ctxt);
+	}
+
+	/*
+	 * In non-protected nVHE, the pKVM HVC is not available but the
+	 * hyp callback pointers can be accessed and modified directly.
+	 */
+	if (cb)
+		cb =3D kern_hyp_va(kvm_ksym_ref(cb));
+
+	if (in_host_ctxt)
+		kvm_nvhe_sym(hyp_test_host_ctxt_cfi) =3D cb;
+	else
+		kvm_nvhe_sym(hyp_test_guest_ctxt_cfi) =3D cb;
+
+	return 0;
+}
+
+static int kvm_register_cfi_test_cb(void (*vhe_cb)(void), void *nvhe_cb,
+				    bool in_host_ctxt)
 {
 	if (!is_hyp_mode_available())
 		return -ENXIO;
=20
 	if (is_hyp_nvhe())
-		return -EOPNOTSUPP;
+		return kvm_register_nvhe_cfi_test_cb(nvhe_cb, in_host_ctxt);
=20
 	return __kvm_register_cfi_test_cb(vhe_cb, in_host_ctxt);
 }
=20
-int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void))
+int kvm_cfi_test_register_host_ctxt_cb(void (*vhe_cb)(void), void *nvhe_cb=
)
 {
-	return kvm_register_cfi_test_cb(cb, true);
+	return kvm_register_cfi_test_cb(vhe_cb, nvhe_cb, true);
 }
 EXPORT_SYMBOL(kvm_cfi_test_register_host_ctxt_cb);
=20
-int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void))
+int kvm_cfi_test_register_guest_ctxt_cb(void (*vhe_cb)(void), void *nvhe_c=
b)
 {
-	return kvm_register_cfi_test_cb(cb, false);
+	return kvm_register_cfi_test_cb(vhe_cb, nvhe_cb, false);
 }
 EXPORT_SYMBOL(kvm_cfi_test_register_guest_ctxt_cb);
=20
 /* Hypervisor callbacks for the test module to register. */
 EXPORT_SYMBOL(hyp_trigger_builtin_cfi_fault);
+EXPORT_SYMBOL(kvm_nvhe_sym(hyp_trigger_builtin_cfi_fault));
 EXPORT_SYMBOL(hyp_builtin_cfi_fault_target);
+EXPORT_SYMBOL(kvm_nvhe_sym(hyp_builtin_cfi_fault_target));
diff --git a/arch/arm64/kvm/hyp_cfi_test_module.c b/arch/arm64/kvm/hyp_cfi_=
test_module.c
index eeda4be4d3ef..63a5e99cb164 100644
--- a/arch/arm64/kvm/hyp_cfi_test_module.c
+++ b/arch/arm64/kvm/hyp_cfi_test_module.c
@@ -20,9 +20,9 @@ static int set_guest_mode(const char *val, const struct k=
ernel_param *kp);
 #define M_DESC \
 	"\n\t0: none" \
 	"\n\t1: built-in caller & built-in callee" \
-	"\n\t2: built-in caller & module callee" \
-	"\n\t3: module caller & built-in callee" \
-	"\n\t4: module caller & module callee"
+	"\n\t2: built-in caller & module callee (VHE only)" \
+	"\n\t3: module caller & built-in callee (VHE only)" \
+	"\n\t4: module caller & module callee (VHE only)"
=20
 static unsigned int host_mode;
 module_param_call(host, set_host_mode, param_get_uint, &host_mode, 0644);
@@ -40,7 +40,7 @@ static void hyp_cfi_module2module_test_target(int);
 static void hyp_cfi_builtin2module_test_target(int);
=20
 static int set_param_mode(const char *val, const struct kernel_param *kp,
-			 int (*register_cb)(void (*)(void)))
+			 int (*register_cb)(void (*)(void), void *))
 {
 	unsigned int *mode =3D kp->arg;
 	int err;
@@ -51,15 +51,17 @@ static int set_param_mode(const char *val, const struct=
 kernel_param *kp,
=20
 	switch (*mode) {
 	case 0:
-		return register_cb(NULL);
+		return register_cb(NULL, NULL);
 	case 1:
-		return register_cb(hyp_trigger_builtin_cfi_fault);
+		return register_cb(hyp_trigger_builtin_cfi_fault,
+				   kvm_nvhe_sym(hyp_trigger_builtin_cfi_fault));
 	case 2:
-		return register_cb((void *)hyp_cfi_builtin2module_test_target);
+		return register_cb((void *)hyp_cfi_builtin2module_test_target,
+				   NULL);
 	case 3:
-		return register_cb(trigger_module2builtin_cfi_fault);
+		return register_cb(trigger_module2builtin_cfi_fault, NULL);
 	case 4:
-		return register_cb(trigger_module2module_cfi_fault);
+		return register_cb(trigger_module2module_cfi_fault, NULL);
 	default:
 		return -EINVAL;
 	}
@@ -79,11 +81,11 @@ static void __exit exit_hyp_cfi_test(void)
 {
 	int err;
=20
-	err =3D kvm_cfi_test_register_host_ctxt_cb(NULL);
+	err =3D kvm_cfi_test_register_host_ctxt_cb(NULL, NULL);
 	if (err)
 		pr_err("Failed to unregister host context trigger: %d\n", err);
=20
-	err =3D kvm_cfi_test_register_guest_ctxt_cb(NULL);
+	err =3D kvm_cfi_test_register_guest_ctxt_cb(NULL, NULL);
 	if (err)
 		pr_err("Failed to unregister guest context trigger: %d\n", err);
 }
--=20
2.45.0.118.g7fe29c98d7-goog

