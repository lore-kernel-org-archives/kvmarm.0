Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2864F391E
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 15:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660209; cv=none; b=hDokEa1sFJkcfip2y0JIjWKAHzEJm/lAAvJrmrRf6TCNLP+iwgFy4lzSGosEOvcI7vkqzVhD9jfi83K3hka0VpF6TZEEIMmcSbMBTZ0jsTo/jnz1XSGkYyEGpIz7RAuiiUB5u2JLlB659QHRWws8sgmkVekrAy1F1WklHMal/aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660209; c=relaxed/simple;
	bh=Lo6AV22VRneWsIefgdLEObQ+PyLMSU+PUdesn29k7vU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCE1YrZT4FO+DbiQPhEUWT8s0fPBV0U/zjh96806Ma8kCzNAyJdkxAxivxGUtmdc+MSnYAac6onSafGHYKDI8Fxf8Tyz+rnaKT1B8So7BAFp/tv+1pcBt0u45HnVu0kIf0oswwXRJV8q/JUnCt2dscSMzW3nCCD3qzmpFFJ54kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HqMQ7y1N; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HqMQ7y1N"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBC221F02;
	Thu, 17 Sep 2026 08:49:53 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5B8D3F7B4;
	Thu, 17 Sep 2026 08:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789660197; bh=Lo6AV22VRneWsIefgdLEObQ+PyLMSU+PUdesn29k7vU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HqMQ7y1NjYYhNLV6P6MSdQ0gKeXAB3leFW40Y01KSRjD6ov9xcgPVxsdlzsUqmS/P
	 TooQLQJwZDxxFT6jvlRFOiyW0aUahgVayPy5Mq/YirIzLr4hbqPia4ydi7vvEyJ/DY
	 aN/vQEaDGYPwO5nCFB5enf8Js0PwQhL11rGtuE8k=
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
Subject: [PATCH kvmtool 3/7] arm64: Free the temporary cpumask in vcpu_affinity_parser()
Date: Thu, 17 Sep 2026 16:49:28 +0100
Message-ID: <20260917154932.193943-4-alexandru.elisei@arm.com>
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

Free the local variable 'cpumask' when the function is successful.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm64/kvm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arm64/kvm.c b/arm64/kvm.c
index 5f3ed9f6d201..88b3622766bf 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -451,7 +451,8 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 	const char *cpulist = arg;
 	cpumask_t *cpumask;
 	size_t setsize;
-	int cpu, ret;
+	int ret = 0;
+	int cpu;
 
 	kvm->cfg.arch.vcpu_affinity = cpulist;
 
@@ -460,10 +461,8 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 		die_perror("calloc");
 
 	ret = cpulist_parse(cpulist, cpumask);
-	if (ret) {
-		free(cpumask);
-		return ret;
-	}
+	if (ret)
+		goto out_free;
 
 	kvm->arch.vcpu_affinity_cpuset = CPU_ALLOC(NR_CPUS);
 	if (!kvm->arch.vcpu_affinity_cpuset)
@@ -474,7 +473,9 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 	for_each_cpu(cpu, cpumask)
 		CPU_SET_S(cpu, setsize, kvm->arch.vcpu_affinity_cpuset);
 
-	return 0;
+out_free:
+	free(cpumask);
+	return ret;
 }
 
 void kvm__arch_validate_cfg(struct kvm *kvm)
-- 
2.55.0

