Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345D6180A99
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984876; cv=none; b=XyHxiN/tB21N9EHG/R2lsPMsnw7ud7nqmB49tnCXmlhMJ7iLIzN1fd5jmbbnykYz6IITwTZpzsRjuMpuIX3atMPLlm/L0jW3k9yg1QhIHJQf8VakP7It5z3aNFsXgEwQiWdlvJeaL6UVmEvwvSbmI++WdjiEno9y75n7DESSzKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984876; c=relaxed/simple;
	bh=BRujChrM4VFfYrpRS71aJErzF3wII2UsmVJlHzt0Ypw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ed+88tbz7cPDgUIQpXirFe2CMhI4N7K/7L73ZSbP9i5WPkGxqQrsHTGxyN7hFUDDuq3ioJwQ5T8h8qL35INxG2PL0cSGzRqTZrEC+KD3w+extX0BmOOszf+lkj/KZ/WRlhwgRjMoHsg1k4mKdqpa6u/rvRzwgdhkt1DL9ZW6SeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i9RY3qi0; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i9RY3qi0"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-579d2279abaso882353a12.3
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984873; x=1717589673; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tLmL1So5x4FnLH0kyn2ty29vEdym4EM/KIgVNMwbuEQ=;
        b=i9RY3qi0/gvad0hhRRLwiXWceCzIVAqSGekuxAD1jjFrDy/RiE+eeATS/U8EiZFPT/
         iRkP6PjsVgfbvZtNqcUkAmE1gYDPtCr9DsJXEACoJYtBjx3ctCSoJ8gyu2oJEdijNuO5
         c2XPKdzdFbfif4R9B+qPMpCkp1zJnxz0yziV7cMNBi4LE8jCqJP79q3aCkWAqi3Vka3D
         W9kzSErFISWY7hd60O59gAHyp1UtgO4FOqqVJzqUSZ/3xVL7OJu3vFDFL14l2eSVJdZH
         iYnaWMWjksf3nfhOfPAhb9Hb+gOJ9VaM6DeHh3hp2yKFgPflORZS5BCiiqJAMVCBK3aJ
         VkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984873; x=1717589673;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tLmL1So5x4FnLH0kyn2ty29vEdym4EM/KIgVNMwbuEQ=;
        b=cpHMjZb2ZKnscMLMsY9d6Lk4HixODgRpQ0d29Z+8cC0I/gYUVaXImYrMzaoNnAmMAM
         FOXMaMULLpARLEmR5eHTDzRCwUND+XeOJhaYlmkpf41khEf1VCAqtG1g5s2M5U5dI4U9
         Cwcpm53dpRJh7PmpxAKN4laB1sV/Fq+stdOWZig6ye+WP4BlFv0/Wevpa37CILFMaeUn
         OI11GaUpgwCSMIcxFm2OD6mAmiyXNLdYnAXNzeY23zz3JbT20KuS3+IFUPvygtdpqVy2
         2WtigzYBo3eOKwKvoKpbQIe4VmpQh6alQSCKHzCZSFiXsKkHmKfYmM/QHjwsJbh68hu3
         I8Hg==
X-Gm-Message-State: AOJu0Yw4adTpL/56luoAkUsNOcETyCczSV1+J0X8FALmJtnk8+CgjtlE
	+mxChjTarzob1LC/HhQ7FatxrCZVs1COyBSitCTcXFWwSIFNA0My51Zx2A8UHyqjGovwL9y2xrr
	LArd8/kq9c/n02/4WYvUOZSFgXBQvlhx7SjZO3ukmyX/sA7/NrJDqRF4K6e/MJwnqRxIDH2u5d+
	M05Y9fvpi58kIUgZf1Hp6pScSk4fQ=
X-Google-Smtp-Source: AGHT+IFoWb2krclv9TkDbcARu8wLLSDlMlxLJgD2KUqfjrU7i3St1EL1/OV74yeBjy7fXa7WBSwaGQ6E2A==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:3223:b0:572:6e36:f0f7 with SMTP id
 4fb4d7f45d1cf-578519bbf75mr18449a12.6.1716984873520; Wed, 29 May 2024
 05:14:33 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:08 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-3-ptosi@google.com>
Subject: [PATCH v4 02/13] KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fix the mismatch between the (incorrect) C signature, C call site, and
asm implementation by aligning all three on an API passing the
parameters (pgd and SP) separately, instead of as a bundled struct.

Remove the now unnecessary memory accesses while the MMU is off from the
asm, which simplifies the C caller (as it does not need to convert a VA
struct pointer to PA) and makes the code slightly more robust by
offsetting the struct fields from C and properly expressing the call to
the C compiler (e.g. type checker and kCFI).

Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL=
2")
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  3 +--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 17 +++++++++--------
 arch/arm64/kvm/hyp/nvhe/setup.c    |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 3e80464f8953..58b5a2b14d88 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *=
host_ctxt, u64 spsr,
 #endif
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
-			    phys_addr_t pgd, void *sp, void *cont_fn);
+void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/h=
yp-init.S
index 2994878d68ea..d859c4de06b6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -265,33 +265,34 @@ alternative_else_nop_endif
=20
 SYM_CODE_END(__kvm_handle_stub_hvc)
=20
+/*
+ * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void)=
);
+ */
 SYM_FUNC_START(__pkvm_init_switch_pgd)
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
-	mrs	x2, sctlr_el2
-	bic	x3, x2, #SCTLR_ELx_M
+	mrs	x9, sctlr_el2
+	bic	x3, x9, #SCTLR_ELx_M
 	msr	sctlr_el2, x3
 	isb
=20
 	tlbi	alle2
=20
 	/* Install the new pgtables */
-	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x4, x3
+	phys_to_ttbr x4, x0
 alternative_if ARM64_HAS_CNP
 	orr	x4, x4, #TTBR_CNP_BIT
 alternative_else_nop_endif
 	msr	ttbr0_el2, x4
=20
 	/* Set the new stack pointer */
-	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
-	mov	sp, x0
+	mov	sp, x1
=20
 	/* And turn the MMU back on! */
 	dsb	nsh
 	isb
-	set_sctlr_el2	x2
-	ret	x1
+	set_sctlr_el2	x9
+	ret	x2
 SYM_FUNC_END(__pkvm_init_switch_pgd)
=20
 	.popsection
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setu=
p.c
index 859f22f754d3..1cbd2c78f7a1 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, u=
nsigned long nr_cpus,
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt =3D hyp_phys_to_virt(phys);
-	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
+	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
=20
 	BUG_ON(kvm_check_pvm_sysreg_table());
@@ -340,7 +340,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, u=
nsigned long nr_cpus,
 	/* Jump in the idmap page to switch to the new page-tables */
 	params =3D this_cpu_ptr(&kvm_init_params);
 	fn =3D (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
-	fn(__hyp_pa(params), __pkvm_init_finalise);
+	fn(params->pgd_pa, (void *)params->stack_hyp_va, __pkvm_init_finalise);
=20
 	unreachable();
 }
--=20
2.45.1.288.g0e0cd299f1-goog

