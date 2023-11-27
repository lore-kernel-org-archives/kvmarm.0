Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8528F19463
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C567C2F4;
	Mon, 27 Nov 2023 03:18:59 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC2A63F73F;
	Mon, 27 Nov 2023 03:18:10 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v6 11/12] KVM: selftests: arm64: Determine max ipa size per-page size
Date: Mon, 27 Nov 2023 11:17:36 +0000
Message-Id: <20231127111737.1897081-12-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231127111737.1897081-1-ryan.roberts@arm.com>
References: <20231127111737.1897081-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We are about to add 52 bit PA guest modes for 4K and 16K pages when the
system supports LPA2. In preparation beef up the logic that parses mmfr0
to also tell us what the maximum supported PA size is for each page
size. Max PA size = 0 implies the page size is not supported at all.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  4 +-
 .../selftests/kvm/include/guest_modes.h       |  4 +-
 .../selftests/kvm/lib/aarch64/processor.c     | 30 ++++++++++--
 tools/testing/selftests/kvm/lib/guest_modes.c | 48 ++++++++-----------
 4 files changed, 50 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c42d683102c7..cf20e44e86f2 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -119,8 +119,8 @@ enum {
 /* Access flag update enable/disable */
 #define TCR_EL1_HA		(1ULL << 39)
 
-void aarch64_get_supported_page_sizes(uint32_t ipa,
-				      bool *ps4k, bool *ps16k, bool *ps64k);
+void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
+					uint32_t *ipa16k, uint32_t *ipa64k);
 
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/include/guest_modes.h b/tools/testing/selftests/kvm/include/guest_modes.h
index b691df33e64e..63f5167397cc 100644
--- a/tools/testing/selftests/kvm/include/guest_modes.h
+++ b/tools/testing/selftests/kvm/include/guest_modes.h
@@ -11,8 +11,8 @@ struct guest_mode {
 
 extern struct guest_mode guest_modes[NUM_VM_MODES];
 
-#define guest_mode_append(mode, supported, enabled) ({ \
-	guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
+#define guest_mode_append(mode, enabled) ({ \
+	guest_modes[mode] = (struct guest_mode){ (enabled), (enabled) }; \
 })
 
 void guest_modes_append_default(void);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6fe12e985ba5..e6ffd9037c37 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -492,12 +492,24 @@ uint32_t guest_get_vcpuid(void)
 	return read_sysreg(tpidr_el1);
 }
 
-void aarch64_get_supported_page_sizes(uint32_t ipa,
-				      bool *ps4k, bool *ps16k, bool *ps64k)
+static uint32_t max_ipa_for_page_size(uint32_t vm_ipa, uint32_t gran,
+				uint32_t not_sup_val, uint32_t ipa52_min_val)
+{
+	if (gran == not_sup_val)
+		return 0;
+	else if (gran >= ipa52_min_val && vm_ipa >= 52)
+		return 52;
+	else
+		return min(vm_ipa, 48U);
+}
+
+void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
+					uint32_t *ipa16k, uint32_t *ipa64k)
 {
 	struct kvm_vcpu_init preferred_init;
 	int kvm_fd, vm_fd, vcpu_fd, err;
 	uint64_t val;
+	uint32_t gran;
 	struct kvm_one_reg reg = {
 		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
 		.addr	= (uint64_t)&val,
@@ -518,9 +530,17 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
 	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
 
-	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val) != 0xf;
-	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val) == 0;
-	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val) != 0;
+	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val);
+	*ipa4k = max_ipa_for_page_size(ipa, gran, ID_AA64MMFR0_EL1_TGRAN4_NI,
+					ID_AA64MMFR0_EL1_TGRAN4_52_BIT);
+
+	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val);
+	*ipa64k = max_ipa_for_page_size(ipa, gran, ID_AA64MMFR0_EL1_TGRAN64_NI,
+					ID_AA64MMFR0_EL1_TGRAN64_IMP);
+
+	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val);
+	*ipa16k = max_ipa_for_page_size(ipa, gran, ID_AA64MMFR0_EL1_TGRAN16_NI,
+					ID_AA64MMFR0_EL1_TGRAN16_52_BIT);
 
 	close(vcpu_fd);
 	close(vm_fd);
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 1df3ce4b16fd..772a7dd15db4 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -14,37 +14,31 @@ struct guest_mode guest_modes[NUM_VM_MODES];
 void guest_modes_append_default(void)
 {
 #ifndef __aarch64__
-	guest_mode_append(VM_MODE_DEFAULT, true, true);
+	guest_mode_append(VM_MODE_DEFAULT, true);
 #else
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-		bool ps4k, ps16k, ps64k;
+		uint32_t ipa4k, ipa16k, ipa64k;
 		int i;
 
-		aarch64_get_supported_page_sizes(limit, &ps4k, &ps16k, &ps64k);
+		aarch64_get_supported_page_sizes(limit, &ipa4k, &ipa16k, &ipa64k);
 
-		vm_mode_default = NUM_VM_MODES;
+		guest_mode_append(VM_MODE_P52V48_64K, ipa64k >= 52);
 
-		if (limit >= 52)
-			guest_mode_append(VM_MODE_P52V48_64K, ps64k, ps64k);
-		if (limit >= 48) {
-			guest_mode_append(VM_MODE_P48V48_4K, ps4k, ps4k);
-			guest_mode_append(VM_MODE_P48V48_16K, ps16k, ps16k);
-			guest_mode_append(VM_MODE_P48V48_64K, ps64k, ps64k);
-		}
-		if (limit >= 40) {
-			guest_mode_append(VM_MODE_P40V48_4K, ps4k, ps4k);
-			guest_mode_append(VM_MODE_P40V48_16K, ps16k, ps16k);
-			guest_mode_append(VM_MODE_P40V48_64K, ps64k, ps64k);
-			if (ps4k)
-				vm_mode_default = VM_MODE_P40V48_4K;
-		}
-		if (limit >= 36) {
-			guest_mode_append(VM_MODE_P36V48_4K, ps4k, ps4k);
-			guest_mode_append(VM_MODE_P36V48_16K, ps16k, ps16k);
-			guest_mode_append(VM_MODE_P36V48_64K, ps64k, ps64k);
-			guest_mode_append(VM_MODE_P36V47_16K, ps16k, ps16k);
-		}
+		guest_mode_append(VM_MODE_P48V48_4K, ipa4k >= 48);
+		guest_mode_append(VM_MODE_P48V48_16K, ipa16k >= 48);
+		guest_mode_append(VM_MODE_P48V48_64K, ipa64k >= 48);
+
+		guest_mode_append(VM_MODE_P40V48_4K, ipa4k >= 40);
+		guest_mode_append(VM_MODE_P40V48_16K, ipa16k >= 40);
+		guest_mode_append(VM_MODE_P40V48_64K, ipa64k >= 40);
+
+		guest_mode_append(VM_MODE_P36V48_4K, ipa4k >= 36);
+		guest_mode_append(VM_MODE_P36V48_16K, ipa16k >= 36);
+		guest_mode_append(VM_MODE_P36V48_64K, ipa64k >= 36);
+		guest_mode_append(VM_MODE_P36V47_16K, ipa16k >= 36);
+
+		vm_mode_default = ipa4k >= 40 ? VM_MODE_P40V48_4K : NUM_VM_MODES;
 
 		/*
 		 * Pick the first supported IPA size if the default
@@ -72,7 +66,7 @@ void guest_modes_append_default(void)
 		close(kvm_fd);
 		/* Starting with z13 we have 47bits of physical address */
 		if (info.ibc >= 0x30)
-			guest_mode_append(VM_MODE_P47V64_4K, true, true);
+			guest_mode_append(VM_MODE_P47V64_4K, true);
 	}
 #endif
 #ifdef __riscv
@@ -80,9 +74,9 @@ void guest_modes_append_default(void)
 		unsigned int sz = kvm_check_cap(KVM_CAP_VM_GPA_BITS);
 
 		if (sz >= 52)
-			guest_mode_append(VM_MODE_P52V48_4K, true, true);
+			guest_mode_append(VM_MODE_P52V48_4K, true);
 		if (sz >= 48)
-			guest_mode_append(VM_MODE_P48V48_4K, true, true);
+			guest_mode_append(VM_MODE_P48V48_4K, true);
 	}
 #endif
 }
-- 
2.25.1

