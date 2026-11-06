Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989922;
	b=C/6yEMohfVRLxpQudEx6FL1xriWTR8dXQgp5xE4mS1dCVwcmyoHiHuoSrJa5isBHeHOq
	 LKT1FxU8FIWRhHyuQ4UGUH0/EqSd8/8pYVrCYq7aWqFhljNNETbF2OnjJ/TsAdTibBNpR
	 ygDpb5hTZm6EseEU81v/v6GtiOHx+/DgFf1LtIJuzYaNl5iEtRVSXrZnMzxiZZRvxTNL1
	 ZD5o9ybENzrvEo/x3l3R4IJRmv4ksCA2NtZet292eb+Zh4aaZUW0ziiVx4KzG9r77tkNd
	 7W7iYIJtwtgwa6hKM0evUPlDRZw1JtHbrndVPhz8wQ/f5Udra9j+O7XiZOTeDJrsUlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HbX/IgmWw5G3kayRfInKq+D4ImkiTn3Cuw7L+ddgcPs=;
	b=e7/jV4TVtSFfQgJMOOqP/WE8LE/pADhofrpsI6kITwRA+1xJ5uC8uASD+vMx/jYKQRtB
	 0Aij2BecUsKSyW/WwGPBVzqHBcXMc5TvV5JkoCjn8ImJaz2gsTghImmj+BQfT9xqoGT6A
	 UdjHNq9dIp19aI1WTlaT2n+RelfD0atqw7NcSt4eDECDE4U2OXzp8QSnTFk1XJ6/lk2ya
	 fJDAhqxFNiEjVScOA5AcCoeZDaVBLP4PoLc3q4ETGe+r0gkvJ6EAG6n7KVYBE8QYHc/Ym
	 8JXs6hDQDuoPbJ5pVW1650AotMi6PbEF24yF/ENXFuZhhVCBCjGe6Fy9KArAv8F9DzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cEV+BHy5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7CB606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cEV+BHy5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571CD1F008BF;
	Fri,  6 Nov 2026 18:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989922;
	bh=HbX/IgmWw5G3kayRfInKq+D4ImkiTn3Cuw7L+ddgcPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEV+BHy5GaX6p71f13jSeNeYEx9jga/ywZhcPax+9wxJ1oFrjIj9/8xI26HTPmaVj
	 OXjR6MY9+5GLh9hKhbH4pXvIWTAzE4DfgHIQ3LV6qDoYyCcEbJRVTzJPAP+T9jRAOP
	 N3BG1wcuLRGuZeEB+S167UTWcRAc5tVGrUEVUbHCQ+wA7xtAZFMLye5AcpYWtoFj87
	 3o3dYHYR2GNd6DnS6ICpT/73QuM5xn67xYCksNfmAKp2lsGynudxmeEqDC8zjAYtnq
	 3OZra6lbmSL5hB8Z2WjgKh+tcPsSa7cMCGU35A9/HntT101XIeDYhnh3xB5OSYcHMm
	 1QTTek2bOKiHA==
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
Subject: [PATCH v2 6/8] KVM: arm64: Add sys_reg_descs for remaining MTE CMO instructions
Date: Fri,  6 Nov 2026 10:31:52 -0800
Message-ID: <20261106183154.3590825-7-oupton@kernel.org>
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

