Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B534BC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:01:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 434E164EF1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 434E164EF1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4934B301;
	Wed, 24 Feb 2021 20:01:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 96TPIan-ugii; Wed, 24 Feb 2021 20:00:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52E864B30C;
	Wed, 24 Feb 2021 20:00:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 180684B25C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hGtn7Zxv5rrb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 20:00:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59BF74B0C7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A9381478;
 Wed, 24 Feb 2021 17:00:54 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C44993F73B;
 Wed, 24 Feb 2021 17:00:52 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v2 18/22] pci: Switch trap handling to use MMIO handler
Date: Thu, 25 Feb 2021 00:59:11 +0000
Message-Id: <20210225005915.26423-19-andre.przywara@arm.com>
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

Merge the existing _in and _out handlers to adhere to that MMIO
interface, and register these using the new registration function.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 pci.c | 82 +++++++++++++++++------------------------------------------
 1 file changed, 24 insertions(+), 58 deletions(-)

diff --git a/pci.c b/pci.c
index 2e2c0270..d6da79e0 100644
--- a/pci.c
+++ b/pci.c
@@ -87,29 +87,16 @@ static void *pci_config_address_ptr(u16 port)
 	return base + offset;
 }
 
-static bool pci_config_address_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void pci_config_address_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				    u32 len, u8 is_write, void *ptr)
 {
-	void *p = pci_config_address_ptr(port);
+	void *p = pci_config_address_ptr(addr);
 
-	memcpy(p, data, size);
-
-	return true;
-}
-
-static bool pci_config_address_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	void *p = pci_config_address_ptr(port);
-
-	memcpy(data, p, size);
-
-	return true;
+	if (is_write)
+		memcpy(p, data, len);
+	else
+		memcpy(data, p, len);
 }
-
-static struct ioport_operations pci_config_address_ops = {
-	.io_in	= pci_config_address_in,
-	.io_out	= pci_config_address_out,
-};
-
 static bool pci_device_exists(u8 bus_number, u8 device_number, u8 function_number)
 {
 	union pci_config_address pci_config_address;
@@ -125,49 +112,27 @@ static bool pci_device_exists(u8 bus_number, u8 device_number, u8 function_numbe
 	return !IS_ERR_OR_NULL(device__find_dev(DEVICE_BUS_PCI, device_number));
 }
 
-static bool pci_config_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	union pci_config_address pci_config_address;
-
-	if (size > 4)
-		size = 4;
-
-	pci_config_address.w = ioport__read32(&pci_config_address_bits);
-	/*
-	 * If someone accesses PCI configuration space offsets that are not
-	 * aligned to 4 bytes, it uses ioports to signify that.
-	 */
-	pci_config_address.reg_offset = port - PCI_CONFIG_DATA;
-
-	pci__config_wr(vcpu->kvm, pci_config_address, data, size);
-
-	return true;
-}
-
-static bool pci_config_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void pci_config_data_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				 u32 len, u8 is_write, void *kvm)
 {
 	union pci_config_address pci_config_address;
 
-	if (size > 4)
-		size = 4;
+	if (len > 4)
+		len = 4;
 
 	pci_config_address.w = ioport__read32(&pci_config_address_bits);
 	/*
 	 * If someone accesses PCI configuration space offsets that are not
 	 * aligned to 4 bytes, it uses ioports to signify that.
 	 */
-	pci_config_address.reg_offset = port - PCI_CONFIG_DATA;
+	pci_config_address.reg_offset = addr - PCI_CONFIG_DATA;
 
-	pci__config_rd(vcpu->kvm, pci_config_address, data, size);
-
-	return true;
+	if (is_write)
+		pci__config_wr(vcpu->kvm, pci_config_address, data, len);
+	else
+		pci__config_rd(vcpu->kvm, pci_config_address, data, len);
 }
 
-static struct ioport_operations pci_config_data_ops = {
-	.io_in	= pci_config_data_in,
-	.io_out	= pci_config_data_out,
-};
-
 static int pci_activate_bar(struct kvm *kvm, struct pci_device_header *pci_hdr,
 			    int bar_num)
 {
@@ -512,11 +477,12 @@ int pci__init(struct kvm *kvm)
 {
 	int r;
 
-	r = ioport__register(kvm, PCI_CONFIG_DATA + 0, &pci_config_data_ops, 4, NULL);
+	r = kvm__register_pio(kvm, PCI_CONFIG_DATA, 4,
+				 pci_config_data_mmio, NULL);
 	if (r < 0)
 		return r;
-
-	r = ioport__register(kvm, PCI_CONFIG_ADDRESS + 0, &pci_config_address_ops, 4, NULL);
+	r = kvm__register_pio(kvm, PCI_CONFIG_ADDRESS, 4,
+				 pci_config_address_mmio, NULL);
 	if (r < 0)
 		goto err_unregister_data;
 
@@ -528,17 +494,17 @@ int pci__init(struct kvm *kvm)
 	return 0;
 
 err_unregister_addr:
-	ioport__unregister(kvm, PCI_CONFIG_ADDRESS);
+	kvm__deregister_pio(kvm, PCI_CONFIG_ADDRESS);
 err_unregister_data:
-	ioport__unregister(kvm, PCI_CONFIG_DATA);
+	kvm__deregister_pio(kvm, PCI_CONFIG_DATA);
 	return r;
 }
 dev_base_init(pci__init);
 
 int pci__exit(struct kvm *kvm)
 {
-	ioport__unregister(kvm, PCI_CONFIG_DATA);
-	ioport__unregister(kvm, PCI_CONFIG_ADDRESS);
+	kvm__deregister_pio(kvm, PCI_CONFIG_DATA);
+	kvm__deregister_pio(kvm, PCI_CONFIG_ADDRESS);
 
 	return 0;
 }
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
