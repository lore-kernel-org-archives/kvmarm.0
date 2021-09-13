Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51394C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:10:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03BD061151
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:10:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03BD061151
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9CF4B217;
	Mon, 13 Sep 2021 19:10:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KlU1OYnYuHB4; Mon, 13 Sep 2021 19:10:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C4B94B220;
	Mon, 13 Sep 2021 19:10:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA9824B149
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:10:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wm-W+fgVKCYU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 19:10:17 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE53A4B1E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:10:17 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 h9-20020a17090a470900b001791c0352aaso5981616pjg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
 b=L74ftL0MnBDplytzX70ckvtTydMK0Eqbh058KvbeC7UELLvibodQtUhzEX3sYxlYaJ
 A2UkkQkn/G8fh+gpTXpjWgOV6XSPp1b7hJCymZ/nnuhX99gImgZBDhAsLQ+gcmxawHmq
 Ff+VM14GiOcjF0C8O95JMlr+EnM4Dv+iTOybu/LJosUhlXrnoelVNW0b3qmZAsAYxN8W
 96Fwg3AuXRFT68xYPygavi2uYU+F47+Ri4xMSufvj9uNMeya/FU8TN97LCCo15fY6210
 PYSQVNmyPuSLz+SeTHQrezFBodpaX0Hc2kB6Bd6aphu2xJpd4xO2ce/NNiM/ppfyeYKl
 Qkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
 b=mfBjz05ibzgoeLy5zjCW+/jn4pWeUEBYXO+70IsQYZdzd4OOcUJPI5+4v5ZyB2Y0ph
 7/wbWM8V5YDZKTS//7jQ4QsLOyutRUOXPfgRA8DdwjYbj/W56r/ob2OdRw5kp4RQ/RqM
 iW5oLsL4IidZOCsb11BtazkZh8m+nC8pvhyr1muYKx1CofHen9p6EpagH7uK0s2pYubW
 7VTXfBGY6SSX2WwDDvwsUYmq7m+d5WVa48w4KNbyerdltlBV/DzD3g4zAUATegWsK9po
 dTO6iThDw3IJTvP81BwKpul7QGnQ0hGxhcL5c+c1zmfJh0AkdgliY9GkWUZ0dDUk88pR
 bHjQ==
X-Gm-Message-State: AOAM533+2Ef/sHgad2PSmm2px4E2ZZu9bVD1EYXqigPmn0v6/dGKRLLI
 DatLAbTrQzKF4AgDRJ1EF0VqSXzZfnDp
X-Google-Smtp-Source: ABdhPJy8bvr4FrZXQ2nQUysQcP7QaTOqreVVEVwJaF6HiOLbS3oknxNpc+PhzJi/hmUqnKElBX+9Bl/Hnfw0
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:6c97:: with SMTP id
 y23mr2075372pjj.117.1631574617035; Mon, 13 Sep 2021 16:10:17 -0700 (PDT)
Date: Mon, 13 Sep 2021 23:09:48 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-8-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 07/14] KVM: arm64: selftests: Add basic support to generate
 delays
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
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

Add udelay() support to generate a delay in the guest.

The routines are derived and simplified from kernel's
arch/arm64/lib/delay.c.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/aarch64/delay.h     | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/delay.h b/tools/testing/selftests/kvm/include/aarch64/delay.h
new file mode 100644
index 000000000000..329e4f5079ea
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/delay.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM simple delay routines
+ */
+
+#ifndef SELFTEST_KVM_ARM_DELAY_H
+#define SELFTEST_KVM_ARM_DELAY_H
+
+#include "arch_timer.h"
+
+static inline void __delay(uint64_t cycles)
+{
+	enum arch_timer timer = VIRTUAL;
+	uint64_t start = timer_get_cntct(timer);
+
+	while ((timer_get_cntct(timer) - start) < cycles)
+		cpu_relax();
+}
+
+static inline void udelay(unsigned long usec)
+{
+	__delay(usec_to_cycles(usec));
+}
+
+#endif /* SELFTEST_KVM_ARM_DELAY_H */
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
