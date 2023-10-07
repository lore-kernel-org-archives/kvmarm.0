Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898AD179A8
	for <kvmarm@lists.linux.dev>; Sat,  7 Oct 2023 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S2lDH4HvwzLnZ9;
	Sat,  7 Oct 2023 20:37:03 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 7 Oct 2023 20:40:57 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <ricarkol@google.com>,
	<wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/2] KVM: arm64: selftest: Perform ISB before reading PAR_EL1
Date: Sat, 7 Oct 2023 20:40:43 +0800
Message-ID: <20231007124043.626-2-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20231007124043.626-1-yuzenghui@huawei.com>
References: <20231007124043.626-1-yuzenghui@huawei.com>
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

It looks like a mistake to issue ISB *after* reading PAR_EL1, we should
instead perform it between the AT instruction and the reads of PAR_EL1.

As according to DDI0487J.a IJTYVP,

"When an address translation instruction is executed, explicit
 synchronization is required to guarantee the result is visible to
 subsequent direct reads of PAR_EL1."

Otherwise all guest_at testcases fail on my box with

==== Test Assertion Failure ====
  aarch64/page_fault_test.c:142: par & 1 == 0
  pid=1355864 tid=1355864 errno=4 - Interrupted system call
     1	0x0000000000402853: vcpu_run_loop at page_fault_test.c:681
     2	0x0000000000402cdb: run_test at page_fault_test.c:730
     3	0x0000000000403897: for_each_guest_mode at guest_modes.c:100
     4	0x00000000004019f3: for_each_test_and_guest_mode at page_fault_test.c:1105
     5	 (inlined by) main at page_fault_test.c:1131
     6	0x0000ffffb153c03b: ?? ??:0
     7	0x0000ffffb153c113: ?? ??:0
     8	0x0000000000401aaf: _start at ??:?
  0x1 != 0x0 (par & 1 != 0)

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index eb5ead50c0b1..9a3be80e8bc9 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -135,8 +135,8 @@ static void guest_at(void)
 	uint64_t par;
 
 	asm volatile("at s1e1r, %0" :: "r" (guest_test_memory));
-	par = read_sysreg(par_el1);
 	isb();
+	par = read_sysreg(par_el1);
 
 	/* Bit 1 indicates whether the AT was successful */
 	GUEST_ASSERT_EQ(par & 1, 0);
-- 
2.33.0

