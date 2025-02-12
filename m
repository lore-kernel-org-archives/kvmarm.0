Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED5F17C2;
	Wed, 12 Feb 2025 00:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739320555; cv=none; b=VqNv7LMPQ1jbaXuV+wY6hqVVxdG9xYaLeKtSDG1JrF5ntEs6s/kioxsfRQgHiZgP7Yo33EzDvexaUx5vCmej/UmFGP3/rAPY2Fss3civMNu/cHQEmSD7Xa77uSggvoE5hofVigJS+kWAQs+wfLTDYO4/I6mNdr4qgp/QjhJiQMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739320555; c=relaxed/simple;
	bh=IHSRysAps1kPO4mQdQ2PWZCTN+vLfajuUKA+LRmoBSI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ghipWmAdRc+flzDW/e7H+ZsU29Epc+klgoqeepW/WjNde6YXUD2AsGjhb42lk9hJnryihU2wEMOzlQExjcaYS6j8sDEWEPtRiFV0rUeqaltZdkhmlLC2WWHFK3qNvJ9NFcuppnLekPREtksaAcV3lPsBGTV+5I5IfMjx1oquKEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlXpZhrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlXpZhrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F0DC4CEDD;
	Wed, 12 Feb 2025 00:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739320555;
	bh=IHSRysAps1kPO4mQdQ2PWZCTN+vLfajuUKA+LRmoBSI=;
	h=From:Date:Subject:To:Cc:From;
	b=KlXpZhrFsfYTIXkxGQMoJDS9aQlzLhEhxEMjiOtgFWUYbp/hCogvhYgR3sdx0uQW8
	 VBzdePQZ91zbrwdK9YqA2jWb2LUrVHwCXCKohOW14Va6nT2MNuhKDf/ODhJhgz0R5e
	 nNx9KL7apZwT7kC8o81sCaspUfbPYZ+RWV+7kzT/THy6mQT/0Qx4A5+Gm2AtaFBo9d
	 6aTDWCvQhJBl+ppj+y7FtBzUEfPdUR2xf5tNaN+4qgTdCaoVxT/Tx1ayk6ua0/B5bK
	 D/rFj8Iwew1OPSyybMDd/VQ7x2/vR1LB6pntbPqG+7o4bfDBXwvAn+Zxl3JzH/EkI+
	 b3vgq3+5vcJgA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Feb 2025 00:35:14 +0000
Subject: [PATCH] KVM: arm64: Use symbolic name for ID_AA64PFR0_EL1.RME in
 NV filtering
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250212-kvm-arm64-rme-symbol-v1-1-45d272c2108b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMHsq2cC/x3MTQ5AMBBA4avIrE3SNurvKmJBDSYUmSZCxN01l
 t/ivQcCCVOAOnlA6OTA+xah0wTc3G0TIQ/RYJSxymiNy+mxE59nKJ4w3L7fVzRlr21VWJc5BTE
 9hEa+/m3Tvu8H6VwuqmYAAAA=
X-Change-ID: 20250211-kvm-arm64-rme-symbol-28b15975c4c0
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=1261; i=broonie@kernel.org;
 h=from:subject:message-id; bh=IHSRysAps1kPO4mQdQ2PWZCTN+vLfajuUKA+LRmoBSI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBnq+zoaS29eV6IcWGgLA7ZN4ZG85DsktSsCIJo9npw
 tfvlehCJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ6vs6AAKCRAk1otyXVSH0Pq3B/
 95gsg9mQinUb1vZOecK757FVwxsEPeGs4rmG4pei3PQcT6F4w5onBwNZGOefJLTeB3TZocVLpPGVZQ
 XS2DKafrRA7M9wbMzS9zgBmfRtoiVnGL9LI4twFz7aohZ8fo1nnQGBlDjT/B43eNg2bvWyhHJu0Cy/
 OdeQKEZ3ArGXyNnmok9yD0gM8agSx0a4595OP37LHVt95Zoy+bQCkb7qbJis2pzwzOdJ+TnpwiBZgO
 DXLCcIRscv69uj/FJ9s2xocrbQB+D+CSFDGjhhN7pvATTkfFRP3EyqUUL5MohzPmItpuUCAf9scTXk
 BdqonTsruvL2Wg5pJETy4KRCqzi2MB
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

We generally use symbolic field names generated via NV_FTR() when we filter
the feature registers for nested virtualisation but when the current format
was adopted there was no symbolic definition for ID_AA64PFR0_EL1.RME so it
was instead specified using a raw GENMASK_ULL(). Since the field has now
been specified in sysreg we can replace this with the symbolic name in
order to make things marginally more legible.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 0c9387d2f50708565b5aac1fc0f86fefffd94ea1..bf6ec0f499ae207a5c056a0ec157368527a71fde 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -824,7 +824,7 @@ static void limit_nv_id_regs(struct kvm *kvm)
 
 	/* No AMU, MPAM, S-EL2, or RAS */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1);
-	val &= ~(GENMASK_ULL(55, 52)	|
+	val &= ~(NV_FTR(PFR0, RME)	|
 		 NV_FTR(PFR0, AMU)	|
 		 NV_FTR(PFR0, MPAM)	|
 		 NV_FTR(PFR0, SEL2)	|

---
base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
change-id: 20250211-kvm-arm64-rme-symbol-28b15975c4c0

Best regards,
-- 
Mark Brown <broonie@kernel.org>

