Return-Path: <SRS0=J0qp=JB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BFFC433ED
	for <kvmarm@archiver.kernel.org>; Sun,  4 Apr 2021 17:23:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C33486128D
	for <kvmarm@archiver.kernel.org>; Sun,  4 Apr 2021 17:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C33486128D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 749794BC1A;
	Sun,  4 Apr 2021 13:23:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XEAgPtcTvHfQ; Sun,  4 Apr 2021 13:23:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5914BBA3;
	Sun,  4 Apr 2021 13:23:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2207F4BBB3
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Apr 2021 13:23:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cx2IXwqdU2sN for <kvmarm@lists.cs.columbia.edu>;
 Sun,  4 Apr 2021 13:23:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B45A4BB7F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Apr 2021 13:23:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617556993;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ByjtabHi3qP6F5UkQNQxBF2bES6muJXwq+B7lZjhBgQ=;
 b=iWKltYXDAvT9TYxX8bLezyKpE50Ilb8kVyUCl9BcmcrPMfad6PorUsPVY5SjF2reaUHKgS
 vD05Yaf3/mFIsFR0bD6wm5ytvCZuRmnHjwpvaXtf2DyyQyH0D6kmFCPYXlOKor8DucTGFE
 3+9RD5h1C8G4lfGcivGIaegJxycYJ9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-CsZ_E29sPNWdCoqHUVwR5Q-1; Sun, 04 Apr 2021 13:23:11 -0400
X-MC-Unique: CsZ_E29sPNWdCoqHUVwR5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A26610CE7A8;
 Sun,  4 Apr 2021 17:23:10 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 52E4E10027C4;
 Sun,  4 Apr 2021 17:23:04 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
 alexandru.elisei@arm.com
Subject: [PATCH v5 5/8] KVM: arm64: Simplify argument passing to
 vgic_uaccess_[read|write]
Date: Sun,  4 Apr 2021 19:22:40 +0200
Message-Id: <20210404172243.504309-6-eric.auger@redhat.com>
In-Reply-To: <20210404172243.504309-1-eric.auger@redhat.com>
References: <20210404172243.504309-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
2.26.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
