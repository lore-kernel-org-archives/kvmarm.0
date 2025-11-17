Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8C831354C
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419414; cv=none; b=jubWd8lr4FaDPqfs9d5MseZXyssutDQMyk9GqHJDshPUiH1fnqC6P+wc0EkFxWth4jf2t0wYFFGYI09aZTO5LTqPkztqz2qFOnr9kcTUm0taHgPLLJQTaU0jtj8fO/R0lMJYboLxTZCl6IndPJ/ZB/Qm/8nu2M+Zd2yEvMiPpAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419414; c=relaxed/simple;
	bh=JO02slPGidSPL2l+uM5IRDu1CQ7/VEtI+TegWDNXPaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1tqBUN62sDXvF4FtEvyScY6r9nknjqqrJUOm5UBDxJBe/XO3/lmObvJhXEmxtgHbXe6X1/tIuQ5wLK99jwLoHSWMILsUNKxoy+j1RAgMTEpGBZ8iILQB8MvnJOPH45Ay0f8INEao4Z9aGRt21J2rvlQDcpIWZX9XAHTz4XX6TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9KfpPov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9KfpPov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A42C4CEF1;
	Mon, 17 Nov 2025 22:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419413;
	bh=JO02slPGidSPL2l+uM5IRDu1CQ7/VEtI+TegWDNXPaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9KfpPovRl5pKJOqKDkMT+dizWfONJspfa5yglw//Ocy57mxQTsifx5HNFkk8ffMv
	 VRiF3vyx68HUd3YKdA37ZYGQn4Xqexqfc+sGuNGZUVpAE60cUaRMgCKT6LZVkll7EQ
	 bCGZmHBeuwlDXYDS1lztwGNuiiPncBtczuiK8ffe7rduDJTdudKSVqfD8K61GGPuoV
	 s3qPvpoQM4jfUCF5AtVajr0pBhJehYpmrCyZE7DTR5BjhJpVUP9lJwliJYKKw6UH1P
	 hdKC1iVlZ1oS8Opmo8WplelTAeQvZa8TaNCEu/3ENX5Aq5ynF16G0r3/7+uzHf8181
	 JoEM2M85PbXBw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 11/14] KVM: arm64: Implement HW access flag management in stage-1 SW PTW
Date: Mon, 17 Nov 2025 14:43:22 -0800
Message-ID: <20251117224325.2431848-12-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Atomically update the Access flag at stage-1 when the guest has
configured the MMU to do so. Make the implementation choice (and liberal
interpretation of speculation) that any access type updates the Access
flag, including AT and CMO instructions.

Restart the entire walk by returning to the exception-generating
instruction in the case of a failed Access flag update.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/at.c                 | 33 +++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 6dbc2908aed9..905c658057a4 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -353,6 +353,7 @@ struct s1_walk_info {
 	bool	     		be;
 	bool	     		s2;
 	bool			pa52bit;
+	bool			ha;
 };
 
 struct s1_walk_result {
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index eece654b02a1..7c13e69a7d9a 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -346,6 +346,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
 
+	wi->ha = tcr & TCR_HA;
+
 	return 0;
 
 addrsz:
@@ -380,10 +382,24 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
 	return 0;
 }
 
+static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
+			    struct s1_walk_info *wi)
+{
+	if (wi->be) {
+		old = cpu_to_be64(old);
+		new = cpu_to_be64(new);
+	} else {
+		old = cpu_to_le64(old);
+		new = cpu_to_le64(new);
+	}
+
+	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
+}
+
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		   struct s1_walk_result *wr, u64 va)
 {
-	u64 va_top, va_bottom, baddr, desc;
+	u64 va_top, va_bottom, baddr, desc, new_desc, ipa;
 	int level, stride, ret;
 
 	level = wi->sl;
@@ -393,7 +409,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	va_top = get_ia_size(wi) - 1;
 
 	while (1) {
-		u64 index, ipa;
+		u64 index;
 
 		va_bottom = (3 - level) * stride + wi->pgshift;
 		index = (va & GENMASK_ULL(va_top, va_bottom)) >> (va_bottom - 3);
@@ -438,6 +454,8 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			return ret;
 		}
 
+		new_desc = desc;
+
 		/* Invalid descriptor */
 		if (!(desc & BIT(0)))
 			goto transfault;
@@ -490,6 +508,17 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
 		goto addrsz;
 
+	if (wi->ha)
+		new_desc |= PTE_AF;
+
+	if (new_desc != desc) {
+		ret = kvm_swap_s1_desc(vcpu, ipa, desc, new_desc, wi);
+		if (ret)
+			return ret;
+
+		desc = new_desc;
+	}
+
 	if (!(desc & PTE_AF)) {
 		fail_s1_walk(wr, ESR_ELx_FSC_ACCESS_L(level), false);
 		return -EACCES;
-- 
2.47.3

