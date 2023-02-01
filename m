Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5D98494
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:54 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id m16-20020a05600c3b1000b003dc4050c94aso1362631wms.4
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJX+SGqG6zLegXNP2FyB5mHsuPTdUwTTVk34rvHHB9Y=;
        b=PX2X8jEZRjn8B8OW49X9Nl3Le/FoV4QE6thuBsRX/+nQGyRsVqDLBvVfNztzNB/jbw
         RLqoljwE0InPvfppftU1jxH8AjJ6YPIrVNh760Ncn4iJufwpkb9ZDy9ZXYGc2qs2IcdU
         47ectI5CDPmjzt1TBluvUasl1VQFttGX+Iziaax7lP9KI6UO0kUxBesC7i7kyN5/IRwZ
         MVokWcuVTv6QYBqKthSeBEFFzcGhVBuYtsUydbkiSpZN5vdHeQHr9ASZt9CvkNdqX/Ku
         7MT5C/UmYdvFTN2Y9xq4gImapqPicu2RyWwf9LGwsoGavKOq7GZR1/ftyYs/K1PpcHyk
         uzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJX+SGqG6zLegXNP2FyB5mHsuPTdUwTTVk34rvHHB9Y=;
        b=qUZdqYGEjUCj9NweR8MUlgQlVrnWOpj7bZYpEnm1vP/W/8t0MHxUzJbk2HsilUZoSi
         MOgNhOMSCGjVvwMQeBXe92mR+RDoK2rNF0FD/75FC8I4b3QWW2EBon+EUMC6BjHdgtvy
         dtZSMlqovQfAz7Y2iwxxDxy1kPfOsTxRwah+FtC+Z89WYI6cxAReBIkiogvJIHMQhkUF
         FjTarXHRwdYqHpXEgd1WvFLyOitSMBm+F4sLX4d4KpfU/fwaYw8S4oIJxlrdCu9opPRk
         gUtun3daXHxAu1yWIYcmdiDUj/WTwd0K2l6Y7ij28V/nynMxwKZLknEMglKdzjPz3nWu
         aCew==
X-Gm-Message-State: AO0yUKV+hywH+K/0sXgwv3dYAFsyZJNUsSaRoR4zs6btRHSoIIvE/DiY
	Bz9HLb3M7OMy25XI60qXepkwsg==
X-Google-Smtp-Source: AK7set/gosJV6CCV/9cnL0aXRK2ZgMnlEyfxjA1eQ/7IxDIjm2hJYiDK0rKFD5ZmlMlkIiJhOyQH2g==
X-Received: by 2002:a05:600c:3789:b0:3dc:54e9:dfd7 with SMTP id o9-20020a05600c378900b003dc54e9dfd7mr2105226wmr.25.1675256392661;
        Wed, 01 Feb 2023 04:59:52 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:52 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 42/45] KVM: arm64: pkvm: Support SCMI power domain
Date: Wed,  1 Feb 2023 12:53:26 +0000
Message-Id: <20230201125328.2186498-43-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hypervisor needs to catch power domain changes for devices it owns,
such as the SMMU. Possible reasons:

* Ensure that software and hardware states are consistent. The driver
  does not attempt to modify the state while the device is off.
* Save and restore the device state.
* Enforce dependency between consumers and suppliers. For example ensure
  that endpoints are off before turning the SMMU off, in case a powered
  off SMMU lets DMA through. However this is normally enforced by
  firmware.

Add a SCMI power domain, as the standard method for device power
management on Arm. Other methods can be added to kvm_power_domain later.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/nvhe/Makefile              |   1 +
 arch/arm64/include/asm/kvm_hyp.h              |   1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  26 ++
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
 include/kvm/power_domain.h                    |  22 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   4 +-
 arch/arm64/kvm/hyp/nvhe/power/scmi.c          | 233 ++++++++++++++++++
 7 files changed, 287 insertions(+), 2 deletions(-)
 create mode 100644 include/kvm/power_domain.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/power/scmi.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8359909bd796..583a1f920c81 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -32,6 +32,7 @@ hyp-obj-$(CONFIG_KVM_IOMMU) += iommu/iommu.o
 hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += iommu/arm-smmu-v3.o
 hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += iommu/io-pgtable-arm.o \
 	../../../../../drivers/iommu/io-pgtable-arm-common.o
+hyp-obj-y += power/scmi.o
 
 ##
 ## Build rules for compiling nVHE hyp code
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 0226a719e28f..91b792d1c074 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -104,6 +104,7 @@ void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
+bool kvm_host_scmi_handler(struct kvm_cpu_context *host_ctxt);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 746dc1c05a8e..1025354b4650 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -8,6 +8,7 @@
 #define __ARM64_KVM_NVHE_PKVM_H__
 
 #include <asm/kvm_pkvm.h>
+#include <kvm/power_domain.h>
 
 #include <nvhe/gfp.h>
 #include <nvhe/spinlock.h>
@@ -112,4 +113,29 @@ struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *vm, u64 mpidr);
 int pkvm_timer_init(void);
 void pkvm_udelay(unsigned long usecs);
 
+struct kvm_power_domain_ops {
+	int (*power_on)(struct kvm_power_domain *pd);
+	int (*power_off)(struct kvm_power_domain *pd);
+};
+
+int pkvm_init_scmi_pd(struct kvm_power_domain *pd,
+		      const struct kvm_power_domain_ops *ops);
+
+/*
+ * Register a power domain. When the hypervisor catches power requests from the
+ * host for this power domain, it calls the power ops with @pd as argument.
+ */
+static inline int pkvm_init_power_domain(struct kvm_power_domain *pd,
+					 const struct kvm_power_domain_ops *ops)
+{
+	switch (pd->type) {
+	case KVM_POWER_DOMAIN_NONE:
+		return 0;
+	case KVM_POWER_DOMAIN_ARM_SCMI:
+		return pkvm_init_scmi_pd(pd, ops);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
index 1e6d995968a1..0e6bb92ccdb7 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -15,4 +15,6 @@
 #define DECLARE_REG(type, name, ctxt, reg)	\
 				type name = (type)cpu_reg(ctxt, (reg))
 
+void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
+
 #endif /* __ARM64_KVM_NVHE_TRAP_HANDLER_H__ */
diff --git a/include/kvm/power_domain.h b/include/kvm/power_domain.h
new file mode 100644
index 000000000000..3dcb40005a04
--- /dev/null
+++ b/include/kvm/power_domain.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_POWER_DOMAIN_H
+#define __KVM_POWER_DOMAIN_H
+
+enum kvm_power_domain_type {
+	KVM_POWER_DOMAIN_NONE,
+	KVM_POWER_DOMAIN_ARM_SCMI,
+};
+
+struct kvm_power_domain {
+	enum kvm_power_domain_type	type;
+	union {
+		struct {
+			u32		smc_id;
+			u32		domain_id;
+			phys_addr_t	shmem_base;
+			size_t		shmem_size;
+		} arm_scmi;
+	};
+};
+
+#endif /* __KVM_POWER_DOMAIN_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 34ec46b890f0..ad0877e6ea54 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -37,8 +37,6 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 struct kvm_iommu_ops kvm_iommu_ops;
 
-void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
-
 typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
 
 static void handle_pvm_entry_wfx(struct pkvm_hyp_vcpu *hyp_vcpu)
@@ -1217,6 +1215,8 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	bool handled;
 
 	handled = kvm_host_psci_handler(host_ctxt);
+	if (!handled)
+		handled = kvm_host_scmi_handler(host_ctxt);
 	if (!handled)
 		default_host_smc_handler(host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/power/scmi.c b/arch/arm64/kvm/hyp/nvhe/power/scmi.c
new file mode 100644
index 000000000000..e9ac33f3583c
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/power/scmi.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+
+#include <linux/bitfield.h>
+
+#include <nvhe/pkvm.h>
+#include <nvhe/mm.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/trap_handler.h>
+
+/* SCMI protocol */
+#define SCMI_PROTOCOL_POWER_DOMAIN	0x11
+
+/*  shmem registers */
+#define SCMI_SHM_CHANNEL_STATUS		0x4
+#define SCMI_SHM_CHANNEL_FLAGS		0x10
+#define SCMI_SHM_LENGTH			0x14
+#define SCMI_SHM_MESSAGE_HEADER		0x18
+#define SCMI_SHM_MESSAGE_PAYLOAD	0x1c
+
+/*  channel status */
+#define SCMI_CHN_FREE			(1U << 0)
+#define SCMI_CHN_ERROR			(1U << 1)
+
+/*  channel flags */
+#define SCMI_CHN_IRQ			(1U << 0)
+
+/*  message header */
+#define SCMI_HDR_TOKEN			GENMASK(27, 18)
+#define SCMI_HDR_PROTOCOL_ID		GENMASK(17, 10)
+#define SCMI_HDR_MESSAGE_TYPE		GENMASK(9, 8)
+#define SCMI_HDR_MESSAGE_ID		GENMASK(7, 0)
+
+/*  power domain */
+#define SCMI_PD_STATE_SET		0x4
+#define SCMI_PD_STATE_SET_FLAGS		0x0
+#define SCMI_PD_STATE_SET_DOMAIN_ID	0x4
+#define SCMI_PD_STATE_SET_POWER_STATE	0x8
+
+#define SCMI_PD_STATE_SET_STATUS	0x0
+
+#define SCMI_PD_STATE_SET_FLAGS_ASYNC	(1U << 0)
+
+#define SCMI_PD_POWER_ON		0
+#define SCMI_PD_POWER_OFF		(1U << 30)
+
+#define SCMI_SUCCESS			0
+
+
+static struct {
+	u32				smc_id;
+	phys_addr_t			shmem_pfn;
+	size_t				shmem_size;
+	void __iomem			*shmem;
+} scmi_channel;
+
+#define MAX_POWER_DOMAINS		16
+
+struct scmi_power_domain {
+	struct kvm_power_domain			*pd;
+	const struct kvm_power_domain_ops	*ops;
+};
+
+static struct scmi_power_domain scmi_power_domains[MAX_POWER_DOMAINS];
+static int scmi_power_domain_count;
+
+#define SCMI_POLL_TIMEOUT_US	1000000 /* 1s! */
+
+/* Forward the command to EL3, and wait for completion */
+static int scmi_run_command(struct kvm_cpu_context *host_ctxt)
+{
+	u32 reg;
+	unsigned long i = 0;
+
+	__kvm_hyp_host_forward_smc(host_ctxt);
+
+	do {
+		reg = readl_relaxed(scmi_channel.shmem + SCMI_SHM_CHANNEL_STATUS);
+		if (reg & SCMI_CHN_FREE)
+			break;
+
+		if (WARN_ON(++i > SCMI_POLL_TIMEOUT_US))
+			return -ETIMEDOUT;
+
+		pkvm_udelay(1);
+	} while (!(reg & (SCMI_CHN_FREE | SCMI_CHN_ERROR)));
+
+	if (reg & SCMI_CHN_ERROR)
+		return -EIO;
+
+	reg = readl_relaxed(scmi_channel.shmem + SCMI_SHM_MESSAGE_PAYLOAD +
+			    SCMI_PD_STATE_SET_STATUS);
+	if (reg != SCMI_SUCCESS)
+		return -EIO;
+
+	return 0;
+}
+
+static void __kvm_host_scmi_handler(struct kvm_cpu_context *host_ctxt)
+{
+	int i;
+	u32 reg;
+	struct scmi_power_domain *scmi_pd = NULL;
+
+	/*
+	 * FIXME: the spec does not really allow for an intermediary filtering
+	 * messages on the channel: as soon as the host clears SCMI_CHN_FREE,
+	 * the server may process the message. It doesn't have to wait for a
+	 * doorbell and could just poll on the shared mem. Unlikely in practice,
+	 * but this code is not correct without a spec change requiring the
+	 * server to observe an SMC before processing the message.
+	 */
+	reg = readl_relaxed(scmi_channel.shmem + SCMI_SHM_CHANNEL_STATUS);
+	if (reg & (SCMI_CHN_FREE | SCMI_CHN_ERROR))
+		return;
+
+	reg = readl_relaxed(scmi_channel.shmem + SCMI_SHM_MESSAGE_HEADER);
+	if (FIELD_GET(SCMI_HDR_PROTOCOL_ID, reg) != SCMI_PROTOCOL_POWER_DOMAIN)
+		goto out_forward_smc;
+
+	if (FIELD_GET(SCMI_HDR_MESSAGE_ID, reg) != SCMI_PD_STATE_SET)
+		goto out_forward_smc;
+
+	reg = readl_relaxed(scmi_channel.shmem + SCMI_SHM_MESSAGE_PAYLOAD +
+			    SCMI_PD_STATE_SET_FLAGS);
+	if (WARN_ON(reg & SCMI_PD_STATE_SET_FLAGS_ASYNC))
+		/* We don't support async requests at the moment */
+		return;
+
+	reg = readl_relaxed(scmi_channel.shmem + SCMI_SHM_MESSAGE_PAYLOAD +
+			    SCMI_PD_STATE_SET_DOMAIN_ID);
+
+	for (i = 0; i < MAX_POWER_DOMAINS; i++) {
+		if (!scmi_power_domains[i].pd)
+			break;
+
+		if (reg == scmi_power_domains[i].pd->arm_scmi.domain_id) {
+			scmi_pd = &scmi_power_domains[i];
+			break;
+		}
+	}
+	if (!scmi_pd)
+		goto out_forward_smc;
+
+	reg = readl_relaxed(scmi_channel.shmem + SCMI_SHM_MESSAGE_PAYLOAD +
+			    SCMI_PD_STATE_SET_POWER_STATE);
+	switch (reg) {
+	case SCMI_PD_POWER_ON:
+		if (scmi_run_command(host_ctxt))
+			break;
+
+		scmi_pd->ops->power_on(scmi_pd->pd);
+		break;
+	case SCMI_PD_POWER_OFF:
+		scmi_pd->ops->power_off(scmi_pd->pd);
+
+		if (scmi_run_command(host_ctxt))
+			scmi_pd->ops->power_on(scmi_pd->pd);
+		break;
+	}
+	return;
+
+out_forward_smc:
+	__kvm_hyp_host_forward_smc(host_ctxt);
+}
+
+bool kvm_host_scmi_handler(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, func_id, host_ctxt, 0);
+
+	if (!scmi_channel.shmem || func_id != scmi_channel.smc_id)
+		return false; /* Unhandled */
+
+	/*
+	 * Prevent the host from modifying the request while it is in flight.
+	 * One page is enough, SCMI messages are smaller than that.
+	 *
+	 * FIXME: the host is allowed to poll the shmem while the request is in
+	 * flight, or read shmem when receiving the SCMI interrupt. Although
+	 * it's unlikely with the SMC-based transport, this too requires some
+	 * tightening in the spec.
+	 */
+	if (WARN_ON(__pkvm_host_add_remove_page(scmi_channel.shmem_pfn, true)))
+		return true;
+
+	__kvm_host_scmi_handler(host_ctxt);
+
+	WARN_ON(__pkvm_host_add_remove_page(scmi_channel.shmem_pfn, false));
+	return true; /* Handled */
+}
+
+int pkvm_init_scmi_pd(struct kvm_power_domain *pd,
+		      const struct kvm_power_domain_ops *ops)
+{
+	int ret;
+
+	if (!IS_ALIGNED(pd->arm_scmi.shmem_base, PAGE_SIZE) ||
+	    pd->arm_scmi.shmem_size < PAGE_SIZE) {
+		return -EINVAL;
+	}
+
+	if (!scmi_channel.shmem) {
+		unsigned long shmem;
+
+		/* FIXME: Do we need to mark those pages shared in the host s2? */
+		ret = __pkvm_create_private_mapping(pd->arm_scmi.shmem_base,
+						    pd->arm_scmi.shmem_size,
+						    PAGE_HYP_DEVICE,
+						    &shmem);
+		if (ret)
+			return ret;
+
+		scmi_channel.smc_id = pd->arm_scmi.smc_id;
+		scmi_channel.shmem_pfn = hyp_phys_to_pfn(pd->arm_scmi.shmem_base);
+		scmi_channel.shmem = (void *)shmem;
+
+	} else if (scmi_channel.shmem_pfn !=
+		   hyp_phys_to_pfn(pd->arm_scmi.shmem_base) ||
+		   scmi_channel.smc_id != pd->arm_scmi.smc_id) {
+		/* We support a single channel at the moment */
+		return -ENXIO;
+	}
+
+	if (scmi_power_domain_count == MAX_POWER_DOMAINS)
+		return -ENOSPC;
+
+	scmi_power_domains[scmi_power_domain_count].pd = pd;
+	scmi_power_domains[scmi_power_domain_count].ops = ops;
+	scmi_power_domain_count++;
+	return 0;
+}
-- 
2.39.0

