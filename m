Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD96C71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88C69221FA
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88C69221FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2647A4B424;
	Wed,  2 Dec 2020 13:41:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bSXMZo3QBLIw; Wed,  2 Dec 2020 13:41:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2CD84B436;
	Wed,  2 Dec 2020 13:41:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A19C04B333
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NO-+hOUy2HZa for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:41:53 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 563F74B31D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:53 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id t4so5091379wrr.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=SYG0eeQv/KzkRV71YTMJbmdpg/6//a3ujvezKDQIbk8=;
 b=I6qPvyU/FEX7FoJaBAPoMr8c0thpJsMeXHt3MTW4C/mlzQSsWMAIep+7zln0pouZ69
 oSIqQIHhphrOpyf9KrtyyKVpZ9ws63s0hMyFc+TmZV9P0M0reBlv34xK9/mgCDapBvZ2
 HBRTDBpFTKJ2JHroGfWfnXTwvM09Kp5Vt2NzgcNYSoe4gOQvAxueMU4QmxSgQirMH/CQ
 vfnDSWQq6MXCHPHO+j9hsFHgxgyms8RJGLjJecLRktMuO1/ofiirUVZM614qboCwTRuF
 q9kPFpqy5ZGaltgubW7eWPEk+L44OIsBifxsw8vU4w66d+3q7Z8ZlWArOrfUwJX0PPZV
 neWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=SYG0eeQv/KzkRV71YTMJbmdpg/6//a3ujvezKDQIbk8=;
 b=W/UfZKYXQ605GGe86bIpx2nLEZupTGDOsjkYrtbc3uckUa5a+Zkm6kG6+jcYkI86j0
 FhmCfRcWTdMyUT947j2HUeRNZ1ZixHKN2eeZQKMOhMIs8ssaR5G3+xz4Bp0xdLoatwtf
 6wgHWdVXuTX1DbGXh1FWJEVFwu8J2WVX6iWRdONwNTgGKnVCxBt7b9Q0eWlo04itqiAc
 +zjIy8kjcdc18Yn85gUvfPgpRRVxhRBR6bl5YNnRt6g4S/g8NPT2BeoX90Od9UPqnoM2
 5Pn9Jie1M7idO32XOiqzc2TqB0EUSySlk0F0zVLLrs7I8ErHelocFhru+IzkW8c+4YN3
 qA8Q==
X-Gm-Message-State: AOAM531joRZLPSa/q3ZDAhVJQNrfLaYAfwKQ0GOGyOzRaQIODj08aW7x
 H7HEb3h9/crxxxOKajyDTQBPaE+Ej2a/Zg==
X-Google-Smtp-Source: ABdhPJzQ4njSIdl4L+IWqJBBxyUMLi1VeNNJl71IrmZZYtKGG+ycdDeDDGy/czwUB2v1OUbzSwBadg==
X-Received: by 2002:adf:f8d2:: with SMTP id f18mr4955628wrq.379.1606934511842; 
 Wed, 02 Dec 2020 10:41:51 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id l14sm2962159wmi.33.2020.12.02.10.41.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:50 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 11/26] kvm: arm64: Init MAIR/TCR_EL2 from params struct
Date: Wed,  2 Dec 2020 18:41:07 +0000
Message-Id: <20201202184122.26046-12-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

MAIR_EL2 and TCR_EL2 are currently initialized from their _EL1 values.
This will not work once KVM starts intercepting PSCI ON/SUSPEND SMCs
and initializing EL2 state before EL1 state.

Obtain the EL1 values during KVM init and store them in the init params
struct. The struct will stay in memory and can be used when booting new
cores.

Take the opportunity to move copying the T0SZ value from idmap_t0sz in
KVM init rather than in .hyp.idmap.text. This avoids the need for the
idmap_t0sz symbol alias.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/kernel/asm-offsets.c    |  2 ++
 arch/arm64/kernel/image-vars.h     |  3 ---
 arch/arm64/kvm/arm.c               | 22 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 38 +++++++-----------------------
 5 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 1a7b91534a16..7ccf770c53d9 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -149,6 +149,8 @@ extern void *__vhe_undefined_symbol;
 #endif
 
 struct kvm_nvhe_init_params {
+	unsigned long mair_el2;
+	unsigned long tcr_el2;
 	unsigned long tpidr_el2;
 	unsigned long stack_hyp_va;
 	phys_addr_t pgd_pa;
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 8d6272a01a00..ba01185ef281 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -110,6 +110,8 @@ int main(void)
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
+  DEFINE(NVHE_INIT_MAIR_EL2,	offsetof(struct kvm_nvhe_init_params, mair_el2));
+  DEFINE(NVHE_INIT_TCR_EL2,	offsetof(struct kvm_nvhe_init_params, tcr_el2));
   DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
   DEFINE(NVHE_INIT_STACK_HYP_VA,	offsetof(struct kvm_nvhe_init_params, stack_hyp_va));
   DEFINE(NVHE_INIT_PGD_PA,	offsetof(struct kvm_nvhe_init_params, pgd_pa));
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 4b32588918d9..08e69faedf6c 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -77,9 +77,6 @@ KVM_NVHE_ALIAS(panic);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
-/* IDMAP TCR_EL1.T0SZ as computed by the EL1 init code */
-KVM_NVHE_ALIAS(idmap_t0sz);
-
 /* Kernel symbol used by icache_is_vpipt(). */
 KVM_NVHE_ALIAS(__icache_flags);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 93a408c00249..6c8594378865 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1387,6 +1387,7 @@ static void cpu_init_hyp_mode(void)
 {
 	struct kvm_nvhe_init_params *params = this_cpu_ptr_nvhe_sym(kvm_init_params);
 	struct arm_smccc_res res;
+	unsigned long tcr;
 
 	/* Switch from the HYP stub to our own HYP init vector */
 	__hyp_set_vectors(kvm_get_idmap_vector());
@@ -1399,6 +1400,27 @@ static void cpu_init_hyp_mode(void)
 	params->tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe_sym(__per_cpu_start) -
 			    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
 
+	params->mair_el2 = read_sysreg(mair_el1);
+
+	/*
+	 * The ID map may be configured to use an extended virtual address
+	 * range. This is only the case if system RAM is out of range for the
+	 * currently configured page size and VA_BITS, in which case we will
+	 * also need the extended virtual range for the HYP ID map, or we won't
+	 * be able to enable the EL2 MMU.
+	 *
+	 * However, at EL2, there is only one TTBR register, and we can't switch
+	 * between translation tables *and* update TCR_EL2.T0SZ at the same
+	 * time. Bottom line: we need to use the extended range with *both* our
+	 * translation tables.
+	 *
+	 * So use the same T0SZ value we use for the ID map.
+	 */
+	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
+	tcr &= ~TCR_T0SZ_MASK;
+	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
+	params->tcr_el2 = tcr;
+
 	params->stack_hyp_va = kern_hyp_va(__this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE);
 	params->pgd_pa = kvm_mmu_get_httbr();
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index e712e317337c..712f57289357 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -71,48 +71,26 @@ __do_hyp_init:
 1:	ldr	x0, [x1, #NVHE_INIT_TPIDR_EL2]
 	msr	tpidr_el2, x0
 
+	ldr	x0, [x1, #NVHE_INIT_MAIR_EL2]
+	msr	mair_el2, x0
+
 	ldr	x0, [x1, #NVHE_INIT_STACK_HYP_VA]
 	mov	sp, x0
 
-	ldr	x1, [x1, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x0, x1
+	ldr	x0, [x1, #NVHE_INIT_PGD_PA]
+	phys_to_ttbr x2, x0
 alternative_if ARM64_HAS_CNP
-	orr	x0, x0, #TTBR_CNP_BIT
+	orr	x2, x2, #TTBR_CNP_BIT
 alternative_else_nop_endif
-	msr	ttbr0_el2, x0
-
-	mrs	x0, tcr_el1
-	mov_q	x1, TCR_EL2_MASK
-	and	x0, x0, x1
-	mov	x1, #TCR_EL2_RES1
-	orr	x0, x0, x1
-
-	/*
-	 * The ID map may be configured to use an extended virtual address
-	 * range. This is only the case if system RAM is out of range for the
-	 * currently configured page size and VA_BITS, in which case we will
-	 * also need the extended virtual range for the HYP ID map, or we won't
-	 * be able to enable the EL2 MMU.
-	 *
-	 * However, at EL2, there is only one TTBR register, and we can't switch
-	 * between translation tables *and* update TCR_EL2.T0SZ at the same
-	 * time. Bottom line: we need to use the extended range with *both* our
-	 * translation tables.
-	 *
-	 * So use the same T0SZ value we use for the ID map.
-	 */
-	ldr_l	x1, idmap_t0sz
-	bfi	x0, x1, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
+	msr	ttbr0_el2, x2
 
 	/*
 	 * Set the PS bits in TCR_EL2.
 	 */
+	ldr	x0, [x1, #NVHE_INIT_TCR_EL2]
 	tcr_compute_pa_size x0, #TCR_EL2_PS_SHIFT, x1, x2
-
 	msr	tcr_el2, x0
 
-	mrs	x0, mair_el1
-	msr	mair_el2, x0
 	isb
 
 	/* Invalidate the stale TLBs from Bootloader */
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
