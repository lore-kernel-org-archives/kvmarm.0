Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1496DC6379D
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8117320780
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="glZIgG4S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8117320780
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24A6E4B6D6;
	Wed,  4 Nov 2020 13:37:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OcuSRAtLRge7; Wed,  4 Nov 2020 13:37:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2764E4B7DC;
	Wed,  4 Nov 2020 13:37:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0164B6D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 28ReS6skNTrH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:15 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7DCD4B780
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:15 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id c18so3359050wme.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=NtbQNJ0uZzWKg9gLgK2M3GouFY/UQOUZaNHatLeLQ8M=;
 b=glZIgG4SvpZZisD70c1QAFcHNEqwgKXE55ekUwKFPprz1IIkVpSXlyWYgAtg2MCZM5
 GqbKCZ3+xM/3+eOqF8D5wUxLEkEa6IQiJBeW8l6gSOLPRjEyrZUczqmCfQWxw0KjFRAV
 UTg06vSZoQR1ZRffNmFizJslF0vRdkKBwRISs0LhkuKK3dxmFpeYQzWGseWjGXaP53pX
 /XHsM9yTMR0wqMauTJgRe+RH3fb0nyXd+XMoMRPI3fdzZHBU1YxFys0+gatGpOM+mWw3
 9Y1glJporpQT5vgTtSIAUmA3HuRnvrogowxslIbDEDS242fjxYGpkpL7E97BbqlKk7yy
 /SVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=NtbQNJ0uZzWKg9gLgK2M3GouFY/UQOUZaNHatLeLQ8M=;
 b=Mkx5oiu++C4vYrBQX1vNC6liCL27sYTSn/6UH6PAi8Qefhsh4iVjxXUHTVBZ82/6m2
 ZCJdUY9LiXVuINuL7PzQ6C3VlQjGc4Jkf+GWXeOBvZexv99k2lb+12n9jfR4VmpDKnbZ
 3Rr90Ni8S0QyD0vxth8VRd6W3IgVvWfFoMzCqqh1oohKmzV2Sed7jLWl8iT7VAg1qTqJ
 j6O83obfxLf2TnrH9FILmt3eFVA/iqXFXKJdlY9VfeL65tBmXzhqdV48BtJKWGBdYJ5w
 cbYHSFcZ9KEozxJKGA4+SqlrA7KmeVdRcmXWX5+qa1d17aZxMuS1Bsl4Zjv1O9bhJCAS
 miYQ==
X-Gm-Message-State: AOAM533hL/TWL+gFa8PloTqWanLcd0g35x/NMwrvHTS9GwDXsUvLJE7k
 yz2S9le+sKLEeukbtfUDacBsIAYjH0YGopiS
X-Google-Smtp-Source: ABdhPJxJRepCEtlNkPsKx2eanZXbzlkYpzLB45jmxePnFjEoeyIHr7ruHFcNIkE+7lLzMGGiaX+Q4g==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr6301427wma.171.1604515034317; 
 Wed, 04 Nov 2020 10:37:14 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id w4sm3692651wrk.28.2020.11.04.10.37.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:13 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 17/26] kvm: arm64: Bootstrap PSCI power state of host CPUs
Date: Wed,  4 Nov 2020 18:36:21 +0000
Message-Id: <20201104183630.27513-18-dbrazdil@google.com>
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

Proxying host's PSCI SMCs will require synchronizing CPU_ON/OFF/SUSPEND
calls based on the observed state of individual cores. Add a per-CPU enum
that tracks the power state of each core and initialize all CPUs online
at the point of KVM init to ON.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 6 ++++++
 arch/arm64/include/asm/kvm_hyp.h | 1 +
 arch/arm64/kvm/arm.c             | 5 +++++
 arch/arm64/kvm/hyp/nvhe/psci.c   | 2 ++
 4 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 893327d1e449..9eecb37db6df 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -157,6 +157,12 @@ struct kvm_nvhe_init_params {
 	unsigned long vector_ptr;
 };
 
+enum kvm_nvhe_psci_state {
+	KVM_NVHE_PSCI_CPU_OFF = 0,
+	KVM_NVHE_PSCI_CPU_PENDING_ON,
+	KVM_NVHE_PSCI_CPU_ON,
+};
+
 /* Translate a kernel address @ptr into its equivalent linear mapping */
 #define kvm_ksym_ref(ptr)						\
 	({								\
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 95a2bbbcc7e1..cf4c1d16c3e0 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,6 +97,7 @@ void deactivate_traps_vhe_put(void);
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
+void kvm_host_psci_cpu_init(void);
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 #endif
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 580d4a656a7b..5b073806463e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -52,6 +52,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DECLARE_KVM_NVHE_PER_CPU(enum kvm_nvhe_psci_state, psci_cpu_state);
 
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
@@ -1517,10 +1518,14 @@ static void init_psci(void)
 {
 	extern u32 kvm_nvhe_sym(kvm_host_psci_version);
 	extern u32 kvm_nvhe_sym(kvm_host_psci_function_id)[PSCI_FN_MAX];
+	int cpu;
 
 	kvm_nvhe_sym(kvm_host_psci_version) = psci_driver_version;
 	memcpy(kvm_nvhe_sym(kvm_host_psci_function_id),
 		psci_function_id, sizeof(psci_function_id));
+
+	for_each_online_cpu(cpu)
+		*per_cpu_ptr_nvhe_sym(psci_cpu_state, cpu) = KVM_NVHE_PSCI_CPU_ON;
 }
 
 static int init_common_resources(void)
diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index 3eafcf48a29b..c3d0a6246c66 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -20,6 +20,8 @@ s64 hyp_physvirt_offset;
 
 #define __hyp_pa(x) ((phys_addr_t)(x) + hyp_physvirt_offset)
 
+DEFINE_PER_CPU(enum kvm_nvhe_psci_state, psci_cpu_state);
+
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
 	return host_ctxt->regs.regs[0];
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
