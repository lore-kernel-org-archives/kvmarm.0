Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED7E13FF7
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zw4UPztb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2449C433CD;
	Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698054893;
	bh=UCVfaxixEC1cjSrf8vsDNxh9MV8g4gesXnFpQTH6Wbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zw4UPztboRvjPK4JO41qvPJvbY5mpGPYU9iZL1sjVwu9gX9x8PItgj+7y6ZEsTKj2
	 SNc3QmOujdUMpapkO7Qazka+YrlNDS6G17QLm10rGgMcz3iS/EAnzFHeZdRuNuEDnD
	 A1LqaujyrEAWSJf+JVw7827BjxjR6ByRULpL6x9ycLYimkKTfYD/4cDk9qw/zwgpGI
	 /Pnz3MSkGVETpZ+37qjrcBkXor4oHA2RSUdIEx3b1DdZSKebe62kIHuvaSQnFz4TNL
	 lofX3bMHmSHh27GOsSMW8XPqplqs/mORiEWGQfiZKHPXBfDxQSAfzXDcAqVwzX2zX0
	 KQ7B+dTVYosWg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qure7-006nPT-I2;
	Mon, 23 Oct 2023 10:54:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@redhat.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 4/5] KVM: arm64: Do not let a L1 hypervisor access the *32_EL2 sysregs
Date: Mon, 23 Oct 2023 10:54:43 +0100
Message-Id: <20231023095444.1587322-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231023095444.1587322-1-maz@kernel.org>
References: <20231023095444.1587322-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com, miguel.luis@oracle.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
UNDEF when AArch32 isn't implemented, which is definitely the case when
running NV.

Given that this is the only case where these registers can trap,
unconditionally inject an UNDEF exception.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20231013223311.3950585-1-maz@kernel.org
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0afd6136e275..0071ccccaf00 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1961,7 +1961,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	// DBGDTR[TR]X_EL0 share the same encoding
 	{ SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
 
-	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
+	{ SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 },
 
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
 
@@ -2380,18 +2380,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
 	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
 
-	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
+	{ SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
 	EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
 	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
 	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
-	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
+	{ SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
 	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(ESR_EL2, access_rw, reset_val, 0),
-	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
+	{ SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x700 },
 
 	EL2_REG(FAR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
-- 
2.39.2

