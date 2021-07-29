Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E56AC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DD0360F23
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1DD0360F23
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B55414B0C5;
	Thu, 29 Jul 2021 09:28:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H+Rgmqo96Omt; Thu, 29 Jul 2021 09:28:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6BC54B0D0;
	Thu, 29 Jul 2021 09:28:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 689C14B0A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NLkEYLgt4LdS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:25 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB5114B0B5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:24 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 l12-20020a05622a050cb029025ca4fbcc12so2729993qtx.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=crBqYydgsM0lLmpXbxrQzqnfwJboPEMWJ5uFG+CB388=;
 b=JOIVCVkTKSE7PwC39f/uN10vnOvi7Vzp2RTafhg3kyIB15DlDdxcNRRjKoM75ogyTS
 sjmXizIUunrQ4Q2yIkfgmJDrNF8nuB33MW7tB7YPCbcNhgcnStKG61TKLA9OHyXOwzKH
 i7uDNzA+PPHFpfTHJs2M5QoYOwbb6NUXBh++UvXlYe3cdezMzPl1EZ3sOx0jBVOxIit7
 DsJ4Rk2OJv96rif4hnZqeL50UBKsRJGWc8A2EaMc0YZVDJkZTXTjcJfL1x72E+Z4uyBi
 PGyvbycBPgY92pQ84g5f29LjEY96+E8Pod3jV3Xa3E41vkI8XuIPX9jDrr0GlJ2pzzRS
 RQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=crBqYydgsM0lLmpXbxrQzqnfwJboPEMWJ5uFG+CB388=;
 b=TP7mEC7RuYqRnAD/6gESZ+8yxaFvoGuWnB1LG4oqc7zE/KCxoIZ/Kpoh/B9Qj0hg4e
 Z9GhyWTyq361jl7gjbJPvM+DQo/s/ZPJZK4wV2VM/o6vxkYSWWqZyPTjtVkC6VyZdS5V
 rDQx+zhi0JGt0fR4G93OWGKSDsRbI0epaDcnNcw1OsNodLPaf3sBQsWv++YdhEY8lMhZ
 RjIZXtCNr0Gwr1uAj1NQduQpcbcRbRscO3z3uF3DBMnCUIg9eTSM5lWd63k4+kAcpiAw
 NR9rmWjQLvEga6LTcl8aEsSDsnrNAVoDRqkhGv4gFuKRej9zJZ3uwPLFJrbhwlopY26M
 NRrg==
X-Gm-Message-State: AOAM5337dI4olgxnwG0ZUXXCmY1eZ6RRsuwhrizVdqHju7I3v7L35/fG
 6OzZbJFaxbCnCxtC4vA5nvL2Tm6OMm+o
X-Google-Smtp-Source: ABdhPJxHRTBRw3rhOotBjYPWwjVk04U8m2F1PsiYgMcXVSq1/9Rd7rzCjHaUtz4DsAzceZrGz5P9KOU1HQzs
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a05:6214:1021:: with SMTP id
 k1mr5318862qvr.4.1627565304476; Thu, 29 Jul 2021 06:28:24 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:27:58 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-2-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 01/21] KVM: arm64: Add hyp_spin_is_locked() for basic
 locking assertions at EL2
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

From: Will Deacon <will@kernel.org>

Introduce hyp_spin_is_locked() so that functions can easily assert that
a given lock is held (albeit possibly by another CPU!) without having to
drag full lockdep support up to EL2.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
index 76b537f8d1c6..04f65b655fcf 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -15,6 +15,7 @@
 
 #include <asm/alternative.h>
 #include <asm/lse.h>
+#include <asm/rwonce.h>
 
 typedef union hyp_spinlock {
 	u32	__val;
@@ -89,4 +90,11 @@ static inline void hyp_spin_unlock(hyp_spinlock_t *lock)
 	: "memory");
 }
 
+static inline bool hyp_spin_is_locked(hyp_spinlock_t *lock)
+{
+	hyp_spinlock_t lockval = READ_ONCE(*lock);
+
+	return lockval.owner != lockval.next;
+}
+
 #endif /* __ARM64_KVM_NVHE_SPINLOCK_H__ */
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
