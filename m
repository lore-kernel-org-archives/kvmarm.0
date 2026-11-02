Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648718;
	b=g0FW+Vj0k24lZYTPPSFBTxdwCVVzku5sgcjGYhCSf3UpbZ+RGzf06RfFxMBvyTB4SK8c
	 KmQa7y2cD5IfBmuCbRDN25xGkIFPWTlUL7F9sejj3DoCuo4uZTiswhZuj0p9EWsZXty06
	 p8zdlDTjhFQRqsM4x07O91lSKEZzlT25JkFMszAr5iekov5UHJPKzxp8dRB12YQHGu39v
	 Wpw2YSrb6RGUJxJZAyiOzS/q9mJacL5lryudi97hSO1kNmDnK+C95/r15nHswMkKJ0MuI
	 gthB+jFWUdOS1jmVs4C5JZyAdArLy32m2GcK9WqpUsAQv+ZPeFurm49vdyNEQ8VO2oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648718;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=X3Wl76sNh2EDZcFFg+MvKbcdjE0WEhfwDpthLQhEmtM=;
	b=VSRfgD1Ilnh3y2kmLABtYKZih1Z+bd2GOprU7Mche/Gi9xidFM8ZM4qyzDUj+GMZxbQ1
	 aN3L0eAOKZhCcL/q9cHpLnctxK60LtH0Wa+dNPb4zYUKwqXw21d3raXJOxueReq5K2Ysb
	 iL6cvaKDIcJgt4tDjvTRW+sWO7f3hCxKtkSozkuCZobMQwPCFWQqc7NtkAUa3xgUTZCoo
	 EF47Dspft2EiFD+rXC8q8ktLgTaMvIcf2n9Z8d/HYnrR3RTXxMs/se8UUZ+jJXOhFGNoJ
	 osmyFrAzNljMbqRK+wd70Hg47WRijHsYSwfVfRnBJXE9UniKixrhvkOh89JQFdvFNIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BItXzWWY;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867926082BDD
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:45:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 867926082BDD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BItXzWWY
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7549175D;
	Mon,  2 Nov 2026 11:45:13 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 613093F673;
	Mon,  2 Nov 2026 11:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648716; bh=SOZ66g2j8NEnKOqTTWZoObY3YvcNmy2tUIDaqYf+yq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BItXzWWYL6kN4anqzLzKI6Ftz9Se+Sax4XEuzMzrHxpD8E/Fve3MhlB6zguALbyKN
	 hngrHsMGa9EtcsRCYVAwQ6iE4Oue50JBrQqEgvbeT4eV68yWY0I9aaLgR8JpiBhLBr
	 h7ncotPqtkrV/rUEusxfj1ZfAnWJiBwVRWUH8qQk=
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
Subject: [PATCH v2 03/16] KVM: arm64: gic-v5: Share CoreSight ID register emulation
Date: Mon,  2 Nov 2026 19:44:41 +0000
Message-Id: <20261102194454.4086911-4-sascha.bischoff@arm.com>
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

The GICv5 IRS and ITS expose the same CoreSight identification register
block. Move the register-value switch into a shared helper and describe
the contiguous ID register range with one register-region descriptor.

This keeps the IRS behaviour unchanged while giving the ITS MMIO
emulation a helper it can reuse when it is added in the following commit.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c  | 75 +++---------------------------
 arch/arm64/kvm/vgic/vgic-v5.c      | 34 ++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 include/linux/irqchip/arm-gic-v5.h |  2 +
 4 files changed, 44 insertions(+), 68 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-irs-v5.c
index 8d0ad74ebc64a..d0ebed2e1663b 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -520,38 +520,9 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
 static unsigned long vgic_v5_coresight_read(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
-	const size_t offset = addr & (SZ_64K - 1);
+	u32 offset = addr & (SZ_64K - 1);
 
-	switch (offset) {
-	case GICV5_CORESIGHT_DEVARCH:
-		return GICV5_CORESIGHT_DEVARCH_VAL;
-	case GICV5_CORESIGHT_PIDR4:
-		return GICV5_CORESIGHT_PIDR4_JEP106_CONT;
-	case GICV5_CORESIGHT_PIDR5:
-		return GICV5_CORESIGHT_PIDR5_RES0;
-	case GICV5_CORESIGHT_PIDR6:
-		return GICV5_CORESIGHT_PIDR6_RES0;
-	case GICV5_CORESIGHT_PIDR7:
-		return GICV5_CORESIGHT_PIDR7_RES0;
-	case GICV5_CORESIGHT_PIDR0:
-		return GICV5_CORESIGHT_PIDR0_PART_0;
-	case GICV5_CORESIGHT_PIDR1:
-		return GICV5_CORESIGHT_PIDR1_DES_0_PART_1;
-	case GICV5_CORESIGHT_PIDR2:
-		return GICV5_CORESIGHT_PIDR2_DES_1;
-	case GICV5_CORESIGHT_PIDR3:
-		return GICV5_CORESIGHT_PIDR3_REVAND_CMOD;
-	case GICV5_CORESIGHT_CIDR0:
-		return GICV5_CORESIGHT_CIDR0_VAL;
-	case GICV5_CORESIGHT_CIDR1:
-		return GICV5_CORESIGHT_CIDR1_VAL;
-	case GICV5_CORESIGHT_CIDR2:
-		return GICV5_CORESIGHT_CIDR2_VAL;
-	case GICV5_CORESIGHT_CIDR3:
-		return GICV5_CORESIGHT_CIDR3_VAL;
-	default:
-		return 0;
-	}
+	return vgic_v5_handle_guest_coresight_idreg_read(offset);
 }
 
 static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu *vcpu,
@@ -903,45 +874,13 @@ static const struct vgic_register_region vgic_v5_irs_registers[] = {
 				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 
-	/* CoreSight identification registers */
+	/* Split the ranges so KVM_HAS_DEVICE_ATTR only reports actual registers. */
 	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_DEVARCH,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
+				  vgic_v5_coresight_read, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR4,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR5,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR6,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR7,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR0,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR1,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR2,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR3,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR0,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR1,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR2,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR3,
-				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi,
+				  GICV5_CORESIGHT_PIDR_CIDR_SIZE,
 				  VGIC_ACCESS_32bit),
 };
 
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 91810fbd99afa..18184020e188b 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1601,3 +1601,37 @@ int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr)
 
 	return ret;
 }
+
+unsigned long vgic_v5_handle_guest_coresight_idreg_read(u32 offset)
+{
+	switch (offset) {
+	case GICV5_CORESIGHT_DEVARCH:
+		return GICV5_CORESIGHT_DEVARCH_VAL;
+	case GICV5_CORESIGHT_PIDR4:
+		return GICV5_CORESIGHT_PIDR4_JEP106_CONT;
+	case GICV5_CORESIGHT_PIDR5:
+		return GICV5_CORESIGHT_PIDR5_RES0;
+	case GICV5_CORESIGHT_PIDR6:
+		return GICV5_CORESIGHT_PIDR6_RES0;
+	case GICV5_CORESIGHT_PIDR7:
+		return GICV5_CORESIGHT_PIDR7_RES0;
+	case GICV5_CORESIGHT_PIDR0:
+		return GICV5_CORESIGHT_PIDR0_PART_0;
+	case GICV5_CORESIGHT_PIDR1:
+		return GICV5_CORESIGHT_PIDR1_DES_0_PART_1;
+	case GICV5_CORESIGHT_PIDR2:
+		return GICV5_CORESIGHT_PIDR2_DES_1;
+	case GICV5_CORESIGHT_PIDR3:
+		return GICV5_CORESIGHT_PIDR3_REVAND_CMOD;
+	case GICV5_CORESIGHT_CIDR0:
+		return GICV5_CORESIGHT_CIDR0_VAL;
+	case GICV5_CORESIGHT_CIDR1:
+		return GICV5_CORESIGHT_CIDR1_VAL;
+	case GICV5_CORESIGHT_CIDR2:
+		return GICV5_CORESIGHT_CIDR2_VAL;
+	case GICV5_CORESIGHT_CIDR3:
+		return GICV5_CORESIGHT_CIDR3_VAL;
+	default:
+		return 0;
+	}
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 8792953057bb7..f95eec6a01f63 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -390,6 +390,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
 int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis);
+unsigned long vgic_v5_handle_guest_coresight_idreg_read(u32 offset);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm-gic-v5.h
index 299e75bc95255..ee3677413560f 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -498,6 +498,8 @@
 #define GICV5_CORESIGHT_CIDR1		0xfff4
 #define GICV5_CORESIGHT_CIDR2		0xfff8
 #define GICV5_CORESIGHT_CIDR3		0xfffc
+#define GICV5_CORESIGHT_PIDR_CIDR_SIZE	\
+	(GICV5_CORESIGHT_CIDR3 + 4 - GICV5_CORESIGHT_PIDR4)
 
 #define GICV5_CORESIGHT_DEVARCH_VAL			\
 	(FIELD_PREP(GENMASK(31, 21), 0x23b) |		\
-- 
2.34.1

