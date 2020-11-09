Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9C8C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 255BF208FE
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="GGA3JU5M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 255BF208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF324B771;
	Mon,  9 Nov 2020 06:33:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K3RwNh9mH84K; Mon,  9 Nov 2020 06:33:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32E1A4B4DF;
	Mon,  9 Nov 2020 06:33:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 713BD4B771
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AaPrPnXhx0Ng for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:28 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AE9B4B536
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:28 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id j7so1055071wrp.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=yiVqo0I7pGB5oEXJoL4wsfNNfOXq8d133w3c7AwQTmA=;
 b=GGA3JU5M9+tIOvlhbl+W31KWNkSPWds3SMYdI2y84Pb3DQsror8hLpYrnonQblZsI+
 JTqPx3DioUxKwT2W5XvGzA/MhoW4J4VZh0ul97rvAkv+Kr8U7J28OQUN0cZqVzvX8oe4
 BZrYy1qKA41ohpNXJgymlX8cnWolNzJcTztyhG1iix/9gWfqj3dXmm7lrksUk8hHzLFS
 r3QVhaBdVrzR4f0NJQjZ6/zG9mdRnJQsPNtJC7tMcGpwVrk+e41ajZwyLfzkJYUOJkKm
 KuVgYUCmiD/cycIAYCfFwSA7TPdRCMmKsNTANlHO6cmOltdjOhGA6GKjpSuSXDGNc8mZ
 KJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=yiVqo0I7pGB5oEXJoL4wsfNNfOXq8d133w3c7AwQTmA=;
 b=VujfNVZKJflmbfvtZfcKZFZd3KhRKk5gGgAmEnc+x7SuyAcsjL6HF/9RYssOC4/Ypr
 akSd6gsJ9YZQh5iEAKTNg3bBdfwh1LeEhtG8Pe4yppeZyK8okqkZmmUgeH0N9rurMxws
 a5i8Wi5XtuoCrEUuyTxeTuRea4nH6GU8f1yQHRmGYTsFgHCuVm6jV5HMEqrmyFpNGGiO
 Jtc2L7jOEHmRLL7cvU16SLDfOyo4Lrefxn4EX2Ch8OXJAF0KACGXVqQDYRpUnyTv8NL1
 sz+bihBzJpbe5D8bXUj82Rg0ojD0EPO/rVe9Lo2yixup8MbZv9h5qhgt7njKEfBRVKNO
 tsGA==
X-Gm-Message-State: AOAM530/SktCDJRiIE+SFc8faMgQ86Dh0WeozIEEA4SmjxLpNa4tDcUu
 /NeEeATuUuh0NCwbBOSLR8bpVVDaRWdsAgjV
X-Google-Smtp-Source: ABdhPJwsxb54EYyLHnV2E1XBcoH6JNqqkZcyLkTXWH8b0BTZda5qQTihScZQ+OrfOTSrBdeqjMvt4w==
X-Received: by 2002:adf:e3cf:: with SMTP id k15mr1457671wrm.259.1604921606682; 
 Mon, 09 Nov 2020 03:33:26 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id u10sm13507690wrw.36.2020.11.09.03.33.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:25 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 23/24] kvm: arm64: Trap host SMCs in protected mode.
Date: Mon,  9 Nov 2020 11:32:32 +0000
Message-Id: <20201109113233.9012-24-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
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

While protected nVHE KVM is installed, start trapping all host SMCs.
By default, these are simply forwarded to EL3, but PSCI SMCs are
validated first.

Create new constant HCR_HOST_NVHE_PROTECTED_FLAGS with the new set of HCR
flags to use while the nVHE vector is installed when the kernel was
booted with the protected flag enabled. Switch back to the default HCR
flags when switching back to the stub vector.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_arm.h   |  1 +
 arch/arm64/kernel/image-vars.h     |  4 ++++
 arch/arm64/kvm/arm.c               | 35 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  8 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c   |  5 ++++-
 5 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 64ce29378467..4e90c2debf70 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -80,6 +80,7 @@
 			 HCR_FMO | HCR_IMO | HCR_PTW )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
+#define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 78a42a7cdb72..75cda51674f4 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -62,9 +62,13 @@ __efistub__ctype		= _ctype;
  */
 
 /* Alternative callbacks for init-time patching of nVHE hyp code. */
+KVM_NVHE_ALIAS(kvm_patch_hcr_flags);
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
 
+/* Static key enabled when the user opted into nVHE protected mode. */
+KVM_NVHE_ALIAS(kvm_protected_mode);
+
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 574aa2d026e6..c09b95cfa00a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1861,6 +1861,41 @@ void kvm_arch_exit(void)
 	kvm_perf_teardown();
 }
 
+static inline u32 __init __gen_mov_hcr_insn(u64 hcr, u32 rd, int i)
+{
+	int shift = 48 - (i * 16);
+	u16 imm = (hcr >> shift) & GENMASK(16, 0);
+
+	return aarch64_insn_gen_movewide(rd, imm, shift,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 (i == 0) ? AARCH64_INSN_MOVEWIDE_ZERO
+						  : AARCH64_INSN_MOVEWIDE_KEEP);
+}
+
+void __init kvm_patch_hcr_flags(struct alt_instr *alt,
+				__le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	int i;
+	u32 rd;
+
+	BUG_ON(nr_inst != 4);
+
+	/* Skip for VHE and unprotected nVHE modes. */
+	if (!is_kvm_protected_mode())
+		return;
+
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD,
+					  le32_to_cpu(origptr[0]));
+
+	for (i = 0; i < nr_inst; i++) {
+		u32 oinsn = __gen_mov_hcr_insn(HCR_HOST_NVHE_FLAGS, rd, i);
+		u32 insn = __gen_mov_hcr_insn(HCR_HOST_NVHE_PROTECTED_FLAGS, rd, i);
+
+		BUG_ON(oinsn != le32_to_cpu(origptr[i]));
+		updptr[i] = cpu_to_le32(insn);
+	}
+}
+
 static int __init early_kvm_protected_cfg(char *buf)
 {
 	bool val;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index f999a35b2c8c..bbe6c5f558e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -88,6 +88,12 @@ SYM_CODE_END(__kvm_hyp_init)
  * x0: struct kvm_nvhe_init_params PA
  */
 SYM_CODE_START(___kvm_hyp_init)
+alternative_cb kvm_patch_hcr_flags
+	mov_q	x1, HCR_HOST_NVHE_FLAGS
+alternative_cb_end
+	msr	hcr_el2, x1
+	isb
+
 	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
 	msr	tpidr_el2, x1
 
@@ -220,6 +226,8 @@ reset:
 	bic	x5, x5, x6		// Clear SCTL_M and etc
 	pre_disable_mmu_workaround
 	msr	sctlr_el2, x5
+	mov_q	x5, HCR_HOST_NVHE_FLAGS
+	msr	hcr_el2, x5
 	isb
 
 	/* Install stub vectors */
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 8ae8160bc93a..f605b25a9afc 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -96,7 +96,10 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
 
 	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
+	if (is_kvm_protected_mode())
+		write_sysreg(HCR_HOST_NVHE_PROTECTED_FLAGS, hcr_el2);
+	else
+		write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
