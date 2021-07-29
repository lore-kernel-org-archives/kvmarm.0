Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F569C432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 19:56:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F320360F22
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 19:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F320360F22
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0BD64B0C4;
	Thu, 29 Jul 2021 15:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id feZCH7TS-hXy; Thu, 29 Jul 2021 15:56:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6C7F4B0CE;
	Thu, 29 Jul 2021 15:56:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 570884B0C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:56:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cCRoB5LttW1h for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 15:56:46 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29EE24B0B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:56:46 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 c18-20020a0566023352b0290523c137a6a4so4467657ioz.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
 b=m3lZXoM3uP217QVv6csbkAltS9NEEhlX5Mu2B9nMMbJPkm+CF/zpiI1uNtLlaJ3MpF
 XKTxlciv8MR41Pp5L7tMTygFtTj8t5ato+tsIPb5PxLea28TW9AIQvorz4AvHHqUrbg0
 jl3TKtHlXkF/6dnirx+9CmRoi0oSZz7bUs5HqwZT5mfm5EptQVI1kIijkc+NydchjeGY
 k0xOPjTs+IS75wZoMWlION+1nkDz7PARYeuzxq5NugWy+CbXKybB1hCyzW6h9gKEWy7+
 JUI3EAqUwjfTN7sgZnM5Nc3G7DjRq4i1Np6UemRK4blDB/Bfs7c1L0Ww9qGVNI4nCEqF
 71mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
 b=NttpLzA3XuqMVRPig6ZHZxIKdNdACD0Zp3g6EQKzKZRSuqohSyoPE4IXT8bHaCroDI
 wb3GVSihkan8f7nw99yE4drpW8QHO40ZXKixslSqzmZygJdVQpFHair8t3Ztl+Uzl2uN
 7W2V/MCu9iwaQb+MVz1If9uoPFG7HhgoGzvGzgzdmfTgBNUBhDsfvUdjWn/10GKd2xwX
 wlh+pQuvQ9mUrrw90Uy5Pn9jBZPme2JrUon80eqINyvAwPIpcHiK/siRSc4RfRSNmA6j
 i44TPn09mv2B3EGQlBsrWRCbsVDjxHTeW2uNqX0Z9m393r5rG0wn+zUqf797tHx401Fw
 Z6nQ==
X-Gm-Message-State: AOAM5305j6Tis6zAqZYPENmjBFAgVpjfiHe1t010RKSrcbEKw9tTWh5c
 zK8SGmoH7ltXpnjQ0d4rPMHgU5f3DR1cGeb68pk1xp/5eVigWdESeQESJdxuYc4qnxwbPSpX/gy
 mpEmprI8uEvBmhDwKI++ataW91Xzw8lE5xpg+dI273jj61IMmczYJPeswHOH8kABza0LOnQ==
X-Google-Smtp-Source: ABdhPJwrrRQSELpkKclDmiXvKjRHCNyfC/t/jEaDJIBbOW61CMAAggTennP0JRqnhAKMtQYKP8Wl+xwYsLI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:2416:: with SMTP id
 z22mr5873473jat.57.1627588605328; Thu, 29 Jul 2021 12:56:45 -0700 (PDT)
Date: Thu, 29 Jul 2021 19:56:31 +0000
In-Reply-To: <20210729195632.489978-1-oupton@google.com>
Message-Id: <20210729195632.489978-3-oupton@google.com>
Mime-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 2/3] entry: KVM: Allow use of generic KVM entry w/o full
 generic support
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Shakeel Butt <shakeelb@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

Some architectures (e.g. arm64) have yet to adopt the generic entry
infrastructure. Despite that, it would be nice to use some common
plumbing for guest entry/exit handling. For example, KVM/arm64 currently
does not handle TIF_NOTIFY_PENDING correctly.

Allow use of only the generic KVM entry code by tightening up the
include list. No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/linux/entry-kvm.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 136b8d97d8c0..0d7865a0731c 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -2,7 +2,11 @@
 #ifndef __LINUX_ENTRYKVM_H
 #define __LINUX_ENTRYKVM_H
 
-#include <linux/entry-common.h>
+#include <linux/static_call_types.h>
+#include <linux/tracehook.h>
+#include <linux/syscalls.h>
+#include <linux/seccomp.h>
+#include <linux/sched.h>
 #include <linux/tick.h>
 
 /* Transfer to guest mode work */
-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
