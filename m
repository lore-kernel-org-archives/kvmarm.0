Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB814734F7
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 12:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390721; cv=none; b=qWqOYnvVibgJySX07b6zSJuTMoX1F4SCNVedE1s98IrG+8Xkgok8QzFFjQANRfcuSOk6r3da/ZBI4MmyNfzzm1Ii1tebGNDA6opBGN7FMPX/ia7yI4Uj51xMlf/xBA/6p18MU6PMtNVCHeCwaVrvNvZ65vaRxmJrTyrywCynxgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390721; c=relaxed/simple;
	bh=cr2R0muZQJAbH/2zo0/ZBnfmxN5tuFxhYming9+hGcc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TCkZnWbXtJ8nqyvYhkcwYGmUJs6hU7NXi6dHIPJ9ID+MHxwOs7qDi5XFJyAYovUgAdg3t+RlTYT9+enkcEzBzwl5o2mSi8TzgLtQDC2JM8E1qhKGddLTpyX4mwGEU1DMuTmRV7cHw/B067h8pn3aRbo3sGhhHnYWwAnCbNInNTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JDRQ+09b; arc=none smtp.client-ip=91.218.175.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JDRQ+09b"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=cr2R0muZQJAbH/2zo0/ZBnfmxN5tuFxhYming9+hGcc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789390718; v=1; x=1789995518;
 b=JDRQ+09bRJUJGjJZsL1xZ6JLy+LM+HvBswowUWJwMIT/lQS5gbdSXgPewQs2AH9PqVxT5gRr
 3L/H44i0d58+6rQ8PzNAJ1pNRSjAFFOx1zS/vwxXbsIUk4yENJNm2VHOxCkWXvY4AnGXv9h+ap7
 zy/6ZzTPEqZr5m4MuQYbvKb4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 89023a9896b98e15;
	Mon, 14 Sep 2026 12:58:28 +0000
X-Mizu-Trace-ID: 89023a9896b98e15
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Report SMCCC_VERSION and SMCCC_ARCH_FEATURES as implemented
Date: Mon, 14 Sep 2026 13:58:26 +0100
Message-Id: <20260914125827.1645980-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM reports SMCCC v1.1 to guests, which makes SMCCC_VERSION and
SMCCC_ARCH_FEATURES mandatory, and DEN0028H 7.3.6 requires
SMCCC_ARCH_FEATURES to return SUCCESS for both function ids: "This
function must return SUCCESS when arch_func_id is the SMCCC_VERSION or
SMCCC_ARCH_FEATURES function id." With arch_func_id set to either, KVM's
guest handler returns NOT_SUPPORTED. Return SUCCESS.

A Linux guest is unaffected: it discovers SMCCC_VERSION through
PSCI_FEATURES, and issues SMCCC_ARCH_FEATURES only with arch_func_id set
to ARCH_SOC_ID, the ARCH_WORKAROUND_* ids or HV_PV_TIME_FEATURES.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hypercalls.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b11b8821c9fbc..66f16bf9a8ea7 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -293,6 +293,10 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
 		feature = smccc_get_arg1(vcpu);
 		switch (feature) {
+		case ARM_SMCCC_VERSION_FUNC_ID:
+		case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+			val[0] = SMCCC_RET_SUCCESS;
+			break;
 		case ARM_SMCCC_ARCH_WORKAROUND_1:
 			switch (arm64_get_spectre_v2_state()) {
 			case SPECTRE_VULNERABLE:
-- 
2.39.5

