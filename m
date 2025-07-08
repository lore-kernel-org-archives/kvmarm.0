Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871AE12CD8B
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 23:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752016009; cv=none; b=bJs/oq+jwg+wumN5Mvz3u9/78iI4/7vSsvIQ8o7yhyY31wY1/3j3mhbPxE14d/OzZWc0J7qBla51NIQZYfaMvNK6omrqz0MxTQIs+wwpobN9+gIOjjWwuFWgRti90nbfs1VMSh4U2xLKeyrAp7YdBoNqPf2/Ruvz5zCSbKndvPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752016009; c=relaxed/simple;
	bh=C7PVQhj0UNCvxW1Qrv+WvDAepDFrfx2kNzkmuzlz5vo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ND+Zp3ferJs7sV6nZZR+gEbbxDh82WjaHeDng72WXYMXxU+4Yh7lmsQxjw0+u/qMFXDjgCx7YnJoVu7MSg5bJ1Q5xAaMjYy3dMefz4Zw0P0+qktbZiv9K4pqS5XDx2vVLVzHihtq4y0nTe8UmQ7dWsjlRf8CQNnjcnMR3WlHhew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GwOZUiUy; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GwOZUiUy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752016005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVFp8N41PRpt4riOk3QsIYqRgCgsV9gBsSFFT1BHToY=;
	b=GwOZUiUyZVqPrAlAaEvFpYuDgvvv5xQLqjYMMCWQKc5v1lbJWGFOxFeWkPa84jkXooN3Xw
	T8SHdyAjyCNDPX8C5VQXr+Ib3XAV43yvLCegoHjfQGNdY9qRNxuiIt3tRONdQaolPeSKHH
	CJRFMT/eE7mawZhcu2N0xT7VtIHj3Fo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: selftests: Test ESR propagation for vSError injection
Date: Tue,  8 Jul 2025 16:06:32 -0700
Message-Id: <20250708230632.1954240-3-oliver.upton@linux.dev>
In-Reply-To: <20250708230632.1954240-1-oliver.upton@linux.dev>
References: <20250708230632.1954240-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Ensure that vSErrors taken in the guest have an appropriate ESR_ELx
value for the expected exception. Additionally, switch the EASE test to
install the SEA handler at the SError offset, as the ESR is still
expected to match an SEA in that case.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/arm64/external_aborts.c     | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index ec7e30776a0e..062bf84cced1 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -7,7 +7,8 @@
 #include "processor.h"
 #include "test_util.h"
 
-#define MMIO_ADDR	0x8000000ULL
+#define MMIO_ADDR		0x8000000ULL
+#define EXPECTED_SERROR_ISS	(ESR_ELx_ISV | 0x1d1ed)
 
 static u64 expected_abort_pc;
 
@@ -49,11 +50,28 @@ static void vcpu_inject_sea(struct kvm_vcpu *vcpu)
 	vcpu_events_set(vcpu, &events);
 }
 
+static bool vcpu_has_ras(struct kvm_vcpu *vcpu)
+{
+	u64 pfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
+
+	return SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, pfr0);
+}
+
+static bool guest_has_ras(void)
+{
+	return SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, read_sysreg(id_aa64pfr0_el1));
+}
+
 static void vcpu_inject_serror(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_events events = {};
 
 	events.exception.serror_pending = true;
+	if (vcpu_has_ras(vcpu)) {
+		events.exception.serror_has_esr = true;
+		events.exception.serror_esr = EXPECTED_SERROR_ISS;
+	}
+
 	vcpu_events_set(vcpu, &events);
 }
 
@@ -199,6 +217,12 @@ static void test_serror_masked(void)
 
 static void expect_serror_handler(struct ex_regs *regs)
 {
+	u64 esr = read_sysreg(esr_el1);
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_SERROR);
+	if (guest_has_ras())
+		GUEST_ASSERT_EQ(ESR_ELx_ISS(esr), EXPECTED_SERROR_ISS);
+
 	GUEST_DONE();
 }
 
@@ -277,7 +301,11 @@ static void test_mmio_ease(void)
 		return;
 	}
 
-	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_serror_handler);
+	/*
+	 * SCTLR2_ELx.EASE changes the exception vector to the SError vector but
+	 * doesn't further modify the exception context (e.g. ESR_ELx, FAR_ELx).
+	 */
+	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_sea_handler);
 
 	vcpu_run(vcpu);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
-- 
2.39.5

