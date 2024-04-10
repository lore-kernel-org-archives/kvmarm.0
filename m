Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F91413D886
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 08:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737714; cv=none; b=A5O7YM8ye12k+h9epaQ/+qmxZIu8dM1Bjkfau2WNd4auMfYKIViTTHs8PvjhIobUNR1B2ZcT4iITrDU/A6hA8jKvUXbDGyMVdJ2AhwIrPBHNYBVaLV8MCPUKLoVWmhIQoaQhVgZiddqhY81u2oX5pKd6tzuMqGnhmPK8KF6CgeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737714; c=relaxed/simple;
	bh=hQbIAYxCN7AHKx4jWK0xjI+853X8oj81NzdgGm0O5U0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Za1a1HrUkF0dYVDS5DIeqJH6FskPJipNYAQQ2NrmvlEcCSts//AD/h0k8uRNngOCJKBVrTRiUgikIyjowZhDTRJkE22lF+9MPtR/GTck8Q18IeL1cSqiabIbKSLCgx8xVVcHKVho3Ugqy7ib/9Zjy7QZ8koQ+lx7adn97wIVJ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kofVO+0X; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kofVO+0X"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56fc155b646so368914a12.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 01:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737710; x=1713342510; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxLIFexzyxIK5HPZLQRBUNaNzamUF5S8ye0TLbRuvBI=;
        b=kofVO+0XZfQvPYSmX3sHBBG0FEOE6cPxoO5x+CQo+Udi10D/nSB92EaIgf0ScapX/4
         WuTs6w41ayG61iBmhz0bWtCwp9m4Zq8YKW8iIXBhUHB1OqX8nD5e8XDfhgfy+iyZKKvV
         H0KiyLb38zQcRGn3f8a0U3KXnim9omTYuamRWvaWS11my3SUffk+jqnUwIQoZGdypSb/
         uJ2O+yTYOsrNDimCK3+NkKg/REM5PwL0uT2nJnoFrLsPsvl77UHg+1HRQn9IEQwlxqSX
         f29DhXP64JhR/+iZarz8TQdUkkemooIydp9RkNt9Li9cAiHtSLPMeq9Bv1ZQ29hcrYMF
         sEKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737710; x=1713342510;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qxLIFexzyxIK5HPZLQRBUNaNzamUF5S8ye0TLbRuvBI=;
        b=KE5rrEepiJBM6MVW8haNpLjFT3wtZVJnu1Cu1Ioq/6DoW36PsJbqEeOHV6N16y2ukK
         mpm9GYlaJw0QpNdl9nnN5UY2d4N1tvekAh/2ehEVqzce/ebP54TZUjsnBLXdeBTN+Rgp
         +aLdiPa0NURnDG1vx++8y3xA+4n59PpxznaBdJRAzsZdoBn9FS/VVSibP4HVSxUpjpbq
         faUgc7vKm6hBjbUZRzPyLeyA/E+lZ36wS9kDzYaqqM66RB8xrSwZee/U7Ai3O2C8leNO
         3+FVMNhnz3B+X7v/D4pwZRS/hTzXQBlSt0zVJV5nT4+CxvBFYOboFyYTNlYafLtNar9n
         UEYw==
X-Gm-Message-State: AOJu0Yw7hU0mBgEOGyiOe7/AQtFcP5d8rXD/ly1BssnCLuPSgBjR6xvF
	gJ0k+0Rap92nklm09VNz+1pUA4oodlQjOtemQJm/0zmu++xYrmDxOS443fvTkyuI3uMgxdoR+C3
	vmQ==
X-Google-Smtp-Source: AGHT+IGsWsU9bAzX/IPEjmB8SimXIKLnvmyxzGnMrYTatjRSIELLqQwhMG790NNumW8RkBeRsXi0+A==
X-Received: by 2002:a50:9ee9:0:b0:56e:418:5559 with SMTP id a96-20020a509ee9000000b0056e04185559mr1277972edf.3.1712737710569;
        Wed, 10 Apr 2024 01:28:30 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id q3-20020a056402248300b0056bfca6f1c0sm6154174eda.15.2024.04.10.01.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:28:30 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:28:26 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 03/12] KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
Message-ID: <k6esb27sx5foezwon2iaywkuh3i7w4xyzosyadf2f27fqujxed@6yzo5gtae2xf>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Make the function take a VA pointer, instead of a phys_addr_t, to fully
take advantage of the high-level C language and its type checker.

Perform all accesses to the kvm_nvhe_init_params before disabling the
MMU, removing the need to access it using physical addresses, which was
the reason for taking a phys_addr_t.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 12 +++++++++---
 arch/arm64/kvm/hyp/nvhe/setup.c    |  4 +---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 96daf7cf6802..c195e71d0746 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,7 +123,8 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void));
+void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
+			    void (*finalize_fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 2994878d68ea..5a15737b4233 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -265,7 +265,15 @@ alternative_else_nop_endif
 
 SYM_CODE_END(__kvm_handle_stub_hvc)
 
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
 
 	/* Install the new pgtables */
-	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x4, x3
+	phys_to_ttbr x4, x5
 alternative_if ARM64_HAS_CNP
 	orr	x4, x4, #TTBR_CNP_BIT
 alternative_else_nop_endif
 	msr	ttbr0_el2, x4
 
 	/* Set the new stack pointer */
-	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
 	mov	sp, x0
 
 	/* And turn the MMU back on! */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bcaeb0fafd2d..45b83f3ed012 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -314,7 +314,6 @@ void __noreturn __pkvm_init_finalise(void)
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		unsigned long *per_cpu_base, u32 hyp_va_bits)
 {
-	struct kvm_nvhe_init_params *params;
 	void *virt = hyp_phys_to_virt(phys);
 	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
@@ -338,9 +337,8 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 	update_nvhe_init_params();
 
 	/* Jump in the idmap page to switch to the new page-tables */
-	params = this_cpu_ptr(&kvm_init_params);
 	fn = (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
-	fn(__hyp_pa(params), __pkvm_init_finalise);
+	fn(this_cpu_ptr(&kvm_init_params), __pkvm_init_finalise);
 
 	unreachable();
 }
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre
