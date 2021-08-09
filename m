Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE7BC432BE
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:24:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED6EE6103B
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:24:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ED6EE6103B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DF114A1A5;
	Mon,  9 Aug 2021 11:24:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3QPEe4-4QuXF; Mon,  9 Aug 2021 11:24:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8677D4B0EA;
	Mon,  9 Aug 2021 11:24:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28D774A1A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:24:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BBV97N2oWUvi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:24:53 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BC874A19B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:24:53 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 k7-20020ad453c70000b02902f36ca6afdcso8290209qvv.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9BduUGnjsWum8FcOsM11gO3G+u8+79slhTeMYYKry4w=;
 b=g983I9YSVoWH/a7/cl0ZycwVjzqZeyo8x+fLCew59C7a0BnEu2wL6cysC50kAFs8Vi
 ehEdfCFNUnOWvVuDeMXGfwSfjkPO6irIfVDI1BOyVgOb2mistjn/3qc9aekGj3nyWfEP
 mv2IxEl7l/db3vL40dr7vcCKECuWFlGEQTsXsxS+OPHN8h4PW005Da05hkZ4QrGVi6/c
 iy5E1D2xv8HABlnaCg5SV0NZvQskMmKX3vG7+v7NRPhL/iuVTDX753+y/AxDWOc3l6hM
 igtE3JtznbdG+M1JR7b47U5TTSHB4/v8dAR/v0CBrRKmc9w4iH1rKAt2xMXY4Rmb58AP
 IwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9BduUGnjsWum8FcOsM11gO3G+u8+79slhTeMYYKry4w=;
 b=DQdGAxG1RltglFFOF4sH5HQh+wRfLeLtfLsCII04OUE23CDZBsMVhj/01pyY1xlwi4
 Rx+rm6ULameV7C2wePY8xp+bsctOxWoFolEaM9gSwmGcKBtyJ6L/6Cs4AZFZBDAVtcMM
 t2fG16HWJzmtF8ob8bbos8kONXa4v/duRBn37o7rZ6g3Mw+PRL5kIyEafpyTRnpMEYC4
 oITbRBQCqbD1bEs9FOl1s7vnrdd7mU6MoCg2eBRCPTfHfsYAsunwK5w8aypqgcWvSC2v
 t9UPfXZrAfZuD1DVtg3vTMkJM+y5LrfqEG/2sfJy4r+8IkTTKJcIBYlkvQtJ0f9nGZm/
 /v8Q==
X-Gm-Message-State: AOAM5318xvgjVRGPDdL/QjUfmE0y7T30qN0yMhM/YvkarhzR8DtyxL7+
 x7rO+vrNZACKJbe/Tx+SPqIucgBvAjpa
X-Google-Smtp-Source: ABdhPJxcZ9biebm1fDKv+UMiqbVL5l0nCshM5eLfjTeBhNH2YYSYI90HGbAFPRYEaW9dglJFBj8tlcbiknXL
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a0c:e609:: with SMTP id
 z9mr9405599qvm.37.1628522692904; Mon, 09 Aug 2021 08:24:52 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:28 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-2-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 01/21] KVM: arm64: Add hyp_spin_is_locked() for basic
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
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
