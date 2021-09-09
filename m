Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D17C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89B1361181
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 89B1361181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C9664B099;
	Wed,  8 Sep 2021 21:38:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y6BXXMEBT9PK; Wed,  8 Sep 2021 21:38:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 193CD4B0F2;
	Wed,  8 Sep 2021 21:38:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC0874A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OThMbUo+dMQL for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:43 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0B1F4B0A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:42 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 u3-20020a17090abb0300b0019567f8a277so320320pjr.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hjRX/HftaWd94e+jvOSEuHmijk3nZocmEtVUiH9mvr8=;
 b=DNT8H+P/i3+0pP+A8ae3zx+/69e/d6GKxdp5tnytAlBYxL1bysblA3Z96zvM7faRnp
 MiPxYxeza9JLHN0GpF4GmSXez3T0p4LoZRVFrVHQYzEr0LcPVUlKEELrUiWxD6I0A9Wm
 taOxz6ZoahTr8qdnhqB/tnCUY5TNl9VfVe5mDKpPeuQeDd5EQckZgFf63OfLJ5Pvjd0e
 IM/ym6YPja6fesLQKlJwdRY5BdXDUXU7h6AVrtoCG6Pmgk0KHvtPv9klWAhie36Uqena
 wWc0B+bDczYGE1Sq2/AfitLnfQKqzh5MeXwN4J65tKUXEmoCgUXw+E0W60fmyDJKwhst
 rOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hjRX/HftaWd94e+jvOSEuHmijk3nZocmEtVUiH9mvr8=;
 b=rDopQhZALn27tY4z+V3kosSBXwWBz9EuYVX7FciSkDCUeUslbbNr0o+iyIToZpuvdo
 F6cixPhzH9Esiv1rYg50yFJWSLzSYINWB5zDEJ8WpoOI6kSCF8+2M1QzbY43yQdn/LK1
 +EnZ1r8RWvaZZeQGn+LArILLTqhUOZ0NDQTp5BzTuvUftn7KrxBAmeX72w04Z9bWTDSF
 1y4swkgs59kJhDfZ0+5AhxPSPrWSZItpUEwy3u5McTOh2A+FGr1JAMJI7I3p5Sth8Zl+
 4JnzHk6qgtd9WTDZgMqZk1k0tZuv/qivmMDfjpRQR3JLz868BvCDEZd3ALYNHzuiYIhj
 92UQ==
X-Gm-Message-State: AOAM531UTXWAeqT5zYUcJ4ef6sPUTzoxwiAbA6oS4G6kVi4l3Su0Khah
 XnuAblWIEsjMBjocr0hLwJDdyzIbTTyu
X-Google-Smtp-Source: ABdhPJyDh2cPwprGNDmaMLhS9RKCSqm8CaY83z9TCFAffNsjqNFL2DJ5xQrC3RTO9+d6S+9VLvSevr3OyarG
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:a415:b029:129:5342:eab7 with SMTP
 id p21-20020a170902a415b02901295342eab7mr420693plq.26.1631151521851; Wed, 08
 Sep 2021 18:38:41 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:07 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-8-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 07/18] KVM: arm64: selftests: Add basic support to generate
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
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
