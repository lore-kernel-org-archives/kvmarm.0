Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDD9C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 09:55:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 940E44B2F3;
	Mon,  9 May 2022 05:55:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9a2ItyFu+wsU; Mon,  9 May 2022 05:55:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89AA54B2FC;
	Mon,  9 May 2022 05:55:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9912B4B2F3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I4+qDdxBqr3T for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 05:55:08 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 051F04B2E3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:07 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 e21-20020adfa455000000b0020ae075cf35so5613146wra.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 02:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2IAt5dQwtvAG3RiQIn69aK8zHEfSjm99svJSdYnazxI=;
 b=lpH/+8as281hqZUxcSof0AoV/+svBOb/BCwMDi41vDXH9SwuutgTMB5yi3bUlWwbLJ
 b39iTziQbmuFtZH6DVCTx3bNMhcx1cmP7ZwYo0jDyx3yR8OKrE51S7ZhQLPx7wLCPezD
 qw9UBItkGlt2s3mJ2zdwyB0c8RxfS4YgVbrq4sHM3EO9ZRqwDW5MW8T9HgBK+sMUwRe6
 RKpjxAJ3ROb9lFSZI1FeIO16FudM8JP1T7t5O1fuWTBlIgNkIPK74yUsCnWdPinSB08k
 GZJ6SQOV8++xqGdrxAOAP/nozCrVdIt02DO/U8kReiP0oCwqiKxWdvTeq+Zgzi3ku0Fq
 VZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2IAt5dQwtvAG3RiQIn69aK8zHEfSjm99svJSdYnazxI=;
 b=ZISOlRZtufuDomOUSTWYlFHcT8TW62ysy8+1+UqWWUzDKB9MvQDG9Isip7wxxEUqQ3
 xBluBi0OrKeXwOHchm16ft7NzLNXbMUOIxIX9+kPmuXOaa6cW1769esalLIpNILlqNin
 Fe7JKy8vG0xqxuWLzkoxO/IHDpetGmq9ZMFr8o8LwqtSZ+vfdd3FTkL6eJ/vz8X3khV6
 s++LIHA4D4OI5NjTfGRhoX4PM4uTvpDSb81QrOzgRRBhv/fhmeUCqeSbWDKRBzPRy2l9
 +dcmUT9FOsA/qp9iHzyhjjIrhT9FDJ2Tg9PHBibgoLVLMdxMsZtqK8hnrwWPMMXOUkk+
 MKFw==
X-Gm-Message-State: AOAM532LpYdnbkR5zP6V/WaU+GINPJAMAybkAPEAMvly30ILu/+gix9i
 /B2GQvju/QVqfKCSVS6VjpA//TOaulT26cGj3L8xKueu3fqH3gBztLSTJD9bn8NvkXHKFKljDJu
 vIQ54TSc8dCHoft0tt7E9Z6jrYzMJR6n2fC2dHV4frbECCcI6qlJRhEqOKGEkjNY+DDA=
X-Google-Smtp-Source: ABdhPJyC1Cd7Hn9V24FAKY2cwQpn+sYGG7AiMinZ6qOXBOKNN+drqBQy8/nob6iXaFvhd8gd8GjJzPgaqQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:501e:b0:394:8b0a:3ec9
 with SMTP id
 n30-20020a05600c501e00b003948b0a3ec9mr6214776wmr.0.1652090107148; Mon, 09 May
 2022 02:55:07 -0700 (PDT)
Date: Mon,  9 May 2022 09:54:58 +0000
In-Reply-To: <20220509095500.2408785-1-tabba@google.com>
Message-Id: <20220509095500.2408785-3-tabba@google.com>
Mime-Version: 1.0
References: <20220509095500.2408785-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v2 2/4] KVM: arm64: Repack struct kvm_pmu to reduce size
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
