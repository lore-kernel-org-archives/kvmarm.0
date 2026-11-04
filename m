Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820088;
	b=vUCH5jCsCUJ+pXPpk6Sx4wE/J2ZFcMTdXSMT9sXT8pihwkts6s4F4JQbxffxKKoqUBgW
	 TeDDopvOv3MmoZRPJIuWgzr83x7+M5NZ1ouL4DcEcM46MNBaL0DBCMcYz6mY+5ZLqA2dy
	 YrUuo6LloZVTmv7I+cLK1XHTy+U5t9ptkd7ZvwWXHbohHcIN7/9aVtKQ2sJbZGDH6E6ku
	 KWugSflSyN17LXRIJ4x4XwWdfq0B6/PsGjxGzf9TkerAHScfBImJ5tccDiQthlZFGvSSN
	 54ORs7pdzpD+4AEwuFCv8vLymdv2dOpGWaaptLW2UJZrWUy9i2Fs/hWNtuxk58xJnig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rJ4hkdahi2jk6fxl30kbgS8EJOmA46DverGIQ/HpfEA=;
	b=vgGw0L5ckTY/9kLUb5eAHVfdgKCqPvRiAc5m4ZaegLEWf3q3ijecR/Vh1t9/U/bjPCB0
	 QFZqwJ846P6wkgdSbNuDm4vsSSg42FXkmu1FTkvSIT23IKND0iexDFTqYXFq2OnzURFKp
	 aLs0TdTdaS54ebmHI0opDTwQ3Cx7BYc2VQmSIoRrScnyMwgZOhjDwToK7Gg6TL3DcyUZK
	 AO4h3Ycc3sglJcv5+Hcm54mZu9pTcx3x9qIGJjv86azMEVM9VV3VV9E77mqxIIAoymQ6Y
	 QvpBTmUhZOeXOTL9olX+k9NHMu3tHR0mUfrfrIscYbuIB0vqqkZZ1Dvj1bbhkfNnXfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X1zeQKH4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3903606A879
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 19:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X1zeQKH4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60121F00A1B;
	Wed,  4 Nov 2026 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820087;
	bh=rJ4hkdahi2jk6fxl30kbgS8EJOmA46DverGIQ/HpfEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1zeQKH4F2iboNf5t8ER6KwQnrCbkMhWlPLYDaAGti9NZ/MFtiojGbmX+T4EwUXl/
	 zDpVR6gCeYWiQhrI6hHpNvrdsRRa21Enlq/MXZOtJPrJZRo9DRexMUr21BBfwOC7Rd
	 XxAlKJKeM9RgAFypj6TpHrg8ZPg8AarJfsGCb8lYKSA2deYBUhXYeKbHB5GOmYiVmA
	 /T+gSk6V20R2DcmdpssyCD67akEEQfi5iXKjQ/46AcM2Ju8Y8udK6YYV7Yk7fQnrh3
	 w7cHpccn6A3UjTN1pKgtcGghWtUJ5hcVYV59LMvaDGCeUoRv/idGa+wS2Prdxq3Hdi
	 3iiLP9g8E1G9Q==
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
Subject: [PATCH 5/8] KVM: arm64: Use ->visibility() to filter MTE CMO instructions
Date: Wed,  4 Nov 2026 11:21:21 -0800
Message-ID: <20261104192124.3932743-6-oupton@kernel.org>
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

