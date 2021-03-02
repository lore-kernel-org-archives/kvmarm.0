Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7753FC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2448A64F3A
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2448A64F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBC694B65C;
	Tue,  2 Mar 2021 10:01:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XmsCsPP7LrER; Tue,  2 Mar 2021 10:01:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D81E4B698;
	Tue,  2 Mar 2021 10:01:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F083E4B6A7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LGc+Ng39LxTv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:01:19 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A0604B664
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:19 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id l10so11229236wry.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=8yMjY9nGGdG3kCURKAswxRcBn78w62ceWoknmifn0Fc=;
 b=wSZRd5YyhLGwCBAFIt3Ga6LuNLgf8Fi8I6omo/pvR9foidKTkYk2IXlyNbnBoJFF34
 KbnndPtsrm7ghrq1Wy+pnLcenm1IcfH2XxjeT4mApWic44zxOx6Uq8kuiHrlXdgJl4Ob
 7kvIFN11fUx/ydfa1rpVa59aYAbnaYJGYgu8EHWbQE8o/aBq0LBE4sk9GsmrJKArwKTm
 B9v13xqdO1QuVwjYSH4t8Co9vDG9yCdw3TgpxYoQOjPkvVUJ6coXDKrHjKWL0v6UXTK4
 qAr08axgDfhr9fJ3I0sIV4a/PFg0+4MF3lvC4K7GocSYm3sV7IWq6xwjI/diP+ESwcs+
 64IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8yMjY9nGGdG3kCURKAswxRcBn78w62ceWoknmifn0Fc=;
 b=Gi2efPGCT2fd/gBllm2zicqwSGxLVU0DVT2jsMUCrzvV7fhnT7EL7fUvA3vsDz+e8S
 YK2C5AK3KievZxgTUyk0vTsXGga4IgeAKa2Mh7UbRchx0Aa/Pw88skeNRSIzRmFsvM2Z
 HLGoMliEdkxeX7MJEue8NxpVXCl8nhbf3je/eEQucTwUFQaeejG08+HfGFClRMzKasdf
 B1/UonQyxKW3JK5tUhj045PHjfpFRZtFKGedPSrwFxIFo1KQKsKfDWDris1yPaudWVhO
 Axkrq5SCmuMS7k19yzkGWYznhABvX0mr/uikBbcrYxCPPQsMdkwpI5rPiRxzKT3+IkwG
 GzAg==
X-Gm-Message-State: AOAM530VnNxHa+hdhdgwf5qKBMolZxY4voddhlghsFJGlmtTTbBTksuN
 5GiWHYuho1PcNYO9tNr6p06OxHJJaaEJ
X-Google-Smtp-Source: ABdhPJxYQIjUkt2RSBck3HRxMcW3YX2laHG5V0FLpOXHWWygCA8hezD7vfJS55sNzIbZYYijKQfyTK90llcS
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:adf:f3cc:: with SMTP id
 g12mr13345460wrp.118.1614697278738; Tue, 02 Mar 2021 07:01:18 -0800 (PST)
Date: Tue,  2 Mar 2021 15:00:02 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-33-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 32/32] KVM: arm64: Protect the .hyp sections from the host
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

When KVM runs in nVHE protected mode, use the host stage 2 to unmap the
hypervisor sections. The long-term goal is to ensure the EL2 code can
remain robust regardless of the host's state, so this starts by making
sure the host cannot e.g. write to the .hyp sections directly.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/arm.c                          | 46 +++++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 22 +++++++++
 5 files changed, 80 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index b127af02bd45..9accf5350858 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -62,6 +62,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
+#define __KVM_HOST_SMCCC_FUNC___pkvm_host_unmap			20
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a31c56bc55b3..73c26d206542 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1894,11 +1894,57 @@ void _kvm_host_prot_finalize(void *discard)
 	WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize));
 }
 
+static inline int pkvm_host_unmap(phys_addr_t start, phys_addr_t end)
+{
+	return kvm_call_hyp_nvhe(__pkvm_host_unmap, start, end);
+}
+
+#define pkvm_host_unmap_section(__section)		\
+	pkvm_host_unmap(__pa_symbol(__section##_start),	\
+			__pa_symbol(__section##_end))
+
 static int finalize_hyp_mode(void)
 {
+	int cpu, ret;
+
 	if (!is_protected_kvm_enabled())
 		return 0;
 
+	ret = pkvm_host_unmap_section(__hyp_idmap_text);
+	if (ret)
+		return ret;
+
+	ret = pkvm_host_unmap_section(__hyp_text);
+	if (ret)
+		return ret;
+
+	ret = pkvm_host_unmap_section(__hyp_rodata);
+	if (ret)
+		return ret;
+
+	ret = pkvm_host_unmap_section(__hyp_bss);
+	if (ret)
+		return ret;
+
+	ret = pkvm_host_unmap(hyp_mem_base, hyp_mem_base + hyp_mem_size);
+	if (ret)
+		return ret;
+
+	for_each_possible_cpu(cpu) {
+		phys_addr_t start = virt_to_phys((void *)kvm_arm_hyp_percpu_base[cpu]);
+		phys_addr_t end = start + (PAGE_SIZE << nvhe_percpu_order());
+
+		ret = pkvm_host_unmap(start, end);
+		if (ret)
+			return ret;
+
+		start = virt_to_phys((void *)per_cpu(kvm_arm_hyp_stack_page, cpu));
+		end = start + PAGE_SIZE;
+		ret = pkvm_host_unmap(start, end);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Flip the static key upfront as that may no longer be possible
 	 * once the host stage 2 is installed.
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index d293cb328cc4..39890d4f1dc8 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -21,6 +21,8 @@ struct host_kvm {
 extern struct host_kvm host_kvm;
 
 int __pkvm_prot_finalize(void);
+int __pkvm_host_unmap(phys_addr_t start, phys_addr_t end);
+
 int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f47028d3fd0a..2069136fdaec 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -156,6 +156,14 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 {
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
 }
+
+static void handle___pkvm_host_unmap(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, start, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, end, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_host_unmap(start, end);
+}
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -180,6 +188,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_create_mappings),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_prot_finalize),
+	HANDLE_FUNC(__pkvm_host_unmap),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2252ad1a8945..ed480facdc88 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -196,6 +196,28 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+int __pkvm_host_unmap(phys_addr_t start, phys_addr_t end)
+{
+	struct kvm_mem_range r1, r2;
+	int ret;
+
+	/*
+	 * host_stage2_unmap_dev_all() currently relies on MMIO mappings being
+	 * non-persistent, so don't allow PROT_NONE in MMIO range.
+	 */
+	if (!find_mem_range(start, &r1) || !find_mem_range(end, &r2))
+		return -EINVAL;
+	if (r1.start != r2.start)
+		return -EINVAL;
+
+	hyp_spin_lock(&host_kvm.lock);
+	ret = kvm_pgtable_stage2_map(&host_kvm.pgt, start, end - start, start,
+				     KVM_PGTABLE_PROT_NONE, &host_s2_mem);
+	hyp_spin_unlock(&host_kvm.lock);
+
+	return ret;
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
