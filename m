Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F6D3081B7
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 07:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762500143; cv=none; b=JgpLCgUae0vSwrN7mSZc4v0GK7tVNHLdpyN10Fv8Z47gtnGv3mUSC1LltyWbYhEOqpk++oqh4s85o+pZmip1mA1hU46M648UJIj3M0+54nvEcd2kwrGGqwXTqIyq7A0PnELIph5UIbVpZcb93E+3Bo2iJYD0ci3A4roNzIIHgYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762500143; c=relaxed/simple;
	bh=RYp0DG4CHJJInH7j31xP24BuAObnQzry1LquoapxGNc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r1la86v3JUzAN8623JMGPHpoOePKgKByEccKjGbHZV916ZRcvmJVnV4XAhDsviWQQW9RjGBPCR2/y91YpQcv06b+vh4OmWbLFqiSA2klLB6afxDP0qeqGZeG8VRtRUitR8mAIhfQIYPcUzYGznckziVmnRu0fX121PUa64zvErk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d2r7X6gPtzmV7X;
	Fri,  7 Nov 2025 15:20:40 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 792551A016C;
	Fri,  7 Nov 2025 15:22:17 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Nov 2025 15:22:17 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 7 Nov
 2025 15:22:16 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH v7 1/7] KVM: arm64: Add exit to userspace on {LD,ST}64B* outside of memslots
Date: Fri, 7 Nov 2025 15:21:21 +0800
Message-ID: <20251107072127.448953-2-wangzhou1@hisilicon.com>
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

From: Marc Zyngier <maz@kernel.org>

The main use of {LD,ST}64B* is to talk to a device, which is hopefully
directly assigned to the guest and requires no additional handling.

However, this does not preclude a VMM from exposing a virtual device
to the guest, and to allow 64 byte accesses as part of the programming
interface. A direct consequence of this is that we need to be able
to forward such access to userspace.

Given that such a contraption is very unlikely to ever exist, we choose
to offer a limited service: userspace gets (as part of a new exit reason)
the ESR, the IPA, and that's it. It is fully expected to handle the full
semantics of the instructions, deal with ACCDATA, the return values and
increment PC. Much fun.

A canonical implementation can also simply inject an abort and be done
with it. Frankly, don't try to do anything else unless you have time
to waste.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 arch/arm64/kvm/mmio.c    | 27 ++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h |  3 ++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 54f9358c9e0e..2a6261abb647 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -159,6 +159,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	bool is_write;
 	int len;
 	u8 data_buf[8];
+	u64 esr;
+
+	esr = kvm_vcpu_get_esr(vcpu);
 
 	/*
 	 * No valid syndrome? Ask userspace for help if it has
@@ -168,7 +171,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	 * though, so directly deliver an exception to the guest.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
-		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
+		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), esr,
 				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
 		if (vcpu_is_protected(vcpu))
@@ -185,6 +188,28 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 		return -ENOSYS;
 	}
 
+	/*
+	 * When (DFSC == 0b00xxxx || DFSC == 0b10101x) && DFSC != 0b0000xx
+	 * ESR_EL2[12:11] describe the Load/Store Type. This allows us to
+	 * punt the LD64B/ST64B/ST64BV/ST64BV0 instructions to luserspace,
+	 * which will have to provide a full emulation of these 4
+	 * instructions.  No, we don't expect this do be fast.
+	 *
+	 * We rely on traps being set if the corresponding features are not
+	 * enabled, so if we get here, userspace has promised us to handle
+	 * it already.
+	 */
+	switch (kvm_vcpu_trap_get_fault(vcpu)) {
+	case 0b000100 ... 0b001111:
+	case 0b101010 ... 0b101011:
+		if (FIELD_GET(GENMASK(12, 11), esr)) {
+			run->exit_reason = KVM_EXIT_ARM_LDST64B;
+			run->arm_nisv.esr_iss = esr & ~(u64)ESR_ELx_FSC;
+			run->arm_nisv.fault_ipa = fault_ipa;
+			return 0;
+		}
+	}
+
 	/*
 	 * Prepare MMIO operation. First decode the syndrome data we get
 	 * from the CPU. Then try if some in-kernel emulation feels
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..d219946b96be 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
+#define KVM_EXIT_ARM_LDST64B      41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -401,7 +402,7 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
-		/* KVM_EXIT_ARM_NISV */
+		/* KVM_EXIT_ARM_NISV / KVM_EXIT_ARM_LDST64B */
 		struct {
 			__u64 esr_iss;
 			__u64 fault_ipa;
-- 
2.33.0

