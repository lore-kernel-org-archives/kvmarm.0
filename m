Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648754;
	b=jgyO70rPSb17FMSCDSiE9P41cBI5y7LVRzfDGkLJgnDNss/mB38vo4Rb6fbMVfNdhfXA
	 3ZxPBw94JS/a/xGxs5FyCuSb89oZ8XmcAT7i7Nb2KbpLphvyKHZjnArsF/NABSzrdjQDP
	 pZlrtKtipzBqhQPcKoYlWg/70GFC/TsFfE/dkEuHgL6Tnf9CcEGrP6fTzVCbPjDunnEfV
	 LEVDjHOMkiXCEDiJf3te1rL5nrbD0dBBnRGL21X7fBLWOqWwCP6b4cLSMRVQjkL0Xk3wH
	 qQP5Hvf5o78VWIUT7RwPWv+pueXq/b8cYd1Pauh99M76o/txrSjCZ13mO2bZ01PJGDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648754;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kMEGc0eVEgC2D9JP8FTGru/6bKm39/nf8BU8+sRFibw=;
	b=RU8vFubbwie5x02gHJ//q94POuIoaFAL9P0a4qjfHA8k0F1pu4776g/p7radOD3g4piG
	 3OxvsBpAItLFn2SPn1rSs8Pa90znvOV08h5ax2qCOqk91G1G6knVqn+kOAWPE2c6UZdmi
	 vY0j2nrzko9tkZyVbklvqXbq/IGMmwY0vRdhHq1KvJOZtTFBEsNvnpNBcq9nAtCrZ2vQ0
	 yb57udOHA5cSxalzcjL4ZclBUNgQqaJuAIS8PTMmjVJFcmfjE9GaUBXHHwr0q5LsiIK6x
	 TI21o3sHpGJaJaDMffyeei9pK5J1mEEsLWrIjeUgSZ5pI3JSQI8UzaNAzgKXO5IIbfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RKaht33I;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E21F606A32D
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E21F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RKaht33I
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78DE216A3;
	Mon,  2 Nov 2026 11:45:50 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C241D3F673;
	Mon,  2 Nov 2026 11:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648753; bh=8ufYLTgExRcynqcSclIrqXjVMInyx7aBmEPJwxCFi+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKaht33Iu3Z85+5soFy0KwsJr5+zf06qBJMEj8pHg+XR1w5r1m9D0xdcw54jwWlUC
	 6I79icFOfYrsHZdWu//nhwXVv3FbSDp610yp/m0RvYHvX7YorKcLlkG5edv0GowYTZ
	 t2Yjx6tJuSSxnqE7HAh3TwsJMV9+PROFGwY+bYPw=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH v2 11/16] irqchip/gic-v5: Enable direct injection in ITS
Date: Mon,  2 Nov 2026 19:44:49 +0000
Message-Id: <20261102194454.4086911-12-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102194454.4086911-1-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow KVM to replace a host ITTE with a virtual translation that
directly injects an interrupt into a guest. Add an irq_chip callback to
install and remove the virtual translation, and disable lazy masking
while the interrupt is forwarded. The KVM caller is added later.

The ITS writes the ITTE before invalidating its cache. If invalidation
times out, hardware may still use the virtual translation even though
setup failed. Allow disable to restore the host ITTE when the forwarded
flag is clear, and retain retryable state if restoration also times
out. Keep lazy masking disabled until the host mapping is restored.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-its.c   | 141 +++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v5.h |   8 ++
 2 files changed, 149 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v5-its.c
index 28e39b065de0e..d91f4ea1ef440 100644
--- a/drivers/irqchip/irq-gic-v5-its.c
+++ b/drivers/irqchip/irq-gic-v5-its.c
@@ -61,6 +61,48 @@ static void its_writeq_relaxed(struct gicv5_its_chip_data *its_node, const u64 v
 	writeq_relaxed(val, its_node->its_base + reg_offset);
 }
 
+#ifdef CONFIG_KVM
+int gicv5_its_enable_direct_injection(int virq, u16 vm_id, u32 guest_lpi)
+{
+	struct virt_intr_data virt_intr = {
+		.vm_id		= vm_id,
+		.guest_lpi	= guest_lpi,
+	};
+	int ret;
+
+	/*
+	 * The host will never see that interrupt firing again, so it
+	 * is vital that we don't do any lazy masking.
+	 */
+	irq_set_status_flags(virq, IRQ_DISABLE_UNLAZY);
+
+	ret = irq_set_vcpu_affinity(virq, &virt_intr);
+	if (ret && ret != -ETIMEDOUT && ret != -EBUSY)
+		irq_clear_status_flags(virq, IRQ_DISABLE_UNLAZY);
+
+	return ret;
+}
+
+int gicv5_its_disable_direct_injection(int virq)
+{
+	int ret;
+
+	ret = irq_set_vcpu_affinity(virq, NULL);
+	if (ret) {
+		pr_err("Failed to restore host interrupt\n");
+		return ret;
+	}
+
+	/*
+	 * In theory the host could see the interrupt again now. Undo this
+	 * again.
+	 */
+	irq_clear_status_flags(virq, IRQ_DISABLE_UNLAZY);
+
+	return 0;
+}
+#endif /* CONFIG_KVM */
+
 static void gicv5_its_dcache_clean(struct gicv5_its_chip_data *its, void *start,
 				   size_t sz)
 {
@@ -723,6 +765,102 @@ static void gicv5_its_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 	msi_msg_set_addr(irq_data_get_msi_desc(d), msg, addr);
 }
 
+#ifdef CONFIG_KVM
+static int gicv5_its_set_vcpu_affinity(struct irq_data *d, void *int_data)
+{
+	struct gicv5_its_dev *its_dev = irq_data_get_irq_chip_data(d);
+	u16 event_id = FIELD_GET(GICV5_ITS_HWIRQ_EVENT_ID, d->hwirq);
+	u32 dev_id = FIELD_GET(GICV5_ITS_HWIRQ_DEVICE_ID, d->hwirq);
+	struct virt_intr_data *data = int_data;
+	struct gicv5_its_chip_data *its;
+	__le64 *itte;
+	u64 itte_val, tmp;
+	int ret = 0;
+
+	if (IS_ERR(its_dev)) {
+		pr_err("Failed to find ITS entry for DeviceID 0x%x", dev_id);
+		return PTR_ERR(its_dev);
+	}
+
+	its = its_dev->its_node;
+
+	itte = gicv5_its_device_get_itte_ref(its_dev, event_id);
+	itte_val = le64_to_cpu(*itte);
+
+	/*
+	 * The host entry should be valid, else something strange is going on!
+	 */
+	if (!(itte_val & GICV5_ITTL2E_VALID)) {
+		if (data)
+			return -EINVAL;
+		if (!irqd_is_forwarded_to_vcpu(d))
+			return 0;
+		goto invalidate;
+	}
+
+	if (data) {
+		if (irqd_is_forwarded_to_vcpu(d)) {
+			if ((itte_val & GICV5_ITTL2E_VIRTUAL) &&
+			    FIELD_GET(GICV5_ITTL2E_LPI_ID, itte_val) == data->guest_lpi &&
+			    FIELD_GET(GICV5_ITTL2E_VM_ID, itte_val) == data->vm_id)
+				return 0;
+			return -EBUSY;
+		}
+
+		/* Stale virtual translation without forwarded state. */
+		if (itte_val & GICV5_ITTL2E_VIRTUAL)
+			return -EBUSY;
+
+		tmp = FIELD_PREP(GICV5_ITTL2E_LPI_ID, data->guest_lpi);
+		tmp |= FIELD_PREP(GICV5_ITTL2E_VM_ID, data->vm_id);
+		tmp |= GICV5_ITTL2E_VIRTUAL;
+		tmp |= GICV5_ITTL2E_VALID;
+
+		its_write_table_entry(its, itte, tmp);
+	} else {
+		/*
+		 * A failed sync still needs retrying, even if the ITTE is
+		 * host-owned.
+		 */
+		if (!(itte_val & GICV5_ITTL2E_VIRTUAL) &&
+		    !irqd_is_forwarded_to_vcpu(d))
+			return 0;
+
+		if (itte_val & GICV5_ITTL2E_VIRTUAL) {
+			tmp = FIELD_PREP(GICV5_ITTL2E_LPI_ID,
+					 d->parent_data->hwirq);
+			tmp |= GICV5_ITTL2E_VALID;
+			its_write_table_entry(its, itte, tmp);
+		}
+	}
+
+invalidate:
+	/* Make the change ITS-visible */
+	dsb(st);
+	ret = gicv5_its_itt_cache_inv(its, dev_id, event_id);
+	if (!ret && !data) {
+		/*
+		 * Invalidation sends events using the old translation to the
+		 * IRS, but does not wait for them to be processed.
+		 */
+		gicv5_irs_syncr();
+	}
+	if (ret) {
+		/* Keep a failed restoration distinguishable from a clean host ITTE. */
+		if (!data)
+			irqd_set_forwarded_to_vcpu(d);
+		return ret;
+	}
+
+	if (data)
+		irqd_set_forwarded_to_vcpu(d);
+	else
+		irqd_clr_forwarded_to_vcpu(d);
+
+	return 0;
+}
+#endif /* CONFIG_KVM */
+
 static const struct irq_chip gicv5_its_irq_chip = {
 	.name			= "GICv5-ITS-MSI",
 	.irq_mask		= irq_chip_mask_parent,
@@ -732,6 +870,9 @@ static const struct irq_chip gicv5_its_irq_chip = {
 	.irq_get_irqchip_state	= irq_chip_get_parent_state,
 	.irq_set_irqchip_state	= irq_chip_set_parent_state,
 	.irq_compose_msi_msg	= gicv5_its_compose_msi_msg,
+#ifdef CONFIG_KVM
+	.irq_set_vcpu_affinity	= gicv5_its_set_vcpu_affinity,
+#endif /* CONFIG_KVM */
 };
 
 static struct gicv5_its_dev *gicv5_its_find_device(struct gicv5_its_chip_data *its,
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm-gic-v5.h
index 6e8484fef9faf..26ca29794a960 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -727,4 +727,12 @@ enum gicv5_vcpu_cmd {
 	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
 };
 
+struct virt_intr_data {
+	u16 vm_id;
+	u32 guest_lpi;
+};
+
+int gicv5_its_enable_direct_injection(int virq, u16 vm_id, u32 guest_lpi);
+int gicv5_its_disable_direct_injection(int virq);
+
 #endif
-- 
2.34.1

