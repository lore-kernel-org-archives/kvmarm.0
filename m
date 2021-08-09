Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6CBC432BE
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:24:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25BCA6103B
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 25BCA6103B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B90B14A1FA;
	Mon,  9 Aug 2021 11:24:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KRQtfZM7FmcI; Mon,  9 Aug 2021 11:24:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC3024B0F1;
	Mon,  9 Aug 2021 11:24:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BBD64A19B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:24:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AJ58Yk4AV3Bd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:24:55 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 967D24B0F9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:24:55 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 a17-20020a0cefd10000b0290341c3c56ff4so12559639qvt.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BeIaolisaUZtGeC9k2EMLoK7VySoIN8YqNGAmtfkvk0=;
 b=iotHDKdGhx5vD9VI+nB2hXHLhXQLu/dD/nLQap0ZXipIAdjHfTrBtWxzjBLF27fJvX
 V8y2aGlVI3WevnGv3a/oygvB8DWA83QPRUnoFEaP2mA/jZ5OzBE3dKjBkI9lUapxC4nI
 kvU0G+t3hmhMJm5nfdoXxXB7+P0mv3iMd/wNs0oYDeM9lA/FwvqtmAfoJDexoKDFfwCM
 /KfNeDHdg0hyO5xlCEKkrzl90VhfWtHnfpPf+mjOAQJeoMnDgQiNXR4arITrxhV1tsQO
 oADMUZZt36O4VZv5wDHUL3HnQX+JwOi7hViCI1DDa2kxcUEA214zGyr/oVnSEsHC2Sef
 V3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BeIaolisaUZtGeC9k2EMLoK7VySoIN8YqNGAmtfkvk0=;
 b=JvtJYL88X2nRhXTSg72kGYBm/5LVEV28HXnR2gy6DswQpvKKVFIZctlJM852+AUNTC
 96z+FuGL/gz9U4xhwKBHTM9bWQhilAa8CZ+arAYtU9iL/mB71dsyRFYcLNaT07vu5aAV
 zTW3QJCjdtUli9rciaN7sljybRxW2UscWV76lCVN+RFq6BJTa+ImIaupj6A0e25YpRb2
 sPzFeFI4GUL2kfUXF5VmL6jFwQHErinGP+LdrMMOxFaasK7+xi4ieiUNT7mlm3mM+zN9
 sUjd16n0ukXuwNkaSlRFUvc4TcbQTiaiQMHBPylAyLL8Rv4ty5QJt7XyiiFfpru6FbS0
 Yxkw==
X-Gm-Message-State: AOAM530NrrokuKy8K+EDMfBcB77KeBRQhT8X14R7OPMIEVxlVm7WZQxQ
 W0+moC97TLaLW2gBe01tr553iqYmDZnN
X-Google-Smtp-Source: ABdhPJwwkJx0vgQujLnN6O80r1QMwphuw2OhWcj7Ct18NZVCBAh2Ykl3Y1mymMGph4BEdeJQyMlOnYmLV0m0
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:ad4:59c5:: with SMTP id
 el5mr10407143qvb.43.1628522695300; Mon, 09 Aug 2021 08:24:55 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:29 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-3-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 02/21] KVM: arm64: Introduce hyp_assert_lock_held()
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
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
