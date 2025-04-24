Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9620528B51B
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504051; cv=none; b=b2zlmD0Y1MU0msBT02wAesQCsSbdZ08lnYWmZBJUWyaY3uMXPzzv38nZczkADBk+NyZ7hwMbmF4dSl3YA5irtvsPFnlI03QA8Sggu3PcTAyc2HJUJX6dgsCUhKuPcrGR/XpjbZqMhTM5dqPyC3zAnPiNnum80O8ahq9C8CPcq0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504051; c=relaxed/simple;
	bh=o5jUxv0nZ8uJl1blXMpoQdyQe0eMlKyDBmLFSdRHE2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnUfUxRKH+nZMDm8dj4A1jCCPYiklITCiR9p074+IGL3xob+q5xk57JTxffJxr/D9wCBkomWY/t/2P0qRcQayZu0HKA+zx66LDBF/R5+ETC168gyGxes6nufbS4mnaHEMAEvoEEvLFF928Y9l9r3Y5Ij9QkKF5Iy+DXGl3sgI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H5yrA0ka; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H5yrA0ka"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39c0dfad22aso840610f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504046; x=1746108846; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoVyA4T/XR+PrBla9t1/dUC6ibbVMr9f/wkTq4NWm5c=;
        b=H5yrA0kaFxgIyoq4POPKfjgRp+rFroBvpYq7Ygq/1Av7tySkaYtYy8iiINsDJU9KV5
         IC2OUcYuZS+lyR/GKZQxbafVFquZ06uIa4TuJxbm7nc5vhyIeWRBv9ML8JQ4KzXGjFVy
         iodYH3um+IUY5RYvHtxMzCXAe1eT7AjmklP7Xiebq6jwLaOIPwqsbdYSKZ4WvVeUZLgh
         9yJ57Lwz7zCG9qWC0MOsDi4jOp/+Zyikx36RrdGYDe/AnxT2Zu6eARsI+RgNPpggAAPb
         vP7271I0I+jSaP80Ocna4wIcKfdq9j3I51QvoTfS1Dd52rRQhJ+iwlV08FFa/4poeVGd
         lr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504046; x=1746108846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UoVyA4T/XR+PrBla9t1/dUC6ibbVMr9f/wkTq4NWm5c=;
        b=h9MXXRAB5NFYoj76QSjkvL73y/Bqt4BqQhfJ23Bm9bIGGrL4hsR2EF1W7zFztkzd0a
         kqCxboZRIMSip5fUy4OyOnNmVCCQY64vJBAoHhttn1xA7ZUCboPzqMxkyWeQpbUm95hd
         G21u1zKU0I2Vcloq+CG4WKldXbb82F7dxKn3nOVZYM61qf90aa8y0rJmYO5ngK44Zbue
         30i4BSsq5IV18RHVwe+vzgkwoFQ1/+6JEdDZmcytoSUa9FdxRTuAPFya1vNlIHbrVMEz
         B3hH0hX0PnZZPvFoQ6y8SahjroOxQOpj1ACIhKr9eKX67hQPKVjfrCiV3dmmmj2mTDiO
         SGag==
X-Forwarded-Encrypted: i=1; AJvYcCXnvfIRnU4yCzlJkow+r853Z4i5hIL3DlYAHvcvpSUnkxmoDIgjN8BIlQjm5McuJDunjS4hFUI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBZHQkPioCoIKqlKB6XXOx0Nqx220UNSU3aipd0dJ3FzaO92a7
	cWgZs70nWrddKoxbwipI5Nw6CGxp0bP6HtupOjdAHaXUa2D4QFGVy8EVcPaZ7xU=
X-Gm-Gg: ASbGncvb9r/ObnGRtu7QwadETiv5aknmpMSmkzHhr0RylSZDRddVtY2kLm4kY8KBSf+
	x5l/DNQuW6P1OWwuNgeljAhucb5DU4Q2fdwY44hKu5SoSROGVBUiOKu+DmyIOEXBItJA4jjEcLe
	kN3SFpiUCFP5szE2PXUhSSjTgrntCAdYp29yPP05g20/tCKCyUQ5xvUc5ecY6lVW9d8rpqt3CfJ
	lIUhSDOz8DqZg0iI+xuIn70GbNNG/diuE4BH/YQl3iOi+nBsY6Tvbbv/LvB+3oCPFB8FzbVQHu7
	oAf+0YcMRnqeiFffgN4riebhPBcoQrjeQzYsA9pb2Qr/vPnaqw/R54IM5Z9bTOO+XwXvXjqoSkP
	Nw4kCg+5bUBEwRfB7
X-Google-Smtp-Source: AGHT+IFaUaoW58kCoH3cGCkS9884/3gN3P0U2I1fqPQYARfS16RUhRZKrV74ekkuGWYubSRTquJKGQ==
X-Received: by 2002:a5d:64ab:0:b0:391:2a9f:2fcb with SMTP id ffacd0b85a97d-3a06cfa8400mr2501557f8f.36.1745504046320;
        Thu, 24 Apr 2025 07:14:06 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:05 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 16/34] gunyah: Add basic VM lifecycle management
Date: Thu, 24 Apr 2025 15:13:23 +0100
Message-Id: <20250424141341.841734-17-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch hooks up Gunyah virtual machine lifecycle management with the
KVM backend by implementing the kvm_arch_alloc_vm(), kvm_arch_destroy_vm(),
and kvm_arch_free_vm() hooks.

The Gunyah VM management logic—VMID allocation, configuration,
initialization, start/stop, teardown, and notifier handling—is based on
the implementation introduced in [1], authored by Elliot Berman and
Prakruthi Deepak Heragu.

The original code added a special ioctl interface to support userspace
initialization of guest VMs. This patch reuses the same logic, but
ported to KVM, allowing to use KVM's ioctl interface to create
Gunyah-based guests.

[1] Commit: 532788ce71c9 ("gunyah: vm_mgr: Add VM start/stop")
    Link: https://lore.kernel.org/lkml/20240222-gunyah-v17-10-1e9da6763d38@quicinc.com/

Co-developed-by: Elliot Berman <quic_eberman@quicinc.com>
Co-developed-by: Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |   5 +
 arch/arm64/kvm/gunyah.c           | 196 ++++++++++++++++++++++++++++--
 drivers/virt/gunyah/rsc_mgr_rpc.c |   2 +-
 include/linux/gunyah.h            |  32 +++++
 4 files changed, 227 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9c8e173fc9c1..53358d3f5fa8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1591,4 +1591,9 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+#ifndef CONFIG_KVM_ARM
+#define __KVM_HAVE_ARCH_VM_FREE
+void kvm_arch_free_vm(struct kvm *kvm);
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 9c37ab20d7e2..a3c29ae985c9 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -13,6 +13,12 @@
 #include <asm/kvm_mmu.h>
 #include <linux/perf_event.h>
 
+#include <linux/gunyah_rsc_mgr.h>
+#include <linux/gunyah.h>
+
+#undef pr_fmt
+#define pr_fmt(fmt) "gunyah: " fmt
+
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
 
 enum kvm_mode kvm_get_mode(void)
@@ -338,12 +344,6 @@ void kvm_arch_create_vm_debugfs(struct kvm *kvm)
 {
 }
 
-void kvm_arch_destroy_vm(struct kvm *kvm)
-{
-	kvm_destroy_vcpus(kvm);
-	return;
-}
-
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
@@ -788,7 +788,189 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 	return -EINVAL;
 }
 
+static int gunyah_vm_rm_notification_status(struct gunyah_vm *ghvm, void *data)
+{
+	struct gunyah_rm_vm_status_payload *payload = data;
+
+	if (le16_to_cpu(payload->vmid) != ghvm->vmid)
+		return NOTIFY_OK;
+
+	/* All other state transitions are synchronous to a corresponding RM call */
+	if (payload->vm_status == GUNYAH_RM_VM_STATUS_RESET) {
+		down_write(&ghvm->status_lock);
+		ghvm->vm_status = payload->vm_status;
+		up_write(&ghvm->status_lock);
+		wake_up(&ghvm->vm_status_wait);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int gunyah_vm_rm_notification_exited(struct gunyah_vm *ghvm, void *data)
+{
+	struct gunyah_rm_vm_exited_payload *payload = data;
+
+	if (le16_to_cpu(payload->vmid) != ghvm->vmid)
+		return NOTIFY_OK;
+
+	down_write(&ghvm->status_lock);
+	ghvm->vm_status = GUNYAH_RM_VM_STATUS_EXITED;
+	up_write(&ghvm->status_lock);
+	wake_up(&ghvm->vm_status_wait);
+
+	return NOTIFY_DONE;
+}
+
+static int gunyah_vm_rm_notification(struct notifier_block *nb,
+		unsigned long action, void *data)
+{
+	struct gunyah_vm *ghvm = container_of(nb, struct gunyah_vm, nb);
+
+	switch (action) {
+	case GUNYAH_RM_NOTIFICATION_VM_STATUS:
+		return gunyah_vm_rm_notification_status(ghvm, data);
+	case GUNYAH_RM_NOTIFICATION_VM_EXITED:
+		return gunyah_vm_rm_notification_exited(ghvm, data);
+	default:
+		return NOTIFY_OK;
+	}
+}
+
+static void gunyah_vm_stop(struct gunyah_vm *ghvm)
+{
+	int ret;
+
+	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_RUNNING) {
+		ret = gunyah_rm_vm_stop(ghvm->rm, ghvm->vmid);
+		if (ret)
+			pr_warn("Failed to stop VM: %d\n", ret);
+	}
+
+	wait_event(ghvm->vm_status_wait,
+		   ghvm->vm_status != GUNYAH_RM_VM_STATUS_RUNNING);
+}
+
+static int gunyah_vm_start(struct gunyah_vm *ghvm)
+{
+	int ret;
+
+	down_write(&ghvm->status_lock);
+	if (ghvm->vm_status != GUNYAH_RM_VM_STATUS_NO_STATE) {
+		up_write(&ghvm->status_lock);
+		return 0;
+	}
+
+	ghvm->nb.notifier_call = gunyah_vm_rm_notification;
+	ret = gunyah_rm_notifier_register(ghvm->rm, &ghvm->nb);
+	if (ret)
+		goto err;
+
+	ret = gunyah_rm_alloc_vmid(ghvm->rm, 0);
+	if (ret < 0) {
+		gunyah_rm_notifier_unregister(ghvm->rm, &ghvm->nb);
+		goto err;
+	}
+	ghvm->vmid = ret;
+	ghvm->vm_status = GUNYAH_RM_VM_STATUS_LOAD;
+
+	ret = gunyah_rm_vm_configure(ghvm->rm, ghvm->vmid, ghvm->auth, 0, 0, 0, 0, 0);
+	if (ret) {
+		pr_warn("Failed to configure VM: %d\n", ret);
+		goto err;
+	}
+
+	ret = gunyah_rm_vm_init(ghvm->rm, ghvm->vmid);
+	if (ret) {
+		ghvm->vm_status = GUNYAH_RM_VM_STATUS_INIT_FAILED;
+		pr_warn("Failed to initialize VM: %d\n", ret);
+		goto err;
+	}
+	ghvm->vm_status = GUNYAH_RM_VM_STATUS_READY;
+
+	ret = gunyah_rm_vm_start(ghvm->rm, ghvm->vmid);
+	if (ret) {
+		pr_warn("Failed to start VM: %d\n", ret);
+		goto err;
+	}
+
+	ghvm->vm_status = GUNYAH_RM_VM_STATUS_RUNNING;
+	up_write(&ghvm->status_lock);
+	return 0;
+err:
+	up_write(&ghvm->status_lock);
+	return ret;
+}
+
+static struct gunyah_vm *gunyah_vm_alloc(struct gunyah_rm *rm)
+{
+	struct gunyah_vm *ghvm;
+
+	ghvm = kzalloc(sizeof(*ghvm), GFP_KERNEL);
+	if (!ghvm)
+		return ERR_PTR(-ENOMEM);
+
+	ghvm->vmid = GUNYAH_VMID_INVAL;
+	ghvm->rm = rm;
+
+	init_rwsem(&ghvm->status_lock);
+	init_waitqueue_head(&ghvm->vm_status_wait);
+	ghvm->vm_status = GUNYAH_RM_VM_STATUS_NO_STATE;
+
+	return ghvm;
+}
+
+static void gunyah_destroy_vm(struct gunyah_vm *ghvm)
+{
+	int ret;
+
+	/**
+	 * We might race with a VM exit notification, but that's ok:
+	 * gh_rm_vm_stop() will just return right away.
+	 */
+	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_RUNNING)
+		gunyah_vm_stop(ghvm);
+
+	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_EXITED ||
+	    ghvm->vm_status == GUNYAH_RM_VM_STATUS_READY ||
+	    ghvm->vm_status == GUNYAH_RM_VM_STATUS_INIT_FAILED) {
+		ret = gunyah_rm_vm_reset(ghvm->rm, ghvm->vmid);
+		if (!ret)
+			wait_event(ghvm->vm_status_wait,
+				   ghvm->vm_status == GUNYAH_RM_VM_STATUS_RESET);
+		else
+			pr_warn("Failed to reset the vm: %d\n", ret);
+	}
+
+	if (ghvm->vm_status > GUNYAH_RM_VM_STATUS_NO_STATE) {
+		gunyah_rm_notifier_unregister(ghvm->rm, &ghvm->nb);
+		ret = gunyah_rm_dealloc_vmid(ghvm->rm, ghvm->vmid);
+		if (ret)
+			pr_warn("Failed to deallocate vmid: %d\n", ret);
+	}
+}
+
 struct kvm *kvm_arch_alloc_vm(void)
 {
-	return NULL;
+	struct gunyah_vm *ghvm;
+
+	ghvm = gunyah_vm_alloc(gunyah_rm);
+	if (IS_ERR(ghvm))
+		return NULL;
+
+	return &ghvm->kvm;
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	struct gunyah_vm *ghvm = kvm_to_gunyah(kvm);
+
+	kvm_destroy_vcpus(kvm);
+	gunyah_destroy_vm(ghvm);
+}
+
+void kvm_arch_free_vm(struct kvm *kvm)
+{
+	struct gunyah_vm *ghvm = kvm_to_gunyah(kvm);
+
+	kfree(ghvm);
 }
diff --git a/drivers/virt/gunyah/rsc_mgr_rpc.c b/drivers/virt/gunyah/rsc_mgr_rpc.c
index 626ad2565548..936592177ddb 100644
--- a/drivers/virt/gunyah/rsc_mgr_rpc.c
+++ b/drivers/virt/gunyah/rsc_mgr_rpc.c
@@ -3,8 +3,8 @@
  * Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
+#include <linux/slab.h>
 #include <linux/error-injection.h>
-
 #include <linux/gunyah_rsc_mgr.h>
 
 /* Message IDs: VM Management */
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index acd70f982425..1f4389eb21fb 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -11,6 +11,12 @@
 #include <linux/interrupt.h>
 #include <linux/limits.h>
 #include <linux/types.h>
+#include <linux/kvm_host.h>
+
+#include <linux/gunyah_rsc_mgr.h>
+
+#define kvm_to_gunyah(kvm_ptr) \
+	container_of(kvm_ptr, struct gunyah_vm, kvm)
 
 /* Matches resource manager's resource types for VM_GET_HYP_RESOURCES RPC */
 enum gunyah_resource_type {
@@ -31,6 +37,32 @@ struct gunyah_resource {
 	unsigned int irq;
 };
 
+/**
+ * struct gunyah_vm - Main representation of a Gunyah Virtual machine
+                              memory shared with the guest.
+ * @vmid: Gunyah's VMID for this virtual machine
+ * @kvm: kvm instance for this VM
+ * @rm: Pointer to the resource manager struct to make RM calls
+ * @nb: Notifier block for RM notifications
+ * @vm_status: Current state of the VM, as last reported by RM
+ * @vm_status_wait: Wait queue for status @vm_status changes
+ * @status_lock: Serializing state transitions
+ * @auth: Authentication mechanism to be used by resource manager when
+ *        launching the VM
+ */
+struct gunyah_vm {
+	u16 vmid;
+	struct kvm kvm;
+	struct gunyah_rm *rm;
+
+	struct notifier_block nb;
+	enum gunyah_rm_vm_status vm_status;
+	wait_queue_head_t vm_status_wait;
+	struct rw_semaphore status_lock;
+
+	enum gunyah_rm_vm_auth_mechanism auth;
+};
+
 /******************************************************************************/
 /* Common arch-independent definitions for Gunyah hypercalls                  */
 #define GUNYAH_CAPID_INVAL U64_MAX
-- 
2.39.5

