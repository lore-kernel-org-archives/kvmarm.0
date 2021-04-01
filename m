Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACD3C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 08:53:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B16AF60FEE
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 08:53:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B16AF60FEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C7EF4B610;
	Thu,  1 Apr 2021 04:53:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jtw62hqlFv59; Thu,  1 Apr 2021 04:52:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 377984B5C3;
	Thu,  1 Apr 2021 04:52:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D475D4B4B1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 04:52:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oeWShvhWTQqH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 04:52:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C83964B5FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 04:52:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617267177;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oAp8KP+PLZpDIKXzQzhXsSAbuzZEHkjTkksMRphxdow=;
 b=GEW9RNzh2wtMDTEq6GGqCmP5Tr4ytUlkza5/06LTgacNreda1F9kkPo2GQr4sINVDXSP36
 Z4gNLeGwMmQUSt5CowP697xiwOPI2KsGaxSb4wfcIYtJ7pgYX3NutEWrBe2PpMoxBPZKrk
 tcNMVMnaCLXgCK+9jymolFYPyFQx7GE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-LucLALYfP0SAUJFgksrUTw-1; Thu, 01 Apr 2021 04:52:54 -0400
X-MC-Unique: LucLALYfP0SAUJFgksrUTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63095501FF;
 Thu,  1 Apr 2021 08:52:52 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTP id BDEF65D9CC;
 Thu,  1 Apr 2021 08:52:49 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
 alexandru.elisei@arm.com
Subject: [PATCH v4 3/8] KVM: arm64: vgic-v3: Fix error handling in
 vgic_v3_set_redist_base()
Date: Thu,  1 Apr 2021 10:52:33 +0200
Message-Id: <20210401085238.477270-4-eric.auger@redhat.com>
In-Reply-To: <20210401085238.477270-1-eric.auger@redhat.com>
References: <20210401085238.477270-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

vgic_v3_insert_redist_region() may succeed while
vgic_register_all_redist_iodevs fails. For example this happens
while adding a redistributor region overlapping a dist region. The
failure only is detected on vgic_register_all_redist_iodevs when
vgic_v3_check_base() gets called in vgic_register_redist_iodev().

In such a case, remove the newly added redistributor region and free
it.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- fix the commit message and split declaration/assignment of rdreg
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 013b737b658f8..987e366c80008 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -860,8 +860,14 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	 * afterwards will register the iodevs when needed.
 	 */
 	ret = vgic_register_all_redist_iodevs(kvm);
-	if (ret)
+	if (ret) {
+		struct vgic_redist_region *rdreg;
+
+		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
+		list_del(&rdreg->list);
+		kfree(rdreg);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.26.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
