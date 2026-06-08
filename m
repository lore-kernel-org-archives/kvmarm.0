Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26B73EFFA6;
	Mon,  8 Jun 2026 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929802; cv=none; b=Fn88qfsWQnRdlWkcdhYwUx15UrgZvZ+7w681Ds7uJsr0/R7SGri8edJBmObDrYPeef/jigGDFUSPtHDcLcwAEwbf0q3cvzv/Hk+OMcN/h7uN28kj1hPdlq/Ov5pKfMegm739v8HQoX4s1dkmDdDcTa3Ul0BLwpC/IlRlOG1XI1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929802; c=relaxed/simple;
	bh=o7zI0ZsZq1gnAsfw3zddX3o8Ol6pDt5U+2vJejF1D64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2Pl6WDmUjozCAl3uIlkA4losq2YZVL0aejbct/BD33Ea5FYrKnNrdXmUeTRoEx6UGTD7i8anF0rJGKg8Tj2Mvwl+L9dtYRYBp1x//iS8raZySaO3SxrHmyeVRWmE9h09tnKUrS5mb6oXU5iRmRVAVZFvHAH4dSehtWZYaL7jPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 7E4DA2028B3;
	Mon,  8 Jun 2026 16:43:08 +0200 (CEST)
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
Subject: [PATCH 16/60] kvm: Add accessors for kvm_vcpu->mutex
Date: Mon,  8 Jun 2026 16:42:08 +0200
Message-ID: <20260608144252.351443-17-joro@8bytes.org>
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

Use accessors to manage the mutex so it is easier to move it to
another struct.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/arm64/kvm/arm.c                  |  4 ++--
 arch/arm64/kvm/inject_fault.c         |  4 ++--
 arch/powerpc/kvm/book3s_xics.c        |  4 ++--
 arch/powerpc/kvm/book3s_xive.c        |  4 ++--
 arch/powerpc/kvm/book3s_xive_native.c |  4 ++--
 arch/riscv/kvm/aia_device.c           |  4 ++--
 arch/s390/kvm/interrupt.c             |  8 ++++----
 arch/s390/kvm/kvm-s390.c              |  8 ++++----
 arch/s390/kvm/pv.c                    |  2 +-
 arch/x86/kvm/svm/sev.c                |  2 +-
 arch/x86/kvm/vmx/nested.h             |  4 ++--
 arch/x86/kvm/x86.c                    |  4 ++--
 include/linux/kvm_host.h              | 15 +++++++++++++++
 virt/kvm/kvm_main.c                   | 24 ++++++++++++------------
 14 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index de00088c9a80..295d7f19e4de 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -527,10 +527,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_LOCKDEP
 	/* Inform lockdep that the config_lock is acquired after vcpu->mutex */
-	mutex_lock(&vcpu->mutex);
+	kvm_vcpu_lock(vcpu);
 	mutex_lock(&vcpu->kvm->arch.config_lock);
 	mutex_unlock(&vcpu->kvm->arch.config_lock);
-	mutex_unlock(&vcpu->mutex);
+	kvm_vcpu_unlock(vcpu);
 #endif
 
 	/* Force users to call KVM_ARM_VCPU_INIT */
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 89982bd3345f..000d94ed7948 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -248,7 +248,7 @@ static bool kvm_sea_target_is_el2(struct kvm_vcpu *vcpu)
 
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 {
-	lockdep_assert_held(&vcpu->mutex);
+	lockdep_assert_held(kvm_vcpu_mutex(vcpu));
 
 	if (is_nested_ctxt(vcpu) && kvm_sea_target_is_el2(vcpu))
 		return kvm_inject_nested_sea(vcpu, iabt, addr);
@@ -367,7 +367,7 @@ static bool kvm_serror_undeliverable_at_el2(struct kvm_vcpu *vcpu)
 
 int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 {
-	lockdep_assert_held(&vcpu->mutex);
+	lockdep_assert_held(kvm_vcpu_mutex(vcpu));
 
 	if (is_nested_ctxt(vcpu) && kvm_serror_target_is_el2(vcpu))
 		return kvm_inject_nested_serror(vcpu, esr);
diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index 74a44fa702b0..a9afd9df2690 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -1361,9 +1361,9 @@ static void kvmppc_xics_release(struct kvm_device *dev)
 		 * have been cleared and the vcpu will not be going into the
 		 * XICS code anymore.
 		 */
-		mutex_lock(&vcpu->mutex);
+		kvm_vcpu_lock(vcpu);
 		kvmppc_xics_free_icp(vcpu);
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 	}
 
 	if (kvm)
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 1d67237783b7..e0c68e86f951 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2668,9 +2668,9 @@ static void kvmppc_xive_release(struct kvm_device *dev)
 		 * be executing the XIVE push or pull code or accessing
 		 * the XIVE MMIO regions.
 		 */
-		mutex_lock(&vcpu->mutex);
+		kvm_vcpu_lock(vcpu);
 		kvmppc_xive_cleanup_vcpu(vcpu);
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 	}
 
 	/*
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 728b5606dd14..40e93ac5fc2f 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1052,9 +1052,9 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
 		 * be executing the XIVE push or pull code or accessing
 		 * the XIVE MMIO regions.
 		 */
-		mutex_lock(&vcpu->mutex);
+		kvm_vcpu_lock(vcpu);
 		kvmppc_xive_native_cleanup_vcpu(vcpu);
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 	}
 
 	/*
diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 3d1e81e2a36b..d98c8fddc89d 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -181,12 +181,12 @@ static int aia_imsic_addr(struct kvm *kvm, u64 *addr,
 			return -EINVAL;
 	}
 
-	mutex_lock(&vcpu->mutex);
+	kvm_vcpu_lock(vcpu);
 	if (write)
 		vcpu_aia->imsic_addr = *addr;
 	else
 		*addr = vcpu_aia->imsic_addr;
-	mutex_unlock(&vcpu->mutex);
+	kvm_vcpu_unlock(vcpu);
 
 	return 0;
 }
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 3bcdbbbb6891..1d66ef9f7527 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3176,12 +3176,12 @@ void kvm_s390_gisa_enable(struct kvm *kvm)
 	if (!gisa_desc)
 		return;
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
+		kvm_vcpu_lock(vcpu);
 		vcpu->arch.sie_block->gd = gisa_desc;
 		vcpu->arch.sie_block->eca |= ECA_AIV;
 		VCPU_EVENT(vcpu, 3, "AIV gisa format-%u enabled for cpu %03u",
 			   vcpu->arch.sie_block->gd & 0x3, vcpu->vcpu_id);
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 	}
 }
 
@@ -3212,10 +3212,10 @@ void kvm_s390_gisa_disable(struct kvm *kvm)
 	if (!gi->origin)
 		return;
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
+		kvm_vcpu_lock(vcpu);
 		vcpu->arch.sie_block->eca &= ~ECA_AIV;
 		vcpu->arch.sie_block->gd = 0U;
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 		VCPU_EVENT(vcpu, 3, "AIV disabled for cpu %03u", vcpu->vcpu_id);
 	}
 	kvm_s390_gisa_destroy(kvm);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8401bcad1f37..e6fe83da172f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2360,13 +2360,13 @@ int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 	 * We want to return the first failure rc and rrc, though.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
+		kvm_vcpu_lock(vcpu);
 		if (kvm_s390_pv_destroy_cpu(vcpu, &_rc, &_rrc) && !ret) {
 			*rc = _rc;
 			*rrc = _rrc;
 			ret = -EIO;
 		}
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 	}
 	/* Ensure that we re-enable gisa if the non-PV guest used it but the PV guest did not. */
 	if (use_gisa)
@@ -2398,9 +2398,9 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 		kvm_s390_gisa_disable(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
+		kvm_vcpu_lock(vcpu);
 		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 		if (r)
 			break;
 	}
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 4b865e75351c..4661cbf28199 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL_GPL(kvm_s390_pv_is_protected);
 
 bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu)
 {
-	lockdep_assert_held(&vcpu->mutex);
+	lockdep_assert_held(kvm_vcpu_mutex(vcpu));
 	return !!kvm_s390_pv_cpu_get_handle(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pv_cpu_is_protected);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d04f71836ef7..a23dcb081751 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -938,7 +938,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	u8 *d;
 	int i;
 
-	lockdep_assert_held(&vcpu->mutex);
+	lockdep_assert_held(kvm_vcpu_mutex(vcpu));
 
 	if (vcpu->arch.guest_state_protected)
 		return -EINVAL;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 213a448104af..7677dff127f1 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -57,7 +57,7 @@ bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
-	lockdep_assert_once(lockdep_is_held(&vcpu->mutex) ||
+	lockdep_assert_once(lockdep_is_held(kvm_vcpu_mutex(vcpu)) ||
 			    !refcount_read(&vcpu->kvm->users_count));
 
 	return to_vmx(vcpu)->nested.cached_vmcs12;
@@ -65,7 +65,7 @@ static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 
 static inline struct vmcs12 *get_shadow_vmcs12(struct kvm_vcpu *vcpu)
 {
-	lockdep_assert_once(lockdep_is_held(&vcpu->mutex) ||
+	lockdep_assert_once(lockdep_is_held(kvm_vcpu_mutex(vcpu)) ||
 			    !refcount_read(&vcpu->kvm->users_count));
 
 	return to_vmx(vcpu)->nested.cached_shadow_vmcs12;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6355fe7f546f..2a87359cf42f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12941,7 +12941,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
-	if (mutex_lock_killable(&vcpu->mutex))
+	if (mutex_lock_killable(kvm_vcpu_mutex(vcpu)))
 		return;
 	vcpu_load(vcpu);
 	kvm_synchronize_tsc(vcpu, NULL);
@@ -12950,7 +12950,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	/* poll control enabled by default */
 	vcpu->arch.msr_kvm_poll_control = 1;
 
-	mutex_unlock(&vcpu->mutex);
+	kvm_vcpu_unlock(vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a6aacd507c02..611bba515ac0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -999,6 +999,21 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 	unlikely(__ret);					\
 })
 
+static inline void kvm_vcpu_lock(struct kvm_vcpu *vcpu)
+{
+	mutex_lock(&vcpu->mutex);
+}
+
+static inline void kvm_vcpu_unlock(struct kvm_vcpu *vcpu)
+{
+	mutex_unlock(&vcpu->mutex);
+}
+
+static inline struct mutex *kvm_vcpu_mutex(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->mutex;
+}
+
 static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_PROVE_RCU
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a44f8dc8418a..d6975a5c60b4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1499,7 +1499,7 @@ int kvm_trylock_all_vcpus(struct kvm *kvm)
 	lockdep_assert_held(&kvm->lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
+		if (!mutex_trylock_nest_lock(kvm_vcpu_mutex(vcpu), &kvm->lock))
 			goto out_unlock;
 	return 0;
 
@@ -1507,7 +1507,7 @@ int kvm_trylock_all_vcpus(struct kvm *kvm)
 	kvm_for_each_vcpu(j, vcpu, kvm) {
 		if (i == j)
 			break;
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 	}
 	return -EINTR;
 }
@@ -1522,7 +1522,7 @@ int kvm_lock_all_vcpus(struct kvm *kvm)
 	lockdep_assert_held(&kvm->lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		r = mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock);
+		r = mutex_lock_killable_nest_lock(kvm_vcpu_mutex(vcpu), &kvm->lock);
 		if (r)
 			goto out_unlock;
 	}
@@ -1532,7 +1532,7 @@ int kvm_lock_all_vcpus(struct kvm *kvm)
 	kvm_for_each_vcpu(j, vcpu, kvm) {
 		if (i == j)
 			break;
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 	}
 	return r;
 }
@@ -1546,7 +1546,7 @@ void kvm_unlock_all_vcpus(struct kvm *kvm)
 	lockdep_assert_held(&kvm->lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		mutex_unlock(&vcpu->mutex);
+		kvm_vcpu_unlock(vcpu);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_unlock_all_vcpus);
 
@@ -4353,14 +4353,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	 * vCPU doesn't exist.  As a bonus, taking vcpu->mutex ensures lockdep
 	 * knows it's taken *inside* kvm->lock.
 	 */
-	mutex_lock(&vcpu->mutex);
+	kvm_vcpu_lock(vcpu);
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
 	if (r < 0)
 		goto kvm_put_xa_erase;
 
 	kvm_vcpu_finish_common(vcpu);
-	mutex_unlock(&vcpu->mutex);
+	kvm_vcpu_unlock(vcpu);
 
 	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_postcreate(vcpu);
@@ -4368,7 +4368,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	return r;
 
 kvm_put_xa_erase:
-	mutex_unlock(&vcpu->mutex);
+	kvm_vcpu_unlock(vcpu);
 	kvm_put_kvm_no_destroy(kvm);
 	xa_erase(&kvm->planes[0]->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
@@ -4509,10 +4509,10 @@ static int kvm_wait_for_vcpu_online(struct kvm_vcpu *vcpu)
 	 * complete (kvm_vm_ioctl_create_vcpu() holds the mutex until the vCPU
 	 * is fully online).
 	 */
-	if (mutex_lock_killable(&vcpu->mutex))
+	if (mutex_lock_killable(kvm_vcpu_mutex(vcpu)))
 		return -EINTR;
 
-	mutex_unlock(&vcpu->mutex);
+	kvm_vcpu_unlock(vcpu);
 
 	if (WARN_ON_ONCE(!kvm_get_vcpu(kvm, vcpu->vcpu_idx)))
 		return -EIO;
@@ -4552,7 +4552,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (r != -ENOIOCTLCMD)
 		return r;
 
-	if (mutex_lock_killable(&vcpu->mutex))
+	if (mutex_lock_killable(kvm_vcpu_mutex(vcpu)))
 		return -EINTR;
 	switch (ioctl) {
 	case KVM_RUN: {
@@ -4764,7 +4764,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
 out:
-	mutex_unlock(&vcpu->mutex);
+	kvm_vcpu_unlock(vcpu);
 	kfree(fpu);
 	kfree(kvm_sregs);
 	return r;
-- 
2.53.0

