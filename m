Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F13FA4C
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 21:17:02 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id i15-20020aa78d8f000000b005edc307b103so6721902pfr.17
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 13:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AyQwFFR+sM3AjGhPSeNMTQXkHflwmeDdXwXEbmr5h+E=;
        b=pYMa2OtEY+vmyWWa9yw3R2ExSa6IY1i6E6t+6wzheNsXmU5EPR01Vot7JIJHT/qwak
         SkoNr2mRknbC84EJc5DKGfsdFapxqQpcB5SOG+6efwyftIotDOGzPLW1LXWiBwKHTcjg
         kovTTzH7nZIumcI/elhor2wVw/k0ndk1z55wrbw+WtxH5Lf9iTJ7Y07jAX/4Gb8WLclD
         MTWins+bfPXhOi0PfQUNOMXM1brjemy27YbFup/ZcKSlbrRpQUnQZXKyaTQlYGb8dA/v
         ue8HOohm7e0c8whS0Ge4nM62Sl8VIQ2egCyJdvQOWhZZYIO0DQb6ApOU5Wq3UTTCEXVF
         y5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AyQwFFR+sM3AjGhPSeNMTQXkHflwmeDdXwXEbmr5h+E=;
        b=q6K7zUfa1KPZQcE08XnC4odD6UZRzZrdTqaMHrx3QJ+U7yv2CyIwsx9PhjJFnp2qt5
         RREh7v1O89CfGAcPMkbifr9EgTxP9K8s5JVNYZkt3CDgHOcM8bMAPvRSW98gHtMRyNfs
         iy9A9vvujWgx60SbRH8Mi+p0EPbmKZliuj2gdbp6Als/3UD+xgaMnZVZF3mfeEWQDe3b
         6B7cpZCLjrarbV+6fRThpkaecbqCTlqIfR0Y1uGUNhaA2reOqVNpFfKZxt5o3ir03SrF
         NfIUSLkzgojUy3lncBqNUrgELzUQeCqC/TBeYED0xZPLjVHvuOGnN6vD00OPPrS11cPU
         3yuw==
X-Gm-Message-State: AO0yUKWTMv2D+pOUK+lJlQO6b5TcjZtk4JatTSQd+QnuRM8JbtK4rLkS
	HV7ndhkeAVhO4jUoqvPGEAROygPj94SluQ==
X-Google-Smtp-Source: AK7set9TXehDrschYbjcA/9KfvI0u1IPieBacO26x8ZbIZC1/zC1kpDzsxUGBOvvlhI5NDOtZwBae8PR/0EA+A==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:2d8:b0:5a8:9872:2b9b with SMTP
 id b24-20020a056a0002d800b005a898722b9bmr3125821pft.1.1677704980039; Wed, 01
 Mar 2023 13:09:40 -0800 (PST)
Date: Wed,  1 Mar 2023 21:09:21 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-6-ricarkol@google.com>
Subject: [PATCH v5 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
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
2.39.2.722.g9855ee24e9-goog

