Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75FB81724
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371079; cv=none; b=p02NdlkEBFKP6co6CHyrO5NAmhEOPMbXxiOeP3EEhykvRTG+FQx3b6OoCuVylNv1hclAfon/tuMRLBva8NWVZYsj53S8Ji3kf/OQFSAosLiO86IwneLZB7/vwHuETQo3eR6AsWmlMjcRT1MgyFa7e/5swbGv2onaGt22ohE3Prg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371079; c=relaxed/simple;
	bh=womlNSebg8YA4nRh21CzpVYFz8+Hr298oHktq30HrIc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OCKjvpe8Ba2Ba7UevODWsb1r9msubfOWsGKkiqnxT5d63JPIQipOO5rJOorj1qLYWBKjNeKCDrx/fhMpGVXamZ3MNBIcU3G4FniP/nlKmcVvDS9erwrEU2Bb7Gs8WmqiIsv1fkk2F8HusduBKNnkQuyhc87NLIV0mntlBzTDT1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=SF7jbX3A; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="SF7jbX3A"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789371076; x=1820907076;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=womlNSebg8YA4nRh21CzpVYFz8+Hr298oHktq30HrIc=;
  b=SF7jbX3ABAtfuFjzuVLXIH/eLbQXu6fNLWk3QAITZv2sspmiKCuJ5PKZ
   uvEsS5Xr9qlmjE4msxiOW1QgZvaUtW/gZEjnV3yWOk6K07YE3VUr2MJbv
   aFQkLAcDAAcmDT4uZWikx8kW+JpPc4CE9SAWAXnwnREpHQDwHFETUwpQ6
   fa/dr1iAo+scRaqvxSbvxxTutYv2uyLncpaFIKZXYqsog5OEAjFawbAXT
   iZ4ge9aZdUTfPfAyD1ZfVlku7GIXpm4t5XKcbRWXwTouRmQfJgntq1bBs
   FNG9Q1q+MuAhM93k2Dn27Q1GDW9AVwveel8fuYYQLEE0UBjWsVYpUi1zo
   A==;
X-CSE-ConnectionGUID: Q4ma951jQpCYdegJYfolsg==
X-CSE-MsgGUID: GUGerIMwQS2L6YGsnNsS3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="253154826"
X-IronPort-AV: E=Sophos;i="6.27,102,1786978800"; 
   d="scan'208";a="253154826"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 16:31:14 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 595CE1C1C714
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:31:14 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 0A3AB8D29E0
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:31:14 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTP id 2ED2718005CF;
	Mon, 14 Sep 2026 07:31:07 +0000 (UTC)
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Date: Mon, 14 Sep 2026 16:30:45 +0900
Subject: [PATCH v2 2/3] KVM: arm64: selftests: Add 52-bit VA guest modes
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-arm64-52bit-va-v2-2-3911cb9d4ad4@fujitsu.com>
References: <20260914-arm64-52bit-va-v2-0-3911cb9d4ad4@fujitsu.com>
In-Reply-To: <20260914-arm64-52bit-va-v2-0-3911cb9d4ad4@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
 Takayuki Okamoto <tokamoto@fujitsu.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789371056; l=7290;
 i=itaru.kitayama@fujitsu.com; s=20260825; h=from:subject:message-id;
 bh=womlNSebg8YA4nRh21CzpVYFz8+Hr298oHktq30HrIc=;
 b=wTuHb/dS7hr29G0OtUzlZDfl79+46Cbk0yFnl9e4puuQrjhbhmUbzlNa/yy6l6LdB6ryEMc9l
 7YLLQPUCnwRCJ+gNyMBWNgdlyM+KM2lepReJ+JlYGbd6yfyiOcIfAaU
X-Developer-Key: i=itaru.kitayama@fujitsu.com; a=ed25519;
 pk=g9bTnr9giRP7JwNSZHy+OMLQZBEUtSE9tUnXso0hH1Y=

Add guest modes for 52-bit VA operation with the 4K, 16K, and 64K
translation granules, using five, four, and three page-table levels,
respectively.

Extend the existing guest-mode capability probe to read
ID_AA64MMFR2_EL1 from the same probe vCPU. Use VARange only when
determining 52-bit VA support for the 64K granule.

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Reviewed-by: Takayuki Okamoto <tokamoto@fujitsu.com>
---
 tools/testing/selftests/kvm/include/arm64/processor.h |  2 +-
 tools/testing/selftests/kvm/include/kvm_util.h        |  3 +++
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 15 ++++++++++++++-
 tools/testing/selftests/kvm/lib/guest_modes.c         |  7 +++++--
 tools/testing/selftests/kvm/lib/kvm_util.c            | 11 +++++++++++
 5 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 7457503df956..4ab00a7e6efb 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -169,7 +169,7 @@ enum {
 			   (v) == VECTOR_SYNC_LOWER_32)
 
 void aarch64_get_supported_page_sizes(u32 ipa, u32 *ipa4k,
-				      u32 *ipa16k, u32 *ipa64k);
+				      u32 *ipa16k, u32 *ipa64k, u32 *va64k);
 
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 5a7a455b5387..1c268fa994aa 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -184,6 +184,9 @@ enum vm_guest_mode {
 	VM_MODE_P52V48_4K,
 	VM_MODE_P52V48_16K,
 	VM_MODE_P52V48_64K,
+	VM_MODE_P52V52_4K,
+	VM_MODE_P52V52_16K,
+	VM_MODE_P52V52_64K,
 	VM_MODE_P48V48_4K,
 	VM_MODE_P48V48_16K,
 	VM_MODE_P48V48_64K,
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index b589368bf822..9915f25f0287 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -356,12 +356,14 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	case VM_MODE_PXXVYY_4K:
 		TEST_FAIL("AArch64 does not support 4K sized pages "
 			  "with ANY-bit physical address ranges");
+	case VM_MODE_P52V52_64K:
 	case VM_MODE_P52V48_64K:
 	case VM_MODE_P48V48_64K:
 	case VM_MODE_P40V48_64K:
 	case VM_MODE_P36V48_64K:
 		tcr_el1 |= TCR_TG0_64K;
 		break;
+	case VM_MODE_P52V52_16K:
 	case VM_MODE_P52V48_16K:
 	case VM_MODE_P48V48_16K:
 	case VM_MODE_P40V48_16K:
@@ -369,6 +371,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	case VM_MODE_P36V47_16K:
 		tcr_el1 |= TCR_TG0_16K;
 		break;
+	case VM_MODE_P52V52_4K:
 	case VM_MODE_P52V48_4K:
 	case VM_MODE_P48V48_4K:
 	case VM_MODE_P40V48_4K:
@@ -383,6 +386,9 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 
 	/* Configure output size */
 	switch (vm->mode) {
+	case VM_MODE_P52V52_4K:
+	case VM_MODE_P52V52_16K:
+	case VM_MODE_P52V52_64K:
 	case VM_MODE_P52V48_4K:
 	case VM_MODE_P52V48_16K:
 	case VM_MODE_P52V48_64K:
@@ -614,7 +620,7 @@ static u32 max_ipa_for_page_size(u32 vm_ipa, u32 gran,
 }
 
 void aarch64_get_supported_page_sizes(u32 ipa, u32 *ipa4k,
-				      u32 *ipa16k, u32 *ipa64k)
+				      u32 *ipa16k, u32 *ipa64k, u32 *va64k)
 {
 	struct kvm_vcpu_init preferred_init;
 	int kvm_fd, vm_fd, vcpu_fd, err;
@@ -652,6 +658,13 @@ void aarch64_get_supported_page_sizes(u32 ipa, u32 *ipa4k,
 	*ipa16k = max_ipa_for_page_size(ipa, gran, ID_AA64MMFR0_EL1_TGRAN16_NI,
 					ID_AA64MMFR0_EL1_TGRAN16_52_BIT);
 
+	reg.id = KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1);
+	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
+	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, err));
+
+	*va64k = FIELD_GET(ID_AA64MMFR2_EL1_VARange, val) >=
+		ID_AA64MMFR2_EL1_VARange_52 ? 52 : 48;
+
 	close(vcpu_fd);
 	close(vm_fd);
 	close(kvm_fd);
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 7a96c43b5704..8d2748145f8f 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -20,11 +20,14 @@ void guest_modes_append_default(void)
 #ifdef __aarch64__
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-		u32 ipa4k, ipa16k, ipa64k;
+		u32 ipa4k, ipa16k, ipa64k, va64k;
 		int i;
 
-		aarch64_get_supported_page_sizes(limit, &ipa4k, &ipa16k, &ipa64k);
+		aarch64_get_supported_page_sizes(limit, &ipa4k, &ipa16k, &ipa64k, &va64k);
 
+		guest_mode_append(VM_MODE_P52V52_4K, ipa4k >= 52);
+		guest_mode_append(VM_MODE_P52V52_16K, ipa16k >= 52);
+		guest_mode_append(VM_MODE_P52V52_64K, ipa64k >= 52 && va64k >= 52);
 		guest_mode_append(VM_MODE_P52V48_4K, ipa4k >= 52);
 		guest_mode_append(VM_MODE_P52V48_16K, ipa16k >= 52);
 		guest_mode_append(VM_MODE_P52V48_64K, ipa64k >= 52);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9ddc047d5c27..bc3ed034e203 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -203,6 +203,9 @@ const char *vm_guest_mode_string(u32 i)
 		[VM_MODE_P52V48_4K]	= "PA-bits:52,  VA-bits:48,  4K pages",
 		[VM_MODE_P52V48_16K]	= "PA-bits:52,  VA-bits:48, 16K pages",
 		[VM_MODE_P52V48_64K]	= "PA-bits:52,  VA-bits:48, 64K pages",
+		[VM_MODE_P52V52_4K]	= "PA-bits:52,  VA-bits:52,  4K pages",
+		[VM_MODE_P52V52_16K]	= "PA-bits:52,  VA-bits:52, 16K pages",
+		[VM_MODE_P52V52_64K]	= "PA-bits:52,  VA-bits:52, 64K pages",
 		[VM_MODE_P48V48_4K]	= "PA-bits:48,  VA-bits:48,  4K pages",
 		[VM_MODE_P48V48_16K]	= "PA-bits:48,  VA-bits:48, 16K pages",
 		[VM_MODE_P48V48_64K]	= "PA-bits:48,  VA-bits:48, 64K pages",
@@ -239,6 +242,9 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	[VM_MODE_P52V48_4K]	= { 52, 48,  0x1000, 12 },
 	[VM_MODE_P52V48_16K]	= { 52, 48,  0x4000, 14 },
 	[VM_MODE_P52V48_64K]	= { 52, 48, 0x10000, 16 },
+	[VM_MODE_P52V52_4K]	= { 52, 52,  0x1000, 12 },
+	[VM_MODE_P52V52_16K]	= { 52, 52,  0x4000, 14 },
+	[VM_MODE_P52V52_64K]	= { 52, 52, 0x10000, 16 },
 	[VM_MODE_P48V48_4K]	= { 48, 48,  0x1000, 12 },
 	[VM_MODE_P48V48_16K]	= { 48, 48,  0x4000, 14 },
 	[VM_MODE_P48V48_64K]	= { 48, 48, 0x10000, 16 },
@@ -306,10 +312,14 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
 	/* Setup mode specific traits. */
 	switch (vm->mode) {
+	case VM_MODE_P52V52_4K:
+		vm->mmu.pgtable_levels = 5;
+		break;
 	case VM_MODE_P52V48_4K:
 		vm->mmu.pgtable_levels = 4;
 		break;
 	case VM_MODE_P52V48_64K:
+	case VM_MODE_P52V52_64K:
 		vm->mmu.pgtable_levels = 3;
 		break;
 	case VM_MODE_P48V48_4K:
@@ -330,6 +340,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 	case VM_MODE_P48V48_16K:
 	case VM_MODE_P40V48_16K:
 	case VM_MODE_P36V48_16K:
+	case VM_MODE_P52V52_16K:
 		vm->mmu.pgtable_levels = 4;
 		break;
 	case VM_MODE_P47V47_16K:

-- 
2.43.0

