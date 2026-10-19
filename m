Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7EB4F96AC
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417380; cv=none; b=T8V9PLiC1ZSKVU2/5S20AvzuqcPgO1pGUnrlOXXXHxUDaJif2pqrbtl6yo0QQNmEkOq0hLVgvs5Yvp9DH7TSfgadZwvy8rfwGs5+isoiNqWtA2Mi0U1/VqdFiC3VNIYgEppRysdgA7W32rHKlIWkwQ4fhk03rJz3RrpJQQgIAD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417380; c=relaxed/simple;
	bh=uF3gHfbdma2orZBXGO3W33CSKmBuY31e2U0A16wUtI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rtcu8kO3H2s5i6TxOXSkh0pTN+0nsSg0M04vu1Y8ttPtTI7UpMpdNzHhkVaMr5jim1gO7SUsCb4zT6leMMrtijiREgQ2HEndbbQAQxQgRa4dcSJhiPKG6tHHpUpsIJVQjWumGCsuNr/uZejDIq98XwxGp1gCR2sfv+prUyqg8P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XYs0c9v6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XYs0c9v6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FB7E1CE0;
	Mon, 19 Oct 2026 06:42:55 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 699593F7D8;
	Mon, 19 Oct 2026 06:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792417378; bh=uF3gHfbdma2orZBXGO3W33CSKmBuY31e2U0A16wUtI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYs0c9v6eCUP6TFLr/38qxMAAJ02GuUE+cvJoII+EneHNNCLsTlQhoRZ3moyfbt03
	 z0Y8veezIvYax7sZoSx0q1Mcmj3Ss6p+myC0Kr5Cz67a4GHwYKy+QZjh0ibUW9jCIb
	 Ttl0+1+2beS1NEXO5GaELPODbAICnc8ilCF5fQww=
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
Subject: [PATCH v2 2/2] KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC
Date: Mon, 19 Oct 2026 14:42:42 +0100
Message-Id: <20261019134242.1289002-3-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019134242.1289002-1-sascha.bischoff@arm.com>
References: <20261019134242.1289002-1-sascha.bischoff@arm.com>
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

