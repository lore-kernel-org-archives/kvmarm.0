Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA8636E
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:06 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id t12-20020aa7938c000000b005ac41980708so6468341pfe.7
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j/rvnSUPkFYod+qtoGkjVnQK76DLzlbuECq38DHxQ5A=;
        b=fb1Gvc769uSZciENcHpUJql9DAUpW3BmIfMoSuuGM7TRqKwudVfqotQvwUJCQtiWVG
         siwJ97O8ckmab6z6OQKYBQ2NX42GiV28Qpes8eQW3ie3+eXHi8/oOXaaGFx3qeaGS/ar
         oWVYjXOHTnUR6j0g1a/lZ6A1DRaO4waasQAX/lyuYJY577MJSyCJwEr+BoRALiy8gbGb
         5pSHP1OdbqLIhFi1DVa6g8w0An+r9iZhBmG7PCXJT3fMaYaU0k1Rmrskxjq3Zsc17pF5
         lrzYOPJUJWq9irRijnygLpDD9GA+WMS+WZpA2ctrf6C1m9pWxMeted/cMSBIXvAX+jd6
         3a2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/rvnSUPkFYod+qtoGkjVnQK76DLzlbuECq38DHxQ5A=;
        b=1hbsdYX4u9hLYrdvMKG8h03JJZYg30nLozh+a6y4sMpyaJ/eLnddAfe3Z/FBw7SfGF
         7lQf1eJ8XCzuzsUa8tke9tp+nG2+TfJDAT7LiXmHnRw1RBHBLhQgHzTigFY1VxV+oS39
         i8iSGIrn7NErgt5zcJaNRuKIktfZu3SKlpAdQ8PsoYqobKY0HrmkbzG40gvvgSGLTuUI
         YO5V3fTXicsVlB9ld+LYvY+eL7bPyBjxRfe6Q+UBP0HXvf3aGiufI1mc1C2TwCNZzufl
         /UC/d+gkwEsIKE8T0Uel+CnMLPiusIJp+ukBuaO/nQJ8mf9Nrq6aG9f/rww3lfu+R11p
         9Udw==
X-Gm-Message-State: AO0yUKWpPK0N8F08gBWBtASLiXRAUyrYxQ9I1avuRhcL5viBK8jBEwRJ
	gdkGBUyStX9a+T40XzoL6t/7YdaL8gAgOQ==
X-Google-Smtp-Source: AK7set+xmVQmajo5oH9Jd2T7h/jPslono/c3fXukdsoDK6T1PUjeCXYT1WC9c3DWD2cvqTn1Iu5v8aQY1k1FYw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:903:4285:b0:19c:da35:6699 with SMTP
 id ju5-20020a170903428500b0019cda356699mr5125398plb.7.1678160766547; Mon, 06
 Mar 2023 19:46:06 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:48 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-6-ricarkol@google.com>
Subject: [PATCH v6 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
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

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index efdaab3f154d..37d7d2aa472a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.40.0.rc0.216.gc4246ad0f0-goog

