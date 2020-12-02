Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179CFC64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E5F22173E
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E5F22173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BCD14B459;
	Wed,  2 Dec 2020 13:42:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5wQZSasdtAe2; Wed,  2 Dec 2020 13:42:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E82594B474;
	Wed,  2 Dec 2020 13:42:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F994B3FE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LeZaQ2uFKgpf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:42:28 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65BDC4B2CE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:42:28 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id e25so11136710wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=26Ee3tSf6bjWmO+pbW0InldfONK6QPnrCLx1QjKfx/Q=;
 b=Nu9UWjvhl68YCUsjhbXmp2EFwXOEzYW/jis6nLNCXn/NxJfU7CpOTssijMFw+UsPpd
 7oltSpuibe/iHjGG2OpFQ4w4pD1qsmbBGRvFmjW2xuUn2JkuWyVwcg85RRjAp9tIXaTK
 aP2gAH/bBPYSxRqNlX8Plyl8Gky8pnctQ4ag/a3FWSbjY3S0k6kIfS78g+wEMf0OxlFk
 v65pBZ5UKBi8p2sRqdfPUqIc6NexyNIU1+i7sK09E/pPGsQ7wP233KAe1++CSZzOLErg
 61rDJ75t8vNUKCFB/8Anz2tYqOdXv+9jzvHcdxm4tMFqEUh2BjkE8mApOYf3gCbWJHkp
 jjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=26Ee3tSf6bjWmO+pbW0InldfONK6QPnrCLx1QjKfx/Q=;
 b=tZSTAOncxd5e0vFKSiVwfzLiVzWBkwTKT28t9UnO0mkozeRmHRjYNq9DVhT75PbK2V
 rx0/ij2zID0TD7W5f+IeHGnpwzdDNf1A7czPuJgjML5r72szSO6a85dIYN6nhdrhDa0C
 xoiuWAyw9K/4ZcNaA6lVb2hmNTXKc+Ch5xJ6iwUVh0HForzm/yl/yG1Q7sttZrX9GUP1
 77eddOK9tU6u51u+jxQBRhq4j6/u/VDuu3j4XqgxFQwCItAqQSMSqCoNGbZaj40yg7O3
 UjmX/JwUAQkvyK+PFaX5Qraul2S/xqkK0QcuyLOAYKp8Le0b3HD19z3bi0DSXOB3blN3
 8gDw==
X-Gm-Message-State: AOAM532vFDGhP2jrS22Mq7Vj3oQ28ydIU54CZFtThtNBw/Jf3aTFpW/E
 dohZ+suj7K+/b/crTVVZV8y/+CKY9IvtBQ==
X-Google-Smtp-Source: ABdhPJxp6dGVemgWiRIwNDXC1BFMQeJwThH7w+RQVGXX/e/0zonlc4l4p1zCzJtr2NzkM2SO9rchMQ==
X-Received: by 2002:a1c:220a:: with SMTP id i10mr4451281wmi.93.1606934546855; 
 Wed, 02 Dec 2020 10:42:26 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id q12sm3056403wmc.45.2020.12.02.10.42.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:42:25 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 26/26] kvm: arm64: Fix EL2 mode availability checks
Date: Wed,  2 Dec 2020 18:41:22 +0000
Message-Id: <20201202184122.26046-27-dbrazdil@google.com>
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

With protected nVHE hyp code interception host's PSCI SMCs, the host
starts seeing new CPUs boot in EL1 instead of EL2. The kernel logic
that keeps track of the boot mode needs to be adjusted.

Add a static key enabled if KVM protected mode initialization is
successful.

When the key is enabled, is_hyp_mode_available continues to report
`true` because its users either treat it as a check whether KVM will be
/ was initialized, or whether stub HVCs can be made (eg. hibernate).

is_hyp_mode_mismatched is changed to report `false` when the key is
enabled. That's because all cores' modes matched at the point of KVM
init and KVM will not allow cores not present at init to boot. That
said, the function is never used after KVM is initialized.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/virt.h | 18 ++++++++++++++++++
 arch/arm64/kvm/arm.c          |  9 ++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index eb81dcc220b6..ee6a48df89d9 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -65,9 +65,19 @@ extern u32 __boot_cpu_mode[2];
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
 void __hyp_reset_vectors(void);
 
+DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
+	/*
+	 * If KVM protected mode is initialized, all CPUs must have been booted
+	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
+	 */
+	if (IS_ENABLED(CONFIG_KVM) &&
+	    static_branch_likely(&kvm_protected_mode_initialized))
+		return true;
+
 	return (__boot_cpu_mode[0] == BOOT_CPU_MODE_EL2 &&
 		__boot_cpu_mode[1] == BOOT_CPU_MODE_EL2);
 }
@@ -75,6 +85,14 @@ static inline bool is_hyp_mode_available(void)
 /* Check if the bootloader has booted CPUs in different modes */
 static inline bool is_hyp_mode_mismatched(void)
 {
+	/*
+	 * If KVM protected mode is initialized, all CPUs must have been booted
+	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
+	 */
+	if (IS_ENABLED(CONFIG_KVM) &&
+	    static_branch_likely(&kvm_protected_mode_initialized))
+		return false;
+
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5f8776eefe46..6e637d2b4cfb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
+DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
@@ -1926,12 +1927,14 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_hyp;
 
-	if (is_protected_kvm_enabled())
+	if (is_protected_kvm_enabled()) {
+		static_branch_enable(&kvm_protected_mode_initialized);
 		kvm_info("Protected nVHE mode initialized successfully\n");
-	else if (in_hyp_mode)
+	} else if (in_hyp_mode) {
 		kvm_info("VHE mode initialized successfully\n");
-	else
+	} else {
 		kvm_info("Hyp mode initialized successfully\n");
+	}
 
 	return 0;
 
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
