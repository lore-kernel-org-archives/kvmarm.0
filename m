Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53571C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED8D764E22
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED8D764E22
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A029C4B681;
	Mon, 15 Mar 2021 11:34:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CXAUuHYJ4wSF; Mon, 15 Mar 2021 11:34:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68AF24B69A;
	Mon, 15 Mar 2021 11:34:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 699114B65C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BdVHrvwj0jMe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 11:34:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E7B4B639
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC642D6E;
 Mon, 15 Mar 2021 08:34:32 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1A503F792;
 Mon, 15 Mar 2021 08:34:31 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v3 14/22] hw/serial: Switch to new trap handlers
Date: Mon, 15 Mar 2021 15:33:42 +0000
Message-Id: <20210315153350.19988-15-andre.przywara@arm.com>
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

Now that the serial device has a trap handler adhering to the MMIO fault
handler prototype, let's switch over to the joint registration routine.

This allows us to get rid of the ioport shim routines.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/serial.c | 31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/hw/serial.c b/hw/serial.c
index 3f797452..16af493b 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -393,26 +393,6 @@ static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 		serial8250_in(dev, vcpu, addr - dev->iobase, data);
 }
 
-static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
-				  u16 port, void *data, int size)
-{
-	struct serial8250_device *dev = ioport->priv;
-
-	serial8250_mmio(vcpu, port, data, 1, true, dev);
-
-	return true;
-}
-
-static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
-				 u16 port, void *data, int size)
-{
-	struct serial8250_device *dev = ioport->priv;
-
-	serial8250_mmio(vcpu, port, data, 1, false, dev);
-
-	return true;
-}
-
 #ifdef CONFIG_HAS_LIBFDT
 
 char *fdt_stdout_path = NULL;
@@ -450,11 +430,6 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
 }
 #endif
 
-static struct ioport_operations serial8250_ops = {
-	.io_in			= serial8250_ioport_in,
-	.io_out			= serial8250_ioport_out,
-};
-
 static int serial8250__device_init(struct kvm *kvm,
 				   struct serial8250_device *dev)
 {
@@ -465,7 +440,7 @@ static int serial8250__device_init(struct kvm *kvm,
 		return r;
 
 	ioport__map_irq(&dev->irq);
-	r = ioport__register(kvm, dev->iobase, &serial8250_ops, 8, dev);
+	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
 
 	return r;
 }
@@ -488,7 +463,7 @@ cleanup:
 	for (j = 0; j <= i; j++) {
 		struct serial8250_device *dev = &devices[j];
 
-		ioport__unregister(kvm, dev->iobase);
+		kvm__deregister_pio(kvm, dev->iobase);
 		device__unregister(&dev->dev_hdr);
 	}
 
@@ -504,7 +479,7 @@ int serial8250__exit(struct kvm *kvm)
 	for (i = 0; i < ARRAY_SIZE(devices); i++) {
 		struct serial8250_device *dev = &devices[i];
 
-		r = ioport__unregister(kvm, dev->iobase);
+		r = kvm__deregister_pio(kvm, dev->iobase);
 		if (r < 0)
 			return r;
 		device__unregister(&dev->dev_hdr);
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
