Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A177AC2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 403D52224B
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="V0kKFYAC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 403D52224B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D65DC4C25C;
	Mon, 16 Nov 2020 15:43:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vw4SXgPLElCc; Mon, 16 Nov 2020 15:43:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C333B4C246;
	Mon, 16 Nov 2020 15:43:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CF764C1EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NKBWQ8gWX-ZY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:52 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 589CD4C246
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:52 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id m125so578585wmm.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=tbKc0XACzM2ruUCBvbubjeIAaEVu68JylfPt9mceM1c=;
 b=V0kKFYACpKx5jE69f+4aUeVVVU0VxycZFFIX0Z1f7dnoyAJr09Ps1E9SsrP/0GOfEU
 aPhG5sBGQx5FVnsM2+CIFWKtR9QzPGV3r+sDwdzniDxXDodE2urN3MpQBawaYZ2T4IIR
 xD/KJ3c0EnuyX/Av2vEm1PdejW7PnbDH++SSaafdD9isNZNnqIQfO1OMFacu1LmNLtl8
 2zBH0XHJZdSBLpqSLEn+acR3I9sPPF2clR3r380SSkH/u0ZgqN1kp+BO+K699A5dUPFY
 +irj4fwGT2++WFzSsD4gCBkTDfiqo4T9tJlaVrajFemZJDON9TaBI0yynHgtOyLAYsIM
 XmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=tbKc0XACzM2ruUCBvbubjeIAaEVu68JylfPt9mceM1c=;
 b=dSEn2HgHdkR6+D3W8juOmcWCTpTidPZuaudqwTgQ0Ve41brDglOaWfp0h8YAK82P2p
 +JkdTirV2T45LCo22o+MilZLs+ixkJLSBBkVKb/d7rj/frpZwGX36q1Fx2up/u0GfYDz
 DgPNmxi9CAhl5w8HxJyX2Zx0FpxzWHqUW104T+q68njZ6YLfC3j+a4gl9/MPW5Twx0nu
 Yk6IULP+OsiXvAeVQ4Gy4O2EH1M+a+wUIpjVScqOZ7EvRpwTOaS5d7RrJ0Z/BvY+sBfX
 QktoPmoN3k+sjaIv2xun+galKGza94LP1l+94NIz0T9kPtGzpLOmjklR2DKRkP08a2T1
 TARw==
X-Gm-Message-State: AOAM532SCV7dQCWAp7K14X5EInA4HxMHDOqA3r8vaKrDi+B28vjIcbF+
 JX0U4PYGPNHbxvITdQAkAoZAmTJY1y//SbnaA/4=
X-Google-Smtp-Source: ABdhPJwqhw97XZrxLyHY9+fXCxOlyroHhFsnnL0TEFTRcWcLWzN0zrDmnJ4SoEdyylNRdDXrSB3g6g==
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr694636wmj.109.1605559430793;
 Mon, 16 Nov 2020 12:43:50 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id i6sm530365wma.42.2020.11.16.12.43.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:49 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 13/24] kvm: arm64: Add offset for hyp VA <-> PA conversion
Date: Mon, 16 Nov 2020 20:43:07 +0000
Message-Id: <20201116204318.63987-14-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
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

Add a host-initialized constant to KVM nVHE hyp code for converting
between EL2 linear map virtual addresses and physical addresses.
Also add `__hyp_pa` macro that performs the conversion.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
 arch/arm64/kvm/va_layout.c           | 30 +++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index d75d3f896bfd..1583b63322c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -16,6 +16,9 @@
 /* Config options set by the host. */
 u32 __ro_after_init kvm_host_psci_version = PSCI_VERSION(0, 0);
 u32 __ro_after_init kvm_host_psci_function_id[PSCI_FN_MAX];
+s64 __ro_after_init hyp_physvirt_offset;
+
+#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index e0404bcab019..744a0d998ad3 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -22,6 +22,30 @@ static u8 tag_lsb;
 static u64 tag_val;
 static u64 va_mask;
 
+/*
+ * Compute HYP VA by using the same computation as kern_hyp_va().
+ */
+static u64 __early_kern_hyp_va(u64 addr)
+{
+	addr &= va_mask;
+	addr |= tag_val << tag_lsb;
+	return addr;
+}
+
+/*
+ * Store a hyp VA <-> PA offset into a hyp-owned variable.
+ */
+static void init_hyp_physvirt_offset(void)
+{
+	extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
+	u64 kern_va, hyp_va;
+
+	/* Compute the offset from the hyp VA and PA of a random symbol. */
+	kern_va = (u64)kvm_ksym_ref(__hyp_text_start);
+	hyp_va = __early_kern_hyp_va(kern_va);
+	CHOOSE_NVHE_SYM(hyp_physvirt_offset) = (s64)__pa(kern_va) - (s64)hyp_va;
+}
+
 /*
  * We want to generate a hyp VA with the following format (with V ==
  * vabits_actual):
@@ -53,6 +77,8 @@ __init void kvm_compute_layout(void)
 		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
 	}
 	tag_val >>= tag_lsb;
+
+	init_hyp_physvirt_offset();
 }
 
 static u32 compute_instruction(int n, u32 rd, u32 rn)
@@ -150,9 +176,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 	/*
 	 * Compute HYP VA by using the same computation as kern_hyp_va()
 	 */
-	addr = (uintptr_t)kvm_ksym_ref(__kvm_hyp_vector);
-	addr &= va_mask;
-	addr |= tag_val << tag_lsb;
+	addr = __early_kern_hyp_va((u64)kvm_ksym_ref(__kvm_hyp_vector));
 
 	/* Use PC[10:7] to branch to the same vector in KVM */
 	addr |= ((u64)origptr & GENMASK_ULL(10, 7));
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
