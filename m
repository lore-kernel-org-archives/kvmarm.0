Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B009CA6B
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 00:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776125043; cv=none; b=T0itteAi04p+co/QoLzy96irX3yKX4xCNtuSU1IZr1ANvxgq6KnJZq63XJNIPVitmjCLVwD7+3LN2g7aLt1Ln4Wx8MQK6VDy5jeA2r0l+vGunFkWkCaFneWn90uRwXajwfHAu3iCfWZr0gGsHvd3iGs8TfBlr7bfcc6bnL8XcJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776125043; c=relaxed/simple;
	bh=sNkeD3oItSsUYpcwRXopPrAGHGTV7rUHC2RBworXx6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ke5ebiNbwsuM8mgaoNBRFsDj7V0AELZl5UqAtmugBNNEoZkJ2+zBzYq+yrD09s1ixMktAWgJP+LZfNYQeibJH8p+deVI5Xc+NBPf+JMMRhKPnFwoIUEfIr9lEUFUwkkxrKR0yBIiBE1ooLOsCQz0fBieV4JTKb5iRfQ2uFHLp+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qzTpUOMt; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qzTpUOMt"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02A3E4E28;
	Mon, 13 Apr 2026 17:03:56 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07E4E3F7B4;
	Mon, 13 Apr 2026 17:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776125041; bh=sNkeD3oItSsUYpcwRXopPrAGHGTV7rUHC2RBworXx6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzTpUOMtt4Daa1iCNSkoG6aW71GBI52JmOBJuML2B5kaxm32WfnMgBniZyQU6tfLy
	 wGJiXEDWZDjfG3XFWBAbi3+oo7PfuScZCQrVlsKy+nb33CUJI2CryYbapSVVRTBccG
	 KKzE9uO+KkTyzyLE+t3FvSci7YdovJoyMiHr4MXI=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 1/4] KVM: arm64: nv: Rename vtcr_to_walk_info() to setup_s2_walk()
Date: Tue, 14 Apr 2026 01:03:31 +0100
Message-ID: <20260414000334.3947257-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414000334.3947257-1-weilin.chang@arm.com>
References: <20260414000334.3947257-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This rename aligns the stage-2 walker better with the stage-1 walker.
Also set up other non-VTCR walk info in the function.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/nested.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2c43097248b2..f20402d0d7e5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -378,9 +378,12 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	return 0;
 }
 
-static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
+static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
 {
-	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
+	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+
+	wi->baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	wi->t0sz = vtcr & VTCR_EL2_T0SZ_MASK;
 
 	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
 	case VTCR_EL2_TG0_4K:
@@ -398,12 +401,12 @@ static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
 
 	wi->ha = vtcr & VTCR_EL2_HA;
+	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 		       struct kvm_s2_trans *result)
 {
-	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
 	struct s2_walk_info wi;
 	int ret;
 
@@ -412,11 +415,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	if (!vcpu_has_nv(vcpu))
 		return 0;
 
-	wi.baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-
-	vtcr_to_walk_info(vtcr, &wi);
-
-	wi.be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
+	setup_s2_walk(vcpu, &wi);
 
 	ret = walk_nested_s2_pgd(vcpu, gipa, &wi, result);
 	if (ret)
-- 
2.43.0

