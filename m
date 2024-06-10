Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54AD1C6AF
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 06:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001188; cv=none; b=tvRNpkEsIFQC1GG1Lul7g9YNWfl55ztgpr0PDgiTu0diaLECnMUjQKx7+AO1ErQB7EUnY6JfB+SfP2MgQgyQ49sO2MypaocegW/c+//rF/oviL5223HvuO461bSUTxQL6+fwZng+QXePrd5L+hbCRautX+C3VRY7WV61+9uH21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001188; c=relaxed/simple;
	bh=qt+pTMWO2R3fLlL4+WTmu4miWiSr41X+81Bu/pRbJ7Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZY/v1CfbsVWHAqIEQd25Z38BjexIGLu96ihxMYMqyPqZ4VNAxb2l3+U4ndmUo8zYnk7alGMr3KJK2l0jlmHEjk99HWQ/pjS7caupChdTO/ZikJlfWGGhteOrkGig1KDGR9kte1jN3sI+8/J7Oty+MK99rca1c945YV4STYvIE24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qs70TPoa; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qs70TPoa"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62ca03fc1ceso74833697b3.1
        for <kvmarm@lists.linux.dev>; Sun, 09 Jun 2024 23:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001186; x=1718605986; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ev2HO0qDfqZpObOP/EpmEGn4LzOsyqIcz+fCTzlf7nU=;
        b=Qs70TPoaxwSi1SD+ArgErh+GHrYpmySMKaNEGiT/y7up/7vGZjmHuw28DmGyWYMa7i
         /jM00H5yzg9k5EcxoNGURtcd1GBHjfU2Jq8gs5jd6D5by3QJCvV6MwMAD6jA+hJdYT21
         81K2ND8vlq03cJwe0hL9aFlpzLS5wI+DPKxDFzT4HWGf7aFg0PGoZ3C8XDNU2nylOCqt
         2I1Kz6HMOOW9cUVs3IY3raiin0/bwvxlpmZZLCRJMoM6ptOUDUEeu8P3Zf/1/8ZZYvmM
         6k73NLdQHoRJZu72cqKhfWWhBQwz4efRFjj2vHm2BZ8pJQSLwMC45WfwW2sRqjzXLLmz
         dm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001186; x=1718605986;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ev2HO0qDfqZpObOP/EpmEGn4LzOsyqIcz+fCTzlf7nU=;
        b=MkjpX1uYllJirWZhRR56L3VJXJTzGwYIdq9IweigO6wtd1Vr6c0M3zwoQOTGeWh/2Y
         fhWi87QP3kEcOi5GjfsVaOc+w6FStDBfomgHN9FKEQe40bRfcxzBhRdES0zXcskcToN0
         9Ht4P/YHeGOiFIjfvoKgLapCBjFB606V8lBzoKYza4zrcNSm+mkR6OsczFZJwN+92FUi
         EKRuFOF0XhaJL3MU9+s5oz+R3QTVglw+vApLFH/k34BmlYirSZtIk2aowTYrri9cp3Iw
         mZO41vJ/9C6P+gPWagjSPrNji7iuzgCNFSrvT5tSliFkEPePLCF64Jt6tmQ3mEy/SWeL
         /sIA==
X-Gm-Message-State: AOJu0YxthYaStg5Kppk7p4AFwcVCFte89cdLAk4A9cLMG0rYOT0I5+SU
	OMzl9NHIE2OQ5HyznK0HghNIZeO1eLvRW1tNu27oYU8V8Tuq/mQHm+9uCEe1xEJz6eHTd0g34vZ
	ikWIuBdvcvuPwQ2wji8pCWHaKxHzvsX1BUpzzYLaKqjd6+Mo7pkdVdGGWUFSw+WZjl+/PohzspX
	L5bA9thwBwyzInsXYnZF4hroSruws=
X-Google-Smtp-Source: AGHT+IEwLr9O/yeoTB9Cb8xFfViewwFIQ4AayrMhr4eyJthDmUi3ELBBv/heAruNMSP2LyWXM5aKCg7P4Q==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:690c:640d:b0:62c:f7e2:fc4e with SMTP id
 00721157ae682-62cf7e3002dmr13313137b3.2.1718001185803; Sun, 09 Jun 2024
 23:33:05 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:31 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-3-ptosi@google.com>
Subject: [PATCH v5 2/8] KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
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
 arch/arm64/include/asm/kvm_hyp.h   |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 24 +++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/setup.c    |  4 ++--
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 3e80464f8953..181e10e2575b 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,8 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *=
host_ctxt, u64 spsr,
 #endif
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
-			    phys_addr_t pgd, void *sp, void *cont_fn);
+void __pkvm_init_switch_pgd(phys_addr_t pgd, unsigned long sp,
+		void (*fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/h=
yp-init.S
index 2994878d68ea..3a2836a52e85 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -265,33 +265,35 @@ alternative_else_nop_endif
=20
 SYM_CODE_END(__kvm_handle_stub_hvc)
=20
+/*
+ * void __pkvm_init_switch_pgd(phys_addr_t pgd, unsigned long sp,
+ *                             void (*fn)(void));
+ */
 SYM_FUNC_START(__pkvm_init_switch_pgd)
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
-	mrs	x2, sctlr_el2
-	bic	x3, x2, #SCTLR_ELx_M
-	msr	sctlr_el2, x3
+	mrs	x3, sctlr_el2
+	bic	x4, x3, #SCTLR_ELx_M
+	msr	sctlr_el2, x4
 	isb
=20
 	tlbi	alle2
=20
 	/* Install the new pgtables */
-	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x4, x3
+	phys_to_ttbr x5, x0
 alternative_if ARM64_HAS_CNP
-	orr	x4, x4, #TTBR_CNP_BIT
+	orr	x5, x5, #TTBR_CNP_BIT
 alternative_else_nop_endif
-	msr	ttbr0_el2, x4
+	msr	ttbr0_el2, x5
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
+	set_sctlr_el2	x3
+	ret	x2
 SYM_FUNC_END(__pkvm_init_switch_pgd)
=20
 	.popsection
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setu=
p.c
index 859f22f754d3..598f688b678f 100644
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
+	fn(params->pgd_pa, params->stack_hyp_va, __pkvm_init_finalise);
=20
 	unreachable();
 }
--=20
2.45.2.505.gda0bf45e8d-goog

