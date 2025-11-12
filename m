Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F583538AE
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972452; cv=none; b=YNkb26gn18P7VNnHr995YLDMvqdRyfEfrXTXSl1HaSdsHOeLljoyBCByKvpk/43He2cMt9nSm5xPo3r1i+wTeD4Bvit7QjxFGeleVuDldt8VB+CFEBo6XuINtpSKNsURukMcquij/qL1EH5cHuiXBr+c4WwFJjLiH5D9xyey0XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972452; c=relaxed/simple;
	bh=pqSKo8er0SoMTFLT6zNG7jCIWrfz1ZRG0V9yP9E1WoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3zUyegs6sB7X66lkftXY1W6CV4N8mHN0+ghkQDv4JP07Hf5AhxMKsTY4rBejfFQjuCK76tViZ2HIT8EJ+WjTad6sUO4tnSdyYCSI2Iq0KOmhMRxUyjfgXpADH9NEb3aOqbICsxqIkVSyOi3+6G9bACyRkozSH21yhBPsyXDLig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMZNpIb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMZNpIb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F122C19421;
	Wed, 12 Nov 2025 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972451;
	bh=pqSKo8er0SoMTFLT6zNG7jCIWrfz1ZRG0V9yP9E1WoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMZNpIb4BVwjW2t3OQxXnUfCy+LC8oYLor1xqin3nbZ46LglBcD+Fvxw36Gaw3nRU
	 zAkP1yPyMWuv+3fPTaoBeHdIgJjKqsLW4nHGGy8k/k4GyZ3WNrnsQOjvFEYuaafKoo
	 PeGIGRFPRKhan03Mm+JQAuocgovMM6k1kZRTfUMvfEJ+0LzakvRBJclLPW/RD/W/H2
	 YOqQVlS1w8F8MkqCYaYhncWKdRj7yE11RKeuNF4Xlu8XU4KgkPH+F/xRyM90rfYD3H
	 z2Uc20SQCA81xJjnPjXtIkp55GsaNZEy2Sj44GGdTvachQyOJMBn6/2UN3GhpPRajV
	 6vKLNaeYqG2ZQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 06/12] KVM: arm64: Call helper for reading descriptors directly
Date: Wed, 12 Nov 2025 10:34:00 -0800
Message-ID: <20251112183406.2118981-7-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112183406.2118981-1-oupton@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Going through a function pointer doesn't serve much purpose when there's
only one implementation.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 08839a320a45..cf4b24e04a1a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,7 +124,6 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 }
 
 struct s2_walk_info {
-	int	     (*read_desc)(phys_addr_t pa, u64 *desc, void *data);
 	void	     *data;
 	u64	     baddr;
 	unsigned int max_oa_bits;
@@ -199,6 +198,15 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
 	return 0;
 }
 
+static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+	u64 val;
+	int r;
+
+	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
+}
+
 /*
  * This is essentially a C-version of the pseudo code from the ARM ARM
  * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
@@ -257,7 +265,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 			>> (addr_bottom - 3);
 
 		paddr = base_addr | index;
-		ret = wi->read_desc(paddr, &desc, wi->data);
+		ret = read_guest_s2_desc(paddr, &desc, wi->data);
 		if (ret < 0)
 			return ret;
 
@@ -325,13 +333,6 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 	return 0;
 }
 
-static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
-{
-	struct kvm_vcpu *vcpu = data;
-
-	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
-}
-
 static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 {
 	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
@@ -364,7 +365,6 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	if (!vcpu_has_nv(vcpu))
 		return 0;
 
-	wi.read_desc = read_guest_s2_desc;
 	wi.data = vcpu;
 	wi.baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 
-- 
2.47.3

