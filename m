Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64843081CA
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 07:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762500144; cv=none; b=eR+DuUwi9jgf6OEShsiBScVW/4OZvE7ifHD0JmQTm+SvyOyVNkvthPDui+36//Su3XohoAdawEIe+9Wt397k98I2MgScNW24aMDt6rwDO8uoIp5MQEUXmaLZhRBMK3i6TbEJG6eDnHskrxY2DN6NXKgaZInYa3BnbVeZNoRfMVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762500144; c=relaxed/simple;
	bh=Y0GLhquTDlXdRJyhLo+wkC4QPAVZGf/ky3y/eqNw5Kc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0I7+w7962hO9QK9OntMWjc4uwJRCH151OdGI5Cn1BErxW8dQf2KOmuH8bZUmK8zT7xpM9u3+3v157xZt4wE6s+PvbRW3b0bfhKj99pijKbuuagJSZ4TUhSs+IJ1Ho9ziuh1ZB+m777FnpQ61d538Q6ck+lGPiBY3QJFjfmJaKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4d2r7Y4KQGz1cyPm;
	Fri,  7 Nov 2025 15:20:41 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5970A140277;
	Fri,  7 Nov 2025 15:22:18 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Nov 2025 15:22:18 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 7 Nov
 2025 15:22:17 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH v7 3/7] KVM: arm64: Handle DABT caused by LS64* instructions on unsupported memory
Date: Fri, 7 Nov 2025 15:21:23 +0800
Message-ID: <20251107072127.448953-4-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20251107072127.448953-1-wangzhou1@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

From: Yicong Yang <yangyicong@hisilicon.com>

If FEAT_LS64WB not supported, FEAT_LS64* instructions only support
to access Device/Uncacheable memory, otherwise a data abort for
unsupported Exclusive or atomic access (0x35, UAoEF) is generated
per spec. It's implementation defined whether the target exception
level is routed and is possible to implemented as route to EL2 on a
VHE VM according to DDI0487L.b Section C3.2.6 Single-copy atomic
64-byte load/store.

If it's implemented as generate the DABT to the final enabled stage
(stage-2), inject the UAoEF back to the guest after checking the
memslot is valid.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 arch/arm64/include/asm/esr.h         |  8 +++++++
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 34 ++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                 | 14 +++++++++++-
 4 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index e1deed824464..63cd17f830da 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -124,6 +124,7 @@
 #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
 #define ESR_ELx_FSC_SECC	(0x18)
 #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
+#define ESR_ELx_FSC_EXCL_ATOMIC	(0x35)
 #define ESR_ELx_FSC_ADDRSZ	(0x00)
 
 /*
@@ -488,6 +489,13 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
 	       (esr == ESR_ELx_FSC_ACCESS_L(0));
 }
 
+static inline bool esr_fsc_is_excl_atomic_fault(unsigned long esr)
+{
+	esr = esr & ESR_ELx_FSC;
+
+	return esr == ESR_ELx_FSC_EXCL_ATOMIC;
+}
+
 static inline bool esr_fsc_is_addr_sz_fault(unsigned long esr)
 {
 	esr &= ESR_ELx_FSC;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9eab316398e..bab967d65715 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -47,6 +47,7 @@ void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
+int kvm_inject_dabt_excl_atomic(struct kvm_vcpu *vcpu, u64 addr);
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
 
 static inline int kvm_inject_sea_dabt(struct kvm_vcpu *vcpu, u64 addr)
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index dfcd66c65517..6cc7ad84d7d8 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -253,6 +253,40 @@ int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 	return 1;
 }
 
+static int kvm_inject_nested_excl_atomic(struct kvm_vcpu *vcpu, u64 addr)
+{
+	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_DABT_LOW) |
+		  FIELD_PREP(ESR_ELx_FSC, ESR_ELx_FSC_EXCL_ATOMIC) |
+		  ESR_ELx_IL;
+
+	vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
+	return kvm_inject_nested_sync(vcpu, esr);
+}
+
+/**
+ * kvm_inject_dabt_excl_atomic - inject a data abort for unsupported exclusive
+ *				 or atomic access
+ * @vcpu: The VCPU to receive the data abort
+ * @addr: The address to report in the DFAR
+ *
+ * It is assumed that this code is called from the VCPU thread and that the
+ * VCPU therefore is not currently executing guest code.
+ */
+int kvm_inject_dabt_excl_atomic(struct kvm_vcpu *vcpu, u64 addr)
+{
+	u64 esr;
+
+	if (is_nested_ctxt(vcpu) && (vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM))
+		return kvm_inject_nested_excl_atomic(vcpu, addr);
+
+	__kvm_inject_sea(vcpu, false, addr);
+	esr = vcpu_read_sys_reg(vcpu, exception_esr_elx(vcpu));
+	esr &= ~ESR_ELx_FSC;
+	esr |= ESR_ELx_FSC_EXCL_ATOMIC;
+	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+	return 1;
+}
+
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned long addr, esr;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..06cec9070ea6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1802,6 +1802,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return ret;
 	}
 
+	/*
+	 * Guest performs atomic/exclusive operations on memory with unsupported
+	 * attributes (e.g. ld64b/st64b on normal memory when no FEAT_LS64WB)
+	 * and trigger the exception here. Since the memslot is valid, inject
+	 * the fault back to the guest.
+	 */
+	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(vcpu))) {
+		kvm_inject_dabt_excl_atomic(vcpu, kvm_vcpu_get_hfar(vcpu));
+		return 1;
+	}
+
 	if (nested)
 		adjust_nested_fault_perms(nested, &prot, &writable);
 
@@ -1971,7 +1982,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	/* Check the stage-2 fault is trans. fault or write fault */
 	if (!esr_fsc_is_translation_fault(esr) &&
 	    !esr_fsc_is_permission_fault(esr) &&
-	    !esr_fsc_is_access_flag_fault(esr)) {
+	    !esr_fsc_is_access_flag_fault(esr) &&
+	    !esr_fsc_is_excl_atomic_fault(esr)) {
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
 			kvm_vcpu_trap_get_class(vcpu),
 			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
-- 
2.33.0

