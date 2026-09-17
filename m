Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3804ABBC7
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660200; cv=none; b=t4Bq3U4f9KKutGSa5e02yGxOrk+pHS3pwGR75SBEH563FSw98+ROJ7M+h0Z1kSp26ZeTVWyftXUn2e9IS1QI0af7AOxGlNNG6o63WOUR8cP/hXkd+ja9OWei21ttsWmbqc+bIdHiOF2dEyYShRIQ6YyFXcFAJBMeAOoEPLSvJdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660200; c=relaxed/simple;
	bh=7sqR+1Z/fJAou2PRLS/FpDCcUcqzxktOKzSP5jajxKE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kfg8/JNdmEG8TIhGbwMNODKLADkzDBKg7FGyRhtdzWNm5V4gHZNb1ozOWK9L4Ai3aOKCJ3M6gydqZ3UmiNOcFJJ4z21gCdg/E2+cOMvpSHFiRnQF93m2f0pRIYnzomhk2bTZ9ZGP4McCDFeA01FxYQydBv0zhaN76EX1oQXoit0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NJXJks/Q; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NJXJks/Q"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05B331AED;
	Thu, 17 Sep 2026 08:49:52 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1C753F7B4;
	Thu, 17 Sep 2026 08:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789660195; bh=7sqR+1Z/fJAou2PRLS/FpDCcUcqzxktOKzSP5jajxKE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NJXJks/QzNPAg8o/kiW0WP7OkbIC3tLvBwIXPD8xNeyyh3vS+49ZsPrvqsuHi39K2
	 +pzlTbePYIRQdZxsiqCYyVRa/wQBwjcaOal+2/kvba6HwkD6dZgTaz/5DG392k/hJ6
	 ZWqL7GsmN7HvnBpiCYj87607s7EnnRUpqxqcjCrs=
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
Subject: [PATCH kvmtool 2/7] arm64: Consistently treat vcpu_affinity_cpuset as dynamically allocated
Date: Thu, 17 Sep 2026 16:49:27 +0100
Message-ID: <20260917154932.193943-3-alexandru.elisei@arm.com>
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

man 3 CPU_ALLOC says that for dynamically allocated cpusets, one should use
the *_S macros to manipulate the cpuset, and the example program also
demonstrates this. Use CPU_SET_S and CPU_ISSET_S to comply.

Fixes: 4639b72f61a3 ("arm64: Add --vcpu-affinity command line argument")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm64/kvm.c | 6 ++++--
 arm64/pmu.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arm64/kvm.c b/arm64/kvm.c
index cdd673542aea..5f3ed9f6d201 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -450,6 +450,7 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 	struct kvm *kvm = opt->ptr;
 	const char *cpulist = arg;
 	cpumask_t *cpumask;
+	size_t setsize;
 	int cpu, ret;
 
 	kvm->cfg.arch.vcpu_affinity = cpulist;
@@ -467,10 +468,11 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 	kvm->arch.vcpu_affinity_cpuset = CPU_ALLOC(NR_CPUS);
 	if (!kvm->arch.vcpu_affinity_cpuset)
 		die_perror("CPU_ALLOC");
-	CPU_ZERO_S(CPU_ALLOC_SIZE(NR_CPUS), kvm->arch.vcpu_affinity_cpuset);
 
+	setsize = CPU_ALLOC_SIZE(NR_CPUS);
+	CPU_ZERO_S(setsize, kvm->arch.vcpu_affinity_cpuset);
 	for_each_cpu(cpu, cpumask)
-		CPU_SET(cpu, kvm->arch.vcpu_affinity_cpuset);
+		CPU_SET_S(cpu, setsize, kvm->arch.vcpu_affinity_cpuset);
 
 	return 0;
 }
diff --git a/arm64/pmu.c b/arm64/pmu.c
index 49d58ddd529b..e5a07abcd317 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -191,6 +191,7 @@ static int find_pmu(struct kvm *kvm)
 {
 	cpumask_t *cpumask;
 	int i, this_cpu;
+	size_t setsize;
 
 	cpumask = calloc(cpumask_size(), 1);
 	if (!cpumask)
@@ -202,8 +203,9 @@ static int find_pmu(struct kvm *kvm)
 			return -errno;
 		cpumask_set_cpu(this_cpu, cpumask);
 	} else {
-		for (i = 0; i < CPU_SETSIZE; i ++) {
-			if (CPU_ISSET(i, kvm->arch.vcpu_affinity_cpuset))
+		setsize = CPU_ALLOC_SIZE(NR_CPUS);
+		for (i = 0; i < NR_CPUS; i ++) {
+			if (CPU_ISSET_S(i, setsize, kvm->arch.vcpu_affinity_cpuset))
 				cpumask_set_cpu(i, cpumask);
 		}
 	}
-- 
2.55.0

