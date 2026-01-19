Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E3D1624DF
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 02:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768789866; cv=none; b=LerNRv67YOmxhhOHkV7tBmFClUUBcfA/CmngdihGAE38sTL4DQgpBT3iwsvGxubIsNKNYfB5EmzaQDU7nMmkDeGZ3hUpucLryas2oJCJsNd+9WRttj1sWk9MOWF1bQsBCSa20ZxCNAVIRdzhESdMKDEjZwN7qDX90xLoAo0ZaFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768789866; c=relaxed/simple;
	bh=U4SOOCeADJ3d5ujuCwLwN1MYTaX50nykqlzN4omOpQQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fYC+eUSx4KZcRVnJ0+WZBbKQ4cFI5oBPZ3xtE6BhgmWzAwtyhqGey4Y9mxqhTT7T0dn2K4wPn2EGQwMJB3QnkE9xaW42gi0Han21DVAS6yoWhSKHZ7KF6SL3f4Pi62br1qTPDHOedhUpMwX229GQozrhQJPLRYZB9JqXA9+Teog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dvZ902VJfz1T4GT;
	Mon, 19 Jan 2026 10:27:00 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id CDA6E40539;
	Mon, 19 Jan 2026 10:30:59 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Jan 2026 10:30:59 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 19 Jan
 2026 10:30:58 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <arnd@arndb.de>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH v8 RESEND 2/7] KVM: arm64: Add documentation for KVM_EXIT_ARM_LDST64B
Date: Mon, 19 Jan 2026 10:29:23 +0800
Message-ID: <20260119022928.149358-3-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20260119022928.149358-1-wangzhou1@hisilicon.com>
References: <20260119022928.149358-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200004.china.huawei.com (7.202.195.237)

From: Marc Zyngier <maz@kernel.org>

Add a bit of documentation for KVM_EXIT_ARM_LDST64B so that userspace
knows what to expect.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/virt/kvm/api.rst | 43 ++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..bfa0ab343081 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1303,12 +1303,13 @@ userspace, for example because of missing instruction syndrome decode
 information or because there is no device mapped at the accessed IPA, then
 userspace can ask the kernel to inject an external abort using the address
 from the exiting fault on the VCPU. It is a programming error to set
-ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO or
-KVM_EXIT_ARM_NISV. This feature is only available if the system supports
-KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
-how userspace reports accesses for the above cases to guests, across different
-userspace implementations. Nevertheless, userspace can still emulate all Arm
-exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
+ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO,
+KVM_EXIT_ARM_NISV, or KVM_EXIT_ARM_LDST64B. This feature is only available if
+the system supports KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which
+provides commonality in how userspace reports accesses for the above cases to
+guests, across different userspace implementations. Nevertheless, userspace
+can still emulate all Arm exceptions by manipulating individual registers
+using the KVM_SET_ONE_REG API.
 
 See KVM_GET_VCPU_EVENTS for the data structure.
 
@@ -7050,12 +7051,14 @@ in send_page or recv a buffer to recv_page).
 
 ::
 
-		/* KVM_EXIT_ARM_NISV */
+		/* KVM_EXIT_ARM_NISV / KVM_EXIT_ARM_LDST64B */
 		struct {
 			__u64 esr_iss;
 			__u64 fault_ipa;
 		} arm_nisv;
 
+- KVM_EXIT_ARM_NISV:
+
 Used on arm64 systems. If a guest accesses memory not in a memslot,
 KVM will typically return to userspace and ask it to do MMIO emulation on its
 behalf. However, for certain classes of instructions, no instruction decode
@@ -7089,6 +7092,32 @@ Note that although KVM_CAP_ARM_NISV_TO_USER will be reported if
 queried outside of a protected VM context, the feature will not be
 exposed if queried on a protected VM file descriptor.
 
+- KVM_EXIT_ARM_LDST64B:
+
+Used on arm64 systems. When a guest using a LD64B, ST64B, ST64BV, ST64BV0,
+outside of a memslot, KVM will return to userspace with KVM_EXIT_ARM_LDST64B,
+exposing the relevant ESR_EL2 information and faulting IPA, similarly to
+KVM_EXIT_ARM_NISV.
+
+Userspace is supposed to fully emulate the instructions, which includes:
+
+	- fetch of the operands for a store, including ACCDATA_EL1 in the case
+	  of a ST64BV0 instruction
+	- deal with the endianness if the guest is big-endian
+	- emulate the access, including the delivery of an exception if the
+	  access didn't succeed
+	- provide a return value in the case of ST64BV/ST64BV0
+	- return the data in the case of a load
+	- increment PC if the instruction was successfully executed
+
+Note that there is no expectation of performance for this emulation, as it
+involves a large number of interaction with the guest state. It is, however,
+expected that the instruction's semantics are preserved, specially the
+single-copy atomicity property of the 64 byte access.
+
+This exit reason must be handled if userspace sets ID_AA64ISAR1_EL1.LS64 to a
+non-zero value, indicating that FEAT_LS64* is enabled.
+
 ::
 
 		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
-- 
2.33.0

