Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D317AC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 23:41:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C16410E5;
	Fri,  4 Nov 2022 19:41:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lx1MliSzBqvc; Fri,  4 Nov 2022 19:41:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A5E543479;
	Fri,  4 Nov 2022 19:41:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5725E410DE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 19:41:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3qAogBLZ0xOb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 19:41:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9AB540C1F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 19:41:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667605296;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PkED6K5Tg/V9jTVPbomAdCuQSxbvSeaJEFFiPiEaHfk=;
 b=LC3wyY8fmMwn1QU372IPFI8p3zRQ1IFMQ6nQU3dCqw7h9xGv4l3EwBZ8veRa3fDWobCheD
 fjAmDqUvQRHfkUavwK5ZnJ3EJ785dCNTr14UoBJyLGMyvuLIVPbNxa3f20SRJ7rZ7YvSLR
 vh+Ni0CZcUywfAvMTA01C06AdjQx1jY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-MnyDgqdyO3-2HvkdP61nGA-1; Fri, 04 Nov 2022 19:41:33 -0400
X-MC-Unique: MnyDgqdyO3-2HvkdP61nGA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8551A3C025C7;
 Fri,  4 Nov 2022 23:41:32 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B88A4A9254;
 Fri,  4 Nov 2022 23:41:26 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Subject: [PATCH v8 4/7] KVM: arm64: Enable ring-based dirty memory tracking
Date: Sat,  5 Nov 2022 07:40:46 +0800
Message-Id: <20221104234049.25103-5-gshan@redhat.com>
In-Reply-To: <20221104234049.25103-1-gshan@redhat.com>
References: <20221104234049.25103-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, will@kernel.org, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

Enable ring-based dirty memory tracking on arm64 by selecting
CONFIG_HAVE_KVM_DIRTY_{RING_ACQ_REL, RING_WITH_BITMAP} and providing
the ring buffer's physical page offset (KVM_DIRTY_LOG_PAGE_OFFSET).

Besides, helper kvm_vgic_save_its_tables_in_progress() is added to
indicate if vgic/its tables are being saved or not. The helper is used
in ARM64's kvm_arch_allow_write_without_running_vcpu() to keep the
site of saving vgic/its tables out of no-running-vcpu radar.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst     |  2 +-
 arch/arm64/include/uapi/asm/kvm.h  |  1 +
 arch/arm64/kvm/Kconfig             |  2 ++
 arch/arm64/kvm/arm.c               |  3 +++
 arch/arm64/kvm/mmu.c               | 15 +++++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c     |  3 +++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  7 +++++++
 include/kvm/arm_vgic.h             |  2 ++
 8 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2ec32bd41792..2fc68f684ad8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7921,7 +7921,7 @@ regardless of what has actually been exposed through the CPUID leaf.
 8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
 ----------------------------------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Parameters: args[0] - size of the dirty log ring
 
 KVM is capable of tracking dirty memory using ring buffers that are
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 316917b98707..a7a857f1784d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -43,6 +43,7 @@
 #define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 815cc118c675..066b053e9eb9 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,6 +32,8 @@ menuconfig KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
+	select HAVE_KVM_DIRTY_RING_WITH_BITMAP
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..6b097605e38c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -746,6 +746,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
+
+		if (kvm_dirty_ring_check_request(vcpu))
+			return 0;
 	}
 
 	return 1;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 60ee3d9f01f8..fbeb55e45f53 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -932,6 +932,21 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
+/*
+ * kvm_arch_allow_write_without_running_vcpu - allow writing guest memory
+ * without the running VCPU when dirty ring is enabled.
+ *
+ * The running VCPU is required to track dirty guest pages when dirty ring
+ * is enabled. Otherwise, the backup bitmap should be used to track the
+ * dirty guest pages. When vgic/its tables are being saved, the backup
+ * bitmap is used to track the dirty guest pages due to the missed running
+ * VCPU in the period.
+ */
+bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+	return kvm_vgic_save_its_tables_in_progress(kvm);
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 733b53055f97..dd340bb812bd 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2743,6 +2743,7 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
 	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT) /* Nothing to do */
@@ -2762,7 +2763,9 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		vgic_its_reset(kvm, its);
 		break;
 	case KVM_DEV_ARM_ITS_SAVE_TABLES:
+		dist->save_its_tables_in_progress = true;
 		ret = abi->save_tables(its);
+		dist->save_its_tables_in_progress = false;
 		break;
 	case KVM_DEV_ARM_ITS_RESTORE_TABLES:
 		ret = abi->restore_tables(its);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 91201f743033..b63898f86e9e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -54,6 +54,13 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
 		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
 }
 
+bool kvm_vgic_save_its_tables_in_progress(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	return dist->save_its_tables_in_progress;
+}
+
 /*
  * The Revision field in the IIDR have the following meanings:
  *
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4df9e73a8bb5..db42fbd47bcf 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -263,6 +263,7 @@ struct vgic_dist {
 	struct vgic_io_device	dist_iodev;
 
 	bool			has_its;
+	bool			save_its_tables_in_progress;
 
 	/*
 	 * Contains the attributes and gpa of the LPI configuration table.
@@ -374,6 +375,7 @@ int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
 
+bool kvm_vgic_save_its_tables_in_progress(struct kvm *kvm);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
