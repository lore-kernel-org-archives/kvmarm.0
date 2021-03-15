Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E774C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDDBA64E77
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 15:34:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDDBA64E77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 729D84B5EE;
	Mon, 15 Mar 2021 11:34:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id inUSIWYE4hbw; Mon, 15 Mar 2021 11:34:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E08D74B638;
	Mon, 15 Mar 2021 11:34:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5134B51B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VnPPnh5hj8Qk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 11:34:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CDA74B5CE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 11:34:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C27E6106F;
 Mon, 15 Mar 2021 08:34:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B6A23F792;
 Mon, 15 Mar 2021 08:34:25 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v3 10/22] hw/rtc: Refactor trap handlers
Date: Mon, 15 Mar 2021 15:33:38 +0000
Message-Id: <20210315153350.19988-11-andre.przywara@arm.com>
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

With the planned retirement of the special ioport emulation code, we
need to provide emulation functions compatible with the MMIO prototype.

Merge the two different trap handlers into one function, checking for
read/write and data/index register inside.
Adjust the trap handlers to use that new function, and provide shims to
implement the old ioport interface, for now.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/rtc.c | 70 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/hw/rtc.c b/hw/rtc.c
index 5483879f..664d4cb0 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -42,11 +42,37 @@ static inline unsigned char bin2bcd(unsigned val)
 	return ((val / 10) << 4) + val % 10;
 }
 
-static bool cmos_ram_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+			u32 len, u8 is_write, void *ptr)
 {
 	struct tm *tm;
 	time_t ti;
 
+	if (is_write) {
+		if (addr == 0x70) {	/* index register */
+			u8 value = ioport__read8(data);
+
+			vcpu->kvm->nmi_disabled	= value & (1UL << 7);
+			rtc.cmos_idx		= value & ~(1UL << 7);
+
+			return;
+		}
+
+		switch (rtc.cmos_idx) {
+		case RTC_REG_C:
+		case RTC_REG_D:
+			/* Read-only */
+			break;
+		default:
+			rtc.cmos_data[rtc.cmos_idx] = ioport__read8(data);
+			break;
+		}
+		return;
+	}
+
+	if (addr == 0x70)
+		return;
+
 	time(&ti);
 
 	tm = gmtime(&ti);
@@ -92,42 +118,23 @@ static bool cmos_ram_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 po
 		ioport__write8(data, rtc.cmos_data[rtc.cmos_idx]);
 		break;
 	}
-
-	return true;
 }
 
-static bool cmos_ram_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool cmos_ram_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
-	switch (rtc.cmos_idx) {
-	case RTC_REG_C:
-	case RTC_REG_D:
-		/* Read-only */
-		break;
-	default:
-		rtc.cmos_data[rtc.cmos_idx] = ioport__read8(data);
-		break;
-	}
-
+	cmos_ram_io(vcpu, port, data, size, false, NULL);
 	return true;
 }
 
-static struct ioport_operations cmos_ram_data_ioport_ops = {
-	.io_out		= cmos_ram_data_out,
-	.io_in		= cmos_ram_data_in,
-};
-
-static bool cmos_ram_index_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool cmos_ram_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
-	u8 value = ioport__read8(data);
-
-	vcpu->kvm->nmi_disabled	= value & (1UL << 7);
-	rtc.cmos_idx		= value & ~(1UL << 7);
-
+	cmos_ram_io(vcpu, port, data, size, true, NULL);
 	return true;
 }
 
-static struct ioport_operations cmos_ram_index_ioport_ops = {
-	.io_out		= cmos_ram_index_out,
+static struct ioport_operations cmos_ram_ioport_ops = {
+	.io_out		= cmos_ram_out,
+	.io_in		= cmos_ram_in,
 };
 
 #ifdef CONFIG_HAS_LIBFDT
@@ -162,21 +169,15 @@ int rtc__init(struct kvm *kvm)
 		return r;
 
 	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
-	r = ioport__register(kvm, 0x0070, &cmos_ram_index_ioport_ops, 1, NULL);
+	r = ioport__register(kvm, 0x0070, &cmos_ram_ioport_ops, 2, NULL);
 	if (r < 0)
 		goto out_device;
 
-	r = ioport__register(kvm, 0x0071, &cmos_ram_data_ioport_ops, 1, NULL);
-	if (r < 0)
-		goto out_ioport;
-
 	/* Set the VRT bit in Register D to indicate valid RAM and time */
 	rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
 
 	return r;
 
-out_ioport:
-	ioport__unregister(kvm, 0x0070);
 out_device:
 	device__unregister(&rtc_dev_hdr);
 
@@ -188,7 +189,6 @@ int rtc__exit(struct kvm *kvm)
 {
 	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
 	ioport__unregister(kvm, 0x0070);
-	ioport__unregister(kvm, 0x0071);
 
 	return 0;
 }
-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
