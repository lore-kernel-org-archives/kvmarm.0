Received: from out-33.mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A08F319A2
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 16:34:40 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687278878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7LsBlJpEo/pL35RJaUEfDLyTFgkAssLIgdkLLp5+e7w=;
	b=G0kbisjEwYx7pKoZomjnlMaNhNdwhq9scghFhxPHvmFzVaGleKQxZR8aszhljHL2tBc5WE
	wFhMSRAP4zg/5THj6xFBbaF4XLhCqMt36m+bk1aW16R6OVKUKO4URVSYClHxIS0wukPFIp
	GRCLPIs0LrTNyBEfC+RSwrMrVCUvcm4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 12/20] aarch64: Add support for finding vCPU for given MPIDR
Date: Tue, 20 Jun 2023 11:33:45 -0500
Message-ID: <20230620163353.2688567-13-oliver.upton@linux.dev>
In-Reply-To: <20230620163353.2688567-1-oliver.upton@linux.dev>
References: <20230620163353.2688567-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Some PSCI calls take an MPIDR affinity as an argument. Add a helper to
get the vCPU that matches an MPIDR so we can find the intended
recipient.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-arch.h |  1 +
 arm/aarch64/kvm.c                  | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 0d3b169..dacbc92 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -6,6 +6,7 @@
 struct kvm;
 unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
 int kvm__arch_get_ipa_limit(struct kvm *kvm);
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr);
 
 #define MAX_PAGE_SIZE	SZ_64K
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 848e690..4929ce4 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -1,4 +1,5 @@
 #include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
 
 #include <asm/image.h>
 
@@ -165,3 +166,18 @@ void __kvm__arm_init(struct kvm *kvm)
 {
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
-- 
2.41.0.162.gfafddb0af9-goog

