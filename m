Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648722;
	b=o1vl9C024YtvI5T+jSkc3xnDSvR/Sq8cTc/nijtWHlZLMQ1r9VpiIHvi74JDcdTYAC3I
	 E7g5i60o2513wd/h0Y+kdLavEQEnDotVZDcD/TxowYgbv53Kumm9eSw3GpYW6lZTMofYN
	 tCucOVD3gHAQGeEKwvBPHF4MrOM0CAFKTejBA6AxdGKmlITeYZIepvMRQwfnNsvbKguDY
	 5G7/15v+D6mXOCM8ldBEHs+RMX4bqvGpgnY0F2id8GEbiHJU0LSyVjRw7dRcFNrd9tX69
	 AsvXNiriqoWb6YlWqG0xh842ebOdGZfSIcMJU/I4cDvUffEjY0u2iBIrU4dPadNSx5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648722;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+NOo5xkBbc3f2BbNLUmdp9/dTWvq69FacuNY1c/vFa4=;
	b=MXDLUH9ytDfrew3xFdWRwWT4o+sFlIHs+M0kkWVGVIYzQmcSRWGG+LCcEfsbIJjfV0sZ
	 Q6bx2KZ4fZufjq8YzbVaXDkLp7PED07N/GZs7TG5bl4ET/1XXXN5QrdS7bxhaxlWytJxi
	 GfG2iCSEuB5Uw26LYRGg4leuncClZS94lr6FG70eppdW891RnYeNpMlA6D/aAefP9Alf+
	 ns56MFZWsMDtH6EQcdqkjWEkv7MEyftjV4lvgO48mpZP+RjHelKStQ7LH+lKITSNShhhH
	 7PGfpQgaHH0VQWmaS3pc+4iEhD3SE5LTgNrE+xQbJUsRxtPXeNB5r3TneS934tMPpdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=pD9yP+2M;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E51608361A
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:45:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8E51608361A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=pD9yP+2M
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F22921C14;
	Mon,  2 Nov 2026 11:45:17 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DB993FB9E;
	Mon,  2 Nov 2026 11:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648721; bh=Tk77NTIJOW7X1q61eFcXK6Rq36pF0H/sFRkZQTHUPZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD9yP+2M1i7Lnot3VfuUrSUsAX4TrvXjtjYcmaWFqrWA+yuRTV5qSvhzVsEEpLZzb
	 LdC9Th2PfQPjUV6LkfbEEx+KgsXVD55dWzlz5wE34//Nfs6cjNA6FI/8sUdMA6R85w
	 2E4Y/1edYJgrkCElsCewjxuadaO+850I2yJhCkrI=
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
Subject: [PATCH v2 04/16] irqchip/gic-v5: Add ITS MMIO register definitions
Date: Mon,  2 Nov 2026 19:44:42 +0000
Message-Id: <20261102194454.4086911-5-sascha.bischoff@arm.com>
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

Introduce the GICv5 ITS MMIO register offsets and bit definitions in
one place before the virtual ITS starts consuming them.

Keeping the ITS register frame definitions together avoids spreading
register-definition churn across the subsequent KVM ITS emulation
patches.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/linux/irqchip/arm-gic-v5.h | 126 +++++++++++++++++++++--------
 1 file changed, 92 insertions(+), 34 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm-gic-v5.h
index ee3677413560f..6e8484fef9faf 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -364,50 +364,88 @@
 /*
  * ITS registers and tables structures
  */
-#define GICV5_ITS_IDR1		0x0004
-#define GICV5_ITS_IDR2		0x0008
-#define GICV5_ITS_CR0		0x0080
-#define GICV5_ITS_CR1		0x0084
-#define GICV5_ITS_DT_BASER	0x00c0
-#define GICV5_ITS_DT_CFGR	0x00d0
-#define GICV5_ITS_DIDR		0x0100
-#define GICV5_ITS_EIDR		0x0108
-#define GICV5_ITS_INV_EVENTR	0x010c
-#define GICV5_ITS_INV_DEVICER	0x0110
-#define GICV5_ITS_STATUSR	0x0120
-#define GICV5_ITS_SYNCR		0x0140
-#define GICV5_ITS_SYNC_STATUSR	0x0148
-
-#define GICV5_ITS_IDR1_L2SZ			GENMASK(10, 8)
-#define GICV5_ITS_IDR1_ITT_LEVELS		BIT(7)
-#define GICV5_ITS_IDR1_DT_LEVELS		BIT(6)
-#define GICV5_ITS_IDR1_DEVICEID_BITS		GENMASK(5, 0)
+#define GICV5_ITS_IDR0			0x0000
+#define GICV5_ITS_IDR1			0x0004
+#define GICV5_ITS_IDR2			0x0008
+#define GICV5_ITS_IIDR			0x0040
+#define GICV5_ITS_AIDR			0x0044
+#define GICV5_ITS_CR0			0x0080
+#define GICV5_ITS_CR1			0x0084
+#define GICV5_ITS_DT_BASER		0x00c0
+#define GICV5_ITS_DT_CFGR		0x00d0
+#define GICV5_ITS_DIDR			0x0100
+#define GICV5_ITS_EIDR			0x0108
+#define GICV5_ITS_INV_EVENTR		0x010c
+#define GICV5_ITS_INV_DEVICER		0x0110
+#define GICV5_ITS_READ_EVENTR		0x0114
+#define GICV5_ITS_READ_EVENT_DATAR	0x0118
+#define GICV5_ITS_STATUSR		0x0120
+#define GICV5_ITS_SYNCR			0x0140
+#define GICV5_ITS_SYNC_STATUSR		0x0148
+#define GICV5_ITS_GEN_EVENT_DIDR	0x0180
+#define GICV5_ITS_GEN_EVENT_EIDR	0x0188
+#define GICV5_ITS_GEN_EVENTR		0x018c
+#define GICV5_ITS_GEN_EVENT_STATUSR	0x0190
+#define GICV5_ITS_MEC_IDR		0x01c0
+#define GICV5_ITS_MEC_MECID_R		0x01c4
+#define GICV5_ITS_MPAM_IDR		0x0200
+#define GICV5_ITS_MPAM_PARTID_R		0x0204
+#define GICV5_ITS_SWERR_STATUSR		0x0240
+#define GICV5_ITS_SWERR_SYNDROMER0	0x0248
+#define GICV5_ITS_SWERR_SYNDROMER1	0x0250
+#define GICV5_ITS_MPAM_PMGR		0x0258
+
+#define GICV5_ITS_TRANSLATER		0x0000
+#define GICV5_ITS_RL_TRANSLATER		0x0008
+
+#define GICV5_ITS_IDR0_ITSID		GENMASK(31, 16)
+#define GICV5_ITS_IDR0_SWE		BIT(8)
+#define GICV5_ITS_IDR0_MPAM		BIT(7)
+#define GICV5_ITS_IDR0_MEC		BIT(6)
+#define GICV5_ITS_IDR0_PA_RANGE		GENMASK(5, 2)
+#define GICV5_ITS_IDR0_DOM		GENMASK(1, 0)
+
+#define GICV5_ITS_IDR0_DOMAIN_SECURE		0b00
+#define GICV5_ITS_IDR0_DOMAIN_NON_SECURE	0b01
+#define GICV5_ITS_IDR0_DOMAIN_EL3		0b10
+#define GICV5_ITS_IDR0_DOMAIN_REALM		0b11
+
+#define GICV5_ITS_IDR1_L2SZ		GENMASK(10, 8)
+#define GICV5_ITS_IDR1_ITT_LEVELS	BIT(7)
+#define GICV5_ITS_IDR1_DT_LEVELS	BIT(6)
+#define GICV5_ITS_IDR1_DEVICEID_BITS	GENMASK(5, 0)
 
 #define GICV5_ITS_IDR1_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(8), (r))
 #define GICV5_ITS_IDR1_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(9), (r))
 #define GICV5_ITS_IDR1_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(10), (r))
 
-#define GICV5_ITS_IDR2_XDMN_EVENTs		GENMASK(6, 5)
-#define GICV5_ITS_IDR2_EVENTID_BITS		GENMASK(4, 0)
+#define GICV5_ITS_IDR2_XDMN_EVENTS	GENMASK(6, 5)
+#define GICV5_ITS_IDR2_EVENTID_BITS	GENMASK(4, 0)
 
-#define GICV5_ITS_CR0_IDLE			BIT(1)
-#define GICV5_ITS_CR0_ITSEN			BIT(0)
+#define GICV5_ITS_IIDR_PRODUCT_ID	GENMASK(31, 20)
+#define GICV5_ITS_IIDR_VARIANT		GENMASK(19, 16)
+#define GICV5_ITS_IIDR_REVISION		GENMASK(15, 12)
+#define GICV5_ITS_IIDR_IMPLEMENTER	GENMASK(11, 0)
 
-#define GICV5_ITS_CR1_ITT_RA			BIT(7)
-#define GICV5_ITS_CR1_DT_RA			BIT(6)
-#define GICV5_ITS_CR1_IC			GENMASK(5, 4)
-#define GICV5_ITS_CR1_OC			GENMASK(3, 2)
-#define GICV5_ITS_CR1_SH			GENMASK(1, 0)
+#define GICV5_ITS_AIDR_COMPONENT	GENMASK(11, 8)
+#define GICV5_ITS_AIDR_ARCHMAJORREV	GENMASK(7, 4)
+#define GICV5_ITS_AIDR_ARCHMINORREV	GENMASK(3, 0)
 
-#define GICV5_ITS_DT_CFGR_STRUCTURE		BIT(16)
-#define GICV5_ITS_DT_CFGR_L2SZ			GENMASK(7, 6)
-#define GICV5_ITS_DT_CFGR_DEVICEID_BITS		GENMASK(5, 0)
+#define GICV5_ITS_CR0_IDLE		BIT(1)
+#define GICV5_ITS_CR0_ITSEN		BIT(0)
 
-#define GICV5_ITS_DT_BASER_ADDR_MASK		GENMASK_ULL(55, 3)
+#define GICV5_ITS_CR1_ITT_RA		BIT(7)
+#define GICV5_ITS_CR1_DT_RA		BIT(6)
+#define GICV5_ITS_CR1_IC		GENMASK(5, 4)
+#define GICV5_ITS_CR1_OC		GENMASK(3, 2)
+#define GICV5_ITS_CR1_SH		GENMASK(1, 0)
 
-#define GICV5_ITS_INV_DEVICER_I			BIT(31)
-#define GICV5_ITS_INV_DEVICER_EVENTID_BITS	GENMASK(5, 1)
-#define GICV5_ITS_INV_DEVICER_L1		BIT(0)
+#define GICV5_ITS_DT_BASER_ADDR_MASK	GENMASK_ULL(55, 3)
+#define GICV5_ITS_DT_BASER_ADDR_SHIFT	3ULL
+
+#define GICV5_ITS_DT_CFGR_STRUCTURE	BIT(16)
+#define GICV5_ITS_DT_CFGR_L2SZ		GENMASK(7, 6)
+#define GICV5_ITS_DT_CFGR_DEVICEID_BITS	GENMASK(5, 0)
 
 #define GICV5_ITS_DIDR_DEVICEID			GENMASK_ULL(31, 0)
 
@@ -417,6 +455,17 @@
 #define GICV5_ITS_INV_EVENTR_ITT_L2SZ		GENMASK(2, 1)
 #define GICV5_ITS_INV_EVENTR_L1			BIT(0)
 
+#define GICV5_ITS_INV_DEVICER_I			BIT(31)
+#define GICV5_ITS_INV_DEVICER_EVENTID_BITS	GENMASK(5, 1)
+#define GICV5_ITS_INV_DEVICER_L1		BIT(0)
+
+#define GICV5_ITS_READ_EVENTR_R			BIT(31)
+
+#define GICV5_ITS_READ_EVENT_DATAR_VIRT		BIT_ULL(63)
+#define GICV5_ITS_READ_EVENT_DATAR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_ITS_READ_EVENT_DATAR_VALID	BIT_ULL(31)
+#define GICV5_ITS_READ_EVENT_DATAR_LPI_ID	GENMASK_ULL(23, 0)
+
 #define GICV5_ITS_STATUSR_IDLE			BIT(0)
 
 #define GICV5_ITS_SYNCR_SYNC			BIT_ULL(63)
@@ -425,6 +474,15 @@
 
 #define GICV5_ITS_SYNC_STATUSR_IDLE		BIT(0)
 
+#define GICV5_ITS_GEN_EVENT_DIDR_DEVICEID	GENMASK_ULL(31, 0)
+
+#define GICV5_ITS_GEN_EVENT_EIDR_EVENTID	GENMASK(15, 0)
+
+#define GICV5_ITS_GEN_EVENTR_R			BIT(31)
+#define GICV5_ITS_GEN_EVENTR_TARGET_DOMAIN	GENMASK(1, 0)
+
+#define GICV5_ITS_GEN_EVENT_STATUSR_IDLE	BIT(0)
+
 #define GICV5_DTL1E_VALID			BIT_ULL(0)
 /* Note that there is no shift for the address by design */
 #define GICV5_DTL1E_L2_ADDR_MASK		GENMASK_ULL(55, 3)
-- 
2.34.1

