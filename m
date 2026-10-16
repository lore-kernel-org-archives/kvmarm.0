Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1104DD6F5
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166318; cv=none; b=Q954izRFx1v7+5Md8AIE9pAMQtgIei6UuQAzIWpbP1OuueEWt0Zn3mGBM3cumm3YTj6lRuQ5lRzGZA3Oya0c+roDdu2SLpjYgra2vGgbiQDHL/EbFnrsZCnIYBMV+IWFjEKhBWIe1A0lzpNoTATb3TbattJ1xl+IoZQaQcLTPiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166318; c=relaxed/simple;
	bh=pq2+wWRhfYB/qAuo/UjADcYRpR88rqDHy/3xv7EDzq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dV6NY1A/5QGmaFsZ1oq2Taf9dGGwjd3Wdgn41rFtlZSWoWyY6tvzCRbUmMQgOOoA2/MdoYj7y1kvWxG/rtCbotCzJGl7NvBPl6xirHTKiT5SM2IUFtuJqnpU5y3SdyxvVbhOHBmbKvsZabQGQ2fWBufUghHuXKq99HwgBBMjkHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JhwKnf3k; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JhwKnf3k"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88D8E143D;
	Fri, 16 Oct 2026 08:58:33 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF27B3F673;
	Fri, 16 Oct 2026 08:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166316; bh=pq2+wWRhfYB/qAuo/UjADcYRpR88rqDHy/3xv7EDzq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhwKnf3kkTqtWSIkHfurlJhQMGoDHsdffNQkZNaaSQLAqaRdqBIt3gbE/P6jJwt79
	 XJ4UdV/LJ5g8UKgWMHEb+4YqJgqJbBIGWbN95Ryh1VCBBO0mGuemP4nxFyYHz1DWZo
	 7nKdcVqS8+sPVQ7KPx4+8S7t+LQj+8cURSeAL8No=
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
Subject: [PATCH 04/16] irqchip/gic-v5: Add ITS MMIO register definitions
Date: Fri, 16 Oct 2026 16:57:29 +0100
Message-Id: <20261016155741.979985-5-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016155741.979985-1-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
index a4879774124f8..7e64eb0436394 100644
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

