Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8077538A
	for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 17:23:46 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-52855ba7539so2170219a12.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 10:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529826; x=1685121826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+eiBogFDbJ7/PpjU5DTdjZ5VwrrLAvstoq84EX5RGOU=;
        b=qIGeiokt1nAg4zwnz5OaInuRBMHYly9IwuF0pq9C26gAiDVU3UYIhR3l1L6xR78asd
         1QXuIVrkRf2D/EgxWnv8QDPmwelefKIM+jjYZ2djKdi4m18MWOQ1Xo+X89aABga+UBNu
         duHNdg+RUjom9o6azIXPg/7oLpYK+J1Rkljaxq3r+GNhRH8OhzVuqSYHI2k0eIoNN6MI
         lBolXE4PmsQmynm2b1hmhRFXR5r8nR82jKUgsNOZWiIuPvlLj/lZslPAdJSdczmokKOr
         fUOASxRB6ZbOVnNJakDzfQVxpYlS9BmsdzZC9ryOHKGCebfx8wriuLE6Sl4U8drucT29
         xVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529826; x=1685121826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+eiBogFDbJ7/PpjU5DTdjZ5VwrrLAvstoq84EX5RGOU=;
        b=g14Y30UMurtQW/qw2Fb1ZV2wB655PpcrCKuC9iqAs7RKcbqUcXQ6dUuVy6fOSF1MvC
         iAcoXZ9f3XCvlQW72HtnoAiWcMsViiMIzXuKWY4WXR3kZarD6LrE9POk4hbpUVD2m6VV
         NnAs/1tKbr/TPJ6kfbo8pQtPMpsBNNOcTjOO5iaL/jvDFER6fw6u+ixWusuZ66SnR+Ww
         GTMxOpJWKHwLxXgWpko3/oIgaw7LmHioh0OazlE/xNH3TDuFyhSUYuC475pWhgEgX41P
         Q8dsNc+2yk6ufOoUrDvBXucHKL0+Wl56Rc3HT7NjnvC9oByotdqdd4VNv02nWerr/eFr
         BAVw==
X-Gm-Message-State: AAQBX9c51OKzW2ri7G5uhZatwQNnQz+W+debabi88BKiluQ9vomw5q74
	vi6Cn938+g43eu3C5zhxyiSCltOa6cBc3Q==
X-Google-Smtp-Source: AKy350bD9vkjTCoe3Me0GqM4NOKEnVHhSJLlNYhCveEZhDvtTq/ZROfRwuSK090OuHnA/fkTX4VH1xRZaIdWuQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:4d50:0:b0:513:290b:7516 with SMTP id
 n16-20020a634d50000000b00513290b7516mr4939122pgl.3.1682529826235; Wed, 26 Apr
 2023 10:23:46 -0700 (PDT)
Date: Wed, 26 Apr 2023 17:23:25 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-8-ricarkol@google.com>
Subject: [PATCH v8 07/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Refactor kvm_arch_commit_memory_region() as a preparation for a future
commit to look cleaner and more understandable. Also, it looks more
like its x86 counterpart (in kvm_mmu_slot_apply_flags()).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7e1cb38d0fc97..92f8872550f26 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1765,20 +1765,32 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
-		 * If we're with initial-all-set, we don't need to write
-		 * protect any pages because they're all reported as dirty.
-		 * Huge pages and normal pages will be write protect gradually.
+		 * Pages are write-protected on either of these two
+		 * cases:
+		 *
+		 * 1. with initial-all-set: gradually with CLEAR ioctls,
 		 */
-		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, new->id);
-		}
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
+		/*
+		 * or
+		 * 2. without initial-all-set: all in one shot when
+		 *    enabling dirty logging.
+		 */
+		kvm_mmu_wp_memory_region(kvm, new->id);
 	}
 }
 
-- 
2.40.1.495.gc816e09b53d-goog

