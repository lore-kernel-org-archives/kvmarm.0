Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6263CBE7A
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 08:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782202503; cv=none; b=eLk18CK0qPXV9IBP04t3QeMPG4lcntDx4A85AkWUCiq2gTO1TKE/1Jq4PKuPAPx7IhFjZZ5o/qEZjvmttfWRUflKcGzFGVUISa6CeX9+kOFiGS0EgyFa3+I4SKWta580fB69nUAdZaTV73fbl55LAyevTmQ9YDG5gn4kWIrAllA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782202503; c=relaxed/simple;
	bh=lv00yt5h4iA7zAdiud+2wNlHMeBNwTBGw53WrIYz4fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL69PUfOlzwkCrHwzgMxg5YImVpBPOWL9LolKIurK7S7DgQqeTYrrF6kPfeQPstWXCxLeQdIJkFT1clSdQWvimG9hia3hHBEjed358z15+FIz/UwQ/TxsncWs/gRcn4h9oEoQrzt3Lmcyazh5ItMOqDiWKzTOQT9n4eCtWW0Rww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9da3d15a6edb11f1aa26b74ffac11d73-20260623
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_UNTRUSTED
	SA_UNFAMILIAR, SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-UNFAMILIAR: 1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e244f643-0d94-4661-9dbe-d3f87441a1ef,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:e244f643-0d94-4661-9dbe-d3f87441a1ef,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:5549c0c9c56ac87306c3598eda0d2bad,BulkI
	D:260623161455U457ALV5,BulkQuantity:0,Recheck:0,SF:16|19|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_USA,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9da3d15a6edb11f1aa26b74ffac11d73-20260623
X-User: leixiang@kylinos.cn
Received: from ninol.. [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <leixiang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 276535867; Tue, 23 Jun 2026 16:14:54 +0800
From: leixiang <leixiang@kylinos.cn>
To: maz@kernel.org
Cc: oupton@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	leixiang <leixiang@kylinos.cn>
Subject: [RFC PATCH] KVM: arm64: Set irqfd->producer to enable vLPI routing updates
Date: Tue, 23 Jun 2026 16:14:33 +0800
Message-ID: <20260623081433.21250-1-leixiang@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260622075103.35164-1-leixiang@kylinos.cn>
References: <20260622075103.35164-1-leixiang@kylinos.cn>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ARM64's kvm_arch_irq_bypass_add_producer() never sets irqfd->producer,
so kvm_irq_routing_update() never calls the ARM64 routing hook.  That
hook unmaps the vLPI and falls back to software injection when an
irqfd's MSI routing changes; with it dead, the vLPI stays bound to the
old translation.

Set irqfd->producer once kvm_vgic_v4_set_forwarding() succeeds and
clear it in del_producer(), under irqfds.lock; the only reader,
kvm_irq_routing_update(), takes that lock.  set_forwarding() may sleep,
so it runs outside the lock and the pointer is published only on
success, needing no error cleanup.

Sent as RFC: the unmap-on-reroute path has been dormant.

Fixes: 2412405b3141 ("KVM: arm/arm64: register irq bypass consumer on ARM/ARM64")
Signed-off-by: leixiang <leixiang@kylinos.cn>
---
A review of the x86/powerpc producer-nullify patch pointed out that
ARM64 never sets irqfd->producer, so kvm_arch_update_irqfd_routing()
is dead.  This RFC fills that gap; set_forwarding() may sleep and so
can't run under irqfds.lock like the x86 path, hence the locking is
what I'd most like reviewed.

 arch/arm64/kvm/arm.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..6f1e4f526719 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2935,6 +2935,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 	struct kvm_kernel_irq_routing_entry *irq_entry = &irqfd->irq_entry;
+	int ret;

 	/*
 	 * The only thing we have a chance of directly-injecting is LPIs. Maybe
@@ -2943,8 +2944,16 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	if (irq_entry->type != KVM_IRQ_ROUTING_MSI)
 		return 0;

-	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
-					  &irqfd->irq_entry);
+	ret = kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
+					 &irqfd->irq_entry);
+	if (ret)
+		return ret;
+
+	spin_lock_irq(&irqfd->kvm->irqfds.lock);
+	irqfd->producer = prod;
+	spin_unlock_irq(&irqfd->kvm->irqfds.lock);
+
+	return 0;
 }

 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
@@ -2957,6 +2966,10 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	if (irq_entry->type != KVM_IRQ_ROUTING_MSI)
 		return;

+	spin_lock_irq(&irqfd->kvm->irqfds.lock);
+	irqfd->producer = NULL;
+	spin_unlock_irq(&irqfd->kvm->irqfds.lock);
+
 	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
 }

--
2.45.0
