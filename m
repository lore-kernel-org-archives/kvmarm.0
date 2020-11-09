Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9E0C388F7
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E40AE206ED
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="iAn2GzCf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E40AE206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82CEA4B4DF;
	Mon,  9 Nov 2020 06:33:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cj2vQvDcRmlT; Mon,  9 Nov 2020 06:33:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 571DA4B4E1;
	Mon,  9 Nov 2020 06:33:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AC004B829
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AsvayeIINIyN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:31 -0500 (EST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35AB44B771
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:30 -0500 (EST)
Received: by mail-wr1-f52.google.com with SMTP id d12so6789350wrr.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=TSwlUknyxMEI+6/IdIE7BFo27ktFepUyPMrayg9jAhU=;
 b=iAn2GzCfxNArh5CKayH8Vx8icaJ2i4fbykQO1kjXT9qJmzxGyHErFl5pAdrOwyItSF
 n61YAtEdFpK5GaHftfHCQeRp6ATxUD5xTKpJupnh7JfzXWnKshJWUdT6f7nOvBuZeX6g
 SGTh0c59Oy/Ar+Y5/KK20aP3f4pCWGqiLNdyaUMbq443GYcVvqwIsQ966yMSdc2E8cID
 3Mp9gTu52MoliwQgaKBilPbbycLyb+QisomKBY6VpW2r03L+l2WHjFsB8xxFhUSYzL8X
 A+z31ZTD4ZKDaaSAqD/uCOOH17EhMAWrV29kZe3P9LTQG8LRF2/gL4x0aWTjBkB3TWgg
 CJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=TSwlUknyxMEI+6/IdIE7BFo27ktFepUyPMrayg9jAhU=;
 b=EK3l0naa4DAZOACwnRO0SQ2CeR3zKt/jhBspktjt+M8z46sG6taCgMm8s50lHB1BCw
 unics2vaUmFBkFEoSw42fOXZsJOhPDTGVH5k0XF2A+nGVC45gp6xr4AkLwsWPhgre/nD
 Pb66gsTNqRUUekcTZob2tujqtVJ7N83re/6j8pKi4ND6GX9KFyigS95XMzccAYez35//
 l2D6HSjMLhqqbrnGwi+naMnGe1cVVGIeQWtE5MLu3CP6Gm96WzNiDYkfxl2/izYUgg23
 TBX0iNP472nJcAeJrfSNJe93C+Ct7B1MZsnbnnYC1Lue1GgOhKyi/b2wRGWBUh+yQLPk
 /spw==
X-Gm-Message-State: AOAM531NSWLLiAhfLN9bsHUzSVzOJNU4bmYLO9Ia59JaJ6+n6Gyym+B8
 NH4MkiUC1YoL32A8HQN9e7cAtJUkSgy/d3e/
X-Google-Smtp-Source: ABdhPJxh4X0Ke2rWDYUSFAfru62h5H3hy1NB0X1m0Pp9aNMnCDnQcDcDX1PGxexIachYDmdrHQtBjQ==
X-Received: by 2002:a5d:6ca6:: with SMTP id a6mr17360696wra.348.1604921608925; 
 Mon, 09 Nov 2020 03:33:28 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id z19sm12507964wmk.12.2020.11.09.03.33.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:28 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 24/24] kvm: arm64: Fix EL2 mode availability checks
Date: Mon,  9 Nov 2020 11:32:33 +0000
Message-Id: <20201109113233.9012-25-dbrazdil@google.com>
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

With protected nVHE hyp code interception host's PSCI CPU_ON/OFF/SUSPEND
SMCs, from the host's perspective new CPUs start booting in EL1 while
previously they would have booted in EL2. The kernel logic which keeps
track of the mode CPUs were booted in needs to be adjusted to account
for this fact.

Add a static key enabled if KVM protected nVHE initialization is
successful.

When the key is enabled, is_hyp_mode_available continues to report
`true` because its users either treat it a check whether KVM will be /
has been initialized, or whether stub HVCs can be made (eg. hibernate).

is_hyp_mode_mismatched is changed to report `false` when the key is
enabled. That's because all cores' modes matched at the point of KVM
init and KVM will not allow cores not present at init to boot. That
said, the function is never used after KVM is initialized.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/virt.h | 17 +++++++++++++++++
 arch/arm64/kvm/arm.c          |  9 ++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 2c3124512c00..8159d6010f4b 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -66,10 +66,19 @@ void __hyp_set_vectors(phys_addr_t phys_vector_base);
 void __hyp_reset_vectors(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode);
+DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
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
@@ -77,6 +86,14 @@ static inline bool is_hyp_mode_available(void)
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
index c09b95cfa00a..9a2329c92a01 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -48,6 +48,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode);
+DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
@@ -1838,12 +1839,14 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_hyp;
 
-	if (is_kvm_protected_mode())
+	if (is_kvm_protected_mode()) {
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
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
