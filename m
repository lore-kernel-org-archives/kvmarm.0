Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA34C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF2576141B
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DF2576141B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE624B1C1;
	Fri, 24 Sep 2021 08:54:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M6GUmwru8JkE; Fri, 24 Sep 2021 08:54:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C63C4B1CF;
	Fri, 24 Sep 2021 08:54:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 833874B1BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FmGvjHKUOYL0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:26 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B38384B174
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:25 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 bm12-20020a05620a198c00b00432e14ddb99so31542792qkb.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LZOV2dq//fdarSZ1UQXRXLqBKRPy36MQCgMnGFxeKiY=;
 b=i7wNsSyEZO3Xlq4SY8WT2jMhEBq6yM4BseM6UxtVbhob5zKaZA1doTwn0DklaFJS2J
 LjLo/74OYhBloKd6aumy8koxoHfNV7/DYJzKOeMqQ65NyinAyxqchr5aDy0CYpDfOw3t
 JM2pDEncfpfat3Mbl+MfvITadVXzbrAUxqM69iij9wjqJ+8GPmmWmw86KHpz6RuUYLq/
 bt7kxSeLwbBL2g8F9PT4IrcOvb1n3g5mAneeZ2GG+fnnw4rWmPYIEbRrY2TEHKTtuZcC
 fCpIu4w6jLfF+Eaqz8z6+bgq8cwl75ERIOks6W689Aq7x5XtM7RrPYZzgBTyOtyEjH7L
 yyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LZOV2dq//fdarSZ1UQXRXLqBKRPy36MQCgMnGFxeKiY=;
 b=eyRySZrEKDq16MDqtx/d3ksVUX9BG36kYRMapHfLbwwfjDP2/p8id4x9jIuVfrcQqe
 kkotW7CdQHTRyOBkyljtsE9G6YGp6wMnAFj7tOnSUc9B5b/6p8VF8xjtboyNocLjvvk9
 k+xo/I0yC30ls0r+CXmMrTIoAc2646RiLuH07BgsUGwyPvdAj7T1BxhGpdYa4XzCPsx3
 VRKsyq/L5uANwUnCuo9+X0ujIzn0kzl4B5ZbbQfYqEAjyEjkvPWZyxzgdie18r8lJTKK
 /8gIJoMtMgAvyankfNE2N9PB/D47tSFkReRRIWTTdr6Op4uMvJYgkvbF6fodQnf0isAw
 z02w==
X-Gm-Message-State: AOAM533vzsgowq0ndlbNcYdxYaTa9TK4T6Ry+pqMDO9t7dfbihyUB3Rj
 XL26x2W5KTVhYO9U0r5D3tkvTJ5wSa62bNj4bQkddwJzsCU3TJAjGWBxOOO52XYYS5LnzaPd1Tm
 D83TJg3JpqgQ52CrmSob95lfuhSvjztyDA972VkZ8qBc529W+Je2wdlBEiqwU/Ol/zhY=
X-Google-Smtp-Source: ABdhPJyiUxiESUbsfUSqdfuMXJkScSsmcEa94A8nBj+cCsvl5tfCKO45MzFdUPEtgqstBChxPe4XLicMqw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1022:: with SMTP id
 k2mr102283qvr.53.1632488065246; Fri, 24 Sep 2021 05:54:25 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:40 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-12-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 11/30] KVM: arm64: create and use a new vcpu_hyp_state
 struct
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

Create a struct for the hypervisor state from the related fields
in vcpu_arch. This is needed in future patches to reduce the
scope of functions from the vcpu as a whole to only the relevant
state, via this newly created struct.

Create a new instance of this struct in vcpu_arch and fix the
accessors to use the new fields. Remove the existing fields from
vcpu_arch.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 35 ++++++++++++++++++-------------
 arch/arm64/kernel/asm-offsets.c   |  2 +-
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e5c173d2360..dc4b5e133d86 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -269,27 +269,35 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+/* Holds the hyp-relevant data of a vcpu.*/
+struct vcpu_hyp_state {
+	/* HYP configuration */
+	u64 hcr_el2;
+	u32 mdcr_el2;
+
+	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
+	u64 vsesr_el2;
+
+	/* Exception Information */
+	struct kvm_vcpu_fault_info fault;
+
+	/* Miscellaneous vcpu state flags */
+	u64 flags;
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
 	unsigned int sve_max_vl;
 
+	struct vcpu_hyp_state hyp_state;
+
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
 
-	/* HYP configuration */
-	u64 hcr_el2;
-	u32 mdcr_el2;
-
-	/* Exception Information */
-	struct kvm_vcpu_fault_info fault;
-
 	/* State of various workarounds, see kvm_asm.h for bit assignment */
 	u64 workaround_flags;
 
-	/* Miscellaneous vcpu state flags */
-	u64 flags;
-
 	/*
 	 * We maintain more than a single set of debug registers to support
 	 * debugging the guest from the host and to maintain separate host and
@@ -356,9 +364,6 @@ struct kvm_vcpu_arch {
 	/* Detect first run of a vcpu */
 	bool has_run_once;
 
-	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
-	u64 vsesr_el2;
-
 	/* Additional reset state */
 	struct vcpu_reset_state	reset_state;
 
@@ -373,7 +378,7 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
-#define hyp_state(vcpu) ((vcpu)->arch)
+#define hyp_state(vcpu) ((vcpu)->arch.hyp_state)
 
 /* Accessors for hyp_state parameters related to the hypervistor state. */
 #define hyp_state_hcr_el2(hyps) (hyps)->hcr_el2
@@ -633,7 +638,7 @@ void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
-#define kvm_call_hyp_nvhe(f, ...)						\
+#define kvm_call_hyp_nvhe(f, ...)					\
 	({								\
 		struct arm_smccc_res res;				\
 									\
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index c2cc3a2813e6..1776efc3cc9d 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -107,7 +107,7 @@ int main(void)
   BLANK();
 #ifdef CONFIG_KVM
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
-  DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
+  DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.hyp_state.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
