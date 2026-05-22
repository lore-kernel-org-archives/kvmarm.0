Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8FA328611;
	Fri, 22 May 2026 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779472822; cv=none; b=At1hNBPjKni4Ct8L3FpH5w9Sh32jEcfwiLkGGODiPyIa+cUEVbQt5sspB79ad+MwGZnyTXZHXnmQ/B1bKZsjl1a1VCrZhphyv3sCcb7dU0cAZQQ973BKMHGJi+nQZaUWVw1iBJJWUJpvoJrZagunsRHfzdJPDKiQP4PZlRilXA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779472822; c=relaxed/simple;
	bh=NuFpAbhy7SIcpHNtP51CJ5XzabRJU55tghTXRronQQ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JNgr3aBkjGUTpdHYEhMPygNwwbAvlsAWwQg+W/7mAMm7FE92XSGYsXauNKdqCVl3fptbL5o/GblsJU1E9jbaXkV46Z+PH3iHk9Mgv3K2CHVG7G+cDkyZeq95l0UMWe+fen8LLVxzpmV6DYX9Ype6yZ1YK0vSU90N9lpwK5BORaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGC7snl+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGC7snl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083821F000E9;
	Fri, 22 May 2026 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779472820;
	bh=zaYaOdDDdM4eMMiXs7oSYVChBLimpl06io6NldbGQpU=;
	h=From:Date:Subject:To:Cc;
	b=EGC7snl+DtLrdxQZPCIkUcxv3YPJXwjOW8fF87TPr7o7XCwgE1+QoRcJXu4UCF/KX
	 paR7up5fOsGSAcdt4ZHT1YmAEsY9mT6keVmYwbKWufUe18ur6BfVLf2hAdFrunYgf0
	 nSmcAFxZ7Wgj+B39rsTLdQAiiqgVWqOVPao70sex3tDa5Cr7WgWEwI1dw17//Xk/EC
	 1iqSk+7xhklcX+8uusSpdTyfXMTmfv2mbrtbklrjH6jZVoTjwDdt2+Khy5tnnWLMvc
	 oGx+Atyav1BCfdwsfeeGc67ff33oFc1+EirWZ3HWZ/SjPPyFgglXW/wvw7n5ewTF1R
	 1IG25UhoK5Bmg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 22 May 2026 19:00:04 +0100
Subject: [PATCH] KVM: arm64: Preserve all guest ZCR_EL2.LEN values
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-kvm-arm64-fix-zcr-len-nv-v1-1-ec254e9078cf@kernel.org>
X-B4-Tracking: v=1; b=H4sIAKOZEGoC/yXMUQrCMBCE4auUfXYhCdoSryI+pHFsV22UjQax9
 O5G+/jBzD9Thgoy7ZuZFEWy3FOF3TQUx5AGsJyqyRnXmp31fC0TB53aLZ/lzZ+ofEPiVNjDo+s
 DjHWB6v2hqIt/+nBcnV/9BfH569GyfAF5x4K4fAAAAA==
X-Change-ID: 20260519-kvm-arm64-fix-zcr-len-nv-9e9e7bae012a
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3374; i=broonie@kernel.org;
 h=from:subject:message-id; bh=NuFpAbhy7SIcpHNtP51CJ5XzabRJU55tghTXRronQQ8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqEJmw5sPUxxYu5BdKH7PXAjJE9yYbrnRA6tzAs
 TCvvMaEwcqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCahCZsAAKCRAk1otyXVSH
 0FCWB/9fbZOC9HhqXlHPnU+iZ33L/WZnir6QyHwm+p8OOR2YEblEcEVeCWgahGXvRPfXf8SZW3q
 6NkPQ7H8Zc5yJW4dgCMNnd1MNmtGcrABBP4XLSPrhKcIsdn6OLWXokrLDU87o+mA4C7BhIBGD2J
 CN/QmMPit7BgPp6AolUalC09jxvPD61cYRFHbw52+weygfFbo/LPA8IL/vsP1CKGq/mgoZRbX0/
 M1AaO4/zIeU0qFSboxeLsBvl7JyKrnP7LIBUowLD4z/wNkcKFeLs16S1k68bBsqGP1PYBfKOpQq
 uUL30hWrKTF6yKqhE1LQizAWoHaMpFEkhGfYEr1qUxpPELPJ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Since b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps") when guests
write to ZCR_EL2 we have clamped the value of ZCR_EL2.LEN to be at most
that configuring the maximum guest VL. This is not the behaviour the
architecture documents for ZCR_EL2.LEN, the expectation is that all bits
will be read as written. Further, writing values larger than the largest
available vector length is part of the documented procedure for enumerating
the supported vector lengths so we expect to see this happen in practice.

The reasoning for the current behaviour is not specifically articulated, my
best guess is that it is intended to ensure that the guest can not see an
effective VL greater than the maximum that has been configured. This can
instead be achieved by configuring ZCR_EL2 when loading guest state:

 - When running at EL0 or EL1 configure ZCR_EL2.LEN to the minimum of the
   guest ZCR_EL2.LEN and vcpu_sve_max_vq(vcpu)-1.
 - When running at EL2 configure the maximum VL for the guest in
   ZCR_EL2.LEN like we do for non-nested guests and load the guest
   ZCR_EL2 into ZCR_EL1.

This will ensure that the guest sees both the ZCR_EL2.LEN value which it
wrote and the effective VL that resulting from the values it has configured
in ZCR_ELx.LEN.

Currently all other bits in ZCR_EL2 are either RES0 or RAZ/WI, values
written are sanitised based on this.

Fixes: b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 8 ++++----
 arch/arm64/kvm/sys_regs.c               | 6 +-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index bf0eb5e43427..fd277cb70967 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -501,11 +501,11 @@ static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 		return;
 
 	if (vcpu_has_sve(vcpu)) {
+		zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+
 		/* A guest hypervisor may restrict the effective max VL. */
-		if (is_nested_ctxt(vcpu))
-			zcr_el2 = __vcpu_sys_reg(vcpu, ZCR_EL2);
-		else
-			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+		if (is_nested_ctxt(vcpu) && !is_hyp_ctxt(vcpu))
+			zcr_el2 = min(zcr_el2, __vcpu_sys_reg(vcpu, ZCR_EL2));
 
 		write_sysreg_el2(zcr_el2, SYS_ZCR);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 148fc3400ea8..c4d3bbae2d14 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2862,8 +2862,6 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	unsigned int vq;
-
 	if (guest_hyp_sve_traps_enabled(vcpu)) {
 		kvm_inject_nested_sve_trap(vcpu);
 		return false;
@@ -2874,9 +2872,7 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 		return true;
 	}
 
-	vq = SYS_FIELD_GET(ZCR_ELx, LEN, p->regval) + 1;
-	vq = min(vq, vcpu_sve_max_vq(vcpu));
-	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, vq - 1);
+	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, p->regval & ZCR_ELx_LEN);
 	return true;
 }
 

---
base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
change-id: 20260519-kvm-arm64-fix-zcr-len-nv-9e9e7bae012a

Best regards,
--  
Mark Brown <broonie@kernel.org>

