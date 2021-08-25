Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8D2C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:17:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C1F661163
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:17:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C1F661163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF634B236;
	Wed, 25 Aug 2021 12:17:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RO5dkYWcoI9N; Wed, 25 Aug 2021 12:17:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 164B04B214;
	Wed, 25 Aug 2021 12:17:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6464B205
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nQ3dspafacSP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:17:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7264B1FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 719DA101E;
 Wed, 25 Aug 2021 09:17:13 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21E4A3F66F;
 Wed, 25 Aug 2021 09:17:11 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 01/39] KVM: arm64: Make lock_all_vcpus() available to
 the rest of KVM
Date: Wed, 25 Aug 2021 17:17:37 +0100
Message-Id: <20210825161815.266051-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

The VGIC code uses the lock_all_vcpus() function to make sure no VCPUs are
run while it fiddles with the global VGIC state. Move the declaration of
lock_all_vcpus() and the corresponding unlock function into asm/kvm_host.h
where it can be reused by other parts of KVM/arm64 and rename the functions
to kvm_{lock,unlock}_all_vcpus() to make them more generic.

Because the scope of the code potentially using the functions has
increased, add a lockdep check that the kvm->lock is held by the caller.
Holding the lock is necessary because otherwise userspace would be able to
create new VCPUs and run them while the existing VCPUs are locked.

No functional change intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h     |  3 ++
 arch/arm64/kvm/arm.c                  | 41 ++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c       |  4 +--
 arch/arm64/kvm/vgic/vgic-its.c        |  8 ++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 50 ++++-----------------------
 arch/arm64/kvm/vgic/vgic.h            |  3 --
 6 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..797083203603 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -601,6 +601,9 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+bool kvm_lock_all_vcpus(struct kvm *kvm);
+void kvm_unlock_all_vcpus(struct kvm *kvm);
+
 #ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..ddace63528f1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -647,6 +647,47 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
+/* unlocks vcpus from @vcpu_lock_idx and smaller */
+static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
+{
+	struct kvm_vcpu *tmp_vcpu;
+
+	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
+		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
+		mutex_unlock(&tmp_vcpu->mutex);
+	}
+}
+
+void kvm_unlock_all_vcpus(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->lock);
+	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
+}
+
+/* Returns true if all vcpus were locked, false otherwise */
+bool kvm_lock_all_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *tmp_vcpu;
+	int c;
+
+	lockdep_assert_held(&kvm->lock);
+
+	/*
+	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
+	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure that
+	 * no other VCPUs are run and it is safe to fiddle with KVM global
+	 * state.
+	 */
+	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
+		if (!mutex_trylock(&tmp_vcpu->mutex)) {
+			unlock_vcpus(kvm, c - 1);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 340c51d87677..6a85aa064a6c 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -87,7 +87,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		return -ENODEV;
 
 	ret = -EBUSY;
-	if (!lock_all_vcpus(kvm))
+	if (!kvm_lock_all_vcpus(kvm))
 		return ret;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
@@ -117,7 +117,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
 out_unlock:
-	unlock_all_vcpus(kvm);
+	kvm_unlock_all_vcpus(kvm);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 61728c543eb9..3a336a678cb8 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2005,7 +2005,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 		goto out;
 	}
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	if (!kvm_lock_all_vcpus(dev->kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -2023,7 +2023,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	} else {
 		*reg = region->its_read(dev->kvm, its, addr, len);
 	}
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
 	return ret;
@@ -2668,7 +2668,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 	mutex_lock(&kvm->lock);
 	mutex_lock(&its->its_lock);
 
-	if (!lock_all_vcpus(kvm)) {
+	if (!kvm_lock_all_vcpus(kvm)) {
 		mutex_unlock(&its->its_lock);
 		mutex_unlock(&kvm->lock);
 		return -EBUSY;
@@ -2686,7 +2686,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		break;
 	}
 
-	unlock_all_vcpus(kvm);
+	kvm_unlock_all_vcpus(kvm);
 	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->lock);
 	return ret;
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 7740995de982..c2f95d124cbc 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -298,44 +298,6 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 	return 0;
 }
 
-/* unlocks vcpus from @vcpu_lock_idx and smaller */
-static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
-{
-	struct kvm_vcpu *tmp_vcpu;
-
-	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
-		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
-		mutex_unlock(&tmp_vcpu->mutex);
-	}
-}
-
-void unlock_all_vcpus(struct kvm *kvm)
-{
-	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
-}
-
-/* Returns true if all vcpus were locked, false otherwise */
-bool lock_all_vcpus(struct kvm *kvm)
-{
-	struct kvm_vcpu *tmp_vcpu;
-	int c;
-
-	/*
-	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
-	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
-	 * that no other VCPUs are run and fiddle with the vgic state while we
-	 * access it.
-	 */
-	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
-		if (!mutex_trylock(&tmp_vcpu->mutex)) {
-			unlock_vcpus(kvm, c - 1);
-			return false;
-		}
-	}
-
-	return true;
-}
-
 /**
  * vgic_v2_attr_regs_access - allows user space to access VGIC v2 state
  *
@@ -366,7 +328,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 	if (ret)
 		goto out;
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	if (!kvm_lock_all_vcpus(dev->kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -383,7 +345,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 		break;
 	}
 
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
 	return ret;
@@ -532,7 +494,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		goto out;
 	}
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	if (!kvm_lock_all_vcpus(dev->kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -582,7 +544,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		break;
 	}
 
-	unlock_all_vcpus(dev->kvm);
+	kvm_unlock_all_vcpus(dev->kvm);
 out:
 	mutex_unlock(&dev->kvm->lock);
 	return ret;
@@ -637,12 +599,12 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 			mutex_lock(&dev->kvm->lock);
 
-			if (!lock_all_vcpus(dev->kvm)) {
+			if (!kvm_lock_all_vcpus(dev->kvm)) {
 				mutex_unlock(&dev->kvm->lock);
 				return -EBUSY;
 			}
 			ret = vgic_v3_save_pending_tables(dev->kvm);
-			unlock_all_vcpus(dev->kvm);
+			kvm_unlock_all_vcpus(dev->kvm);
 			mutex_unlock(&dev->kvm->lock);
 			return ret;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index dc1f3d1657ee..0511618c89f6 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -252,9 +252,6 @@ int vgic_init(struct kvm *kvm);
 void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
 
-bool lock_all_vcpus(struct kvm *kvm);
-void unlock_all_vcpus(struct kvm *kvm);
-
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *cpu_if = &vcpu->arch.vgic_cpu;
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
