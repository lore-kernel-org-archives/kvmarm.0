Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEFEC4320E
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCA996101D
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BCA996101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6133E4B113;
	Mon,  9 Aug 2021 11:25:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RoZ9Dp3CNFmI; Mon,  9 Aug 2021 11:25:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F209B4B0EA;
	Mon,  9 Aug 2021 11:25:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D034A19F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rpk2ZESLgnr7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:31 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C70B40569
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:31 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 v6-20020a0cf9060000b029035546f11a23so1033218qvn.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MNGuBytX5NXMQPGh03MXz48l5IrVanSNLiyhXmu6HLc=;
 b=PARTJpvAdy7O5RqWHTAlFxcXu05/69ppZA0ujC1MkD/awV08LT++mW1Ot31gr/o2oE
 L7mInUCVpVyODycSxKTxKYGD7JUtSxBxwDtsTSLz4lX0jlNM2ZmxK+CywSCOB5nMw02q
 yJsSlJNdEe8QcdmwQo5IEqgbCrY9NLZRHKscsVzqrj8H6XZ0z2glBxgii77jHP/IrnNf
 ycRYzjVA6vW1A8kqhst9lDLKuRB3MV7VBWf7GNDsfD6uxVDkw/mErsEmhhp3lPDDd6p1
 8bMcTEPHuzFSiF3VHwnYVS/IR5yd2vUrfefNVmIVJfrlBSdnquN33PGrAdR1ZKp4pfDj
 f1Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MNGuBytX5NXMQPGh03MXz48l5IrVanSNLiyhXmu6HLc=;
 b=fpBV/O5je5z/faIY5PxqI8lR8Ga8kjrXymZkRitNvgdT7bvNHLxUWeTtPQNG5Nen1g
 YrB0y4HWeAmJR4Q2fIVjz4z3qhPy9yg/xWx2TZNWHEz4isW9MdgX3/JeO1hvvDHx+EWU
 VPSMHpQMEIDTdfXWmo3Z7uHs32nvPIf64F9hvVPlRJRY2WO/0VZ6rtCltYRCM6tme24G
 4Wd3s0Ct3z1kwm+7f17qn/zi2Tg/GSrB8VmZDJasErx91Nx6HyCrj3eX28tvN6SzKeD4
 Q+O17dD7WNZkLOdg0WNifZM4F2C9AoMu7h4n1COtoA/ibscL8wIqg+CSIbKhONxb0bL6
 rk4Q==
X-Gm-Message-State: AOAM5317OXeEdR9MDgdVMbDUO/hEKcWAsvkzeU/kwgsd1WYUmK9XkZOT
 KTObhObIZK66tqa57t4MsuigmGu3W0Uj
X-Google-Smtp-Source: ABdhPJw4mf35HGX4mhejZnF84rlhADJ8aR2DHNMQwNPUuRpUPyARXjrqqyYC3OYWgsFBlllhXreLHcRP/iXd
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a0c:f5c8:: with SMTP id
 q8mr6468132qvm.5.1628522731047; Mon, 09 Aug 2021 08:25:31 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:45 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-19-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 18/21] KVM: arm64: Remove __pkvm_mark_hyp
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

Now that we mark memory owned by the hypervisor in the host stage-2
during __pkvm_init(), we no longer need to rely on the host to
explicitly mark the hyp sections later on.

Remove the __pkvm_mark_hyp() hypercall altogether.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  3 +-
 arch/arm64/kvm/arm.c                          | 46 -------------------
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 --------
 5 files changed, 1 insertion(+), 77 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9f0bf2109be7..432a9ea1f02e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -63,8 +63,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
-#define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
-#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
+#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			20
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..2f378482471b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1954,57 +1954,11 @@ static void _kvm_host_prot_finalize(void *discard)
 	WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize));
 }
 
-static inline int pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
-{
-	return kvm_call_hyp_nvhe(__pkvm_mark_hyp, start, end);
-}
-
-#define pkvm_mark_hyp_section(__section)		\
-	pkvm_mark_hyp(__pa_symbol(__section##_start),	\
-			__pa_symbol(__section##_end))
-
 static int finalize_hyp_mode(void)
 {
-	int cpu, ret;
-
 	if (!is_protected_kvm_enabled())
 		return 0;
 
-	ret = pkvm_mark_hyp_section(__hyp_idmap_text);
-	if (ret)
-		return ret;
-
-	ret = pkvm_mark_hyp_section(__hyp_text);
-	if (ret)
-		return ret;
-
-	ret = pkvm_mark_hyp_section(__hyp_rodata);
-	if (ret)
-		return ret;
-
-	ret = pkvm_mark_hyp_section(__hyp_bss);
-	if (ret)
-		return ret;
-
-	ret = pkvm_mark_hyp(hyp_mem_base, hyp_mem_base + hyp_mem_size);
-	if (ret)
-		return ret;
-
-	for_each_possible_cpu(cpu) {
-		phys_addr_t start = virt_to_phys((void *)kvm_arm_hyp_percpu_base[cpu]);
-		phys_addr_t end = start + (PAGE_SIZE << nvhe_percpu_order());
-
-		ret = pkvm_mark_hyp(start, end);
-		if (ret)
-			return ret;
-
-		start = virt_to_phys((void *)per_cpu(kvm_arm_hyp_stack_page, cpu));
-		end = start + PAGE_SIZE;
-		ret = pkvm_mark_hyp(start, end);
-		if (ret)
-			return ret;
-	}
-
 	/*
 	 * Flip the static key upfront as that may no longer be possible
 	 * once the host stage 2 is installed.
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 49db0ec5a606..0118527b07b0 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -49,7 +49,6 @@ extern struct host_kvm host_kvm;
 extern const u8 pkvm_hyp_id;
 
 int __pkvm_prot_finalize(void);
-int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1632f001f4ed..7900d5b66ba3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -163,14 +163,6 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 {
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
 }
-
-static void handle___pkvm_mark_hyp(struct kvm_cpu_context *host_ctxt)
-{
-	DECLARE_REG(phys_addr_t, start, host_ctxt, 1);
-	DECLARE_REG(phys_addr_t, end, host_ctxt, 2);
-
-	cpu_reg(host_ctxt, 1) = __pkvm_mark_hyp(start, end);
-}
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -196,7 +188,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_create_mappings),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_prot_finalize),
-	HANDLE_FUNC(__pkvm_mark_hyp),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index cb023d31666e..2991dc6996b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -339,25 +339,6 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
-int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
-{
-	int ret;
-
-	/*
-	 * host_stage2_unmap_dev_all() currently relies on MMIO mappings being
-	 * non-persistent, so don't allow changing page ownership in MMIO range.
-	 */
-	if (!range_is_memory(start, end))
-		return -EINVAL;
-
-	hyp_spin_lock(&host_kvm.lock);
-	ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
-			      start, end - start, &host_s2_pool, pkvm_hyp_id);
-	hyp_spin_unlock(&host_kvm.lock);
-
-	return ret != -EAGAIN ? ret : 0;
-}
-
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
