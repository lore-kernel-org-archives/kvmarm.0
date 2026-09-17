Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0E04C10C3
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660209; cv=none; b=KsxHELU+EFazJmgqwP8f3aaA+uNscLzOLaABCPqjy3PLLnRjzk3sx2V1Fnv/FNjHbMz4JD5fKIzgfl4T5ULTkbwKPiXgeQmC/p7Cvqt0kVZ/ELdMCGCTSujGqeCT8jlIuHKqKU9ZxicsJeJUPsQ4D+hGu1d4Zjl7jpCV35ugudY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660209; c=relaxed/simple;
	bh=uj9ZhxPtZlaMAJjllPz+XYRBkA3Sgv72c0v1bO+y8ic=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwlNO9pRCbvOGe0zEmMz11VVkVzQ8KQ6YIhEDVmSXBwqTet/meo8mFW1ZYDpUi58w2jK0czGn7NrATPdEh4O67J2r4fnRmOCqd5zukBcZQtXt/pU2O9GP99I3kE/QEg47D+5u2a9LoRlTtriZDpP+5EFsTh6k5cBuP1OCnSXCkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WRfIo66+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WRfIo66+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD2C31F37;
	Thu, 17 Sep 2026 08:49:55 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9FB13F7B4;
	Thu, 17 Sep 2026 08:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789660199; bh=uj9ZhxPtZlaMAJjllPz+XYRBkA3Sgv72c0v1bO+y8ic=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WRfIo66+RNyHDDP73SbOEOHjy7/jhlsevqI2ipFIm7MsCkfLlI8OeXMavfr9VE577
	 4ooAI4aPFjGiwxipG8MK/sXJPVC+lrHlUpfwWulLN/kgulZsNcIylTL2iRndDOrKJT
	 y3XGAXaXL0SQxdB+SM4qbYRrbI5Q4unGPiudwVJY=
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
Subject: [PATCH kvmtool 4/7] arm64/pmu: Consider kvmtool's affinity when searching for a PMU
Date: Thu, 17 Sep 2026 16:49:29 +0100
Message-ID: <20260917154932.193943-5-alexandru.elisei@arm.com>
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

When --vcpu-affinity is set, find_pmu() -> find_pmu_cpumask() attempts to
find a PMU instance that is shared by all CPUs in the specified affinity.

If --vcpu-affinity is not set, find_pmu() will only attempt to find a PMU
instance associated with the *current* physical CPU. This misses the fact
that it might be possible that the other threads that kvmtool creates
(which include the VCPU threads), might be executed on physical CPUs which
have a different PMU instance than the *current* physical CPU (or none at
all). This can lead to hard to reproduce and diagnose errors.

Improve things by teaching find_pmu() to use kvmtool process CPU affinity
when --vcpu-affinity is not set.

Also fix a memory leak by freeing the local variable 'cpumask'.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm64/pmu.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/arm64/pmu.c b/arm64/pmu.c
index e5a07abcd317..d3761689c907 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -189,28 +189,44 @@ out_free:
  */
 static int find_pmu(struct kvm *kvm)
 {
+	cpu_set_t *affinity;
 	cpumask_t *cpumask;
-	int i, this_cpu;
 	size_t setsize;
+	int i, ret = 0;
 
 	cpumask = calloc(cpumask_size(), 1);
 	if (!cpumask)
 		die_perror("calloc");
 
-	if (!kvm->arch.vcpu_affinity_cpuset) {
-		this_cpu = sched_getcpu();
-		if (this_cpu < 0)
-			return -errno;
-		cpumask_set_cpu(this_cpu, cpumask);
+	setsize = CPU_ALLOC_SIZE(NR_CPUS);
+
+	if (kvm->arch.vcpu_affinity_cpuset) {
+		affinity = kvm->arch.vcpu_affinity_cpuset;
 	} else {
-		setsize = CPU_ALLOC_SIZE(NR_CPUS);
-		for (i = 0; i < NR_CPUS; i ++) {
-			if (CPU_ISSET_S(i, setsize, kvm->arch.vcpu_affinity_cpuset))
-				cpumask_set_cpu(i, cpumask);
+		affinity = CPU_ALLOC(NR_CPUS);
+		if (!affinity)
+			die_perror("CPU_ALLOC");
+		CPU_ZERO_S(setsize, affinity);
+
+		ret = sched_getaffinity(0, setsize, affinity);
+		if (ret < 0) {
+			ret = -errno;
+			goto out_free;
 		}
 	}
 
-	return find_pmu_cpumask(kvm, cpumask);
+	for (i = 0; i < NR_CPUS; i ++) {
+		if (CPU_ISSET_S(i, setsize, affinity))
+			cpumask_set_cpu(i, cpumask);
+	}
+
+	ret = find_pmu_cpumask(kvm, cpumask);
+
+out_free:
+	free(cpumask);
+	if (!kvm->arch.vcpu_affinity_cpuset)
+		CPU_FREE(affinity);
+	return ret;
 }
 
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
-- 
2.55.0

