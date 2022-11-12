Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D5DA23
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:30 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-3691846091fso62692857b3.9
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=M0dbLqDpv8nl7yELg00/KAns+RtImV/PwKm8GJILggvSPgdfQcuCufOtHpP4pQMfY2
         UAxnqkXzrmuJZg+9xh6m3RRU9vi6kBZgucRU38khlm54fq2sFyBYjs8B6Ps20bHVYvmj
         yidNav1VwTKbuw+OUDdlNYKtm39kmtPA9aMZcFJ98hTgZl8Vc67hsYbVoQi6ZSRDogbZ
         +3OaBXokBKlubhJX3u8n+QwaXLftz+TvzSiotfyjGGhtkc460WZWuub8Rtqb2OdGfkn4
         Fb8+9HNZ9p0JPyckQ2cI+Ryug/8OzcgQs0jpDym9X1j4X6DRREmESB0kBPD/+MgLwoUw
         KQKA==
X-Gm-Message-State: ANoB5pnodbRRPOEVapUouCnZDLLoN4vWow/4sNZPnf69UPpsGuV+pRxe
	eyAdshgZ3cO6F4/lKXM29gtNXAM6XOS/kQ==
X-Google-Smtp-Source: AA0mqf5J4lgPyBB5y+f3Nq56r3EX+3f3XVFGVpba92grsCihrLzXFlwxYutDNVRoff367ywYqhaBZFCdb+AbvQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:cc86:0:b0:368:738a:b13b with SMTP id
 o128-20020a0dcc86000000b00368738ab13bmr5277155ywd.97.1668241049641; Sat, 12
 Nov 2022 00:17:29 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:09 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081709.zTO_NigxtCOPCFY0WVmWWjcWqzcmNKTDzyVcKkikfuo@z>

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

