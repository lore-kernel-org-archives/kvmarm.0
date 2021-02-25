Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30ECC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8217864F0D
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8217864F0D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5B94B297;
	Wed, 24 Feb 2021 20:00:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jhMaI-3rNzAw; Wed, 24 Feb 2021 20:00:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81AC44B2C1;
	Wed, 24 Feb 2021 20:00:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C8774B297
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1NE9F5z0P5SQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 20:00:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 400C34B2BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA47A11FB;
 Wed, 24 Feb 2021 17:00:33 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FA163F73B;
 Wed, 24 Feb 2021 17:00:32 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v2 05/22] hw/i8042: Clean up data types
Date: Thu, 25 Feb 2021 00:58:58 +0000
Message-Id: <20210225005915.26423-6-andre.przywara@arm.com>
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

The i8042 is clearly an 8-bit era device, so there is little room for
32-bit registers.
Clean up the data types used.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/i8042.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/hw/i8042.c b/hw/i8042.c
index 37a99a2d..7d1f9772 100644
--- a/hw/i8042.c
+++ b/hw/i8042.c
@@ -64,11 +64,11 @@
 struct kbd_state {
 	struct kvm		*kvm;
 
-	char			kq[QUEUE_SIZE];	/* Keyboard queue */
+	u8			kq[QUEUE_SIZE];	/* Keyboard queue */
 	int			kread, kwrite;	/* Indexes into the queue */
 	int			kcount;		/* number of elements in queue */
 
-	char			mq[QUEUE_SIZE];
+	u8			mq[QUEUE_SIZE];
 	int			mread, mwrite;
 	int			mcount;
 
@@ -82,7 +82,7 @@ struct kbd_state {
 	 * Some commands (on port 0x64) have arguments;
 	 * we store the command here while we wait for the argument
 	 */
-	u32			write_cmd;
+	u8			write_cmd;
 };
 
 static struct kbd_state		state;
@@ -173,9 +173,9 @@ static void kbd_write_command(struct kvm *kvm, u8 val)
 /*
  * Called when the OS reads from port 0x60 (PS/2 data)
  */
-static u32 kbd_read_data(void)
+static u8 kbd_read_data(void)
 {
-	u32 ret;
+	u8 ret;
 	int i;
 
 	if (state.kcount != 0) {
@@ -202,9 +202,9 @@ static u32 kbd_read_data(void)
 /*
  * Called when the OS read from port 0x64, the command port
  */
-static u32 kbd_read_status(void)
+static u8 kbd_read_status(void)
 {
-	return (u32)state.status;
+	return state.status;
 }
 
 /*
@@ -212,7 +212,7 @@ static u32 kbd_read_status(void)
  * Things written here are generally arguments to commands previously
  * written to port 0x64 and stored in state.write_cmd
  */
-static void kbd_write_data(u32 val)
+static void kbd_write_data(u8 val)
 {
 	switch (state.write_cmd) {
 	case I8042_CMD_CTL_WCTR:
@@ -266,8 +266,8 @@ static void kbd_write_data(u32 val)
 			break;
 		default:
 			break;
-	}
-	break;
+		}
+		break;
 	case 0:
 		/* Just send the ID */
 		kbd_queue(RESPONSE_ACK);
@@ -304,8 +304,8 @@ static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *
 		break;
 	}
 	case I8042_DATA_REG: {
-		u32 value = kbd_read_data();
-		ioport__write32(data, value);
+		u8 value = kbd_read_data();
+		ioport__write8(data, value);
 		break;
 	}
 	case I8042_PORT_B_REG: {
@@ -328,7 +328,7 @@ static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void
 		break;
 	}
 	case I8042_DATA_REG: {
-		u32 value = ioport__read32(data);
+		u8 value = ioport__read8(data);
 		kbd_write_data(value);
 		break;
 	}
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
