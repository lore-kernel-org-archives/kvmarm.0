Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83E94EBAD6
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451645; cv=none; b=qYK6bJDHrOnvuy4LawC4UtejhPmL3lyOivyrjngiTivukvImJMojOXNho+ofeXuPSgYzd+M2TVugLYe7OR+5Fg9Qyv+qNuwEFq5WCT+m3uNaNWr8B1W1XsOI029LslZTv4XT4babKZoCJX3ZC0noLIJaDF7WBCEFFxtpxvoTaQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451645; c=relaxed/simple;
	bh=niz3RfvY/d8rpGz6tKQ0HPt0Q34iKw+9wA9OI+1T2WE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLZjaCdmtQUwXORuM7j+S7FMS46MHg4tPMnLaScEZzwXW/MeR0gUK7ekgLrpK5igTbazCk/cTtGlZPnCovKzG5h3swLicGTApAVdkgQKlVrmOoor6xDqZrwk/aIufTykkWkOs3f8yC5dvHwmVS1Xt36xdPvbV8LAK/YbrCesF38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zqa1GL1d; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zqa1GL1d"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B055A1F37;
	Thu,  3 Sep 2026 09:07:19 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A74343F673;
	Thu,  3 Sep 2026 09:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451643; bh=niz3RfvY/d8rpGz6tKQ0HPt0Q34iKw+9wA9OI+1T2WE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Zqa1GL1dezO/KuhlMRK/gjNeNLEyylU+N/sp6G5M4jdHlQ7U3m5MHDjHzAUwHGHHV
	 y1ou2dOoB2yzRlTNiXyVpBOY7GS6JzsdpsbdXfLd+RfruDXG6LG8SWTfvrH4i/eZLR
	 yGO0pTEhqwrVLhXCtkPZ0kx+6EHzddXkMg1MQAmU=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 23/28] KVM: arm64: Add kvm-arm.ignore_spe_errata kernel parameter
Date: Thu,  3 Sep 2026 17:06:18 +0100
Message-ID: <20260903160623.315525-24-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new kernel command line parameter, kvm-arm.ignore_spe_errata with the
effect of ignoring any errata that might inhibit userspace from creating a
SPE enabled virtual machine.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 arch/arm64/kvm/spe.c                            | 10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..2d91ce8e8c4b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3299,6 +3299,9 @@ Kernel parameters
 
 			notrap: clear WFI instruction trap
 
+	kvm-arm.ignore_spe_errata=
+			[KVM,ARM] Ignore SPE errata and expose SPE to guests.
+
 	kvm_cma_resv_ratio=n [PPC,EARLY]
 			Reserves given percentage from system memory area for
 			contiguous memory allocation for KVM hash pagetable
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index ce68789d184b..3e82edc8be85 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -21,8 +21,16 @@ struct spe_pmu_entry {
 	struct arm_spe_pmu *spe_pmu;
 };
 
+static bool ignore_spe_errata;
+
 static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level);
 
+static int __init kvm_ignore_spe_errata(char *arg)
+{
+	return kstrtobool(arg, &ignore_spe_errata);
+}
+early_param("kvm-arm.ignore_spe_errata", kvm_ignore_spe_errata);
+
 void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
 {
 	struct spe_pmu_entry *entry;
@@ -290,7 +298,7 @@ static int kvm_spe_set_spe_id(struct kvm_vcpu *vcpu, int spe_id)
 		return 0;
 	}
 
-	if (spe_pmu->has_workaround_3023823)
+	if (spe_pmu->has_workaround_3023823 && !ignore_spe_errata)
 		return -EINVAL;
 
 	if (!try_module_get(spe_pmu->pmu.module))
-- 
2.43.0

