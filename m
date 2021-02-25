Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC54C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4772D64F10
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4772D64F10
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E46A24B2A3;
	Wed, 24 Feb 2021 20:00:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EMzWV4YCUvK4; Wed, 24 Feb 2021 20:00:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7EF74B2C0;
	Wed, 24 Feb 2021 20:00:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F9754B2EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kz27vbKLBESQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 20:00:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CE264B292
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:46 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AFEC143D;
 Wed, 24 Feb 2021 17:00:46 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 101DC3F73B;
 Wed, 24 Feb 2021 17:00:44 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v2 13/22] hw/serial: Refactor trap handler
Date: Thu, 25 Feb 2021 00:59:06 +0000
Message-Id: <20210225005915.26423-14-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
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

Adjust the trap handler to use that new function, and provide shims to
implement the old ioport interface, for now.

We drop the usage of ioport__read8/write8 entirely, as this would only
be applicable for I/O port accesses, and does nothing for 8-bit wide
accesses anyway.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/serial.c | 93 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 35 deletions(-)

diff --git a/hw/serial.c b/hw/serial.c
index b0465d99..c495eac1 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -242,36 +242,31 @@ void serial8250__inject_sysrq(struct kvm *kvm, char sysrq)
 	sysrq_pending = sysrq;
 }
 
-static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
-			   void *data, int size)
+static bool serial8250_out(struct serial8250_device *dev, struct kvm_cpu *vcpu,
+			   u16 offset, u8 data)
 {
-	struct serial8250_device *dev = ioport->priv;
-	u16 offset;
 	bool ret = true;
-	char *addr = data;
 
 	mutex_lock(&dev->mutex);
 
-	offset = port - dev->iobase;
-
 	switch (offset) {
 	case UART_TX:
 		if (dev->lcr & UART_LCR_DLAB) {
-			dev->dll = ioport__read8(data);
+			dev->dll = data;
 			break;
 		}
 
 		/* Loopback mode */
 		if (dev->mcr & UART_MCR_LOOP) {
 			if (dev->rxcnt < FIFO_LEN) {
-				dev->rxbuf[dev->rxcnt++] = *addr;
+				dev->rxbuf[dev->rxcnt++] = data;
 				dev->lsr |= UART_LSR_DR;
 			}
 			break;
 		}
 
 		if (dev->txcnt < FIFO_LEN) {
-			dev->txbuf[dev->txcnt++] = *addr;
+			dev->txbuf[dev->txcnt++] = data;
 			dev->lsr &= ~UART_LSR_TEMT;
 			if (dev->txcnt == FIFO_LEN / 2)
 				dev->lsr &= ~UART_LSR_THRE;
@@ -283,18 +278,18 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
 		break;
 	case UART_IER:
 		if (!(dev->lcr & UART_LCR_DLAB))
-			dev->ier = ioport__read8(data) & 0x0f;
+			dev->ier = data & 0x0f;
 		else
-			dev->dlm = ioport__read8(data);
+			dev->dlm = data;
 		break;
 	case UART_FCR:
-		dev->fcr = ioport__read8(data);
+		dev->fcr = data;
 		break;
 	case UART_LCR:
-		dev->lcr = ioport__read8(data);
+		dev->lcr = data;
 		break;
 	case UART_MCR:
-		dev->mcr = ioport__read8(data);
+		dev->mcr = data;
 		break;
 	case UART_LSR:
 		/* Factory test */
@@ -303,7 +298,7 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
 		/* Not used */
 		break;
 	case UART_SCR:
-		dev->scr = ioport__read8(data);
+		dev->scr = data;
 		break;
 	default:
 		ret = false;
@@ -317,7 +312,7 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
 	return ret;
 }
 
-static void serial8250_rx(struct serial8250_device *dev, void *data)
+static void serial8250_rx(struct serial8250_device *dev, u8 *data)
 {
 	if (dev->rxdone == dev->rxcnt)
 		return;
@@ -325,57 +320,54 @@ static void serial8250_rx(struct serial8250_device *dev, void *data)
 	/* Break issued ? */
 	if (dev->lsr & UART_LSR_BI) {
 		dev->lsr &= ~UART_LSR_BI;
-		ioport__write8(data, 0);
+		*data = 0;
 		return;
 	}
 
-	ioport__write8(data, dev->rxbuf[dev->rxdone++]);
+	*data = dev->rxbuf[dev->rxdone++];
 	if (dev->rxcnt == dev->rxdone) {
 		dev->lsr &= ~UART_LSR_DR;
 		dev->rxcnt = dev->rxdone = 0;
 	}
 }
 
-static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool serial8250_in(struct serial8250_device *dev, struct kvm_cpu *vcpu,
+			  u16 offset, u8 *data)
 {
-	struct serial8250_device *dev = ioport->priv;
-	u16 offset;
 	bool ret = true;
 
 	mutex_lock(&dev->mutex);
 
-	offset = port - dev->iobase;
-
 	switch (offset) {
 	case UART_RX:
 		if (dev->lcr & UART_LCR_DLAB)
-			ioport__write8(data, dev->dll);
+			*data = dev->dll;
 		else
 			serial8250_rx(dev, data);
 		break;
 	case UART_IER:
 		if (dev->lcr & UART_LCR_DLAB)
-			ioport__write8(data, dev->dlm);
+			*data = dev->dlm;
 		else
-			ioport__write8(data, dev->ier);
+			*data = dev->ier;
 		break;
 	case UART_IIR:
-		ioport__write8(data, dev->iir | UART_IIR_TYPE_BITS);
+		*data = dev->iir | UART_IIR_TYPE_BITS;
 		break;
 	case UART_LCR:
-		ioport__write8(data, dev->lcr);
+		*data = dev->lcr;
 		break;
 	case UART_MCR:
-		ioport__write8(data, dev->mcr);
+		*data = dev->mcr;
 		break;
 	case UART_LSR:
-		ioport__write8(data, dev->lsr);
+		*data = dev->lsr;
 		break;
 	case UART_MSR:
-		ioport__write8(data, dev->msr);
+		*data = dev->msr;
 		break;
 	case UART_SCR:
-		ioport__write8(data, dev->scr);
+		*data = dev->scr;
 		break;
 	default:
 		ret = false;
@@ -389,6 +381,37 @@ static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
 	return ret;
 }
 
+static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+			    u8 is_write, void *ptr)
+{
+	struct serial8250_device *dev = ptr;
+
+	if (is_write)
+		serial8250_out(dev, vcpu, addr - dev->iobase, *data);
+	else
+		serial8250_in(dev, vcpu, addr - dev->iobase, data);
+}
+
+static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
+				  u16 port, void *data, int size)
+{
+	struct serial8250_device *dev = ioport->priv;
+
+	serial8250_mmio(vcpu, port, data, 1, true, dev);
+
+	return true;
+}
+
+static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
+				 u16 port, void *data, int size)
+{
+	struct serial8250_device *dev = ioport->priv;
+
+	serial8250_mmio(vcpu, port, data, 1, false, dev);
+
+	return true;
+}
+
 #ifdef CONFIG_HAS_LIBFDT
 
 char *fdt_stdout_path = NULL;
@@ -427,8 +450,8 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
 #endif
 
 static struct ioport_operations serial8250_ops = {
-	.io_in			= serial8250_in,
-	.io_out			= serial8250_out,
+	.io_in			= serial8250_ioport_in,
+	.io_out			= serial8250_ioport_out,
 };
 
 static int serial8250__device_init(struct kvm *kvm,
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
