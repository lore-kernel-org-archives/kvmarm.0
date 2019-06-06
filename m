Return-Path: <SRS0=kd74=UF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C02C04AB5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jun 2019 16:55:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AC1F20872
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jun 2019 16:55:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AC1F20872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67C74A4DF;
	Thu,  6 Jun 2019 12:55:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zvKyTmAgACEd; Thu,  6 Jun 2019 12:55:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F32054A4EC;
	Thu,  6 Jun 2019 12:55:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD0274A4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jun 2019 12:55:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 43QHTRtXl2Um for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jun 2019 12:55:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB8964A4D5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jun 2019 12:55:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48DFC15A2;
 Thu,  6 Jun 2019 09:55:07 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CAB03F690;
 Thu,  6 Jun 2019 09:55:05 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 1/8] KVM: arm/arm64: vgic: Add LPI translation cache definition
Date: Thu,  6 Jun 2019 17:54:48 +0100
Message-Id: <20190606165455.162478-2-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606165455.162478-1-marc.zyngier@arm.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>
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

Add the basic data structure that expresses an MSI to LPI
translation as well as the allocation/release hooks.

THe size of the cache is arbitrarily defined as 4*nr_vcpus.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h        | 10 ++++++++++
 virt/kvm/arm/vgic/vgic-init.c | 34 ++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-its.c  |  2 ++
 virt/kvm/arm/vgic/vgic.h      |  3 +++
 4 files changed, 49 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c36c86f1ec9a..5a0d6b07c5ef 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -173,6 +173,14 @@ struct vgic_io_device {
 	struct kvm_io_device dev;
 };
 
+struct vgic_translation_cache_entry {
+	struct list_head	entry;
+	phys_addr_t		db;
+	u32			devid;
+	u32			eventid;
+	struct vgic_irq		*irq;
+};
+
 struct vgic_its {
 	/* The base address of the ITS control register frame */
 	gpa_t			vgic_its_base;
@@ -260,6 +268,8 @@ struct vgic_dist {
 	struct list_head	lpi_list_head;
 	int			lpi_list_count;
 
+	struct list_head	lpi_translation_cache;
+
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
 
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 3bdb31eaed64..25ae25694a28 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -64,6 +64,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
 	INIT_LIST_HEAD(&dist->lpi_list_head);
+	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
 }
 
@@ -260,6 +261,27 @@ static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
 		vgic_v3_enable(vcpu);
 }
 
+void vgic_lpi_translation_cache_init(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int i;
+
+	if (!list_empty(&dist->lpi_translation_cache))
+		return;
+
+	for (i = 0; i < LPI_CACHE_SIZE(kvm); i++) {
+		struct vgic_translation_cache_entry *cte;
+
+		/* An allocation failure is not fatal */
+		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
+		if (WARN_ON(!cte))
+			break;
+
+		INIT_LIST_HEAD(&cte->entry);
+		list_add(&cte->entry, &dist->lpi_translation_cache);
+	}
+}
+
 /*
  * vgic_init: allocates and initializes dist and vcpu data structures
  * depending on two dimensioning parameters:
@@ -305,6 +327,7 @@ int vgic_init(struct kvm *kvm)
 	}
 
 	if (vgic_has_its(kvm)) {
+		vgic_lpi_translation_cache_init(kvm);
 		ret = vgic_v4_init(kvm);
 		if (ret)
 			goto out;
@@ -346,6 +369,17 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		INIT_LIST_HEAD(&dist->rd_regions);
 	}
 
+	if (vgic_has_its(kvm)) {
+		struct vgic_translation_cache_entry *cte, *tmp;
+
+		list_for_each_entry_safe(cte, tmp,
+					 &dist->lpi_translation_cache, entry) {
+			list_del(&cte->entry);
+			kfree(cte);
+		}
+		INIT_LIST_HEAD(&dist->lpi_translation_cache);
+	}
+
 	if (vgic_supports_direct_msis(kvm))
 		vgic_v4_teardown(kvm);
 }
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 44ceaccb18cf..5758504fd934 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1696,6 +1696,8 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 			kfree(its);
 			return ret;
 		}
+
+		vgic_lpi_translation_cache_init(dev->kvm);
 	}
 
 	mutex_init(&its->its_lock);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index abeeffabc456..a58e1b263dca 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -316,6 +316,9 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+void vgic_lpi_translation_cache_init(struct kvm *kvm);
+
+#define LPI_CACHE_SIZE(kvm)	(atomic_read(&(kvm)->online_vcpus) * 4)
 
 bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
