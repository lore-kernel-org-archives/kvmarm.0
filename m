Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE599C433E9
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77EA864FC0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77EA864FC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF264B611;
	Mon, 15 Mar 2021 10:36:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cia+zutfWh7s; Mon, 15 Mar 2021 10:36:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 932C44B61B;
	Mon, 15 Mar 2021 10:36:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09D3C4B3AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rRtqFnKfwtzu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:35:59 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 231C04B498
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:58 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id m17so2910123wml.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+iu0t5BZID9srTWBP+2VrUQDFbl6lTqyuwf0tKjg+JE=;
 b=eCfaDc/7sIi6ERqTbQYAo0T/MGESaou7EUDhXwnQrsDwamnC9YlqfgIGWyi8fqO8yO
 nTiawzHfVoaGMYlQk9s/eR4POgKLB8f5IkHNxi6muO5P+/FDSHukbR3UQzYNUZH+9RNt
 RI0isey48BJvIiy7xK7jk3qVM28DXl+YCeu3jI2fLFYrAWJqy0tzVaTanAh6qbjLcAlw
 eaFZc759FNLxBsxtgNJ4BfAQRFbHA5fOqbOU+BobykofhZI/QjUT3Zm/RCejnFg7Bv28
 MzfvvCmCqN1yIauigRfpZiyXbb/q0yuJN8t/XhF4fSGvwRd53BMDgZoUAxXmwjS03SVW
 XjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+iu0t5BZID9srTWBP+2VrUQDFbl6lTqyuwf0tKjg+JE=;
 b=eCxNDFBwG2yE6gJd8P8i0npLH3bJF1k3K8cxybuHBOQVOg7OC3r7edNCY4r82PXJqM
 cXDlraxgeUCFOTR7SW992yDXk4yfU7XFDRxSwY5YUrDuPpl+lzpBpgh4dMTWIue/AmgW
 W6giF8DNTywxQ48nQbRK14dPELGgzOaOrFor0VkVJgAHyp1fDMIeIwH2Rs02CHsHWZ6I
 xg6ov/9V3Y78YbiaxfhMhMQkwgwRfAIqsmtRHR5QUUjCdBZG3DdQp/IC7gLVvVumYWEO
 fCtRn9l0MkTIeWzyk67IE4pw+tlb3KvuzcHIJjOEG0kI2qdX58PHY6DGRwE6iAJ8n/0Q
 /1gw==
X-Gm-Message-State: AOAM530+QYh4gX5tiqtTuVAIW77DHXpWRFtvXn6hty8Ifk9kk/vA9nlC
 ZkOac4xHB3XL6xuR5NWdYU4UEURV7+F5
X-Google-Smtp-Source: ABdhPJxCgwITDTWF8jM+n9TA0U3rRomDUbTmfz8t0MMwY2a20uS8WWMoTr0wvdf1I/4Avmktbd6EQAwHuiCo
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:c20a:: with SMTP id
 s10mr21383wmf.144.1615818957308; Mon, 15 Mar 2021 07:35:57 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:08 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-9-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 08/36] KVM: arm64: Make kvm_call_hyp() a function call at
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
index 3d10e6527f7d..06ca4828005f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -591,6 +591,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
 		struct arm_smccc_res res;				\
@@ -630,6 +631,11 @@ void kvm_arm_resume_guest(struct kvm *kvm);
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
