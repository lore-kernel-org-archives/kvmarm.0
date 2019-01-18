From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 08/12] arm64: [HACK] Basic SVE support
Date: Fri, 18 Jan 2019 16:14:17 +0000
Message-ID: <1547828061-20462-9-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 175064A3D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VBNpCivSpiBU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C62794A3BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:32 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

For compatibility reasons, new vcpus created by KVM always have SVE
disabled by default.

To enable SVE to be turned on, this patch adds an option --sve.

Currently, no independent control is added per-vcpu.  This means
that it is not currently possible to create a VM containing a mix
of SVE-enabled and non-SVE-enabled vcpus.  This functionality could
be added later if desired.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h | 2 ++
 arm/aarch64/include/kvm/kvm-cpu-arch.h    | 3 ++-
 arm/include/arm-common/kvm-config-arch.h  | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index cb3f8bc..7710f14 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -6,6 +6,8 @@
 			"Run AArch32 guest"),				\
 	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
 			"Create PMUv3 device"),				\
+	OPT_BOOLEAN('\0', "sve", &(cfg)->has_sve,			\
+		    "Enable SVE for the guest"),			\
 	OPT_BOOLEAN('\0', "show-reg-list", &(cfg)->show_reg_list,	\
 		    "Show the list of KVM register IDs on startup"),	\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index a9d8563..6aeddde 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -8,7 +8,8 @@
 #define ARM_VCPU_FEATURE_FLAGS(kvm, cpuid)	{				\
 	[0] = ((!!(cpuid) << KVM_ARM_VCPU_POWER_OFF) |				\
 	       (!!(kvm)->cfg.arch.aarch32_guest << KVM_ARM_VCPU_EL1_32BIT) |	\
-	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3))		\
+	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3) |		\
+	       (!!(kvm)->cfg.arch.has_sve << KVM_ARM_VCPU_SVE))			\
 }
 
 #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index f18bfd4..6abb170 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -9,6 +9,7 @@ struct kvm_config_arch {
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
+	bool		has_sve;
 	bool		show_reg_list;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
-- 
2.1.4
