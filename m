Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EDBC433B4
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 08:53:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1368560FEE
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 08:53:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1368560FEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD36D4B608;
	Thu,  1 Apr 2021 04:53:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2QAdRCaf8YKK; Thu,  1 Apr 2021 04:53:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B4C44B60F;
	Thu,  1 Apr 2021 04:53:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AD1E4B594
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 04:53:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mK2qGk1kH7hj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 04:53:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD554B608
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 04:53:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617267186;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nPqLtWXi6oUl4VT/EiwUC9B4rzKqCc5vKl7lO4px/gM=;
 b=iPskNJYOTGLCaPykF3Rpub6KmHK5JE10KIclG4sZ3oiIySlyQ/P0J4lxR7x9OxxJGXPtrs
 Xrbn+dZsSjlE0ZoVyW2HtUhvCel067z31tOeGQnigb0eHWuBn6w2JYTgUyinOJQcyWMZya
 Cz9sQbVzIhjtIxD9boHtsN3em83XFWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-WT1BgprrO46lK8sWO7OaYw-1; Thu, 01 Apr 2021 04:53:02 -0400
X-MC-Unique: WT1BgprrO46lK8sWO7OaYw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 713E118C89C4;
 Thu,  1 Apr 2021 08:53:01 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTP id AA67E5D9CC;
 Thu,  1 Apr 2021 08:52:58 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
 alexandru.elisei@arm.com
Subject: [PATCH v4 6/8] KVM: arm64: Simplify argument passing to
 vgic_uaccess_[read|write]
Date: Thu,  1 Apr 2021 10:52:36 +0200
Message-Id: <20210401085238.477270-7-eric.auger@redhat.com>
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

vgic_uaccess() takes a struct vgic_io_device argument, converts it
to a struct kvm_io_device and passes it to the read/write accessor
functions, which convert it back to a struct vgic_io_device.
Avoid the indirection by passing the struct vgic_io_device argument
directly to vgic_uaccess_{read,write}.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- reworded the commit message as suggested by Alexandru
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index b2d73fc0d1ef4..48c6067fc5ecb 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -938,10 +938,9 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 	return region;
 }
 
-static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 			     gpa_t addr, u32 *val)
 {
-	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
 	const struct vgic_register_region *region;
 	struct kvm_vcpu *r_vcpu;
 
@@ -960,10 +959,9 @@ static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	return 0;
 }
 
-static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 			      gpa_t addr, const u32 *val)
 {
-	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
 	const struct vgic_register_region *region;
 	struct kvm_vcpu *r_vcpu;
 
@@ -986,9 +984,9 @@ int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
 		 bool is_write, int offset, u32 *val)
 {
 	if (is_write)
-		return vgic_uaccess_write(vcpu, &dev->dev, offset, val);
+		return vgic_uaccess_write(vcpu, dev, offset, val);
 	else
-		return vgic_uaccess_read(vcpu, &dev->dev, offset, val);
+		return vgic_uaccess_read(vcpu, dev, offset, val);
 }
 
 static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
-- 
2.26.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
