Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7AEC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B344423D9D
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B344423D9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52EED4B190;
	Thu, 10 Dec 2020 09:29:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3YHbo1GOCWfs; Thu, 10 Dec 2020 09:29:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 098454B250;
	Thu, 10 Dec 2020 09:29:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 895604B191
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R2BbYO+wFify for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 09:29:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC1A44B1A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:44 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DBD51516;
 Thu, 10 Dec 2020 06:29:44 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5444B3F718;
 Thu, 10 Dec 2020 06:29:43 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 17/21] virtio: Switch trap handling to use MMIO handler
Date: Thu, 10 Dec 2020 14:29:04 +0000
Message-Id: <20201210142908.169597-18-andre.przywara@arm.com>
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

With the planned retirement of the special ioport emulation code, we
need to provide an emulation function compatible with the MMIO prototype.

Adjust the existing MMIO callback routine to automatically determine
the region this trap came through, and call the existing I/O handlers.
Register the ioport region using the new registration function.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virtio/pci.c | 42 ++++++++++--------------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 6eea6c68..49d3f4d5 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -178,15 +178,6 @@ static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev
 	return ret;
 }
 
-static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	struct virtio_device *vdev = ioport->priv;
-	struct virtio_pci *vpci = vdev->virtio;
-	unsigned long offset = port - virtio_pci__port_addr(vpci);
-
-	return virtio_pci__data_in(vcpu, vdev, offset, data, size);
-}
-
 static void update_msix_map(struct virtio_pci *vpci,
 			    struct msix_table *msix_entry, u32 vecnum)
 {
@@ -334,20 +325,6 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 	return ret;
 }
 
-static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	struct virtio_device *vdev = ioport->priv;
-	struct virtio_pci *vpci = vdev->virtio;
-	unsigned long offset = port - virtio_pci__port_addr(vpci);
-
-	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
-}
-
-static struct ioport_operations virtio_pci__io_ops = {
-	.io_in	= virtio_pci__io_in,
-	.io_out	= virtio_pci__io_out,
-};
-
 static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 					   u64 addr, u8 *data, u32 len,
 					   u8 is_write, void *ptr)
@@ -455,12 +432,15 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 {
 	struct virtio_device *vdev = ptr;
 	struct virtio_pci *vpci = vdev->virtio;
-	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
+	u32 base_addr = virtio_pci__mmio_addr(vpci);
+
+	if (addr < base_addr || addr >= base_addr + PCI_IO_SIZE)
+		base_addr = virtio_pci__port_addr(vpci);
 
 	if (!is_write)
-		virtio_pci__data_in(vcpu, vdev, addr - mmio_addr, data, len);
+		virtio_pci__data_in(vcpu, vdev, addr - base_addr, data, len);
 	else
-		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
+		virtio_pci__data_out(vcpu, vdev, addr - base_addr, data, len);
 }
 
 static int virtio_pci__bar_activate(struct kvm *kvm,
@@ -478,10 +458,8 @@ static int virtio_pci__bar_activate(struct kvm *kvm,
 
 	switch (bar_num) {
 	case 0:
-		r = ioport__register(kvm, bar_addr, &virtio_pci__io_ops,
-				     bar_size, vdev);
-		if (r > 0)
-			r = 0;
+		r = kvm__register_pio(kvm, bar_addr, bar_size,
+				      virtio_pci__io_mmio_callback, vdev);
 		break;
 	case 1:
 		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
@@ -510,7 +488,7 @@ static int virtio_pci__bar_deactivate(struct kvm *kvm,
 
 	switch (bar_num) {
 	case 0:
-		r = ioport__unregister(kvm, bar_addr);
+		r = kvm__deregister_pio(kvm, bar_addr);
 		break;
 	case 1:
 	case 2:
@@ -625,7 +603,7 @@ int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev)
 	virtio_pci__reset(kvm, vdev);
 	kvm__deregister_mmio(kvm, virtio_pci__mmio_addr(vpci));
 	kvm__deregister_mmio(kvm, virtio_pci__msix_io_addr(vpci));
-	ioport__unregister(kvm, virtio_pci__port_addr(vpci));
+	kvm__deregister_pio(kvm, virtio_pci__port_addr(vpci));
 
 	return 0;
 }
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
