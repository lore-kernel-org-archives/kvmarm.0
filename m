Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7B9A927
	for <kvmarm@lists.linux.dev>; Sun,  8 Jun 2025 09:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749376459; cv=none; b=jnLbIqDw64bMc1xU3c+FJL1QXWFRMJ2BPm13/RwiyYH88ku+W5BaSCOri0us9wuR+o8yVG/EtxdhvOfXsAUx4/cxunq2Yrl9LB51xoFE8M/iJnDv3EBI39YQqLPx3zboNB8SHmWXrB8VZMaE9JicgM4HDvo1t9NV8LRykGOr+Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749376459; c=relaxed/simple;
	bh=dnTNFvMnQgqWU1Z4xBX61EOnld4DfGmVKEYPsd/5rKw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZmuSoigTcGhL4rFQxYI98FOEgD5u6xnILjY4EoeJw9VlH8jKY+of75/eivKSqrIHg4iIZArXgTsK2haZbAE/34KBu/Qzi6Ln4qCwNw/cGEZA41W5AGIScyJeMDPisrRMH5SDPNzykvLmanjlo8Vedfopk16rsXaUhcsITvo6CWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4bFVjF3T3sz1fy4l;
	Sun,  8 Jun 2025 17:52:49 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 9AD96140155;
	Sun,  8 Jun 2025 17:54:05 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 8 Jun 2025 17:54:04 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>, Zenghui Yu
	<yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: selftests: Close the GIC FD in arch_timer_edge_cases
Date: Sun, 8 Jun 2025 17:54:02 +0800
Message-ID: <20250608095402.1131-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200017.china.huawei.com (7.202.194.83)

Close the GIC FD to free the reference it holds to the VM so that we can
correctly clean up the VM. This also gets rid of the

	"KVM: debugfs: duplicate directory 395722-4"

warning when running arch_timer_edge_cases.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 .../selftests/kvm/arm64/arch_timer_edge_cases.c  | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index ad882ec8ff7b..b75e506324ce 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -954,6 +954,8 @@ static void test_init_timer_irq(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
 }
 
+static int gic_fd;
+
 static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
 			   enum arch_timer timer)
 {
@@ -968,12 +970,20 @@ static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
 	vcpu_args_set(*vcpu, 1, timer);
 
 	test_init_timer_irq(*vm, *vcpu);
-	vgic_v3_setup(*vm, 1, 64);
+	gic_fd = vgic_v3_setup(*vm, 1, 64);
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
+
 	sync_global_to_guest(*vm, test_args);
 	sync_global_to_guest(*vm, CVAL_MAX);
 	sync_global_to_guest(*vm, DEF_CNT);
 }
 
+static void test_vm_cleanup(struct kvm_vm *vm)
+{
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
 static void test_print_help(char *name)
 {
 	pr_info("Usage: %s [-h] [-b] [-i iterations] [-l long_wait_ms] [-p] [-v]\n"
@@ -1060,13 +1070,13 @@ int main(int argc, char *argv[])
 	if (test_args.test_virtual) {
 		test_vm_create(&vm, &vcpu, VIRTUAL);
 		test_run(vm, vcpu);
-		kvm_vm_free(vm);
+		test_vm_cleanup(vm);
 	}
 
 	if (test_args.test_physical) {
 		test_vm_create(&vm, &vcpu, PHYSICAL);
 		test_run(vm, vcpu);
-		kvm_vm_free(vm);
+		test_vm_cleanup(vm);
 	}
 
 	return 0;
-- 
2.33.0

