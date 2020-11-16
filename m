Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406CFC63798
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CBA8522240
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="h35rLEUq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBA8522240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E2404C103;
	Mon, 16 Nov 2020 15:44:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bK9GypPfXTte; Mon, 16 Nov 2020 15:44:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 421714C195;
	Mon, 16 Nov 2020 15:44:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 338794B87F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0oQWIms09q+D for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:44:16 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 217FD4C25A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:15 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id 10so602933wml.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=atsDjx/TzGfxVZgd6hTk0EAv0F2OT5jr+J2cgmZ2xFY=;
 b=h35rLEUqBFivWJURPalCErJ0No6DR5+PK0ffG8XVdL6zUlUrYdObTEz/xhcUIbbXvN
 bT16OoQVKSz1vAepCnSmD13fwkILI+1lAnLYb7aVBFpGbWcDM2Q7aiqidsAFZOjRQaZg
 Me0EqWX07U8NpONGPrFDoZIvHZ31g16eI++TBHHLBM2kraF7Zqe7anwhiHlv3eW1u3l9
 kLTMw7nFFrPSkjnJ6Y0Li30dnpw/zkH4N1CU7n7h5DWJ/k/pmQOoMJiOnliC/ltLfvBQ
 btiN0VcHK9tInQa6ELnxeP1Um1+hErUSvgPBa0GS7icfaYlQ3UNsD4HSaSGcFpn7avLz
 UDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=atsDjx/TzGfxVZgd6hTk0EAv0F2OT5jr+J2cgmZ2xFY=;
 b=ku6foiy34tQ9GRBn0mVzXzPSEYoy9zHfAx6Iq5Ban2h1utdAOIk4mwW/MRYbBOt1QC
 ocFED7CE4d/oTkqEJp7+19lWK6U6OeyC2rAWA5sxGNPW8nvRI0iT5RCsrd3956ocA2XS
 7ZiqzUV2sz4Mazh6w+H0L/6sYJ5F3ZJv4BVBR68UydtWonEmUjWmP40NrSlxOAhoUDo6
 N/OZAkbX6kAjJSJpisXzz9ZvDg+b5X3J34iif1AbN3ZAcOIbGMhXVgLxp7RRqXAm+UJI
 C8VyF9hdNGU24Kkd+rdB4lktXhEsjBeQZz0vHXU/GXT1YMsjlStPzqGOcdaCTkXMglvy
 XCgg==
X-Gm-Message-State: AOAM530iE/ra9mqPvWfBYWqEyUzzsXucp7U1Hsr0XgouPjt1v/hJ+EjI
 hTTA4k2i0zq5yuD+wyBDXQ6nxnu3Kb7OUH/AcMo=
X-Google-Smtp-Source: ABdhPJwozD4XyGSV4KXI+UXJz9WG5MB6TEAe9AMEW6YkhUBIyX0FL3Gr3dxN7wPhJJG4wCepksmk0w==
X-Received: by 2002:a7b:c1ce:: with SMTP id a14mr663097wmj.169.1605559453768; 
 Mon, 16 Nov 2020 12:44:13 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id 90sm3958005wrl.60.2020.11.16.12.44.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:44:12 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 24/24] kvm: arm64: Fix EL2 mode availability checks
Date: Mon, 16 Nov 2020 20:43:18 +0000
Message-Id: <20201116204318.63987-25-dbrazdil@google.com>
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
index 45bc7a6b9e0b..b86d0b38f30b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,8 @@
 __asm__(".arch_extension	virt");
 #endif
 
+DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
+
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
@@ -1837,12 +1839,14 @@ int kvm_arch_init(void *opaque)
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
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
