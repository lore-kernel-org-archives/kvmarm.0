Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36261C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACE422466D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="nNRoD2M9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACE422466D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46F254B62C;
	Tue, 17 Nov 2020 13:16:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C3R52CV712XU; Tue, 17 Nov 2020 13:16:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43C424B874;
	Tue, 17 Nov 2020 13:16:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D85674B601
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ioNlcT2bLcF3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:39 -0500 (EST)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22DCC4B87C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:38 -0500 (EST)
Received: by mail-qk1-f202.google.com with SMTP id 143so10846922qkg.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=lh2wfGLmmAYfouTWYrt95KjC1/ZF6WAi7ZBhV5AjDD0=;
 b=nNRoD2M9XXWoWM8NgpAlnEhXBoYa9xn/smGakcLCZJxBll99tRVH7XlZ6kpAfLmDzS
 YEBOp/igtTiXRZTz+j56GXi5pzEcTsxtC69P2Bv0KA1AZUyCDWPY853b0xcR0BXqNsjY
 zzoThHvrbMLTNPm/8mNuW8sATGGuqFD6NUWfoAWRd9Krb9CmjdTe3yBuDe1UP2ALLPRo
 K9J+hEQ46hZWlOQ5xsj57z6jJFoBPfuEglscL+ZMWfWKy3HK4Aci7rdN/cI80VZX34fB
 Q8O1Od1+22A+zc26YZLJls0NZORus1Ag2kLC1/y6w0rVECW+qKDUHu2XDuWGww78dUnJ
 85Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lh2wfGLmmAYfouTWYrt95KjC1/ZF6WAi7ZBhV5AjDD0=;
 b=UDoL4WkSZK3y8a0XdnkEV8dFpounqkrunXemIyo1o6fMW/R7ix+sctm9MeGdEBtCi4
 nGc2Lqvo7krA5P8z7V3BM5JxNyFbXOy7+mBfuyYdOHZIpXQq/1+13I8M4yPWl9Ibde7r
 JPYXSeI6XOQnhVz9Sf1dQ2pwsGybRTMP59xy210NWmOQCWOfUIhBuY+IKUfS1gh+VjcT
 h3zdGgXWJqYWiv7SsYiaIlo4EyHwpkQtr8hj+R6C7GsTAXAeaqQxFSdMfLBpM0Kcthje
 cuM3prBp0nk0rlHZ4TEwGOWRNADGNRYXdr0QUpr/DDARDnP1L0NLrtYKVjMorwPJuoY7
 5tMg==
X-Gm-Message-State: AOAM532WV+GxkVYV4uD3hY3YHk1sNDgZEkIDcDr+ASdP6OydXewnYMNr
 tGXr1wXo38HZGpbuAGwpEa8t5B3gXCjy
X-Google-Smtp-Source: ABdhPJw9IfFuggDXuw8zeDBboBwHrDiqLV2n/32la8Pmpb9DK5T8ZLl8MJjnvcQGvWKpPM+6LkFNsSmTdWC9
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a0c:80e1:: with SMTP id
 88mr995546qvb.10.1605636997650; Tue, 17 Nov 2020 10:16:37 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:48 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-9-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 08/27] KVM: arm64: Make kvm_call_hyp() a function call at
 Hyp
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
index ac11adab6602..7a5d5f4b3351 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -557,6 +557,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
 		struct arm_smccc_res res;				\
@@ -596,6 +597,11 @@ void kvm_arm_resume_guest(struct kvm *kvm);
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
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
