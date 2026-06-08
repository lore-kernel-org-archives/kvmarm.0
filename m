Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7903A3F0744;
	Mon,  8 Jun 2026 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929807; cv=none; b=W1EMiVUReU+mItKLoQDSloa0uWMwgTwVGcm2moq62NDw90gILngVeGba2/qQEdPCNkvuh6KLcse7MWnqipgVi8n/S5wovU/dyFaFZb2StRcMvQ1nnR74Y2t+vkZVUMEKQuKh4hw2UhHZeUlewKSu+vnaXjhrhRnV2JoUjNsv+xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929807; c=relaxed/simple;
	bh=FnTf8S9kceE//yWUAiWOlH/RuuDXZNz3gKPjWMroS5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e779FS7iIABaKAGoxxirW0sQuvrh3O8OjpMxbkc3dUWn1FxzS9511/7SFvRsR9PwF1UAlZdF9GxdHJhU2WcxV2ZZrKc+gea07bCmSZmq7EKvF1uNnYjBNC2dTMvSUSqs5Z+x/bkyIUlLw9+IWkY+Ni221a17Rm6pKWaV8Xq35Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 265112028BA;
	Mon,  8 Jun 2026 16:43:09 +0200 (CEST)
From: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com
Subject: [PATCH 19/60] kvm: Introduce accessors for kvm_vcpu->mode
Date: Mon,  8 Jun 2026 16:42:11 +0200
Message-ID: <20260608144252.351443-20-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <joerg.roedel@amd.com>

Introduce accessors to make it easier to move this member of struct
kvm_vcpu.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/arm64/kvm/arm.c         |  6 +++---
 arch/loongarch/kvm/vcpu.c    |  6 +++---
 arch/mips/kvm/mips.c         |  6 +++---
 arch/powerpc/kvm/book3s_pr.c |  2 +-
 arch/powerpc/kvm/booke.c     |  2 +-
 arch/powerpc/kvm/powerpc.c   |  2 +-
 arch/riscv/kvm/vcpu.c        |  6 +++---
 arch/x86/kvm/lapic.c         |  3 ++-
 arch/x86/kvm/mmu/mmu.c       |  4 ++--
 arch/x86/kvm/svm/svm.c       |  2 +-
 arch/x86/kvm/vmx/common.h    |  2 +-
 arch/x86/kvm/x86.c           |  8 ++++----
 include/linux/kvm_host.h     | 25 +++++++++++++++++++++++++
 virt/kvm/kvm_main.c          |  4 ++--
 14 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 295d7f19e4de..001f83f737ea 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1298,10 +1298,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
 		 * Documentation/virt/kvm/vcpu-requests.rst
 		 */
-		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		kvm_vcpu_set_mode_mb(vcpu, IN_GUEST_MODE);
 
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
+			kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			if (kvm_vcpu_has_pmu(vcpu))
 				kvm_pmu_sync_hwstate(vcpu);
@@ -1323,7 +1323,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
+		kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 		vcpu->stat.exits++;
 		/*
 		 * Back from guest
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index bde8b68b8273..bab3c66ae58d 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -311,7 +311,7 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_deliver_intr(vcpu);
 		kvm_deliver_exception(vcpu);
 		/* Make sure the vcpu mode has been written */
-		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		kvm_vcpu_set_mode_mb(vcpu, IN_GUEST_MODE);
 		kvm_check_vpid(vcpu);
 
 		/*
@@ -329,7 +329,7 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 				kvm_make_request(KVM_REQ_PMU, vcpu);
 			}
 			/* make sure the vcpu mode has been written */
-			smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
+			kvm_vcpu_set_mode_mb(vcpu, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			ret = -EAGAIN;
 		}
@@ -348,7 +348,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	u32 intr = estat & CSR_ESTAT_IS;
 	u32 ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
 
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 
 	/* Set a default exit reason */
 	run->exit_reason = KVM_EXIT_UNKNOWN;
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 6469ec246dd6..776aba0af096 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -448,7 +448,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	 * flush request while the requester sees the VCPU as outside of guest
 	 * mode and not needing an IPI.
 	 */
-	smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+	kvm_vcpu_set_mode_mb(vcpu, IN_GUEST_MODE);
 
 	r = kvm_mips_vcpu_enter_exit(vcpu);
 
@@ -1175,7 +1175,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 	u32 inst;
 	int ret = RESUME_GUEST;
 
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 
 	/* Set a default exit reason */
 	run->exit_reason = KVM_EXIT_UNKNOWN;
@@ -1329,7 +1329,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		 * or we could miss a TLB flush request while the requester sees
 		 * the VCPU as outside of guest mode and not needing an IPI.
 		 */
-		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		kvm_vcpu_set_mode_mb(vcpu, IN_GUEST_MODE);
 
 		kvm_mips_callbacks->vcpu_reenter(vcpu);
 
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 2ba2dd26a7ea..0a14870f1d33 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1852,7 +1852,7 @@ static int kvmppc_vcpu_run_pr(struct kvm_vcpu *vcpu)
 
 	srr_regs_clobbered();
 out:
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 	return ret;
 }
 
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index f3ddb24ece74..08b3180adc83 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -823,7 +823,7 @@ int kvmppc_vcpu_run(struct kvm_vcpu *vcpu)
 #endif
 
 out:
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 	return ret;
 }
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 800867c164c6..5d94e0f676ec 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -98,7 +98,7 @@ int kvmppc_prepare_to_enter(struct kvm_vcpu *vcpu)
 			break;
 		}
 
-		vcpu->mode = IN_GUEST_MODE;
+		kvm_vcpu_set_mode(vcpu, IN_GUEST_MODE);
 
 		/*
 		 * Reading vcpu->requests must happen after setting vcpu->mode,
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8519a5bfbdc4..66cde226eb87 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -903,7 +903,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
 		 * Documentation/virt/kvm/vcpu-requests.rst
 		 */
-		vcpu->mode = IN_GUEST_MODE;
+		kvm_vcpu_set_mode(vcpu, IN_GUEST_MODE);
 
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		smp_mb__after_srcu_read_unlock();
@@ -920,7 +920,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (kvm_riscv_gstage_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu) ||
 		    xfer_to_guest_mode_work_pending()) {
-			vcpu->mode = OUTSIDE_GUEST_MODE;
+			kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
 			preempt_enable();
 			kvm_vcpu_srcu_read_lock(vcpu);
@@ -941,7 +941,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_riscv_vcpu_enter_exit(vcpu, &trap);
 
-		vcpu->mode = OUTSIDE_GUEST_MODE;
+		kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 		vcpu->stat.exits++;
 
 		/* Syncup interrupts state with HW */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ab40a2e4ab9d..1b763f164951 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -200,7 +200,8 @@ static bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 
 static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return kvm_can_post_timer_interrupt(vcpu) && vcpu->mode == IN_GUEST_MODE;
+	return kvm_can_post_timer_interrupt(vcpu) &&
+	       kvm_vcpu_mode(vcpu) == IN_GUEST_MODE;
 }
 
 static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f0144ae8d891..0cec559f59b1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -574,7 +574,7 @@ static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 		 * Make sure a following spte read is not reordered ahead of the write
 		 * to vcpu->mode.
 		 */
-		smp_store_mb(vcpu->mode, READING_SHADOW_PAGE_TABLES);
+		kvm_vcpu_set_mode_mb(vcpu, READING_SHADOW_PAGE_TABLES);
 	}
 }
 
@@ -588,7 +588,7 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 		 * reads to sptes.  If it does, kvm_mmu_commit_zap_page() can see us
 		 * OUTSIDE_GUEST_MODE and proceed to free the shadow page table.
 		 */
-		smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
+		kvm_vcpu_set_mode_release(vcpu, OUTSIDE_GUEST_MODE);
 		local_irq_enable();
 	}
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f5cc30a6732f..e8ad880a4266 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3870,7 +3870,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 	 * apic->apicv_active must be read after vcpu->mode.
 	 * Pairs with smp_store_release in vcpu_enter_guest.
 	 */
-	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
+	bool in_guest_mode = (kvm_vcpu_mode_acquire(vcpu) == IN_GUEST_MODE);
 
 	/* Note, this is called iff the local APIC is in-kernel. */
 	if (!READ_ONCE(vcpu->arch.apic->apicv_active)) {
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 412d0829d7a2..fe480f7cf55e 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -112,7 +112,7 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 						     int pi_vec)
 {
 #ifdef CONFIG_SMP
-	if (vcpu->mode == IN_GUEST_MODE) {
+	if (kvm_vcpu_mode(vcpu) == IN_GUEST_MODE) {
 		/*
 		 * The vector of the virtual has already been set in the PIR.
 		 * Send a notification event to deliver the virtual interrupt
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2a87359cf42f..50601ac2828f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2272,7 +2272,7 @@ static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
 	xfer_to_guest_mode_prepare();
 
-	return READ_ONCE(vcpu->mode) == EXITING_GUEST_MODE ||
+	return kvm_vcpu_mode(vcpu) == EXITING_GUEST_MODE ||
 	       kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending();
 }
 
@@ -11391,7 +11391,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 
 	/* Store vcpu->apicv_active before vcpu->mode.  */
-	smp_store_release(&vcpu->mode, IN_GUEST_MODE);
+	kvm_vcpu_set_mode_release(vcpu, IN_GUEST_MODE);
 
 	kvm_vcpu_srcu_read_unlock(vcpu);
 
@@ -11420,7 +11420,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_x86_call(sync_pir_to_irr)(vcpu);
 
 	if (kvm_vcpu_exit_request(vcpu)) {
-		vcpu->mode = OUTSIDE_GUEST_MODE;
+		kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 		smp_wmb();
 		local_irq_enable();
 		preempt_enable();
@@ -11539,7 +11539,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	kvm_vcpu_set_mode(vcpu, OUTSIDE_GUEST_MODE);
 	smp_wmb();
 
 	kvm_load_xfeatures(vcpu, false);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c08ede1cefd2..45286b3b35c9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -440,6 +440,31 @@ static inline bool kvm_vcpu_scheduled_out(struct kvm_vcpu *vcpu)
 	return vcpu->common->scheduled_out;
 }
 
+static inline int kvm_vcpu_mode(struct kvm_vcpu *vcpu)
+{
+	return vcpu->mode;
+}
+
+static inline int kvm_vcpu_mode_acquire(struct kvm_vcpu *vcpu)
+{
+	return smp_load_acquire(&vcpu->mode);
+}
+
+static inline void kvm_vcpu_set_mode(struct kvm_vcpu *vcpu, int mode)
+{
+	vcpu->mode = mode;
+}
+
+static inline void kvm_vcpu_set_mode_mb(struct kvm_vcpu *vcpu, int mode)
+{
+	smp_store_mb(vcpu->mode, mode);
+}
+
+static inline void kvm_vcpu_set_mode_release(struct kvm_vcpu *vcpu, int mode)
+{
+	smp_store_release(&vcpu->mode, mode);
+}
+
 /*
  * Start accounting time towards a guest.
  * Must be called before entering guest context.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 11e0d4af82df..7ea20d96bc89 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3960,8 +3960,8 @@ void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait)
 	 * within the vCPU thread itself.
 	 */
 	if (vcpu == kvm_get_running_vcpu()) {
-		if (vcpu->mode == IN_GUEST_MODE)
-			WRITE_ONCE(vcpu->mode, EXITING_GUEST_MODE);
+		if (kvm_vcpu_mode(vcpu) == IN_GUEST_MODE)
+			kvm_vcpu_set_mode(vcpu, EXITING_GUEST_MODE);
 		goto out;
 	}
 
-- 
2.53.0

