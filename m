Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290CAC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4C8161423
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D4C8161423
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF724B1F4;
	Fri, 24 Sep 2021 08:54:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id olD9Ww6T3PQM; Fri, 24 Sep 2021 08:54:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EEE84B17C;
	Fri, 24 Sep 2021 08:54:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A62474B1BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 83Vl75q6RnJy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:45 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B931A40642
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:44 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 r15-20020adfce8f000000b0015df1098ccbso8022708wrn.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xhHjvocneo3OmYPl2aUhxqJ3BMqVUjdViv8A/KXRtOc=;
 b=J/C7Ta1yUem3gYRbil/zKRF0IxStHUFvTVNEvuRRLK6gctPS7/SC8wGX+7hdV8c7WF
 sjSMDuG0NjrV+/3ZNT0KciOwQfFrUiKwdKHNGGAYU85PPOeEbgyIDakYmiziwKsXibQN
 ZPrs0iDshzZjAJZ1kGyfQ1P565o2m8tAaHk2VwfnaXwwQCX46G347RPHq4hD4gmQ2LzT
 SLor++gvWIZW6zyDo3nnux9Tf+Km2hcZI0xela+/ti30GaLVylKlApErL4/QNfcgmrZL
 +j6MVi7XB5CJE/FaDfjRSKxRzHxJNULy6UVDbKmpOpKkV6+Jjj8ul6m6gZRAuZ+d1A50
 4JLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xhHjvocneo3OmYPl2aUhxqJ3BMqVUjdViv8A/KXRtOc=;
 b=D1jTmOp1vJ/hVDis15SNJuMcv2BgJg/Ty/R9CEGb3JvjavahaKNFAGez05bLlO4Okr
 Tpke1dZWjfkSrf3bidQhVVi+NOUsqpsn5z4tKiCCejZFJNoqzeoJ0/wKcVvE1sa2KkmC
 MR3MxA59BBmJCy+2Dv2cTTY4NbH8It/0mXvFUh+GrnM0KgKa2RZc6eZbUxl60t5mtZCl
 Pxv1ZkP1UFjdEH8HcChVrdm86Lr4zoBd6dJvO2hh/2ND3/8ft+kk2jiJOVFizI2J58QP
 WvSFSFV80lpZGyIVVCFoIrO/C5/GSyTz51vRo+4Tpb8UPg5s4+GbU/V/5vvemysQK+50
 o3jw==
X-Gm-Message-State: AOAM533Z3sKEksHmHaInj02V06hM5dbq6evBD1K9N08NbJrK6z/kmgOp
 EBdkNZoILGRtHPjEk0wPltXAumsjnrhQkDJaq/1S/6/u3ZYolt7/M8cVZEZGwTMEqoptAC9tBHy
 TK9PWvgfnuI89W7eLgO7mrLvaGRRcUbnv5DrZYKp90pSqfEziMLS0zDpzxDQeGSyGBgI=
X-Google-Smtp-Source: ABdhPJxU6dLnsCPB/2TUUhu7b+8Tafoe11ACEILnegBEKHhcSyod6McampCuDXPyU43B2yIY76HX2EhGMA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6000:1a89:: with SMTP id
 f9mr11219965wry.19.1632488083973; Fri, 24 Sep 2021 05:54:43 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:49 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-21-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 20/30] KVM: arm64: add __hyp_running_ctxt and
 __hyp_running_hyps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

In order to prepare to remove __hyp_running_vcpu, add
__hyp_running_ctxt and __hyp_running_hyps to access the running
kvm_cpu_ctxt and the hyp_state, as well as their associated
assembly offsets.

These new fields are updated but not accessed yet. Their state is
consistent with __hyp_running_vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 13 +++++++++++++
 arch/arm64/include/asm/kvm_host.h | 19 ++++++++++++++++---
 arch/arm64/kernel/asm-offsets.c   |  2 ++
 arch/arm64/kvm/hyp/entry.S        |  2 +-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 766b6a852407..52079e937fcd 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -271,6 +271,19 @@ extern u32 __kvm_get_mdcr_el2(void);
 .macro set_loaded_vcpu vcpu, ctxt, tmp
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
 	str	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+
+	add	\tmp, \vcpu, #VCPU_CONTEXT
+	str	\tmp, [\ctxt, #HOST_CONTEXT_CTXT]
+
+	add	\tmp, \vcpu, #VCPU_HYPS
+	str	\tmp, [\ctxt, #HOST_CONTEXT_HYPS]
+.endm
+
+.macro clear_loaded_vcpu ctxt, tmp
+	adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
+	str	xzr, [\ctxt, #HOST_CONTEXT_VCPU]
+	str	xzr, [\ctxt, #HOST_CONTEXT_CTXT]
+	str	xzr, [\ctxt, #HOST_CONTEXT_HYPS]
 .endm
 
 .macro get_loaded_vcpu_ctxt vcpu, ctxt
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4b01c74705ad..b42d0c6c8004 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -228,14 +228,27 @@ struct kvm_cpu_context {
 	u64 sys_regs[NR_SYS_REGS];
 
 	struct kvm_vcpu *__hyp_running_vcpu;
+	struct kvm_cpu_context *__hyp_running_ctxt;
+	struct vcpu_hyp_state *__hyp_running_hyps;
 };
 
 #define get_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
-#define set_hyp_running_vcpu(ctxt, vcpu) (ctxt)->__hyp_running_vcpu = (vcpu)
+#define set_hyp_running_vcpu(host_ctxt, vcpu) do { \
+	struct kvm_vcpu *v = (vcpu); \
+	(host_ctxt)->__hyp_running_vcpu = v; \
+	if (vcpu) { \
+		(host_ctxt)->__hyp_running_ctxt = &v->arch.ctxt; \
+		(host_ctxt)->__hyp_running_hyps = &v->arch.hyp_state; \
+	} else { \
+		(host_ctxt)->__hyp_running_ctxt = NULL; \
+		(host_ctxt)->__hyp_running_hyps = NULL;	\
+	}\
+} while(0)
+
 #define is_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
 
-#define get_hyp_running_ctxt(host_ctxt) (host_ctxt)->__hyp_running_vcpu ? &(host_ctxt)->__hyp_running_vcpu->arch.ctxt : NULL
-#define get_hyp_running_hyps(host_ctxt) (host_ctxt)->__hyp_running_vcpu ? &(host_ctxt)->__hyp_running_vcpu->arch.hyp_state : NULL
+#define get_hyp_running_ctxt(host_ctxt) (host_ctxt)->__hyp_running_ctxt
+#define get_hyp_running_hyps(host_ctxt) (host_ctxt)->__hyp_running_hyps
 
 struct kvm_pmu_events {
 	u32 events_host;
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 1ecc55570acc..9c25078da294 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -117,6 +117,8 @@ int main(void)
   DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
+  DEFINE(HOST_CONTEXT_CTXT,	offsetof(struct kvm_cpu_context, __hyp_running_ctxt));
+  DEFINE(HOST_CONTEXT_HYPS,	offsetof(struct kvm_cpu_context, __hyp_running_hyps));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
   DEFINE(NVHE_INIT_MAIR_EL2,	offsetof(struct kvm_nvhe_init_params, mair_el2));
   DEFINE(NVHE_INIT_TCR_EL2,	offsetof(struct kvm_nvhe_init_params, tcr_el2));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 1804be5b7ead..8e7033aa5770 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -145,7 +145,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
-	set_loaded_vcpu xzr, x2, x3
+	clear_loaded_vcpu x2, x3
 
 alternative_if ARM64_HAS_RAS_EXTN
 	// If we have the RAS extensions we can consume a pending error
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
