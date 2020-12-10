Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6EAC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08A3F23E23
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08A3F23E23
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A181C4B1E5;
	Thu, 10 Dec 2020 09:29:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RQ2J4OzA90jh; Thu, 10 Dec 2020 09:29:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0954B1E6;
	Thu, 10 Dec 2020 09:29:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A625D4B1A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AAjJJn-j8GGQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 09:29:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35B9E4B234
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:30 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC68E143B;
 Thu, 10 Dec 2020 06:29:29 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2F143F718;
 Thu, 10 Dec 2020 06:29:28 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 06/21] hw/i8042: Refactor trap handler
Date: Thu, 10 Dec 2020 14:28:53 +0000
Message-Id: <20201210142908.169597-7-andre.przywara@arm.com>
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

With the planned retirement of the special ioport emulation code, we
need to provide an emulation function compatible with the MMIO
prototype.

Adjust the trap handler to use that new function, and provide shims to
implement the old ioport interface, for now.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/i8042.c | 68 +++++++++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/hw/i8042.c b/hw/i8042.c
index 36ee183f..eb1f9d28 100644
--- a/hw/i8042.c
+++ b/hw/i8042.c
@@ -292,52 +292,52 @@ static void kbd_reset(void)
 	};
 }
 
-/*
- * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
- */
-static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+		   u8 is_write, void *ptr)
 {
-	switch (port) {
-	case I8042_COMMAND_REG: {
-		u8 value = kbd_read_status();
-		ioport__write8(data, value);
+	u8 value;
+
+	if (is_write)
+		value = ioport__read8(data);
+
+	switch (addr) {
+	case I8042_COMMAND_REG:
+		if (is_write)
+			kbd_write_command(vcpu->kvm, value);
+		else
+			value = kbd_read_status();
 		break;
-	}
-	case I8042_DATA_REG: {
-		u8 value = kbd_read_data();
-		ioport__write8(data, value);
+	case I8042_DATA_REG:
+		if (is_write)
+			kbd_write_data(value);
+		else
+			value = kbd_read_data();
 		break;
-	}
-	case I8042_PORT_B_REG: {
-		ioport__write8(data, 0x20);
+	case I8042_PORT_B_REG:
+		if (!is_write)
+			value = 0x20;
 		break;
-	}
 	default:
-		return false;
+		return;
 	}
 
+	if (!is_write)
+		ioport__write8(data, value);
+}
+
+/*
+ * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
+ */
+static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	kbd_io(vcpu, port, data, size, false, NULL);
+
 	return true;
 }
 
 static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
-	switch (port) {
-	case I8042_COMMAND_REG: {
-		u8 value = ioport__read8(data);
-		kbd_write_command(vcpu->kvm, value);
-		break;
-	}
-	case I8042_DATA_REG: {
-		u8 value = ioport__read8(data);
-		kbd_write_data(value);
-		break;
-	}
-	case I8042_PORT_B_REG: {
-		break;
-	}
-	default:
-		return false;
-	}
+	kbd_io(vcpu, port, data, size, true, NULL);
 
 	return true;
 }
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
