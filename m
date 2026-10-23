Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789042;
	b=kkVYXY7Z1Ehf33gZOGNma5VKdIs2QYu5X5lhj4DgI1YAG/1dkJ0a8p2p2GsQRPgVi1AW
	 YHqJ27ZwXczRPR2XyqkxjdBeCIM232hmpvHqUUUncDRVH3sC8YJiOMA12djNDddyWTVoK
	 rxwZbsF97Ho4dBOogfQ4/oRqktg/OAilFtyO6X+azkbb0UwgQgAy9djfvaoh8uhnhvfqP
	 UltU9FObiKk+cRY0D6LSGEaP3K9iBIBz9QkmtdoxkUF9f/5GecZRlH9u0oSzLazBfFlMw
	 rdOPJ+6jvnbyLeWyiTIRfv3z3epEoBdVsGGjfJS5C8djrDSAQrpSG3G9pyGJYQyGpFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hmH0ZH2wNvDIdAKdXV/THoRuWtSJQnHWL34seNIkoRM=;
	b=SwnkXZwnGB8EwYjk+xJxkLr3VI2/U3/SQLhUv31fCjZMro5Km+BtGO4j/zpH+NXKyo81
	 9XbtGD9AKl15syNIiovASiH8kI9vRNKSXx3TnuZRBIXRGR5gkDsl1X/HmsbcLNLVlaTMb
	 yJF9aOgHeNcNuNHaBjylbJolmwiZHe1o+EKrCYq+Vm0APvthqtdXSdGP+ktqIEACWxK+F
	 MpqsRlohdCjN3fP8gbBKlLF/DCViZP/nn1S562Dawgj3vM2mR8n1I01y7kv+W1FyaBWDV
	 L+PGiQBzKRbG7ipI0wO5I15Q9EWeA9YD0Z8Xy1+Mz6E9rWYJTZvwNC3dJG2yCglyshA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MqzfLbwf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F242D606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MqzfLbwf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB821F01825;
	Fri, 23 Oct 2026 20:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789041;
	bh=hmH0ZH2wNvDIdAKdXV/THoRuWtSJQnHWL34seNIkoRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqzfLbwf7kPKabxH/BZCBRuBAbjpAM5bThtem8WqMYCRzIGPuqhH5X7gEIDQ0X4OK
	 5o/goq655fGzNZoVsUVcA0Cz0tU3EaUBU7OuH5vI9Uik/eDOtr7WlzHob5YMeQSVx2
	 0OZFNLgPf9YFuIu5LytIZd25pauAZYos8e/4O4LPWg1y2aKHrDtp+RMOV3UDEvtulQ
	 ZUVw6L3myeQ75a6M7cc3LxwJFOWQI+P7eIVOzFDTYnwkTFO1vtOmQbFN3VOl4QNCXM
	 RsUk+Xiy+cBKQKHIcmrO5j/MgNuOG9tbbLMFHQRPG5wXnhrcyUcScnOVHaleAZ1yUv
	 4dAPNKUxjOuAw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 23/28] KVM: arm64: nv: Set access flag on table descriptors at stage-2
Date: Fri, 23 Oct 2026 13:56:05 -0700
Message-ID: <20261023205610.1044532-24-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement access flag updates on table descriptors as required by
FEAT_HAFT.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index eb20409a14b1..5ae818a70ae2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -152,6 +152,7 @@ struct s2_walk_info {
 	bool		be;
 	bool		ha;
 	bool		hd;
+	bool		haft;
 };
 
 struct s2_walk_step {
@@ -253,12 +254,15 @@ static bool should_set_access_flag(struct s2_walk_info *wi, struct s2_walk_step
 	if (access->type == WALK_ACCESS_NONARCH)
 		return false;
 
-	return wi->ha;
+	return kvm_pte_table(ws->desc, ws->level) ? wi->haft : wi->ha;
 }
 
 static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
 				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
 {
+	if (kvm_pte_table(ws->desc, ws->level))
+		return false;
+
 	switch (access->type) {
 	/* R_ZYGHJ */
 	case WALK_ACCESS_CMO:
@@ -447,6 +451,10 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 			return 1;
 		}
 
+		ret = handle_desc_update(vcpu, wi, &ws, out, access);
+		if (ret)
+			return ret;
+
 		base_addr = ws.desc & GENMASK_ULL(47, wi->pgshift);
 
 		ws.level += 1;
@@ -585,6 +593,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
 	wi->ha = vtcr & VTCR_EL2_HA;
 	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
 	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);
+	wi->haft = wi->ha && (vtcr & VTCR_EL2_HAFT);
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
-- 
2.47.3

