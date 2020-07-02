Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54238C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:56:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 169A32088E
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:56:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 169A32088E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C52EA4B5E6;
	Thu,  2 Jul 2020 09:56:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dGF9IuLInY1A; Thu,  2 Jul 2020 09:56:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C76B4B609;
	Thu,  2 Jul 2020 09:56:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4811F4B5D2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:56:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GjIY94Lcj1Yg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 09:56:18 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEAFD4B5D5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:56:17 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 984256462E39DFB8901B;
 Thu,  2 Jul 2020 21:56:15 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 21:56:07 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH v2 7/8] KVM: arm64: Sync dirty log parallel
Date: Thu, 2 Jul 2020 21:55:55 +0800
Message-ID: <20200702135556.36896-8-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200702135556.36896-1-zhukeqian1@huawei.com>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Steven Price <steven.price@arm.com>, liangpeng10@huawei.com,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Give userspace another selection to solve high-cost dirty log
sync, which called multi-core offload. Usersapce can enable
this policy through KVM_CAP_ARM_HW_DIRTY_LOG.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/arm.c              |  9 +++-
 arch/arm64/kvm/mmu.c              | 82 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/reset.c            |  2 +-
 4 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 69a5317c7049..05da819f9adc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -95,6 +95,9 @@ struct kvm_arch {
 	 * supported.
 	 */
 	bool return_nisv_io_abort_to_user;
+
+	/* Sync dirty log parallel when hw dirty log enabled */
+	bool sync_dirty_log_parallel;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9e3f765d5467..89614984831d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -82,6 +82,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	int i;
 	struct kvm_vcpu *vcpu;
 	bool enable_hw_dirty_log;
+	bool enable_sync_parallel;
 #endif
 
 	if (cap->flags)
@@ -94,10 +95,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 #ifdef CONFIG_ARM64_HW_AFDBM
 	case KVM_CAP_ARM_HW_DIRTY_LOG:
-		if (!arm_mmu_hw_dbm_supported() || (cap->args[0] & ~0x1))
+		if (!arm_mmu_hw_dbm_supported() || (cap->args[0] & ~0x3))
 			r = -EINVAL;
 
 		enable_hw_dirty_log = !!(cap->args[0] & 0x1);
+		enable_sync_parallel = !!(cap->args[0] & 0x2);
+		if (!enable_hw_dirty_log && enable_sync_parallel)
+			r = -EINVAL;
+
 		if (!!(kvm->arch.vtcr & VTCR_EL2_HD) != enable_hw_dirty_log) {
 			if (enable_hw_dirty_log)
 				kvm->arch.vtcr |= VTCR_EL2_HD;
@@ -119,6 +124,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			}
 		}
 
+		kvm->arch.sync_dirty_log_parallel = enable_sync_parallel;
+
 		r = 0;
 		break;
 #endif
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a48554accb0..be360e0fd20b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2548,15 +2548,55 @@ static void stage2_sync_dirty_log_range(struct kvm *kvm, phys_addr_t addr,
 
 	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
 	do {
-		cond_resched_lock(&kvm->mmu_lock);
-		if (!READ_ONCE(kvm->arch.pgd))
-			break;
+		if (!kvm->arch.sync_dirty_log_parallel) {
+			cond_resched_lock(&kvm->mmu_lock);
+			if (!READ_ONCE(kvm->arch.pgd))
+				break;
+		}
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (stage2_pgd_present(kvm, *pgd))
 			stage2_sync_dirty_log_p4ds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
+static struct dirty_sync_task {
+	struct kvm *kvm;
+	struct kvm_memory_slot *memslot;
+	u32 cpu_cnt;
+	u16 cpu_idx_map[NR_CPUS];
+	u32 ite_npages;
+	u32 ite;
+	bool finished;
+} sync_task;
+
+static void stage2_sync_dirty_log_smp(void *task)
+{
+	struct dirty_sync_task *t = task;
+	struct kvm_memory_slot *memslot = t->memslot;
+	unsigned long ite_idx, base_page, end_page;
+	gfn_t base_gfn;
+
+	ite_idx = t->cpu_cnt * t->ite + t->cpu_idx_map[smp_processor_id()];
+
+	base_page = ite_idx * t->ite_npages;
+	if (base_page >= memslot->npages) {
+		t->finished = true;
+		trace_printk("stage2_sync_dirty_log_smp finished 1.\n");
+		return;
+	}
+
+	end_page = min(memslot->npages, base_page + t->ite_npages);
+	if (end_page == memslot->npages) {
+		t->finished = true;
+		trace_printk("stage2_sync_dirty_log_smp finished 2.\n");
+	}
+
+	base_gfn = memslot->base_gfn;
+	trace_printk("base_page 0x%lx, end_page 0x%lx.\n", base_page, end_page);
+	stage2_sync_dirty_log_range(t->kvm, (base_gfn + base_page) << PAGE_SHIFT,
+				    (base_gfn + end_page) << PAGE_SHIFT);
+}
+
 /**
  * kvm_mmu_sync_dirty_log() - synchronize dirty log from stage2 PTEs for
  * memory slot
@@ -2577,18 +2617,52 @@ void kvm_mmu_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+	u32 ite_npages, cpu_cnt, this_cpu, cpu;
+	u16 cpu_idx;
 	int srcu_idx;
 
 	if (WARN_ON_ONCE(!memslot->dirty_bitmap))
 		return;
 
+	get_online_cpus();
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 
-	stage2_sync_dirty_log_range(kvm, start, end);
+	ite_npages = (1 << 17); /* 512MB max for per iteration and CPU */
+	cpu_cnt = num_online_cpus();
+
+	/* Use single CPU */
+	if (!kvm->arch.sync_dirty_log_parallel ||
+	    memslot->npages <= ite_npages ||
+	    unlikely(cpu_cnt == 1)) {
+		stage2_sync_dirty_log_range(kvm, start, end);
+		goto out_unlock;
+	}
 
+	/* Use many CPUs through IPI */
+	cpu_idx = 0;
+	this_cpu = smp_processor_id();
+	for_each_online_cpu(cpu) {
+		if (cpu != this_cpu)
+			sync_task.cpu_idx_map[cpu] = cpu_idx++;
+	}
+
+	sync_task.kvm = kvm;
+	sync_task.memslot = memslot;
+	sync_task.cpu_cnt = cpu_cnt - 1; /* Not include this CPU */
+	sync_task.ite_npages = ite_npages;
+
+	sync_task.ite = 0;
+	sync_task.finished = false;
+	do {
+		smp_call_function(stage2_sync_dirty_log_smp, &sync_task, 1);
+		sync_task.ite++;
+	} while (!sync_task.finished);
+
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	put_online_cpus();
 }
 
 /**
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index a3be703dd54b..4171d6c1d400 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -85,7 +85,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 #ifdef CONFIG_ARM64_HW_AFDBM
 	case KVM_CAP_ARM_HW_DIRTY_LOG:
-		r = arm_mmu_hw_dbm_supported();
+		r = arm_mmu_hw_dbm_supported() ? 0x3 : 0x0;
 		break;
 #endif /* CONFIG_ARM64_HW_AFDBM */
 	default:
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
