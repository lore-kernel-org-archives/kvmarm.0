Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DBF1389
	for <kvmarm@lists.linux.dev>; Sun,  9 Oct 2022 03:32:19 +0000 (UTC)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MlSDC1JpTzVhr8;
	Sun,  9 Oct 2022 11:27:55 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 9 Oct 2022 11:32:16 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 9 Oct 2022 11:32:15 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <maz@kernel.org>, <andrew.jones@linux.dev>, <james.morse@arm.com>,
	<alexandru.elisei@arm.com>, <suzuki.poulose@arm.com>,
	<oliver.upton@linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: selftests: Fix multiple versions of GIC creation
Date: Sun, 9 Oct 2022 11:31:31 +0800
Message-ID: <20221009033131.365-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Message-ID: <20221009033131.K9PhEWtsN9PGAMgqcEeo5tvh00ae7-Gmm6CJDNdHn-8@z>

Commit 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to
separate helper") wrongly converted a "real" GIC device creation to
__kvm_test_create_device() and caused the test failure on my D05 (which
supports v2 emulation). Fix it.

Fixes: 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separate helper")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index e05ecb31823f..9c131d977a1b 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -662,8 +662,8 @@ int test_kvm_device(uint32_t gic_dev_type)
 					     : KVM_DEV_TYPE_ARM_VGIC_V2;
 
 	if (!__kvm_test_create_device(v.vm, other)) {
-		ret = __kvm_test_create_device(v.vm, other);
-		TEST_ASSERT(ret && (errno == EINVAL || errno == EEXIST),
+		ret = __kvm_create_device(v.vm, other);
+		TEST_ASSERT(ret < 0 && (errno == EINVAL || errno == EEXIST),
 				"create GIC device while other version exists");
 	}
 
-- 
2.33.0

