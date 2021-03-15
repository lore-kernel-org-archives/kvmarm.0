Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D685CC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:35:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5CD646500A
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:35:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CD646500A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 020524B5BB;
	Mon, 15 Mar 2021 10:35:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rADfLxF0poiB; Mon, 15 Mar 2021 10:35:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 010584B5A7;
	Mon, 15 Mar 2021 10:35:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0E224B5FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id flqhTcz75EMx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:35:51 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E72414B5B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:49 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id i5so15188773wrp.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CWD0ZTykbS9rpgPcDzjldFEhYHHZjk+W/M1Qg3Ptvcw=;
 b=YH68EwOClBXGIJmeGqCUN2dhjlTkG1F/UlBsPGBdkrfbjGJ/wKGnavp/Cs02ZJyOnA
 i9zS8UvlY5ht/Sq8FBKuH8o7kQzDd9aRtAZB0T6BuYdPfO2/PZ5iLEWx3SDEdYDHSyOh
 dczI07hP20xwCKm4zmlPWwLc2zRwazuu0pxdK0MlOIAasdPOq29Fld+MgcxnMs/WHnHO
 HOSy4YvbCExvOeq9JGAP8qvzGB6+CrW/eN35hN4MDI0unThGS3JFrIFcZiM6TXLYw1F5
 q7IyUQGmMGC0Mo9hAE3MU6bekn5puwnNhVM6fJSQlGmCLzTdiwBtuBi4J5gRMFdsuId4
 wIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CWD0ZTykbS9rpgPcDzjldFEhYHHZjk+W/M1Qg3Ptvcw=;
 b=ifQSBqUT/zLJhl84jA+aSpq8KZCLTeS+rb/mFOB/LtZnbeBWqQG3b7P7/GgEEgLvto
 JrP25Ezm9nbluJnjWnBA8Jk5IkJ/7LCvgG7FO6nNaCUFrE9KGDY0OTkqcYmwL98dbq3X
 0YEo30CAE9vCOi6tBx04O0zVca1kneHHPtsGUPIr1K0LCi8rFxtYloWB4Kbpb+HXf3hW
 WoF4m4tMysgJFU752wD5EMzaTYJUhhlFiLMwf3guYqAo5lrE+R/uPW9NrK5XhQ9j36VV
 z+R1yNWUiYI5lemO6F2e+WOIkBkaNnGDEuR7B1NB52AGl9yeMHq/aUQPgMOJ5n3c+dtB
 M06w==
X-Gm-Message-State: AOAM530o61XypaREEL1y2s0wE4sNWMOgoG2caNE5DvBCMcpbiqnzNrmt
 lf8mmSTdyXMjyCFH48m2f9F6LqOs1/33
X-Google-Smtp-Source: ABdhPJxyely57bJXbfq5qywc89TBRX65VoRvNM5+Je7YF6yjHB3oFwlqb826w0urpEOUPJE9/f/45AdrETx6
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:a504:: with SMTP id
 o4mr12766wme.174.1615818948988; Mon, 15 Mar 2021 07:35:48 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:04 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-5-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 04/36] KVM: arm64: Initialize kvm_nvhe_init_params early
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

Move the initialization of kvm_nvhe_init_params in a dedicated function
that is run early, and only once during KVM init, rather than every time
the KVM vectors are set and reset.

This also opens the opportunity for the hypervisor to change the init
structs during boot, hence simplifying the replacement of host-provided
page-table by the one the hypervisor will create for itself.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/arm.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fc4c95dd2d26..2d1e7ef69c04 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1383,22 +1383,18 @@ static int kvm_init_vector_slots(void)
 	return 0;
 }
 
-static void cpu_init_hyp_mode(void)
+static void cpu_prepare_hyp_mode(int cpu)
 {
-	struct kvm_nvhe_init_params *params = this_cpu_ptr_nvhe_sym(kvm_init_params);
-	struct arm_smccc_res res;
+	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 	unsigned long tcr;
 
-	/* Switch from the HYP stub to our own HYP init vector */
-	__hyp_set_vectors(kvm_get_idmap_vector());
-
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 * Also drop the KASAN tag which gets in the way...
 	 */
-	params->tpidr_el2 = (unsigned long)kasan_reset_tag(this_cpu_ptr_nvhe_sym(__per_cpu_start)) -
+	params->tpidr_el2 = (unsigned long)kasan_reset_tag(per_cpu_ptr_nvhe_sym(__per_cpu_start, cpu)) -
 			    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
 
 	params->mair_el2 = read_sysreg(mair_el1);
@@ -1422,7 +1418,7 @@ static void cpu_init_hyp_mode(void)
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
 
-	params->stack_hyp_va = kern_hyp_va(__this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE);
+	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
 	params->pgd_pa = kvm_mmu_get_httbr();
 
 	/*
@@ -1430,6 +1426,15 @@ static void cpu_init_hyp_mode(void)
 	 * be read while the MMU is off.
 	 */
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
+}
+
+static void cpu_init_hyp_mode(void)
+{
+	struct kvm_nvhe_init_params *params;
+	struct arm_smccc_res res;
+
+	/* Switch from the HYP stub to our own HYP init vector */
+	__hyp_set_vectors(kvm_get_idmap_vector());
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -1438,6 +1443,7 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
+	params = this_cpu_ptr_nvhe_sym(kvm_init_params);
 	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init), virt_to_phys(params), &res);
 	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
 
@@ -1785,19 +1791,19 @@ static int init_hyp_mode(void)
 		}
 	}
 
-	/*
-	 * Map Hyp percpu pages
-	 */
 	for_each_possible_cpu(cpu) {
 		char *percpu_begin = (char *)kvm_arm_hyp_percpu_base[cpu];
 		char *percpu_end = percpu_begin + nvhe_percpu_size();
 
+		/* Map Hyp percpu pages */
 		err = create_hyp_mappings(percpu_begin, percpu_end, PAGE_HYP);
-
 		if (err) {
 			kvm_err("Cannot map hyp percpu region\n");
 			goto out_err;
 		}
+
+		/* Prepare the CPU initialization parameters */
+		cpu_prepare_hyp_mode(cpu);
 	}
 
 	if (is_protected_kvm_enabled()) {
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
