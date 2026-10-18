Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B73CAE9B
	for <kvmarm@lists.linux.dev>; Sun, 18 Oct 2026 08:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792310965; cv=none; b=p7+X8BRJkmc8Ov3RWo60aGRVkHCfXvcVjJa+fQ202O8Q+I4Bv+uFVrIQQFOrQQ9uMlN6b8oVF2mkcGfOSSZ/PWewfmnax73xdRgb+CeM7cQeI7mTmjKWS8SFuZBsJgvdImiwbZSIlHWmM8XB+oTyqDmygfN2tBUskRXQHCB3m0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792310965; c=relaxed/simple;
	bh=qNYqHsAHI3D2aPJmGx4BXdS7p6PSMN3a0jhnzLNwxsI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Shi/GY8oESjZJBXyCAHXd4H6A/FcRnvw2eSsKQs24VKPW4QbguolrYYnAQwrkTylYVSljd4LbvL25g4kUaXY/XjYQJn6xoQbDu9umjPVTeLEh7cVx5gX/FmEXkRFQM/38pS22LeMBWrLpr2g0Af/TpYn4FyrBvZZWXh3igP0L8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wz7v8pKp; arc=none smtp.client-ip=95.215.58.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wz7v8pKp"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qNYqHsAHI3D2aPJmGx4BXdS7p6PSMN3a0jhnzLNwxsI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792310961; v=1; x=1792915761;
 b=Wz7v8pKpEBk8280l784bBkmCcmwNp0OS1yhecXnhfm6LfojnpQux+qxHezKBt0P2uLG+QCJ9
 XdfVPc327mUhnajsz+VOcWHHFolAQPVMkTSQa2s/bGNGdXYI2QH5R83iB3fBvMKyLXPIn3qB+qg
 xaUJO7cUskQFjk9gfTjFgfR4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 82dde8ee2cd03a9b;
	Sun, 18 Oct 2026 08:09:21 +0000
X-Mizu-Trace-ID: 82dde8ee2cd03a9b
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Only enable S1PIE and S1POE with the features they imply
Date: Sun, 18 Oct 2026 09:09:20 +0100
Message-Id: <20261018080921.3942517-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The world switch skips PIR_EL1, PIRE0_EL1 and POR_EL1 for a guest
without TCR2, but KVM doesn't trap them for a guest with S1PIE or
S1POE. Userspace can hide TCR2 while leaving either visible, and such a
guest then accesses registers that are neither trapped nor switched.

Under VHE, that leaks values between guests. POR_EL1, which the host
kernel doesn't use, leaks between guests in every mode. On nVHE and
hVHE, pKVM included, the host's own EL1 registers are saved and restored
according to the running guest's features, so the host kernel resumes
with its stage-1 permissions taken from the guest's PIR_EL1 and
PIRE0_EL1.

As per the architecture, S1PIE and S1POE imply TCR2 and ATS1A, and
S1POE also implies HPDS. Only enable each for a guest that has the
features it implies. A guest that has S1PIE or S1POE without them still
sees the feature in its ID registers, but its accesses to that
feature's registers UNDEF.

Fixes: 70ed7238297fb ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Fixes: d4a89e5aee23e ("KVM: arm64: Expose S1PIE to guests")
Reported-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20260930-arm64-gcs-v21-2-3556644cd927@kernel.org
Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/86fqyn2che.wl-maz@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
Changes in v2:
- Also require FEAT_HPDS for S1POE (Marc)
- Link to v1: https://lore.kernel.org/r/20261015153041.3770032-1-fuad.tabba@linux.dev

Based on Linux 7.3-rc3 (fd73f4a665989).

 arch/arm64/kvm/config.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1053676551aff..6d2650427c5fc 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -205,6 +205,7 @@ struct reg_feat_map_desc {
 #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
 #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
 #define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
+#define FEAT_HPDS		ID_AA64MMFR1_EL1, HPDS, IMP
 #define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
 #define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
 #define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
@@ -280,6 +281,25 @@ static bool feat_anerr(struct kvm *kvm)
 		kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SNERR, FEAT_ANERR));
 }
 
+/*
+ * S1PIE and S1POE imply TCR2 and ATS1A, and S1POE also implies HPDS, but
+ * userspace can set them independently.
+ */
+static bool feat_s1pie(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, FEAT_S1PIE) &&
+		kvm_has_feat(kvm, FEAT_TCR2) &&
+		kvm_has_feat(kvm, FEAT_ATS1A));
+}
+
+static bool feat_s1poe(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, FEAT_S1POE) &&
+		kvm_has_feat(kvm, FEAT_TCR2) &&
+		kvm_has_feat(kvm, FEAT_ATS1A) &&
+		kvm_has_feat(kvm, FEAT_HPDS));
+}
+
 static bool feat_sme_smps(struct kvm *kvm)
 {
 	/*
@@ -393,10 +413,10 @@ static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
 	NEEDS_FEAT(HFGRTR_EL2_nS2POR_EL1, FEAT_S2POE),
 	NEEDS_FEAT(HFGRTR_EL2_nPOR_EL1		|
 		   HFGRTR_EL2_nPOR_EL0,
-		   FEAT_S1POE),
+		   feat_s1poe),
 	NEEDS_FEAT(HFGRTR_EL2_nPIR_EL1		|
 		   HFGRTR_EL2_nPIRE0_EL1,
-		   FEAT_S1PIE),
+		   feat_s1pie),
 	NEEDS_FEAT(HFGRTR_EL2_nRCWMASK_EL1, FEAT_THE),
 	NEEDS_FEAT(HFGRTR_EL2_nTPIDR2_EL0	|
 		   HFGRTR_EL2_nSMPRI_EL1,
@@ -474,10 +494,10 @@ static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
 	NEEDS_FEAT(HFGWTR_EL2_nS2POR_EL1, FEAT_S2POE),
 	NEEDS_FEAT(HFGWTR_EL2_nPOR_EL1		|
 		   HFGWTR_EL2_nPOR_EL0,
-		   FEAT_S1POE),
+		   feat_s1poe),
 	NEEDS_FEAT(HFGWTR_EL2_nPIR_EL1		|
 		   HFGWTR_EL2_nPIRE0_EL1,
-		   FEAT_S1PIE),
+		   feat_s1pie),
 	NEEDS_FEAT(HFGWTR_EL2_nRCWMASK_EL1, FEAT_THE),
 	NEEDS_FEAT(HFGWTR_EL2_nTPIDR2_EL0	|
 		   HFGWTR_EL2_nSMPRI_EL1,
-- 
2.39.5

