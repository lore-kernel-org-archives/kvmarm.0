Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A455C1848
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 12:18:02 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680956280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=STkeLKB55+cZfutVbkwWVnPvD/91QpSTelEyuTYWFUM=;
	b=EcZ8q6rkMKf8id5X3qfkqnB9XJ9J+v+tuzMw6JWYeTz9nfo1/DbCAXV+VC5BU26HYek6vX
	ZclJN78SA1NKyLOtxzWmmdLSfuqrYk+Kcn81iUiwbHkalK2vMfF554QcSaJtIq02PHVe7M
	bPCMotmBLDCyGpp437i1FrK0eQ8bb5Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Test that SMC64 arch calls are reserved
Date: Sat,  8 Apr 2023 12:17:32 +0000
Message-Id: <20230408121732.3411329-3-oliver.upton@linux.dev>
In-Reply-To: <20230408121732.3411329-1-oliver.upton@linux.dev>
References: <20230408121732.3411329-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Assert that the SMC64 view of the Arm architecture range is reserved by
KVM and cannot be filtered by userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/smccc_filter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/smccc_filter.c b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
index 0f9db0641847..dab671fdf239 100644
--- a/tools/testing/selftests/kvm/aarch64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
@@ -99,6 +99,7 @@ static void test_filter_reserved_range(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm = setup_vm(&vcpu);
+	uint32_t smc64_fn;
 	int r;
 
 	r = __set_smccc_filter(vm, ARM_SMCCC_ARCH_WORKAROUND_1,
@@ -106,6 +107,13 @@ static void test_filter_reserved_range(void)
 	TEST_ASSERT(r < 0 && errno == EEXIST,
 		    "Attempt to filter reserved range should return EEXIST");
 
+	smc64_fn = ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64,
+				      0, 0);
+
+	r = __set_smccc_filter(vm, smc64_fn, 1, KVM_SMCCC_FILTER_DENY);
+	TEST_ASSERT(r < 0 && errno == EEXIST,
+		    "Attempt to filter reserved range should return EEXIST");
+
 	kvm_vm_free(vm);
 }
 
-- 
2.40.0.577.gac1e443424-goog

