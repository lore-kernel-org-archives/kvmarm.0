Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46461C8D1
	for <kvmarm@lists.linux.dev>; Fri, 25 Aug 2023 09:37:01 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXF9V6pKpz684JJ;
	Fri, 25 Aug 2023 17:32:46 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:36:52 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>, <will@kernel.org>,
	<catalin.marinas@arm.com>, <oliver.upton@linux.dev>
CC: <james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<zhukeqian1@huawei.com>, <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 5/8] KVM: arm64: Add some HW_DBM related mmu interfaces
Date: Fri, 25 Aug 2023 10:35:25 +0100
Message-ID: <20230825093528.1637-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

From: Keqian Zhu <zhukeqian1@huawei.com>

This adds set_dbm, clear_dbm and sync_dirty interfaces in mmu layer.
They simply wrap those interfaces of pgtable layer.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  7 +++++++
 arch/arm64/kvm/mmu.c             | 30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 0e1e1ab17b4d..86e1e074337b 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -170,6 +170,13 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
 void __init free_hyp_pgds(void);
 
+void kvm_stage2_clear_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+			  gfn_t gfn_offset, unsigned long npages);
+void kvm_stage2_set_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+			gfn_t gfn_offset, unsigned long npages);
+void kvm_stage2_sync_dirty(struct kvm *kvm, struct kvm_memory_slot *slot,
+			   gfn_t gfn_offset, unsigned long npages);
+
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_uninit_stage2_mmu(struct kvm *kvm);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b16aff3f65f6..f5ae4b97df4d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1149,6 +1149,36 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
+void kvm_stage2_clear_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+			  gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range_resched(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_clear_dbm);
+}
+
+void kvm_stage2_set_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+			gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_set_dbm, false);
+}
+
+void kvm_stage2_sync_dirty(struct kvm *kvm, struct kvm_memory_slot *slot,
+			   gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_sync_dirty, false);
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
-- 
2.34.1

