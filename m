Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD8D7B
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 16:59:03 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-4c11ae6ab25so120017607b3.8
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 08:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8zrNUdMOQOUCJgLNSlqpWBpwPg1ysQqMfJW7ug17pk8=;
        b=OhogaDmxK2A4kV6+TTY9E1br3vwEnQWAXP4ItIL5FD1Y3YQ5dt5/DbUeN2hySyWDqS
         9fLNvLxT88V3LYBi+kPyBlwcie/evnfpfJtMNUdhmIzve8VkYv6BRKl3pks0VuN9TfLA
         5cREu96AzkOJpObRjU9/AoKblo5ztdPmcipREktbavYR3DrY7vg6fdHjQf8Hqsu8hmaK
         yvDcx+jU9yapfiu7bODzfejb2YyxXRzuG9pvwLSqreYZEKs8f4yT7IvCvX7nAOQhf3X3
         dNIJHt65wWlTiwvNzcfT0DdBZp9V8AwPjH0TzAl+hYWnc0uz46bbjHQxVH2Lnvt9pSyr
         KGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8zrNUdMOQOUCJgLNSlqpWBpwPg1ysQqMfJW7ug17pk8=;
        b=ZG5QxizFDr9H6lm6v98xDp3lTWtuz/jlvbTqdbrwQDgiR2lVCWQhpFwh2oadcWl/Da
         Ni7dyO41vDIcFHc+Kv628i8GT5aPg6mtnMoFlivtXTEx7H/s7IcNYQEkV5w2b+hY0f73
         95XR1X+Z6zDA8/kVSuCzT9paxIAtvGpgQ/3LYelEZddgXzgipHjofnqNeCuisEwpGUub
         f6be1h8K5Zgh5skhNd2ixBkgVpcD4KXa6q2iim3szar4tfTPO/uyL0RCCnA//tffqOCI
         rBxeLy9VBPX+FzMeAYHQchbUURG0hcmoGKMPw3FFcxqlhJXdcK6oO5INMH0Q03Gxotez
         HtXA==
X-Gm-Message-State: AO0yUKW8V4bVafzOuMkZLF1cnM3Z1ZmTlwPOde4cewhLHET4XrPU+UXe
	RgfvU40UDXRtJ1jay1kN9BVHCZfZRGM8xA==
X-Google-Smtp-Source: AK7set94430d3TW0rOSOGdcCMwmeKCK2QLWM9dIYTScifN3Lhaw6SVCQvu82gV70yChRGOpb9SbRNDBzgZ4dCA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:13c6:0:b0:855:fdcb:4467 with SMTP id
 189-20020a2513c6000000b00855fdcb4467mr0ybt.0.1675702742440; Mon, 06 Feb 2023
 08:59:02 -0800 (PST)
Date: Mon,  6 Feb 2023 16:58:44 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-6-ricarkol@google.com>
Subject: [PATCH v2 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
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
index 9bd3c2cfb476..d2c5e6992459 100644
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
2.39.1.519.gcb327c4b5f-goog

