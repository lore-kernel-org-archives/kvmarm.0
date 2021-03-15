Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD99FC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8842F64E6B
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8842F64E6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0D44B675;
	Mon, 15 Mar 2021 11:34:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sptk9BEQ1L87; Mon, 15 Mar 2021 11:34:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E553A4B688;
	Mon, 15 Mar 2021 11:34:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 110674B57B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KA+Rqm1ewNrY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 11:34:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4FA04B606
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80CB61FB;
 Mon, 15 Mar 2021 08:34:34 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3288A3F792;
 Mon, 15 Mar 2021 08:34:33 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v3 15/22] vfio: Refactor ioport trap handler
Date: Mon, 15 Mar 2021 15:33:43 +0000
Message-Id: <20210315153350.19988-16-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210315153350.19988-1-andre.przywara@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Sami Mujawar <sami.mujawar@arm.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

With the planned retirement of the special ioport emulation code, we
need to provide an emulation function compatible with the MMIO prototype.

Adjust the I/O port trap handler to use that new function, and provide
shims to implement the old ioport interface, for now.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/core.c | 51 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index 0b45e78b..ddd3c2c7 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -81,15 +81,12 @@ out_free_buf:
 	return ret;
 }
 
-static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
-			   u16 port, void *data, int len)
+static bool _vfio_ioport_in(struct vfio_region *region, u32 offset,
+			    void *data, int len)
 {
-	u32 val;
-	ssize_t nr;
-	struct vfio_region *region = ioport->priv;
 	struct vfio_device *vdev = region->vdev;
-
-	u32 offset = port - region->port_base;
+	ssize_t nr;
+	u32 val;
 
 	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_READ))
 		return false;
@@ -97,7 +94,7 @@ static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
 	nr = pread(vdev->fd, &val, len, region->info.offset + offset);
 	if (nr != len) {
 		vfio_dev_err(vdev, "could not read %d bytes from I/O port 0x%x\n",
-			     len, port);
+			     len, offset + region->port_base);
 		return false;
 	}
 
@@ -118,15 +115,13 @@ static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
 	return true;
 }
 
-static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
-			    u16 port, void *data, int len)
+static bool _vfio_ioport_out(struct vfio_region *region, u32 offset,
+			     void *data, int len)
 {
-	u32 val;
-	ssize_t nr;
-	struct vfio_region *region = ioport->priv;
 	struct vfio_device *vdev = region->vdev;
+	ssize_t nr;
+	u32 val;
 
-	u32 offset = port - region->port_base;
 
 	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_WRITE))
 		return false;
@@ -148,11 +143,37 @@ static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
 	nr = pwrite(vdev->fd, &val, len, region->info.offset + offset);
 	if (nr != len)
 		vfio_dev_err(vdev, "could not write %d bytes to I/O port 0x%x",
-			     len, port);
+			     len, offset + region->port_base);
 
 	return nr == len;
 }
 
+static void vfio_ioport_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+			     u8 is_write, void *ptr)
+{
+	struct vfio_region *region = ptr;
+	u32 offset = addr - region->port_base;
+
+	if (is_write)
+		_vfio_ioport_out(region, offset, data, len);
+	else
+		_vfio_ioport_in(region, offset, data, len);
+}
+
+static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
+			    u16 port, void *data, int len)
+{
+	vfio_ioport_mmio(vcpu, port, data, len, true, ioport->priv);
+	return true;
+}
+
+static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
+			   u16 port, void *data, int len)
+{
+	vfio_ioport_mmio(vcpu, port, data, len, false, ioport->priv);
+	return true;
+}
+
 static struct ioport_operations vfio_ioport_ops = {
 	.io_in	= vfio_ioport_in,
 	.io_out	= vfio_ioport_out,
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
