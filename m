Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6D0C71156
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B93422240
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="oc+9V2yp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B93422240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 094584C295;
	Mon, 16 Nov 2020 15:44:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wBnYU165tFCq; Mon, 16 Nov 2020 15:44:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D75034C291;
	Mon, 16 Nov 2020 15:44:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E8B74B87E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R4JtoBoCgZVS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:44:10 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA50E4C27F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:08 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id b6so20286800wrt.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=/b5jsmdQhqUsP3iV70g55rFSHyU2Npcyd/L9vacP6Sc=;
 b=oc+9V2ypjwDCQSX2JHTAUt2BRrwLY8+/3AfQMXK5Z0Iol0FtYMP/CKLPK8bKmUQZvh
 n5+acER6e/irmEd8g0uLmW/xNvXzj2WKzpiGA6jYjSymV14pdrfyLbEz3ZtYAii8wShj
 /dXq9ek07rghShp0XHB9LewTzzK1hhaoXzzrI8TkJ1lGuFccEL7OaE7MpK2oYK+/aaPK
 lOCRmbOU+0u/88UkaXdx99xG6hhInjJ/FzGNatUi9toC1gXeLTKGJIAslARrRveo8IYQ
 gyTuw2WWOgwRC8imlFRYSfNuXhxZ53O6BGCOSj9FHkFq5jDJP1SbHqYFU2rQlKoJCBQw
 pM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=/b5jsmdQhqUsP3iV70g55rFSHyU2Npcyd/L9vacP6Sc=;
 b=Vg/H2B6q1YQu6J2s8cyXN1Zf3O0q+VspHzBpawBq5xnMm6vB3d95HxPvoQBSU45Qz8
 937EIhJGXFefLAhnMoYhbLwwIl14h8MV4AjyGTwv6XcMyrxXWdTXMDR2u5quDXs+s8f4
 722onRgox9Kl6K/Uc+vcZg4jXvxUqYmXsKqQw6nRDVcoynqzt6Ep/QrEa3xWVuzv5AMd
 8UUwUZTDx7cOR0HpZ9sNP+gfBboxzKrrC4CUGjTIH6A7ZisnZfm2QeRBIjzACmSflC6o
 OSDVeNindN2GDBs2AkJq86mDOujAi6uPpCx4/kVhrOsS9RFYi2L2cgGFx/MdzEGVCWxD
 Nc7A==
X-Gm-Message-State: AOAM533sncjffUskOdy447OlOr6LvYCLPu7KhFmUCnSYrIICtreQ3Q47
 hGeLTAqyfx+JMPd2WHWzu9PBXO7sQ5lasBUhCgg=
X-Google-Smtp-Source: ABdhPJwioNxTaew/6UynUWUqW3NRa5PGrRoMP1SYBFly6NWT6QRM6TZUt8ZXOODPLV9EiV/5CLUuBQ==
X-Received: by 2002:a5d:4ec2:: with SMTP id s2mr21177611wrv.258.1605559447503; 
 Mon, 16 Nov 2020 12:44:07 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id c2sm26308586wrf.68.2020.11.16.12.44.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:44:06 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 21/24] kvm: arm64: Add kvm-arm.protected early kernel
 parameter
Date: Mon, 16 Nov 2020 20:43:15 +0000
Message-Id: <20201116204318.63987-22-dbrazdil@google.com>
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

Add an early parameter that allows users to opt into protected KVM mode
when using the nVHE hypervisor. In this mode, guest state will be kept
private from the host. This will primarily involve enabling stage-2
address translation for the host, restricting DMA to host memory, and
filtering host SMCs.

Capability ARM64_PROTECTED_KVM is set if the param is passed, CONFIG_KVM
is enabled and the kernel was not booted with VHE.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/virt.h    |  8 ++++++++
 arch/arm64/kernel/cpufeature.c   | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c             | 10 +++++++++-
 4 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index e7d98997c09c..ac075f70b2e4 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -66,7 +66,8 @@
 #define ARM64_HAS_TLB_RANGE			56
 #define ARM64_MTE				57
 #define ARM64_WORKAROUND_1508412		58
+#define ARM64_PROTECTED_KVM			59
 
-#define ARM64_NCAPS				59
+#define ARM64_NCAPS				60
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 6069be50baf9..2fde1186b962 100644
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
+		return cpus_have_final_cap(ARM64_PROTECTED_KVM);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* ! __ASM__VIRT_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6f36c4f62f69..dd5bc0f0cf0d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1709,6 +1709,29 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 }
 #endif /* CONFIG_ARM64_MTE */
 
+#ifdef CONFIG_KVM
+static bool enable_protected_kvm;
+
+static bool has_protected_kvm(const struct arm64_cpu_capabilities *entry, int __unused)
+{
+	if (!enable_protected_kvm)
+		return false;
+
+	if (is_kernel_in_hyp_mode()) {
+		pr_warn("Protected KVM not available with VHE\n");
+		return false;
+	}
+
+	return true;
+}
+
+static int __init early_protected_kvm_cfg(char *buf)
+{
+	return strtobool(buf, &enable_protected_kvm);
+}
+early_param("kvm-arm.protected", early_protected_kvm_cfg);
+#endif /* CONFIG_KVM */
+
 /* Internal helper functions to match cpu capability type */
 static bool
 cpucap_late_cpu_optional(const struct arm64_cpu_capabilities *cap)
@@ -1822,6 +1845,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR0_EL1_SHIFT,
 		.min_field_value = ID_AA64PFR0_EL1_32BIT_64BIT,
 	},
+	{
+		.desc = "Protected KVM",
+		.capability = ARM64_PROTECTED_KVM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_protected_kvm,
+	},
 #endif
 	{
 		.desc = "Kernel page table isolation (KPTI)",
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c76a8e5bd19c..49d2474f2a80 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1796,6 +1796,12 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	/* The PROTECTED_KVM cap should not have been enabled for VHE. */
+	if (in_hyp_mode && is_protected_kvm_enabled()) {
+		kvm_pr_unimpl("VHE protected mode unsupported, not initializing\n");
+		return -ENODEV;
+	}
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
@@ -1827,7 +1833,9 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_hyp;
 
-	if (in_hyp_mode)
+	if (is_protected_kvm_enabled())
+		kvm_info("Protected nVHE mode initialized successfully\n");
+	else if (in_hyp_mode)
 		kvm_info("VHE mode initialized successfully\n");
 	else
 		kvm_info("Hyp mode initialized successfully\n");
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
