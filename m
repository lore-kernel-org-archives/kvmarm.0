Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC6FC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CE9B64E81
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CE9B64E81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C59354B654;
	Mon, 15 Mar 2021 11:34:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XaZ0yGJxucpV; Mon, 15 Mar 2021 11:34:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7024B6AB;
	Mon, 15 Mar 2021 11:34:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 882554B653
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21LySY6yYKPQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 11:34:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C4F4B679
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1064DD6E;
 Mon, 15 Mar 2021 08:34:36 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB2E03F792;
 Mon, 15 Mar 2021 08:34:34 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v3 16/22] vfio: Switch to new ioport trap handlers
Date: Mon, 15 Mar 2021 15:33:44 +0000
Message-Id: <20210315153350.19988-17-andre.przywara@arm.com>
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

Now that the vfio device has a trap handler adhering to the MMIO fault
handler prototype, let's switch over to the joint registration routine.

This allows us to get rid of the ioport shim routines.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/core.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index ddd3c2c7..3ff2c0b0 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -81,7 +81,7 @@ out_free_buf:
 	return ret;
 }
 
-static bool _vfio_ioport_in(struct vfio_region *region, u32 offset,
+static bool vfio_ioport_in(struct vfio_region *region, u32 offset,
 			    void *data, int len)
 {
 	struct vfio_device *vdev = region->vdev;
@@ -115,7 +115,7 @@ static bool _vfio_ioport_in(struct vfio_region *region, u32 offset,
 	return true;
 }
 
-static bool _vfio_ioport_out(struct vfio_region *region, u32 offset,
+static bool vfio_ioport_out(struct vfio_region *region, u32 offset,
 			     void *data, int len)
 {
 	struct vfio_device *vdev = region->vdev;
@@ -155,30 +155,11 @@ static void vfio_ioport_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 	u32 offset = addr - region->port_base;
 
 	if (is_write)
-		_vfio_ioport_out(region, offset, data, len);
+		vfio_ioport_out(region, offset, data, len);
 	else
-		_vfio_ioport_in(region, offset, data, len);
+		vfio_ioport_in(region, offset, data, len);
 }
 
-static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
-			    u16 port, void *data, int len)
-{
-	vfio_ioport_mmio(vcpu, port, data, len, true, ioport->priv);
-	return true;
-}
-
-static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
-			   u16 port, void *data, int len)
-{
-	vfio_ioport_mmio(vcpu, port, data, len, false, ioport->priv);
-	return true;
-}
-
-static struct ioport_operations vfio_ioport_ops = {
-	.io_in	= vfio_ioport_in,
-	.io_out	= vfio_ioport_out,
-};
-
 static void vfio_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 			     u8 is_write, void *ptr)
 {
@@ -223,9 +204,11 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
 				  struct vfio_region *region)
 {
 	if (region->is_ioport) {
-		int port = ioport__register(kvm, region->port_base,
-					   &vfio_ioport_ops, region->info.size,
-					   region);
+		int port;
+
+		port = kvm__register_pio(kvm, region->port_base,
+					 region->info.size, vfio_ioport_mmio,
+					 region);
 		if (port < 0)
 			return port;
 		return 0;
@@ -292,7 +275,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
 		munmap(region->host_addr, region->info.size);
 		region->host_addr = NULL;
 	} else if (region->is_ioport) {
-		ioport__unregister(kvm, region->port_base);
+		kvm__deregister_pio(kvm, region->port_base);
 	} else {
 		kvm__deregister_mmio(kvm, region->guest_phys_addr);
 	}
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
