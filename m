Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B83A514751
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678248; cv=none; b=D9rkOYvbjG9DN5+MH0jK6FFKGYukxKDRtzDZ/ysdqhGjSzBMq4y2N+hq25jGQzMh3gAU4F+0hZFEEBKlZjc7AceOcgzPtRJNNcTUr9lDvh2ti2Kpfhcws7btWMrXl9xTywSfhubM0XBAAp9hXB4VQeUkZpIq+RKlKQlXdyZ4yb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678248; c=relaxed/simple;
	bh=+93hM5U8N4Bh0IDUYnxzYb9Do1DsoNnLJ8ItleNrIHA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXR4x/Zc2tGnFBpauwAAom2eGSgQ4ElpKFqeLD8CrtJouAE8XoVzuQMnZANAtzlDnVDj97dVh4gFi07WuCAHJL1vS7Ky6M9u8MAJ/8NjeBx8RWCPStnubZkhPm4r2OCPm5p8VshMeeC5SAUIghRicLjgheLHwgY32gIByzKWTaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jHcKaFYd; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jHcKaFYd"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rmDQUIphJFlzenQYZdfd1cedfjoPbRRqTeAYuNnfI9g=;
	b=jHcKaFYd3fJjqJagj1xIeyMwSYMdsjiQcguDOLEzj0tl19WR/yJ0SXrGlUHW/mk7QCrW1VQ5Y
	xhaW5hEMRLECEpNfTaYWKeUqXmhg7Gk055gVJ/LKSM/i0om/C+NYedzSlVAnEsdjPjk2XzmOqra
	J22ubbEwFtuUahAF122EQHI=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hvDnl2v1Zz12LHh;
	Tue, 29 Sep 2026 18:24:59 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 183D240537;
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
Subject: [PATCH v5 07/15] KVM: arm64: Add HDBSS per-vCPU buffer management
Date: Tue, 29 Sep 2026 18:36:47 +0800
Message-ID: <20260929103655.85107-8-zhengtian10@huawei.com>
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

Each vCPU owns an HDBSS buffer, described by HDBSSBR_EL2 (base
address and encoded size) and advanced by HDBSSPROD_EL2 as hardware
appends entries. Tie the buffer lifetime to the vCPU: allocate at
vCPU creation, free at destruction. The buffer is allocated zeroed,
so a stale producer index can only ever observe invalid entries.

Registers are programmed whenever the vCPU owns a buffer, regardless
of whether HDBSS is enabled. The feature can be turned on
mid-KVM_RUN, and hardware dirty-state updates write to
HDBSSBR_EL2.BADDR without any fault, so the registers must already
be in place by then. HDBSSPROD_EL2 is preserved across context
switches and vCPU migration.

Two details: the buddy order is kept separate from the HDBSSBR_EL2.SZ
encoding, since the two only coincide on 4KB pages; and kvm_share_hyp()
is unwound in kvm_arch_vcpu_create() when the HDBSS allocation fails.

Signed-off-by: Eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_dirty_bit.h | 28 +++++++++++++
 arch/arm64/include/asm/kvm_host.h      | 13 ++++++
 arch/arm64/include/asm/sysreg.h        |  9 +++++
 arch/arm64/kvm/Makefile                |  1 +
 arch/arm64/kvm/arm.c                   | 14 ++++++-
 arch/arm64/kvm/dirty_bit.c             | 55 ++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c        | 17 ++++++++
 arch/arm64/kvm/reset.c                 |  3 ++
 8 files changed, 138 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
 create mode 100644 arch/arm64/kvm/dirty_bit.c

diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
new file mode 100644
index 000000000000..fe703f02626b
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_dirty_bit.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Per-vCPU buffer management for HDBSS-based dirty page tracking.
+ *
+ * Copyright (C) 2026 Huawei Technologies Co., Ltd
+ * Author: Tian Zheng <zhengtian10@huawei.com>
+ */
+
+#ifndef __ARM64_KVM_DIRTY_BIT_H__
+#define __ARM64_KVM_DIRTY_BIT_H__
+
+#include <asm/kvm_pgtable.h>
+#include <asm/sysreg.h>
+#include <linux/sizes.h>
+
+#define KVM_ARM_HDBSS_DEFAULT_SIZE  PAGE_SIZE
+#define KVM_ARM_HDBSS_MAX_SIZE      SZ_2M
+
+/* 0 means unconfigured, fall back to one page per vCPU. */
+static inline u32 kvm_hdbss_buffer_size(struct kvm *kvm)
+{
+	return kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
+}
+
+int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
+
+#endif /* __ARM64_KVM_DIRTY_BIT_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 86a4d6e50934..c8fc29f3db75 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -425,6 +425,9 @@ struct kvm_arch {
 	 */
 	struct kvm_protected_vm pkvm;

+	/* HDBSS: per-VM buffer size in bytes (0 = not configured, use default) */
+	u32 hdbss_buffer_size;
+
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 	/* Nested virtualization info */
 	struct dentry *debugfs_nv_dentry;
@@ -844,6 +847,13 @@ struct vcpu_reset_state {
 	bool		reset;
 };

+struct vcpu_hdbss_state {
+	struct page *hdbss_pg;		/* HDBSS buffer */
+	u64 hdbssbr_el2;		/* programmed into the CPU on load */
+	u64 hdbssprod_el2;		/* producer index, saved on put */
+	unsigned int buddy_order;	/* allocation order for __free_pages() */
+};
+
 struct vncr_tlb;

 struct kvm_vcpu_arch {
@@ -951,6 +961,9 @@ struct kvm_vcpu_arch {

 	/* Hyp-readable copy of kvm_vcpu::pid */
 	pid_t pid;
+
+	/* HDBSS buffer state */
+	struct vcpu_hdbss_state hdbss;
 };

 /*
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7aa08d59d494..7c71560b57e4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1039,6 +1039,15 @@

 #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
 					       GCS_CAP_VALID_TOKEN)
+
+/*
+ * Definitions for the HDBSS feature
+ */
+#define HDBSSBR_EL2(baddr, sz)	(((baddr) & HDBSSBR_EL2_BADDR_MASK) | \
+				 FIELD_PREP(HDBSSBR_EL2_SZ_MASK, sz))
+
+#define HDBSSPROD_IDX(prod)	FIELD_GET(HDBSSPROD_EL2_INDEX_MASK, prod)
+
 /*
  * Definitions for GICv5 instructions
  */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c..ec2749af64fa 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -18,6 +18,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
 	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
+	 dirty_bit.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d9ad765943d9..5ea4ac26995e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -36,6 +36,7 @@
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_dirty_bit.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
@@ -580,10 +581,19 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	}

 	err = kvm_share_hyp(vcpu, vcpu + 1);
-	if (err)
+	if (err) {
 		kvm_vgic_vcpu_destroy(vcpu);
+		return err;
+	}

-	return err;
+	err = kvm_arm_vcpu_alloc_hdbss(vcpu);
+	if (err) {
+		kvm_unshare_hyp(vcpu, vcpu + 1);
+		kvm_vgic_vcpu_destroy(vcpu);
+		return err;
+	}
+
+	return 0;
 }

 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
new file mode 100644
index 000000000000..f9aeb9f34ad0
--- /dev/null
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Per-vCPU HDBSS buffer management.
+ *
+ * Copyright (C) 2026 Huawei Technologies Co., Ltd
+ * Author: Tian Zheng <zhengtian10@huawei.com>
+ */
+
+#include <asm/kvm_dirty_bit.h>
+#include <asm/kvm_mmu.h>
+#include <asm/sysreg.h>
+#include <linux/gfp.h>
+#include <linux/kconfig.h>
+#include <linux/log2.h>
+#include <linux/mm.h>
+
+int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu)
+{
+	struct page *hdbss_pg;
+	u32 size;
+	unsigned int buddy_order;
+	u32 sz_encoded;
+
+	if (vcpu->arch.hdbss.hdbss_pg || !system_supports_hdbss())
+		return 0;
+
+	size = kvm_hdbss_buffer_size(vcpu->kvm);
+
+	buddy_order = get_order(size);
+	sz_encoded = ilog2(size) - 12;
+
+	hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, buddy_order);
+	if (!hdbss_pg)
+		return -ENOMEM;
+
+	vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
+		.hdbss_pg = hdbss_pg,
+		.hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), sz_encoded),
+		.hdbssprod_el2 = 0,
+		.buddy_order = buddy_order,
+	};
+
+	return 0;
+}
+
+void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->arch.hdbss.hdbss_pg)
+		return;
+
+	__free_pages(vcpu->arch.hdbss.hdbss_pg, vcpu->arch.hdbss.buddy_order);
+
+	vcpu->arch.hdbss.hdbss_pg = NULL;
+	vcpu->arch.hdbss.hdbssbr_el2 = 0;
+}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7875911c0506..922fc9260e11 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -19,6 +19,7 @@
 #include <asm/cpufeature.h>
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_dirty_bit.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
@@ -219,6 +220,17 @@ static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }

+static void __load_hdbss(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->arch.hdbss.hdbss_pg)
+		return;
+
+	write_sysreg_s(vcpu->arch.hdbss.hdbssbr_el2, SYS_HDBSSBR_EL2);
+	write_sysreg_s(vcpu->arch.hdbss.hdbssprod_el2, SYS_HDBSSPROD_EL2);
+
+	isb();
+}
+
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 {
 	host_data_ptr(host_ctxt)->__hyp_running_vcpu = vcpu;
@@ -226,10 +238,15 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 	__vcpu_load_switch_sysregs(vcpu);
 	__vcpu_load_activate_traps(vcpu);
 	__load_stage2(vcpu->arch.hw_mmu);
+	__load_hdbss(vcpu);
 }

 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 {
+	/* Saved under the same ownership condition as __load_hdbss(). */
+	if (vcpu->arch.hdbss.hdbss_pg)
+		vcpu->arch.hdbss.hdbssprod_el2 = read_sysreg_s(SYS_HDBSSPROD_EL2);
+
 	__vcpu_put_deactivate_traps(vcpu);
 	__vcpu_put_switch_sysregs(vcpu);

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 10eb7249aa9e..05ebe304830e 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -25,6 +25,7 @@
 #include <asm/ptrace.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_dirty_bit.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
@@ -149,6 +150,8 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 	kfree(vcpu->arch.vncr_tlb);
 	kfree(vcpu->arch.ccsidr);
+
+	kvm_arm_vcpu_free_hdbss(vcpu);
 }

 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
--
2.43.0

