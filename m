Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F02C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A3FD64E83
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A3FD64E83
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D6CD4B5CE;
	Mon, 15 Mar 2021 11:34:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e-j8rAt0CETT; Mon, 15 Mar 2021 11:34:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00A254B5CC;
	Mon, 15 Mar 2021 11:34:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D5994B515
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Iw0Rtf4wgsBq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 11:34:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6A44B487
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEC8A1FB;
 Mon, 15 Mar 2021 08:34:15 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93E6A3F792;
 Mon, 15 Mar 2021 08:34:14 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v3 03/22] ioport: Retire .generate_fdt_node
 functionality
Date: Mon, 15 Mar 2021 15:33:31 +0000
Message-Id: <20210315153350.19988-4-andre.przywara@arm.com>
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

The ioport routines support a special way of registering FDT node
generator functions. There is no reason to have this separate from the
already existing way via the device header.

Now that the only user of this special ioport variety has been
transferred, we can retire this code, to simplify ioport handling.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/ioport.h |  4 ----
 ioport.c             | 34 ----------------------------------
 2 files changed, 38 deletions(-)

diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index d0213541..a61038e2 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -29,10 +29,6 @@ struct ioport {
 struct ioport_operations {
 	bool (*io_in)(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size);
 	bool (*io_out)(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size);
-	void (*generate_fdt_node)(struct ioport *ioport, void *fdt,
-				  void (*generate_irq_prop)(void *fdt,
-							    u8 irq,
-							    enum irq_type));
 };
 
 void ioport__map_irq(u8 *irq);
diff --git a/ioport.c b/ioport.c
index a6972179..e0123f27 100644
--- a/ioport.c
+++ b/ioport.c
@@ -56,7 +56,6 @@ static struct ioport *ioport_get(struct rb_root *root, u64 addr)
 /* Called with ioport_lock held. */
 static void ioport_unregister(struct rb_root *root, struct ioport *data)
 {
-	device__unregister(&data->dev_hdr);
 	ioport_remove(root, data);
 	free(data);
 }
@@ -70,30 +69,6 @@ static void ioport_put(struct rb_root *root, struct ioport *data)
 	mutex_unlock(&ioport_lock);
 }
 
-#ifdef CONFIG_HAS_LIBFDT
-static void generate_ioport_fdt_node(void *fdt,
-				     struct device_header *dev_hdr,
-				     void (*generate_irq_prop)(void *fdt,
-							       u8 irq,
-							       enum irq_type))
-{
-	struct ioport *ioport = container_of(dev_hdr, struct ioport, dev_hdr);
-	struct ioport_operations *ops = ioport->ops;
-
-	if (ops->generate_fdt_node)
-		ops->generate_fdt_node(ioport, fdt, generate_irq_prop);
-}
-#else
-static void generate_ioport_fdt_node(void *fdt,
-				     struct device_header *dev_hdr,
-				     void (*generate_irq_prop)(void *fdt,
-							       u8 irq,
-							       enum irq_type))
-{
-	die("Unable to generate device tree nodes without libfdt\n");
-}
-#endif
-
 int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, int count, void *param)
 {
 	struct ioport *entry;
@@ -107,10 +82,6 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 		.node		= RB_INT_INIT(port, port + count),
 		.ops		= ops,
 		.priv		= param,
-		.dev_hdr	= (struct device_header) {
-			.bus_type	= DEVICE_BUS_IOPORT,
-			.data		= generate_ioport_fdt_node,
-		},
 		/*
 		 * Start from 0 because ioport__unregister() doesn't decrement
 		 * the reference count.
@@ -123,15 +94,10 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	r = ioport_insert(&ioport_tree, entry);
 	if (r < 0)
 		goto out_free;
-	r = device__register(&entry->dev_hdr);
-	if (r < 0)
-		goto out_remove;
 	mutex_unlock(&ioport_lock);
 
 	return port;
 
-out_remove:
-	ioport_remove(&ioport_tree, entry);
 out_free:
 	free(entry);
 	mutex_unlock(&ioport_lock);
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
