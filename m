Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 385D17464
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 06:58:16 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30548C15;
	Sun, 17 Sep 2023 23:58:53 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CAB23F5A1;
	Sun, 17 Sep 2023 23:58:14 -0700 (PDT)
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
Subject: [PATCH v3 12/13] KVM: selftests: arm64: Determine max ipa size per-page size
Date: Mon, 18 Sep 2023 07:57:39 +0100
Message-Id: <20230918065740.3670662-13-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230918065740.3670662-1-ryan.roberts@arm.com>
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
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

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  4 +-
 .../selftests/kvm/lib/aarch64/processor.c     | 27 ++++++++++---
 tools/testing/selftests/kvm/lib/guest_modes.c | 40 ++++++++-----------
 3 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index cb537253a6b9..9e415cf4f8dd 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -118,8 +118,8 @@ enum {
 /* Access flag update enable/disable */
 #define TCR_EL1_HA		(1ULL << 39)
 
-void aarch64_get_supported_page_sizes(uint32_t ipa,
-				      bool *ps4k, bool *ps16k, bool *ps64k);
+void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
+					uint32_t *ipa16k, uint32_t *ipa64k);
 
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 3a0259e25335..e50dad81e956 100644
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
@@ -518,9 +530,14 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
 	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
 
-	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val) != 0xf;
-	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val) == 0;
-	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16), val) != 0;
+	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val);
+	*ipa4k = max_ipa_for_page_size(ipa, gran, 0xf, 1);
+
+	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val);
+	*ipa64k = max_ipa_for_page_size(ipa, gran, 0xf, 0);
+
+	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16), val);
+	*ipa16k = max_ipa_for_page_size(ipa, gran, 0, 2);
 
 	close(vcpu_fd);
 	close(vm_fd);
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 1df3ce4b16fd..c64c5cf49942 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -18,33 +18,27 @@ void guest_modes_append_default(void)
 #else
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-		bool ps4k, ps16k, ps64k;
+		uint32_t ipa4k, ipa16k, ipa64k;
 		int i;
 
-		aarch64_get_supported_page_sizes(limit, &ps4k, &ps16k, &ps64k);
+		aarch64_get_supported_page_sizes(limit, &ipa4k, &ipa16k, &ipa64k);
 
-		vm_mode_default = NUM_VM_MODES;
+		guest_mode_append(VM_MODE_P52V48_64K, ipa64k >= 52, ipa64k >= 52);
 
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
+		guest_mode_append(VM_MODE_P48V48_4K, ipa4k >= 48, ipa4k >= 48);
+		guest_mode_append(VM_MODE_P48V48_16K, ipa16k >= 48, ipa16k >= 48);
+		guest_mode_append(VM_MODE_P48V48_64K, ipa64k >= 48, ipa16k >= 48);
+
+		guest_mode_append(VM_MODE_P40V48_4K, ipa4k >= 40, ipa4k >= 40);
+		guest_mode_append(VM_MODE_P40V48_16K, ipa16k >= 40, ipa16k >= 40);
+		guest_mode_append(VM_MODE_P40V48_64K, ipa64k >= 40, ipa64k >= 40);
+
+		guest_mode_append(VM_MODE_P36V48_4K, ipa4k >= 36, ipa4k >= 36);
+		guest_mode_append(VM_MODE_P36V48_16K, ipa16k >= 36, ipa16k >= 36);
+		guest_mode_append(VM_MODE_P36V48_64K, ipa64k >= 36, ipa64k >= 36);
+		guest_mode_append(VM_MODE_P36V47_16K, ipa16k >= 36, ipa16k >= 36);
+
+		vm_mode_default = ipa4k >= 40 ? VM_MODE_P40V48_4K : NUM_VM_MODES;
 
 		/*
 		 * Pick the first supported IPA size if the default
-- 
2.25.1

