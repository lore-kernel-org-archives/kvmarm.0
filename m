Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41F231D759
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 07:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780559529; cv=none; b=fLIVYnOlrdMU2sNfctNHdUinPL8Ip0Pm85L+BKhA1v+4NqkBpcZTnG9ye4SNnojXeADGZS719JlMMkovFxBdlAZay6FNKfpP2cYcvA3Gy8drERGUN5MEG7hqlq+2xT5sOlJpNyWKO7pgbXUSR4Rqd3G2nPoZQg0qma6dGahXtYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780559529; c=relaxed/simple;
	bh=lrJJJ+9noOVWAcugcM//hXL79yS4YPrboTsDnJcx/VA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tZM5910E9gVRrajOEtvsGlf6vxitC6OOao4R6/Zx+NXvXUlDg7X3R2y0MtT6RZRG0Z2qidgaXxhtEg9Q4ii7hPx+OCJBwrRK5GECWmrqaBQXE2hs+KOtra45y8L6h8KNakZz87L5gAdKysR/v1/30klzYiHfk6mB3YX7+4EBINc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pwTsRkuR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pwTsRkuR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780559524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F/6a5Hz4T+tF5Hum64kyYi4mlYR+VtC6XjGxcnq9JNQ=;
	b=pwTsRkuRxX/Hf8Nq/pKS0+lmUicQzYXQrTAgan89ZNjbFReMXqbzUdmpwpFnA6xkTBWI3+
	k3PnNujYF5Dym72An0vvY9hIv6eFfEimp5zqPneuOt1y6pIn1obj9PUunH2cy+mX1eH7+Y
	UvVpdnTfOf4brq6RzzqTFuYHbPOxRjQ=
From: Jackie Liu <liu.yun@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: yuzenghui@huawei.com,
	will@kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2] KVM/arm64: vgic-its: Make ABI commit helpers return void
Date: Thu,  4 Jun 2026 15:51:47 +0800
Message-ID: <20260604075147.53299-1-liu.yun@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jackie Liu <liuyun01@kylinos.cn>

The return values of vgic_its_set_abi() and vgic_its_commit_v0() are always
0 and do not carry useful error information. Simplify by changing them to
void.

Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 1d7e5d560af4..ca48b34dec20 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -27,7 +27,7 @@ static struct kvm_device_ops kvm_arm_vgic_its_ops;
 
 static int vgic_its_save_tables_v0(struct vgic_its *its);
 static int vgic_its_restore_tables_v0(struct vgic_its *its);
-static int vgic_its_commit_v0(struct vgic_its *its);
+static void vgic_its_commit_v0(struct vgic_its *its);
 static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
 
@@ -168,7 +168,7 @@ struct vgic_its_abi {
 	int ite_esz;
 	int (*save_tables)(struct vgic_its *its);
 	int (*restore_tables)(struct vgic_its *its);
-	int (*commit)(struct vgic_its *its);
+	void (*commit)(struct vgic_its *its);
 };
 
 #define ABI_0_ESZ	8
@@ -192,13 +192,13 @@ inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
 	return &its_table_abi_versions[its->abi_rev];
 }
 
-static int vgic_its_set_abi(struct vgic_its *its, u32 rev)
+static void vgic_its_set_abi(struct vgic_its *its, u32 rev)
 {
 	const struct vgic_its_abi *abi;
 
 	its->abi_rev = rev;
 	abi = vgic_its_get_abi(its);
-	return abi->commit(its);
+	abi->commit(its);
 }
 
 /*
@@ -472,7 +472,8 @@ static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
 
 	if (rev >= NR_ITS_ABIS)
 		return -EINVAL;
-	return vgic_its_set_abi(its, rev);
+	vgic_its_set_abi(its, rev);
+	return 0;
 }
 
 static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
@@ -1888,14 +1889,11 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	its->baser_coll_table = INITIAL_BASER_VALUE |
 		((u64)GITS_BASER_TYPE_COLLECTION << GITS_BASER_TYPE_SHIFT);
 	dev->kvm->arch.vgic.propbaser = INITIAL_PROPBASER_VALUE;
-
 	dev->private = its;
 
-	ret = vgic_its_set_abi(its, NR_ITS_ABIS - 1);
-
+	vgic_its_set_abi(its, NR_ITS_ABIS - 1);
 	mutex_unlock(&dev->kvm->arch.config_lock);
-
-	return ret;
+	return 0;
 }
 
 static void vgic_its_destroy(struct kvm_device *kvm_dev)
@@ -2610,7 +2608,7 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
 	return ret;
 }
 
-static int vgic_its_commit_v0(struct vgic_its *its)
+static void vgic_its_commit_v0(struct vgic_its *its)
 {
 	const struct vgic_its_abi *abi;
 
@@ -2623,7 +2621,6 @@ static int vgic_its_commit_v0(struct vgic_its *its)
 
 	its->baser_device_table |= (GIC_ENCODE_SZ(abi->dte_esz, 5)
 					<< GITS_BASER_ENTRY_SIZE_SHIFT);
-	return 0;
 }
 
 static void vgic_its_reset(struct kvm *kvm, struct vgic_its *its)
-- 
2.54.0

