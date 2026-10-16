Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9449375F9C
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166301; cv=none; b=XxCywKpuETFyCss5FoDmcqTaYkv6BG9GzvFRnLNnWHdvFktk3+EzPRhgsHKzZjgekiZFiYhb2ftfFh5kOUW1NSojw9uelGJDv8qOUzhbixmch5Fe54UfYgd4ftoonoIw1KlSGVBPRm7LX5tDpjm2gLv+pH36eqzTm8wu2qxCp1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166301; c=relaxed/simple;
	bh=ZtH0KITBHyvbIZ7zmmTk/nJd7SlkyxaLPNLQJ3eVu5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pBfDdwKYxjIkepyIR7cAhJXNB01kTKvPulPYPiOG+PTYqduee2l9++v+CKsJw1tXz9TokImI9Tv+8ygGI+FWz5YZ0mlxjRyGApKkqNSyzhY/LfJ7QZeSBozDV4bJWLLBnw8WlqVvGlzoQ+8ZmI46KcersExRwy/ML+e3NNYrlgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VH6mh8Iw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VH6mh8Iw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02914143D;
	Fri, 16 Oct 2026 08:58:16 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D4273F673;
	Fri, 16 Oct 2026 08:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166299; bh=ZtH0KITBHyvbIZ7zmmTk/nJd7SlkyxaLPNLQJ3eVu5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VH6mh8Iw0gEWxZsRVcxSZbw3lOpL6t+afgpbtKX/Csx1vCX0JbGsGt+hbEB1Oz/l5
	 /HujX7yfrEdY6WfaqWeo+HMXiJ61QAeb5gDD/HRyIojtFCPFwbjuk455Ip+cdOnui/
	 cZ5LtDHkVH6thwQua9Sw1qh9AaoHBJgmxp0DrFLI=
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
Subject: [PATCH 02/16] KVM: arm64: vgic: Pass opaque device pointer to ITS MMIO callbacks
Date: Fri, 16 Oct 2026 16:57:27 +0100
Message-Id: <20261016155741.979985-3-sascha.bischoff@arm.com>
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
index 8e7bee1bae95d..dff942b4f4233 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -388,10 +388,10 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
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
 
@@ -410,10 +410,10 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
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
@@ -421,11 +421,11 @@ static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
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
@@ -435,7 +435,7 @@ static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
 }
 
 static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
-					       struct vgic_its *its,
+					       void *dev,
 					       gpa_t addr, unsigned int len)
 {
 	switch (addr & 0xffff) {
@@ -1445,17 +1445,18 @@ static u64 vgic_sanitise_its_cbaser(u64 reg)
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
@@ -1513,10 +1514,11 @@ static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
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
@@ -1537,25 +1539,25 @@ static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
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
 
@@ -1579,10 +1581,10 @@ static int vgic_mmio_uaccess_write_its_creadr(struct kvm *kvm,
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
@@ -1601,11 +1603,11 @@ static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
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
@@ -1660,10 +1662,10 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
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
@@ -1676,10 +1678,11 @@ static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
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
@@ -1725,8 +1728,8 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
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

