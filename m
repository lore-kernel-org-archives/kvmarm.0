Return-Path: <SRS0=Uj0Q=JC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC99C43461
	for <kvmarm@archiver.kernel.org>; Mon,  5 Apr 2021 16:40:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F3F9613B3
	for <kvmarm@archiver.kernel.org>; Mon,  5 Apr 2021 16:40:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F3F9613B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232384BC27;
	Mon,  5 Apr 2021 12:40:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RYIs1JtEnbBp; Mon,  5 Apr 2021 12:40:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 061734BC3D;
	Mon,  5 Apr 2021 12:40:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA9F4BAD5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Apr 2021 12:40:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xeqhDmDHphw1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Apr 2021 12:40:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7658F4BAB3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Apr 2021 12:40:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617640824;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fobR56P1Wx6MurFew5By3DwSeDXha3rhr+G2cvBGNCw=;
 b=BUntQT6GSBvAODMZtYnKcTW7uIXt7171MA7Tke+UvzKEsoUcjbu3e7Ij2+nbOjFzcP2xBJ
 0jEIuol2O6fZ3FILcQpJWibX5EJ5kAMnx69Bryzi8qJn/Ee+dtBGCbppgzIw38jya6XPbj
 2ssnlewDvwFmglDihYGDjfUlKC7TBmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-XsjHxyvwPjCW7owhKZD2AA-1; Mon, 05 Apr 2021 12:40:20 -0400
X-MC-Unique: XsjHxyvwPjCW7owhKZD2AA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B638A1922964;
 Mon,  5 Apr 2021 16:40:18 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 18FC919715;
 Mon,  5 Apr 2021 16:40:15 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
 alexandru.elisei@arm.com
Subject: [PATCH v6 7/9] kvm: arm64: vgic-v3: Introduce
 vgic_v3_free_redist_region()
Date: Mon,  5 Apr 2021 18:39:39 +0200
Message-Id: <20210405163941.510258-8-eric.auger@redhat.com>
In-Reply-To: <20210405163941.510258-1-eric.auger@redhat.com>
References: <20210405163941.510258-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: shuah@kernel.org, pbonzini@redhat.com
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

To improve the readability, we introduce the new
vgic_v3_free_redist_region helper and also rename
vgic_v3_insert_redist_region into vgic_v3_alloc_redist_region

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  6 ++----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 17 +++++++++++------
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index cf6faa0aeddb..58cbda00e56d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -338,10 +338,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 
 	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
-			list_del(&rdreg->list);
-			kfree(rdreg);
-		}
+		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list)
+			vgic_v3_free_redist_region(rdreg);
 		INIT_LIST_HEAD(&dist->rd_regions);
 	} else {
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index fec0555529c0..e1ed0c5a8eaa 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -768,7 +768,7 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 }
 
 /**
- * vgic_v3_insert_redist_region - Insert a new redistributor region
+ * vgic_v3_alloc_redist_region - Allocate a new redistributor region
  *
  * Performs various checks before inserting the rdist region in the list.
  * Those tests depend on whether the size of the rdist region is known
@@ -782,8 +782,8 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
  *
  * Return 0 on success, < 0 otherwise
  */
-static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
-					gpa_t base, uint32_t count)
+static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
+				       gpa_t base, uint32_t count)
 {
 	struct vgic_dist *d = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg;
@@ -848,11 +848,17 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	return ret;
 }
 
+void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg)
+{
+	list_del(&rdreg->list);
+	kfree(rdreg);
+}
+
 int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 {
 	int ret;
 
-	ret = vgic_v3_insert_redist_region(kvm, index, addr, count);
+	ret = vgic_v3_alloc_redist_region(kvm, index, addr, count);
 	if (ret)
 		return ret;
 
@@ -865,8 +871,7 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 		struct vgic_redist_region *rdreg;
 
 		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
-		list_del(&rdreg->list);
-		kfree(rdreg);
+		vgic_v3_free_redist_region(rdreg);
 		return ret;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 64fcd7511110..bc418c2c1214 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -293,6 +293,7 @@ vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
 
 struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
 							   u32 index);
+void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg);
 
 bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
 
-- 
2.26.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
