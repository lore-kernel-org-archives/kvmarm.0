Return-Path: <SRS0=2miQ=FQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0631EC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 12 Dec 2020 18:50:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F464207B0
	for <kvmarm@archiver.kernel.org>; Sat, 12 Dec 2020 18:50:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F464207B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1984B460;
	Sat, 12 Dec 2020 13:50:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i-xNv71h2sE2; Sat, 12 Dec 2020 13:50:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF1C4B4CA;
	Sat, 12 Dec 2020 13:50:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A654B42E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Dec 2020 13:50:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MLFvfWTJeekJ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Dec 2020 13:50:44 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 666E44B4CA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Dec 2020 13:50:44 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607799044;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dRab5lNNMKQ4h1Cgpx6Hakf/XLGnhqOfT0II2ep+iVg=;
 b=TiHlBoNucierQ7BE09R2VUTFhqb03Z4wqfmGQx0nRGYjkqsgFpEQJAktpSM8AqeTokwnwz
 xRoUVeYPzEEhngC6mDYlZkebEMa6EiLFtguKx/af0xM6KeYk2HR7Uk5e3XONotHYaFQRHx
 fGlXnfelaZzAqx/x83tbILOheU72Z/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-t6d4hLZmPU6fcwpA_jTt0Q-1; Sat, 12 Dec 2020 13:50:40 -0500
X-MC-Unique: t6d4hLZmPU6fcwpA_jTt0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2936107ACF5;
 Sat, 12 Dec 2020 18:50:38 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-41.ams2.redhat.com [10.36.115.41])
 by smtp.corp.redhat.com (Postfix) with ESMTP id EA21F1F069;
 Sat, 12 Dec 2020 18:50:35 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Subject: [PATCH 4/9] KVM: arm/arm64: vgic: Reset base address on
 kvm_vgic_dist_destroy()
Date: Sat, 12 Dec 2020 19:50:05 +0100
Message-Id: <20201212185010.26579-5-eric.auger@redhat.com>
In-Reply-To: <20201212185010.26579-1-eric.auger@redhat.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: pbonzini@redhat.com, shuah@kernel.org
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

On vgic_dist_destroy(), the addresses are not reset. However for
kvm selftest purpose this would allow to continue the test execution
even after a failure when running KVM_RUN. So let's reset the
base addresses.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 32e32d67a127..6147bed56b1b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -335,14 +335,16 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	kfree(dist->spis);
 	dist->spis = NULL;
 	dist->nr_spis = 0;
+	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
 			list_del(&rdreg->list);
 			kfree(rdreg);
 		}
 		INIT_LIST_HEAD(&dist->rd_regions);
-	}
+	} else
+		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
 
 	if (vgic_has_its(kvm))
 		vgic_lpi_translation_cache_destroy(kvm);
@@ -362,6 +364,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_flush_pending_lpis(vcpu);
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
 /* To be called with kvm->lock held */
-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
