Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648773;
	b=qsBFIOkwg68+kw0WxO2n9v9vUXd8OlPonL6+8w9TJY2tt/wkaNkhHW71hNDiuWszLwcr
	 8xkMYGB+BZ7cLQWd561j5UxgelxvL6qvoRXbGXV+JWd5+0T4eq5X8K2iJ2virOXWJlCHD
	 Gs6HgrcaJPpLL6EEm7KSrDjzh4wEolcxClkBcRrImRTZGqCSbGYT3LhynpOT4zZSh6xGr
	 kdm6fGBwBWxSu5u+8vBbXqMIIjq2n4T6XtUl5jvF7GLzf8S9mV6CO2rpnjghE2mmmDrP0
	 I9EYA8D/O9jzF20qiHJqhwt7GlD9tu9lM3P0UuqmG+RFhouECfLe216/ILvlB5MIfog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648773;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZGOjsSCVHGcF0aQsWKOcJSPUc6jEFxBTw+lbJBogpMQ=;
	b=xIn9ATk6UfCl7UkungZB7/jIEbMH7LWxSOgRnvP2m8FACV+ZTnKfUY/HhuLo6R6aINK9
	 K5rxMVaHFNR40mLtJebr1zkBvr9uifN0GdMWJdaH/CODWZAZnlCq9BG1POtm1X5AbooTN
	 TiHzrQ+lW1uxAHTwpwLN/ydWzJ/xWwbkXtItQVtzJcyi843DHbjGjhhizxe30fthruYv2
	 zg3ah0ACuvat6PobbiOMEF7KUK1WBfmtqsyBlR0bdFgAWtOghxIyEizJktdWmdyIUEPSE
	 mdkr9vClw+GnKSxLOTgsrObmaLfs/ySKT8jhcegVLcBvASdrKwUyQY7zpbtR+MNtsYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="Y8U4/30g";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D268606D81C
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:46:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D268606D81C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y8U4/30g
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 141F4175D;
	Mon,  2 Nov 2026 11:46:09 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E7AA3F871;
	Mon,  2 Nov 2026 11:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648772; bh=ETROQhNM1XfSjo8+txzNPj6SILluSxFHA4bsy044qeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8U4/30g73Xgw7j6zIa1mCTa9EL9SJWyWgjolNd6hXZcDVZXhtLzSeACj0nYh4ViA
	 jfo2a49mwCrgLPta+uIiR6GLItTniob1XGFO6Qy4oInYgWDcq6Wl/hDtjBYp2h/rAL
	 7kDdiSmwEEl1BAdsnLi24QnZWjkfDnN3ZmpaurGM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH v2 15/16] KVM: selftests: Add VGICv5 ITS translation cache tests
Date: Mon,  2 Nov 2026 19:44:53 +0000
Message-Id: <20261102194454.4086911-16-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102194454.4086911-1-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add end-to-end coverage for VGICv5 ITS translation and cache
invalidation. The ITS attribute test only checks the userspace API
surface; this test verifies that KVM can parse guest-provided linear
DT and ITT state and use it to deliver LPIs through guest GEN_EVENTR
and KVM_SIGNAL_MSI.

Build a two-VPE VM with IRS, ITS and an LPI IST. VPE0 programs a
linear device table and interrupt translation table, enables the
virtual ITS, enables two LPIs targeting VPE1, and sends GEN_EVENTR to
populate the translation cache with EventID to LPI A. VPE1 reports the
LPI identity it consumed.

VPE0 then rewrites the ITT to point at LPI B without invalidation, and
a host KVM_SIGNAL_MSI injection verifies that the stale cached LPI A
translation is reused. VPE0 invalidates the event with ITS_INV_EVENTR
and the host verifies that LPI B is delivered.

VPE0 then rewrites the ITT back to LPI A, invalidates the device with
ITS_INV_DEVICER, and the host verifies that LPI A is delivered again.
This exercises the guest-side event and device invalidation paths
rather than invalidating translations directly from the test host.

Also cover negative MSI paths by checking that KVM_SIGNAL_MSI rejects a
message without KVM_MSI_VALID_DEVID and rejects a message whose address
does not target the GICv5 ITS. Finally, inject once before guest-side
ITS disable to prove delivery still works, then have VPE0 disable the
ITS and verify that a cached KVM_SIGNAL_MSI delivery is rejected with
ENXIO.

Check 32-bit accesses to both halves of DT_BASER and preservation of
the untouched half. Verify that guest writes to the ITS ID registers
and READ_EVENT_DATAR are ignored, and that READ_EVENT_DATAR can be read
at both 32-bit and 64-bit widths.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 518 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  17 +
 2 files changed, 532 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
index 92da9753ce8e6..a9b0bca24ec08 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -18,6 +18,7 @@
 #define VGIC_V5_SPARSE_VCPU0_ID	17
 #define VGIC_V5_SPARSE_VCPU1_ID	3
 #define VGIC_V5_LPI_MEMSLOT	1
+#define VGIC_V5_ITS_TABLE_MEMSLOT	2
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(10)
@@ -25,8 +26,19 @@
 #define VGIC_V5_IRS_WAIT_RETRIES	1000000
 #define VGIC_V5_LPI_IST_BASE_GPA	(GICV5_IRS_CONFIG_BASE_GPA + VGIC_V5_IRS_SIZE)
 #define VGIC_V5_LPI_IST_SIZE		0x10000
+/* A linear DT with 17 DeviceID bits needs 1 MiB of aligned storage. */
+#define VGIC_V5_ITS_DT_BASE_GPA		0x8100000ULL
+#define VGIC_V5_ITS_ITT_BASE_GPA	(VGIC_V5_ITS_DT_BASE_GPA + 0x100000)
+#define VGIC_V5_ITS_TABLE_SIZE		0x110000
 #define LPI_TEST_TO_VPE1		0
 #define LPI_TEST_TO_VPE0		1
+#define ITS_TEST_DEVICE_ID		5
+#define ITS_TEST_OVERWIDE_DEVICE_ID	BIT(16)
+#define ITS_TEST_EVENT_ID		3
+#define ITS_TEST_LPI_A			2
+#define ITS_TEST_LPI_B			3
+#define ITS_TEST_DEVICE_ID_BITS		17
+#define ITS_TEST_EVENT_ID_BITS		4
 #define RESTORE_TEST_LPI_PENDING		0
 #define RESTORE_TEST_LPI_ENABLED		1
 #define RESTORE_TEST_SPI_PRIO_HIGH		0
@@ -56,6 +68,13 @@ struct vm_gic {
 #define GUEST_CMD_IST_SOURCE_READY	16
 #define GUEST_CMD_IST_SPI_INJECT_READY	17
 #define GUEST_CMD_IST_LPI_INJECT_READY	18
+#define GUEST_CMD_ITS_READY		19
+#define GUEST_CMD_ITS_LPI_DELIVERED	20
+#define GUEST_CMD_ITS_GEN_EVENT_SENT	21
+#define GUEST_CMD_ITS_ITT_REWRITTEN	22
+#define GUEST_CMD_ITS_EVENT_INVALIDATED	23
+#define GUEST_CMD_ITS_DEVICE_INVALIDATED	24
+#define GUEST_CMD_ITS_DISABLED		25
 
 static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_size,
 					       void *lpi_ist, size_t lpi_size)
@@ -71,6 +90,7 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_size,
 static u32 spi_line_expected;
 static bool spi_line_level_sensitive;
 static bool lpi_ist_ready;
+static u32 its_expected_lpi;
 static u32 ist_restore_irq_count[VGIC_V5_LPI_NR_VCPUS];
 
 static u64 gicv5_hwirq(u32 type, u32 intid)
@@ -222,6 +242,199 @@ static void gicv5_configure_lpi_ist(void)
 			      GICV5_IRS_IST_BASER), val);
 }
 
+/* We only use a single DeviceID and hence only have a single ITT */
+static void gicv5_write_its_itte(u32 event_id, u32 lpi)
+{
+	u64 val;
+
+	val = FIELD_PREP(GICV5_ITTL2E_LPI_ID, lpi) | GICV5_ITTL2E_VALID;
+	WRITE_ONCE(*(u64 *)(VGIC_V5_ITS_ITT_BASE_GPA +
+			    event_id * sizeof(u64)), val);
+}
+
+/*
+ * Set up the ITS "tables". Point the DTE to the ITT and make valid. Then set up
+ * the translation in the ITT. We are cheating a bit here, and have the most
+ * simplistic table setup possible. A linear DT with two DeviceIDs pointing
+ * to the same linear ITT; the second ID exceeds the advertised width.
+ */
+static void gicv5_configure_its_tables(u32 lpi)
+{
+	u64 val;
+
+	val = FIELD_PREP(GICV5_DTL2E_ITT_ADDR_MASK,
+			 VGIC_V5_ITS_ITT_BASE_GPA >> GICV5_ITS_DT_BASER_ADDR_SHIFT) |
+	      FIELD_PREP(GICV5_DTL2E_EVENT_ID_BITS, ITS_TEST_EVENT_ID_BITS) |
+	      GICV5_DTL2E_VALID;
+	WRITE_ONCE(*(u64 *)(VGIC_V5_ITS_DT_BASE_GPA +
+			    ITS_TEST_DEVICE_ID * sizeof(u64)), val);
+	WRITE_ONCE(*(u64 *)(VGIC_V5_ITS_DT_BASE_GPA +
+			    ITS_TEST_OVERWIDE_DEVICE_ID * sizeof(u64)), val);
+
+	gicv5_write_its_itte(ITS_TEST_EVENT_ID, lpi);
+}
+
+/* Set ITS_DT_CFGR, ITS_DT_BASER, and enable the ITS */
+static void gicv5_configure_its(void)
+{
+	u64 val;
+	u64 test_baser;
+	u32 idr0, lower, upper;
+
+	idr0 = readl(GICV5_ITS_BASE_GVA + GICV5_ITS_IDR0);
+	writel(idr0 ^ GICV5_ITS_IDR0_SWE, GICV5_ITS_BASE_GVA + GICV5_ITS_IDR0);
+	GUEST_ASSERT_EQ(readl(GICV5_ITS_BASE_GVA + GICV5_ITS_IDR0), idr0);
+
+	/* A 32-bit write must leave the other half of DT_BASER intact. */
+	test_baser = BIT_ULL(40) | BIT_ULL(16);
+	writeq(test_baser, GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER);
+	lower = BIT(24);
+	writel(lower, GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER);
+	GUEST_ASSERT_EQ(readq(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER),
+			(BIT_ULL(40) | lower));
+	upper = BIT(20);
+	writel(upper, GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER + 4);
+	GUEST_ASSERT_EQ(readq(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER),
+			(((u64)upper << 32) | lower));
+	GUEST_ASSERT_EQ(readl(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER), lower);
+	GUEST_ASSERT_EQ(readl(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER + 4),
+			upper);
+
+	val = FIELD_PREP(GICV5_ITS_DT_BASER_ADDR_MASK,
+			 VGIC_V5_ITS_DT_BASE_GPA >> GICV5_ITS_DT_BASER_ADDR_SHIFT);
+	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER);
+
+	val = FIELD_PREP(GICV5_ITS_DT_CFGR_DEVICEID_BITS,
+			 ITS_TEST_DEVICE_ID_BITS);
+	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DT_CFGR);
+
+	writel(GICV5_ITS_CR0_ITSEN, GICV5_ITS_BASE_GVA + GICV5_ITS_CR0);
+	GUEST_ASSERT(readl(GICV5_ITS_BASE_GVA + GICV5_ITS_CR0) & GICV5_ITS_CR0_ITSEN);
+}
+
+/*
+ * The DT registers are read-only to the guest while the ITS is enabled. Write
+ * modified versions of the current values and check that the writes are
+ * ignored. Avoid literal zero here: the arm64 selftest MMIO helpers allow a
+ * zero-immediate operand, but a store instruction needs a register operand.
+ */
+static void gicv5_check_enabled_its_dt_regs_ro(void)
+{
+	const u64 dt_baser = readq(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER);
+	const u32 dt_cfgr = readl(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_CFGR);
+	const u64 new_dt_baser = dt_baser ^ BIT_ULL(16);
+	const u32 new_dt_cfgr = dt_cfgr ^ BIT(0);
+
+	writeq(new_dt_baser, GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER);
+	writel((u32)(dt_baser >> 32) ^ BIT(0),
+	       GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER + 4);
+	writel(new_dt_cfgr, GICV5_ITS_BASE_GVA + GICV5_ITS_DT_CFGR);
+
+	GUEST_ASSERT_EQ(readq(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_BASER),
+			dt_baser);
+	GUEST_ASSERT_EQ(readl(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_CFGR),
+			dt_cfgr);
+}
+
+/*
+ * Read out the Event Data from ITS_READ_EVENT_DATAR and check it to ensure the
+ * expected translation is returned.
+ */
+static void gicv5_check_its_read_event(u32 device_id, u32 event_id, u32 lpi)
+{
+	u64 val;
+	u32 new_datar;
+
+	val = FIELD_PREP(GICV5_ITS_DIDR_DEVICEID, device_id);
+	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DIDR);
+
+	val = FIELD_PREP(GICV5_ITS_EIDR_EVENTID, event_id);
+	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_EIDR);
+
+	writel(GICV5_ITS_READ_EVENTR_R,
+	       GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENTR);
+
+	val = readq(GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENT_DATAR);
+	GUEST_ASSERT(val & GICV5_ITS_READ_EVENT_DATAR_VALID);
+	GUEST_ASSERT_EQ(FIELD_GET(GICV5_ITS_READ_EVENT_DATAR_LPI_ID, val),
+			lpi);
+	/* The result register remains read-only to the guest at either width. */
+	new_datar = (u32)val ^ BIT(0);
+	writel(new_datar, GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENT_DATAR);
+	writel((u32)(val >> 32) ^ BIT(0),
+	       GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENT_DATAR + 4);
+	writeq(val ^ BIT_ULL(0), GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENT_DATAR);
+	GUEST_ASSERT_EQ(readq(GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENT_DATAR),
+			val);
+	GUEST_ASSERT_EQ(readl(GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENT_DATAR),
+			(u32)val);
+	GUEST_ASSERT_EQ(readl(GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENT_DATAR + 4),
+			(u32)(val >> 32));
+}
+
+static void gicv5_check_its_deviceid_cap(void)
+{
+	u32 idr1 = readl(GICV5_ITS_BASE_GVA + GICV5_ITS_IDR1);
+	u32 dt_cfgr = readl(GICV5_ITS_BASE_GVA + GICV5_ITS_DT_CFGR);
+	u64 val;
+
+	GUEST_ASSERT_EQ(FIELD_GET(GICV5_ITS_IDR1_DEVICEID_BITS, idr1),
+			ITS_TEST_DEVICE_ID_BITS - 1);
+	GUEST_ASSERT_EQ(FIELD_GET(GICV5_ITS_DT_CFGR_DEVICEID_BITS, dt_cfgr),
+			ITS_TEST_DEVICE_ID_BITS);
+
+	writeq(ITS_TEST_OVERWIDE_DEVICE_ID,
+	       GICV5_ITS_BASE_GVA + GICV5_ITS_DIDR);
+	writel(ITS_TEST_EVENT_ID, GICV5_ITS_BASE_GVA + GICV5_ITS_EIDR);
+	writel(GICV5_ITS_READ_EVENTR_R,
+	       GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENTR);
+
+	val = readq(GICV5_ITS_BASE_GVA + GICV5_ITS_READ_EVENT_DATAR);
+	GUEST_ASSERT(!(val & GICV5_ITS_READ_EVENT_DATAR_VALID));
+}
+
+/* Inject a manually triggered translation via the ITS_GEN_EVENTR */
+static void gicv5_send_its_gen_event(u32 device_id, u32 event_id)
+{
+	u64 val;
+
+	val = FIELD_PREP(GICV5_ITS_GEN_EVENT_DIDR_DEVICEID, device_id);
+	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENT_DIDR);
+
+	val = FIELD_PREP(GICV5_ITS_GEN_EVENT_EIDR_EVENTID, event_id);
+	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENT_EIDR);
+
+	writel(GICV5_ITS_GEN_EVENTR_R |
+	       FIELD_PREP(GICV5_ITS_GEN_EVENTR_TARGET_DOMAIN, 0),
+	       GICV5_ITS_BASE_GVA + GICV5_ITS_GEN_EVENTR);
+}
+
+static void gicv5_invalidate_its_event(u32 device_id, u32 event_id)
+{
+	u64 val;
+
+	val = FIELD_PREP(GICV5_ITS_DIDR_DEVICEID, device_id);
+	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DIDR);
+
+	val = FIELD_PREP(GICV5_ITS_EIDR_EVENTID, event_id);
+	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_EIDR);
+
+	writel(GICV5_ITS_INV_EVENTR_I,
+	       GICV5_ITS_BASE_GVA + GICV5_ITS_INV_EVENTR);
+}
+
+static void gicv5_invalidate_its_device(u32 device_id, u32 event_id_bits)
+{
+	u64 val;
+
+	val = FIELD_PREP(GICV5_ITS_DIDR_DEVICEID, device_id);
+	writeq(val, GICV5_ITS_BASE_GVA + GICV5_ITS_DIDR);
+
+	val = GICV5_ITS_INV_DEVICER_I |
+	      FIELD_PREP(GICV5_ITS_INV_DEVICER_EVENTID_BITS, event_id_bits);
+	writel(val, GICV5_ITS_BASE_GVA + GICV5_ITS_INV_DEVICER);
+}
+
 static void gicv5_enable_irs(void)
 {
 	writel(GICV5_IRS_CR0_IRSEN,
@@ -417,6 +630,81 @@ static void guest_lpi_code(void)
 		wfi();
 }
 
+static void guest_its_irq_handler(struct ex_regs *regs)
+{
+	u64 expected_hwirq = gicv5_lpi_hwirq(READ_ONCE(its_expected_lpi));
+	u32 hwirq;
+	u64 ia;
+
+	ia = gicr_insn(CDIA);
+	if (!GICV5_GICR_CDIA_VALID(ia))
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq = FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_SYNC(GUEST_CMD_ITS_LPI_DELIVERED);
+}
+
+static void guest_its_code(void)
+{
+	local_irq_disable();
+
+	if (!guest_get_vcpuid()) { /* VCPU0 */
+		gicv5_enable_irs();
+		gicv5_configure_lpi_ist();
+		gicv5_enable_lpi(ITS_TEST_LPI_A, 1);
+		gicv5_enable_lpi(ITS_TEST_LPI_B, 1);
+		gicv5_configure_its_tables(ITS_TEST_LPI_A);
+		gicv5_configure_its();
+		gicv5_check_enabled_its_dt_regs_ro();
+		gicv5_check_its_read_event(ITS_TEST_DEVICE_ID,
+					   ITS_TEST_EVENT_ID,
+					   ITS_TEST_LPI_A);
+		gicv5_check_its_deviceid_cap();
+		WRITE_ONCE(lpi_ist_ready, true);
+
+		GUEST_SYNC(GUEST_CMD_ITS_READY);
+
+		gicv5_send_its_gen_event(ITS_TEST_DEVICE_ID,
+					 ITS_TEST_EVENT_ID);
+
+		GUEST_SYNC(GUEST_CMD_ITS_GEN_EVENT_SENT);
+
+		gicv5_write_its_itte(ITS_TEST_EVENT_ID, ITS_TEST_LPI_B);
+		GUEST_SYNC(GUEST_CMD_ITS_ITT_REWRITTEN);
+
+		gicv5_invalidate_its_event(ITS_TEST_DEVICE_ID,
+					   ITS_TEST_EVENT_ID);
+		GUEST_SYNC(GUEST_CMD_ITS_EVENT_INVALIDATED);
+
+		gicv5_write_its_itte(ITS_TEST_EVENT_ID, ITS_TEST_LPI_A);
+		gicv5_invalidate_its_device(ITS_TEST_DEVICE_ID,
+					    ITS_TEST_EVENT_ID_BITS);
+		GUEST_SYNC(GUEST_CMD_ITS_DEVICE_INVALIDATED);
+
+		writel(0, GICV5_ITS_BASE_GVA + GICV5_ITS_CR0);
+		GUEST_ASSERT(!(readl(GICV5_ITS_BASE_GVA + GICV5_ITS_CR0) &
+			       GICV5_ITS_CR0_ITSEN));
+		GUEST_SYNC(GUEST_CMD_ITS_DISABLED);
+	} else { /* VCPU1 */
+		GUEST_ASSERT(READ_ONCE(lpi_ist_ready));
+		gicv5_cpu_enable_interrupts();
+		local_irq_enable();
+
+		GUEST_SYNC(GUEST_CMD_ITS_READY);
+	}
+
+	while (1)
+		wfi();
+}
+
 static void restore_test_setup_hwirq(u64 hwirq, u32 target_vpe,
 				     u32 priority, bool enable)
 {
@@ -610,6 +898,29 @@ static void vgic_v5_map_irs(struct kvm_vm *vm)
 		 GICV5_IRS_CONFIG_BASE_GPA, nr_irs_pages);
 }
 
+static void vgic_v5_map_its(struct kvm_vm *vm)
+{
+	unsigned int nr_its_pages;
+
+	nr_its_pages = vm_calc_num_guest_pages(vm->mode, GICV5_ITS_SIZE);
+
+	/* Map the ITS at VA == IPA so guest MMIO writes hit the ITS IODEV. */
+	virt_map(vm, GICV5_ITS_BASE_GPA, GICV5_ITS_BASE_GPA, nr_its_pages);
+}
+
+static void vgic_v5_add_its_table_mem(struct kvm_vm *vm)
+{
+	unsigned int nr_pages;
+
+	nr_pages = vm_calc_num_guest_pages(vm->mode, VGIC_V5_ITS_TABLE_SIZE);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    VGIC_V5_ITS_DT_BASE_GPA,
+				    VGIC_V5_ITS_TABLE_MEMSLOT,
+				    nr_pages, 0);
+	virt_map(vm, VGIC_V5_ITS_DT_BASE_GPA, VGIC_V5_ITS_DT_BASE_GPA,
+		 nr_pages);
+}
+
 static u32 vgic_v5_irq_line_payload(u32 type, u32 num)
 {
 	return (type << KVM_ARM_IRQ_TYPE_SHIFT) |
@@ -660,7 +971,8 @@ static void vgic_v5_spi_line_vm_create(struct vm_gic *v,
 static void vgic_v5_lpi_ist_vm_create(struct vm_gic *v,
 				      struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS],
 				      void (*guest_code)(void),
-				      void (*irq_handler)(struct ex_regs *))
+				      void (*irq_handler)(struct ex_regs *),
+				      bool with_its)
 {
 	unsigned int nr_lpi_ist_pages;
 	u64 attr;
@@ -669,6 +981,9 @@ static void vgic_v5_lpi_ist_vm_create(struct vm_gic *v,
 	vm_gic_init(v);
 	v->vm = __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_LPI_NR_VCPUS, 0);
 	v->gic_fd = kvm_create_device(v->vm, v->gic_dev_type);
+	if (with_its)
+		v->its_fd = kvm_create_device(v->vm,
+					      KVM_DEV_TYPE_ARM_VGIC_V5_ITS);
 
 	for (i = 0; i < VGIC_V5_LPI_NR_VCPUS; i++) {
 		vcpus[i] = vm_vcpu_add(v->vm, i, guest_code);
@@ -687,6 +1002,16 @@ static void vgic_v5_lpi_ist_vm_create(struct vm_gic *v,
 			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
 	vgic_v5_map_irs(v->vm);
 
+	if (with_its) {
+		attr = GICV5_ITS_BASE_GPA;
+		kvm_device_attr_set(v->its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS, &attr);
+		kvm_device_attr_set(v->its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+		vgic_v5_map_its(v->vm);
+		vgic_v5_add_its_table_mem(v->vm);
+	}
+
 	nr_lpi_ist_pages = vm_calc_num_guest_pages(v->vm->mode,
 						   VGIC_V5_LPI_IST_SIZE);
 	vm_userspace_mem_region_add(v->vm, VM_MEM_SRC_ANONYMOUS,
@@ -708,7 +1033,14 @@ static void vgic_v5_lpi_vm_create(struct vm_gic *v,
 				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
 {
 	vgic_v5_lpi_ist_vm_create(v, vcpus, guest_lpi_code,
-				  guest_lpi_irq_handler);
+				  guest_lpi_irq_handler, false);
+}
+
+static void vgic_v5_its_vm_create(struct vm_gic *v,
+				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
+{
+	vgic_v5_lpi_ist_vm_create(v, vcpus, guest_its_code,
+				  guest_its_irq_handler, true);
 }
 
 static void vgic_v5_ist_restore_vm_create(struct vm_gic *v,
@@ -716,7 +1048,7 @@ static void vgic_v5_ist_restore_vm_create(struct vm_gic *v,
 					  void (*guest_code)(void),
 					  void (*irq_handler)(struct ex_regs *))
 {
-	vgic_v5_lpi_ist_vm_create(v, vcpus, guest_code, irq_handler);
+	vgic_v5_lpi_ist_vm_create(v, vcpus, guest_code, irq_handler, false);
 }
 
 static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
@@ -2312,6 +2644,183 @@ static void test_vgic_v5_ist_save_restore(void)
 	vm_gic_destroy(&dst);
 }
 
+static int __vgic_v5_signal_msi(struct kvm_vm *vm, u64 address,
+				u32 device_id, u32 event_id, u32 flags)
+{
+	struct kvm_msi msi = {
+		.address_lo	= address,
+		.address_hi	= address >> 32,
+		.data		= event_id,
+		.devid		= device_id,
+		.flags		= flags,
+	};
+
+	return __vm_ioctl(vm, KVM_SIGNAL_MSI, &msi);
+}
+
+static void vgic_v5_signal_msi(struct kvm_vm *vm, u32 device_id,
+			       u32 event_id)
+{
+	u64 addr = GICV5_ITS_BASE_GPA + GICV5_ITS_TRANSLATER;
+	int ret;
+
+	ret = __vgic_v5_signal_msi(vm, addr, device_id, event_id,
+				   KVM_MSI_VALID_DEVID);
+	TEST_ASSERT(ret == 1, "KVM_SIGNAL_MSI failed for GICv5 ITS");
+}
+
+static void vgic_v5_expect_its_lpi(struct vm_gic *v, struct kvm_vcpu *vcpu,
+				   u32 lpi)
+{
+	int ret;
+
+	its_expected_lpi = lpi;
+	sync_global_to_guest(v->vm, its_expected_lpi);
+
+	vgic_v5_signal_msi(v->vm, ITS_TEST_DEVICE_ID, ITS_TEST_EVENT_ID);
+
+	ret = run_vcpu(vcpu);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS receiver");
+	vgic_v5_expect_sync(vcpu, GUEST_CMD_ITS_LPI_DELIVERED,
+			    "GICv5 ITS guest did not consume expected LPI");
+}
+
+static void test_vgic_v5_its_translation_cache(void)
+{
+	struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS];
+	struct vm_gic v;
+	u64 wrong_addr, idr1;
+	int ret;
+
+	lpi_ist_ready = false;
+	its_expected_lpi = ITS_TEST_LPI_A;
+	vgic_v5_its_vm_create(&v, vcpus);
+	sync_global_to_guest(v.vm, lpi_ist_ready);
+	sync_global_to_guest(v.vm, its_expected_lpi);
+
+	ret = run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS setup vCPU");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_ITS_READY,
+			    "GICv5 ITS setup guest did not become ready");
+
+	ret = run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS receiver vCPU");
+	vgic_v5_expect_sync(vcpus[1], GUEST_CMD_ITS_READY,
+			    "GICv5 ITS receiver guest did not become ready");
+
+	ret = run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS GEN_EVENTR sender");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_ITS_GEN_EVENT_SENT,
+			    "GICv5 ITS setup guest did not send GEN_EVENTR");
+
+	ret = run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS GEN_EVENTR receiver");
+	vgic_v5_expect_sync(vcpus[1], GUEST_CMD_ITS_LPI_DELIVERED,
+			    "GICv5 ITS GEN_EVENTR did not deliver expected LPI");
+
+	ret = __vgic_v5_signal_msi(v.vm, GICV5_ITS_BASE_GPA +
+				   GICV5_ITS_TRANSLATER,
+				   ITS_TEST_DEVICE_ID, ITS_TEST_EVENT_ID, 0);
+	TEST_ASSERT(ret < 0 && errno == EINVAL,
+		    "GICv5 ITS accepted MSI without device ID flag");
+
+	wrong_addr = GICV5_ITS_BASE_GPA + GICV5_ITS_SIZE;
+	ret = __vgic_v5_signal_msi(v.vm, wrong_addr, ITS_TEST_DEVICE_ID,
+				   ITS_TEST_EVENT_ID, KVM_MSI_VALID_DEVID);
+	TEST_ASSERT(ret < 0 && errno == EINVAL,
+		    "GICv5 ITS accepted MSI for wrong address");
+
+	ret = __vgic_v5_signal_msi(v.vm, GICV5_ITS_BASE_GPA +
+				   GICV5_ITS_TRANSLATER,
+				   ITS_TEST_DEVICE_ID, BIT(16),
+				   KVM_MSI_VALID_DEVID);
+	TEST_ASSERT(ret < 0 && errno == EINVAL,
+		    "GICv5 ITS accepted MSI data wider than EventID");
+
+	ret = __vgic_v5_signal_msi(v.vm, GICV5_ITS_BASE_GPA +
+				   GICV5_ITS_TRANSLATER,
+				   ITS_TEST_DEVICE_ID, BIT(ITS_TEST_EVENT_ID_BITS),
+				   KVM_MSI_VALID_DEVID);
+	TEST_ASSERT(ret == 0,
+		    "GICv5 ITS did not block MSI with out-of-range EventID");
+
+	ret = __vgic_v5_signal_msi(v.vm, GICV5_ITS_BASE_GPA +
+				   GICV5_ITS_TRANSLATER,
+				   ITS_TEST_DEVICE_ID, ITS_TEST_EVENT_ID + 1,
+				   KVM_MSI_VALID_DEVID);
+	TEST_ASSERT(ret == 0,
+		    "GICv5 ITS did not block MSI with invalid ITTE");
+
+	/*
+	 * The earlier GEN_EVENTR has cached EventID -> LPI_A. At this stage,
+	 * VCPU0 rewrites the event, but doesn't invalidate it. The result is
+	 * that the MSI injection reuses the (stale) cache translation. This is
+	 * broken guest behaviour, as it should always issue an invalidation
+	 * when a translation changes.
+	 */
+	ret = run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS ITT rewrite");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_ITS_ITT_REWRITTEN,
+			    "GICv5 ITS guest did not rewrite ITT");
+	vgic_v5_expect_its_lpi(&v, vcpus[1], ITS_TEST_LPI_A);
+
+	/*
+	 * Event invalidation must drop the stale EventID -> LPI_A entry. We now
+	 * expect LPI B.
+	 */
+	ret = run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS event invalidation");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_ITS_EVENT_INVALIDATED,
+			    "GICv5 ITS guest did not invalidate event");
+	vgic_v5_expect_its_lpi(&v, vcpus[1], ITS_TEST_LPI_B);
+
+	/*
+	 * Device invalidation must cover all cached EventIDs for the
+	 * DeviceID. The guest has again re-written the event to translate to
+	 * LPI A.
+	 */
+	ret = run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS device invalidation");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_ITS_DEVICE_INVALIDATED,
+			    "GICv5 ITS guest did not invalidate device");
+	vgic_v5_expect_its_lpi(&v, vcpus[1], ITS_TEST_LPI_A);
+
+	/* A narrower userspace IDR1 must invalidate the cached DeviceID. */
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR1, &idr1);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS failed to read IDR1");
+	idr1 = (idr1 & ~GICV5_ITS_IDR1_DEVICEID_BITS) |
+		FIELD_PREP(GICV5_ITS_IDR1_DEVICEID_BITS, 2);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR1, &idr1);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS failed to narrow DeviceID width");
+	ret = __vgic_v5_signal_msi(v.vm, GICV5_ITS_BASE_GPA +
+				   GICV5_ITS_TRANSLATER,
+				   ITS_TEST_DEVICE_ID, ITS_TEST_EVENT_ID,
+				   KVM_MSI_VALID_DEVID);
+	TEST_ASSERT(ret == 0,
+		    "GICv5 ITS did not block MSI after DeviceID width changed");
+
+	/* Disabling the ITS must also prevent delivery from cached entries. */
+	ret = run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 ITS disable");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_ITS_DISABLED,
+			    "GICv5 ITS guest did not disable ITS");
+
+	/*
+	 * We should fail to inject this MSI. Use the raw call to ensure we
+	 * catch the return value.
+	 */
+	ret = __vgic_v5_signal_msi(v.vm, GICV5_ITS_BASE_GPA +
+				   GICV5_ITS_TRANSLATER,
+				   ITS_TEST_DEVICE_ID, ITS_TEST_EVENT_ID,
+				   KVM_MSI_VALID_DEVID);
+	TEST_ASSERT(ret < 0 && errno == ENXIO,
+		    "GICv5 ITS accepted cached MSI while disabled");
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -2411,6 +2920,9 @@ void run_tests(u32 gic_dev_type)
 
 	pr_info("Test VGICv5 IST save/restore\n");
 	test_vgic_v5_ist_save_restore();
+
+	pr_info("Test VGICv5 ITS translation cache\n");
+	test_vgic_v5_its_translation_cache();
 }
 
 int main(int ac, char **av)
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
index 2e4472489601c..895215a813b8d 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -137,14 +137,31 @@
 #define GICV5_ITS_INV_DEVICER_I		BIT(31)
 #define GICV5_ITS_INV_DEVICER_EVENTID_BITS GENMASK(5, 1)
 #define GICV5_ITS_INV_DEVICER_L1	BIT(0)
+#define GICV5_ITS_READ_EVENTR_R		BIT(31)
 #define GICV5_ITS_READ_EVENT_DATAR_VIRT	BIT_ULL(63)
 #define GICV5_ITS_READ_EVENT_DATAR_VM_ID GENMASK_ULL(47, 32)
 #define GICV5_ITS_READ_EVENT_DATAR_VALID BIT_ULL(31)
 #define GICV5_ITS_READ_EVENT_DATAR_LPI_ID GENMASK_ULL(23, 0)
+#define GICV5_ITS_GEN_EVENT_DIDR_DEVICEID GENMASK_ULL(31, 0)
+#define GICV5_ITS_GEN_EVENT_EIDR_EVENTID GENMASK(15, 0)
+#define GICV5_ITS_GEN_EVENTR_R		BIT(31)
+#define GICV5_ITS_GEN_EVENTR_TARGET_DOMAIN GENMASK(1, 0)
 #define GICV5_ITS_STATUSR_IDLE		BIT(0)
 #define GICV5_ITS_SYNC_STATUSR_IDLE	BIT(0)
 #define GICV5_ITS_GEN_EVENT_STATUSR_IDLE BIT(0)
 
+#define GICV5_DTL2E_VALID		BIT_ULL(0)
+#define GICV5_DTL2E_ITT_L2SZ		GENMASK_ULL(2, 1)
+#define GICV5_DTL2E_ITT_ADDR_MASK	GENMASK_ULL(55, 3)
+#define GICV5_DTL2E_ITT_DSWE		BIT_ULL(57)
+#define GICV5_DTL2E_ITT_STRUCTURE	BIT_ULL(58)
+#define GICV5_DTL2E_EVENT_ID_BITS	GENMASK_ULL(63, 59)
+
+#define GICV5_ITTL2E_LPI_ID		GENMASK_ULL(23, 0)
+#define GICV5_ITTL2E_DAC		GENMASK_ULL(29, 28)
+#define GICV5_ITTL2E_VIRTUAL		BIT_ULL(30)
+#define GICV5_ITTL2E_VALID		BIT_ULL(31)
+
 #define GICV5_IRS_IDR0_SETLPI		BIT(9)
 #define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
 #define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
-- 
2.34.1

