Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19010C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:37:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C51423A53
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C51423A53
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BBE34B1A1;
	Thu, 14 Jan 2021 05:37:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rc4aAa9q2r7F; Thu, 14 Jan 2021 05:37:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84E614B1BC;
	Thu, 14 Jan 2021 05:37:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB79B4B19F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:37:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CiWDDq-YdYUO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 05:37:23 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 328F64B190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:37:23 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610620643;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oKdwrjYJNoYhljc3HaThzszr/6Fqa60W1Mc5o3lCwaY=;
 b=HQ2ji2VvDWjnbBi+vGHBLrIvdGQIvFLbazn9PHuZX/DdxsHHp220Y1+BNp84g79guYTLEU
 gix3k95vWXqHjfBi+CSWZGe3fD2fLExBQV3CQ23acxLGPBsixXVtfJ9sGixOuHjLsaaJkQ
 4/ljrRx+ZnJoSTFcl8+ItVfd44v6mWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-eE_13MMTPVCU9lBs4wkM2g-1; Thu, 14 Jan 2021 05:37:21 -0500
X-MC-Unique: eE_13MMTPVCU9lBs4wkM2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA3281009456;
 Thu, 14 Jan 2021 10:37:19 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E266612D7E;
 Thu, 14 Jan 2021 10:37:16 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Subject: [PATCH v2 1/9] KVM: arm64: vgic-v3: Fix some error codes when setting
 RDIST base
Date: Thu, 14 Jan 2021 11:37:00 +0100
Message-Id: <20210114103708.26763-2-eric.auger@redhat.com>
In-Reply-To: <20210114103708.26763-1-eric.auger@redhat.com>
References: <20210114103708.26763-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

KVM_DEV_ARM_VGIC_GRP_ADDR group doc says we should return
-EEXIST in case the base address of the redist is already set.
We currently return -EINVAL.

However we need to return -EINVAL in case a legacy REDIST address
is attempted to be set while REDIST_REGIONS were set. This case
is discriminated by looking at the count field.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- simplify the check sequence
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 15a6c98ee92f..013b737b658f 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -791,10 +791,6 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
 	int ret;
 
-	/* single rdist region already set ?*/
-	if (!count && !list_empty(rd_regions))
-		return -EINVAL;
-
 	/* cross the end of memory ? */
 	if (base + size < base)
 		return -EINVAL;
@@ -805,11 +801,14 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	} else {
 		rdreg = list_last_entry(rd_regions,
 					struct vgic_redist_region, list);
-		if (index != rdreg->index + 1)
-			return -EINVAL;
 
-		/* Cannot add an explicitly sized regions after legacy region */
-		if (!rdreg->count)
+		if ((!count) != (!rdreg->count))
+			return -EINVAL; /* Mix REDIST and REDIST_REGION */
+
+		if (!count)
+			return -EEXIST;
+
+		if (index != rdreg->index + 1)
 			return -EINVAL;
 	}
 
-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
