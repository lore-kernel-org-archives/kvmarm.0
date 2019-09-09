Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1BEC4740C
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:49:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D51221920
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D51221920
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45DE74A554;
	Mon,  9 Sep 2019 09:49:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KTq0TbPbpcud; Mon,  9 Sep 2019 09:49:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17E6A4A5CE;
	Mon,  9 Sep 2019 09:49:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BA214A523
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:49:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zb+5x4wAmogx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 09:49:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CD044A554
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:49:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04A201650;
 Mon,  9 Sep 2019 06:49:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE2F13F59C;
 Mon,  9 Sep 2019 06:48:58 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 04/17] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI
 translation cache on specific commands
Date: Mon,  9 Sep 2019 14:47:54 +0100
Message-Id: <20190909134807.27978-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The LPI translation cache needs to be discarded when an ITS command
may affect the translation of an LPI (DISCARD, MAPC and MAPD with V=0)
or the routing of an LPI to a redistributor with disabled LPIs (MOVI,
MOVALL).

We decide to perform a full invalidation of the cache, irrespective
of the LPI that is affected. Commands are supposed to be rare enough
that it doesn't matter.

Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index cc6b5e49a312..09a179820816 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -722,6 +722,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		 * don't bother here since we clear the ITTE anyway and the
 		 * pending state is a property of the ITTE struct.
 		 */
+		vgic_its_invalidate_cache(kvm);
+
 		its_free_ite(kvm, ite);
 		return 0;
 	}
@@ -757,6 +759,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->collection = collection;
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
+	vgic_its_invalidate_cache(kvm);
+
 	return update_affinity(ite->irq, vcpu);
 }
 
@@ -985,6 +989,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
 	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
 		its_free_ite(kvm, ite);
 
+	vgic_its_invalidate_cache(kvm);
+
 	list_del(&device->dev_list);
 	kfree(device);
 }
@@ -1090,6 +1096,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 
 	if (!valid) {
 		vgic_its_free_collection(its, coll_id);
+		vgic_its_invalidate_cache(kvm);
 	} else {
 		collection = find_collection(its, coll_id);
 
@@ -1238,6 +1245,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 		vgic_put_irq(kvm, irq);
 	}
 
+	vgic_its_invalidate_cache(kvm);
+
 	kfree(intids);
 	return 0;
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
