Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF20547D441
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 09:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327185; cv=none; b=ZUF3DOSobr8VVWoFqtYmcjJ8c0PbhK/jxl2YYXF01yx4n5OtRfe3q5BEtyJiWg69KjgGTmweqCfvjX3Xapo/Epsy8cJijlBJCf1Dwkl72U98PtXHqqiRfxQ8NIIERnoZR9qq51uspaxQKpbvEKHCzTgn7XF7NjFlmI49Yd6xwEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327185; c=relaxed/simple;
	bh=8smf6B5tmlcKz4QzEGNgl2hIDEjwNVAhW9TDDQkcLVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=STakpcqjEA4ccoTzeqj+7GlM2rhRiluN3W7VtRRKKYQWhtlFn2+GWGNxFbzU0gG+4vJRgVBaMAo1RPqxy9Y9a+QJqq3IS8pEUaeSviNoddM2ULodBlErmH86CevXU92zb+ojEyuGc25XYzZRyrGrUFZwT/PWYYEYgFs3Tcrc6yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a2ntrXph; arc=none smtp.client-ip=95.215.58.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a2ntrXph"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8smf6B5tmlcKz4QzEGNgl2hIDEjwNVAhW9TDDQkcLVc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790327180; v=1; x=1790931980;
 b=a2ntrXphIPFOe1yZje+JkJ8k02wPscxfCg5akywqTNCUknE1uA+5jo9J+eviYujweOWJrZVz
 dsuhmy/Lve/Yk3wOravotxdI7IBUSDiS0j23peMXghk5ccAkcobT8B8bcguQZyhp6Qop2ht4W7d
 ivfz2q+cUzrO0tyKCSWtgcZM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id dbee69ddbf1bd07b;
	Fri, 25 Sep 2026 09:06:20 +0000
X-Mizu-Trace-ID: dbee69ddbf1bd07b
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/4] KVM: arm64: Don't WARN on an unsupported TLBI OS from vEL1
Date: Fri, 25 Sep 2026 10:06:16 +0100
Message-Id: <20260925090619.852995-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260925090619.852995-1-fuad.tabba@linux.dev>
References: <20260925090619.852995-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A VMM can trigger the WARN_ON(!vcpu_is_el2()) in handle_tlbi_el1() on a
CPU with FEAT_EVT2 and FEAT_TLBIOS but no FEAT_FGT, by setting
ID_AA64ISAR0_EL1.TLB to NI and having the guest execute TLBI VMALLE1OS.

Without FGT, HCR_EL2.TTLBOS traps the instruction. KVM records no FGT
trap information on such a host, so triage_sysreg_trap() doesn't UNDEF
it. The instruction reaches handle_tlbi_el1(), which warns before
checking whether the guest supports it.

Check support before the warning.

Fixes: 0cb8aae226768 ("KVM: arm64: nv: Add handling of outer-shareable TLBI operations")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d7..0ce29ce678b08 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4257,6 +4257,10 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 
+	/* Without FGT, HCR_EL2.TTLBOS also traps a hidden TLBI OS from vEL1 */
+	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding))
+		return undef_access(vcpu, p, r);
+
 	/*
 	 * If we're here, this is because we've trapped on a EL1 TLBI
 	 * instruction that affects the EL1 translation regime while
@@ -4279,9 +4283,6 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	WARN_ON(!vcpu_is_el2(vcpu));
 
-	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding))
-		return undef_access(vcpu, p, r);
-
 	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) {
 		kvm_handle_s1e2_tlbi(vcpu, sys_encoding, p->regval);
 		return true;
-- 
2.39.5

