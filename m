Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCC8C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8681C23D9D
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8681C23D9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 217624B228;
	Thu, 10 Dec 2020 09:29:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gl-xIrW4aPrd; Thu, 10 Dec 2020 09:29:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 903CB4B219;
	Thu, 10 Dec 2020 09:29:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2FE04B190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nU-PYD4Hw3QP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 09:29:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBED94B1D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FD451435;
 Thu, 10 Dec 2020 06:29:28 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8638C3F718;
 Thu, 10 Dec 2020 06:29:27 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 05/21] hw/i8042: Clean up data types
Date: Thu, 10 Dec 2020 14:28:52 +0000
Message-Id: <20201210142908.169597-6-andre.przywara@arm.com>
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

The i8042 is clearly an 8-bit era device, so there is little room for
32-bit registers.
Clean up the data types used.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/i8042.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/hw/i8042.c b/hw/i8042.c
index 37a99a2d..36ee183f 100644
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
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
