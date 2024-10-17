Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D1D23A6
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 00:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729124402; cv=none; b=IpuHxtCpu6CrSksC/ydAwDighcK7oYsCRO6/2Edk7XHL20dhBzTN9eg0CJKFR3BsCtJy+IopLYPpSMMewAan3DIXjsLviYJH7s7ExLwI8PGQ5u4IYpePKncO7GkrY+KWBnbMFJWgL3b4JpD8xrN1kQhp1wwBrqm7Ky3KyKNMd/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729124402; c=relaxed/simple;
	bh=Rwgh83VbrrB8XtIJsFmQ0uwK+g4e/VmwzNp5TI+Ir4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf1htbxFdFZ0dI+cpgmfvp81fVs36nr+n5C8U/xBxyh27a48k0b5bwi4/ryhtxMejrY+/I80r4aZyqlZ/LFNdXQ/r1/vJQSbcyxOXsmXDEIg4ZhvPxp/T9e3Qj7oQiw4V0e55DF1jMSsFAcg8DHd8a+eOCz3W/ptTD7wEMuFJEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bMD9418w; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bMD9418w"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729124398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+JT14a+z9Hy+WbUOzEZ9JfUBH4VfY+TZHfRTt4KCQLU=;
	b=bMD9418w94xSZDs7c7uHeybFWj1bHYMVkNo4w/wjsFQIXh8GUehMhy9AfuIPxxhGGT8H/U
	Q2ueMegj/Da5ndtQy2e8mbQzsDNqxhmgvzfSL+092y/zkYz2HV09JkXqZlbKxJQyBXoHQv
	tJCLr1XLesKZ6w6D1oxMVI8S4RAQL4g=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: vgic: Don't check for vgic_ready() when setting NR_IRQS
Date: Thu, 17 Oct 2024 00:19:46 +0000
Message-ID: <20241017001947.2707312-2-oliver.upton@linux.dev>
In-Reply-To: <20241017001947.2707312-1-oliver.upton@linux.dev>
References: <20241017001947.2707312-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM commits to a particular sizing of SPIs when the vgic is initialized,
which is before the point a vgic becomes ready. On top of that, KVM
supplies a default amount of SPIs should userspace not explicitly
configure this.

As such, the check for vgic_ready() in the handling of
KVM_DEV_ARM_VGIC_GRP_NR_IRQS is completely wrong, and testing if nr_spis
is nonzero is sufficient for preventing userspace from playing games
with us.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 1d26bb5b02f4..5f4f57aaa23e 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -236,7 +236,12 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 
 		mutex_lock(&dev->kvm->arch.config_lock);
 
-		if (vgic_ready(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
+		/*
+		 * Either userspace has already configured NR_IRQS or
+		 * the vgic has already been initialized and vgic_init()
+		 * supplied a default amount of SPIs.
+		 */
+		if (dev->kvm->arch.vgic.nr_spis)
 			ret = -EBUSY;
 		else
 			dev->kvm->arch.vgic.nr_spis =
-- 
2.47.0.rc1.288.g06298d1525-goog

