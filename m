Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 053B512F585
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164171; cv=none; b=KTHpnx5iYso+DVf00cpPuwcDgrXc3zeyyYp3JUzxs64uB0qvZtZFtdt6FGzsUwZODYCGo+UqDdTqnZYKbJZXwEWtbrvwGfLGFZ2IOnNLqTd6XNeb5Tan2OsMDGVdVe9q6BiYYJC9QUhc2Yh4nS30HWXTI+hT9gHGmK367bgiWbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164171; c=relaxed/simple;
	bh=uF3gHfbdma2orZBXGO3W33CSKmBuY31e2U0A16wUtI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AnwdCLeEXCGKJCpYpBTGzpRKsb8aKfi14sh6JAmONSuRCje3ciixA37kRSZPvku/s4H88d2DnhEC3VucK4/7NIVsCFZ0uHbW1iyJ/2Sg/RuFEiD/JW7rPUCSxoKP9qk0UH4s7iWy83MX9JP6njc7cp0ZcBe0liNO2R0OJeyijAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XfBBoZWe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XfBBoZWe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 437FA143D;
	Fri, 16 Oct 2026 08:22:46 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36D1A3F673;
	Fri, 16 Oct 2026 08:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792164169; bh=uF3gHfbdma2orZBXGO3W33CSKmBuY31e2U0A16wUtI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfBBoZWegND7u2jVP+pM2ziUVDPyA3kq4qCgfdFsV3k0sHlQtGnZSXHOqGZui4ald
	 s0pXh1Q4aXSLGw/iarRK4ZHnYXVS/ODu2EMXO8M2dzweWg64EJ+FuCmhIaaX6MSmTB
	 3073N9Li0kUX6yhKE4iIEh8v9fi4pCl0SEKcHOFA=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: [PATCH 2/2] KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC
Date: Fri, 16 Oct 2026 16:22:24 +0100
Message-Id: <20261016152225.898761-3-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016152225.898761-1-sascha.bischoff@arm.com>
References: <20261016152225.898761-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check that a GICv3 ITS and a GICv5 VGIC cannot be paired, regardless
of which device is created first. Skip the check when the host does not
expose a GICv3 ITS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 32 +++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
index d5df742b23001..5bf7d99d29147 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -2003,8 +2003,40 @@ int test_kvm_device(u32 gic_dev_type)
 	return 0;
 }
 
+static void test_vgic_v3_its_with_vgic_v5(void)
+{
+	struct kvm_vm *vm = vm_create_barebones();
+	int gic_fd, its_fd, ret;
+
+	if (__kvm_test_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_ITS)) {
+		pr_info("No GICv3 ITS support; skipping mixed-model test.\n");
+		kvm_vm_free(vm);
+		return;
+	}
+
+	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V5);
+	ret = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
+	TEST_ASSERT(ret < 0 && errno == ENODEV,
+		    "GICv3 ITS created after GICv5 VGIC: ret=%d errno=%d",
+		    ret, errno);
+	close(gic_fd);
+	kvm_vm_free(vm);
+
+	vm = vm_create_barebones();
+	its_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
+	ret = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V5);
+	TEST_ASSERT(ret < 0 && errno == ENODEV,
+		    "GICv5 VGIC created after GICv3 ITS: ret=%d errno=%d",
+		    ret, errno);
+	close(its_fd);
+	kvm_vm_free(vm);
+}
+
 void run_tests(u32 gic_dev_type)
 {
+	pr_info("Test VGICv5 and GICv3 ITS model mismatch\n");
+	test_vgic_v3_its_with_vgic_v5();
+
 	pr_info("Test VGICv5 address attrs\n");
 	test_vgic_v5_addr_attrs();
 
-- 
2.34.1

