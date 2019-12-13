Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C5FC43603
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 09:42:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAFC52253D
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 09:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfWG/v+K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAFC52253D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 014E44A528;
	Fri, 13 Dec 2019 04:42:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R6VcRpxNs2zU; Fri, 13 Dec 2019 04:42:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D94724A534;
	Fri, 13 Dec 2019 04:42:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6504E4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 04:42:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gYBTNiGRSpFd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 04:42:50 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82B0E4A534
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 04:42:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576230170;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=uigEN0nLQI71ck507PDuSZrIZl/Tr9AMoJ7h/plhVG4=;
 b=PfWG/v+KtAMOhXf7jKfl0chfPn5NjW1ZqWf5zdBDBKdjXYCx5Ci0IhZIeWqZS7eH0oZ16v
 5JIgddlnmW8bfAaPkmAdT6sawkJ+JcGrGqFhO+b4HqITz9a7p81HR0MYQy3s6NA/XbXw19
 cgQ46TNjjYOthuMgEWK9wNyG2wlSMDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-SD6U9BGIPm6_9_RZObwPHA-1; Fri, 13 Dec 2019 04:42:48 -0500
X-MC-Unique: SD6U9BGIPm6_9_RZObwPHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 876E4107ACC7;
 Fri, 13 Dec 2019 09:42:47 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B751A5D9C9;
 Fri, 13 Dec 2019 09:42:43 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm/arm64: vgic-its: Fix restoration of unmapped
 collections
Date: Fri, 13 Dec 2019 10:42:37 +0100
Message-Id: <20191213094237.19627-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Saving/restoring an unmapped collection is a valid scenario. For
example this happens if a MAPTI command was sent, featuring an
unmapped collection. At the moment the CTE fails to be restored.
Only compare against the number of online vcpus if the rdist
base is set.

Cc: stable@vger.kernel.org # v4.11+
Fixes: ea1ad53e1e31a ("KVM: arm64: vgic-its: Collection table save/restore")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 98c7360d9fb7..17920d1b350a 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2475,7 +2475,8 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
 	coll_id = val & KVM_ITS_CTE_ICID_MASK;
 
-	if (target_addr >= atomic_read(&kvm->online_vcpus))
+	if (target_addr != COLLECTION_NOT_MAPPED &&
+	    target_addr >= atomic_read(&kvm->online_vcpus))
 		return -EINVAL;
 
 	collection = find_collection(its, coll_id);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
