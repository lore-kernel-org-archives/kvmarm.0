Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77201293A8
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 16:34:33 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687278871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRHUR6r7bsVGmC92d8NE9qfJ1O4+x10SEg6+B1ck4aA=;
	b=Aam2/YdhrWQVnl4nKYZzOGbIOHU5Pv2CM07q2LRwXCJdj5r7LSnKXUnO3VDj2FfwQGdseY
	61QDdI+4FHr6ytRrBQlG+cZSKiDqtOX+lmq7EY1/TRKsu/h5S//8Ew1W7yKqbbDDk73UBJ
	2lQRnUvVw3JD6OA18QNF87Tv/lTtzn4=
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
Subject: [PATCH v2 09/20] aarch64: Expose ARM64_CORE_REG() for general use
Date: Tue, 20 Jun 2023 11:33:42 -0500
Message-ID: <20230620163353.2688567-10-oliver.upton@linux.dev>
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

Expose the macro such that it may be used to get SMCCC arguments in a
future change.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-cpu-arch.h | 16 ++++++++++++++++
 arm/aarch64/kvm-cpu.c                  | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index aeae8c1..264d001 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -11,6 +11,22 @@
 #define ARM_CPU_CTRL		3, 0, 1, 0
 #define ARM_CPU_CTRL_SCTLR_EL1	0
 
+static inline __u64 __core_reg_id(__u64 offset)
+{
+	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
+
+	if (offset < KVM_REG_ARM_CORE_REG(fp_regs))
+		id |= KVM_REG_SIZE_U64;
+	else if (offset < KVM_REG_ARM_CORE_REG(fp_regs.fpsr))
+		id |= KVM_REG_SIZE_U128;
+	else
+		id |= KVM_REG_SIZE_U32;
+
+	return id;
+}
+
+#define ARM64_CORE_REG(x) __core_reg_id(KVM_REG_ARM_CORE_REG(x))
+
 void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init);
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
 int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index c8be10b..1e5a6cf 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -12,22 +12,6 @@
 #define SCTLR_EL1_E0E_MASK	(1 << 24)
 #define SCTLR_EL1_EE_MASK	(1 << 25)
 
-static __u64 __core_reg_id(__u64 offset)
-{
-	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
-
-	if (offset < KVM_REG_ARM_CORE_REG(fp_regs))
-		id |= KVM_REG_SIZE_U64;
-	else if (offset < KVM_REG_ARM_CORE_REG(fp_regs.fpsr))
-		id |= KVM_REG_SIZE_U128;
-	else
-		id |= KVM_REG_SIZE_U32;
-
-	return id;
-}
-
-#define ARM64_CORE_REG(x) __core_reg_id(KVM_REG_ARM_CORE_REG(x))
-
 unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu)
 {
 	struct kvm_one_reg reg;
-- 
2.41.0.162.gfafddb0af9-goog

