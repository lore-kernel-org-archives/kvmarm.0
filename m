Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D52F20E704
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527165; cv=none; b=fOeClfBDwtoZFVrOLxURvc2LVbFqk18UMhUAPRfG6xFDX0qPvMfQ1svzgdQa4qswuSmz4yuDy3OHZF3xpIjrlqw0NAxvV9Lh5qceWt1vg4kNGuWywsQVcmOJtokg+I7z5xlg0q44oY96Z+HO/zldjyoOXrvYS5P31KelzNhkB9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527165; c=relaxed/simple;
	bh=ZI/sEAhEFCu5lvxGAVZMXb5pyLBeXvdXqe60NbG+FmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkPng3pYx9svcOq4/xks0vAt0bt5OANv5SZjb+Qdt+CHv6Hp0oL5Ay7ge/8ZvmYPi4atFmcpcbpJyEIEhthW4kpMFtWI+MRru+5HzswKwPJx72l4ZmcbWztTIn5Ypsf1PNPIKgb96Bf+DrUoSt5zZwNtaG8TI3cEH2rHXWBqcO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yhcn+cup; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yhcn+cup"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-225df540edcso933495ad.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 10:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527162; x=1744131962; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GA2kYs8wQSi+0j0jQaDO25e9tFK5hiSvEa3CXe/PxgU=;
        b=Yhcn+cupvEKrl8TSrr5DkTNWWWF4fx6sAKFh4FpiipFXJkiUVMnWgpKFvQDsCKY9GV
         03XVIIWbWkJshJCn72+zYhIDKJHoQZ+F4745tKLtTz+7fBTJPtdNB6RLWmmxmLsrFZTe
         7di4iKWbK06IGrtORiuhGX+6wr04lC8TFrjbqAAVpyYRexRBPq6QVTp7p7Sx5xhZZEcd
         ReaMSzMMEWArB+szt4AOKeNeHt6A0dF13HpbNzEjvWefitrcjQlBptyv3USRSsWOmnRm
         oOcqU/xdj+0qMxmW+2lRvwPUJpa4otkOhWZdBLESs+NR9GpwKhuY+rGw6QN7sNB8lWvf
         xnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527162; x=1744131962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GA2kYs8wQSi+0j0jQaDO25e9tFK5hiSvEa3CXe/PxgU=;
        b=Rqg1RUfCNJ87WtRdIUdfTQXXSVKSptktZGwUTXdFAFlgnHH7a1kgVNFuaXGywLLxfF
         yYoznL8gMRcYU9B0VCWShZt7F1xQ5SoOnK6qI3isTGWHo+oYnJ4c4OKK8p//pdijWVFU
         PhtcMUVoiqMidscZGf/ocKUtPbISYbX6/EiZefzkJ7jik/cPLtpVGjCbq+POeXdqnrhG
         VHxdZ4f+6u08m8g0fj81mxbxjLloPxr67CXr2/z4uOPrdVG4Ox8JtrbNrmHQ35cGOKSm
         LCDwa27VDrHVgVoEBbmX9atBqh0dXpcL+MwvVvyv1YmRJ/ZUwheLvYOBscTsPTPuTSG9
         3HgQ==
X-Gm-Message-State: AOJu0YwEWmXduEqAec2EPPlrWqnisQX7wq3n7YnMg0mtenu0FCHS5mL2
	NQAvcmHQVUoNW+lGHg+B15EdJU53zN4SLJqgRGAw2oVJLGhdCzXLUMLZb0yt
X-Gm-Gg: ASbGncuSnpkI/XgxYfqqjHLByKx3jXqhLwfnHl9vZTPrzRmhjip7GG0XszOYHGHxQsi
	o+DOdnkm/ubAzDLxd/N1fzWDgNK7gUUnOIkd+P4HgcalDiz/PfDdmQuemAJW4XYjQJhrx3AjxbZ
	yRtAcaUJeSJAu/DcFUwJiv0lnSVO/jC52xbQgmGfgNYCgE7nll6AwOzxoHnn2Zf6RMuf/9btXi0
	MvOKaDSZt4NhiIinIbQ0xUAlSv2x2MIcJQERKog+FKj/jfACcNIhOmnw4N/JyEsw7zGNdaB+Aur
	+v3oaAUtWLHSqNfAiymRl259bnoNZHHsq7FAM+AVtYq+LlgSqQY=
X-Google-Smtp-Source: AGHT+IGEHf7ivlGPdc+XvUBtzZ62oiMeiz87MJ8nWnqxYcGMsRisgl9JgQeZkopDQbtkvb1l7k8dXg==
X-Received: by 2002:a05:6a00:4512:b0:727:39a4:30cc with SMTP id d2e1a72fcca58-739c42f80d1mr1047495b3a.1.1743527162348;
        Tue, 01 Apr 2025 10:06:02 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:02 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 2/7] tee: Add TEE Mediator module which aims to expose TEE to a KVM guest.
Date: Tue,  1 Apr 2025 22:35:22 +0530
Message-ID: <20250401170527.344092-3-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TEE Mediator module is an upper abstraction layer which lets KVM guests
interact with a trusted execution environment.

TEE specific subsystems (such as OP-TEE, for example) can register a set of
handlers through tee_mediator_register_ops() with the TEE Mediator, which will
be called by the kernel when required.

Given this module, architecture specific TEE drivers can implement handler functions to work with these
events if necessary. In most implementations, a special instruction (such as SMC, in arm64) switches control
leading to the TEE. These instructions are usually trapped by the hypervisor when executed by the guest.

This module allows making use of these trapped instructions and mediating the request between guest and TEE.

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 drivers/tee/Kconfig          |   5 ++
 drivers/tee/Makefile         |   1 +
 drivers/tee/tee_mediator.c   | 145 +++++++++++++++++++++++++++++++++++
 include/linux/tee_mediator.h |  39 ++++++++++
 4 files changed, 190 insertions(+)
 create mode 100644 drivers/tee/tee_mediator.c
 create mode 100644 include/linux/tee_mediator.h

diff --git a/drivers/tee/Kconfig b/drivers/tee/Kconfig
index 61b507c18780..dc446c9746ee 100644
--- a/drivers/tee/Kconfig
+++ b/drivers/tee/Kconfig
@@ -11,6 +11,11 @@ menuconfig TEE
 	  This implements a generic interface towards a Trusted Execution
 	  Environment (TEE).
 
+config TEE_MEDIATOR
+	bool "Trusted Execution Environment Mediator support"
+	depends on KVM
+	help
+	  Provides an abstraction layer for TEE drivers to mediate KVM guest requests to the TEE.
 if TEE
 
 source "drivers/tee/optee/Kconfig"
diff --git a/drivers/tee/Makefile b/drivers/tee/Makefile
index 5488cba30bd2..46c44e59dd0b 100644
--- a/drivers/tee/Makefile
+++ b/drivers/tee/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_TEE) += tee.o
+obj-$(CONFIG_TEE_MEDIATOR) += tee_mediator.o
 tee-objs += tee_core.o
 tee-objs += tee_shm.o
 tee-objs += tee_shm_pool.o
diff --git a/drivers/tee/tee_mediator.c b/drivers/tee/tee_mediator.c
new file mode 100644
index 000000000000..d1ae7f4cb994
--- /dev/null
+++ b/drivers/tee/tee_mediator.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * TEE Mediator for the Linux Kernel
+ *
+ * This module enables a KVM guest to interact with a
+ * Trusted Execution Environment in the secure processing
+ * state provided by the architecture.
+ *
+ * Author:
+ *   Yuvraj Sakshith <yuvraj.kernel@gmail.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/tee_mediator.h>
+
+static struct tee_mediator *mediator;
+
+int tee_mediator_register_ops(struct tee_mediator_ops *ops)
+{
+
+	int ret = 0;
+
+	if (!ops) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!mediator) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	mediator->ops = ops;
+
+out:
+	return ret;
+}
+
+int tee_mediator_is_active(void)
+{
+	return (mediator != NULL &&
+	 mediator->ops != NULL && mediator->ops->is_active());
+}
+
+int tee_mediator_create_host(void)
+{
+	int ret = 0;
+
+	if (!tee_mediator_is_active() || !mediator->ops->create_host) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = mediator->ops->create_host();
+
+out:
+	return ret;
+}
+
+int tee_mediator_destroy_host(void)
+{
+	int ret = 0;
+
+	if (!tee_mediator_is_active() || !mediator->ops->destroy_host) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = mediator->ops->destroy_host();
+out:
+	return ret;
+}
+
+int tee_mediator_create_vm(struct kvm *kvm)
+{
+	int ret = 0;
+
+	if (!kvm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!tee_mediator_is_active() || !mediator->ops->create_vm) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = mediator->ops->create_vm(kvm);
+
+out:
+	return ret;
+}
+
+int tee_mediator_destroy_vm(struct kvm *kvm)
+{
+	int ret = 0;
+
+	if (!kvm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!tee_mediator_is_active() || !mediator->ops->destroy_vm) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = mediator->ops->destroy_vm(kvm);
+
+out:
+	return ret;
+}
+
+void tee_mediator_forward_request(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu || !tee_mediator_is_active() || !mediator->ops->forward_request)
+		return;
+
+	mediator->ops->forward_request(vcpu);
+}
+
+static int __init tee_mediator_init(void)
+{
+	int ret = 0;
+
+	mediator = kzalloc(sizeof(*mediator), GFP_KERNEL);
+	if (!mediator) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	pr_info("mediator initialised\n");
+out:
+	return ret;
+}
+module_init(tee_mediator_init);
+
+static void __exit tee_mediator_exit(void)
+{
+	kfree(mediator);
+
+	pr_info("mediator exiting\n");
+}
+module_exit(tee_mediator_exit);
diff --git a/include/linux/tee_mediator.h b/include/linux/tee_mediator.h
new file mode 100644
index 000000000000..4a971de158ec
--- /dev/null
+++ b/include/linux/tee_mediator.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * TEE Mediator for the Linux Kernel
+ *
+ * This module enables a KVM guest to interact with a
+ * Trusted Execution Environment in the secure processing
+ * state provided by the architecture.
+ *
+ * Author:
+ *   Yuvraj Sakshith <yuvraj.kernel@gmail.com>
+ */
+
+#ifndef __TEE_MEDIATOR_H
+#define __TEE_MEDIATOR_H
+
+#include <linux/kvm_host.h>
+
+struct tee_mediator_ops {
+	int (*create_host)(void);
+	int (*destroy_host)(void);
+	int (*create_vm)(struct kvm *kvm);
+	int (*destroy_vm)(struct kvm *kvm);
+	void (*forward_request)(struct kvm_vcpu *vcpu);
+	int (*is_active)(void);
+};
+
+struct tee_mediator {
+	struct tee_mediator_ops *ops;
+};
+
+int tee_mediator_create_host(void);
+int tee_mediator_destroy_host(void);
+int tee_mediator_create_vm(struct kvm *kvm);
+int tee_mediator_destroy_vm(struct kvm *kvm);
+void tee_mediator_forward_request(struct kvm_vcpu *vcpu);
+int tee_mediator_is_active(void);
+int tee_mediator_register_ops(struct tee_mediator_ops *ops);
+
+#endif
-- 
2.43.0

