Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F8629AB05
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 22:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758926708; cv=none; b=fAOlcTJWA4s+Rn72/b2wwv0GtKUV4UljJ65Mjcbgs77H9KzmNKmtH0zhrvsaMxLElcnH9hL9WC/juOGOVLEi1WK68v2l58lYFqgj5Bk6eOdLdgxJA4tdNNRo4OV0/GMsoqazf1lCmhC1PCTvqVwcctxBXNPLfXDWoa6uvLEIxsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758926708; c=relaxed/simple;
	bh=P7FxGnEUX7LfTSPUAPo5XBamZ/KP9un8miH1uQdOC0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mgsLUJvd8xGSl3aSn+NcUBFgjif55VFJnVZm5jg2r2o1k6bs/sxTDnkD9EwD7sHDXSTPjQr9Ezk/XhzYJYMGCsGPX6iQ0wErewueM2g7XKnwzbhs5fV95lXBdR5drrDYGGinrmMmn53m/Bu2CtihWVSU1mGe/DPm/KvwAPcPXpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=krFK/Mcm; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="krFK/Mcm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758926704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yd+APAjGAZuazc9NYTrTOX7161a/PiePHaRiS+4FanI=;
	b=krFK/Mcmf/l/0rcV+79BcoGWd1A3EMp3P0P5kcOaEnm+is64hUf8qMqp8FAd71MPVGYFrP
	mIhiUb6nIAn3zAAC+sBY5UMTcAr7GfAS6GmGuhkC6/P6aFOn+rWfOzXyxtwYDUglec2z+8
	GFxO/679knVD8uduytinp6xJyjWk12w=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: selftests: Test effective value of HCR_EL2.AMO
Date: Fri, 26 Sep 2025 15:44:54 -0700
Message-ID: <20250926224454.734066-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A defect against the architecture now allows an implementation to treat
AMO as 1 when HCR_EL2.{E2H, TGE} = {1, 0}. KVM now takes advantage of
this interpretation to address a quality of emulation issue w.r.t.
SError injection.

Add a corresponding test case and expect a pending SError to be taken.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/arm64/external_aborts.c     | 43 +++++++++++++++++++
 .../selftests/kvm/include/arm64/processor.h   | 12 +++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index 592b26ded779..d8fe17a6cc59 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -359,6 +359,44 @@ static void test_mmio_ease(void)
 	kvm_vm_free(vm);
 }
 
+static void test_serror_amo_guest(void)
+{
+	/*
+	 * The ISB is entirely unnecessary (and highlights how FEAT_NV2 is borked)
+	 * since the write is redirected to memory. But don't write (intentionally)
+	 * broken code!
+	 */
+	sysreg_clear_set(hcr_el2, HCR_EL2_AMO | HCR_EL2_TGE, 0);
+	isb();
+
+	GUEST_SYNC(0);
+	GUEST_ASSERT(read_sysreg(isr_el1) & ISR_EL1_A);
+
+	/*
+	 * KVM treats the effective value of AMO as 1 when
+	 * HCR_EL2.{E2H,TGE} = {1, 0}, meaning the SError will be taken when
+	 * unmasked.
+	 */
+	local_serror_enable();
+	isb();
+	local_serror_disable();
+
+	GUEST_FAIL("Should've taken pending SError exception");
+}
+
+static void test_serror_amo(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_amo_guest,
+							unexpected_dabt_handler);
+
+	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_serror_handler);
+	vcpu_run_expect_sync(vcpu);
+	vcpu_inject_serror(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
 	test_mmio_abort();
@@ -369,4 +407,9 @@ int main(void)
 	test_serror_emulated();
 	test_mmio_ease();
 	test_s1ptw_abort();
+
+	if (!test_supports_el2())
+		return 0;
+
+	test_serror_amo();
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 6f481475c135..ff928716574d 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -305,7 +305,17 @@ void test_wants_mte(void);
 void test_disable_default_vgic(void);
 
 bool vm_supports_el2(struct kvm_vm *vm);
-static bool vcpu_has_el2(struct kvm_vcpu *vcpu)
+
+static inline bool test_supports_el2(void)
+{
+	struct kvm_vm *vm = vm_create(1);
+	bool supported = vm_supports_el2(vm);
+
+	kvm_vm_free(vm);
+	return supported;
+}
+
+static inline bool vcpu_has_el2(struct kvm_vcpu *vcpu)
 {
 	return vcpu->init.features[0] & BIT(KVM_ARM_VCPU_HAS_EL2);
 }

base-commit: 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6
-- 
2.47.3

