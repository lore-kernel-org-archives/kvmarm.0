Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7A5C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CABE523E51
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CABE523E51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E41B4B129;
	Thu, 10 Dec 2020 09:29:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qjQke7uUXs6a; Thu, 10 Dec 2020 09:29:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 652404B261;
	Thu, 10 Dec 2020 09:29:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65E744B1CE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g4HbdGzVoWPB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 09:29:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20F024B24F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:38 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D38071480;
 Thu, 10 Dec 2020 06:29:37 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9FC43F718;
 Thu, 10 Dec 2020 06:29:36 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 12/21] hw/vesa: Switch trap handling to use MMIO
 handler
Date: Thu, 10 Dec 2020 14:28:59 +0000
Message-Id: <20201210142908.169597-13-andre.przywara@arm.com>
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

To be able to use the VESA device with the new generic I/O trap handler,
we need to use the different MMIO handler callback routine.

Replace the existing dummy in and out handlers with a joint dummy
MMIO handler, and register this using the new registration function.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/vesa.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/hw/vesa.c b/hw/vesa.c
index 8659a002..7f82cdb4 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -43,21 +43,11 @@ static struct framebuffer vesafb = {
 	.mem_size	= VESA_MEM_SIZE,
 };
 
-static bool vesa_pci_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void vesa_pci_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+		        u8 is_write, void *ptr)
 {
-	return true;
 }
 
-static bool vesa_pci_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	return true;
-}
-
-static struct ioport_operations vesa_io_ops = {
-	.io_in			= vesa_pci_io_in,
-	.io_out			= vesa_pci_io_out,
-};
-
 static int vesa__bar_activate(struct kvm *kvm, struct pci_device_header *pci_hdr,
 			      int bar_num, void *data)
 {
@@ -82,7 +72,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 	BUILD_BUG_ON(VESA_MEM_SIZE < VESA_BPP/8 * VESA_WIDTH * VESA_HEIGHT);
 
 	vesa_base_addr = pci_get_io_port_block(PCI_IO_SIZE);
-	r = ioport__register(kvm, vesa_base_addr, &vesa_io_ops, PCI_IO_SIZE, NULL);
+	r = kvm__register_pio(kvm, vesa_base_addr, PCI_IO_SIZE, vesa_pci_io,
+			      NULL);
 	if (r < 0)
 		goto out_error;
 
@@ -116,7 +107,7 @@ unmap_dev:
 unregister_device:
 	device__unregister(&vesa_device);
 unregister_ioport:
-	ioport__unregister(kvm, vesa_base_addr);
+	kvm__deregister_pio(kvm, vesa_base_addr);
 out_error:
 	return ERR_PTR(r);
 }
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
