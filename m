Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65C316D4DC
	for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 17:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713980416; cv=none; b=e7qeyw7BtrWOkZNMBFVquJP+D+y0OVAnmINf0RYomlTADawYNUfoKxGw/cFRedJ9o2Y4uEHVb2p+NQG5z/0kxtYk75ivBFG7a4c+SYGDrapHS3k8IvO2NSKnjvx6kYS7x0Jqdlg1bZ1YRp6OkA8DyS9GQ/gl2FqgSGp+0fent3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713980416; c=relaxed/simple;
	bh=9FyrcmkOtAhhYqm/Oj7IunlVZtkl4DQgyQew8AYn1ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk2bDLTzInJqNXoSCz+u34t+4v7eEvm0w7xiSxI/lrNaXZ1D1TWgXoFTtRXfZM93WGpLhQUFI10voGHvanady2NpxmptLpgPdmCm+sWfvYyjU+zG57eG8fLoriLl/VpHNr7+pQ9g3Grg/vRRzAai0CAviG/abfEpkikTQOECTUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SzLQvyn5; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SzLQvyn5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713980412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYclyGsafyW+VbguOcIiGpIKqaEvuvieOXH+NNK/rbo=;
	b=SzLQvyn5912aSivKA5JvFM00Jlndye94iIGMiJfQ3whF9zJMMIhf0mtgNJJ18hAWohratQ
	iXTN1RxrYrXP2sNnx8kJSHLcQLQSZkwKoSA0/VY9ZlZr7I2Lx2olHiQEa7o200xx6FJXy2
	UaRAuPL1I0vl+PNDJXp9fN7i2bLxe8U=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
Date: Wed, 24 Apr 2024 17:39:58 +0000
Message-ID: <20240424173959.3776798-2-oliver.upton@linux.dev>
In-Reply-To: <20240424173959.3776798-1-oliver.upton@linux.dev>
References: <20240424173959.3776798-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

vgic_v2_parse_attr() is responsible for finding the vCPU that matches
the user-provided CPUID, which (of course) may not be valid. If the ID
is invalid, kvm_get_vcpu_by_id() returns NULL, which isn't handled
gracefully.

Similar to the GICv3 uaccess flow, check that kvm_get_vcpu_by_id()
actually returns something and fail the ioctl if not.

Cc: stable@vger.kernel.org
Fixes: 7d450e282171 ("KVM: arm/arm64: vgic-new: Add userland access to VGIC dist registers")
Reported-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f48b8dab8b3d..1d26bb5b02f4 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -338,12 +338,12 @@ int kvm_register_vgic_device(unsigned long type)
 int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 		       struct vgic_reg_attr *reg_attr)
 {
-	int cpuid;
+	int cpuid = FIELD_GET(KVM_DEV_ARM_VGIC_CPUID_MASK, attr->attr);
 
-	cpuid = FIELD_GET(KVM_DEV_ARM_VGIC_CPUID_MASK, attr->attr);
-
-	reg_attr->vcpu = kvm_get_vcpu_by_id(dev->kvm, cpuid);
 	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+	reg_attr->vcpu = kvm_get_vcpu_by_id(dev->kvm, cpuid);
+	if (!reg_attr->vcpu)
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.44.0.769.g3c40516874-goog

