Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBAB179A8
	for <kvmarm@lists.linux.dev>; Sat,  7 Oct 2023 12:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4S2lDF2zS6zRhrJ;
	Sat,  7 Oct 2023 20:37:01 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 7 Oct 2023 20:40:54 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <ricarkol@google.com>,
	<wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] KVM: arm64: selftest: Add the missing .guest_prepare()
Date: Sat, 7 Oct 2023 20:40:42 +0800
Message-ID: <20231007124043.626-1-yuzenghui@huawei.com>
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
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

Running page_fault_test on a Cortex A72 fails with

Test: ro_memslot_no_syndrome_guest_cas
Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
Testing memory backing src type: anonymous
==== Test Assertion Failure ====
  aarch64/page_fault_test.c:117: guest_check_lse()
  pid=1944087 tid=1944087 errno=4 - Interrupted system call
     1	0x00000000004028b3: vcpu_run_loop at page_fault_test.c:682
     2	0x0000000000402d93: run_test at page_fault_test.c:731
     3	0x0000000000403957: for_each_guest_mode at guest_modes.c:100
     4	0x00000000004019f3: for_each_test_and_guest_mode at page_fault_test.c:1108
     5	 (inlined by) main at page_fault_test.c:1134
     6	0x0000ffff868e503b: ?? ??:0
     7	0x0000ffff868e5113: ?? ??:0
     8	0x0000000000401aaf: _start at ??:?
  guest_check_lse()

because we don't have a guest_prepare stage to check the presence of
FEAT_LSE and skip the related guest_cas testing, and we end-up failing in
GUEST_ASSERT(guest_check_lse()).

Add the missing .guest_prepare() where it's indeed required.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 47bb914ab2fa..eb5ead50c0b1 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -842,6 +842,7 @@ static void help(char *name)
 	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
 	.pt_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
 	.expected_events	= { .fail_vcpu_runs = 1 },			\
@@ -865,6 +866,7 @@ static void help(char *name)
 	.name			= SCAT2(ro_memslot_no_syn_and_dlog, _access),	\
 	.data_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
 	.pt_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.guest_test_check	= { _test_check },				\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
@@ -894,6 +896,7 @@ static void help(char *name)
 	.data_memslot_flags	= KVM_MEM_READONLY,				\
 	.pt_memslot_flags	= KVM_MEM_READONLY,				\
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
+	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.uffd_data_handler	= _uffd_data_handler,				\
 	.uffd_pt_handler	= uffd_pt_handler,			\
-- 
2.33.0

