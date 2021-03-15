Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AF2C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 793DF64E83
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 793DF64E83
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AB8B4B5A3;
	Mon, 15 Mar 2021 11:34:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ySW8WtR7sLlJ; Mon, 15 Mar 2021 11:34:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8E1E4B5CA;
	Mon, 15 Mar 2021 11:34:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D7124B486
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 69ycQTH25Vrd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 11:34:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4842E4B487
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C680ED6E;
 Mon, 15 Mar 2021 08:34:12 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 717D53F792;
 Mon, 15 Mar 2021 08:34:11 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v3 01/22] ioport: Remove ioport__setup_arch()
Date: Mon, 15 Mar 2021 15:33:29 +0000
Message-Id: <20210315153350.19988-2-andre.przywara@arm.com>
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

Since x86 had a special need for registering tons of special I/O ports,
we had an ioport__setup_arch() callback, to allow each architecture
to do the same. As it turns out no one uses it beside x86, so we remove
that unnecessary abstraction.

The generic function was registered via a device_base_init() call, so
we just do the same for the x86 specific function only, and can remove
the unneeded ioport__setup_arch().

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/ioport.c         | 5 -----
 include/kvm/ioport.h | 1 -
 ioport.c             | 6 ------
 mips/kvm.c           | 5 -----
 powerpc/ioport.c     | 6 ------
 x86/ioport.c         | 3 ++-
 6 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/arm/ioport.c b/arm/ioport.c
index 2f0feb9a..24092c9d 100644
--- a/arm/ioport.c
+++ b/arm/ioport.c
@@ -1,11 +1,6 @@
 #include "kvm/ioport.h"
 #include "kvm/irq.h"
 
-int ioport__setup_arch(struct kvm *kvm)
-{
-	return 0;
-}
-
 void ioport__map_irq(u8 *irq)
 {
 	*irq = irq__alloc_line();
diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index 039633f7..d0213541 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -35,7 +35,6 @@ struct ioport_operations {
 							    enum irq_type));
 };
 
-int ioport__setup_arch(struct kvm *kvm);
 void ioport__map_irq(u8 *irq);
 
 int __must_check ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops,
diff --git a/ioport.c b/ioport.c
index 844a832d..a6972179 100644
--- a/ioport.c
+++ b/ioport.c
@@ -221,12 +221,6 @@ out:
 	return !kvm->cfg.ioport_debug;
 }
 
-int ioport__init(struct kvm *kvm)
-{
-	return ioport__setup_arch(kvm);
-}
-dev_base_init(ioport__init);
-
 int ioport__exit(struct kvm *kvm)
 {
 	ioport__unregister_all();
diff --git a/mips/kvm.c b/mips/kvm.c
index 26355930..e110e5d5 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -100,11 +100,6 @@ void kvm__irq_trigger(struct kvm *kvm, int irq)
 		die_perror("KVM_IRQ_LINE ioctl");
 }
 
-int ioport__setup_arch(struct kvm *kvm)
-{
-	return 0;
-}
-
 bool kvm__arch_cpu_supports_vm(void)
 {
 	return true;
diff --git a/powerpc/ioport.c b/powerpc/ioport.c
index 0c188b61..a5cff4ee 100644
--- a/powerpc/ioport.c
+++ b/powerpc/ioport.c
@@ -12,12 +12,6 @@
 
 #include <stdlib.h>
 
-int ioport__setup_arch(struct kvm *kvm)
-{
-	/* PPC has no legacy ioports to set up */
-	return 0;
-}
-
 void ioport__map_irq(u8 *irq)
 {
 }
diff --git a/x86/ioport.c b/x86/ioport.c
index 7ad7b8f3..a8d2bb1a 100644
--- a/x86/ioport.c
+++ b/x86/ioport.c
@@ -69,7 +69,7 @@ void ioport__map_irq(u8 *irq)
 {
 }
 
-int ioport__setup_arch(struct kvm *kvm)
+static int ioport__setup_arch(struct kvm *kvm)
 {
 	int r;
 
@@ -150,3 +150,4 @@ int ioport__setup_arch(struct kvm *kvm)
 
 	return 0;
 }
+dev_base_init(ioport__setup_arch);
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
