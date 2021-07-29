Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2356DC4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDBDA60C41
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BDBDA60C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73F0A4B0B6;
	Thu, 29 Jul 2021 09:28:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NNJXfxWYUrJi; Thu, 29 Jul 2021 09:28:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2C104B0C6;
	Thu, 29 Jul 2021 09:28:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF0204B0B5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QO9uNLk5SB8m for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:28 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 915BD4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:28 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 25-20020a05600c0219b029024ebb12928cso2009003wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=t7+5ofN1mhSPCYy31zt7RU0I2nBRXXWPYqlSGOk7ubE=;
 b=EOWUMMsZPsB2L4bsN4GxoGi3y0igtMQJVuIWpJTOwkroahO2vrvgGKDlL7RtzJMlsM
 0oE50dz19H3398h3CH7lGvES9i7AZ+VyzBn3LLKoJN/6N09gfxN4nZrgog/WIOpdxF48
 B/jbMHiG9QnFkf2f639cMBjVse7pVDqHc+1Ylei1mCqOmtyDH269kxdDb+J0Kuh6hwTv
 9+n8fZ5n5Q8wA6fg82FoPSbY9mbZRd1dd4E3hdMvxHuv/9ztJK9IqX7gYuN2lWpjx5+s
 +HFOzx5RoBxyC3x0/qNim7tnNdldKJhuLJ7GxVdP5C7TH7ZDgtXRup/AoaGjp/YnLSie
 c8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=t7+5ofN1mhSPCYy31zt7RU0I2nBRXXWPYqlSGOk7ubE=;
 b=bqUvRVXlv1Vn31tMBwBUlBGEymV42mPtWK1aokxDbCvbxvOlBHgDsBGBcwoxdRaOK6
 tN5EVaw73ZWYMudpfdExqqE2jGPvbMrvQ9HRzHRJU+poChAprsrkFQfXhNQrvRqG6Yan
 atudi4b3w+Se4xC31NDb1cUD2X1e1E1mqf+Un7yTw8sfaXN9fojlTTsM1jClN5dBMHB3
 MDYlkL38g7lInk4nwUeSAieA1bjmkux2NbVRg/V9RN8BsuVO09dqFkYSkiu85DfQCo8V
 HhpNdye3zWGtB70dQHyZLEWQ+yfso64UxMpFLfU+wMsp2fNPv3eGl49ofVp51bJtuUY9
 HoCw==
X-Gm-Message-State: AOAM531v4U+XAFBUzckIaps09Fi11a9ovMNN5ya1lpdAt0TFXiUwxKoL
 6RqJr7IsuXWE5OMxMCEpNauWc+fHQbrc
X-Google-Smtp-Source: ABdhPJyA9LhjEf8A/taAM06dydN+uO7RN2g31fVg3fvbmNEB2A5ceVlvMQQeLCoX2VjPrd82TvrUI4VZN1Ys
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a1c:4b0a:: with SMTP id
 y10mr4499wma.1.1627565306816; Thu, 29 Jul 2021 06:28:26 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:27:59 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-3-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 02/21] KVM: arm64: Introduce hyp_assert_lock_held()
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

Introduce a poor man's lockdep implementation at EL2 which allows to
BUG() whenever a hyp spinlock is not held when it should. Hide this
feature behind a new Kconfig option that targets the EL2 object
specifically, instead of piggy backing on the existing CONFIG_LOCKDEP.
EL2 cannot WARN() cleanly to report locking issues, hence BUG() is the
only option and it is not clear whether we want this widely enabled.
This is most likely going to be useful for local testing until the EL2
WARN() situation has improved.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/Kconfig                     |  9 +++++++++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 17 +++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a4eba0908bfa..9b9721895e5c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -46,6 +46,15 @@ if KVM
 
 source "virt/kvm/Kconfig"
 
+config NVHE_EL2_DEBUG
+	bool "Debug mode for non-VHE EL2 object"
+	help
+	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
+	  Failure reports will BUG() in the hypervisor. This is intended for
+	  local EL2 hypervisor development.
+
+	  If unsure, say N.
+
 endif # KVM
 
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
index 04f65b655fcf..4652fd04bdbe 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -97,4 +97,21 @@ static inline bool hyp_spin_is_locked(hyp_spinlock_t *lock)
 	return lockval.owner != lockval.next;
 }
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+static inline void hyp_assert_lock_held(hyp_spinlock_t *lock)
+{
+	/*
+	 * The __pkvm_init() path accesses protected data-structures without
+	 * holding locks as the other CPUs are guaranteed to not enter EL2
+	 * concurrently at this point in time. The point by which EL2 is
+	 * initialized on all CPUs is reflected in the pkvm static key, so
+	 * wait until it is set before checking the lock state.
+	 */
+	if (static_branch_likely(&kvm_protected_mode_initialized))
+		BUG_ON(!hyp_spin_is_locked(lock));
+}
+#else
+static inline void hyp_assert_lock_held(hyp_spinlock_t *lock) { }
+#endif
+
 #endif /* __ARM64_KVM_NVHE_SPINLOCK_H__ */
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
