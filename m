Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EB4273D68
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 08:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752567268; cv=none; b=GMW4G67Ag2gcD9JhAU4QibY1rXeospF1sRoJBm9QnF9hy8+2tpErm1vcMMmZs+vmIG8V+muhsw03D+x/AEtBFHm3nTqhZ7mT3/vqJexGvZUNtNfnBUAY3hxB89BGdwYLxhZNyezyNMAKIf0uwrslOzEtC0xaFSGSETs4wy4rZ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752567268; c=relaxed/simple;
	bh=/+7OdLQE8nw92AQVtAFKRFzf1fW/8M4gBesYexNvEyg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bfjzSG/CNDgPI3A9i1Hl8CDO5uTZn24vIIkrg6GV1iOdA2D1c+kQDFGBqGPS717de+pt2k9roMfcv1lcmIc2mB+1OFXIeyhAkG7gE2P1noF3h8umwHOC2FvZyzrNQJPZ9flbC+Zq+R7eI84GJan1hPM4EGShnBXYef80MwBa3To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bhBlJ72MLzqVDZ;
	Tue, 15 Jul 2025 16:13:16 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 722921401F4;
	Tue, 15 Jul 2025 16:14:22 +0800 (CST)
Received: from kwepemq200018.china.huawei.com (7.202.195.108) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Jul 2025 16:14:22 +0800
Received: from localhost.localdomain (10.50.165.33) by
 kwepemq200018.china.huawei.com (7.202.195.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Jul 2025 16:14:21 +0800
From: Yicong Yang <yangyicong@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <corbet@lwn.net>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<shuah@kernel.org>, <jonathan.cameron@huawei.com>,
	<shameerali.kolothum.thodi@huawei.com>, <linuxarm@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <yangyicong@hisilicon.com>,
	<tangchengchang@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v4 2/7] KVM: arm64: Add documentation for KVM_EXIT_ARM_LDST64B
Date: Tue, 15 Jul 2025 16:13:51 +0800
Message-ID: <20250715081356.12442-3-yangyicong@huawei.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20250715081356.12442-1-yangyicong@huawei.com>
References: <20250715081356.12442-1-yangyicong@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemq200018.china.huawei.com (7.202.195.108)

From: Marc Zyngier <maz@kernel.org>

Add a bit of documentation for KVM_EXIT_ARM_LDST64B so that userspace
knows what to expect.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
---
 Documentation/virt/kvm/api.rst | 43 ++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 43ed57e048a8..dae6a31025e1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1300,12 +1300,13 @@ userspace, for example because of missing instruction syndrome decode
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
 
@@ -7002,12 +7003,14 @@ in send_page or recv a buffer to recv_page).
 
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
@@ -7041,6 +7044,32 @@ Note that although KVM_CAP_ARM_NISV_TO_USER will be reported if
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
2.24.0

