Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CB627A446
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758648622; cv=none; b=RD5e+Hxva36T9pDH2LaYl6rkzbx9hSnmLBovyiIRLWDqLt/9Dq73BMT1y3mHgY8+m2Bo7IwdPjbEcKmPMZ0XXJ1iRAnsMx3+f94KUDLUY485vAA4D8fTrgO2BdP/xZsLgNc/tBj9O7mmeLFbRSC7j1/zujLkbJroiayW431QdRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758648622; c=relaxed/simple;
	bh=cDuxXIEeELS4RlF8N85CgtustN1sXRSvqtd8M+7Ba98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CdccAAVXHzdX+A3HrWQvqfVPm34yOJaflfvw1b2CeA80T7i0D4iBRCWFUnGZlcmHRfoPgVwbY8Uq25F+9hNBVjmGvuPccCZaZSkTqbg4zoOHHaegkkW2yM5FzBbPpjPq+72bYtXm6VOfyKE15BOft10AOi+fgIifMyLCo86kqXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DB6WDsgt; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DB6WDsgt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758648616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GquTSbszNKfAV4XX9XT5XFWqICROJKhCKUbSqsrqCn4=;
	b=DB6WDsgth5FiQZw3z+cwNoxwx4dYTcyuwNCBINwkZUGB4AuScicqTv7mo1df5WBkkBWqLu
	6+7rK4LTwMnsSTBxmIq1HBfGrq3hrWgMWqww7IyH9zYFxPackF4EwROhx2Lbo2LA2Q44Qm
	hjYnJYOT8KFHqX6Iz0v7aQvpKMrpxFA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: selftests: Cope with arch silliness in EL2 selftest
Date: Tue, 23 Sep 2025 10:30:06 -0700
Message-ID: <20250923173006.467455-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Implementations without FEAT_FGT aren't required to trap the entire ID
register space when HCR_EL2.TID3 is set. This is a terrible idea, as the
hypervisor may need to advertise the absence of a feature to the VM
using a negative value in a signed field, FEAT_E2H0 being a great
example of this.

Cope with uncooperative implementations in the EL2 selftest by accepting
a zero value when FEAT_FGT is absent and otherwise only tolerating the
expected nonzero value.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Applies on top of the EL2 selftests series I shared earlier.

https://lore.kernel.org/kvmarm/20250917212044.294760-1-oliver.upton@linux.dev/#t

 tools/testing/selftests/kvm/arm64/hello_el2.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/hello_el2.c b/tools/testing/selftests/kvm/arm64/hello_el2.c
index 3c1f44e43f65..ff77c0ba4bb1 100644
--- a/tools/testing/selftests/kvm/arm64/hello_el2.c
+++ b/tools/testing/selftests/kvm/arm64/hello_el2.c
@@ -13,15 +13,28 @@
 
 static void guest_code(void)
 {
+	u64 mmfr0 = read_sysreg_s(SYS_ID_AA64MMFR0_EL1);
 	u64 mmfr1 = read_sysreg_s(SYS_ID_AA64MMFR1_EL1);
 	u64 mmfr4 = read_sysreg_s(SYS_ID_AA64MMFR4_EL1);
+	u8 e2h0 = SYS_FIELD_GET(ID_AA64MMFR4_EL1, E2H0, mmfr4);
 
 	GUEST_ASSERT_EQ(get_current_el(), 2);
 	GUEST_ASSERT(read_sysreg(hcr_el2) & HCR_EL2_E2H);
 	GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64MMFR1_EL1, VH, mmfr1),
 			ID_AA64MMFR1_EL1_VH_IMP);
-	GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64MMFR4_EL1, E2H0, mmfr4),
-			ID_AA64MMFR4_EL1_E2H0_NI_NV1);
+
+	/*
+	 * Traps of the complete ID register space are IMPDEF without FEAT_FGT,
+	 * which is really annoying to deal with in KVM describing E2H as RES1.
+	 *
+	 * If the implementation doesn't honor the trap then expect the register
+	 * to return all zeros.
+	 */
+	if (e2h0 == ID_AA64MMFR4_EL1_E2H0_IMP)
+		GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64MMFR0_EL1, FGT, mmfr0),
+				ID_AA64MMFR0_EL1_FGT_NI);
+	else
+		GUEST_ASSERT_EQ(e2h0, ID_AA64MMFR4_EL1_E2H0_NI_NV1);
 
 	GUEST_DONE();
 }
-- 
2.47.3

