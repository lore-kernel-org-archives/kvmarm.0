Received: from out-45.mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA63408DE
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:16 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgQ8TUfvr4o7SAUptkm8VLwfes0WAyyuqfpTP12KQcE=;
	b=HVclS8N1TGfnsojpu/DmKc+kotfNdikW6dSsFC4IYWoRmE+zpTc9Rp3YjBBPnO2eL8g0I3
	B4LH3lcFTXMi3VQsBhluMduvY5aOKoj8Ego2wg2tZQH8EZ440oMjg5JkvM1DPXD23KDcKq
	BMrsiQwi8cSHVtIerra2BLa3yBv0XxQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v12 04/11] KVM: arm64: Rewrite IMPDEF PMU version as NI
Date: Fri,  9 Jun 2023 19:00:47 +0000
Message-ID: <20230609190054.1542113-5-oliver.upton@linux.dev>
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM allows userspace to write an IMPDEF PMU version to the corresponding
32bit and 64bit ID register fields for the sake of backwards
compatibility with kernels that lacked commit 3d0dba5764b9 ("KVM: arm64:
PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation"). Plumbing
that IMPDEF PMU version through to the gues is getting in the way of
progress, and really doesn't any sense in the first place.

Bite the bullet and reinterpret the IMPDEF PMU version as NI (0) for
userspace writes. Additionally, spill the dirty details into a comment.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  5 +--
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/sys_regs.c         | 56 +++++++++++++++++++------------
 include/kvm/arm_pmu.h             |  2 +-
 4 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2c8c4ace81ef..44da989435fc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -241,10 +241,7 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
+	u8 dfr0_pmuver;
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 85c978ad1f27..695239e01618 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -168,7 +168,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	 * Initialise the default PMUver before there is a chance to
 	 * create an actual PMU.
 	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
+	kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
 	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 71b12094d613..e1ea7e0da5cd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1177,9 +1177,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
+		return vcpu->kvm->arch.dfr0_pmuver;
 
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+	return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -1384,18 +1384,35 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	bool valid_pmu;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
+	pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
+
+	/*
+	 * Prior to commit 3d0dba5764b9 ("KVM: arm64: PMU: Move the
+	 * ID_AA64DFR0_EL1.PMUver limit to VM creation"), KVM erroneously
+	 * exposed an IMP_DEF PMU to userspace and the guest on systems w/
+	 * non-architectural PMUs. Of course, PMUv3 is the only game in town for
+	 * PMU virtualization, so the IMP_DEF value was rather user-hostile.
+	 *
+	 * At minimum, we're on the hook to allow values that were given to
+	 * userspace by KVM. Cover our tracks here and replace the IMP_DEF value
+	 * with a more sensible NI. The value of an ID register changing under
+	 * the nose of the guest is unfortunate, but is certainly no more
+	 * surprising than an ill-guided PMU driver poking at impdef system
+	 * registers that end in an UNDEF...
+	 */
+	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		pmuver = 0;
+	}
 
 	/*
 	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
-	 * as it doesn't promise more than what the HW gives us. We
-	 * allow an IMPDEF PMU though, only if no PMU is supported
-	 * (KVM backward compatibility handling).
+	 * as it doesn't promise more than what the HW gives us.
 	 */
-	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
-	if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver))
+	if (pmuver > host_pmuver)
 		return -EINVAL;
 
-	valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+	valid_pmu = pmuver;
 
 	/* Make sure view register and PMU support do match */
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
@@ -1407,11 +1424,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
-
+	vcpu->kvm->arch.dfr0_pmuver = pmuver;
 	return 0;
 }
 
@@ -1423,6 +1436,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	bool valid_pmu;
 
 	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
+	perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+
+	if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		perfmon = 0;
+	}
 
 	/*
 	 * Allow DFR0_EL1.PerfMon to be set from userspace as long as
@@ -1430,12 +1449,11 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	 * AArch64 side (as everything is emulated with that), and
 	 * that this is a PMUv3.
 	 */
-	perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), val);
-	if ((perfmon != ID_DFR0_EL1_PerfMon_IMPDEF && perfmon > host_perfmon) ||
+	if (perfmon > host_perfmon ||
 	    (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3))
 		return -EINVAL;
 
-	valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_EL1_PerfMon_IMPDEF);
+	valid_pmu = perfmon;
 
 	/* Make sure view register and PMU support do match */
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
@@ -1447,11 +1465,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
-
+	vcpu->kvm->arch.dfr0_pmuver = perfmon_to_pmuver(perfmon);
 	return 0;
 }
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1a6a695ca67a..0be60d5eebd7 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -93,7 +93,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
  * Evaluates as true when emulating PMUv3p5, and false otherwise.
  */
 #define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+	(vcpu->kvm->arch.dfr0_pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.41.0.162.gfafddb0af9-goog

