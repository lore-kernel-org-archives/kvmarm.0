Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5FDC432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E30860FDC
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8E30860FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 430AE4B17E;
	Wed,  1 Sep 2021 17:14:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FugtZLgLWATx; Wed,  1 Sep 2021 17:14:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56F7B4B199;
	Wed,  1 Sep 2021 17:14:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D66774B150
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZlIUXfWwSXzk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:14:45 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 326E64B1E6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:38 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 b65-20020a621b44000000b003edc0db6a05so442709pfb.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ped5Qc1MM58GGqP18bC+JKvQQkEpWjp7CacWspbiPtU=;
 b=RF+xTrhE1y86Km4Tb2P3P9x56sxf1fIXwOzrKjBM264X3P2jQzCHZAFGTfbfshgqxp
 I3ViPwQGHlQjxAgXUxwylm+7TJXn1t0vKlHBNeiWKYzy32FmgouYKSW1+zXACYXOmERd
 r1JAAHqU3TM8b+t9jnwQP7qDF27X9+iLHlb0cDiMAmb0Wv6zsY9lrfRDcfkC7z9IKFmJ
 Uc7FZRXODjWUGiyg8Nis9o3gpVnPnwn0kNKJwfzsPYJn6kCiBtbCuEpwLZQ4Djl/A/PM
 DwP067BHcP+WdQiUBG6ujxS/hVn3djeGiHvZAJqMiAbzGV9d3zi7VZkLieJlF4xW7BsM
 jeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ped5Qc1MM58GGqP18bC+JKvQQkEpWjp7CacWspbiPtU=;
 b=Qfgx4KdOdNJczlJlPMySFqSnQvAcY0Uj3Oh3yqa/CitC/FE9rhgxvK0szmAHEwYzGC
 0pKsD9B7f17Hu9/CasEwxMNlDPKRFvKqP5aXrGfGO3qoljLUHs5KmKakMzYq5rwWTKe8
 /kSdcgOnyWeeUD3k8kiKDqDVJqgN0yZbSw6K8rAsKskc8gGuUaXvlAgICNg71nmt8RBq
 COYLLcKKl8R5rFvboE73sEbOiRu2z9NUTHY1NsMK9BqPm9NVTmMUn6ZClZQdeDC/sk0u
 CtsB2kVUlSUDCEc6+exkiarIP2UfuwvVVefqpw33kEAXEvVB1pX3RiI4E6KiqR9jgdRy
 ii9Q==
X-Gm-Message-State: AOAM5337dLS3wizoEzjdvSUEuzjwcMlmrmnejldtA9UlmindBi31INSO
 O41JF82J5h9VD3/XoDhv/CYlpS9EPEL5
X-Google-Smtp-Source: ABdhPJzrG1HjvKDU2BB/zBmu2XADs6gKwEPEuy+cbmfKmRvnNPWrGZDzEUEU4Y01W3RLEFRXnQKuk3qmFLfy
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:7d4a:0:b0:3ef:ea37:1422 with SMTP id
 y71-20020a627d4a000000b003efea371422mr1327446pfc.0.1630530877389; Wed, 01 Sep
 2021 14:14:37 -0700 (PDT)
Date: Wed,  1 Sep 2021 21:14:07 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-8-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 07/12] KVM: arm64: selftests: Add support to get the vcpuid
 from MPIDR_EL1
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

At times, such as when in the interrupt handler, the guest wants to
get the vCPU-id that it's running on. As a result, introduce
get_vcpuid() that parses the MPIDR_EL1 and returns the vcpuid to the
requested caller.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c35bb7b8e870..8b372cd427da 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -251,4 +251,23 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+#define MPIDR_LEVEL_BITS 8
+#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
+#define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
+#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
+
+static inline uint32_t get_vcpuid(void)
+{
+	uint32_t vcpuid = 0;
+	uint64_t mpidr = read_sysreg(mpidr_el1);
+
+	/* KVM limits only 16 vCPUs at level 0 */
+	vcpuid = mpidr & 0x0f;
+	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 4;
+	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 12;
+
+	return vcpuid;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
