Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739EBC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF05D23975
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF05D23975
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F79B4B386;
	Fri,  8 Jan 2021 07:15:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WJCB3yqnxDFz; Fri,  8 Jan 2021 07:15:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04C734B3F4;
	Fri,  8 Jan 2021 07:15:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 687F34B388
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QybDkppc0c0S for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:44 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1C634B3FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:43 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id v9so8124409qtw.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=FNjMcGMBepA+DKYzWBZdafn9Pfvz5tgi5bFjDXzrpjw=;
 b=MnwPPAzoXNwaOiIaAGjdxyYKgCpjZp6Y/8k70XQrFxP2o4aKAID1+AZSD9MNSZDBu7
 C1KdtY+o82o9hD3Jv3i9pN11yqVnvTEMzLJECVqtKuxjPOhr4G+fCEVPEA1slzI1JowR
 CSXnnwarOjT0oN1R+ZhxnBm4V4rEHrNYwYu1fsoKb+lRL7HgwNvni2KmTT4h/RzLGhOO
 llmt1BjnI2tjj0RTLZJ49lVdW1/iNrO+a1O+zULzBx1EyMYKzRKJa7IR/UiOX2z6y3so
 2Qt8L9hn3buycUtLVrwGXMuKpsy74lToWQTVDmDWMw+PhLbObGNxGzeYdWb4/SRx0AMn
 srfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FNjMcGMBepA+DKYzWBZdafn9Pfvz5tgi5bFjDXzrpjw=;
 b=VW87bf7erXrxP94q9AdfD/FhRZMVljF7WlwIxjfvdYiwNPOCptLw5JAKBgo6J4iyJi
 2lk98dvmsuUNZswXMmCP0tuS+5ZHPMP3RMoF/0YIRs76ZD9IzYo0au+Z3SNW3E0gNXCK
 TxEyl8sa1MZXhb/TslK1A1i7FYNaUp1ZiCyYNWBONHFjIEL+ynAKgnRw5LZI3pvwkAnq
 ta1/BgHjSrsQsdEoE5RJHjddNAC2fscJRdCnOthu61u3omFJw61zHiw6CsNYKUayDMoW
 TXIsP0zfekJehsjZoPMZLpqHJosXh+JbRhUIbUfdrZ8y8LNfQnBSKkTDuPJTKni6gUvG
 Yxfg==
X-Gm-Message-State: AOAM532z3BvrFJ+c1o8CU5PWWld4edXOGJKo7UM29ERYff1GjWwKqFky
 WL5SnhWovMe7Cu7Ghgx87YWg8gTpk6TG
X-Google-Smtp-Source: ABdhPJzuZf85ALEgP2PMc7AcYtKZ4On8truit0/ITvMunEfbpbr7IAAERcJbv904cp6MdFKGk7/AvT6xTBf6
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:1754:: with SMTP id
 dc20mr3314023qvb.7.1610108143358; Fri, 08 Jan 2021 04:15:43 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:06 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-9-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 08/26] KVM: arm64: Make kvm_call_hyp() a function call
 at Hyp
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

kvm_call_hyp() has some logic to issue a function call or a hypercall
depending the EL at which the kernel is running. However, all the code
compiled under __KVM_NVHE_HYPERVISOR__ is guaranteed to run only at EL2,
and in this case a simple function call is needed.

Add ifdefery to kvm_host.h to symplify kvm_call_hyp() in .hyp.text.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8fcfab0c2567..81212958ef55 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -592,6 +592,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
 		struct arm_smccc_res res;				\
@@ -631,6 +632,11 @@ void kvm_arm_resume_guest(struct kvm *kvm);
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
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
