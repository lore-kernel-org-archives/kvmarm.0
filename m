Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751AE3C1D5C
	for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787392444; cv=none; b=aaYojLYrxRSCwJZ1GIIQio5wmMoOlG0hosPPT4PJyDoJUmr+d0mcYiozS2YphdICUSCpDdYoBFpc2mSrKTGClmUHfSfYxdppBYW01W6/VI5TN1EUXl9Frg7nFhfCebHqs+Fw/JKjfP6/AE+lRfw47xNXTMUVcLm/xiz5LSVOQ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787392444; c=relaxed/simple;
	bh=0b8VuyaQuF/XCQ3FNlzXnVd3Yhyh8aOgT8hrkybBkwc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RfQVGCDfFRqGmFVn5MmhuOHmQ9YRP2y/ud90QlO6t59xqCaMJLLym3p6i9udp592XbidBNX+FApG0CERRC0ntLnAwI1I2zxj6qYdmGolA4yS7Du5Kefe/Xlu0KwPLe2soYPVd1Ni4C1JgpyZ93TZEF4XbiQb5x7cJSPP2pfiers=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q/IjI6mu; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/IjI6mu"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a422090b2fso2841240a12.0
        for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 02:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787392441; x=1787997241; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PqPQildVUr5OZauQmAhm0/cwcJh5PP5Ede7gwQE/8hQ=;
        b=Q/IjI6mu+0507ZscC0x55vQK2fWvl+4rka6gpW4gwwmRiAtuJrm2BxWzywN8XnhXpJ
         1jGDH8GV9ZZYHNIDy22KjE6WKPb/W9cIJG3PC+q6M7vYFkUKamks5NllhgcdzrnEyVKo
         vf45VuSnxkliQUVzHWrBMey2InruXjaBHJui+zzWoeyWXWI47M9a2qNJyzfNGcvguSV+
         bWy3AYIWWjqrWns4YE+YGFtB33+sUsGAyhnsSdOa4m5ZWydJ6Aofmf/MMvqoTvFtJmac
         LSrzQw/VKyOi8NYmd14UpgfNvovtH75aumrJTnbEiWgObFRoxDQqZZ9ZXFClJ24d8ma0
         q/eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787392441; x=1787997241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PqPQildVUr5OZauQmAhm0/cwcJh5PP5Ede7gwQE/8hQ=;
        b=LqYgMPNuaTIKjep17qpRI0Zfsth4zNSjLASC77xIL4fD/oQBv9ZIetFC3KOv2RdqWc
         e6FMt6RaHLEcUkjxfgyTiIAd/8bXrhkZwbiV+jmVjtHnmb/MnQGHwloZ9YNCm8c/UU+z
         nsNXLwfQc4QMgZb/phXSXjOevxITmhkresMJGsS2eyxUkat8zGQ5APwOiMqPFr//mfl6
         gTeXaSPRvQ8kG+12AlQCloqkWgzSfALUmf8+20fNKcN6gY3XrmVxy5i4V48oyH/oza2O
         00oHOmFjIsMhU00Fcr0cvu9MsYNQjZDCfH+ypQ2PRHrvaJ4vixqpfvs4t2S9cl9Bx3Xg
         BeFw==
X-Forwarded-Encrypted: i=1; AHgh+RqJ4Bc7cFHILdzz+sFIa3XvkTq+Nv+8uzRqxFZQI1p9p7b6FKMKSuPhcCAsehk7aNbDE6ORpoA=@lists.linux.dev
X-Gm-Message-State: AFuF++lr4bD7LHyhgccLOnprwQmn1eQA2jiU8L9mjoTV8EXafDaC8pJN
	IFC2fi4BBZ1FwbG/YdplEP7hjKOryaXgeWDA6Zm6KgMOESd9dxgZey1L
X-Gm-Gg: AR+sD117sKhNO8796pSnssG84o/yvct1VPAi3pNhyjDXYMEMOlhFHWqwB1ob1ggTv+6
	tYMEU258ZELSBMbItQcq3yrCF46vN2MW9k7Tzfqo0pehJg4JOorPmBPyybKdCsHK2fc5bO4Rmn+
	13aFZruEY8Nkyc1gpMLRIlwzG/BX8Mkdnkb7Iu+Pr37d6/G1dXFljReY/L7Jn7rsuLPOnDSO0Ls
	7kiB1MPj5LUrLKComFPc3Amx/DHH7xmpPdO2DqX7U0Op3s2taOtYOc3u2kX8F7QF8p5iBVPbLHL
	obo/eyowfVOmP+Wealkqv+W8zR2pymM1tn5ueQIFfcCO5/UnQ7r2tt9sqT6bqZy/J+4f+hpN2Fg
	M7/lvLZ2XmqCjIRJZrgapQHoTLQpKJK6+8NOPy5syCw2c63hrV0/2bXhSUrZBZxVs67aXEHSsO7
	xvy+qi4+nW1tPuN/Ef/RIc90vtzPojUc6NVIUIQKcGyBoX2K/8aKsaN9IInyoiXL3ZIAhYWvncd
	fdjpLuUK8pgHu77nyNn8aBDMUgSM0XHtIrEll4OvNr3NSrZhe3NfRQAwu/tijz2gbU4/XKdtpAH
	f7ZUz6pDZnifzuGK8YIkCKC+3E0gg0BBbnc2QFnL1VgFP1913kcMh4uTCZjphEaCYFOu
X-Received: by 2002:a05:6402:4613:b0:698:9e5e:5df8 with SMTP id 4fb4d7f45d1cf-6a42f1aca88mr12197582a12.7.1787392440592;
        Sat, 22 Aug 2026 02:54:00 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0f5-8c01-3de3-cd62-aa6f-2fb0.310.pool.telefonica.de. [2a02:3100:a0f5:8c01:3de3:cd62:aa6f:2fb0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff0c327asm11151586a12.8.2026.08.22.02.53.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Aug 2026 02:54:00 -0700 (PDT)
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
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 3/5] KVM: arm64: vgic-v3: Separate redistributor teardown from unassignment
Date: Sat, 22 Aug 2026 11:53:44 +0200
Message-Id: <20260822095346.53882-4-kmehltretter@gmail.com>
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

MMIO-bus unregistration may synchronize SRCU and must run outside
config_lock. Conversely, clearing the redistributor assignment needs
config_lock, and teardown must do so before freeing the redistributor
regions.

Introduce an already-locked unassignment primitive that only clears the
cached region and base address. It deliberately does not adjust free_index:
failure rollback resets all region counters, while VM teardown frees the
regions. Keep MMIO-bus unregistration separate. Unregister devices before
taking config_lock in VM teardown, then unassign the vCPUs before freeing
their regions.

Move redistributor cleanup out of __kvm_vgic_vcpu_destroy() and into its
outer wrapper. This preserves failed-vCPU cleanup before its memory can be
freed, without the special conditional in the common destructor. The region
destructor no longer needs to scan the vCPUs.

Suggested-by: Marc Zyngier <maz@kernel.org>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    | 46 +++++++++++-------------------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++---------
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 3 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 0a3df6d3a691..a0d72b540331 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -523,29 +523,6 @@ static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 	kfree(vgic_cpu->private_irqs);
 	vgic_cpu->private_irqs = NULL;
-
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		/*
-		 * If this vCPU is being destroyed because of a failed creation
-		 * then unregister the redistributor to avoid leaving behind a
-		 * dangling pointer to the vCPU struct.
-		 *
-		 * vCPUs that have been successfully created (i.e. added to
-		 * kvm->vcpu_array) get unregistered in kvm_vgic_destroy(), as
-		 * this function gets called while holding kvm->arch.config_lock
-		 * in the VM teardown path and would otherwise introduce a lock
-		 * inversion w.r.t. kvm->srcu.
-		 *
-		 * vCPUs that failed creation are torn down outside of the
-		 * kvm->arch.config_lock and do not get unregistered in
-		 * kvm_vgic_destroy(), meaning it is both safe and necessary to
-		 * do so here.
-		 */
-		if (kvm_get_vcpu_by_id(vcpu->kvm, vcpu->vcpu_id) != vcpu)
-			vgic_unregister_redist_iodev(vcpu);
-
-		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
-	}
 }
 
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -553,7 +530,16 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 
 	mutex_lock(&kvm->slots_lock);
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		vgic_unregister_redist_iodev(vcpu);
+
 	__kvm_vgic_vcpu_destroy(vcpu);
+
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		mutex_lock(&kvm->arch.config_lock);
+		__vgic_unassign_redist_iodev(vcpu);
+		mutex_unlock(&kvm->arch.config_lock);
+	}
 	mutex_unlock(&kvm->slots_lock);
 }
 
@@ -563,21 +549,23 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	unsigned long i;
 
 	mutex_lock(&kvm->slots_lock);
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			vgic_unregister_redist_iodev(vcpu);
+
 	mutex_lock(&kvm->arch.config_lock);
 
 	vgic_debug_destroy(kvm);
 
-	kvm_for_each_vcpu(i, vcpu, kvm)
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 		__kvm_vgic_vcpu_destroy(vcpu);
+		if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+			__vgic_unassign_redist_iodev(vcpu);
+	}
 
 	kvm_vgic_dist_destroy(kvm);
 
 	mutex_unlock(&kvm->arch.config_lock);
-
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
-		kvm_for_each_vcpu(i, vcpu, kvm)
-			vgic_unregister_redist_iodev(vcpu);
-
 	mutex_unlock(&kvm->slots_lock);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 6c009deb11d4..dc860178105d 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -775,8 +775,7 @@ static void vgic_undo_redist_assignment(struct kvm_vcpu *vcpu)
 	guard(mutex)(&vcpu->kvm->arch.config_lock);
 
 	vgic_cpu->rdreg->free_index--;
-	vgic_cpu->rdreg = NULL;
-	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	__vgic_unassign_redist_iodev(vcpu);
 }
 
 /**
@@ -855,7 +854,7 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
 }
 
-static void vgic_reset_redist_iodev(struct kvm_vcpu *vcpu)
+void __vgic_unassign_redist_iodev(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
@@ -881,7 +880,7 @@ static void vgic_v3_rollback_redist_region(struct kvm *kvm, u32 index)
 	guard(mutex)(&kvm->arch.config_lock);
 
 	kvm_for_each_vcpu(c, vcpu, kvm)
-		vgic_reset_redist_iodev(vcpu);
+		__vgic_unassign_redist_iodev(vcpu);
 
 	list_for_each_entry(iter, &kvm->arch.vgic.rd_regions, list)
 		iter->free_index = 0;
@@ -991,17 +990,8 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 
 void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdreg)
 {
-	struct kvm_vcpu *vcpu;
-	unsigned long c;
-
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	/* Garbage collect the region */
-	kvm_for_each_vcpu(c, vcpu, kvm) {
-		if (vcpu->arch.vgic_cpu.rdreg == rdreg)
-			vcpu->arch.vgic_cpu.rdreg = NULL;
-	}
-
 	list_del(&rdreg->list);
 	kfree(rdreg);
 }
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b71d486ae514..1a2e40004a47 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -350,6 +350,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm);
 int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count);
 int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
 void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu);
+void __vgic_unassign_redist_iodev(struct kvm_vcpu *vcpu);
 bool vgic_v3_check_base(struct kvm *kvm);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
-- 
2.39.5 (Apple Git-154)

