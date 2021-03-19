Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC32CC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E2E664F6A
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E2E664F6A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E65404B689;
	Fri, 19 Mar 2021 06:02:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G-w4Z9Gvr+Bo; Fri, 19 Mar 2021 06:02:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEDB34B39B;
	Fri, 19 Mar 2021 06:02:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 369674B611
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b3-+Iq98842F for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:09 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC52F4B671
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:07 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id bt20so22809430qvb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FHhOKlvH8BUgvSu8w1ogZTH6l5iURXLk02Ie2JUxorI=;
 b=qixyVDp2kzHvkmDWySq9jBUdHw1gl4owgBvaGaZcBZnZJ3t0tbfIPvpnr/l0h2deyl
 2EPkGOTsbSATaWOR5f/vBI+kFfGMcSFOmltFzs6oJl8frXJEaIW57uVoBFzxvj7efpej
 Km7kaJymPI6YHaaotbR7/CKArmpzCXEg7pMb+NNE62MGwntXknqbQwbUqCfwZeVJpOxO
 DGXawS5F6hpYD/m+wgEUgM3jp8DdXp7e4Jdtcs7QpjJM9H5atLC5LViAK6E791VUrkia
 lkGv1U5aVDqEVnL5hIxnUiyIOmLtYxelT+qUAgnrR32tl3EQE5CDB5VPnBGGC++t2uNL
 8iSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FHhOKlvH8BUgvSu8w1ogZTH6l5iURXLk02Ie2JUxorI=;
 b=XNYUrqOS8H1aHwu2yZOC5ry7m3NwkVBlH9zAf+QemYwGOEzhliJUPc6TE+omGCK9fQ
 6vZoPFBgxP7gMAM2YZV+O1ZIiLI+/6Pk9qaqf3FfdoP4KWeR9NwkAxP4FmbG7swfP/3H
 DI+TmA4kWx+2pLhQn1NZ0wwL0esEdx+qsSS1WXyZwRy5rNGZ94+QjOeLeEjk1E1Nq4T3
 UoJ1i5Ezj0YLG0ah8CudOO1c7HB6ebCefTNg/bdnTOAvPC17j6l3iujUkZV9JVn9j8L+
 PnY1YJBlAYkErPostA7b4QRcdCONStWBpNPjd6lCBblXBGXKfm1VYi6IBGpAazcG4e4c
 CeZg==
X-Gm-Message-State: AOAM531KeWyV7Xct0KKJkl5p0UFl7Iw14C/qQYUhK+mmi4j4hys47r27
 Ib1YU0/PfwaCz6hfBlcKpxqSapt2obHm
X-Google-Smtp-Source: ABdhPJwIqnMAXTy7s8n+By8NiJmpTPklRN++6V786HQ3MT5zF6JnhYEfpESJplTXQGrKlaX51KwO3bZurPTZ
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:b410:: with SMTP id
 u16mr8628046qve.8.1616148127254; Fri, 19 Mar 2021 03:02:07 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:16 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-9-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 08/38] KVM: arm64: Make kvm_call_hyp() a function call at
 Hyp
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
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

kvm_call_hyp() has some logic to issue a function call or a hypercall
depending on the EL at which the kernel is running. However, all the
code compiled under __KVM_NVHE_HYPERVISOR__ is guaranteed to only run
at EL2 which allows us to simplify.

Add ifdefery to kvm_host.h to simplify kvm_call_hyp() in .hyp.text.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 08f500b2551a..6a2031af9562 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -593,6 +593,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
 		struct arm_smccc_res res;				\
@@ -632,6 +633,11 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 									\
 		ret;							\
 	})
+#else /* __KVM_NVHE_HYPERVISOR__ */
+#define kvm_call_hyp(f, ...) f(__VA_ARGS__)
+#define kvm_call_hyp_ret(f, ...) f(__VA_ARGS__)
+#define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
+#endif /* __KVM_NVHE_HYPERVISOR__ */
 
 void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
