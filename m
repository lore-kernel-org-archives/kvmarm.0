Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820088;
	b=f/+0+GNhTJkyQSWq+iwnSYn+Rneta8WAiAaGiJB/tma8ycmfArFOsk0OMkNTauJqbAqd
	 tjBXgEiA9GYohYn0/sze3xuXVktApDIzPZQDIkjPwx7L1Ds5q72KH4kVWL7dmK/vNCNJ1
	 23PEUN202op7gCRcm8BGa5cNTGU0yUtkrZwo5rRjZgaSqAogbyr7TM6+9H0JZv6CCP9go
	 dJuuxLSKWxPv0gXjVMkpgJhdv3owlVCmFOxuOjNNcHaqxZzbLvpudJaXseKYps+T8FKdd
	 bzx0s2rrCMJYfFhFrNTBWpC39CnqGEvfh/KavJPI+Z9vOzvKbmfLsGjjG0LnjCjRLCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HbX/IgmWw5G3kayRfInKq+D4ImkiTn3Cuw7L+ddgcPs=;
	b=idFKor9nQrabUND7YDDzgx0WvtQGcLlsDzwgVuBtHXg2k5pCRQVgCtuLk4GQgDCpJCUE
	 D4bGrKRB/Hq8NzaJN0p6eUSuqxlrsdh5dkDfyRS2iugdG6ZVUR6HDGHGm9x3/QscFa9Cn
	 SiXWkYRwm99s+iaILX9jEo9XhEhon3VprZX5GoAJMg8dtTdiVGAgbg1gixxoehZTkV9KT
	 aHBN/jub5QmkMV2Kp35dFCkfDhiuJQyKLbnS4p44zEGt0SZFmcDkhbjz9R4BsxsMJVxRw
	 EVIil77YzAw8rQSksd8+jxM7FmmkAq7dS/bXgwbD2SKz86SyByValJAVuOt5WDkZxvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bC+9sOBr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE66606AB2A
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bC+9sOBr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB311F00A1D;
	Wed,  4 Nov 2026 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820088;
	bh=HbX/IgmWw5G3kayRfInKq+D4ImkiTn3Cuw7L+ddgcPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bC+9sOBrlucFMnuyBXDaOcb5wdH++qKwXHoI6MgEBJOHdylPphqItInlwraogV0V0
	 tWl5FVaxP08z/RXMb3iZsgT5d2TZlztskMBfkR1lPoxq/t5RgHzxlZMYPGpLWbjkwQ
	 EG3UFQIStSH9AGTNKYihR5tRPl0jvObRMR1pOZjPTJN/jq2c9e/TLO1Pbvcgs2JEF5
	 D4NU7TUtykpiqku8zBACz6oAO1o9DFKV40fEapkeHsFq8t7KivLWwLSCYwSPa2F97x
	 2HQkJU9uoljRJ5YoS72TRUXyZ4pCxZFQ7PCwELRz6MUm7Iy0pviAej2OOzZOguP4oL
	 RmjRUxUwiUwuA==
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
Subject: [PATCH 6/8] KVM: arm64: Add sys_reg_descs for remaining MTE CMO instructions
Date: Wed,  4 Nov 2026 11:21:22 -0800
Message-ID: <20261104192124.3932743-7-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104192124.3932743-1-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org>
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

Filtering unsupported cache maintenance instructions from a guest relies
on either having a suitable FGU bit for the feature or a descriptor with
a visibility() hook.

MTE CMO instructions can be trapped by HCR_EL2.TPCP and lack a suitable
FGU. Add descriptors for the CMO instructions that UNDEF if MTE isn't
implemented for the VM.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b45635471344..7f7a197a9ad6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4295,6 +4295,12 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		.access = (access_fn),					\
 	}
 
+static bool bad_cmo_trap(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	return bad_trap(vcpu, p, r, "MTE CMO trap");
+}
+
 #define MTE_CMO_INSN(insn, access_fn)					\
 	{								\
 		SYS_DESC(SYS_##insn),					\
@@ -4304,7 +4310,9 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
+	MTE_CMO_INSN(DC_IGVAC, bad_cmo_trap),
 	MTE_CMO_INSN(DC_IGSW, access_dcsw),
+	MTE_CMO_INSN(DC_IGDVAC, bad_cmo_trap),
 	MTE_CMO_INSN(DC_IGDSW, access_dcsw),
 
 	SYS_INSN(AT_S1E1R, handle_at_s1e01),
@@ -4321,6 +4329,7 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
 	MTE_CMO_INSN(DC_CIGSW, access_dcsw),
 	MTE_CMO_INSN(DC_CIGDSW, access_dcsw),
+	MTE_CMO_INSN(DC_CIGDVAPS, bad_cmo_trap),
 
 	SYS_INSN(TLBI_VMALLE1OS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAE1OS, handle_tlbi_el1),
@@ -4394,6 +4403,15 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE1NXS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1NXS, handle_tlbi_el1),
 
+	MTE_CMO_INSN(DC_CGVAC, bad_cmo_trap),
+	MTE_CMO_INSN(DC_CGDVAC, bad_cmo_trap),
+	MTE_CMO_INSN(DC_CGVAP, bad_cmo_trap),
+	MTE_CMO_INSN(DC_CGDVAP, bad_cmo_trap),
+	MTE_CMO_INSN(DC_CGVADP, bad_cmo_trap),
+	MTE_CMO_INSN(DC_CGDVADP, bad_cmo_trap),
+	MTE_CMO_INSN(DC_CIGVAC, bad_cmo_trap),
+	MTE_CMO_INSN(DC_CIGDVAC, bad_cmo_trap),
+
 	SYS_INSN(AT_S1E2R, handle_at_s1e2),
 	SYS_INSN(AT_S1E2W, handle_at_s1e2),
 	SYS_INSN(AT_S12E1R, handle_at_s12),
-- 
2.47.3

