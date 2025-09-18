Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1FE22756A
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 16:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758214008; cv=none; b=nHyhcc/P8+3PD0OD+o6hnizjWcWVnfox5hV7/jml+E0kz75fVLm55ouWVXfvOT3WpkAsmzrAufwEhNZCOxOhU48cfjOMH/dvPiUYKJOcIknLz/61vuIW2TXPM7ZxhSvgzkRCBSNw3lEa9Pul0KErSqAFh35ewy0uar4ud4Xq+G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758214008; c=relaxed/simple;
	bh=98mA3TQ3s9ico+em5UEjjF2rsrm0CZrrUEJ2tcGCZY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jO6p2cUuM3FAhg/WLRh3xA5/+u0tuScuMIGb8PAQrQNKCUNH135QKkysE6UgpAoYv1P9CF2EexsstqU14q2Ms58PaxcoFZgAW7QJhIbErte1ZBgYDn4TS3HGTMO5MZHzpZsVI8drRtjokcmIeIHWRH85VAMjQTet6KsZX1pcoag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YmOoiS/T; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YmOoiS/T"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758214004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B6hPZth8tJskdq9St+W3KYP9EVGJ3oxdVI1j+B8pBCA=;
	b=YmOoiS/TJJ/gH5U3EyezGwWltArI1csHbNrfBmaopca8c7PreMH73o4L0646GoOi6cz3SB
	aUzCHuJExVmT9OZrU1q58nvMMuARqWWZohAeqRG2orptRbNvMaoYSY1abKRyesTpV94ybi
	HHRO4riahDyxX702foNMrY+SQ7mPFis=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] [DO NOT SUBMIT] KVM: arm64: selftests: Test effective value of HCR_EL2.AMO
Date: Thu, 18 Sep 2025 09:46:32 -0700
Message-ID: <20250918164632.410404-3-oliver.upton@linux.dev>
In-Reply-To: <20250918164632.410404-1-oliver.upton@linux.dev>
References: <20250918164632.410404-1-oliver.upton@linux.dev>
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
 .../selftests/kvm/arm64/external_aborts.c     | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index 062bf84cced1..78c29975f0a6 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -318,6 +318,39 @@ static void test_mmio_ease(void)
 	kvm_vm_free(vm);
 }
 
+static void test_serror_amo_guest(void)
+{
+	sysreg_clear_set(hcr_el2, HCR_EL2_AMO | HCR_EL2_TGE, 0);
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
+
+	vcpu_run_expect_sync(vcpu);
+	vcpu_inject_serror(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
 	test_mmio_abort();
@@ -327,4 +360,9 @@ int main(void)
 	test_serror_masked();
 	test_serror_emulated();
 	test_mmio_ease();
+
+	if (!kvm_check_cap(KVM_CAP_ARM_EL2))
+		return 0;
+
+	test_serror_amo();
 }
-- 
2.47.3

