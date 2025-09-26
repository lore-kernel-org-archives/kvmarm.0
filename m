Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FBD270EAB
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758915682; cv=none; b=KVpR6tPUZGsgyjwq5cEMYEu2Bogpt9sr0vkT4nq7Ubn7j9VE4AueaAcmL1uH7n+Vhhobp+ceg6058Pj/ab6wrUHoXNqNfWNYr2MmiHd/1eYmhmr2Ug9+F/F4gZHKvmi0Xi+tMILkpWCOVeUkC9xwtHGOwr1yL/IiNJ5cAFwlSWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758915682; c=relaxed/simple;
	bh=20eLueoVDy8cScdKflRhEqJJ9eb7r9uP0Nf4vTx4k6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PwvBY3/A3hHY+aoLAkKbTVESrj/PB8X1ex1toB/yngbq9aGJl64MYBxLYdLXjdajgYQPM9iUNnSy/imyynlquXAHBjEnZCrV3cILG43Rh/UF4vESa65yGtQDB0ico55FhXhF24OwNyy3arn/TfmTk+LlQVIcpPLrUbg27dapyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jq2epYtv; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jq2epYtv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758915679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcT5DW7Scxi1siyk1UAgrQXE8cRFfCifo1GIRY2+dCk=;
	b=jq2epYtvCSiMp50CI+mwwqTzijLPRBSXFtSiUVx0sKEjQtuOPtSTS0xHk4sxM1B6fyn2zC
	8+aNnXo9R+DDMNooOzyfe0EO27v+kBE0ghCdCrNDVdWi7JcJxDHEBqwh1yprL9LUkbABDB
	8a/1R1BbJp9TwRdI3C7ZK3M6c+bWJK0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jan Kotas <jank@cadence.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: nv: Don't treat ZCR_EL2 as a 'mapped' register
Date: Fri, 26 Sep 2025 12:41:07 -0700
Message-Id: <20250926194108.84093-2-oliver.upton@linux.dev>
In-Reply-To: <20250926194108.84093-1-oliver.upton@linux.dev>
References: <20250926194108.84093-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Unlike the other mapped EL2 sysregs ZCR_EL2 isn't guaranteed to be
resident when a vCPU is loaded as it actually follows the SVE
context. As such, the contents of ZCR_EL1 may belong to another guest if
the vCPU has been preempted before reaching sysreg emulation.

Unconditionally use the in-memory value of ZCR_EL2 and switch to the
memory-only accessors. The in-memory value is guaranteed to be valid as
fpsimd_lazy_switch_to_{guest,host}() will restore/save the register
appropriately.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 91053aa832d0..4a75e5f0c259 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -203,7 +203,6 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
 		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
-		MAPPED_EL2_SYSREG(ZCR_EL2,     ZCR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(CONTEXTIDR_EL2, CONTEXTIDR_EL1, NULL	     );
 		MAPPED_EL2_SYSREG(SCTLR2_EL2,  SCTLR2_EL1,  NULL	     );
 	case CNTHCTL_EL2:
@@ -2709,14 +2708,13 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 	}
 
 	if (!p->is_write) {
-		p->regval = vcpu_read_sys_reg(vcpu, ZCR_EL2);
+		p->regval = __vcpu_sys_reg(vcpu, ZCR_EL2);
 		return true;
 	}
 
 	vq = SYS_FIELD_GET(ZCR_ELx, LEN, p->regval) + 1;
 	vq = min(vq, vcpu_sve_max_vq(vcpu));
-	vcpu_write_sys_reg(vcpu, vq - 1, ZCR_EL2);
-
+	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, vq - 1);
 	return true;
 }
 
-- 
2.39.5

