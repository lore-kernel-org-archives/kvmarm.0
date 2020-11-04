Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DA2C2D0A3
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD47F20780
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="B4IhEM6i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD47F20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DD324B543;
	Wed,  4 Nov 2020 13:37:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xJNCf9978q9I; Wed,  4 Nov 2020 13:37:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 374364B800;
	Wed,  4 Nov 2020 13:37:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C22C4B6E6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RlPTizRcavdq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:34 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B85724B781
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:33 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id x7so23175755wrl.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=iZCBnLMJdYcxZwBzQ3Sarf0ddb9E9I/tpQ6NvhqLTsI=;
 b=B4IhEM6i7eYAD2ymU3gP34oS4vn1E/wZkt1PdaiPM5/5CtTpRosOvwsKQKo0X96cCK
 0+g8w1fiydBxSAvZustLDS0jWbYdNwVoVeSGiVp01VErE+3NmXu2Zguj4zhDd3RQwoNG
 en6FWwAw0dLaqo1BuTfum7Ta4FxBg0BjZWLF6bqxR53vkiKPlHv0os4fdHkCfVcSOUha
 CL9qYevzyEmHuWS9pBv5RwzPROVRKDWww8V+k967+KldgQKur4GRkaO8J8q5SOBxRSpK
 YvVewWO1VZib5H/HpCQ7HbmNXpRdZWPNttE3mKM8sUogeVrex2BX1GvjsLxVqnF1JotD
 ALOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=iZCBnLMJdYcxZwBzQ3Sarf0ddb9E9I/tpQ6NvhqLTsI=;
 b=TTPhjisvb7R2cQsCZfO5OMz5VA/OvRIzGR3MJdxvaA0ppTjqnLNyu5Q86EoiSFMYXv
 FNuO+GJKAzqc1UR80SDhJbz3HsxDxOfO/9SBHWS0ZirlFUdosGrUs35yuqx9qlC1G0mt
 itht5wDmL/xi95FbDLTnIOoCShBxQYSwNIKBwuu05B5Sfkx99CI9RQrt12ydrJWdRBrR
 /MYBaUbh5RTSxM3f25GF4rfe2CvJQePntO+co7x6RMLLJqGGhZcFSNdNwMhpJ/xnOlEV
 eJizmuOinwfzq0D4tWX+SM62t39JU2RdPg44KF9r0wo7sSnYQgfe/X6a716Bbx706gFd
 UKvQ==
X-Gm-Message-State: AOAM533iCKnzkRFORkDjQAY3s7yuGmEL0VqxGHOzVpt983HcKyI8n2Xw
 rL1SGqrAE3i8Rl52SWKykmJ06KutSK1dq+Jg
X-Google-Smtp-Source: ABdhPJwUdVDMguoQlzBKa3UHyXk6rhVG7P6EPtc5ja0S5UDbXD4NiQS5VqgFkkGyhfeVbjM4nCuCpA==
X-Received: by 2002:adf:fe48:: with SMTP id m8mr33208177wrs.127.1604515052352; 
 Wed, 04 Nov 2020 10:37:32 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id r10sm3396829wmg.16.2020.11.04.10.37.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:31 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 25/26] kvm: arm64: Trap host SMCs
Date: Wed,  4 Nov 2020 18:36:29 +0000
Message-Id: <20201104183630.27513-26-dbrazdil@google.com>
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

While nVHE KVM is installed, start trapping all host SMCs. By default,
these are simply forwarded to EL3, but PSCI SMCs are validated first.

Create new constant HCR_HOST_NVHE_STUB_FLAGS with the old set of HCR
flags to use before the nVHE vector is installed or when switching back
to stub vector.

Extend HCR_HOST_NVHE_FLAGS to contain HCR_TSC. Set HCR_EL2 to it before
installing nVHE vector.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_arm.h   | 3 ++-
 arch/arm64/kernel/head.S           | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 6 ++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 64ce29378467..04b862955f32 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -79,7 +79,8 @@
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
-#define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
+#define HCR_HOST_NVHE_STUB_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
+#define HCR_HOST_NVHE_FLAGS (HCR_HOST_NVHE_STUB_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index e7270b63abed..ea17413a04e0 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -522,7 +522,7 @@ SYM_FUNC_START(el2_setup)
 #endif
 
 SYM_INNER_LABEL(el2_setup_nvhe, SYM_L_LOCAL)
-	mov_q	x0, HCR_HOST_NVHE_FLAGS
+	mov_q	x0, HCR_HOST_NVHE_STUB_FLAGS
 	msr	hcr_el2, x0
 	isb
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index dd297a1a8f82..97684deba6c1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -88,6 +88,10 @@ SYM_CODE_END(__kvm_hyp_init)
  * x0: struct kvm_nvhe_init_params PA
  */
 SYM_CODE_START(___kvm_hyp_init)
+	mov_q	x1, HCR_HOST_NVHE_FLAGS
+	msr	hcr_el2, x1
+	isb
+
 	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
 	msr	tpidr_el2, x1
 
@@ -220,6 +224,8 @@ reset:
 	bic	x5, x5, x6		// Clear SCTL_M and etc
 	pre_disable_mmu_workaround
 	msr	sctlr_el2, x5
+	mov_q	x5, HCR_HOST_NVHE_STUB_FLAGS
+	msr	hcr_el2, x5
 	isb
 
 	/* Install stub vectors */
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
