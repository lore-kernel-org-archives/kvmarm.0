Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA832C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 598BA23D98
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 598BA23D98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01FF24B228;
	Thu, 10 Dec 2020 09:29:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TbsgNQDo2sBD; Thu, 10 Dec 2020 09:29:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDF294B1E6;
	Thu, 10 Dec 2020 09:29:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F089C4B1AC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wQvSKzXgz9EZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 09:29:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 600884B1D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:43 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20C92152F;
 Thu, 10 Dec 2020 06:29:43 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 079D23F718;
 Thu, 10 Dec 2020 06:29:41 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 16/21] vfio: Switch to new ioport trap handlers
Date: Thu, 10 Dec 2020 14:29:03 +0000
Message-Id: <20201210142908.169597-17-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210142908.169597-1-andre.przywara@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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
---
 vfio/core.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index f55f1f87..10919101 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -160,25 +160,6 @@ static void vfio_ioport_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 		_vfio_ioport_in(region, offset, data, len);
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
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
