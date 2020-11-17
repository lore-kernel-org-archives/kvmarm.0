Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422D6C63697
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A51302222E
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="vS+rvB1/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A51302222E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43A934B85B;
	Tue, 17 Nov 2020 13:16:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9uIhm0kEkolr; Tue, 17 Nov 2020 13:16:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B576C4B888;
	Tue, 17 Nov 2020 13:16:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3054B853
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gelz08P2Poof for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:29 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 390444B83D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:29 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id 3so2126665wms.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=IZC56EUbcZGLv67uWppNeQH9/JsQWBJOLy6w8MLjYOk=;
 b=vS+rvB1/6KGnGkdgssdAFqr2pdbbPpSdTO3v0TbihY/ScWy+IKWsAhYSb+9u1xIoQY
 iJ5ArdUb3OBFMAalNNv9B0qc726x3h1bvk8i+Bt1in0DvI/BetdAiJgv2iq6+11P85K3
 POOkjSLXMrr5CvPC7Usq08l9ERlJLMKxBdTUq+O3qFMGt1wjdx9cjLeG1FpZm0WbcGgI
 gWEdRNRf4cc7JUlIQ8kW/6J7K8sBCpWEHsM8GS/TPC0z9RhMv2am4tyeUPp/P/FUsJ0h
 xuW1/Ugcc9nP8aKCuNn+d2qK3dxsz5m2Qxz8K4SfKxYCDJLLMPLQDJAyyK1BKwJgdl4V
 VQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IZC56EUbcZGLv67uWppNeQH9/JsQWBJOLy6w8MLjYOk=;
 b=QdJEdZ+AVLVmu+ddZ0z2ohhEWIF0FggN78uKStU/GIxdUoO+eBkWl8v69u3OaSptfN
 1Qe9+ulXv54mDaas9LwV8r4lYZMOEYE7LrYNjyAHP4eCRK0k80BukPbCWzmUSmzWkgAT
 mY2T/2S8aToA/RR0eA3ENFlsvMVNSwkmWXnP6g/2aDutJj7+Ryf88rNYGt57+ejscETT
 jIovsmjHESK+Ut1r+MNfnx9ihu5wwSDuvfyHEBzKC+a2rdz6JHMkPLyp+ZMSLyR/An2v
 AMcK/jZW0mOTCF5K/riCX95Lb15ZC+h5Z5yA+2oR2L9COX/kxDFCC3SSJpF9/fFDdXMR
 XM/w==
X-Gm-Message-State: AOAM5325efz4JSCfl/8zXYvV8rAKsRxfN1WhPv8gyhpOVBrxoOl8755U
 8W8C6DjgC8omzWU6mbcNT5BI8F+UsWNb
X-Google-Smtp-Source: ABdhPJzcNUt5sppuGQvEX0isAFbepTz9C9E9Dic3GRImbsOwvG5qyl5LhxGBa5f3ag7x2AHxrvf7fK/v7tNU
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a7b:cd10:: with SMTP id
 f16mr348760wmj.69.1605636988252; Tue, 17 Nov 2020 10:16:28 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:44 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-5-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 04/27] KVM: arm64: Initialize kvm_nvhe_init_params early
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
index d6d5211653b7..7335eb4fb0bd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1355,24 +1355,20 @@ static int kvm_init_vector_slots(void)
 	return 0;
 }
 
-static void cpu_init_hyp_mode(void)
+static void cpu_prepare_hyp_mode(int cpu)
 {
-	struct kvm_nvhe_init_params *params = this_cpu_ptr_nvhe_sym(kvm_init_params);
-	struct arm_smccc_res res;
-
-	/* Switch from the HYP stub to our own HYP init vector */
-	__hyp_set_vectors(kvm_get_idmap_vector());
+	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
-	params->tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe_sym(__per_cpu_start) -
+	params->tpidr_el2 = (unsigned long)per_cpu_ptr_nvhe_sym(__per_cpu_start, cpu) -
 			    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
 
 	params->vector_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_host_vector));
-	params->stack_hyp_va = kern_hyp_va(__this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE);
+	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
 	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_psci_cpu_entry));
 	params->pgd_pa = kvm_mmu_get_httbr();
 
@@ -1381,6 +1377,15 @@ static void cpu_init_hyp_mode(void)
 	 * be read while the MMU is off.
 	 */
 	__flush_dcache_area(params, sizeof(*params));
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
@@ -1389,6 +1394,7 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
+	params = this_cpu_ptr_nvhe_sym(kvm_init_params);
 	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init), virt_to_phys(params), &res);
 	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
 
@@ -1742,6 +1748,12 @@ static int init_hyp_mode(void)
 	init_cpu_logical_map();
 	init_psci_relay();
 
+	/*
+	 * Prepare the CPU initialization parameters
+	 */
+	for_each_possible_cpu(cpu)
+		cpu_prepare_hyp_mode(cpu);
+
 	return 0;
 
 out_err:
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
