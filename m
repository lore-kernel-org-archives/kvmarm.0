Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384424A21
	for <kvmarm@lists.linux.dev>; Sat, 31 May 2025 01:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748654766; cv=none; b=nzRQLiJAWt56I/6lz69gu0jsn3T15u+UB22t6XNyceJucQmzwf26cVefaMy1TiGMWKhTI5BTUdLCKLtutZ6is0KhBN9RzmQDP3oMo9PGaWUp0bkb8cmBljdtNMVlge+M+GfRRg50DSMZyqpl/scXzYqgpmfav26HT9WvlnRP0aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748654766; c=relaxed/simple;
	bh=bugMo8r8RnxxM9E/b/A/vLBV83UPuDJJn1et5GRMCjA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YQIdYxFsmBfFnF2mVnBURBk9M/9x12v9hvATaQnSA8LayzA1ebdjfsROiUoWagEQMtOxf//ODPdu5mtxnZEjmltgwR7xU/tqkv2HW9ZvvPo06PmbW7ghONZtgagO4KUZ2mRkSUkA6q64dcM6uxkwLtREAAmRtHRoldyUoxrSw7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HKLi9jo7; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HKLi9jo7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748654763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=POZepvMnS98kCy9E83ZMnekacdtvcTLSoMsUWYLNaR8=;
	b=HKLi9jo7Zg9YutTI5pAG0+ST0kTuiArlSIfplrMi1Rp1EJBWwpkY9dYVsxyQD2JWToiNSO
	IY2u7EKZHYxKDJXPajjYe0doMFV52a+H5SHelM6ljb3efhAK3pET6aKYHAJGWxEnPNFDYa
	sIFwp0TnZgnAmTbYSzzOoHFXS42K93o=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 4/4] KVM: arm64: selftests: Add test for nASSGIcap attribute
Date: Fri, 30 May 2025 18:25:45 -0700
Message-Id: <20250531012545.709887-5-oliver.upton@linux.dev>
In-Reply-To: <20250531012545.709887-1-oliver.upton@linux.dev>
References: <20250531012545.709887-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Raghavendra Rao Ananta <rananta@google.com>

Extend vgic_init to test the nASSGIcap attribute, asserting that it is
configurable (within reason) prior to initializing the VGIC.
Additionally, check that userspace cannot set the attribute after the
VGIC has been initialized.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index b3b5fb0ff0a9..aaecba432dbc 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -675,6 +675,46 @@ static void test_v3_its_region(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_v3_nassgicap(void)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic vm;
+	__u8 nassgicap;
+	int ret;
+
+	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	TEST_REQUIRE(!__kvm_has_device_attr(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+					    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap));
+
+	kvm_device_attr_get(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+			    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+	if (!nassgicap) {
+		nassgicap = true;
+		ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+					    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+		TEST_ASSERT(ret && errno == EINVAL,
+			    "Enabled nASSGIcap even though it's unavailable");
+	} else {
+		nassgicap = false;
+		kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+				    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+
+		nassgicap = true;
+		kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+				    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+	}
+
+	kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+				    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+	TEST_ASSERT(ret && errno == EBUSY,
+		    "Configured nASSGIcap after initializing the VGIC");
+
+	vm_gic_destroy(&vm);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -730,6 +770,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
 		test_v3_its_region();
+		test_v3_nassgicap();
 	}
 }
 
-- 
2.39.5

