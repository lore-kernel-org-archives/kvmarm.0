Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C22D4F3912
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660209; cv=none; b=GPZJjOgFi01ry6vNk4D/2nmTPBdTdabc0C38/oGDfWINMZ5uXefdsCjj3NoLaC4r33sFroBSuHEBT7USSeIioKhDrPKd2Pfz+P2cFQD0SikurhtBn1uoyefwH7EJTiNJtjFxPxfOrwlPdzmwJZf15e4PXh+01QzEcOjpVFFPlmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660209; c=relaxed/simple;
	bh=Y+WAhNdJhbgyJ+wetEYORxE9hRaKg6woWRaKFt4pY+0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPDBWsu8Dej8DgGuwtaiWpgs4HxaGBcRBYBDvKutEf1Dn4l3RtQJLKwRbrIgggd2Vh0KWevSPTkcb60ya8ktiXfpDgduvJu2VvPJFSDsf+zM8O/VxV3We8OWdwXUcbqjz0FKpkTns3xSi0242VdtmR+DmcuUPAl+0NEsXNQ/JOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z9CUTph2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z9CUTph2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BE861596;
	Thu, 17 Sep 2026 08:49:50 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 181ED3FAF5;
	Thu, 17 Sep 2026 08:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789660193; bh=Y+WAhNdJhbgyJ+wetEYORxE9hRaKg6woWRaKFt4pY+0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Z9CUTph21YGv5I1DbJ14S+bn2vY2OisXJwdCvVyFDhcPMITMEPjdn1kxCHU/iNRSR
	 wUtRhSOgzztzvSMq0oTCUBUotNOtPPSt2OSzxMQq6gU2fY2wJ1TtXzvCVG6LJn0n02
	 tdRzodyagqrnqZ6k5+Wx8o2L3XMxpOjK/aIZEU44=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool 1/7] arm64: Pass the number of elements as the first argument to calloc()
Date: Thu, 17 Sep 2026 16:49:26 +0100
Message-ID: <20260917154932.193943-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917154932.193943-1-alexandru.elisei@arm.com>
References: <20260917154932.193943-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

man 3 calloc is pretty clear that the first argument to calloc() is the
number of elements to be allocated, and the second argument is the size
of one element. Fix the instances where the order was inversed.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm64/kvm.c | 2 +-
 arm64/pmu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm64/kvm.c b/arm64/kvm.c
index 36b3284e4a92..cdd673542aea 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -454,7 +454,7 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 
 	kvm->cfg.arch.vcpu_affinity = cpulist;
 
-	cpumask = calloc(1, cpumask_size());
+	cpumask = calloc(cpumask_size(), 1);
 	if (!cpumask)
 		die_perror("calloc");
 
diff --git a/arm64/pmu.c b/arm64/pmu.c
index ef7faca1b71d..49d58ddd529b 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -192,7 +192,7 @@ static int find_pmu(struct kvm *kvm)
 	cpumask_t *cpumask;
 	int i, this_cpu;
 
-	cpumask = calloc(1, cpumask_size());
+	cpumask = calloc(cpumask_size(), 1);
 	if (!cpumask)
 		die_perror("calloc");
 
-- 
2.55.0

