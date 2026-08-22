Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30951AB6F1
	for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787392443; cv=none; b=JYyulvoNls29zioZGkSc0ELNqniLlfLGT3voSDor1Ys3N1UuG9yYkf6QcBiZ0WWM6jYdicDS7J/V5423G9KT0Ty2KBkJUyFdU1dGRAN3TVqf6Ti5ewSrixLvRfHdF63q7A0+CUBloy0u72AwiU9VMVn00rAd/hBIJFoFWKRGm+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787392443; c=relaxed/simple;
	bh=JkiYpsUShZAsY1TjWqWCJe4NOQB0f5121pa5w8xGrzI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jxmr7jUjoDHM29/OZfHxH45hAkHprNtfJ1GmEpWQi76hf4SF00C/YYmmxXpTYjqyXI/uw5mEJBhyHUgVnO34LLbeFY/aWnzBrL9RP03PAePPSjFJTKoj9nbZ9WDCAsMyCsFgUGAzuo/xsvy3OiwoXYnOfAS93pLsErnQskdhf88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUE1rqAR; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUE1rqAR"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a1a546a6bbso3366812a12.1
        for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 02:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787392438; x=1787997238; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t0Fit0ozccWqcIUOha2+PzcipOyCFUk6rmWi2DZINrs=;
        b=aUE1rqARoEFbjMbLDvOP1IkcN8sNTlWvIRYwga96llnK86gcgTUD6pqVHP2fyMu5BB
         mT1CETooxhzJKSMhwUbA4cuO+l05XNk81b5XcEjY1qncJSUxod9wjE362VwW6jvxvJmX
         cgh5pytvs30lSiBVMHNe0G7M0YMoHfTcnsclbS5KNdklLxMfztXEDsjMIfewOUJ3HeO5
         R6tH+ds2Ehm2TW5lesDLT1vuXb0iRB//8RCl8TevWKDoKWqajMV7DFBJOJZGEyg7ZqO6
         +Ve1W8xsJRpK1Vug4Ye/iRq2BOTlk11t3fKCe4eTFh3EBXJNXtLHB5yLYnX3V+Ok/5wl
         /xSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787392438; x=1787997238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t0Fit0ozccWqcIUOha2+PzcipOyCFUk6rmWi2DZINrs=;
        b=F63D+VNRR1KapqCf+AmHpyyZw06erJ4Rfh78yeg5G64UgAATR38aW34Z7BMnLWEjUk
         zFAJsSG+IxfQ1ayboH+c6TBBNTmM78uBCJwbVBeGAOGdpb4sHZ1iOldCDKDlHrh/p4+a
         xt3wv0nua0EqcNPlzDvvnmjKInBve2p2iMECrFcAuacS9AzZYpgAlqXsg0oOtoK3jqeG
         Y3Wd0+g5SB86gqRT0NdpPtjgW109x3xP1WOVxm01uS+16AIebLBXU7KVGm7abs9n4TXb
         YBJQbPiqmvsBc0g7wTg+PKbsiWuqkWF3ydjwRMAebEOpYbpBuGLJOZIfByYkYnmcb4/b
         bJBw==
X-Forwarded-Encrypted: i=1; AHgh+Rpx5XVmzHyFtvHUFjwd815rSuOdqf2uuYlgdai2DqpDNJJ4zgj+ICzLONxksBJidx1k7HFeyOo=@lists.linux.dev
X-Gm-Message-State: AFuF++nj22+r+KZ7sEehm0ZCE4uvKN+kVxqG1U1CGUy6NS9Rzikim4HG
	ZeVAtz5Nw2ZxSOSBKNFianUVfYMg3JlteOXGQqv5cZPgkE8fl2kB8UDP
X-Gm-Gg: AR+sD11nFIQwFVPyjANg9VuTYdfHgQ0mEREXkfE1DDBpftduVPjGZ5HfSMWe1y7sTKR
	nIORoaITMzGOmXTtW9TTi2Zd1LrcYQ5JyOCiXy8tl5NhBuecMibOVCSNKCyb32bV6TjQd+YVpzj
	jc36pMUkX+7qtRzReaVWZvM46O0QeYf7NARS9C0lvKkyKny2NtUwCUbXYY5mBA6fu4SmWX3hXIP
	Qn5MxuJ/konxA5YT+rVvmIvmr/3zWgmJS5DifNUD6cSYa0fJSCdbruFnV7Nd/Gr1F4z8JH7cXWP
	fFy8SpSoEfQkFqyRs0vpURXOR+y7u+kSUNwJJmRKPsn/CpHJ4fZtAlYajzVStf8cFluD5mFidv0
	S5XqEDkqeHrkEEkRzenWF+Q8LTZG6pr070N0qyRzzV/m0k8ayuN31DLUV48Ky3Sdk4TIYTldZjj
	iUPhDNXOoJKgr5vzduqL/CiFwnPjnXjLGw5QGVetEiCP7ZP3f4FxK4qtNMJBf5i6ue4Ez6Ru4Bf
	gLEaFQ2zK+xsO0xmOQaoKgvTT3oXlyDSdg+IsdeKx+7pC5Tq6JwgIx9GKRzgjSAFjCyvGtYwtFe
	+uKjVGimKFukPupu03CVXNClZ/Kfk+077lyvrVM64gvFxch28AcNd32jahjsYxorkxwzYQ==
X-Received: by 2002:a05:6402:2186:b0:6a1:2400:baea with SMTP id 4fb4d7f45d1cf-6a42f18a70cmr11760162a12.10.1787392437812;
        Sat, 22 Aug 2026 02:53:57 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0f5-8c01-3de3-cd62-aa6f-2fb0.310.pool.telefonica.de. [2a02:3100:a0f5:8c01:3de3:cd62:aa6f:2fb0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff0c327asm11151586a12.8.2026.08.22.02.53.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Aug 2026 02:53:57 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 2/5] KVM: arm64: vgic-v3: Reset redistributors after failed region setup
Date: Sat, 22 Aug 2026 11:53:43 +0200
Message-Id: <20260822095346.53882-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260822095346.53882-1-kmehltretter@gmail.com>
References: <20260822095346.53882-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A REDIST_REGION write can fail after redistributor iodevs have been
registered. The existing rollback unregisters only vCPUs processed before
the failure, leaving their cached assignments and free_index values intact.
A retry then skips the unregistered iodevs.

Userspace has no guarantee that redistributor assignments survive a failed
region update. On failure, unregister every redistributor iodev and clear
every cached vCPU assignment. Reset all region free_index values and free
the newly inserted region. The next successful region update rebuilds all
possible assignments in region-index order.

While a vCPU is being created, its redistributor iodev may be registered
before the vCPU is visible to kvm_for_each_vcpu(). Reject REDIST and
REDIST_REGION writes while creation is in flight, so rollback can reset every
assignment.

The registration failure for the current vCPU is already undone by
vgic_register_redist_iodev().

Fixes: c011f4ea106b ("KVM: arm/arm64: Check vcpu redist base before registering an iodev")
Suggested-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 20 ++++++++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 53 +++++++++++++++++++--------
 2 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 90be99443df3..48c3b2a48c20 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -97,6 +97,9 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 	phys_addr_t *addr_ptr, alignment, size;
 	u64 undef_value = VGIC_ADDR_UNDEF;
 	u64 addr;
+	bool redist_write = write &&
+		(attr->attr == KVM_VGIC_V3_ADDR_TYPE_REDIST ||
+		 attr->attr == KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION);
 	int r;
 
 	/* Reading a redistributor region addr implies getting the index */
@@ -104,6 +107,19 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 		if (get_user(addr, uaddr))
 			return -EFAULT;
 
+	/*
+	 * A vCPU can have an RD assignment before it is visible to
+	 * kvm_for_each_vcpu(). Reject redistributor updates while vCPU creation
+	 * is in progress, so rollback can reset every assignment.
+	 */
+	if (redist_write) {
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus)) {
+			r = -EBUSY;
+			goto out_unlock_kvm;
+		}
+	}
+
 	/*
 	 * Since we can't hold config_lock while registering the redistributor
 	 * iodevs, take the slots_lock immediately.
@@ -201,6 +217,10 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 out:
 	mutex_unlock(&kvm->slots_lock);
 
+out_unlock_kvm:
+	if (redist_write)
+		mutex_unlock(&kvm->lock);
+
 	if (!r && !write)
 		r =  put_user(addr, uaddr);
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 22897ce64dbf..6c009deb11d4 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -855,6 +855,40 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
 }
 
+static void vgic_reset_redist_iodev(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
+
+	vgic_cpu->rdreg = NULL;
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+}
+
+static void vgic_v3_rollback_redist_region(struct kvm *kvm, u32 index)
+{
+	struct vgic_redist_region *rdreg, *iter;
+	struct kvm_vcpu *vcpu;
+	unsigned long c;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	rdreg = vgic_v3_rdist_region_from_index(kvm, index);
+
+	kvm_for_each_vcpu(c, vcpu, kvm)
+		vgic_unregister_redist_iodev(vcpu);
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	kvm_for_each_vcpu(c, vcpu, kvm)
+		vgic_reset_redist_iodev(vcpu);
+
+	list_for_each_entry(iter, &kvm->arch.vgic.rd_regions, list)
+		iter->free_index = 0;
+
+	vgic_v3_free_redist_region(kvm, rdreg);
+}
+
 static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
@@ -869,16 +903,6 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 			break;
 	}
 
-	if (ret) {
-		/* The current c failed, so iterate over the previous ones. */
-		int i;
-
-		for (i = 0; i < c; i++) {
-			vcpu = kvm_get_vcpu(kvm, i);
-			vgic_unregister_redist_iodev(vcpu);
-		}
-	}
-
 	return ret;
 }
 
@@ -986,6 +1010,8 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 {
 	int ret;
 
+	lockdep_assert_held(&kvm->lock);
+
 	mutex_lock(&kvm->arch.config_lock);
 	ret = vgic_v3_alloc_redist_region(kvm, index, addr, count);
 	mutex_unlock(&kvm->arch.config_lock);
@@ -998,12 +1024,7 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	 */
 	ret = vgic_register_all_redist_iodevs(kvm);
 	if (ret) {
-		struct vgic_redist_region *rdreg;
-
-		mutex_lock(&kvm->arch.config_lock);
-		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
-		vgic_v3_free_redist_region(kvm, rdreg);
-		mutex_unlock(&kvm->arch.config_lock);
+		vgic_v3_rollback_redist_region(kvm, index);
 		return ret;
 	}
 
-- 
2.39.5 (Apple Git-154)

