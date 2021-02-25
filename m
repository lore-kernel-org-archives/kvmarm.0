Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298DBC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F3F764F10
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F3F764F10
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B8494B2C7;
	Wed, 24 Feb 2021 20:00:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x0mwMPjoThDY; Wed, 24 Feb 2021 20:00:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D3954B29D;
	Wed, 24 Feb 2021 20:00:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 344C94B272
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RzYd8jeQcIJ3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 20:00:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB944B297
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFAF1101E;
 Wed, 24 Feb 2021 17:00:27 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 650B13F73B;
 Wed, 24 Feb 2021 17:00:26 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v2 01/22] ioport: Remove ioport__setup_arch()
Date: Thu, 25 Feb 2021 00:58:54 +0000
Message-Id: <20210225005915.26423-2-andre.przywara@arm.com>
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

Since x86 had a special need for registering tons of special I/O ports,
we had an ioport__setup_arch() callback, to allow each architecture
to do the same. As it turns out no one uses it beside x86, so we remove
that unnecessary abstraction.

The generic function was registered via a device_base_init() call, so
we just do the same for the x86 specific function only, and can remove
the unneeded ioport__setup_arch().

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
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
