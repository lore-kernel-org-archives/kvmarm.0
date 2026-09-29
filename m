Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E3E51AFDC
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678246; cv=none; b=sD4k0cb5EFWekRCNaRp26z4oS9PmN+nXFEhGtMCFOPF01uy15QV138HRJqb1ekKxQrCCHaP3uxAlaHm9CBbgwlclRk0StEQZd6GsR0SmcYKQZeiq9iu+5MZ+8e3GZ+2C2bjAYiKkIylgWW/LmMnJJeNGyLLKmVzM3SEA3JliGMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678246; c=relaxed/simple;
	bh=xOzV7sX8Hl1oUH6thulieIiyIW9WreMN6lm/eWJySZ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7nr+MUKluvasqjHQI4lSWv3aqCJs7rnkO/6ou/kqC4c7xMd2gZFf83bIgZ7g61fXSEDcan2ujUBRjpbT3nb7C4clU+uCUw7FKjciYXHbejUentv4CWjgivLDuK4i81ypn3qqxZ2JknJKlq+S4KA+Sy5X6Eik4qQRVgp0PXyuQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gD4gRAxf; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gD4gRAxf"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UhCl5i1QqeG6DsLGoEVhwhQZILgarOVG0u5bGP7j+qo=;
	b=gD4gRAxfs4SbgG+kI4hny6tT0fFtf6zYwuRXd+A1rHopu/M32i+ZYP0i2JRO2/OpYIT6FslfL
	1ROClicrUEOgjqdQ49NYH7Uy3alwpWNcfktQyCVzkFtybvL3MuPk6rUUpaSmdw6qdZRxzzbAQe2
	Pks7TeWi8tA5K0TNNNsmNGo=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hvDnc0xypz1prLc;
	Tue, 29 Sep 2026 18:24:52 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id E1A5E203C8;
	Tue, 29 Sep 2026 18:37:02 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 18:37:01 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<zhengtian10@huawei.com>, <leo.bras@arm.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <tangchengchang@huawei.com>,
	<yezhenyu2@huawei.com>, <yubihong@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>,
	<mark.rutland@arm.com>, <seanjc@google.com>, <rdunlap@infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<skhan@linuxfoundation.org>
Subject: [PATCH v5 08/15] KVM: arm64: Flush the HDBSS buffer on VM exit
Date: Tue, 29 Sep 2026 18:36:48 +0800
Message-ID: <20260929103655.85107-9-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260929103655.85107-1-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

From: Eillon <yezhenyu2@huawei.com>

HDBSS entries accumulate in the per-vCPU buffer while the guest runs,
and must be drained into the dirty bitmap or dirty ring before
userspace can observe them.

Drain the buffer at a single point: kvm_arch_vcpu_ioctl_run() flushes
it on every VM exit, before the exit reason is handled. Flushing
inside the run loop keeps the dirty-ring feedback timely: when a flush
pushes the ring past its soft limit, kvm_dirty_ring_push() raises
KVM_REQ_DIRTY_RING_SOFT_FULL, which check_vcpu_requests() observes at
the top of the next loop iteration, so the vCPU exits to userspace for
the harvest before re-entering the guest.

kvm_arch_sync_dirty_log() relies on the exit path to flush: it kicks
vCPUs out of guest mode, and the GET/CLEAR protocol tolerates
concurrent bitmap writes, so the snapshot is complete without extra
synchronization.

Signed-off-by: Eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_dirty_bit.h | 15 +++++++++
 arch/arm64/kvm/arm.c                   | 20 ++++++++++++
 arch/arm64/kvm/dirty_bit.c             | 45 ++++++++++++++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
index fe703f02626b..d828e6b43fe9 100644
--- a/arch/arm64/include/asm/kvm_dirty_bit.h
+++ b/arch/arm64/include/asm/kvm_dirty_bit.h
@@ -13,6 +13,9 @@
 #include <asm/sysreg.h>
 #include <linux/sizes.h>

+#define HDBSS_ENTRY_VALID	BIT(0)
+#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
+
 #define KVM_ARM_HDBSS_DEFAULT_SIZE  PAGE_SIZE
 #define KVM_ARM_HDBSS_MAX_SIZE      SZ_2M

@@ -22,7 +25,19 @@ static inline u32 kvm_hdbss_buffer_size(struct kvm *kvm)
 	return kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
 }

+static inline bool kvm_hdbss_enabled(struct kvm *kvm)
+{
+	return kvm->arch.mmu.vtcr & VTCR_EL2_HDBSS;
+}
+
+static inline bool vcpu_hdbss_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.hw_mmu &&
+		(vcpu->arch.hw_mmu->vtcr & VTCR_EL2_HDBSS);
+}
+
 int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
+void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);

 #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5ea4ac26995e..9d7bdece149a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1430,6 +1430,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)

 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));

+		/*
+		 * Drain the HDBSS buffer before the exit is handled, so
+		 * entries pushed to the dirty ring are accounted for by
+		 * dirty_ring_check_request() on the next iteration.
+		 */
+		if (vcpu_hdbss_enabled(vcpu))
+			kvm_flush_hdbss_buffer(vcpu);
+
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, ret);

@@ -2017,7 +2025,19 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,

 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	unsigned long i;
+	struct kvm_vcpu *vcpu;

+	if (!kvm_hdbss_enabled(kvm))
+		return;
+
+	/*
+	 * The buffer is drained on every VM exit, so kicking running
+	 * vCPUs is enough to flush them; the dirty-log GET/CLEAR
+	 * protocol tolerates bits set concurrently with the snapshot.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vcpu_kick(vcpu);
 }

 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index f9aeb9f34ad0..be0d12555c84 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -13,6 +13,7 @@
 #include <linux/kconfig.h>
 #include <linux/log2.h>
 #include <linux/mm.h>
+#include <linux/srcu.h>

 int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu)
 {
@@ -53,3 +54,47 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
 	vcpu->arch.hdbss.hdbss_pg = NULL;
 	vcpu->arch.hdbss.hdbssbr_el2 = 0;
 }
+
+void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
+{
+	int idx, curr_idx;
+	u64 prod;
+	u32 entries;
+	u64 *hdbss_buf;
+	struct kvm *kvm = vcpu->kvm;
+	int srcu_idx;
+
+	if (!vcpu_hdbss_enabled(vcpu))
+		return;
+
+	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
+	curr_idx = HDBSSPROD_IDX(prod);
+
+	if (curr_idx == 0 || !vcpu->arch.hdbss.hdbss_pg)
+		return;
+
+	hdbss_buf = page_address(vcpu->arch.hdbss.hdbss_pg);
+	if (!hdbss_buf)
+		return;
+
+	entries = kvm_hdbss_buffer_size(kvm) / sizeof(u64);
+
+	/* kvm_vcpu_mark_page_dirty() resolves the memslot under SRCU. */
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	for (idx = 0; idx < min_t(u32, curr_idx, entries); idx++) {
+		u64 gpa;
+
+		gpa = hdbss_buf[idx];
+		if (!(gpa & HDBSS_ENTRY_VALID))
+			continue;
+
+		gpa &= HDBSS_ENTRY_IPA;
+		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
+	}
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	prod &= ~HDBSSPROD_EL2_INDEX_MASK;
+	write_sysreg_s(prod, SYS_HDBSSPROD_EL2);
+	vcpu->arch.hdbss.hdbssprod_el2 = prod;
+	isb();
+}
--
2.43.0

