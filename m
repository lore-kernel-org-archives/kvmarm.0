Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4053628
	for <kvmarm@lists.linux.dev>; Fri, 13 Jan 2023 03:50:09 +0000 (UTC)
Received: by mail-ot1-f74.google.com with SMTP id x26-20020a9d6d9a000000b00672c2f06716so10223761otp.21
        for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNJ/QahVWN0jZIoUQ1jgvhpTISkbQRg3HWBwcBAUB8Q=;
        b=jm0+bUOJ3mDeey09UoZ0K1vIDMCBj+tFUgrbwxmIcVKdV/6vOjsiE91Z+YAsIKjPWu
         2kpQ50Z4WNB9r7nym2XtMF/iO4yRZgvA3R4WmjEgkBI6mc0bVMLMiffonCYNjBoMCj8A
         sBVYWLfHCLn5nGR1VCPdDZQMeVS0gYvXQIx7Ev6TqxjI1WZRueWtRaFiGUISNolXtz5Z
         a/R2ZJsbH5ale00jO+gWq8rlz23NDTGWYJrXQ5a9wSdW57IG8ckAT49lbxGmUIP29nks
         jI8VybzlUq0TKFxHmXys9gUBDe2VJJnvlh6+enRRL+4X9iiZ36Z6EckhT5/CxKcopKow
         16Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNJ/QahVWN0jZIoUQ1jgvhpTISkbQRg3HWBwcBAUB8Q=;
        b=jJFQ/eWbxaxJRqAiH14ErU1FYmDh2RS68/6WsANasUWl4oTEhRqeCAJhjZrwcc9/n7
         Az8FdTI0pR1T5aoD8TmBkKNemJGN3bapcwuiOVeBRFrrVp+lHkQE2deO0mY1BaxyIz3i
         PvDiUu8/T+F+Z2LOIwTlAHT0pFkH7YWw97j9z0xCRbtWKEoslg2aLl4Bzog7au44bkDw
         VLJJ/UnpbOL8UQLZTjnc83euRDdGLEDkCX365Co1Axt8u5B1vLYYfEtQqQ1RKAyfUxyT
         hb2KqV3cSaRniM8t5VICk0FYOupbEV5/nTjSRWy5owwKWATRZfI6/d93F866kqx9GMu1
         fdFQ==
X-Gm-Message-State: AFqh2krLCJaN5ImHH5oRDsp+CWCD65yII8C30pKEx1E1nC380ceLiPct
	6cASz/sceYc8Bsf8JKG/1kTBOBEutXLGYA==
X-Google-Smtp-Source: AMrXdXtPfxk0qn/HIjWb+HtpyhFViCmVAVNxVfGLg7Z5Hw6JRRZ2JEjSNtm1ZCbxYwHrgd1azKVdovB2Qlsjaw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6808:628e:b0:364:45c4:93b with SMTP
 id du14-20020a056808628e00b0036445c4093bmr1421665oib.209.1673581808676; Thu,
 12 Jan 2023 19:50:08 -0800 (PST)
Date: Fri, 13 Jan 2023 03:49:55 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-5-ricarkol@google.com>
Subject: [PATCH 4/9] KVM: arm64: Refactor kvm_arch_commit_memory_region()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Refactor kvm_arch_commit_memory_region() as a preparation for a future
commit to look cleaner and more understandable. Also, it looks more
like its x86 counterpart (in kvm_mmu_slot_apply_flags()).

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 31d7fa4c7c14..dbcd5d9bc260 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1758,20 +1758,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.39.0.314.g84b9a713c41-goog

