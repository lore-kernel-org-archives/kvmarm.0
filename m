Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BF214AD20
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010921; cv=none; b=qDHEs9jeBl3IKkvrQuPMxiXcM/MaioGEpdF6uK9yyBTkRX+U8WEfuO2sFtQaDDy2iT8qVQwL7MgChYbZIwuIW+qlOqxX0jzWfr2Hvqcl8RFail3LwZC+nsp3dI1nfc2mHF+PypBU7b5DFya7XsCldfURS2VusUfr6eWPs/8oV2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010921; c=relaxed/simple;
	bh=ePrVL7ImOMdiM270PdDY9pXUIsY/eSJ644Bc65UfvwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0TVvitLOa3Ub5NeNZHZ2RCRbYUjRqEqxTd1RQKeRrC7J9bjY9nv0KDqYVxjgh7tityxDrrc8zcRBgW9sMbvybavaTJ3YW5QWaHPbVpDrsrocWlxfS1NKXHP4MBdABDvZ/Wct7DM2MzL8hI9Q2tQFTBTYw2FxutRyhl1rbiUMWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6QHJSoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6QHJSoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029E1C16AAE;
	Mon, 24 Nov 2025 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010921;
	bh=ePrVL7ImOMdiM270PdDY9pXUIsY/eSJ644Bc65UfvwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6QHJSoRR5ASodvWjXVxhGE1Ev12QQH3eOKT+YqFlxeK77QQTAQIEqJ2cLfkIxdLB
	 ommbK+aDz5ub0f8eEFXoJSF+PKAgot+uBucEaCI7q2+XyrKW0k2adUf4MnMR6/iyM5
	 UaZpvrnh6PKf6GyXeSqkxQVGroBSXAC7ArRdEx832Dbic2cPxjAkwWdQjMIUhvvHfP
	 q7Hxb67PMxaBM5slZzUsDHLocJA8Az5AsHXeJxHhAe6jkmRdz50z0C61nYQGC3DjJp
	 s8ylOxD/ZNmQmAGQw0RCnpDoxRigABrvWqtlmYAtBZytJtefha3nETtucFI3zvZpJa
	 FMlVBpbIm+u+g==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 07/15] KVM: arm64: nv: Stop passing vCPU through void ptr in S2 PTW
Date: Mon, 24 Nov 2025 11:01:49 -0800
Message-ID: <20251124190158.177318-8-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stage-2 table walker passes down the vCPU as a void pointer. That
might've made sense if the walker was generic although at this point it
is clear this will only ever be used in the context of a vCPU.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index e4928a6a3672..94eff8307aad 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,7 +124,6 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 }
 
 struct s2_walk_info {
-	void	     *data;
 	u64	     baddr;
 	unsigned int max_oa_bits;
 	unsigned int pgshift;
@@ -198,10 +197,8 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
 	return 0;
 }
 
-static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
+static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc)
 {
-	struct kvm_vcpu *vcpu = data;
-
 	return kvm_read_guest(vcpu->kvm, pa, desc, sizeof(*desc));
 }
 
@@ -212,7 +209,7 @@ static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, void *data)
  *
  * Must be called with the kvm->srcu read lock held
  */
-static int walk_nested_s2_pgd(phys_addr_t ipa,
+static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
 {
 	int first_block_level, level, stride, input_size, base_lower_bound;
@@ -263,7 +260,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 			>> (addr_bottom - 3);
 
 		paddr = base_addr | index;
-		ret = read_guest_s2_desc(paddr, &desc, wi->data);
+		ret = read_guest_s2_desc(vcpu, paddr, &desc);
 		if (ret < 0)
 			return ret;
 
@@ -363,14 +360,13 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	if (!vcpu_has_nv(vcpu))
 		return 0;
 
-	wi.data = vcpu;
 	wi.baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 
 	vtcr_to_walk_info(vtcr, &wi);
 
 	wi.be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
 
-	ret = walk_nested_s2_pgd(gipa, &wi, result);
+	ret = walk_nested_s2_pgd(vcpu, gipa, &wi, result);
 	if (ret)
 		result->esr |= (kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC);
 
-- 
2.47.3

