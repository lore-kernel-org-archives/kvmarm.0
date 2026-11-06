Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989922;
	b=4ReTbwZsDXQnskS37Xc0sqE2DVXWPdoY/l0dnhttMAwcNGxuRWF4J+rV1lI2lIORowFb
	 MOOsZAf3odEF7GACaiZuy/SYUjk+Ct9LHmukNQ/L0Q/xNGFxLrdlOEwpQyFdsaSwXXvIJ
	 uViqxdtzXA2pAuAM9GTwPRn6TOph5xFw6AQpsHThsxJ0oIVMWLKuiOsTVlatq+x69+iR3
	 EocRneKPvlzwOgfm2UcOlGAnV6SDCwM4BJfErGO6ROnPahdZoRgl1f80l1vQDW0utBZKL
	 RSJdueRax+/uV93fdegbpanyazXeeaRTwXfuWYXgMoioDnig6UajKThD2XQ8F6ti4xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rJ4hkdahi2jk6fxl30kbgS8EJOmA46DverGIQ/HpfEA=;
	b=azdw7vr5UfBosWpXiQQAs2emFgHYG96+GWEEUhEAhpK/wSBY1b+ZBP9jvLXrgrHKEaLZ
	 cmUVJkl7UIRGUDKQz3H7QnVHMBfBjERUph93GSGWXuKqlrigOUrDNJ6g9lrVah3QQ+Zma
	 IAo9qmIoggPkZMxDYiDVU4z8DqVdWSOgdFGztXqsMRu2DqT24fCfqHCoy9K1Tq+r1VHDV
	 oxzuKwJFmPlPFWxBwSJg6UCIZOmsoxqBwCPidOJF+9jvBFHluoJlS6VlQ65jrMoIGmofe
	 qiuShSJQZFcNFcjs2KhTkP38virgcN8dXW1X30jYKJAjOhlTW2oOC0ZNNpxK5m3BCeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJSGylLC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5173E606A32C
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJSGylLC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126191F008A7;
	Fri,  6 Nov 2026 18:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989922;
	bh=rJ4hkdahi2jk6fxl30kbgS8EJOmA46DverGIQ/HpfEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJSGylLCk1KNN5ofRdni3jwEwOIwfIJxMW2ct68LqH9gtDu/+ekKM5T7zfCXPBAlQ
	 Oy4VD4xi8njHkfikxk9deBKE0mOHg2MJHBVd3jz7z3lM8zW6e9zeEA2RhLjLi/0qb/
	 NgTSrf6YkVK5Qur5ddQ/SrY1WTId+txM1FmFBiuCQPC/E/UMHeYVoPaawRz0rWAKKI
	 1ZvASGKqJ9+6MdkYfg+XI2oXBbPEwnjWzQ24v3uyRDzBnxM8j5FhqmMY/cciuPirsI
	 8OJ6QdLkU0W9IB7369ByldU/yojInv0ehlQ/xrPpR3ub1sZkVxRyaA4h3p4VQJog48
	 /n+DXzpuC5VDg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 5/8] KVM: arm64: Use ->visibility() to filter MTE CMO instructions
Date: Fri,  6 Nov 2026 10:31:51 -0800
Message-ID: <20261106183154.3590825-6-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106183154.3590825-1-oupton@kernel.org>
References: <20261106183154.3590825-1-oupton@kernel.org>
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

More descriptors for MTE CMO instructions are on the way; prepare by
using sys_reg_desc::visibility() to hide instructions when MTE isn't
implemented.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0b21b454242c..b45635471344 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -556,17 +556,6 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool access_dcgsw(struct kvm_vcpu *vcpu,
-			 struct sys_reg_params *p,
-			 const struct sys_reg_desc *r)
-{
-	if (!kvm_has_mte(vcpu->kvm))
-		return undef_access(vcpu, p, r);
-
-	/* Treat MTE S/W ops as we treat the classic ones: with contempt */
-	return access_dcsw(vcpu, p, r);
-}
-
 static void get_access_mask(const struct sys_reg_desc *r, u64 *mask, u64 *shift)
 {
 	switch (r->aarch32_map) {
@@ -4306,10 +4295,17 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		.access = (access_fn),					\
 	}
 
+#define MTE_CMO_INSN(insn, access_fn)					\
+	{								\
+		SYS_DESC(SYS_##insn),					\
+		.access	= (access_fn),					\
+		.visibility = mte_visibility,				\
+	}
+
 static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
-	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
+	MTE_CMO_INSN(DC_IGSW, access_dcsw),
+	MTE_CMO_INSN(DC_IGDSW, access_dcsw),
 
 	SYS_INSN(AT_S1E1R, handle_at_s1e01),
 	SYS_INSN(AT_S1E1W, handle_at_s1e01),
@@ -4320,11 +4316,11 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(AT_S1E1A, handle_at_s1e01),
 
 	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
-	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
+	MTE_CMO_INSN(DC_CGSW, access_dcsw),
+	MTE_CMO_INSN(DC_CGDSW, access_dcsw),
 	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
-	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
+	MTE_CMO_INSN(DC_CIGSW, access_dcsw),
+	MTE_CMO_INSN(DC_CIGDSW, access_dcsw),
 
 	SYS_INSN(TLBI_VMALLE1OS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAE1OS, handle_tlbi_el1),
-- 
2.47.3

