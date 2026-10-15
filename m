Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5455282F0E
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078262; cv=none; b=Q3KrXIs2AN225eA/tGNNiXEKzodWHgZys0JsTI2vOLz4b03y5zOpY0VW7yb6614l4S8b0P+dXWQMk6pE+IGiEc/ZGSOW1Ks+WQ2BT8jCu+MYfcG0ZuDU7rj7b+VfQMLGuEF8tdmzMuWngr5GiGXorNqG2gC8PUPIjEV3haxBpHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078262; c=relaxed/simple;
	bh=2yWri+1wXQrRPEy5ZKZnqhA5e1wWBSIZ6Uevifgk4uQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DAWR5LVo5bEJr+pQYMYu2LXiKHVFytii/zIumZaL2lW+1YFrdw2iGnqo3AtJyKtPfkPiCP21vRko0QDXPvenS3cwJV9NmqK02PLEVH5cgvsE209+TsCWx/zaIVf4UIBUSGt87kGytQ7+9q2tF90TAT2WlqVYFhC3zhIasGE4xmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ezTL8yAq; arc=none smtp.client-ip=91.218.175.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ezTL8yAq"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=2yWri+1wXQrRPEy5ZKZnqhA5e1wWBSIZ6Uevifgk4uQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792078250; v=1; x=1792683050;
 b=ezTL8yAqZ6Nu9swiGexNA6YIyNlqyK3P1RPf5RdL120JbiGGLFqE04vbYwUuWhxSo6NJLZ/0
 QmH36P5UgE/NNWTDaN6u2ToZ781j+17E1g72wGqeOk4dEAFZOUZcdIgCzmbGOzb9YbyR+QUF7ci
 gskpT4pXO7ldCbXK/9FuNVZU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e3960b5cc32e181e;
	Thu, 15 Oct 2026 15:30:42 +0000
X-Mizu-Trace-ID: e3960b5cc32e181e
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
Subject: [PATCH] KVM: arm64: Only enable S1PIE and S1POE for a guest with TCR2 and ATS1A
Date: Thu, 15 Oct 2026 16:30:41 +0100
Message-Id: <20261015153041.3770032-1-fuad.tabba@linux.dev>
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

As per the architecture, S1PIE and S1POE imply TCR2 and ATS1A. Only
enable them for a guest that has both. A guest that has S1PIE or S1POE
without TCR2 or ATS1A still sees the feature in its ID registers, but
its accesses to that feature's registers UNDEF.

Fixes: 70ed7238297fb ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Fixes: d4a89e5aee23e ("KVM: arm64: Expose S1PIE to guests")
Reported-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20260930-arm64-gcs-v21-2-3556644cd927@kernel.org
Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/86fqyn2che.wl-maz@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
I'm sending this on its own because it affects the host on nVHE and in
pKVM, so that it can go to kvmarm/fixes and stable rather than land
with the GCS series. It's the data-driven fix Marc asked for on Mark's
v21 02/15 [1].

Following Mark's point on Lorenzo's draft [2], only feat_s1pie() and
feat_s1poe() test TCR2 and ATS1A, so kvm_has_s1pie() and the world
switch are unchanged. I've left the guest's ID registers alone, since
updating them is the larger rework Mark described.

I've got a reproducer showing the host's PIR_EL1 overwritten on nVHE
and in pKVM, and can share it privately.

Based on Linux 7.3-rc3 (fd73f4a665989; also applies to kvmarm/fixes
71cc2c67fb8f8).

[1] https://lore.kernel.org/r/86fqyn2che.wl-maz@kernel.org
[2] https://lore.kernel.org/r/ae24e80c-1b34-4827-9c93-e80b987e9cd7@sirena.org.uk

 arch/arm64/kvm/config.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1053676551aff..5e5277c721d52 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -280,6 +280,21 @@ static bool feat_anerr(struct kvm *kvm)
 		kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SNERR, FEAT_ANERR));
 }
 
+/* S1PIE and S1POE imply TCR2 and ATS1A, but userspace can set them independently */
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
+		kvm_has_feat(kvm, FEAT_ATS1A));
+}
+
 static bool feat_sme_smps(struct kvm *kvm)
 {
 	/*
@@ -393,10 +408,10 @@ static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
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
@@ -474,10 +489,10 @@ static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
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

base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

