Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16CC288BD;
	Thu, 12 Sep 2024 11:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726141191; cv=none; b=Ij3kOuUaYoW70vwy50hABQHOeEM/IloQxi4KFUexocVKk/dEzAhTnmo+y7aktSjGFmIlZUCIDi7/KlZECCUHR/vHHPpOrz6DGRg4esJp4kjWQ0AM+bnjy/Ub1OXsPwXS7NYy9CZdKZbLCFpq7c7ud4agBwAS2CCczbv9VZj9+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726141191; c=relaxed/simple;
	bh=T7L5DaGqzTOTtAvvzaHbnlKPp7RFKeCBqLlFYkwSqLw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gg8lp/9sMkUOeAu0Ejfg4LxmJpGSWMX3QfMbnPC/QU0/OJ8sfEboewUZ/946yTghZtN4FGN39LZYZBVkk3JJx5AKeh7Z/CTfe8/4Yja4GoVss3LrCXD63EONiF05CdFSgXEky3ABHHLLdd8qfMxdda+U0jplaCePLoPibio6g0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFgoCJvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFgoCJvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FD2C4CEC3;
	Thu, 12 Sep 2024 11:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726141190;
	bh=T7L5DaGqzTOTtAvvzaHbnlKPp7RFKeCBqLlFYkwSqLw=;
	h=From:Date:Subject:To:Cc:From;
	b=BFgoCJvOJyY3bOglFn+ZWACYg8QtpwGdz8pOmQIFdE74BGNSBRZXNsZoGc/3TT7wU
	 pIYxqLan4KPTOpjpP3inHAEGVz5vjDDn23KuJSrIa2Gh7FVzJBuV/k/LXxPe3+Q0ni
	 UxSRctHpb+A+bzBZ+GJFLciS/UxrF1oD6HIA+Uxzva1OvjsWjmYuzEnkHwAmN8qAdl
	 PXIKZxopbrVwRHXv18u1bl6aaU4/E4iCrt+rscPGfyPRH/fJ0geN15PGYk7hcwJJ9i
	 nRCqVzomZ99TqboGrk3OaOACn4KrFWa9imbTwv9SKXuf5FYeqltPTWHPlOB0xPjzD4
	 G8Evs7cywhkEQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 12 Sep 2024 12:39:35 +0100
Subject: [PATCH v2] KVM: arm64: Constrain the host to the maximum shared
 SVE VL with pKVM
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240912-kvm-arm64-limit-guest-vl-v2-1-dd2c29cb2ac9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPbS4mYC/42NTQ6CMBBGr0Jm7ZiWFAmuvIdhQcsUJvxmio2Gc
 HcrJ3D5XvK9b4dAwhTgnu0gFDnwMifILxm4vpk7Qm4TQ65yoyqtcIgTNjLdDI488Ybdi8KGccS
 28LZRrnSutJDmq5Dn95l+1ol7Dtsin/Mp6p/9Ixo1aixM642yVeG9fQwkM43XRTqoj+P4AoWw2
 gjBAAAA
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=openpgp-sha256; l=4033; i=broonie@kernel.org;
 h=from:subject:message-id; bh=T7L5DaGqzTOTtAvvzaHbnlKPp7RFKeCBqLlFYkwSqLw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBm4tMBhIe/LyjljX9tuBWlDKk4ejJQHl0QK9VwvpLj
 RdUeHXiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZuLTAQAKCRAk1otyXVSH0IdqB/
 4gXr5PVu25pExDRTo3+OAEvKWTRTw/ws6HXCW3rva49UeNE2tmd+L2YNmgFAG6FI8kzDofraRBM2GG
 +fzc+m+LBymMfeYGHklB+aqfJoHbA7l+9YvehpcWE3LaNEpAgzko5Q6I8lPl/mZHe1A94WsFNPCtS4
 UOmAqc4Lzzv+xMT7qTpL82zmc1HGD4ltyzxY2Pv9OQry5CXAdoZ478qOyq6khV0Q/yZyMs4CpYMKsH
 n5MwpGNqRxJlAoCnk899KSVkD6mV6g6waZ/x/+8epabahAKZ4Oae6UNcc6+OPxqSMXnn9oXPz9JCN0
 Z9WCmy2EdR4M6ffd2/BEwbQu5q7afS
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When pKVM saves and restores the host floating point state on a SVE system
it programs the vector length in ZCR_EL2.LEN to be whatever the maximum VL
for the PE is but uses a buffer allocated with kvm_host_sve_max_vl, the
maximum VL shared by all PEs in the system. This means that if we run on a
system where the maximum VLs are not consistent we will overflow the buffer
on PEs which support larger VLs.

Since the host will not currently attempt to make use of non-shared VLs fix
this by explicitly setting the EL2 VL to be the maximum shared VL when we
save and restore. This will enforce the limit on host VL usage. Should we
wish to support asymmetric VLs this code will need to be updated along with
the required changes for the host, patches have previously been posted:

  https://lore.kernel.org/r/20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org

Fixes: b5b9955617bc ("KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Update all places where we constrain the host VL, not just those where
  we save and restore host state.
- The value written to the register is 0 based, not 1 based.
- Link to v1: https://lore.kernel.org/r/20240910-kvm-arm64-limit-guest-vl-v1-1-54df40b95ffb@kernel.org
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f59ccfe11ab9..c2cfb4d6dc92 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -339,7 +339,7 @@ static inline void __hyp_sve_save_host(void)
 	struct cpu_sve_state *sve_state = *host_data_ptr(sve_state);
 
 	sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
-	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
 	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
 			 &sve_state->fpsr,
 			 true);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f43d845f3c4e..dd1c6aa907a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -33,7 +33,7 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 	 */
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr, true);
-	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
 }
 
 static void __hyp_sve_restore_host(void)
@@ -45,10 +45,11 @@ static void __hyp_sve_restore_host(void)
 	 * the host. The layout of the data when saving the sve state depends
 	 * on the VL, so use a consistent (i.e., the maximum) host VL.
 	 *
-	 * Setting ZCR_EL2 to ZCR_ELx_LEN_MASK sets the effective length
-	 * supported by the system (or limited at EL3).
+	 * Note that this constrains the PE to the maximum shared VL
+	 * that was discovered, if we wish to use larger VLs this will
+	 * need to be revisited.
 	 */
-	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
 			    &sve_state->fpsr,
 			    true);
@@ -479,7 +480,8 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_SVE:
 		cpacr_clear_set(0, CPACR_ELx_ZEN);
 		isb();
-		sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+		sve_cond_update_zcr_vq(sve_vq_from_vl(kvm_host_sve_max_vl) - 1,
+				       SYS_ZCR_EL2);
 		break;
 	case ESR_ELx_EC_IABT_LOW:
 	case ESR_ELx_EC_DABT_LOW:

---
base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
change-id: 20240910-kvm-arm64-limit-guest-vl-d5fba0c7cc7b

Best regards,
-- 
Mark Brown <broonie@kernel.org>

