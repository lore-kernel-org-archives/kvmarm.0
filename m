Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26347329C7D
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 20:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904953; cv=none; b=pRuRhCBCkv21kPXmGzod2oYCPYwkZyti12HqG/5AyMx8JCxfqCv+Q+N33hsv7IYSf/1Frf5prxC9C3j4HW3K6fD13IYTr27HbpfO5AMPuFb3LC95CJNSdXnEuMK8qWaC7Ha1iXgpxpwuRS4cTeAhaLLPfwm9oL4HvJzaoAp5/So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904953; c=relaxed/simple;
	bh=Q8WYExuLOEp/bupQY9UWQNgtNdSfmpYPB9TNJ4b3CsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p1RglstKc1iy0d2HoHZ1227c4BRhw2CZpMKZM9AU9WSagUu4yV12GLHIqmVMWqidjeFNByy9/ujmWJ6teqDsSM5l0BmFVXUBeo2Bzj/uF7FY+xmAKB9M1VhdxXJw254E8NACszdP2CY4TBt2TEmoFVoubOADaU6Bi9NFUZalfFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7dBHZmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7dBHZmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA81C116C6;
	Thu,  8 Jan 2026 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767904952;
	bh=Q8WYExuLOEp/bupQY9UWQNgtNdSfmpYPB9TNJ4b3CsU=;
	h=From:To:Cc:Subject:Date:From;
	b=i7dBHZmhaOeeKOxU12m1Dk059TO/5Q6LC9lH75xKBQhF9lvYWK5CtHo5uHIFpeU7T
	 U1+V+bzxhIbBnAmGoUxRjd0akZSvsponMb8KoNkUBZ730SkZB1Shoi+6hfwrgNrchE
	 WIgTFjbfchSeN/lvEHWmV31rpWKlk6ds5ACvYH/mgI+zAAbr57ISM2WpsCPt5SW8gq
	 G88myd10E//DlNJGxo4jy9OLD5QuBpYfqO+zizgG8ymP0MY2J4yhstRDL/IKWh3dzZ
	 b+XPRtMG3rg6IJBErHLij0XfMGiMjiJlBwgCyzDH4cY2u9O6+QTyrAIPXbQe4Baa2G
	 sTHO/n3Aa6fpg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH] KVM: arm64: nv: Respect stage-2 write permssion when setting stage-1 AF
Date: Thu,  8 Jan 2026 12:42:30 -0800
Message-ID: <20260108204230.677172-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Naturally, updating the Access Flag in a stage-1 descriptor requires
write permission at stage-2, although this isn't actually enforced in
KVM's software PTW.

Generate a stage-2 permission fault if the stage-1 walk attempts to
update the descriptor and its corresponding stage-2 translation lacks
write permission.

Fixes: bff8aa213dee ("KVM: arm64: Implement HW access flag management in stage-1 SW PTW")
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 53bf70126f81..808d26bed182 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -403,6 +403,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		   struct s1_walk_result *wr, u64 va)
 {
 	u64 va_top, va_bottom, baddr, desc, new_desc, ipa;
+	struct kvm_s2_trans s2_trans = {};
 	int level, stride, ret;
 
 	level = wi->sl;
@@ -420,8 +421,6 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		ipa = baddr | index;
 
 		if (wi->s2) {
-			struct kvm_s2_trans s2_trans = {};
-
 			ret = kvm_walk_nested_s2(vcpu, ipa, &s2_trans);
 			if (ret) {
 				fail_s1_walk(wr,
@@ -515,6 +514,11 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		new_desc |= PTE_AF;
 
 	if (new_desc != desc) {
+		if (wi->s2 && !kvm_s2_trans_writable(&s2_trans)) {
+			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level), true);
+			return -EPERM;
+		}
+
 		ret = kvm_swap_s1_desc(vcpu, ipa, desc, new_desc, wi);
 		if (ret)
 			return ret;

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.47.3

