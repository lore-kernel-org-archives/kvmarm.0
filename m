Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9283EC4321E
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:17:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F5DB4B811;
	Sat, 12 Nov 2022 03:17:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QYUSbb-TJamD; Sat, 12 Nov 2022 03:17:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7C84B839;
	Sat, 12 Nov 2022 03:17:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFEB64B828
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8npoxYyV-utR for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:17:30 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 130C54B7D8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:30 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-37010fefe48so63438247b3.19
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=XowvsvOcOv2Dze5DffbrE0m7myhjg52x/AYqKu/6H0Q=;
 b=EsW5Gdp75rU2DUuHrGdfowsd3Xg7XJrLSdam+fpUtlwTdh1xrokqMFBjDQfu3ZSN5v
 3WNIAfsqOLgz9ApP/xZH1HRwWly+toBAPueZXyk9cB7bHX4lZw9gZFw4kGeCmEHf6xww
 tgIkAGZLt+9amtGXX3/mSDXUkXfTwEy7EGY+SR6BC7T6OygBkq45p4xA35d9sDiVisW6
 rs966VJsnUdF16OGJeOV5eAMSKeo90JTQ5w2yVogPJnhnlnsJXskfaWTBhhwD2JHSNut
 04cT72ye0o4MEN0FBYX5wuczQ8IkaZcFUgY2DAv5Ajod7vm1m9BGTFuDSumglosNjDzp
 7GZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=XowvsvOcOv2Dze5DffbrE0m7myhjg52x/AYqKu/6H0Q=;
 b=kltikhUfQ/XXhzpeKPsmWLmWnFWQWZiFiyH5cCfOdhp5Iz3pTgBMgbXG4LuJ3/CJM0
 foEVyeFGfGSU9R7WA2M4NnNfUWr9oQyi5L8EZ1J35f3+bQWNi4+39FxBnDjgZ+EQSn5G
 TtOlmkalp1lt0/vYcI6ka9m/13YkuBNESIAzul0HqsAe64pHKpjtudW3Samug+phSMTr
 e4jva9rvhPSpiJGGtOJeTkBh+KVglAz63WghejfU8RPI9x8QxzOThIuhy2AJveMUpRHT
 au5f/rSURGQhqMpsybZW/wGBvhmSwdjKHvV7eWG+ytamaU5aaRyEzOSyBr2IEYCnftS+
 NJfQ==
X-Gm-Message-State: ANoB5plrQrZ7VaDI8gKEqW2XmjmK4iCpUcZWQTFwu2jMb1YkFGuKKQTT
 JvTKzZVjcNaJXEVdKKRssngRYPZbaJiuow==
X-Google-Smtp-Source: AA0mqf5J4lgPyBB5y+f3Nq56r3EX+3f3XVFGVpba92grsCihrLzXFlwxYutDNVRoff367ywYqhaBZFCdb+AbvQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:cc86:0:b0:368:738a:b13b with SMTP id
 o128-20020a0dcc86000000b00368738ab13bmr5277155ywd.97.1668241049641; Sat, 12
 Nov 2022 00:17:29 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:09 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-8-ricarkol@google.com>
Subject: [RFC PATCH 07/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
 dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
 reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvmarm@lists.linux.dev, ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

Refactor kvm_arch_commit_memory_region() as a preparation for a future
commit to look cleaner and more understandable. Also, it looks more like
its x86 counterpart (in kvm_mmu_slot_apply_flags()).

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 318f7b0aa20b..6599a45eebf5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1770,20 +1770,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
+	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+	if (log_dirty_pages) {
+
+		if (change == KVM_MR_DELETE)
+			return;
+
 		/*
 		 * If we're with initial-all-set, we don't need to write
 		 * protect any pages because they're all reported as dirty.
 		 * Huge pages and normal pages will be write protect gradually.
 		 */
-		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, new->id);
-		}
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
+
+		kvm_mmu_wp_memory_region(kvm, new->id);
 	}
 }
 
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
