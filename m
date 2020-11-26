Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1428C63798
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 875B121D40
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QM/rbtXw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 875B121D40
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5584BEA7;
	Thu, 26 Nov 2020 10:55:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qVB4O7UI4lVH; Thu, 26 Nov 2020 10:55:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DB924C030;
	Thu, 26 Nov 2020 10:55:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1403D4B9FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id avuBI4lWYWpS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:55:19 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F7974C10E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:18 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id 10so2566774wml.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=aOLJOeUdUyn9Tp5EB3J9cYHwXErbIHpd/Aan89z6ZHs=;
 b=QM/rbtXwOgu6dblgPCWfx4ngm1/thgvoQ0YW4L2bPmt43izjfGp+feFlrQOkpQS9Om
 6IyiMWQDM9+9UTy3hB+J5mL08+VjIOU0v7HHn2JQNnWZfWWWlGmxzXwQJ5YeUMP4URzL
 1QtnGLr7B86YDgrOowd0eJ/ZlG7g90/JdTPeSBg4Np5jEsxeOF3riX5Aj+ZJnFB1nucH
 eGRGKeHAcqx9n6NEDtpKYSogxV+eRc23vpbWc9NRm5ShbBf3SY7zuFqqGKiDs+I9VeCG
 lbM65gvfMyzKPRVDcbtqP39F0X2J1baGFNxxaE1G/RusVZXby+KoCinFSOxt/dKolC8/
 f6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=aOLJOeUdUyn9Tp5EB3J9cYHwXErbIHpd/Aan89z6ZHs=;
 b=aLwYDoj50o/ixfbK++yjZ2wgCx/ybfQsEm5zNrFwA/PjdnAZ4ob5cO+IyKm2e7m98y
 zolpxjMFnLbse3nMK+hnI+aEufwYRsptkaNx7aA1wy4v3n3Cq59bcuNIVZr0dITDaP/z
 H7UgwLkpj9TO+q3ynVUeVyX0DcJiMb91MkMx+oJJNXpdVIIk5wVaWZvlgX3FxzRi6Xmj
 belATFqbUO9jDJfaJwxG4WIKxBxYGKl4UZPZvbWKIs7lCrTDxMfoaNSc4WT+2vvFeQ/r
 fqc8PLjXoQa9gcGAakCCByZiOtYh2lRgZvZlYs0IRItHaO/57yiAEYLjxt+GQVL1jrj2
 gjfw==
X-Gm-Message-State: AOAM5305u6U3EaumgXLmpquJJXTEPW2bZU5m2JGOxlbESv8lYDYBe3o+
 sAerDZlOBW0j8k2tzDWeUycVYSG8OykfMk/f
X-Google-Smtp-Source: ABdhPJxNaayzFy0JXM9EQDhPZc7SkErVTVeHwN5g49VsWueupWVWXJ57HuFtoPXgm7dm47oDpr8iqg==
X-Received: by 2002:a1c:bd08:: with SMTP id n8mr4124459wmf.136.1606406116246; 
 Thu, 26 Nov 2020 07:55:16 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id j4sm9290305wrn.83.2020.11.26.07.55.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:55:15 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 23/23] kvm: arm64: Fix EL2 mode availability checks
Date: Thu, 26 Nov 2020 15:54:21 +0000
Message-Id: <20201126155421.14901-24-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
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

With protected nVHE hyp code interception host's PSCI CPU_ON/SUSPEND
SMCs, the host starts seeing new CPUs boot in EL1 instead of EL2. The
kernel logic that keeps track of the boot mode needs to be adjusted.

Add a static key enabled if KVM protected nVHE initialization is
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
 arch/arm64/kvm/arm.c          | 10 +++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 2fde1186b962..f7cf3f0e5297 100644
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
index 6ec8ddf74643..b153c08e50fa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,6 +46,8 @@
 __asm__(".arch_extension	virt");
 #endif
 
+DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
+
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
@@ -1877,12 +1879,14 @@ int kvm_arch_init(void *opaque)
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
