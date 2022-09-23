Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BC9ECAAD8
	for <kvmarm@archiver.kernel.org>; Fri, 23 Sep 2022 06:55:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C317410F1;
	Fri, 23 Sep 2022 02:55:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wCa4cn8HYDVf; Fri, 23 Sep 2022 02:55:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1262343399;
	Fri, 23 Sep 2022 02:55:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32418410F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 02:55:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 06ID53c9BN84 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2022 02:55:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3667B40D01
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 02:55:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663916147;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=TyI3/pitfwr7G0vT4ywoa+PCxkCwg5DwusKh6v7dH8I=;
 b=Sh1uLe2b1dMfQx1u23MqR8lAMyqH31zQkZSGkxIyxXqYkg0s5M0yHhMIGrlHkPA4aDBMyo
 FXtr9X9iq7DvSr23pCsfWkr7oUOiGZQSaYmekhhktKoTMPp5i6Pvu5lB0iyD26rsJYo3a4
 KPF1SZv2Lrtzv3IuJrGk3aGbtTaFFb4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-ZcEpPXmLM_6_z8LyNu0njg-1; Fri, 23 Sep 2022 02:55:44 -0400
X-MC-Unique: ZcEpPXmLM_6_z8LyNu0njg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9B1038041C5;
 Fri, 23 Sep 2022 06:55:43 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 254AAC15BA5;
 Fri, 23 Sep 2022 06:55:39 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: vgic: Remove duplicate check in
 update_affinity_collection()
Date: Fri, 23 Sep 2022 14:54:47 +0800
Message-Id: <20220923065447.323445-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Cc: yuzhe@nfschina.com, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, will@kernel.org
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

The ITS collection is guranteed to be !NULL when update_affinity_collection()
is called. So we needn't check ITE's collection with NULL because the
check has been included to the later one.

Remove the duplicate check in update_affinity_collection().

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 9d3299a70242..24d7778d1ce6 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -406,7 +406,7 @@ static void update_affinity_collection(struct kvm *kvm, struct vgic_its *its,
 	struct its_ite *ite;
 
 	for_each_lpi_its(device, ite, its) {
-		if (!ite->collection || coll != ite->collection)
+		if (ite->collection != coll)
 			continue;
 
 		update_affinity_ite(kvm, ite);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
