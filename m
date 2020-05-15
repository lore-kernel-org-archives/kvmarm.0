Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7981AC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 15:21:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E92B120671
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 15:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="GryLZYNy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E92B120671
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45F204B4A3;
	Fri, 15 May 2020 11:21:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CFmpfjR7CnlT; Fri, 15 May 2020 11:21:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA254B4A6;
	Fri, 15 May 2020 11:21:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E0DE4B4A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 11:21:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yUbxxUj1Mgag for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 11:21:12 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC3E94B4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 11:21:11 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id g12so3085554wmh.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 08:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=KntePsrJZ38aKzkA7fo6Gtvi3PLH/oa0OGyHRz0Swos=;
 b=GryLZYNyhp8AzuS9c+B+Fla5RgxNoznfaARAc+BvFqZdeTPhy+4/qMPC4nrBUl9EN3
 OL391QH3tWSy32IaVeN0tLkNc4bTAJjRc8rPd0JdDb06VGw0tVADy6df+OQ3zxvkaPlE
 l/94aMlwdh2EH2Pld8OSdy6KWSY4mkzaheiktwyqSMLpMUiNcSZH9WmBd8tPSAsYlT9E
 taOCiQqdHs4kQhiOlHIgaZynKqM5QJjuCM09qYcuXNntogkawPsmtfAm3Cqh1srwuxsT
 fusGJmI++1YbjwxxgBIGeULct6h5TRgpt2lEN9+OumlSXKR2mjO3nnwKORtvX0bWDQdr
 XGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=KntePsrJZ38aKzkA7fo6Gtvi3PLH/oa0OGyHRz0Swos=;
 b=fVCM3ePn/3duUFTKFSKQdS2TnTME5GOAiH0i9YkSKHVI+GW0nHfzJJD/ttB1P8QHVv
 Ut2IpzOWGKQEdlW9N5pmgzvZPgoWOqg3kHra/mHugWgMLEqUEQo/RuM2A0SUgWTmvdvR
 hjZQfPxKqfCDUrDnlTXZMNyqXhfosfISg+dwWB+JLUDbSxKxAQN1eqW1p27XjrvImqUd
 ILG+zvOHj65P+qG2Jd8BHHFFUKoettUo/mD/xgA03OG3Qvq5pKuR8OKUteS/abOtwuvm
 kYxlXjFS1BPd+lwLAow+4wNR0ATn+DvLx7zGRVLKT5/IUSS+ctuPpAKeOzvkDQXAPBIO
 Vodw==
X-Gm-Message-State: AOAM533eWo3pkLOqGGnq2CHypUEzlQouZ/8vmraWGi2VaYHlR7cQ3h+O
 ZnpV9vos2SxAB3OM9D5j06Xjmg==
X-Google-Smtp-Source: ABdhPJzeS1z51N03Nf21V4FTTxjRFhNkpfq9OsfOx5e2wEnllfq0XS/Kck/v3gGLtKn0ZWv3U3HCfw==
X-Received: by 2002:a1c:5fd4:: with SMTP id t203mr4727738wmb.175.1589556070468; 
 Fri, 15 May 2020 08:21:10 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id h137sm56341596wme.0.2020.05.15.08.21.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 08:21:09 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] arm64: kvm: Clean up cpu_init_hyp_mode()
Date: Fri, 15 May 2020 16:20:56 +0100
Message-Id: <20200515152056.83158-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Pull bits of code to the only place where it is used. Remove empty function
__cpu_init_stage2(). Remove redundant has_vhe() check since this function is
nVHE-only. No functional changes intended.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  |  2 ++
 arch/arm64/include/asm/kvm_host.h | 35 -------------------------------
 arch/arm64/kvm/arm.c              | 32 +++++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 59e314f38e43..0c9b5fc4ba0a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -70,6 +70,8 @@ extern int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu);
 
 extern int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu);
 
+extern void __kvm_enable_ssbs(void);
+
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
 extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a723f84fab83..69a338a390a6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -533,39 +533,6 @@ static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 	cpu_ctxt->sys_regs[MPIDR_EL1] = read_cpuid_mpidr();
 }
 
-void __kvm_enable_ssbs(void);
-
-static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
-				       unsigned long hyp_stack_ptr,
-				       unsigned long vector_ptr)
-{
-	/*
-	 * Calculate the raw per-cpu offset without a translation from the
-	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
-	 * so that we can use adr_l to access per-cpu variables in EL2.
-	 */
-	u64 tpidr_el2 = ((u64)this_cpu_ptr(&kvm_host_data) -
-			 (u64)kvm_ksym_ref(kvm_host_data));
-
-	/*
-	 * Call initialization code, and switch to the full blown HYP code.
-	 * If the cpucaps haven't been finalized yet, something has gone very
-	 * wrong, and hyp will crash and burn when it uses any
-	 * cpus_have_const_cap() wrapper.
-	 */
-	BUG_ON(!system_capabilities_finalized());
-	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
-
-	/*
-	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
-	 * at EL2.
-	 */
-	if (!has_vhe() && this_cpu_has_cap(ARM64_SSBS) &&
-	    arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE) {
-		kvm_call_hyp(__kvm_enable_ssbs);
-	}
-}
-
 static inline bool kvm_arch_requires_vhe(void)
 {
 	/*
@@ -601,8 +568,6 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
-static inline void __cpu_init_stage2(void) {}
-
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e01d44df98df..b0b569f2cdd0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1273,19 +1273,41 @@ static void cpu_init_hyp_mode(void)
 {
 	phys_addr_t pgd_ptr;
 	unsigned long hyp_stack_ptr;
-	unsigned long stack_page;
 	unsigned long vector_ptr;
+	unsigned long tpidr_el2;
 
 	/* Switch from the HYP stub to our own HYP init vector */
 	__hyp_set_vectors(kvm_get_idmap_vector());
 
+	/*
+	 * Calculate the raw per-cpu offset without a translation from the
+	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
+	 * so that we can use adr_l to access per-cpu variables in EL2.
+	 */
+	tpidr_el2 = ((unsigned long)this_cpu_ptr(&kvm_host_data) -
+		     (unsigned long)kvm_ksym_ref(kvm_host_data));
+
 	pgd_ptr = kvm_mmu_get_httbr();
-	stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
-	hyp_stack_ptr = stack_page + PAGE_SIZE;
+	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
 	vector_ptr = (unsigned long)kvm_get_hyp_vector();
 
-	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
-	__cpu_init_stage2();
+	/*
+	 * Call initialization code, and switch to the full blown HYP code.
+	 * If the cpucaps haven't been finalized yet, something has gone very
+	 * wrong, and hyp will crash and burn when it uses any
+	 * cpus_have_const_cap() wrapper.
+	 */
+	BUG_ON(!system_capabilities_finalized());
+	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
+
+	/*
+	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
+	 * at EL2.
+	 */
+	if (this_cpu_has_cap(ARM64_SSBS) &&
+	    arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE) {
+		kvm_call_hyp(__kvm_enable_ssbs);
+	}
 }
 
 static void cpu_hyp_reset(void)
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
