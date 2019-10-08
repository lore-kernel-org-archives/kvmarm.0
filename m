Return-Path: <SRS0=tYEe=YB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB0DC4360C
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 09:36:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82975217D7
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 09:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82975217D7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38E934A86A;
	Tue,  8 Oct 2019 05:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZnDZcQ44Y54Y; Tue,  8 Oct 2019 05:36:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E483E4A90A;
	Tue,  8 Oct 2019 05:36:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACC584A931
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 05:36:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QsiDgxn5DeFa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Oct 2019 05:36:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC1904A856
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 05:36:50 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74C981576;
 Tue,  8 Oct 2019 02:36:50 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 091DB3F6C4;
 Tue,  8 Oct 2019 02:36:49 -0700 (PDT)
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [kvmtool v2 4/5] arm: Handle exits from undecoded load/store
 instructions
Date: Tue,  8 Oct 2019 11:36:39 +0200
Message-Id: <20191008093640.26519-5-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191008093640.26519-1-christoffer.dall@arm.com>
References: <20191008093640.26519-1-christoffer.dall@arm.com>
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM occasionally encounters guests that attempt to access memory outside
the registered RAM memory slots using instructions that don't provide
decoding information in the ESR_EL2 (the ISV bit is not set), and
historically this has led to the kernel printing a confusing error
message in dmesg and returning -ENOYSYS from KVM_RUN.

KVM/Arm now has KVM_CAP_ARM_NISV_TO_USER, which can be enabled from
userspace, and which allows us to handle this with a little bit more
helpful information to the user.  For example, we can at least tell the
user if the guest just hit a hole in the guest's memory map, or if this
appeared to be an attempt at doing MMIO.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arm/kvm-cpu.c     | 20 +++++++++++++++++++-
 arm/kvm.c         |  8 ++++++++
 include/kvm/kvm.h |  1 +
 kvm.c             |  1 +
 mmio.c            | 11 +++++++++++
 5 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 7780251..25bd3ed 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -136,7 +136,25 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
 
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 {
-	return false;
+	switch (vcpu->kvm_run->exit_reason) {
+	case KVM_EXIT_ARM_NISV: {
+		u64 phys_addr = vcpu->kvm_run->arm_nisv.fault_ipa;
+
+		if (!arm_addr_in_ioport_region(phys_addr) &&
+		    !kvm__mmio_exists(vcpu, phys_addr))
+			die("Guest accessed memory outside RAM and IO ranges");
+
+		/*
+		 * We cannot fetch and decode instructions from a KVM guest,
+		 * which used a load/store instruction that doesn't get
+		 * decoded in the ESR towards an I/O device, so we have no
+		 * choice but to exit to the user with an error.
+		 */
+		die("Guest accessed I/O device with unsupported load/store instruction");
+	}
+	default:
+		return false;
+	}
 }
 
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
diff --git a/arm/kvm.c b/arm/kvm.c
index 1f85fc6..2572ac2 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -59,6 +59,8 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 {
+	struct kvm_enable_cap enable_cap = { .flags = 0 };
+
 	/*
 	 * Allocate guest memory. We must align our buffer to 64K to
 	 * correlate with the maximum guest page size for virtio-mmio.
@@ -83,6 +85,12 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_HUGEPAGE);
 
+	if (kvm__supports_extension(kvm, KVM_CAP_ARM_NISV_TO_USER)) {
+		enable_cap.cap = KVM_CAP_ARM_NISV_TO_USER;
+		if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &enable_cap) < 0)
+			die("unable to enable NISV_TO_USER capability");
+	}
+
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 7a73818..05d90ee 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -107,6 +107,7 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
 		      enum kvm_mem_type type);
+bool kvm__mmio_exists(struct kvm_cpu *vcpu, u64 phys_addr);
 static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
 				    void *userspace_addr)
 {
diff --git a/kvm.c b/kvm.c
index 57c4ff9..03ec43f 100644
--- a/kvm.c
+++ b/kvm.c
@@ -55,6 +55,7 @@ const char *kvm_exit_reasons[] = {
 #ifdef CONFIG_PPC64
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_PAPR_HCALL),
 #endif
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_ARM_NISV),
 };
 
 static int pause_event;
diff --git a/mmio.c b/mmio.c
index 61e1d47..2ab7fa7 100644
--- a/mmio.c
+++ b/mmio.c
@@ -139,3 +139,14 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
 
 	return true;
 }
+
+bool kvm__mmio_exists(struct kvm_cpu *vcpu, u64 phys_addr)
+{
+	struct mmio_mapping *mmio;
+
+	br_read_lock(vcpu->kvm);
+	mmio = mmio_search(&mmio_tree, phys_addr, 1);
+	br_read_unlock(vcpu->kvm);
+
+	return mmio != NULL;
+}
-- 
2.18.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
