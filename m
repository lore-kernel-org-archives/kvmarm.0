Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933BE314B6E
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797849; cv=none; b=FGvhtahOcUryC1/qgXAucKQJ+VDjvWlBQ3BApFJDnFzDuCgo384EHrZLkA3kMd9WplcvDbDxKJhUFceahb2mKWGa2VRB4gC9AvgK7gHNCoT6PJLlOX8HwJ7goQHNi5Y1Y0NJ6IobHfzxX4rL4tGZAUEDz6eOc/ks8XxEorU9Vfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797849; c=relaxed/simple;
	bh=rM/qb4gw46Qqf9cHzz1C3xGmiBkv/MNy4YRJ4Y9Y62g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sopuZhr+YcjCxpvLbYLcxYbf8Rrhox8tw/XsIh9CV+fm4QsSfioe6wicP7ediiHIv7vsOY9Q9U0kQVoZeQUpP9ILSGiD2DLN+O1jiH5lbovE6YEUKkJPBJxSZ0lrARHvzWvrPB71TuwVnkMavt3hbhq0lKzKtx/2gbBlavv1kmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SZBO9HAU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SZBO9HAU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58BF848FF;
	Thu, 18 Jun 2026 08:50:42 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CD273F62B;
	Thu, 18 Jun 2026 08:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781797847; bh=rM/qb4gw46Qqf9cHzz1C3xGmiBkv/MNy4YRJ4Y9Y62g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SZBO9HAUs+HPcU3jlkrcip4mKA0xhRLTnJ4I989g59/LF4O5wO2TCsInqFTfsLPki
	 KWndm8tn11x/PszkDwoZxq81NHVoZ93+zgeYSzJAydcSK6KHzkDFbNFiRp2/C4TOJg
	 Ak/gWWEVf5IiWIN8kVyOUMD/+ihMWQ2/ZRBuRabs=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oupton@kernel.org,
	jean-philippe.brucker@arm.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool v2 7/7] arm64: Improve KVM_ARM_VCPU_PMU_V3_CTRL diagnostics
Date: Thu, 18 Jun 2026 16:50:01 +0100
Message-ID: <20260618155001.226266-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618155001.226266-1-alexandru.elisei@arm.com>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvmtool issues several ioctls when configuring the PMU, and each of them
can fail for different reasons. Be more specific about the ioctl that
failed when that happens.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm64/pmu.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/arm64/pmu.c b/arm64/pmu.c
index 92cacd62479e..78c15f153fad 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -12,6 +12,24 @@
 
 #include "asm/pmu.h"
 
+static const char *pmu_attr_names[] = {
+	[KVM_ARM_VCPU_PMU_V3_IRQ]	= "KVM_ARM_VCPU_PMU_V3_IRQ",
+	[KVM_ARM_VCPU_PMU_V3_INIT]	= "KVM_ARM_VCPU_PMU_V3_INIT",
+	[KVM_ARM_VCPU_PMU_V3_FILTER]	= "KVM_ARM_VCPU_PMU_V3_FILTER",
+	[KVM_ARM_VCPU_PMU_V3_SET_PMU]	= "KVM_ARM_VCPU_PMU_V3_SET_PMU",
+	[KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS] = "KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTER",
+};
+
+static const char *pmu_get_attr_name(u64 attr)
+{
+	switch (attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ ... KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+		return pmu_attr_names[attr];
+	default:
+		return "UNKNOWN";
+	}
+}
+
 static bool pmu_has_attr(struct kvm_cpu *vcpu, u64 attr)
 {
 	struct kvm_device_attr pmu_attr = {
@@ -32,13 +50,12 @@ static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
 	};
 	int ret;
 
-	if (pmu_has_attr(vcpu, attr)) {
-		ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
-		if (ret)
-			die_perror("PMU KVM_SET_DEVICE_ATTR");
-	} else {
-		die_perror("PMU KVM_HAS_DEVICE_ATTR");
-	}
+	if (!pmu_has_attr(vcpu, attr))
+		die_perror("KVM_HAS_DEVICE_ATTR(%s)", pmu_get_attr_name(attr));
+
+	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
+	if (ret)
+		die_perror("KVM_SET_DEVICE_ATTR(%s)", pmu_get_attr_name(attr));
 }
 
 #define SYS_EVENT_SOURCE	"/sys/bus/event_source/devices/"
-- 
2.54.0

