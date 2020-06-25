Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB69C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D71C220702
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="L6GN/yTU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D71C220702
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 922454B088;
	Thu, 25 Jun 2020 09:14:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qqWU1i1tH40R; Thu, 25 Jun 2020 09:14:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BA284B552;
	Thu, 25 Jun 2020 09:14:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9371F4B551
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K4kF9aGjdF1C for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:36 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 958474B192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:34 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id l2so4403256wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=kuR4zqn460ZfDvOPRZLBdbatU3Tl1+GK/DM2MsbbDYE=;
 b=L6GN/yTULlibROyq7dwxJEpfOR9idYf2tNFIPd390S+//8i/sDzyXWY8L8ngX0BmtE
 hsHNfixR1RZPoTZ7O9ndXAOPxn8W1w3/3yqWVLMiA5/YairtLVWSHu8z5MYKAcehYrs+
 Ny5pOzpitZGzdjf638XktPBLh0AY0ZGsAy9BPdt/Z9qH4GLDuRjLci4fhTMBsvjyKplw
 bGwJKNeKMZ8zPUozt8P/Mbalws29i6cej9OyrXJq27LEgMdSuKwLHsfgPwe2xUquGlDU
 mp9ZBtC0j+EdYEede1FCz/AqN4V5MzQILFML0M5BASdZ6/qaRxRs2QZc+9HH8xG7EGSV
 KMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=kuR4zqn460ZfDvOPRZLBdbatU3Tl1+GK/DM2MsbbDYE=;
 b=JUzB6QCA0KR85E+0dL38zfXDICsnic5pu51D4/dgb5ng1I+ORRAl2ElesFNldZxCyF
 hC4d8DK82esbrSLEbSde9CKoslOi0TZIpN26a+k1BFK+VG5Kq4jZh9Y8SustMf3DYU5w
 qiQy7yJamMJtH5oFEV7vW7AorMiTBDLsle/piiPN2fOfFCUwU7RInbdE5CqrucJ1v+FC
 f2CuNLXya6QRrzIaQXNQWXrrXpwbAcTpgGd6cSgbpr+/1UFTIL5z1sfWDch80GDlm+UB
 4jPkGcQNa6r6qpwwqCoFm4q8FXB3/4rM986TyRcPq/ErOZaiEXneApxRwHcTHqq1TrBp
 UttA==
X-Gm-Message-State: AOAM5302P/LOHbwCGU3XbMSlniqz+1PWYKGgacvBqOfUU/NDCPgnqXcy
 JqazpNGqfJVRcH55l1/LUq5fOA==
X-Google-Smtp-Source: ABdhPJzjfkKDfkUwAkvXXlxbiBPTEw+5nTG7FyH0H8W76y+Lt4gtAq38QOX0jPlZdLDTDKE6B2VYeA==
X-Received: by 2002:a7b:c441:: with SMTP id l1mr3158785wmi.7.1593090873533;
 Thu, 25 Jun 2020 06:14:33 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id t16sm9874525wru.9.2020.06.25.06.14.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:32 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 05/15] arm64: kvm: Handle calls to prefixed hyp functions
Date: Thu, 25 Jun 2020 14:14:10 +0100
Message-Id: <20200625131420.71444-6-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Andrew Scull <ascull@google.com>

Once hyp functions are moved to a hyp object, they will have prefixed symbols.
This change declares and gets the address of the prefixed version for calls to
the hyp functions.

To aid migration, the hyp functions that have not yet moved have their prefixed
versions aliased to their non-prefixed version. This begins with all the hyp
functions being listed and will reduce to none of them once the migration is
complete.

Signed-off-by: Andrew Scull <ascull@google.com>

[David: Extracted kvm_call_hyp nVHE branches into own helper macros, added
        comments around symbol aliases.]
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 19 +++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h | 17 ++++++++++++++---
 arch/arm64/kernel/image-vars.h    | 26 ++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 352aaebf4198..6a682d66a640 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -42,6 +42,24 @@
 
 #include <linux/mm.h>
 
+/*
+ * Translate name of a symbol defined in nVHE hyp to the name seen
+ * by kernel proper. All nVHE symbols are prefixed by the build system
+ * to avoid clashes with the VHE variants.
+ */
+#define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
+
+#define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
+#define DECLARE_KVM_NVHE_SYM(sym)	extern char kvm_nvhe_sym(sym)[]
+
+/*
+ * Define a pair of symbols sharing the same name but one defined in
+ * VHE and the other in nVHE hyp implementations.
+ */
+#define DECLARE_KVM_HYP_SYM(sym)		\
+	DECLARE_KVM_VHE_SYM(sym);		\
+	DECLARE_KVM_NVHE_SYM(sym)
+
 /* Translate a kernel address of @sym into its equivalent linear mapping */
 #define kvm_ksym_ref(sym)						\
 	({								\
@@ -50,6 +68,7 @@
 			val = lm_alias(&sym);				\
 		val;							\
 	 })
+#define kvm_ksym_ref_nvhe(sym)	kvm_ksym_ref(kvm_nvhe_sym(sym))
 
 struct kvm;
 struct kvm_vcpu;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c3e6fcc664b1..49d1a5cd8f8f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -448,6 +448,18 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 
 u64 __kvm_call_hyp(void *hypfn, ...);
 
+#define kvm_call_hyp_nvhe(f, ...)					\
+	do {								\
+		DECLARE_KVM_NVHE_SYM(f);				\
+		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
+	} while(0)
+
+#define kvm_call_hyp_nvhe_ret(f, ...)					\
+	({								\
+		DECLARE_KVM_NVHE_SYM(f);				\
+		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
+	})
+
 /*
  * The couple of isb() below are there to guarantee the same behaviour
  * on VHE as on !VHE, where the eret to EL1 acts as a context
@@ -459,7 +471,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 			f(__VA_ARGS__);					\
 			isb();						\
 		} else {						\
-			__kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__); \
+			kvm_call_hyp_nvhe(f, ##__VA_ARGS__);		\
 		}							\
 	} while(0)
 
@@ -471,8 +483,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 			ret = f(__VA_ARGS__);				\
 			isb();						\
 		} else {						\
-			ret = __kvm_call_hyp(kvm_ksym_ref(f),		\
-					     ##__VA_ARGS__);		\
+			ret = kvm_call_hyp_nvhe_ret(f, ##__VA_ARGS__);	\
 		}							\
 									\
 		ret;							\
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 3dc27da47712..36444bac6a05 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -63,6 +63,32 @@ __efistub__ctype		= _ctype;
 
 #define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
 
+/* Symbols defined in debug-sr.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_get_mdcr_el2);
+
+/* Symbols defined in switch.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_vcpu_run_nvhe);
+
+/* Symbols defined in sysreg-sr.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_enable_ssbs);
+
+/* Symbols defined in timer-sr.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_timer_set_cntvoff);
+
+/* Symbols defined in tlb.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_flush_vm_context);
+KVM_NVHE_ALIAS(__kvm_tlb_flush_local_vmid);
+KVM_NVHE_ALIAS(__kvm_tlb_flush_vmid);
+KVM_NVHE_ALIAS(__kvm_tlb_flush_vmid_ipa);
+
+/* Symbols defined in vgic-v3-sr.c (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__vgic_v3_get_ich_vtr_el2);
+KVM_NVHE_ALIAS(__vgic_v3_init_lrs);
+KVM_NVHE_ALIAS(__vgic_v3_read_vmcr);
+KVM_NVHE_ALIAS(__vgic_v3_restore_aprs);
+KVM_NVHE_ALIAS(__vgic_v3_save_aprs);
+KVM_NVHE_ALIAS(__vgic_v3_write_vmcr);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
