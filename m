Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B21C2441AA
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752095680; cv=none; b=N6LfLv1XWsUV8PPEQLKJT2aJ3w99pXPMk/ZgpXVg89H0BuKs4yjtX0WNszAb5r4RvxOWzAVhQc513hWsPXJsU1hFpEr7XH2q0R5g2EDnRVpTRgTqqERsl9OLc+5wd9DiE0fCEDBVn+VFMciYlp/kqbSEbdkmUXSZ9ZAZQmqgO3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752095680; c=relaxed/simple;
	bh=vu7wLSL+ENuSiyxPPvVjOxNYnNdkUgc7a1KrZsq5xDc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kNNjpA+9emnxm4gvs/WULcjHNUnrWSdF8cQEQsEuSca6db0O7WXkbLi+z6NMjcNZINPCujC/h2zeGVfHqlwBx0rkXdGfwWhAxqBfW6DdrL5LxyptWWYPaH4/HqTMdl6QFSbfPKxMRZMvUjmx0d2NGcCi5CNouw4QiySEERUOpnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X582QT7m; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X582QT7m"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752095677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1PFRgzWKXsmxtZBYBRCQdzX2f6FPCx3KUTzZUxralhg=;
	b=X582QT7mohdKbG0IQ4cY7aDTjt06mW12MWxDU+L/5+cU4bWCVpzADpHdnI2Yr8DtcjYUX0
	igI0CtOnJ5ziZDwFUlbRwxdtspW5sCx/UzLAv6ifoaSpIUIzdL+vQszzO3cXBDVTn1LV/o
	ClJiHTALGPvYwZc/aCW9NhPKZOxCXWY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 5/6] KVM: arm64: selftests: Add test for nASSGIcap attribute
Date: Wed,  9 Jul 2025 14:14:16 -0700
Message-Id: <20250709211417.2074487-6-oliver.upton@linux.dev>
In-Reply-To: <20250709211417.2074487-1-oliver.upton@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
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
 tools/testing/selftests/kvm/arm64/vgic_init.c | 42 ++++++++++++++++++-
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index b3b5fb0ff0a9..743351aa998e 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -13,13 +13,12 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vgic.h"
+#include "gic_v3.h"
 
 #define NR_VCPUS		4
 
 #define REG_OFFSET(vcpu, offset) (((uint64_t)vcpu << 32) | offset)
 
-#define GICR_TYPER 0x8
-
 #define VGIC_DEV_IS_V2(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V2)
 #define VGIC_DEV_IS_V3(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V3)
 
@@ -675,6 +674,44 @@ static void test_v3_its_region(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_v3_nassgicap(void)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	bool has_nassgicap;
+	struct vm_gic vm;
+	u32 typer2;
+	int ret;
+
+	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	kvm_device_attr_get(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+			    GICD_TYPER2, &typer2);
+	has_nassgicap = typer2 & GICD_TYPER2_nASSGIcap;
+
+	typer2 |= GICD_TYPER2_nASSGIcap;
+	ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+				    GICD_TYPER2, &typer2);
+	if (has_nassgicap)
+		TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_DEVICE_ATTR_SET, ret));
+	else
+		TEST_ASSERT(ret && errno == EINVAL,
+			    "Enabled nASSGIcap even though it's unavailable");
+
+	typer2 &= ~GICD_TYPER2_nASSGIcap;
+	kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+			    GICD_TYPER2, &typer2);
+
+	kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	typer2 ^= GICD_TYPER2_nASSGIcap;
+	ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+				    GICD_TYPER2, &typer2);
+	TEST_ASSERT(ret && errno == EBUSY,
+		    "Changed nASSGIcap after initializing the VGIC");
+
+	vm_gic_destroy(&vm);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -730,6 +767,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
 		test_v3_its_region();
+		test_v3_nassgicap();
 	}
 }
 
-- 
2.39.5

