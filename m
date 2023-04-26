Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AED3538F
	for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 17:23:54 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-b99f3aee8e0so164908276.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 10:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529833; x=1685121833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eA3wfGEyelK4T3XkIQJrJEaWip/EMGSfHILspNym0zM=;
        b=M8cRku5Zf+KEyeiSh+7Z//LvxeT26I9o6CgjbFwLf5MDJVRKf1hpuER9/jCGS02raJ
         ULzVAVM94N9FAxfBK5oE4/0VuYugt5aZ496v3ObI7NvZSnoieoFVvn0MUPsmBQtPNJDE
         FFBbbKvOpV4odfojWlI3l43pyxeBmIO+jjH58vaHZBb8zZDtmYLBNiNJaFJksbJM3s4P
         3c7wI4OLW8B5WbsTHxQLg17zH+yMui28Ewx37jmCIMSzPFGYbaK/A6TcDG3Gk8BejpFk
         QZn2XcA++u05u3apfSVAROlYCpF8rKdklRnieD7qZgsUQ6uqyo2/QTQfTNiIhQU/qXMt
         99QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529833; x=1685121833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eA3wfGEyelK4T3XkIQJrJEaWip/EMGSfHILspNym0zM=;
        b=dShhGcO/ffw3B0m1gP7GFLHNoBuX2qaBJDYVcxt/BxFUZ+Ni1dmTwrJ5ulorKxO0Cz
         LFW1zJyhMzZKFVQzU8rj12slLGLGfMWzmxH9MeNBbC4jVfq1WxRpe/U1mGyZSlOXQkgg
         0XDqNafF0oboGnsKc/ncCMcta8rFK2KHZphWoFjoNvZ+XryQK53tBE3/yXuIZbQ+pV32
         7APIyqBK8UwFiuIhjrTgY5jvEou+3DgaS9z4z7EYU2vMW+CLNNIqHCyxhpsETO5vHfwb
         H6iuuacJ6Jq0962KR/bPf+EG4ukQAZALtFcT/BKMm0WOIZnF/jZwCsJq+Or9HuuxLII5
         SOAQ==
X-Gm-Message-State: AC+VfDzgIAVDGDfW3g5+rL3mH5YBJKrx4fqDAf08hFTP6A6PNsRxDopC
	KmvuQ4vPYnkRSl3WtTM8hceh2kq8Z1jiaQ==
X-Google-Smtp-Source: ACHHUZ7IDAeUDhr/0GGBPV+4GA8AMVpEewL25NCDu+zbaCcBOeXbfDCfAxRRuyfrJQ8J87Zk+zqkI931RGTwaA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:690c:986:b0:54c:15ad:11e4 with SMTP
 id ce6-20020a05690c098600b0054c15ad11e4mr1978890ywb.0.1682529833173; Wed, 26
 Apr 2023 10:23:53 -0700 (PDT)
Date: Wed, 26 Apr 2023 17:23:29 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-12-ricarkol@google.com>
Subject: [PATCH v8 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
which has the benefit of splitting the cost of splitting a memslot
across multiple ioctls.

Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.
And do not split when enabling dirty logging if
KVM_DIRTY_LOG_INITIALLY_SET is set.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 835e4b8f4e5c3..7a68398517c95 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1095,8 +1095,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
  * @mask:	The mask of pages at offset 'gfn_offset' in this memory
  *		slot to enable dirty logging on
  *
- * Writes protect selected pages to enable dirty logging for them. Caller must
- * acquire kvm->mmu_lock.
+ * Writes protect selected pages to enable dirty logging, and then
+ * splits them to PAGE_SIZE. Caller must acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
@@ -1109,6 +1109,17 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * Eager-splitting is done when manual-protect is set.  We
+	 * also check for initially-all-set because we can avoid
+	 * eager-splitting if initially-all-set is false.
+	 * Initially-all-set equal false implies that huge-pages were
+	 * already split when enabling dirty logging: no need to do it
+	 * again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
-- 
2.40.1.495.gc816e09b53d-goog

