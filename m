Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B79AC433E6
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 911ED64F14
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 911ED64F14
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D644B2E7;
	Wed, 24 Feb 2021 20:00:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zgshFVRZNFI3; Wed, 24 Feb 2021 20:00:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 080BA4B2E0;
	Wed, 24 Feb 2021 20:00:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0714B26E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7dn8g5I4yN9l for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 20:00:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0684B1BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:38 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 933DF13A1;
 Wed, 24 Feb 2021 17:00:38 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48E003F73B;
 Wed, 24 Feb 2021 17:00:37 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v2 08/22] x86/ioport: Refactor trap handlers
Date: Thu, 25 Feb 2021 00:59:01 +0000
Message-Id: <20210225005915.26423-9-andre.przywara@arm.com>
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
need to provide emulation functions compatible with the MMIO
prototype.

Adjust the trap handlers to use that new function, and provide shims to
implement the old ioport interface, for now.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 x86/ioport.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/x86/ioport.c b/x86/ioport.c
index a8d2bb1a..78f9a863 100644
--- a/x86/ioport.c
+++ b/x86/ioport.c
@@ -3,8 +3,14 @@
 #include <stdlib.h>
 #include <stdio.h>
 
+static void dummy_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+		       u8 is_write, void *ptr)
+{
+}
+
 static bool debug_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
+	dummy_mmio(vcpu, port, data, size, true, NULL);
 	return 0;
 }
 
@@ -12,15 +18,23 @@ static struct ioport_operations debug_ops = {
 	.io_out		= debug_io_out,
 };
 
-static bool seabios_debug_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void seabios_debug_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+			       u32 len, u8 is_write, void *ptr)
 {
 	char ch;
 
+	if (!is_write)
+		return;
+
 	ch = ioport__read8(data);
 
 	putchar(ch);
+}
 
-	return true;
+static bool seabios_debug_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	seabios_debug_mmio(vcpu, port, data, size, true, NULL);
+	return 0;
 }
 
 static struct ioport_operations seabios_debug_ops = {
@@ -29,11 +43,13 @@ static struct ioport_operations seabios_debug_ops = {
 
 static bool dummy_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
+	dummy_mmio(vcpu, port, data, size, false, NULL);
 	return true;
 }
 
 static bool dummy_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
+	dummy_mmio(vcpu, port, data, size, true, NULL);
 	return true;
 }
 
@@ -50,13 +66,19 @@ static struct ioport_operations dummy_write_only_ioport_ops = {
  * The "fast A20 gate"
  */
 
-static bool ps2_control_a_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void ps2_control_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+			     u8 is_write, void *ptr)
 {
 	/*
 	 * A20 is always enabled.
 	 */
-	ioport__write8(data, 0x02);
+	if (!is_write)
+		ioport__write8(data, 0x02);
+}
 
+static bool ps2_control_a_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	ps2_control_mmio(vcpu, port, data, size, false, NULL);
 	return true;
 }
 
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
