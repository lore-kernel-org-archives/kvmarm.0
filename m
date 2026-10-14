Received: from mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B385038ED
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982529; cv=none; b=nH1B0khxa9fxtbFTEqcvnMTBhAcesYyM0Rv4qZtajrsXt315vZnS/LNovtcEOqfcGQ7v1Nj0mZ4rwWtmGRlNfMlmQmgykkeIVoIoc9yVH1ZKzBqt5YfextQOV+DPMLiOlEUzxq5iAw5IpJF+xCybknDAe/6LMalpmwZFDF5OwLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982529; c=relaxed/simple;
	bh=1W+NOG2Vc3f+T8d2kTd9wvETY+8H8YtcVIfzWtcM8hs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pfy3b6rlDVjdrYMOJ1kxoM/O4Gx6N19O6hKh+nA09pVDL/VUwzoGgnBGkEUf0117eGbxpjP0viO1vNPmXmgFPtjsFM9TslcWd+pSpvW3ldHJjgLdGKl7xwCzk0TVOD0nOysBwxKAe/Cd9c5bH7f+GVljxF/5zZvXQDJhqFJy1XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dntljhIZ; arc=none smtp.client-ip=95.215.58.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dntljhIZ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1W+NOG2Vc3f+T8d2kTd9wvETY+8H8YtcVIfzWtcM8hs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791982518; v=1; x=1792587318;
 b=dntljhIZwyLxEF7g2/rFr503mVZCDevPVkqarcveV3KUbbF3t54IaiBuVSEnJVAq0hCTtnC1
 WVmHEIHjDi+rnHey4KyHZWziXvPYZQSSZlQuCAf2veCeJy8vMj1cvXjo5rd5C4PCkWEDA4hRJpy
 rBIMnazP2f87SCL//w4+b4rQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 439495e9f5d2f512;
	Wed, 14 Oct 2026 12:55:14 +0000
X-Mizu-Trace-ID: 439495e9f5d2f512
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Track physical CPU number at EL2
Date: Wed, 14 Oct 2026 13:55:09 +0100
Message-Id: <20261014125510.2928306-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261014125510.2928306-1-fuad.tabba@linux.dev>
References: <20261014125510.2928306-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nVHE hypervisor has no equivalent of smp_processor_id(), so EL2 code
has no index for the CPU it runs on.

Add a hyp per-CPU hyp_cpu_number, which the host writes in
cpu_prepare_hyp_mode() before it's deprivileged, and a
hyp_smp_processor_id() accessor to read it. The next patch uses it to
index per-CPU state in a hyp VM.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hyp.h  | 3 +++
 arch/arm64/kvm/arm.c              | 3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b0e42be3d9eef..6c4169a14b73e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -16,6 +16,9 @@
 DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DECLARE_PER_CPU(int, hyp_cpu_number);
+
+#define hyp_smp_processor_id() (__this_cpu_read(hyp_cpu_number))
 
 /*
  * Unified accessors for registers that have a different encoding
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d593ba9280933..0dd6667f1beea 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -116,6 +116,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DECLARE_KVM_NVHE_PER_CPU(int, hyp_cpu_number);
 
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 
@@ -2351,6 +2352,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 	unsigned long tcr;
 
+	*per_cpu_ptr_nvhe_sym(hyp_cpu_number, cpu) = cpu;
+
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 04d194583f1e4..9fcb92abd0b57 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -8,6 +8,8 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+DEFINE_PER_CPU(int, hyp_cpu_number);
+
 /*
  * nVHE copy of data structures tracking available CPU cores.
  * Only entries for CPUs that were online at KVM init are populated.
-- 
2.39.5

