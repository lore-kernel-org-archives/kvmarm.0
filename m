Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7953B628
	for <kvmarm@lists.linux.dev>; Fri, 13 Jan 2023 03:50:14 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-4de8261cc86so4130017b3.13
        for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p+sSgvrkkZpJDxwlY/ZTApHr3MYP7u1zHpbjO+TJRms=;
        b=qmCt49Z9xLx8+zo81eq6M0PqPAvthNQXAFrnCnGUMNTHju3lF74tpwAsMU8O/lanM0
         CO22Eyn2zHvq6NOnuKQI7Wm4oWbuh2mcszoEuTt//Ca9YFcnHK8qxKtMuCwqP6Ra7Yx0
         U37LRPpdtFh6Fu/vUUihiLfApJ4FJ5fjBtlnE58L+DkuLReB/Ws4nL08MVYJjOCPYhhW
         rQMiVdPONO8BLonW0RmdttxPBBkstP2V6MIQ2xs1IO6LGjMyKpWiWYVzjnhSBPGl0Erg
         C2ufCE2b4X/3aFuxFYjIyTbF/SX6KA7Uqy0lyiG02ZjVIosGSCaw0YFKjSHoc60pJ4uD
         VCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p+sSgvrkkZpJDxwlY/ZTApHr3MYP7u1zHpbjO+TJRms=;
        b=3CBltxO0JSidTqEtVIVgzsaYLxtcBgKbuTWVQ8B63a4VEpfm/yhAoKGuPg4l28v9w3
         lYlVcC2ri0EbPPHgVQIhOo0xgSfBQf6o8bxYSPrd7z9OnfuCkJNG7NqDuLwkDHT/mOME
         +6NqcGHTSgoldXjO3cEPqTe1lZ08DmSJqMON990/84Dc6eDADABQCMGvLQcZ0qGDFTpP
         uc83C5Z2ym8ZbGM+Ze57zFbJjVg2qGUMKFC8qfxydkwden8BjnmIH1Gbj+CX3uGVmYnP
         LL9S5Vw3+y9wTrga9NQbPlTTSg18dNPG4cYhJkmZfdiZ9HL0+X8SSH3tvAaANwdKx+JY
         p24g==
X-Gm-Message-State: AFqh2krGwUfrOlv7cVLbjG7VaBZUtysQ1CFJ2CAG1C20hIE19Kaqx1Nz
	7aP5TpfeqIS3Yfq6vYW7DpggcY2R1S+k4Q==
X-Google-Smtp-Source: AMrXdXuC/KVbLSGIMwQ2ptv5Lv1P18un3U+GBECCaw+jcTKBsYHjMPMeo4iku7CoqDNfts9qfl0pquZ6AEnfyQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:d657:0:b0:47b:772:83bc with SMTP id
 y84-20020a0dd657000000b0047b077283bcmr1487026ywd.311.1673581813622; Thu, 12
 Jan 2023 19:50:13 -0800 (PST)
Date: Fri, 13 Jan 2023 03:49:58 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-8-ricarkol@google.com>
Subject: [PATCH 7/9] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the functionality of kvm_mmu_write_protect_pt_masked() into its
caller, kvm_arch_mmu_enable_log_dirty_pt_masked().  This will be used
in a subsequent commit in order to share some of the code in
kvm_arch_mmu_enable_log_dirty_pt_masked().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 41ee330edae3..009468822bca 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1045,28 +1045,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	kvm_flush_remote_tlbs(kvm);
 }
 
-/**
- * kvm_mmu_write_protect_pt_masked() - write protect dirty pages
- * @kvm:	The KVM pointer
- * @slot:	The memory slot associated with mask
- * @gfn_offset:	The gfn offset in memory slot
- * @mask:	The mask of dirty pages at offset 'gfn_offset' in this memory
- *		slot to be write protected
- *
- * Walks bits set in mask write protects the associated pte's. Caller must
- * acquire kvm_mmu_lock.
- */
-static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
-		struct kvm_memory_slot *slot,
-		gfn_t gfn_offset, unsigned long mask)
-{
-	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
-	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
-	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
-
-	stage2_wp_range(&kvm->arch.mmu, start, end);
-}
-
 /**
  * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
  *				   pages for memory slot
@@ -1091,17 +1069,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
 }
 
 /*
- * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
- * dirty pages.
+ * kvm_arch_mmu_enable_log_dirty_pt_masked() - enable dirty logging for selected pages.
+ * @kvm:	The KVM pointer
+ * @slot:	The memory slot associated with mask
+ * @gfn_offset:	The gfn offset in memory slot
+ * @mask:	The mask of pages at offset 'gfn_offset' in this memory
+ *		slot to enable dirty logging on
  *
- * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
- * enable dirty logging for them.
+ * Writes protect selected pages to enable dirty logging for them. Caller must
+ * acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		gfn_t gfn_offset, unsigned long mask)
 {
-	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
-- 
2.39.0.314.g84b9a713c41-goog

