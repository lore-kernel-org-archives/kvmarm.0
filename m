Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932CF28314C
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136532; cv=none; b=fZ0PwENjGUkZQNtLG1nj5LhCsVaE/7HESzZy5bGrfpDrTiq2M+fUz37Te9+u72iGu//5Zlk0nyeigg1lqUCOBv/A/mLLGNsAeZlVwr0NU69nfobSLIc9vX0hEEK9gYseJQoZUVSbY1WQC/CohWgK+QEBVYXCQBt/CXwm7Twi3xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136532; c=relaxed/simple;
	bh=SLM+BG/28Amq1LU3rLqRYuXAP4KtJHmRq2Ifj7vw69I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcfSx50wTd+8tWnqY6p6nJJZHqSTXm9L7ckDtqKm1EVeXiVKHs6bRnPuyQCPwhGq9KkfAFshl4oDxgjx0f3HQLkI1IFHpBtXEXPsQ90D6fctthzSoaM+ljeEZ6kdpbFBo80NzMIfvL6L8fXXbD+Z9G00FA+YD/zUo0aXpe7wARc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B4AD19F6;
	Fri, 14 Nov 2025 08:08:42 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E06F53F5A1;
	Fri, 14 Nov 2025 08:08:47 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 30/35] KVM: Propagate MMU event to the MMU notifier handlers
Date: Fri, 14 Nov 2025 16:07:11 +0000
Message-ID: <20251114160717.163230-31-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arm64 will want to perform a different action for MMU notifiers based on
the reason for the notifier. Propagate the reason for the MMU notifier down
to the arch code. Where there is no primary MMU event associated with a
notifier callback, add our own.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/linux/kvm_host.h | 17 +++++++++++++++++
 virt/kvm/kvm_main.c      |  8 ++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5bd76cf394fa..772e75d13af1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -263,12 +263,29 @@ enum kvm_gfn_range_filter {
 	KVM_FILTER_PRIVATE		= BIT(1),
 };
 
+enum kvm_mmu_notifier_event {
+	KVM_MMU_NOTIFY_UNMAP            = MMU_NOTIFY_UNMAP,
+	KVM_MMU_NOTIFY_CLEAR            = MMU_NOTIFY_CLEAR,
+	KVM_MMU_NOTIFY_PROTECTION_VMA   = MMU_NOTIFY_PROTECTION_VMA,
+	KVM_MMU_NOTIFY_PROTECTION_PAGE  = MMU_NOTIFY_PROTECTION_PAGE,
+	KVM_MMU_NOTIFY_SOFT_DIRTY       = MMU_NOTIFY_SOFT_DIRTY,
+	KVM_MMU_NOTIFY_RELEASE          = MMU_NOTIFY_RELEASE,
+	KVM_MMU_NOTIFY_MIGRATE          = MMU_NOTIFY_MIGRATE,
+	KVM_MMU_NOTIFY_EXCLUSIVE        = MMU_NOTIFY_EXCLUSIVE,
+	KVM_MMU_NOTIFY_AGE		= 32,
+	KVM_MMU_NOTIFY_MEMORY_ATTRIBUTES,
+	KVM_MMU_NOTIFY_ARCH1,
+	KVM_MMU_NOTIFY_ARCH2,
+	KVM_MMU_NOTIFY_ARCH3,
+};
+
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
 	enum kvm_gfn_range_filter attr_filter;
+	enum kvm_mmu_notifier_event event;
 	bool may_block;
 	bool lockless;
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b7a0ae2a7b20..2dce50bcb181 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -521,6 +521,7 @@ struct kvm_mmu_notifier_range {
 	union kvm_mmu_notifier_arg arg;
 	gfn_handler_t handler;
 	on_lock_fn_t on_lock;
+	enum kvm_mmu_notifier_event event;
 	bool flush_on_ret;
 	bool may_block;
 	bool lockless;
@@ -618,6 +619,7 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.event = range->event;
 			gfn_range.lockless = range->lockless;
 
 			if (!r.found_memslot) {
@@ -660,6 +662,7 @@ static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= flush_on_ret,
+		.event		= KVM_MMU_NOTIFY_AGE,
 		.may_block	= false,
 		.lockless	= IS_ENABLED(CONFIG_KVM_MMU_LOCKLESS_AGING),
 	};
@@ -732,6 +735,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.end		= range->end,
 		.handler	= kvm_mmu_unmap_gfn_range,
 		.on_lock	= kvm_mmu_invalidate_begin,
+		.event		= (enum kvm_mmu_notifier_event)range->event,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
@@ -808,6 +812,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		.end		= range->end,
 		.handler	= (void *)kvm_null_fn,
 		.on_lock	= kvm_mmu_invalidate_end,
+		.event		= (enum kvm_mmu_notifier_event)range->event,
 		.flush_on_ret	= false,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
@@ -2482,6 +2487,7 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 
 	gfn_range.arg = range->arg;
 	gfn_range.may_block = range->may_block;
+	gfn_range.event = range->event;
 
 	/*
 	 * If/when KVM supports more attributes beyond private .vs shared, this
@@ -2550,6 +2556,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		.arg.attributes = attributes,
 		.handler = kvm_pre_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_begin,
+		.event = KVM_MMU_NOTIFY_MEMORY_ATTRIBUTES,
 		.flush_on_ret = true,
 		.may_block = true,
 	};
@@ -2559,6 +2566,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		.arg.attributes = attributes,
 		.handler = kvm_arch_post_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_end,
+		.event = KVM_MMU_NOTIFY_MEMORY_ATTRIBUTES,
 		.may_block = true,
 	};
 	unsigned long i;
-- 
2.51.2

