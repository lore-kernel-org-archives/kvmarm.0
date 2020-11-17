Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB6AC64E90
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 918AE24686
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="E0fCuokE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 918AE24686
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BA9C4B885;
	Tue, 17 Nov 2020 13:16:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cmkYKOqZ0Ohr; Tue, 17 Nov 2020 13:16:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A1274B887;
	Tue, 17 Nov 2020 13:16:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 746304B883
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4RFDMwhoOMM9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:41 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 652074B5F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:40 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id x9so11699233qvt.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=TDLolWJ6DLDdLZxFLwTPZoAbRqc8wO9K1ZVQwJmhgQI=;
 b=E0fCuokET/iSPfCmN0hv1bpwVzG19gOi60bqbVg4tbU/MXV8JkAYrWoJTWsyKtcZmb
 NCzh+HSrGM/VrpPjSSavb+jAMioMF4i51wNcX3ISkV63+fEwxFrZc6vXKw/yNZVQcwCy
 05Hvg2hX6rvUiRO1FEufam8DDHknNkWZPYw2fzBkTd8AuB8YloMYzzbBHwuePeZao66I
 UYUGCo9WEpMJep8NfwFKG2NCoQu+vd/Oqeqg/bAdwkpHhbpnuHl+hVrGxKJS3KlbgYWl
 e+Gk+eHeUbd/8E9fdjlIquCJgsoKzgzbJUq0eQYXqTuK5nk5LEhfuIzVSQAxYT+jwcTN
 pZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=TDLolWJ6DLDdLZxFLwTPZoAbRqc8wO9K1ZVQwJmhgQI=;
 b=Du8ccODv+4kqXOgja4x4m9rmwkvFZsv7FCKSuMODG0hSyLWyWgMAmQlAuvbogj1sIB
 e2JA+8dbax24bGCAhn73TZaJzyfE1LgG2kvYjFOTlJKXnrsHbEItIZ7kxmDnTAxgNy1n
 lGMnG4lHI/vA0qgIhRpd5cZUN/+q4IPdYoUirlRAoM8zS0ht25ZI9o4Ziq45rGE6llVJ
 e7EZyvWVr6TgoNQMsQq7g0My+0Kupza88uUX/ho6e4HHk/1W4L5yvJ30TVMSAy+by6i8
 WlfTF3uZjOlLImbcSlAegn10W4f2qjE64eYcRCig2mkS2iKje/uG1C3c53Wiy78ZamJq
 nzYw==
X-Gm-Message-State: AOAM530qg4smhA5NszAAFLacLPTpiXiAILqcaffgBr6gjssz6pjIgxVn
 yd5az4YcKuNWD2fgDhH4qchpjeoSdAFu
X-Google-Smtp-Source: ABdhPJzbODkjl7s4UxQH0AkdtMhlkcj6CRSeDqE2+AHaFV3kAPIwJibRapqdnHmTcqcB2PiXnAFDr9sXfpa9
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a0c:df08:: with SMTP id
 g8mr854334qvl.17.1605636999772; Tue, 17 Nov 2020 10:16:39 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:49 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-10-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 09/27] KVM: arm64: Allow using kvm_nvhe_sym() in hyp code
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

In order to allow the usage of code shared by the host and the hyp in
static inline library function, allow the usage of kvm_nvhe_sym() at el2
by defaulting to the raw symbol name.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 4 ++++
 arch/arm64/include/asm/kvm_asm.h   | 4 ++--
 arch/arm64/kvm/arm.c               | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
index daa1a1da539e..8b807b646b8f 100644
--- a/arch/arm64/include/asm/hyp_image.h
+++ b/arch/arm64/include/asm/hyp_image.h
@@ -7,11 +7,15 @@
 #ifndef __ARM64_HYP_IMAGE_H__
 #define __ARM64_HYP_IMAGE_H__
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_,
  * to separate it from the kernel proper.
  */
 #define kvm_nvhe_sym(sym)	__kvm_nvhe_##sym
+#else
+#define kvm_nvhe_sym(sym)	sym
+#endif
 
 #ifdef LINKER_SCRIPT
 
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 1a86581e581e..e4934f5e4234 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -173,11 +173,11 @@ struct kvm_s2_mmu;
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_host_vector);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
-DECLARE_KVM_NVHE_SYM(__kvm_hyp_psci_cpu_entry);
 #define __kvm_hyp_init			CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_host_vector		CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
 #define __kvm_hyp_vector		CHOOSE_HYP_SYM(__kvm_hyp_vector)
-#define __kvm_hyp_psci_cpu_entry	CHOOSE_NVHE_SYM(__kvm_hyp_psci_cpu_entry)
+
+void kvm_nvhe_sym(__kvm_hyp_psci_cpu_entry)(void);
 
 extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_SYM(__per_cpu_start);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 882eb383bd75..391cf6753a13 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1369,7 +1369,7 @@ static void cpu_prepare_hyp_mode(int cpu)
 
 	params->vector_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_host_vector));
 	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
-	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_psci_cpu_entry));
+	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref_nvhe(__kvm_hyp_psci_cpu_entry));
 	params->pgd_pa = kvm_mmu_get_httbr();
 
 	/*
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
