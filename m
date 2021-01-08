Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD59C433E6
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33F4223975
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33F4223975
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B936A4B268;
	Fri,  8 Jan 2021 07:15:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3t9DSOmQXV0u; Fri,  8 Jan 2021 07:15:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AFDC4B3FD;
	Fri,  8 Jan 2021 07:15:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73DF34B364
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id au-WR-fPIaei for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:35 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93D514B3EA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:35 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id t16so8122746qvk.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=RWcnIk+Zz+pG3Av2Dxn/kb2+XtU0B6nl5U7IxSgo4iw=;
 b=wNDXx/sD5GcSm/A2PTYKJfLmxpXERQHCwjVkRWUnY9K+2OAVeVfYr/UCXk9mDcjoMp
 vJKYCy75bWYTCgFQ1ptMnhasFa5sou7N8b/rWBAkDQEQ11itqD0Ptok7bcwYArwv8MTT
 9TdaY+L2RigUm80IdI2+QXKM7SSGNfVKsoakb54xiYsDiKfTpVORSAlTWKiRhFJiYmI7
 ft3aZUjZ78GH8luL/PoDAYpN0RFLmsGt7EKO9aYJyfcBeHWNAsof0F5HnfdZV4a9lKUP
 s1fPLO8kVOYYtT/nh9NctbbbsnRbvfWLwrHL6PED18gm4ShxMOZWiyUWpfdmAM78/ZM1
 x0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RWcnIk+Zz+pG3Av2Dxn/kb2+XtU0B6nl5U7IxSgo4iw=;
 b=ep+JrBAG8Z/iQWV0P6j+6lu/3Rbe7+rZGlHB9eKk9BLeKbIPGTV/3Hygl2AXBApZmb
 k3SpKHlfDEJsZSZgvPWzhY1+9NepnenMI+w6e+QeHb3t/4ec7Lq0Qc3x+9aXYUQaaCQc
 oprkPqXx6U2fH4JJheIGwtj81PNYGoU+pydEn1u00Hvke5E4DSYj+A7VvCmnnB61dx2L
 uMM04bhLaK6u4Puwp6mfJCnuDK/TuEMKk/tNz34GLhlK/1878Qf5SLgQ3K89xEB0JIUS
 vJJNnTHDlXuOBGpnglHmwil9gFmUa9/BFJidWwUNRXJZo5DHNgLK6ghlGUmzwL+ecdRv
 cozQ==
X-Gm-Message-State: AOAM533ZSn603ZzYlJNoxfDxSVo9XF+vSD8Tvyc+mUr+MfAJZ+HkVDYF
 9GJhUSg6UmET/T5S8ZDD+tiaLodw4pwO
X-Google-Smtp-Source: ABdhPJzjzlzr8QnoGpMUomUK/uLWkut64kFG4OYSU3shcMs3B8KGc+9cpRoXp++qeovMbvcWCVJNIGFBfZa5
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:f812:: with SMTP id
 r18mr3189415qvn.39.1610108135126; Fri, 08 Jan 2021 04:15:35 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:02 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-5-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 04/26] KVM: arm64: Initialize kvm_nvhe_init_params early
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
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
page-tables and stacks by the ones the hypervisor will create for
itself.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/arm.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 04c44853b103..3ac0f3425833 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1383,21 +1383,17 @@ static int kvm_init_vector_slots(void)
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
 	 */
-	params->tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe_sym(__per_cpu_start) -
+	params->tpidr_el2 = (unsigned long)per_cpu_ptr_nvhe_sym(__per_cpu_start, cpu) -
 			    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
 
 	params->mair_el2 = read_sysreg(mair_el1);
@@ -1421,7 +1417,7 @@ static void cpu_init_hyp_mode(void)
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
 
-	params->stack_hyp_va = kern_hyp_va(__this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE);
+	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
 	params->pgd_pa = kvm_mmu_get_httbr();
 
 	/*
@@ -1429,6 +1425,15 @@ static void cpu_init_hyp_mode(void)
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
@@ -1437,6 +1442,7 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
+	params = this_cpu_ptr_nvhe_sym(kvm_init_params);
 	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init), virt_to_phys(params), &res);
 	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
 
@@ -1807,6 +1813,12 @@ static int init_hyp_mode(void)
 			goto out_err;
 	}
 
+	/*
+	 * Prepare the CPU initialization parameters
+	 */
+	for_each_possible_cpu(cpu)
+		cpu_prepare_hyp_mode(cpu);
+
 	return 0;
 
 out_err:
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
