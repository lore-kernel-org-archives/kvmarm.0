Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2A53A7F4B
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 03:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780542897; cv=none; b=GvKRknOn3wDKQ2ZFtMOyw8xsYzsJ0V4jU8DJwzhkwbKSYGkMXYoXicksQi5URlFpWS+tocojTBABXp02ijSlPbDSe9opS0GudKdbqdnOeQhaFs7dhLtp5EYVlTnyTbk81iZaWvfr/id33dTTRBXlyVh7/QjDmL8t0WUN6Q3koB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780542897; c=relaxed/simple;
	bh=xX5yQI5HqHDE+mKCChDa8hTnDM73AIFBlNu313PVOoY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U6clK/wJklATZCxNgvatJ2aSAEYVawaoZIy4I/0SlvL3xC//nVRQT3lkLSN1Qve+feLJLKqp1/nGYjbotOVfa26rG1hD8zUwxjzruFPc6Uv6bcDzkyOL563mlt6BMSdOYR3AW+UnS3yu3YakT6ibEJL6ILAhrAyKnN6HGsmIY74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K68z+di4; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K68z+di4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780542894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YvZuk1I/j+eWEKq+4R+vmT9mUVOs9QlwW/okf/c7JhA=;
	b=K68z+di4bi5be0A+GTUpuzeEG4UPq2J6Sghnv71y46NB05mKWRAdz8Pvyp3rea3dx42Lre
	n/7cxHYkGe0yTr8Y3nmChoFw2xdtgw0C61G+dM/01aPp6a+eFx+8vN7bgnWawz71FCavJy
	HY5IVq84Q+vKiv6FkRctRd3FabW/r9M=
From: Jackie Liu <liu.yun@linux.dev>
To: maz@kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: oupton@kernel.org,
	yuzenghui@huawei.com,
	will@kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH] KVM/arm64: vgic-its: Fix memory leak when vgic_its_set_abi() fails
Date: Thu,  4 Jun 2026 11:14:26 +0800
Message-ID: <20260604031426.16109-1-liu.yun@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jackie Liu <liuyun01@kylinos.cn>

In vgic_its_create(), if vgic_its_set_abi() fails after allocating the
its structure and setting kvm state, the allocated 'its' is leaked
because the function returns without freeing it.

Fix by rolling back the kvm state flags and freeing the its structure
when vgic_its_set_abi() returns an error.

Fixes: 71afe470e20d ("KVM: arm64: vgic-its: Introduce migration ABI infrastructure")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 arch/arm64/kvm/vgic/vgic-its.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 1d7e5d560af4..83718eab4e06 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1878,8 +1878,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	INIT_LIST_HEAD(&its->collection_list);
 	xa_init(&its->translation_cache);
 
-	dev->kvm->arch.vgic.msis_require_devid = true;
-	dev->kvm->arch.vgic.has_its = true;
 	its->enabled = false;
 	its->dev = dev;
 
@@ -1887,15 +1885,21 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 		((u64)GITS_BASER_TYPE_DEVICE << GITS_BASER_TYPE_SHIFT);
 	its->baser_coll_table = INITIAL_BASER_VALUE |
 		((u64)GITS_BASER_TYPE_COLLECTION << GITS_BASER_TYPE_SHIFT);
-	dev->kvm->arch.vgic.propbaser = INITIAL_PROPBASER_VALUE;
-
-	dev->private = its;
 
 	ret = vgic_its_set_abi(its, NR_ITS_ABIS - 1);
+	if (ret) {
+		mutex_unlock(&dev->kvm->arch.config_lock);
+		kfree(its);
+		return ret;
+	}
 
-	mutex_unlock(&dev->kvm->arch.config_lock);
+	dev->kvm->arch.vgic.msis_require_devid = true;
+	dev->kvm->arch.vgic.has_its = true;
+	dev->kvm->arch.vgic.propbaser = INITIAL_PROPBASER_VALUE;
+	dev->private = its;
 
-	return ret;
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	return 0;
 }
 
 static void vgic_its_destroy(struct kvm_device *kvm_dev)
-- 
2.54.0

