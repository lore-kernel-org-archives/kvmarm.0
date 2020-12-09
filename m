Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04890C4167B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A20E023BE0
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A20E023BE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 457034B2FF;
	Wed,  9 Dec 2020 08:18:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WcQKMBYPDHXn; Wed,  9 Dec 2020 08:18:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 367384B2FB;
	Wed,  9 Dec 2020 08:18:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1254B2A2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9jSevODdRA0h for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:18:09 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FF404B2FB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:08 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id t4so1695343wrr.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=epDnqaqaZseNBctE5f6pG2jQivwHl0Mc5pVZrVSTknc=;
 b=vMZTrkYojozaS4K0jVCmBqRNU23vVXRN02oEMfrHJs+eTcblucPsYLIWc3Vynrw+mn
 mznHBDBHtGjXdR8iqBA6OGh8SbXDKjYnPobJKkjxEf50OjacfCEa2rGjfuQQ2H4H9sQJ
 5huM2YXJ2VUEtYLttFKHif/j0m1y/kX0dp9/ySWEbQUDoNDnOQoOQi9Wk67kT9gYy+hO
 nu9q8KpDQW49sVES3PmG8NmnSn+TFu/aqzjglEBXHVBANm2olkYlmLHucLxVnRFxPQAj
 LHy2Ipd8nHoWiHjEDUHhwskIoTDUqmBEm8BYh+e/w3HriGC821g+MSWWqpEJBJSufmNz
 fHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=epDnqaqaZseNBctE5f6pG2jQivwHl0Mc5pVZrVSTknc=;
 b=nHAoyZh9ZulJ8+eO2UulRTBY/YJB4kVzAatvXDWXQ9qEX/IpW466t69e78BM43CflM
 6Hd+pLoNUzpOmnMvmStqWcX0t0BnSs9w8wyf6697VIqe3ATt9GbA9ZcSFEbBqv9R7Fuj
 CA5LSVi5dgrlAXkiSOGNRcbHsxHTMm4b9hLYSo1FfJ6+sTHCCwv247TjN+rgFw28iyHT
 T0Ura65E/+R+qPXv9joeYc0dC5TvxQ9Y2AtjceP8+uW2ovYSMTMjh8yCUQExXdNdFnZb
 GNAW7nVSIZ85eWBF5Zb4JmBxQhzXheaVBq65pKI1fFDHQ2zP7XTrmYRXfxYhuy51ZTpC
 b+GQ==
X-Gm-Message-State: AOAM530JICXLefFkcCWZBj6QdvzPsdSP7XBvvP/W0j02ru9cRhc9+N1y
 eWi/BjBNKm9to10AIytlvodCBX5kmonZ5g==
X-Google-Smtp-Source: ABdhPJxW/XmoEaKVme8L2Gku0Ug7u+SX6ybe+SCrh0vpKo7yHlnDZJnDPITz8Rh8FhHshHxxfEtGIg==
X-Received: by 2002:adf:f84b:: with SMTP id d11mr2693844wrq.216.1607519887099; 
 Wed, 09 Dec 2020 05:18:07 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id f16sm3285407wmh.7.2020.12.09.05.18.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:18:06 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 8/9] KVM: arm64: Remove patching of fn pointers in hyp
Date: Wed,  9 Dec 2020 13:17:45 +0000
Message-Id: <20201209131746.85622-9-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209131746.85622-1-dbrazdil@google.com>
References: <20201209131746.85622-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

Storing a function pointer in hyp now generates relocation information
used at early boot to convert the address to hyp VA. The existing
alternative-based conversion mechanism is therefore obsolete. Remove it
and simplify its users.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h   | 18 ------------------
 arch/arm64/kernel/image-vars.h     |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 ++++-------
 arch/arm64/kvm/va_layout.c         |  6 ------
 4 files changed, 4 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index adadc468cc71..90873851f677 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -135,24 +135,6 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
 
-static __always_inline unsigned long __kimg_hyp_va(unsigned long v)
-{
-	unsigned long offset;
-
-	asm volatile(ALTERNATIVE_CB("movz %0, #0\n"
-				    "movk %0, #0, lsl #16\n"
-				    "movk %0, #0, lsl #32\n"
-				    "movk %0, #0, lsl #48\n",
-				    kvm_update_kimg_phys_offset)
-		     : "=r" (offset));
-
-	return __kern_hyp_va((v - offset) | PAGE_OFFSET);
-}
-
-#define kimg_fn_hyp_va(v) 	((typeof(*v))(__kimg_hyp_va((unsigned long)(v))))
-
-#define kimg_fn_ptr(x)	(typeof(x) **)(x)
-
 /*
  * We currently support using a VM-specified IPA size. For backward
  * compatibility, the default IPA size is fixed to 40bits.
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 39289d75118d..3242502f45fa 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -64,7 +64,6 @@ __efistub__ctype		= _ctype;
 /* Alternative callbacks for init-time patching of nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
-KVM_NVHE_ALIAS(kvm_update_kimg_phys_offset);
 KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
 
 /* Global kernel state accessed by nVHE hyp code. */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index bde658d51404..0cf4b750a090 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -108,9 +108,9 @@ static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
 
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
-#define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = kimg_fn_ptr(handle_##x)
+#define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
 
-static const hcall_t *host_hcall[] = {
+static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
@@ -130,7 +130,6 @@ static const hcall_t *host_hcall[] = {
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, id, host_ctxt, 0);
-	const hcall_t *kfn;
 	hcall_t hfn;
 
 	id -= KVM_HOST_SMCCC_ID(0);
@@ -138,13 +137,11 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	if (unlikely(id >= ARRAY_SIZE(host_hcall)))
 		goto inval;
 
-	kfn = host_hcall[id];
-	if (unlikely(!kfn))
+	hfn = host_hcall[id];
+	if (unlikely(!hfn))
 		goto inval;
 
 	cpu_reg(host_ctxt, 0) = SMCCC_RET_SUCCESS;
-
-	hfn = kimg_fn_hyp_va(kfn);
 	hfn(host_ctxt);
 
 	return;
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index fb2ca02b7270..e0021ba960b5 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -284,12 +284,6 @@ static void generate_mov_q(u64 val, __le32 *origptr, __le32 *updptr, int nr_inst
 	*updptr++ = cpu_to_le32(insn);
 }
 
-void kvm_update_kimg_phys_offset(struct alt_instr *alt,
-				 __le32 *origptr, __le32 *updptr, int nr_inst)
-{
-	generate_mov_q(kimage_voffset + PHYS_OFFSET, origptr, updptr, nr_inst);
-}
-
 void kvm_get_kimage_voffset(struct alt_instr *alt,
 			    __le32 *origptr, __le32 *updptr, int nr_inst)
 {
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
