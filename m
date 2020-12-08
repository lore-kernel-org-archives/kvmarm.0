Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF63C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C76B723A5B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C76B723A5B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 663744B0CA;
	Tue,  8 Dec 2020 09:25:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qP4qXTG25gb5; Tue,  8 Dec 2020 09:25:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 286C24B27F;
	Tue,  8 Dec 2020 09:25:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F106B4B238
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CT2jrt0tArVY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 09:25:09 -0500 (EST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD00D4B27A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:08 -0500 (EST)
Received: by mail-wr1-f42.google.com with SMTP id r3so16429789wrt.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 06:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=BjhXUzKj/3SLZy5uNzA4C/K6PgPdZs4Iy7Z8pRwTud8=;
 b=MKIjDRNE/vH7SgozRRbntqZl5L9nka4a7Ks+O6ij33TKr2hIkODBY1hA1/m+K1veuj
 WmwIcpss4zZkKtcl7qo6wg+/fLKsBGX8FIHtR4xNHEfnIbVAC3cMcFL2+jTyZ9XTZYJu
 t0Kw8BRj5oukfXXBP2W3+TB6ljiySnAkgPs6ymhbS7wS2GHlFlJXwNF6FEUgQYtSbD3y
 wF2yRIF0xdIEf/V8Kgv5FInnkg1QXYusNQChJp6+OmEWnCJq5cKCAqzVfPUNWdTbqXrY
 oRhEBOujqBZKugx2DJAg6xp+aIgxxcE8BBKxRWh2ALqOgMNrYVnlyCrf2uyr5wu76iEH
 S7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=BjhXUzKj/3SLZy5uNzA4C/K6PgPdZs4Iy7Z8pRwTud8=;
 b=e/R5xCnK7RYcQkiil+8oJat/VkhZjNWbTRuxH+VjhbhTKxTxXgMOQws0+6MSIU5Ix4
 v5+z1gjSY1A2bMsU55voQgaGSTByWosSPjWrNKivODWbO87cAT1Buz+WOpgFTNiK1Ia4
 +j2UVdmg7v5DZK2F/aCBNoBIURCLabajb6mMgYu2UIftjBaS5CM+62YO/CE4RMiwRDnf
 PWVaZUVJkEjaQE5XA6d1pqHGpqyYCf5z0XIyDEhDrhetR5hUsSvNpEowC8O4i14GQJLB
 2+n6p8nayyllKmu4jwn64WwY5o/ZWf4pNh6u62q355Ed4QwgoUuWCMubHcC99LLrIXNj
 xS4w==
X-Gm-Message-State: AOAM5339rQiqM210uHirxGjQyKsWGC+9ahWwoRScn6jKFfP8502HtNg1
 P1BF07N0Uj7Gle/mjy0eX8bpToh0bTy07w==
X-Google-Smtp-Source: ABdhPJzoJxdQFiXPcs1IzkqG8RhT6d83cMB1+XcYtV3yavJzRs/oL8cti6OQk1Eth3W4tH2A/bO10Q==
X-Received: by 2002:adf:e449:: with SMTP id t9mr24998689wrm.257.1607437507409; 
 Tue, 08 Dec 2020 06:25:07 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id 101sm14275907wrc.11.2020.12.08.06.25.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Dec 2020 06:25:06 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/6] kvm: arm64: Minor cleanup of hyp variables used in host
Date: Tue,  8 Dec 2020 14:24:50 +0000
Message-Id: <20201208142452.87237-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208142452.87237-1-dbrazdil@google.com>
References: <20201208142452.87237-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Small cleanup moving declarations of hyp-exported variables to
kvm_host.h and using macros to avoid having to refer to them with
kvm_nvhe_sym() in host.

No functional change intended.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 arch/arm64/kvm/arm.c              | 4 +---
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 6 +++---
 arch/arm64/kvm/va_layout.c        | 5 ++---
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 828d50d40dc2..bce2452b305c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -260,6 +260,12 @@ struct kvm_host_psci_config {
 extern struct kvm_host_psci_config kvm_nvhe_sym(kvm_host_psci_config);
 #define kvm_host_psci_config CHOOSE_NVHE_SYM(kvm_host_psci_config)
 
+extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
+#define hyp_physvirt_offset CHOOSE_NVHE_SYM(hyp_physvirt_offset)
+
+extern u64 kvm_nvhe_sym(hyp_cpu_logical_map)[NR_CPUS];
+#define hyp_cpu_logical_map CHOOSE_NVHE_SYM(hyp_cpu_logical_map)
+
 struct vcpu_reset_state {
 	unsigned long	pc;
 	unsigned long	r0;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6a2f4e01b04f..836ca763b91d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -65,8 +65,6 @@ static bool vgic_present;
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
-extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
-
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -1602,7 +1600,7 @@ static void init_cpu_logical_map(void)
 	 * allow any other CPUs from the `possible` set to boot.
 	 */
 	for_each_online_cpu(cpu)
-		kvm_nvhe_sym(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
+		hyp_cpu_logical_map[cpu] = cpu_logical_map(cpu);
 }
 
 static bool init_psci_relay(void)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index cbab0c6246e2..2997aa156d8e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -14,14 +14,14 @@
  * Other CPUs should not be allowed to boot because their features were
  * not checked against the finalized system capabilities.
  */
-u64 __ro_after_init __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
+u64 __ro_after_init hyp_cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
 u64 cpu_logical_map(unsigned int cpu)
 {
-	if (cpu >= ARRAY_SIZE(__cpu_logical_map))
+	if (cpu >= ARRAY_SIZE(hyp_cpu_logical_map))
 		hyp_panic();
 
-	return __cpu_logical_map[cpu];
+	return hyp_cpu_logical_map[cpu];
 }
 
 unsigned long __hyp_per_cpu_offset(unsigned int cpu)
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 914732b88c69..70fcd6a12fe1 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -34,17 +34,16 @@ static u64 __early_kern_hyp_va(u64 addr)
 }
 
 /*
- * Store a hyp VA <-> PA offset into a hyp-owned variable.
+ * Store a hyp VA <-> PA offset into a EL2-owned variable.
  */
 static void init_hyp_physvirt_offset(void)
 {
-	extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
 	u64 kern_va, hyp_va;
 
 	/* Compute the offset from the hyp VA and PA of a random symbol. */
 	kern_va = (u64)lm_alias(__hyp_text_start);
 	hyp_va = __early_kern_hyp_va(kern_va);
-	CHOOSE_NVHE_SYM(hyp_physvirt_offset) = (s64)__pa(kern_va) - (s64)hyp_va;
+	hyp_physvirt_offset = (s64)__pa(kern_va) - (s64)hyp_va;
 }
 
 /*
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
