Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CD1D34752D
	for <kvmarm@lists.linux.dev>; Sat, 16 May 2026 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956274; cv=none; b=h8jW8hux/5YRApNONU13iBB/cykeyeiYvIGcNn8uojr6gdPinlMWhOccBI5zVIgYQafnHi7S4FNoJWxgkSvKuecOwQM5gSkq0UWwe9FFElPEuUMisES2v/EZ6L272FrzEUFHuZGFNV4VIHA3wpmsMGwJXzMlhnnDGJic8TRwpas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956274; c=relaxed/simple;
	bh=waACEwaOCU9Q56/CgdQoWvYngZ8Q6B/c8GIndLVbAcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmKfSIZA05RoJpfBSSGUFkiymKLpFekbBzm/8VdBT6t9MJqI6+zka32P8jDUJUqpIuTxXtrRYGyrwj2OvKjswp27NxOYOsNfP6Is7wohZ3BvKSJ1VRFL3oNFnHxP4UCKrRceQRE6zABMUfMjxLB8+nNuIa8FKnLcqwswu7FBdzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sKa08Aso; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sKa08Aso"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 820292D91;
	Sat, 16 May 2026 11:31:04 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 145AD3F85F;
	Sat, 16 May 2026 11:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778956269; bh=waACEwaOCU9Q56/CgdQoWvYngZ8Q6B/c8GIndLVbAcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKa08AsosCe81z3+QYLy0GKotDrI/oTc9yFQYA2Qcwvib+5EX/jkNhQoyOe+D0VM7
	 9X6BjsHACpnmO+kQL9qjViOAQZLBVxNVL011lFr/tNqddm77JgVUNmiKvAmpZMVR0p
	 yFoVIuP4YtbbcCTjUa0QMp3Skyq/pxxJI+y68qfY=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 7/9] KVM: arm64: selftests: shadow_stage2: Check supported stage-2 granule size
Date: Sat, 16 May 2026 19:30:01 +0100
Message-ID: <20260516183003.799058-8-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516183003.799058-1-weilin.chang@arm.com>
References: <20260516183003.799058-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When selecting a granule size for stage-2, the supported stage-2 granule
size must be checked. Add the check. For simplicity, we check whether
the guest stage-1 granule size is supported for stage-2, and skip the
test otherwise.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 .../selftests/kvm/arm64/shadow_stage2.c       |  8 +++++
 .../selftests/kvm/include/arm64/nested.h      |  1 +
 .../testing/selftests/kvm/lib/arm64/nested.c  | 30 +++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/shadow_stage2.c b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
index 1ad510a38654..c5332b8b5683 100644
--- a/tools/testing/selftests/kvm/arm64/shadow_stage2.c
+++ b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
@@ -14,6 +14,8 @@
 #define L2FAILED	(0x1)
 #define L2SYNC		(0x2)
 
+#define TGRAN2NOSUP	(0x3)
+
 /* Used for L2 stack and guest S2 page tables. */
 #define L2_PAGE_POOL_ADDR	(0x80000000)
 #define L2_PAGE_POOL_NPAGES	(512)
@@ -53,6 +55,7 @@ static void guest_code(void)
 	int ret, i = 0;
 	gpa_t l2_pc, l2_stack_top;
 	struct page_pool pp;
+	u64 mmfr0 = read_sysreg(id_aa64mmfr0_el1);
 
 	GUEST_ASSERT_EQ(get_current_el(), 2);
 	GUEST_PRINTF("vEL2 entry\n");
@@ -62,6 +65,9 @@ static void guest_code(void)
 	pp.current = L2_PAGE_POOL_ADDR;
 	pp.page_size = get_page_size();
 
+	if (!has_tgran_2(mmfr0, pp.page_size))
+		GUEST_SYNC1(TGRAN2NOSUP);
+
 	l2_stack_top = alloc_page(&pp) + pp.page_size;
 	l2_pc = ucall_translate_to_gpa(l2_guest_code);
 
@@ -119,6 +125,8 @@ int main(void)
 			}
 			if (uc.args[0] == L2SYNC)
 				pr_info("L2SYNC, L1 info: %ld, L2 info: %ld\n", uc.args[1], uc.args[2]);
+			if (uc.args[0] == TGRAN2NOSUP)
+				ksft_exit_skip("Guest page size not supported as guest stage-2 page size!\n");
 			break;
 		case UCALL_PRINTF:
 			pr_info("[L1] %s", uc.buffer);
diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
index 8e7d7738b381..fc59fabff12d 100644
--- a/tools/testing/selftests/kvm/include/arm64/nested.h
+++ b/tools/testing/selftests/kvm/include/arm64/nested.h
@@ -55,6 +55,7 @@ struct page_pool {
 
 size_t get_page_size(void);
 gpa_t alloc_page(struct page_pool *pp);
+bool has_tgran_2(u64 mmfr0, size_t size);
 void prepare_hyp(void);
 void init_vcpu(struct vcpu *vcpu, gpa_t l2_pc, gpa_t l2_stack_top);
 int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data);
diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
index 7f47e340f00d..cda41f355263 100644
--- a/tools/testing/selftests/kvm/lib/arm64/nested.c
+++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
@@ -9,6 +9,36 @@
 #include <asm/sysreg.h>
 #include <linux/sizes.h>
 
+#define _has_tgran_2(__r, __sz)						\
+	({								\
+		u64 _s1, _s2, _mmfr0 = __r;				\
+									\
+		_s2 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
+				    TGRAN##__sz##_2, _mmfr0);		\
+									\
+		_s1 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
+				    TGRAN##__sz, _mmfr0);		\
+									\
+		((_s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_NI &&		\
+		  _s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz) || \
+		 (_s2 == ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz && \
+		  _s1 != ID_AA64MMFR0_EL1_TGRAN##__sz##_NI));		\
+	})
+
+bool has_tgran_2(u64 mmfr0, size_t size)
+{
+	switch (size) {
+	case SZ_4K:
+		return _has_tgran_2(mmfr0, 4);
+	case SZ_16K:
+		return _has_tgran_2(mmfr0, 16);
+	case SZ_64K:
+		return _has_tgran_2(mmfr0, 64);
+	default:
+		return false;
+	}
+}
+
 size_t get_page_size(void)
 {
 	u64 tcr_el1 = read_sysreg(tcr_el1);
-- 
2.43.0

