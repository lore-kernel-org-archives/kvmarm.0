Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B05AC64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9275A2224B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9275A2224B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B4C4B363;
	Wed,  2 Dec 2020 13:41:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RQa1U-RrF4qP; Wed,  2 Dec 2020 13:41:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97E264B384;
	Wed,  2 Dec 2020 13:41:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F21314B2CE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lEKuwOtYQnv1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:41:34 -0500 (EST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5706E4B408
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:33 -0500 (EST)
Received: by mail-wr1-f42.google.com with SMTP id o1so5161673wrx.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=g69TmuIpp+vIm9gRxx12Sh909+m1H1PrZL1qc3JkdQk=;
 b=WYFmGcSaH/wz/SlleIW3Mcu5nmwmv1kNPSQebgDZz+0eL3IjEcwWqvN80s834KuWzR
 RT3hly6g09zu5fWXVEkuV1YdbuzgldYW+V/8twi8l0yx8axbff8Ape8T/NR3v99S/UFx
 UBu7/c8XKsJf4vxFX3puM6VjMfdo+TmAE6IxE4Ang8fcy12BxnfTtg1FdTdeE6rwEhoS
 YanICjQ8vrCn3rOi1TLnMIhFRy3x7EV/7Dv4MoeSNLxZ2KVazRSH0LJ7mbdhEaezvCt5
 1ytVx/ay9QHVAw3P76uQzTzAv86K6uXZ8g0VqxbV1fUq1XJEGMtJpcjaVOearI/QMSyk
 P8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=g69TmuIpp+vIm9gRxx12Sh909+m1H1PrZL1qc3JkdQk=;
 b=Vbu/dGcGMD1YEFw8QvvjRmTA/zZ4c3Y5uOvEJfMblTDkhsgt7S84ydaYPvCrPDawhb
 uwUjaWREVGkWHB6jTFqvopoMObY8lK6uOUcfdZLq9aJcY6UU/ebCTr81pDAkA58W9C3X
 bsb47AFGW1GVKngweqME63ecgWCwbit+KgmuU1DIS10xNvWtX3RVYCRC7isUfiYl2GK2
 L5R73T21Pd1KGGC7h6bOx1tGTyL72t6Tcy4qjF1kqZ25RMAjjG9MESakt1N1YZ/GlIgi
 bzGoY7iy50dqPQ7kjXt9EtoPDbf0b4obV4jn5lw2cMzUFXFpf1OzNNCIuKx9RZQzFpDm
 37Bg==
X-Gm-Message-State: AOAM5323N6bqcNd6SzJf/XkvhiGN222FT10dKLVfZGOr3mCY1nZMu3A4
 5iBXtYVEHEvUreqqvFuA6MCDsdefZuGGbA==
X-Google-Smtp-Source: ABdhPJxLt3JxRj6qOSsRATpU04zggeVJmgFS/y1Rt/TDhlt67MX8xTg5Vhhj21UyUIwOKHqvCPeRjQ==
X-Received: by 2002:adf:dec1:: with SMTP id i1mr4974199wrn.129.1606934491590; 
 Wed, 02 Dec 2020 10:41:31 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id k205sm3004907wmk.4.2020.12.02.10.41.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:30 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 02/26] kvm: arm64: Add ARM64_KVM_PROTECTED_MODE CPU
 capability
Date: Wed,  2 Dec 2020 18:40:58 +0000
Message-Id: <20201202184122.26046-3-dbrazdil@google.com>
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

Expose the boolean value whether the system is running with KVM in
protected mode (nVHE + kernel param). CPU capability was selected over
a global variable to allow use in alternatives.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/cpucaps.h  |  3 ++-
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/virt.h     |  8 ++++++++
 arch/arm64/kernel/cpufeature.c    | 22 ++++++++++++++++++++++
 arch/arm64/kvm/arm.c              |  9 ++++++++-
 5 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 162539d4c8cd..42f850718d4b 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -66,7 +66,8 @@
 #define ARM64_HAS_TLB_RANGE			56
 #define ARM64_MTE				57
 #define ARM64_WORKAROUND_1508412		58
+#define ARM64_KVM_PROTECTED_MODE		59
 
-#define ARM64_NCAPS				59
+#define ARM64_NCAPS				60
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bca38ccade58..11beda85ee7e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -58,6 +58,7 @@ enum kvm_mode {
 	KVM_MODE_DEFAULT,
 	KVM_MODE_PROTECTED,
 };
+enum kvm_mode kvm_get_mode(void);
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 6069be50baf9..eb81dcc220b6 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -97,6 +97,14 @@ static __always_inline bool has_vhe(void)
 		return cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN);
 }
 
+static __always_inline bool is_protected_kvm_enabled(void)
+{
+	if (is_vhe_hyp_code())
+		return false;
+	else
+		return cpus_have_final_cap(ARM64_KVM_PROTECTED_MODE);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* ! __ASM__VIRT_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 280b10762f6b..5f9e557fa1f7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -74,6 +74,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
 #include <asm/fpsimd.h>
+#include <asm/kvm_host.h>
 #include <asm/mmu_context.h>
 #include <asm/mte.h>
 #include <asm/processor.h>
@@ -1709,6 +1710,21 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 }
 #endif /* CONFIG_ARM64_MTE */
 
+#ifdef CONFIG_KVM
+static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
+{
+	if (kvm_get_mode() != KVM_MODE_PROTECTED)
+		return false;
+
+	if (is_kernel_in_hyp_mode()) {
+		pr_warn("Protected KVM not available with VHE\n");
+		return false;
+	}
+
+	return true;
+}
+#endif /* CONFIG_KVM */
+
 /* Internal helper functions to match cpu capability type */
 static bool
 cpucap_late_cpu_optional(const struct arm64_cpu_capabilities *cap)
@@ -1822,6 +1838,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR0_EL1_SHIFT,
 		.min_field_value = ID_AA64PFR0_EL1_32BIT_64BIT,
 	},
+	{
+		.desc = "Protected KVM",
+		.capability = ARM64_KVM_PROTECTED_MODE,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = is_kvm_protected_mode,
+	},
 #endif
 	{
 		.desc = "Kernel page table isolation (KPTI)",
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 01cf6ac5b2cb..d9e8d7dc7e11 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1849,7 +1849,9 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_hyp;
 
-	if (in_hyp_mode)
+	if (is_protected_kvm_enabled())
+		kvm_info("Protected nVHE mode initialized successfully\n");
+	else if (in_hyp_mode)
 		kvm_info("VHE mode initialized successfully\n");
 	else
 		kvm_info("Hyp mode initialized successfully\n");
@@ -1884,6 +1886,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 }
 early_param("kvm-arm.mode", early_kvm_mode_cfg);
 
+enum kvm_mode kvm_get_mode(void)
+{
+	return kvm_mode;
+}
+
 static int arm_init(void)
 {
 	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
