Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3E13DEACF
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880672; cv=none; b=i0cClXt3liDVIF1UNoG0NzIlL5fAoZ+iiQfxD62sL4hFhg2qLWZlJZRKtoa8j5jqvGdARoldvws//WIk/hcwOVHO+MnToqhYYKKnKAn0lGSWf4tf4ObSrfNSgy9UKYwp0suO+TmuH6MLrfwx5188UI8mab+sa1sZ/5QJoAZ7FdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880672; c=relaxed/simple;
	bh=btyywYT33i0Lf9IQcTmns7XcT2/j2rYyQM4kWBIrhUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQYZFqB1SlpDcEQiMSzYl14MR8sqHiEYz1AwxVr4nZ16kngLXHDFouRALSTSIpWvuqVag1x81/pDb+AvYjT1w88oB8P/pqrRpm07mJyHplLRQe1cBxUsJ/hlyFOb6mBJavfEvp2AMi3eA3RSL2dNryFvZClGbiC41xxb353YrQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EAA36QMk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EAA36QMk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AA8D4515;
	Mon, 30 Mar 2026 07:24:24 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A80303F915;
	Mon, 30 Mar 2026 07:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880670; bh=btyywYT33i0Lf9IQcTmns7XcT2/j2rYyQM4kWBIrhUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAA36QMk5sjUmxsRfM8VyYonNIzqXtESdGFDdyGD4vJ2wcAGVpMOe4XPopd3B6Anc
	 /nmqbCaSgDwJgFNQTq2oCv0PWNiCwupIPMHyyXPKvJt1y8N9mUb53ak447aSmMD2I6
	 TP5x2cnIyhxAr4RGdwKAUSwWTQtSHvnz4sMQ5tvA=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 10/17] arm64: Add support for finding vCPU for given MPIDR
Date: Mon, 30 Mar 2026 15:23:27 +0100
Message-ID: <20260330142334.3309961-11-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Some PSCI calls take an MPIDR affinity as an argument. Add a helper to
get the vCPU that matches an MPIDR so we can find the intended
recipient.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-arch.h |  2 ++
 arm64/kvm.c                  | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index 8f508ef8..a50e6a4f 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -114,4 +114,6 @@ struct kvm_arch {
 	cpu_set_t *vcpu_affinity_cpuset;
 };
 
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr);
+
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 23b4dab1..41c47b13 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -5,6 +5,7 @@
 #include "kvm/virtio-console.h"
 #include "kvm/fdt.h"
 #include "kvm/gic.h"
+#include "kvm/kvm-cpu.h"
 
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
@@ -128,6 +129,22 @@ void kvm__arch_init(struct kvm *kvm)
 	kvm__arch_enable_mte(kvm);
 }
 
+
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr)
+{
+	int i;
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_cpu *tmp = kvm->cpus[i];
+		u64 mpidr = kvm_cpu__get_vcpu_mpidr(tmp) & ARM_MPIDR_HWID_BITMASK;
+
+		if (mpidr == target_mpidr)
+			return tmp;
+	}
+
+	return NULL;
+}
+
 static u64 kvm__arch_get_payload_region_size(struct kvm *kvm)
 {
 	if (kvm->cfg.arch.aarch32_guest)
-- 
2.43.0

