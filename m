Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C0AC4320A
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CF5561241
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4CF5561241
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00E604B13B;
	Sun, 15 Aug 2021 13:01:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vMNQYWsA-p7x; Sun, 15 Aug 2021 13:01:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 097C34B144;
	Sun, 15 Aug 2021 13:01:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E3CC4B0C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8SgihpM9zHqg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 17:12:44 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9239B4B09F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:44 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 w13-20020a17090a8a0d00b00179486bdfe9so1683471pjn.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 14:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=X215a34XlYY9pGUGC8FkhsQTh0Gsxzcj/XXjeeVpyoQ=;
 b=MhG5TU2H2ct2ePotEwsSicyPDViGj0p0dNgvzvpHXfmVNKqBmc1ZjQmPtVVAonuJde
 BU+CeTRJkh0LBh+ubPpNFVTSxgKARa20AUTl8UQiMdHKXlAEYg7RnMQBmXry/Jq7tX6E
 HyjPLsCcwyg3Zm1H7xPkB/no+Ap0vtPMhCs6M7l5NmkCSDM3W+D9gq/VGH4//+udAhr5
 ZNR5VqLEllVpwMz9aoouLjSaz6VtfrwP4iv5p7fAAyZO0G3qasezZh7DVxHXqG67ICIg
 Q3oz6prc8gemBfCQX6JsypAqCGtUl0xbSekKnIyYMTtb6sBPimMXP1uueLUXJ7ixrNba
 liOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=X215a34XlYY9pGUGC8FkhsQTh0Gsxzcj/XXjeeVpyoQ=;
 b=Sw4zhlnNcOfC19byVkFpJ53lCL07oxVLrYoHmGuFTIKzqgxIgK4X93W3/BexxHC+9N
 qCGY0En+5y2pXpJdzeEBN39TwiMsDmJ4cEDe//mXUd/B0T/9zS5oHFFMhrL3fnYmxDfm
 6Ajzy2o6eYkvkVTh3429+zUFwkLRa5yEJiDnRTO59TwwAgS6fQ6gFG6KAtA6fgr91/3A
 bnTzXziNbuzSkuheUIMsZfax2JN9soGo5KXrMS+6mMJ3MDNB81OJ1a6PyJ16T24G5ol3
 X9x6p+DOzMEECyVfhVny/pl3Dwt9J6giywATK7ywDc8Ub/Qo0PyIiiufg4+zWYonqD38
 Ug9A==
X-Gm-Message-State: AOAM532Z2tXxvuGWOnVdwRIZVwazRV94Rb/ah4Y2YI//JSCpGuNLsWZo
 iilYo+MrXcshD2g1jvaOZh1MsNCDz9Uo
X-Google-Smtp-Source: ABdhPJwH9oPaXtIBXMnqXUclGdeHpy/TJgguUlPX0A6ayjUbxiIAsAwI3OwGGCxv8ROPipGomDhawmTskznH
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:de16:: with SMTP id
 m22mr4506677pjv.54.1628889163792; Fri, 13 Aug 2021 14:12:43 -0700 (PDT)
Date: Fri, 13 Aug 2021 21:12:08 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-8-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 07/10] KVM: arm64: selftests: Add support to get the vcpuid
 from MPIDR_EL1
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Sun, 15 Aug 2021 13:01:04 -0400
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
