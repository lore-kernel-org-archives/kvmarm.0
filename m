Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9ADC71155
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84698206D5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84698206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09F4B4B333;
	Wed,  2 Dec 2020 13:41:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sCYvGB0jb0vj; Wed,  2 Dec 2020 13:41:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 749974B40A;
	Wed,  2 Dec 2020 13:41:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12DAD4B36D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zTOG43zWXg5R for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:41:31 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 025A84B2CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:30 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id h21so11162027wmb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Qy+VUI9BXr6HazxoMIsIcdlYXr2Zkw6Es0halgF2Fhw=;
 b=UAOOKMnPkO17JoHDZkxjQgAVO6zpGftV0wvNiSWjhlY7kOwOa1zo2h+ivb22qOwe+V
 OUeZ1kaZ2iuLe85sH3vKir/PolrJozCc8f5BEnZclJqkMHEnPBBe5RIxS54Uily8MPnK
 2Y1SjWE7pmPOCzK4bYInNyWMy9kenBr5/8ZdVX5elM6EWvAO1SdjrF2QGFKXUd9OqCb+
 NtIQnngm0PfEs5d3IgcTf7LhfVPkIPloHQMtfhVabrq5N7Rf/Jb5NOWKYhZgULgWXKhE
 BGxNfajR8eczlwMYDG1uEtwk+bce5hnubdI0gY+5v+YfNSeDCieQsZ2WmyKqfSlr+VD/
 1/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Qy+VUI9BXr6HazxoMIsIcdlYXr2Zkw6Es0halgF2Fhw=;
 b=U2RrAsLtW4+DSe15ZWNZ7DbXBUuoCkxcgkIBdlrGRybYVErQm7HNKc3H7vgREFkfTg
 IXVhAG7/XQVwwBpKmthE/aVMS5qg3K5nWgQ+F+ZcWFDi1F8bj1uaCFLDtk3xt7pqle99
 klhGvaEuDl3wbFPlDMdhkMUPeLm7Z/p1pAV/Je0CUMz2fBugsH6tPYBn9rwX6i6Ocw0w
 tkaR0VJjA17PZ8povuXBH5MN9TY3kPCWJrX24lWpUtaevjSbfBH4AhQM4rnCWa54TvVr
 GFki08Gw4xPOx3sC8ltcwT3Zp9l1vluyLmd1DgCDR0Pthnoa+pf3VJPY7cZ5F7cYsSML
 jnlQ==
X-Gm-Message-State: AOAM532KzYswhJPquDU/hyfPxK0Hp4c3xcXPl8jt9zA62zGsUFw0GaJ5
 jjnGpqh7Gi+1rMkYD0ZSM7ezjApMemVuJg==
X-Google-Smtp-Source: ABdhPJx5dw7ns+PEDpJmj41ddtOfdNs+k8f+Q+FRgiqp1pfkmjrl7qaCK6KSXenVzyoYRhNeR59CDw==
X-Received: by 2002:a1c:b402:: with SMTP id d2mr4422934wmf.38.1606934489275;
 Wed, 02 Dec 2020 10:41:29 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id o13sm2910262wmc.44.2020.12.02.10.41.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:28 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 01/26] kvm: arm64: Add kvm-arm.mode early kernel parameter
Date: Wed,  2 Dec 2020 18:40:57 +0000
Message-Id: <20201202184122.26046-2-dbrazdil@google.com>
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

Add an early parameter that allows users to select the mode of operation
for KVM/arm64.

For now, the only supported value is "protected". By passing this flag
users opt into the hypervisor placing additional restrictions on the
host kernel. These allow the hypervisor to spawn guests whose state is
kept private from the host. Restrictions will include stage-2 address
translation to prevent host from accessing guest memory, filtering its
SMC calls, etc.

Without this parameter, the default behaviour remains selecting VHE/nVHE
based on hardware support and CONFIG_ARM64_VHE.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 10 ++++++++++
 arch/arm64/include/asm/kvm_host.h               |  9 +++++++++
 arch/arm64/kvm/arm.c                            | 16 ++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 526d65d8573a..ee9f13776388 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2259,6 +2259,16 @@
 			for all guests.
 			Default is 1 (enabled) if in 64-bit or 32-bit PAE mode.
 
+	kvm-arm.mode=
+			[KVM,ARM] Select one of KVM/arm64's modes of operation.
+
+			protected: nVHE-based mode with support for guests whose
+				   state is kept private from the host.
+				   Not valid if the kernel is running in EL2.
+
+			Defaults to VHE/nVHE based on hardware support and
+			the value of CONFIG_ARM64_VHE.
+
 	kvm-arm.vgic_v3_group0_trap=
 			[KVM,ARM] Trap guest accesses to GICv3 group-0
 			system registers
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21ce5c420247..bca38ccade58 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -50,6 +50,15 @@
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
 
+/*
+ * Mode of operation configurable with kvm-arm.mode early param.
+ * See Documentation/admin-guide/kernel-parameters.txt for more information.
+ */
+enum kvm_mode {
+	KVM_MODE_DEFAULT,
+	KVM_MODE_PROTECTED,
+};
+
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int kvm_sve_max_vl;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7e86207fa2fc..01cf6ac5b2cb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -45,6 +45,8 @@
 __asm__(".arch_extension	virt");
 #endif
 
+static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
+
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
@@ -1868,6 +1870,20 @@ void kvm_arch_exit(void)
 	kvm_perf_teardown();
 }
 
+static int __init early_kvm_mode_cfg(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp(arg, "protected") == 0) {
+		kvm_mode = KVM_MODE_PROTECTED;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+early_param("kvm-arm.mode", early_kvm_mode_cfg);
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
