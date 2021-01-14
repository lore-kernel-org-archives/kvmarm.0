Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39088C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:37:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C65E823A3B
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C65E823A3B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65EF94B1C1;
	Thu, 14 Jan 2021 05:37:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JpJB+HSRIN05; Thu, 14 Jan 2021 05:37:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C53A4B1AA;
	Thu, 14 Jan 2021 05:37:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B28934B116
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:37:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O+rD5x9DzT+U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 05:37:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 449134B102
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:37:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610620668;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=W1VhNL+LcOCt2GTdnGt+y0NRR3dOMq/QykWmNiUu9QY=;
 b=eRCzBEpHoi3p7BHr/XbYcSVq7GeUQvym3Ph0337GOuAVIhFRbFylbAOhcZ/A5MJoJ79J7k
 Amnl28iYwTP/IJ5MxC8zcxDnef0UB18ArnltXhVuSqP48g1KsaOgoMpwiLe5SDps6Dgnjt
 pxRvK3kAvt6QQ+0HezpSAAuXHT9eJyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-sFZm2qP2M_qjKOIUCLiErA-1; Thu, 14 Jan 2021 05:37:46 -0500
X-MC-Unique: sFZm2qP2M_qjKOIUCLiErA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E718E19251A2;
 Thu, 14 Jan 2021 10:37:44 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 19F3E12D7E;
 Thu, 14 Jan 2021 10:37:41 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Subject: [PATCH v2 7/9] KVM: arm64: Simplify argument passing to
 vgic_uaccess_[read|write]
Date: Thu, 14 Jan 2021 11:37:06 +0100
Message-Id: <20210114103708.26763-8-eric.auger@redhat.com>
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
index b2d73fc0d1ef..48c6067fc5ec 100644
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
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
