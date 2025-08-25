Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881E91C84C7
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 02:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756090054; cv=none; b=SE0GSB3verGq5fpAXK4O2JRY/VQOcPbOO6ze75i3zUINFv+mER9DB/GkUokw+PApEjFGU+c5R0se7/VEOvmA9ORdIemtBac1HvkAKUxCIugiZ+zz7r9u2e/YfSfCqSb/DdfE6d9OstRpGx18n+o5QdBs8QmPpiPzvog0hNQ0eGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756090054; c=relaxed/simple;
	bh=ILLR+DsfUr01nq7iRasKBJ9/Vf4Ru8fHBYj6Zsz+Blg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SoNE8fpCvF0D1cyps9W3+O8q53mMm5ADNm/L+gmIkXiPWMq2mcoC5DDZ3cwOjyyHCms/FUHBJwnWdFkw4JfoIufQcYDOPiywXShF8KygNAnmNd55RHspTynFTBlboE8KjkdrSKh4p/4ZDwCfRBr45QBS4NoVKnxmYr34mB9FEfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c9FTP55vbz2CgGS;
	Mon, 25 Aug 2025 10:43:05 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 914C11A016C;
	Mon, 25 Aug 2025 10:47:30 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 10:47:30 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 10:47:29 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <tangnianyao@huawei.com>,
	<wangwudi@hisilicon.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v2 2/4] KVM: arm64: selftests: Add test for GICD.num_LPIs
Date: Mon, 25 Aug 2025 10:39:52 +0800
Message-ID: <20250825023954.3516381-3-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
References: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

Add test case about GICD.num_LPIs. The default value should be 0, and it
can be modified before GIC init, but cannot be modified after GIC init.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 33 +++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v3.h      |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index a8e0f46bc0ab..7e60443827e9 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -968,6 +968,38 @@ static void test_v3_sysregs(void)
 	kvm_vm_free(vm);
 }
 
+static void test_v3_num_lpis(void)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	u32 num_lpis;
+	struct vm_gic vm;
+	u32 typer;
+	int ret;
+
+	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	kvm_create_device(vm.vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
+
+	kvm_device_attr_get(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+			    GICD_TYPER, &typer);
+	num_lpis = typer & GICD_TYPER_NUM_LPIS_MASK;
+	TEST_ASSERT(!num_lpis, "Default value of GICD.num_LPIs is not 0");
+
+	typer |= 10 << GICD_TYPER_NUM_LPIS_SHIFT;
+	ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+				    GICD_TYPER, &typer);
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_DEVICE_ATTR_SET, ret));
+
+	kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+				    GICD_TYPER, &typer);
+	TEST_ASSERT(ret && errno == EBUSY,
+		    "Changed GICD.num_LPIs after initializing the VGIC");
+
+	vm_gic_destroy(&vm);
+}
+
 void run_tests(uint32_t gic_dev_type)
 {
 	test_vcpus_then_vgic(gic_dev_type);
@@ -985,6 +1017,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_its_region();
 		test_v3_sysregs();
 		test_v3_nassgicap();
+		test_v3_num_lpis();
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v3.h b/tools/testing/selftests/kvm/include/arm64/gic_v3.h
index a76615fa39a1..c9f25cdd3651 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v3.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v3.h
@@ -85,6 +85,8 @@
 #define GICD_TYPER_ESPI			(1U << 8)
 
 #define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
+#define GICD_TYPER_NUM_LPIS_MASK	GENMASK(15, 11)
+#define GICD_TYPER_NUM_LPIS_SHIFT	11
 #define GICD_TYPER_NUM_LPIS(typer)	((((typer) >> 11) & 0x1f) + 1)
 #define GICD_TYPER_SPIS(typer)		((((typer) & 0x1f) + 1) * 32)
 #define GICD_TYPER_ESPIS(typer)						\
-- 
2.33.0

