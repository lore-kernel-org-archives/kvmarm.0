Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A6E11C95
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 10:43:20 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3f435658d23so18132365e9.3
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 03:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684406599; x=1686998599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgINfoal7Z03uwg7G7UlksL/JOEeiuHi3H2Zvftx7tI=;
        b=uHEr/4qrD9rZjIHjYeZ0d8V+5Ed6V2cl1QdzdTH4qOBkAQ+hIYWqbE8e8Q0YOXa9DL
         KAxag3Fc1DrHlInFh20G6sSTxhcJcj4Dl/lbXZY+VCDwQcugXUYL1uEyjKufgjVg0Hl2
         vm6DSXuKEnG+pdauOmuAeoF9GqMcjLmCWd2ufEesAue4P3qkVlvoEimixFC/Zx1yWUUX
         sJyAvWhMS6fSj/vhQTOJhDoC4wKebXhlVlc5se5qq+SysqSWD4/LBaqDHAT/r+BSgUb4
         98zM+M0pnf2inmXuxzUlEET9yxpNKgcUTWk7r1vmr/jNEYv0wmNvKGPQscd/K5rH170J
         XV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684406599; x=1686998599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgINfoal7Z03uwg7G7UlksL/JOEeiuHi3H2Zvftx7tI=;
        b=dCdQkHe7kJIKQCkA91JbeZhKvuA969dri7X7YpHmYUXtzv9FdmEVrzTdfWFjHKlEcI
         6voPEUGOArTQhrVx6LV1tFQYT6qYkQdtBWYJvTONRKSarPWe62xrJu8AGdoLUeawmO+Z
         PjIoP4hKz0j7Kt/kUe/FG/Pnmr+8ofDY0mC5wegUxk1YDT97lqiGbL1T2Ydy2QjovsvC
         04XJOQ3FJnk7PHoY7nzUI/GbwP5q5P+xDiv1XRoH+rQdEZ+1d7ZqkOccd0KBL0H19F57
         T3PeYwCu2q7eumxgwflg3CQXhbu9SqRF3wa2kZfJcj0zXEd/mzjS8GY0WP3QK6iNfr9q
         tj5A==
X-Gm-Message-State: AC+VfDwmXJre6z4EiVwBmL5i7siykxHXbXfTNSyG52tqUWErx1e9qwen
	0/2xDoTQrnnoE7sUnTJnD8ZkDQ==
X-Google-Smtp-Source: ACHHUZ7K2wVviuTSe2dlPpvXWOmZW3UmDUG0Vbv2NYfzPSabwd25dPAVdMNN12rkTECXO1qt+2hniw==
X-Received: by 2002:a7b:c852:0:b0:3f1:979f:a733 with SMTP id c18-20020a7bc852000000b003f1979fa733mr1255682wml.31.1684406598944;
        Thu, 18 May 2023 03:43:18 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id f6-20020a1c6a06000000b003f427cba193sm4880523wmc.41.2023.05.18.03.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 03:43:18 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: oliver.upton@linux.dev,
	maz@kernel.org
Cc: james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH 1/4] KVM: arm64: vgic: Fix a circular locking issue
Date: Thu, 18 May 2023 11:09:15 +0100
Message-Id: <20230518100914.2837292-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230518100914.2837292-1-jean-philippe@linaro.org>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lockdep reports a circular lock dependency between the srcu and the
config_lock:

[  262.179917] -> #1 (&kvm->srcu){.+.+}-{0:0}:
[  262.182010]        __synchronize_srcu+0xb0/0x224
[  262.183422]        synchronize_srcu_expedited+0x24/0x34
[  262.184554]        kvm_io_bus_register_dev+0x324/0x50c
[  262.185650]        vgic_register_redist_iodev+0x254/0x398
[  262.186740]        vgic_v3_set_redist_base+0x3b0/0x724
[  262.188087]        kvm_vgic_addr+0x364/0x600
[  262.189189]        vgic_set_common_attr+0x90/0x544
[  262.190278]        vgic_v3_set_attr+0x74/0x9c
[  262.191432]        kvm_device_ioctl+0x2a0/0x4e4
[  262.192515]        __arm64_sys_ioctl+0x7ac/0x1ba8
[  262.193612]        invoke_syscall.constprop.0+0x70/0x1e0
[  262.195006]        do_el0_svc+0xe4/0x2d4
[  262.195929]        el0_svc+0x44/0x8c
[  262.196917]        el0t_64_sync_handler+0xf4/0x120
[  262.198238]        el0t_64_sync+0x190/0x194
[  262.199224]
[  262.199224] -> #0 (&kvm->arch.config_lock){+.+.}-{3:3}:
[  262.201094]        __lock_acquire+0x2b70/0x626c
[  262.202245]        lock_acquire+0x454/0x778
[  262.203132]        __mutex_lock+0x190/0x8b4
[  262.204023]        mutex_lock_nested+0x24/0x30
[  262.205100]        vgic_mmio_write_v3_misc+0x5c/0x2a0
[  262.206178]        dispatch_mmio_write+0xd8/0x258
[  262.207498]        __kvm_io_bus_write+0x1e0/0x350
[  262.208582]        kvm_io_bus_write+0xe0/0x1cc
[  262.209653]        io_mem_abort+0x2ac/0x6d8
[  262.210569]        kvm_handle_guest_abort+0x9b8/0x1f88
[  262.211937]        handle_exit+0xc4/0x39c
[  262.212971]        kvm_arch_vcpu_ioctl_run+0x90c/0x1c04
[  262.214154]        kvm_vcpu_ioctl+0x450/0x12f8
[  262.215233]        __arm64_sys_ioctl+0x7ac/0x1ba8
[  262.216402]        invoke_syscall.constprop.0+0x70/0x1e0
[  262.217774]        do_el0_svc+0xe4/0x2d4
[  262.218758]        el0_svc+0x44/0x8c
[  262.219941]        el0t_64_sync_handler+0xf4/0x120
[  262.221110]        el0t_64_sync+0x190/0x194

Note that the current report, which can be triggered by the vgic_irq
kselftest, is a triple chain that includes slots_lock, but after
inverting the slots_lock/config_lock dependency, the actual problem
reported above remains.

In several places, the vgic code calls kvm_io_bus_register_dev(), which
synchronizes the srcu, while holding config_lock (#1). And the MMIO
handler takes the config_lock while holding the srcu read lock (#0).

Break dependency #1, by registering the distributor and redistributors
without holding config_lock. The ITS also uses kvm_io_bus_register_dev()
but already relies on slots_lock to serialize calls.

The distributor iodev is created on the first KVM_RUN call. Multiple
threads will race for vgic initialization, and only the first one will
see !vgic_ready() under the lock. To serialize those threads, rely on
slots_lock rather than config_lock.

Redistributors are created earlier, through KVM_DEV_ARM_VGIC_GRP_ADDR
ioctls and vCPU creation. Similarly, serialize the iodev creation with
slots_lock, and the rest with config_lock.

Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/vgic/vgic-init.c       | 25 ++++++++++++++++-----
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 10 +++++++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 31 ++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic-mmio.c       |  8 ++-----
 arch/arm64/kvm/vgic/vgic-v2.c         |  6 ------
 arch/arm64/kvm/vgic/vgic-v3.c         |  7 ------
 6 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 9d42c7cb2b588..c199ba2f192ef 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -235,9 +235,9 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	 * KVM io device for the redistributor that belongs to this VCPU.
 	 */
 	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		mutex_lock(&vcpu->kvm->arch.config_lock);
+		mutex_lock(&vcpu->kvm->slots_lock);
 		ret = vgic_register_redist_iodev(vcpu);
-		mutex_unlock(&vcpu->kvm->arch.config_lock);
+		mutex_unlock(&vcpu->kvm->slots_lock);
 	}
 	return ret;
 }
@@ -446,11 +446,13 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	gpa_t dist_base;
 	int ret = 0;
 
 	if (likely(vgic_ready(kvm)))
 		return 0;
 
+	mutex_lock(&kvm->slots_lock);
 	mutex_lock(&kvm->arch.config_lock);
 	if (vgic_ready(kvm))
 		goto out;
@@ -463,13 +465,26 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	else
 		ret = vgic_v3_map_resources(kvm);
 
-	if (ret)
+	if (ret) {
 		__kvm_vgic_destroy(kvm);
-	else
-		dist->ready = true;
+		goto out;
+	}
+	dist->ready = true;
+	dist_base = dist->vgic_dist_base;
+	mutex_unlock(&kvm->arch.config_lock);
+
+	ret = vgic_register_dist_iodev(kvm, dist_base,
+				       kvm_vgic_global_state.type);
+	if (ret) {
+		kvm_err("Unable to register VGIC dist MMIO regions\n");
+		kvm_vgic_destroy(kvm);
+	}
+	mutex_unlock(&kvm->slots_lock);
+	return ret;
 
 out:
 	mutex_unlock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->slots_lock);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 35cfa268fd5de..212b73a715c1c 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -102,7 +102,11 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 		if (get_user(addr, uaddr))
 			return -EFAULT;
 
-	mutex_lock(&kvm->arch.config_lock);
+	/*
+	 * Since we can't hold config_lock while registering the redistributor
+	 * iodevs, take the slots_lock immediately.
+	 */
+	mutex_lock(&kvm->slots_lock);
 	switch (attr->attr) {
 	case KVM_VGIC_V2_ADDR_TYPE_DIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
@@ -182,6 +186,7 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 	if (r)
 		goto out;
 
+	mutex_lock(&kvm->arch.config_lock);
 	if (write) {
 		r = vgic_check_iorange(kvm, *addr_ptr, addr, alignment, size);
 		if (!r)
@@ -189,9 +194,10 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 	} else {
 		addr = *addr_ptr;
 	}
+	mutex_unlock(&kvm->arch.config_lock);
 
 out:
-	mutex_unlock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->slots_lock);
 
 	if (!r && !write)
 		r =  put_user(addr, uaddr);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 472b18ac92a24..188d2187eede9 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -769,10 +769,13 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
 	struct vgic_redist_region *rdreg;
 	gpa_t rd_base;
-	int ret;
+	int ret = 0;
+
+	lockdep_assert_held(&kvm->slots_lock);
+	mutex_lock(&kvm->arch.config_lock);
 
 	if (!IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr))
-		return 0;
+		goto out_unlock;
 
 	/*
 	 * We may be creating VCPUs before having set the base address for the
@@ -782,10 +785,12 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	 */
 	rdreg = vgic_v3_rdist_free_slot(&vgic->rd_regions);
 	if (!rdreg)
-		return 0;
+		goto out_unlock;
 
-	if (!vgic_v3_check_base(kvm))
-		return -EINVAL;
+	if (!vgic_v3_check_base(kvm)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	vgic_cpu->rdreg = rdreg;
 	vgic_cpu->rdreg_index = rdreg->free_index;
@@ -799,16 +804,20 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rd_registers);
 	rd_dev->redist_vcpu = vcpu;
 
-	mutex_lock(&kvm->slots_lock);
+	mutex_unlock(&kvm->arch.config_lock);
+
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
 				      2 * SZ_64K, &rd_dev->dev);
-	mutex_unlock(&kvm->slots_lock);
-
 	if (ret)
 		return ret;
 
+	/* Protected by slots_lock */
 	rdreg->free_index++;
 	return 0;
+
+out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
+	return ret;
 }
 
 static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
@@ -834,12 +843,10 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 		/* The current c failed, so iterate over the previous ones. */
 		int i;
 
-		mutex_lock(&kvm->slots_lock);
 		for (i = 0; i < c; i++) {
 			vcpu = kvm_get_vcpu(kvm, i);
 			vgic_unregister_redist_iodev(vcpu);
 		}
-		mutex_unlock(&kvm->slots_lock);
 	}
 
 	return ret;
@@ -938,7 +945,9 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 {
 	int ret;
 
+	mutex_lock(&kvm->arch.config_lock);
 	ret = vgic_v3_alloc_redist_region(kvm, index, addr, count);
+	mutex_unlock(&kvm->arch.config_lock);
 	if (ret)
 		return ret;
 
@@ -950,8 +959,10 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	if (ret) {
 		struct vgic_redist_region *rdreg;
 
+		mutex_lock(&kvm->arch.config_lock);
 		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
 		vgic_v3_free_redist_region(rdreg);
+		mutex_unlock(&kvm->arch.config_lock);
 		return ret;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 1939c94e0b248..ce3d17463c6bc 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1114,10 +1114,6 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 	io_device->iodev_type = IODEV_DIST;
 	io_device->redist_vcpu = NULL;
 
-	mutex_lock(&kvm->slots_lock);
-	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, dist_base_address,
-				      len, &io_device->dev);
-	mutex_unlock(&kvm->slots_lock);
-
-	return ret;
+	return kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, dist_base_address,
+				       len, &io_device->dev);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 645648349c99b..7e9cdb78f7ce8 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -312,12 +312,6 @@ int vgic_v2_map_resources(struct kvm *kvm)
 		return ret;
 	}
 
-	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V2);
-	if (ret) {
-		kvm_err("Unable to register VGIC MMIO regions\n");
-		return ret;
-	}
-
 	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 					    kvm_vgic_global_state.vcpu_base,
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 469d816f356f3..76af07e66d731 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -539,7 +539,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu;
-	int ret = 0;
 	unsigned long c;
 
 	kvm_for_each_vcpu(c, vcpu, kvm) {
@@ -569,12 +568,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		return -EBUSY;
 	}
 
-	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V3);
-	if (ret) {
-		kvm_err("Unable to register VGICv3 dist MMIO regions\n");
-		return ret;
-	}
-
 	if (kvm_vgic_global_state.has_gicv4_1)
 		vgic_v4_configure_vsgis(kvm);
 
-- 
2.40.0

