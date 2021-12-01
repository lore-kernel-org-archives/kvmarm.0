Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E36C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:05:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DCB44B222;
	Wed,  1 Dec 2021 12:05:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qe6JHtmNbCI7; Wed,  1 Dec 2021 12:05:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FAD84B25A;
	Wed,  1 Dec 2021 12:05:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FFE64B126
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:05:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sl8ZczR0Be5R for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:05:11 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6625E4B272
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:05:10 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 j25-20020a05600c1c1900b00332372c252dso1208928wms.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HbFxjGh3zL5KJap6QW7mkZZ6VIZaiwXKEnlk6BAwVfU=;
 b=JtzM0gEDraZHkDaYQXTg0ZV8V0cXC3mNBHZ97J5W0AM9joQ+Tu6jEW6c3fBIQkM6Ib
 GwAR01pqvQylN5LeKRH5Q7RYcav9puXAvqGGEcceHhNVJtu2fZHSGJ5I0rAaGQRSIYb2
 um0QpT9MkVgcbMmR6Fe5Gy1YhwIaojgSu8kpYp6Fc99EcuSk/ZUsB6cbr7CyUb/dupU5
 Gz5vsL1JQx95KAsJyQQyYmsRFPNuLYANb7uJyyiLv4lMWxabM0Cwl9zjdJN6qvIeviEy
 3CnwNybnqLkVpaWiFzwQXR0drk5xVz195jgBHNzbI5LpKat6JDQIqFPJtbQdyW+JwiqW
 0uQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HbFxjGh3zL5KJap6QW7mkZZ6VIZaiwXKEnlk6BAwVfU=;
 b=JGueNZMwovlsWB+n8+xdv4vgwiXx3g1rd8FSCUPknngOW7+hUw7w4PeHK9b6rbsv1u
 LyO/4Tb4YbGLImMCngXfnk9r8UJ4WKQrQAle1L0xi1xM1qkRN1MQMJwj7MXKNOycnHeY
 7wPP98QLTTGmlU2LDW6GkzLk1r+dk7sngq8KLog7FZ6nS6MZnX68+DB/NZWQNTudYN62
 dPzve5xO2Y35RAt2C3ljqukfKttg0F/8PPsjLlAxCfxL5KTnvGSQcwq4FBo6bwoSKddh
 bB6LA21ak3zMoc4Ki7YOphaOD8l33egbRDtUMxUkdHs+DXr+u5869ut9XfPgYiTchMF/
 ImSQ==
X-Gm-Message-State: AOAM533kZ5k4IvHGAf9ZOfTqh3N79Mo2Mr1hXLBNqx65FVSOKhs8z5Bh
 lB7d/NB86o4JNsP6IstuvKCB53ThyzXp
X-Google-Smtp-Source: ABdhPJwxaQUpa6nGrPntWg01UvZg5ANqj35b7DgPpex7mqDVaKYEMPj2lT/WlosMtvdaA5BJp8zHD3MNtwZE
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a5d:508d:: with SMTP id
 a13mr8350562wrt.41.1638378309381; Wed, 01 Dec 2021 09:05:09 -0800 (PST)
Date: Wed,  1 Dec 2021 17:04:08 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-15-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 14/15] KVM: arm64: Expose unshare hypercall to the host
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

From: Will Deacon <will@kernel.org>

Introduce an unshare hypercall which can be used to unmap memory from
the hypervisor stage-1 in nVHE protected mode. This will be useful to
update the EL2 ownership state of pages during guest teardown, and
avoids keeping dangling mappings to unreferenced portions of memory.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  8 +++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 33 +++++++++++++++++++
 4 files changed, 43 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 50d5e4de244c..d5b0386ef765 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -63,6 +63,7 @@ enum __kvm_host_smccc_func {
 
 	/* Hypercalls available after pKVM finalisation */
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 56445586c755..80e99836eac7 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -55,6 +55,7 @@ extern const u8 pkvm_hyp_id;
 
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
+int __pkvm_host_unshare_hyp(u64 pfn);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index b096bf009144..5e2197db0d32 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -147,6 +147,13 @@ static void handle___pkvm_host_share_hyp(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn);
 }
 
+static void handle___pkvm_host_unshare_hyp(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, pfn, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_host_unshare_hyp(pfn);
+}
+
 static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
@@ -184,6 +191,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_prot_finalize),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
+	HANDLE_FUNC(__pkvm_host_unshare_hyp),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 43b25e2de780..640234d3896a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -768,3 +768,36 @@ int __pkvm_host_share_hyp(u64 pfn)
 
 	return ret;
 }
+
+int __pkvm_host_unshare_hyp(u64 pfn)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 hyp_addr = (u64)__hyp_va(host_addr);
+	struct pkvm_mem_share share = {
+		.tx	= {
+			.nr_pages	= 1,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= host_addr,
+				.host	= {
+					.completer_addr = hyp_addr,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_HYP,
+			},
+		},
+		.prot	= PAGE_HYP,
+	};
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret = do_unshare(&share);
+
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
