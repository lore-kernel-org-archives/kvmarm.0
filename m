Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FACC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 19:21:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C3456124A
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 19:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6C3456124A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12E5D4B174;
	Fri,  5 Nov 2021 15:21:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N7uStgMDcybJ; Fri,  5 Nov 2021 15:21:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F3F54B191;
	Fri,  5 Nov 2021 15:21:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C62034B174
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 15:21:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tahZlfN0V6DX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 15:21:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF6CF4B13D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 15:21:30 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E63B361244;
 Fri,  5 Nov 2021 19:21:29 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mj4mG-003ig2-1u; Fri, 05 Nov 2021 19:21:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/5] KVM: Move wiping of the kvm->vcpus array to common code
Date: Fri,  5 Nov 2021 19:20:57 +0000
Message-Id: <20211105192101.3862492-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211105192101.3862492-1-maz@kernel.org>
References: <20211105192101.3862492-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
 chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, anup.patel@wdc.com,
 atish.patra@wdc.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, imbrenda@linux.ibm.com, pbonzini@redhat.com, jgross@suse.com,
 npiggin@gmail.com, seanjc@google.com, paulus@samba.org, mpe@ellerman.id.au,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Juergen Gross <jgross@suse.com>, Huacai Chen <chenhuacai@kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Anup Patel <anup.patel@wdc.com>, David Hildenbrand <david@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, kernel-team@android.com,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
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

All architectures have similar loops iterating over the vcpus,
freeing one vcpu at a time, and eventually wiping the reference
off the vcpus array. They are also inconsistently taking
the kvm->lock mutex when wiping the references from the array.

Make this code common, which will simplify further changes.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c       | 10 +---------
 arch/mips/kvm/mips.c       | 21 +--------------------
 arch/powerpc/kvm/powerpc.c | 10 +---------
 arch/riscv/kvm/vm.c        | 10 +---------
 arch/s390/kvm/kvm-s390.c   | 18 +-----------------
 arch/x86/kvm/x86.c         |  9 +--------
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/kvm_main.c        | 20 ++++++++++++++++++--
 8 files changed, 25 insertions(+), 75 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f5490afe1ebf..75bb7215da03 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -175,19 +175,11 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
  */
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	int i;
-
 	bitmap_free(kvm->arch.pmu_filter);
 
 	kvm_vgic_destroy(kvm);
 
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (kvm->vcpus[i]) {
-			kvm_vcpu_destroy(kvm->vcpus[i]);
-			kvm->vcpus[i] = NULL;
-		}
-	}
-	atomic_set(&kvm->online_vcpus, 0);
+	kvm_destroy_vcpus(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 562aa878b266..ceacca74f808 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -171,25 +171,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return 0;
 }
 
-void kvm_mips_free_vcpus(struct kvm *kvm)
-{
-	unsigned int i;
-	struct kvm_vcpu *vcpu;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		kvm_vcpu_destroy(vcpu);
-	}
-
-	mutex_lock(&kvm->lock);
-
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-		kvm->vcpus[i] = NULL;
-
-	atomic_set(&kvm->online_vcpus, 0);
-
-	mutex_unlock(&kvm->lock);
-}
-
 static void kvm_mips_free_gpa_pt(struct kvm *kvm)
 {
 	/* It should always be safe to remove after flushing the whole range */
@@ -199,7 +180,7 @@ static void kvm_mips_free_gpa_pt(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	kvm_mips_free_vcpus(kvm);
+	kvm_destroy_vcpus(kvm);
 	kvm_mips_free_gpa_pt(kvm);
 }
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 35e9cccdeef9..492e4a4121cb 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -463,9 +463,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	unsigned int i;
-	struct kvm_vcpu *vcpu;
-
 #ifdef CONFIG_KVM_XICS
 	/*
 	 * We call kick_all_cpus_sync() to ensure that all
@@ -476,14 +473,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		kick_all_cpus_sync();
 #endif
 
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_vcpu_destroy(vcpu);
+	kvm_destroy_vcpus(kvm);
 
 	mutex_lock(&kvm->lock);
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-		kvm->vcpus[i] = NULL;
-
-	atomic_set(&kvm->online_vcpus, 0);
 
 	kvmppc_core_destroy_vm(kvm);
 
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 26399df15b63..6af6cde295eb 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -46,15 +46,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
-	int i;
-
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (kvm->vcpus[i]) {
-			kvm_vcpu_destroy(kvm->vcpus[i]);
-			kvm->vcpus[i] = NULL;
-		}
-	}
-	atomic_set(&kvm->online_vcpus, 0);
+	kvm_destroy_vcpus(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c6257f625929..7af53b8788fa 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2819,27 +2819,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)(vcpu->arch.sie_block));
 }
 
-static void kvm_free_vcpus(struct kvm *kvm)
-{
-	unsigned int i;
-	struct kvm_vcpu *vcpu;
-
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_vcpu_destroy(vcpu);
-
-	mutex_lock(&kvm->lock);
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-		kvm->vcpus[i] = NULL;
-
-	atomic_set(&kvm->online_vcpus, 0);
-	mutex_unlock(&kvm->lock);
-}
-
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	u16 rc, rrc;
 
-	kvm_free_vcpus(kvm);
+	kvm_destroy_vcpus(kvm);
 	sca_dispose(kvm);
 	kvm_s390_gisa_destroy(kvm);
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c1c4e2b05a63..498a43126615 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11302,15 +11302,8 @@ static void kvm_free_vcpus(struct kvm *kvm)
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_unload_vcpu_mmu(vcpu);
 	}
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_vcpu_destroy(vcpu);
-
-	mutex_lock(&kvm->lock);
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-		kvm->vcpus[i] = NULL;
 
-	atomic_set(&kvm->online_vcpus, 0);
-	mutex_unlock(&kvm->lock);
+	kvm_destroy_vcpus(kvm);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..36967291b8c6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -725,7 +725,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 		if (WARN_ON_ONCE(!memslot->npages)) {			\
 		} else
 
-void kvm_vcpu_destroy(struct kvm_vcpu *vcpu);
+void kvm_destroy_vcpus(struct kvm *kvm);
 
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..d83553eeea21 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -435,7 +435,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->last_used_slot = 0;
 }
 
-void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
@@ -450,7 +450,23 @@ void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->run);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
+
+void kvm_destroy_vcpus(struct kvm *kvm)
+{
+	unsigned int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vcpu_destroy(vcpu);
+
+	mutex_lock(&kvm->lock);
+	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
+		kvm->vcpus[i] = NULL;
+
+	atomic_set(&kvm->online_vcpus, 0);
+	mutex_unlock(&kvm->lock);
+}
+EXPORT_SYMBOL_GPL(kvm_destroy_vcpus);
 
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
