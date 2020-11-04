Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890A0C55178
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0E8E20739
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="il549hLI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0E8E20739
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC884B7BA;
	Wed,  4 Nov 2020 13:37:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PQ8feyh3aonp; Wed,  4 Nov 2020 13:37:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B9AF4B80B;
	Wed,  4 Nov 2020 13:37:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB92D4B7BA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vpDy1IDnUHsf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:36 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9BCA4B7FE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:35 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id c17so3798664wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=HMYGIc+ZZLbnQbcx34p2ubDooBhnfGZkiSjL1q0xiNQ=;
 b=il549hLIFQg0qGoV2QrtJtovxpI7mz6Lm9xqwFQAuBrKk0Z6AC8ta8m/IhticSSWAg
 nunkDYzvs4sOKQEUNrHD/WF3I2uhhw/LMXkFntRbcYdyktGXJhujOyKn7jXnmAQUZjKX
 HWqGa+gOsc0TyXjwlKX20YcgvfXtgqTp7D+0BzkajGuiEkOeV+lo+Wug+iAynKlmeoIF
 fBs0MAQU3p+DN2M/yPDkSBwhSnnCxMkEh3Gygat3MvnDjwWQd21yPXJWRfdjbn8kXXgF
 Ja1pWoR4q5WXTD7ryuVkLcK79AhJCwCunoJp8jfhSnsqvKNqPlNwzC4naVUk6tC/hjBw
 D7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=HMYGIc+ZZLbnQbcx34p2ubDooBhnfGZkiSjL1q0xiNQ=;
 b=HUU9K699aJgDRG/QwcVXN2PDHx/8Mn7h82gxA26sTbrOu/kuse5HSwZnvpw/OiFX2t
 LymUFbqBzjgWsoNT+iw6PccUGZ1GicjlQCbmYP9cVpHcX9Ch5nSi1kBRIox12Dct8WG5
 u2FbTNtZNqNc6TTkkzVWyR8jykaMPXIF/pivA0jIKSksevpJYmi5a8DL4hx+NyKDL6co
 enqYU1vKs2SE7WarkLqAgrxb2ChACyZ092c6ggPmjq6d0z+3AsRGee1+kgbyXPxwlMrr
 zkvWrhbqzyJRdBvT/+sujpYf6NrPXxAUVRO1LSVch57oZ3/hYvXrLkM0pgMmWfuW+fzs
 Nw2Q==
X-Gm-Message-State: AOAM531Y8fWI1YZH836Z1wrVGVzHvPfmcInUbSk84O2xjSmYbEylTxFs
 6KrqqZZ+Ge+c7+xEIW6B1DqX66tvzi065C/6
X-Google-Smtp-Source: ABdhPJzPIMW7rJz/s7+my12k8/M0wSzNOf/au+3oC9aJIIDx/rVVLNmLVAtHZQ7yu1CygOZyQlw0UQ==
X-Received: by 2002:a5d:4a4b:: with SMTP id v11mr4973650wrs.364.1604515054453; 
 Wed, 04 Nov 2020 10:37:34 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id w11sm3705303wmg.36.2020.11.04.10.37.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:33 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 26/26] kvm: arm64: Fix EL2 mode availability checks
Date: Wed,  4 Nov 2020 18:36:30 +0000
Message-Id: <20201104183630.27513-27-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
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

With nVHE hyp code interception host's PSCI CPU_ON/OFF/SUSPEND SMCs,
from the host's perspective new CPUs start booting in EL1 while
previously they would have booted in EL2. The kernel logic which keeps
track of the mode CPUs were booted in needs to be adjusted to account
for this fact.

Add a static key enabled if KVM nVHE initialization is successful.

When the key is enabled, is_hyp_mode_available continues to report
`true` because its users either treat it a check whether KVM will be /
has been initialized, or whether stub HVCs can be made (eg. hibernate).

is_hyp_mode_mismatched is changed to report `false` when the key is
enabled. That's because all cores' modes matched at the point of KVM
init and KVM will not allow cores not present at init to boot. That
said, the function is never used after KVM is initialized.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/virt.h | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c          |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 6069be50baf9..597430b5f5aa 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -65,9 +65,18 @@ extern u32 __boot_cpu_mode[2];
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
 void __hyp_reset_vectors(void);
 
+DECLARE_STATIC_KEY_FALSE(kvm_nvhe_initialized);
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
+	/*
+	 * If KVM nVHE is initialized, all CPUs must have been booted in EL2.
+	 * Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
+	 */
+	if (IS_ENABLED(CONFIG_KVM) && static_branch_unlikely(&kvm_nvhe_initialized))
+		return true;
+
 	return (__boot_cpu_mode[0] == BOOT_CPU_MODE_EL2 &&
 		__boot_cpu_mode[1] == BOOT_CPU_MODE_EL2);
 }
@@ -75,6 +84,13 @@ static inline bool is_hyp_mode_available(void)
 /* Check if the bootloader has booted CPUs in different modes */
 static inline bool is_hyp_mode_mismatched(void)
 {
+	/*
+	 * If KVM nVHE is initialized, all CPUs must have been booted in EL2.
+	 * Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
+	 */
+	if (IS_ENABLED(CONFIG_KVM) && static_branch_unlikely(&kvm_nvhe_initialized))
+		return false;
+
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3dff6af69eca..e93956d6235d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,8 @@
 __asm__(".arch_extension	virt");
 #endif
 
+DEFINE_STATIC_KEY_FALSE(kvm_nvhe_initialized);
+
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
@@ -1841,6 +1843,9 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_hyp;
 
+	if (!in_hyp_mode)
+		static_branch_enable(&kvm_nvhe_initialized);
+
 	if (in_hyp_mode)
 		kvm_info("VHE mode initialized successfully\n");
 	else
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
