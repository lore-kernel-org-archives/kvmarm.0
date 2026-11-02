Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648715;
	b=M5cAM4eIUnTB96nq6fPOM/KBZFQdA2CGediS63MFFwfzj9YKNefwmOaWx4822siHvUBv
	 hw2LLej6/AsFcHebKVzPr/Yv3kMqxHeF/HfINS4NF9SzNdVTnRwlU4N5Zr6Trf8KVD3+q
	 W/FsWZo4n1qUiAnFRzPwCpTXVOAPyOtlZhp0ZE4H85DB9cHam6w6ifv20knKgd3F4OOOU
	 93h0XuKTDuueIPtPOPSqEnG+zwfU/5zC3jH9LXgiRg7DBuH28vAgMVFHjIN1beugx2oVu
	 uq+htEOtw/Rl6U9neyoDgys19GWsFpk2PYkhiP4zjR1yJjoewZDjdIGR1rjNddh2F0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648715;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SxDeP+VVrehaEoxAacbpEcDKEnQestaQVUxckwi1z4Q=;
	b=a+LCzGkuyAjHbRnc5TY4h7kAPcxc6+DLL1DE8AslofUSVo7/7Nq/LDPRVLl9R7xfvmpI
	 PQVVLix3xaFakyh3m2cz00pVa5+qhjyMUeFfDB2upxz+I1PVA/OFZZScrwG1Yx/74YZ69
	 VqDe170Zw9xIDD4sl+LxoaHcVfnKxVLcgSb/oV0xE6TRNPraHQB6uKgfNzGaQLh1y3QUZ
	 K23ekQVheFRRfuszgBbPg97ZR3hqlB/8k7RpDCbBSwo7185dLtHg3mm3Es7ELK+E7CuZb
	 J5PvbSzCgrfoqnba/bfNO1oJ7eOaF/Wgopne2lMMG1M5e+10T0qiWYIWE31H7cafU/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Yq44rYbu;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81EA1606D83D
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:45:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81EA1606D83D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Yq44rYbu
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D4CC16A3;
	Mon,  2 Nov 2026 11:45:09 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D98B63F673;
	Mon,  2 Nov 2026 11:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648712; bh=amDiy+/ROWpP26/w1KGH5V47ch5HrMmB725iyWflZog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yq44rYbu5yvylisult486QxQUL3jSeYkEcobdMl251Kz5R75syCv5ICA26XR9Dd0i
	 7BMBMo1ZiSBQJNTRKH/bLIOzbDQqQzIPywdNUneIPtGis2al1NtHvgNzYqcbV8DAFy
	 9pT5++s+Os+RyAFJrjy1V4llCOme+aHHj/7z5mAM=
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
Subject: [PATCH v2 02/16] KVM: arm64: vgic: Pass opaque device pointer to ITS MMIO callbacks
Date: Mon,  2 Nov 2026 19:44:40 +0000
Message-Id: <20261102194454.4086911-3-sascha.bischoff@arm.com>
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

The ITS MMIO callbacks currently take a struct vgic_its pointer,
which ties them to the GICv3 ITS. GICv5 needs to use the same MMIO
dispatch path with a different device structure.

Pass an opaque device pointer to the callbacks and cast it in the
GICv3 handlers. This does not change GICv3 behaviour.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-its.c  | 55 +++++++++++++++++----------------
 arch/arm64/kvm/vgic/vgic-mmio.h |  6 ++--
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 34c1c89bfbfe1..c6e069af7c614 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -386,10 +386,10 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
-					      struct vgic_its *its,
+static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm, void *dev,
 					      gpa_t addr, unsigned int len)
 {
+	struct vgic_its *its = dev;
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	u64 reg = GITS_TYPER_PLPIS;
 
@@ -408,10 +408,10 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
 	return extract_bytes(reg, addr & 7, len);
 }
 
-static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
-					     struct vgic_its *its,
+static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm, void *dev,
 					     gpa_t addr, unsigned int len)
 {
+	struct vgic_its *its = dev;
 	u32 val;
 
 	val = (its->abi_rev << GITS_IIDR_REV_SHIFT) & GITS_IIDR_REV_MASK;
@@ -419,11 +419,11 @@ static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
 	return val;
 }
 
-static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
-					    struct vgic_its *its,
+static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm, void *dev,
 					    gpa_t addr, unsigned int len,
 					    unsigned long val)
 {
+	struct vgic_its *its = dev;
 	u32 rev = GITS_IIDR_REV(val);
 
 	if (rev >= NR_ITS_ABIS)
@@ -433,7 +433,7 @@ static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
 }
 
 static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
-					       struct vgic_its *its,
+					       void *dev,
 					       gpa_t addr, unsigned int len)
 {
 	switch (addr & 0xffff) {
@@ -1496,17 +1496,18 @@ static u64 vgic_sanitise_its_cbaser(u64 reg)
 	return reg;
 }
 
-static unsigned long vgic_mmio_read_its_cbaser(struct kvm *kvm,
-					       struct vgic_its *its,
+static unsigned long vgic_mmio_read_its_cbaser(struct kvm *kvm, void *dev,
 					       gpa_t addr, unsigned int len)
 {
+	struct vgic_its *its = dev;
 	return extract_bytes(its->cbaser, addr & 7, len);
 }
 
-static void vgic_mmio_write_its_cbaser(struct kvm *kvm, struct vgic_its *its,
+static void vgic_mmio_write_its_cbaser(struct kvm *kvm, void *dev,
 				       gpa_t addr, unsigned int len,
 				       unsigned long val)
 {
+	struct vgic_its *its = dev;
 	/* When GITS_CTLR.Enable is 1, this register is RO. */
 	if (its->enabled)
 		return;
@@ -1564,10 +1565,11 @@ static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
  * protects our ring buffer variables, so that there is only one user
  * per ITS handling commands at a given time.
  */
-static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
+static void vgic_mmio_write_its_cwriter(struct kvm *kvm, void *dev,
 					gpa_t addr, unsigned int len,
 					unsigned long val)
 {
+	struct vgic_its *its = dev;
 	u64 reg;
 
 	if (!its)
@@ -1588,25 +1590,25 @@ static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
 	mutex_unlock(&its->cmd_lock);
 }
 
-static unsigned long vgic_mmio_read_its_cwriter(struct kvm *kvm,
-						struct vgic_its *its,
+static unsigned long vgic_mmio_read_its_cwriter(struct kvm *kvm, void *dev,
 						gpa_t addr, unsigned int len)
 {
+	struct vgic_its *its = dev;
 	return extract_bytes(its->cwriter, addr & 0x7, len);
 }
 
-static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
-					       struct vgic_its *its,
+static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm, void *dev,
 					       gpa_t addr, unsigned int len)
 {
+	struct vgic_its *its = dev;
 	return extract_bytes(its->creadr, addr & 0x7, len);
 }
 
-static int vgic_mmio_uaccess_write_its_creadr(struct kvm *kvm,
-					      struct vgic_its *its,
+static int vgic_mmio_uaccess_write_its_creadr(struct kvm *kvm, void *dev,
 					      gpa_t addr, unsigned int len,
 					      unsigned long val)
 {
+	struct vgic_its *its = dev;
 	u32 cmd_offset;
 	int ret = 0;
 
@@ -1630,10 +1632,10 @@ static int vgic_mmio_uaccess_write_its_creadr(struct kvm *kvm,
 }
 
 #define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
-static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
-					      struct vgic_its *its,
+static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm, void *dev,
 					      gpa_t addr, unsigned int len)
 {
+	struct vgic_its *its = dev;
 	u64 reg;
 
 	switch (BASER_INDEX(addr)) {
@@ -1652,11 +1654,11 @@ static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
 }
 
 #define GITS_BASER_RO_MASK	(GENMASK_ULL(52, 48) | GENMASK_ULL(58, 56))
-static void vgic_mmio_write_its_baser(struct kvm *kvm,
-				      struct vgic_its *its,
+static void vgic_mmio_write_its_baser(struct kvm *kvm, void *dev,
 				      gpa_t addr, unsigned int len,
 				      unsigned long val)
 {
+	struct vgic_its *its = dev;
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	u64 old, entry_size, table_type;
 	u64 reg, *regptr, clearbits = 0;
@@ -1711,10 +1713,10 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	}
 }
 
-static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
-					     struct vgic_its *its,
+static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu, void *dev,
 					     gpa_t addr, unsigned int len)
 {
+	struct vgic_its *its = dev;
 	u32 reg = 0;
 
 	mutex_lock(&its->cmd_lock);
@@ -1727,10 +1729,11 @@ static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
 	return reg;
 }
 
-static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
+static void vgic_mmio_write_its_ctlr(struct kvm *kvm, void *dev,
 				     gpa_t addr, unsigned int len,
 				     unsigned long val)
 {
+	struct vgic_its *its = dev;
 	mutex_lock(&its->cmd_lock);
 
 	/*
@@ -1776,8 +1779,8 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 	.uaccess_its_write = uwr,				\
 }
 
-static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
-			      gpa_t addr, unsigned int len, unsigned long val)
+static void its_mmio_write_wi(struct kvm *kvm, void *dev, gpa_t addr,
+			      unsigned int len, unsigned long val)
 {
 	/* Ignore */
 }
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index 38ed730d68ac3..c3b6d3e752d8d 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -13,13 +13,13 @@ struct vgic_register_region {
 	union {
 		unsigned long (*read)(struct kvm_vcpu *vcpu, gpa_t addr,
 				      unsigned int len);
-		unsigned long (*its_read)(struct kvm *kvm, struct vgic_its *its,
+		unsigned long (*its_read)(struct kvm *kvm, void *dev,
 					  gpa_t addr, unsigned int len);
 	};
 	union {
 		void (*write)(struct kvm_vcpu *vcpu, gpa_t addr,
 			      unsigned int len, unsigned long val);
-		void (*its_write)(struct kvm *kvm, struct vgic_its *its,
+		void (*its_write)(struct kvm *kvm, void *dev,
 				  gpa_t addr, unsigned int len,
 				  unsigned long val);
 	};
@@ -28,7 +28,7 @@ struct vgic_register_region {
 	union {
 		int (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
 				     unsigned int len, unsigned long val);
-		int (*uaccess_its_write)(struct kvm *kvm, struct vgic_its *its,
+		int (*uaccess_its_write)(struct kvm *kvm, void *dev,
 					 gpa_t addr, unsigned int len,
 					 unsigned long val);
 	};
-- 
2.34.1

