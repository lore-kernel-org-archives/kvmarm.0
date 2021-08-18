Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A619FC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56F4B610FE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 56F4B610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A2794B08D;
	Wed, 18 Aug 2021 16:00:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FgVx09uyBsH7; Wed, 18 Aug 2021 16:00:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C42694B108;
	Wed, 18 Aug 2021 15:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9785E49F5F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02N8wdk44XpK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:43:33 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 937934099E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:33 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 1-20020a630e41000000b002528846c9f2so1960630pgo.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=X215a34XlYY9pGUGC8FkhsQTh0Gsxzcj/XXjeeVpyoQ=;
 b=D8RHHn21WpX7lOwcIGclpa5kQE9RPrULMWoIr/pvS4NpZo0Om1eqeAlu1PRP1P1eUF
 IdyNGXYQlZoDhrnT3JirR7kCp1sfABUN3wP8ISx+/rHQNa/uaYACjvTkMJcse4rGqVlz
 XBnxDwirlSF4VOhIF/5nBLRWCCTw+r4O15fySStZfB+TkB7wprD5I4OlSun+ipBQweza
 scQJh4Nv3ll/qCJW/B2bso3VW59XorbpEscb4i/A0aKU5v/j81XzbvdWK1xd2FNCXBNU
 Hf5rPzbe/jNV39F4/ok6ZZoZoEzVv1ekZWY/46D5H2j638X6BySeNRbZJFoT54/mOoUr
 +TGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=X215a34XlYY9pGUGC8FkhsQTh0Gsxzcj/XXjeeVpyoQ=;
 b=QCopW8aN3SpHoNnPdxNVdQCyhQO3jdwhwy9C3Op7WxsllHOVWWLZxlPBvhFSuGNqZL
 LgleSgRu6z7ECSAM/XguFoeBbN2bFXoue7CiE8gRItQ/BZk396s0KCeYcQpUM+dpgltu
 zSbgvkKEco1q355LhjYd0xlNd7r0zSQ1zuG3pg6o2/4paSGznwoPfOVx7RS22KZz7kUT
 EJSFToovbRTBjyozQ3xSa8IumPrM/anEFUHBtioDzs7CObxMlqo1GXZQNM5HksvTBFOz
 M/6hPSd/3tW0F50SJjlRGeG0at+Ixx04pkXf6se9Fo5u40iuSoIFOy9kHxt/EvcgQFXz
 lxUw==
X-Gm-Message-State: AOAM533ss83L5TuJCZbrJTcoBh86Mvy96JyPmOkWT+lJiblkE0YB5Rp0
 YV4zn8KHJrSAkaLib+MGPXEeVldnVW/e
X-Google-Smtp-Source: ABdhPJxNdjQSpOttv8J6ZV+X+0iEAxdfgHwp5u0JVDm7jCBLggrHgvVi0/5rLv6kFjQEQdwhUcVWtBV59Aca
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:43a7:: with SMTP id
 r36mr91749pjg.1.1629312212315; Wed, 18 Aug 2021 11:43:32 -0700 (PDT)
Date: Wed, 18 Aug 2021 18:43:08 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-8-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 07/10] KVM: arm64: selftests: Add support to get the vcpuid
 from MPIDR_EL1
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 18 Aug 2021 15:59:47 -0400
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.cs.columbia.edu
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
index ae7a079ae180..e9342e63d05d 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -248,4 +248,23 @@ static inline void local_irq_disable(void)
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
