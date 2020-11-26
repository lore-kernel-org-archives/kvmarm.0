Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0F0C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B9EA21D46
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="srDcQuvU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B9EA21D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 200DF4C0D1;
	Thu, 26 Nov 2020 10:55:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BQIQWjjCQNJJ; Thu, 26 Nov 2020 10:55:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00D2C4BF7D;
	Thu, 26 Nov 2020 10:55:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6AA34BC6D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e7ZWlaN9NkKD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:55:16 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60B6F4C0CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:15 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id p8so2641380wrx.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=oyYLFWQZMneEnEj2VSn1LS09AGJVymYOLIqAbKZwt6U=;
 b=srDcQuvUhOpoS6XSk1yX5MJj4AVevyOIrmgCRMvuzNjXQLIIJpow8ZYVJGXOAFPuPp
 dWq6VKySkD2XWUUzXzIG2ru6B6Wv878jxXMs1gdAr3aqnnFjRuIcKatC3IvG5dnwH/Kd
 z4/S4ecfHLSdmxRm8YG5vzFFd23znMIXdf4yzi6tTZ9Ya3b7nLFTAFa+7ZDf7W6r4CWi
 EyPt3TlxjLEbVff+OZ+dGgaF0hP77PcnEgxL3ms/56P/1sF0YnhJdeaCxrk4u5MuDO/D
 tgXZVYJceqIWsNdo+g2jjh64bWPyb1+awZyn/9jfD5UZgLu8SmAj1gfMPiywgQmUfb17
 iqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=oyYLFWQZMneEnEj2VSn1LS09AGJVymYOLIqAbKZwt6U=;
 b=Qi1YZGDvNrlvrGJ+MbzQOAVIiDjlxsby3pkcgmh9HGwfKuCpHUC4SwBbAevc1jbhvy
 byf2RBaC7HaASIaStpANomi08Fxw27ZfYBXtsuzdyqCkFe4apx3EiRXCxpX0u1jnLnvf
 Q0KxTO8OMH0qq2FXJlR/mgWmWb+xgyM29nXw15Jgzgz0U/9f62MKURWmK6H7YhEyNu+2
 L94+HQYpTvrw7YVBcX96GBj/APldiIjfFGZCzd0wz9057s8q4Qn/mxmk+FofNhU1K0qb
 biUK4Z7RmWMIxNEK1pMnxym2urDTbfP7o0ivRjjRxMuftlwxALRSVKFdyYSO4qG3apEq
 2ztQ==
X-Gm-Message-State: AOAM533rBp6kM7xNsdjnEVhYhLLIrLwoAHnV7xjKvzBZhpFXn8U3DvK7
 N9hIYBL0NmJyOq7TdXJWRl1yB5X0DQcQO5HV
X-Google-Smtp-Source: ABdhPJyXJxAcdnGaEOLfWk+JL7WUP6NfvyxPJK4EaBXXt8h/6IhmFqWc5LMhe1Lrb0MJFulrnvz4kg==
X-Received: by 2002:a5d:46c6:: with SMTP id g6mr4819602wrs.170.1606406114096; 
 Thu, 26 Nov 2020 07:55:14 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id b4sm10161280wmc.1.2020.11.26.07.55.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:55:13 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 22/23] kvm: arm64: Trap host SMCs in protected mode
Date: Thu, 26 Nov 2020 15:54:20 +0000
Message-Id: <20201126155421.14901-23-dbrazdil@google.com>
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
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 10 ++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c   |  5 ++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

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
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index fbb195851fb9..7af18fa1983d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -88,6 +88,11 @@ SYM_CODE_END(__kvm_hyp_init)
  * x0: struct kvm_nvhe_init_params PA
  */
 SYM_CODE_START(___kvm_hyp_init)
+alternative_if ARM64_PROTECTED_KVM
+	mov_q	x1, HCR_HOST_NVHE_PROTECTED_FLAGS
+	msr	hcr_el2, x1
+alternative_else_nop_endif
+
 	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
 	msr	tpidr_el2, x1
 
@@ -233,6 +238,11 @@ reset:
 	msr	sctlr_el2, x5
 	isb
 
+alternative_if ARM64_PROTECTED_KVM
+	mov_q	x5, HCR_HOST_NVHE_FLAGS
+	msr	hcr_el2, x5
+alternative_else_nop_endif
+
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 3e50ff35aa4f..f3d0e9eca56c 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -97,7 +97,10 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
 
 	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
+	if (is_protected_kvm_enabled())
+		write_sysreg(HCR_HOST_NVHE_PROTECTED_FLAGS, hcr_el2);
+	else
+		write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
