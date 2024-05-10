Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585DE171E69
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340448; cv=none; b=dsNjGzq9+M72o/5zxBe7enrcAmfogfjW2f7FreIkbr922o3J3AjcoG1+3I5axY6/Uw7573znCAGKCdTaJ4ZxJOyuBJeB7Gp5MWbBtmaigslwh+kWViFZXPu6u7KlMdT03Afq7gKXGf+wibAIE/kM4g+Z0rpRDc062xyzNai/07Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340448; c=relaxed/simple;
	bh=FqP+W3H7ODA8nGAmitghr0+uUjjfekAcblOIn5trRhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IIvniinl7WFBlZGZNlBHEgUlKOFigrdC/cpUKsMS1KJGpcVczkXlquStIW3P7dZvJHJrCkFCIZ/+5vkin6dpsq6isUFCW1gsiXQSyap/w7iIMd1ca3dvcrJdmNE1yMEDHrOYf0frsN7UaXXSIDnYZE9Mk+3qnhxP3zSfn1x4COY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JuIipQ0q; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JuIipQ0q"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6207c483342so31798507b3.1
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340445; x=1715945245; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1X74EzIbLgwkSZ3RCE9vimfqgbYyFErrsdDhyQP2Whk=;
        b=JuIipQ0qMO7XAv0ot/yB1Qh0uVNT4ytYglBXXWKUOAcsdAB5dcAHe6gAljI30ukozK
         dYP0fIhQX1rq4DMbrXxs5E8xcwhNxu8IaQzWEoTDFkpCoNviMttx1sfar5nYob3ouytW
         dHE0+6VPm1m16vHC/raO433ORkVjqVB8hVdkDWRMSTp2h4DjPCnmsRhUEAWyPSi5oM16
         nFDVwVmqWZOuzesYTgzCtnG+xeff/mmg7LfYTKlPs2qBvlKTS++xN6Vthx7ATJ1U8BNY
         ULiKW0vVp5hQsK8hpFrMELQazVMBESB14FRIaKjsPMhNb6udEuEYG39H8JXhSrsVKp5T
         1sAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340445; x=1715945245;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1X74EzIbLgwkSZ3RCE9vimfqgbYyFErrsdDhyQP2Whk=;
        b=T9mQgVlP7ZbzwlK4PHKIurL4E+5xXM8SYQGKOcED6Dqhlf9QzLR1rKygiuE78PROpA
         H9mnBxOIWrQariXMjkRYn0ZhZXJDu30wdVelR6JQgu4XihPDdjbiy14loLeWSwlaomIf
         mW6TFOJFJWTj0gYsZ8it2WagsEnpiJSuwlkZOgI9VlLLoW5MHBtopBzRnkMFBT7PFp7N
         uItOS2aL4llvcK8D7JTw5WsZ+KPsVzQXByIxpV6L/Ki0cjndY5NFE5rqzsS8e66L52sn
         3y3jSUZ4VZAGzFHJHECjHHsh5TiwFoum18QnwpX0y6yu4nRl32rK1qVBxcwBWzSaW7W5
         pL+Q==
X-Gm-Message-State: AOJu0YyCRxv3rgJTqDAEdtb6b0mgFtwI9YUWXcP+MvTL0khE2Cm35UKO
	4yB+YGkO+trMV0/DN67PLuxymj7OpzCjFdopvBff24xC3O9UglTZGfbF26w8cXjXHC5JREA6CoR
	iZgVu0dr0bZDQNCJ5FSd9ytn/wIgWKjlWVsYDEk+lbNnBPL74Qs93pXoiqW9OF8t4Z+wCaj+Rd2
	6oo3aB8go9B00o8N+1qJfq3jg4ikU=
X-Google-Smtp-Source: AGHT+IE2vI8V+31DiouhAYXxHwv2C3egPY5JlN+7fyVhlwS8yXv78dpY0cirHvo9+5p4Wx/GqO7X9Ryw0g==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:2b88:b0:dcd:3172:7265 with SMTP id
 3f1490d57ef6-dee4f3036e5mr593281276.8.1715340445332; Fri, 10 May 2024
 04:27:25 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:32 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-4-ptosi@google.com>
Subject: [PATCH v3 03/12] KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Make the function take a VA pointer, instead of a phys_addr_t, to fully
take advantage of the high-level C language and its type checker.

Perform all accesses to the kvm_nvhe_init_params before disabling the
MMU, removing the need to access it using physical addresses, which was
the reason for taking a phys_addr_t.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 12 +++++++++---
 arch/arm64/kvm/hyp/nvhe/setup.c    |  4 +---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 96daf7cf6802..c195e71d0746 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,7 +123,8 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *=
host_ctxt, u64 spsr,
 #endif
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void))=
;
+void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
+			    void (*finalize_fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/h=
yp-init.S
index 2994878d68ea..5a15737b4233 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -265,7 +265,15 @@ alternative_else_nop_endif
=20
 SYM_CODE_END(__kvm_handle_stub_hvc)
=20
+/*
+ * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
+ *                             void (*finalize_fn)(void));
+ */
 SYM_FUNC_START(__pkvm_init_switch_pgd)
+	/* Load the inputs from the VA pointer before turning the MMU off */
+	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
+	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
+
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
 	mrs	x2, sctlr_el2
@@ -276,15 +284,13 @@ SYM_FUNC_START(__pkvm_init_switch_pgd)
 	tlbi	alle2
=20
 	/* Install the new pgtables */
-	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x4, x3
+	phys_to_ttbr x4, x5
 alternative_if ARM64_HAS_CNP
 	orr	x4, x4, #TTBR_CNP_BIT
 alternative_else_nop_endif
 	msr	ttbr0_el2, x4
=20
 	/* Set the new stack pointer */
-	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
 	mov	sp, x0
=20
 	/* And turn the MMU back on! */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setu=
p.c
index bcaeb0fafd2d..45b83f3ed012 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -314,7 +314,6 @@ void __noreturn __pkvm_init_finalise(void)
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits)
 {
-	struct kvm_nvhe_init_params *params;
 	void *virt =3D hyp_phys_to_virt(phys);
 	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
@@ -338,9 +337,8 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, u=
nsigned long nr_cpus,
 	update_nvhe_init_params();
=20
 	/* Jump in the idmap page to switch to the new page-tables */
-	params =3D this_cpu_ptr(&kvm_init_params);
 	fn =3D (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
-	fn(__hyp_pa(params), __pkvm_init_finalise);
+	fn(this_cpu_ptr(&kvm_init_params), __pkvm_init_finalise);
=20
 	unreachable();
 }
--=20
2.45.0.118.g7fe29c98d7-goog

