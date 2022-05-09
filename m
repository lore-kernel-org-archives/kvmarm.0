Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F470C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 12:03:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44ABC4B2E9;
	Mon,  9 May 2022 08:03:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7rXD0EZ4LauB; Mon,  9 May 2022 08:03:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7BAC4B2E5;
	Mon,  9 May 2022 08:03:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B8E64B2F6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sfM6hmQ7zVBM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 08:03:37 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48E6D4B2EF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 08:03:37 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 m186-20020a1c26c3000000b003943e12185dso4169206wmm.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 05:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2IAt5dQwtvAG3RiQIn69aK8zHEfSjm99svJSdYnazxI=;
 b=T1bQmY5WMqOoiA4dWgHSRCNBGFwy1srzW/sn5dDbu/tX5JK4d1r0efExShdnPH4FKY
 /7sMlCHKqZI/4LQSakBTvSPq5yF+A1xZBtutXmShFYAsJ6SLCaMiiQcYmwzS83T8hMmR
 cTXjqaQgJAF2VUY3jx440mqoJAIwUVKF+zVdzrHe2X3+pXZI6AXHuTm2UbkAfCnecbrQ
 miAuOlrpmV+ejeMJNSOG0LjqzGo99Xroc52ljiDRnl9qwwdB3h0Q47xoAOvhGzV4Bp2e
 xPBFo9bvKM4nakO5w0MsKfyHuThWnJqziMTZZw5y41Yg6K6pwrMe93kmGU6VeZ5oEz+L
 5h6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2IAt5dQwtvAG3RiQIn69aK8zHEfSjm99svJSdYnazxI=;
 b=UaZAibJEWsVDyw0WS7fUVpvxowztVmQ9JFpl1nX5BcqLp394hR1DDQKXjvSXY9SqxN
 EEplOuxYF1C0rFqTYx2JXU4T9Xj2XiJcHYn/gDJy4ijgx5QXM6OOoQyNUMRGqlT+NZCs
 A744ZLpBXqgN+QlrkksrQyS84pgNcN1Hj5+j6Va4C9SlV3XzwYcPsw+DTSaCNl3jGFC2
 D1XV4WEHSQggAMr+tHAMRv1xRpepIpULJA1QgskuGIgfSagL08C2wpDo5c1pRuwF8XIE
 xSqe9GYquDuLwUq7tjbMo6ASO0TriddFYdPQ9YTTdSU9pRJkDcv8ViI4HfcYAu667kpp
 gsIw==
X-Gm-Message-State: AOAM530iY8of2IKy8Md33urYplPtTpD1YK+qwRRaECfDe9YOfDcfUUWg
 6LEb4Hi2Z90KYyyv2l67sEYckSWf4NRH4k39LioODJ7fsehvnQPhoh1eLRZq/CarUXkMVOWVnws
 flbxbepHXxwg5tgb3L+LIHuteGlJMhiYVrOhg7Hi+/CRHUCjkRuM1ngZJoQqShahekVc=
X-Google-Smtp-Source: ABdhPJw4M7oFpKwBkZ4zAMju5qT2mCDPBgJJ6xbvDi4JbpFYlfoWDnry00S6CaUCcw0l/QUQc+MjRkpkLg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c4d8:0:b0:393:fecd:2718 with
 SMTP id
 g24-20020a7bc4d8000000b00393fecd2718mr15770809wmk.23.1652097816382; Mon, 09
 May 2022 05:03:36 -0700 (PDT)
Date: Mon,  9 May 2022 12:03:28 +0000
In-Reply-To: <20220509120330.3043773-1-tabba@google.com>
Message-Id: <20220509120330.3043773-3-tabba@google.com>
Mime-Version: 1.0
References: <20220509120330.3043773-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 2/4] KVM: arm64: Repack struct kvm_pmu to reduce size
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

struct kvm_pmu has 2 holes using 10 bytes. This is instantiated
in all vcpus, so it adds up. This repacking removes all holes.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/arm_pmu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 20193416d214..eaa8290b116f 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -21,12 +21,12 @@ struct kvm_pmc {
 };
 
 struct kvm_pmu {
-	int irq_num;
+	struct irq_work overflow_work;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
 	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
+	int irq_num;
 	bool created;
 	bool irq_level;
-	struct irq_work overflow_work;
 };
 
 struct arm_pmu_entry {
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
