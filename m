Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C502BA45;
	Tue, 10 Sep 2024 20:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725999972; cv=none; b=EvsjLOI2g28MPvD/RLjLzSg/wXRHmel1aPLQqIWhEIZ5SdexBjgGpCo73+MW5WBPPvqaZgB8UltOERBHhunTAxTzzOqDsZsb0hXO49GJx0CZgrd2HUxw5L1kj6NBBeike/A18KzcVpFbQGVqfCrS94VsAQyEB44XoHgUzhuP2jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725999972; c=relaxed/simple;
	bh=/vRC6UW5TKpXSnzoNSBj6lJfT63gnYyuAM0O5g3j+7U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Fl2eRjHiutPckTw2p1jqmTx4GGpwIraiUEHlWTUpybdnO7PMK0XzI30yf6oMhtIrQLye9mkovYt2zAOO2O3mCjvNlvu3ZHxyq1wyghdolt/al1kTITY5/icNviM2Vs/Y8bbrpoZXvo3TjMKeoGyvfVvdJRgI3Mhl2c/9yMnTVy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVpLwP3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVpLwP3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9B3C4CEC3;
	Tue, 10 Sep 2024 20:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725999971;
	bh=/vRC6UW5TKpXSnzoNSBj6lJfT63gnYyuAM0O5g3j+7U=;
	h=From:Date:Subject:To:Cc:From;
	b=IVpLwP3PN5TyPmbrRqw1W0DMCfJhFrKyDJadAo4MTiFrd+NEaiaeyOu9wmWUkEbQs
	 NvtNVo4V9yXvAfmT1Eq8kpdfG2Z+F4+TFFZpDpMDnGSCsob0RJc6Zsc6kkGcciIlll
	 LlZ7pxUTP6R/4PX3mrSNDpviRRPv/9p5VcaMy7CtYu934yFVt2izSkqzAKsVWg9WLn
	 4P02gs7VIZN63MeZl3FcdE3psz+nnWPEHKfyx/59Q/19n/4HlURh/Cw7di6CwDeYHd
	 qqr4RcOc1ZCgiDoir1vlwK/PbvGDE+GLtPtznQVmJ4rXcktL0Yd6j8dcUSXv8aT9b+
	 lM5aZgWGbdv4Q==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 10 Sep 2024 21:21:17 +0100
Subject: [PATCH] KVM: arm64: Constrain the host to the maximum shared SVE
 VL with pKVM
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240910-kvm-arm64-limit-guest-vl-v1-1-54df40b95ffb@kernel.org>
X-B4-Tracking: v=1; b=H4sIADyq4GYC/x3MQQ5AMBBA0avIrE1SgoariEXVqAlF2mok4u4ay
 7f4/wFPjslDlz3gKLLnY08o8gz0onZDyFMylKKsRFsIXKNF5WxT4caWA5qLfMC44VTPoxJaai1
 HSPnpaOb7X/fD+370TlaQagAAAA==
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=openpgp-sha256; l=2951; i=broonie@kernel.org;
 h=from:subject:message-id; bh=/vRC6UW5TKpXSnzoNSBj6lJfT63gnYyuAM0O5g3j+7U=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBm4KtgcGbqP1jiMA0U/QcL+yIVnZS3mIQtN3BHVkLk
 4xEBMuaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZuCrYAAKCRAk1otyXVSH0NRNB/
 9XT/BOpsS6KyJqP7dJyHRnbt2jwFRAsoob01rk9CYemGuCAfn1bn6pN+6N0RA9ES9oYMzOPiZEIVp4
 BOtvReHeQdsP6UgU2oNuJJJtH1GhZwySs/fZuqtUc8f1a8wTQwNxFp0s1Vmei0l9AC9NGQIDSKm2SQ
 ATsU+dJMFccAbu2Oj38S669xLUhrEg3C8UbXRPu1PoonmI3bVeI1CVx5QKD4XyiQ2BHAsEvC76jPCt
 p63n7FvwLJx2OudS9fLMc5waRvjv059MECo7nAIWU2MKSVIdQVAZYaFBATL4iHylY7TuIOPLgh5emD
 reohv4tECOV66tjrhaOjFAxuvYnFwu
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
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f59ccfe11ab9..ab1425baf0e9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -339,7 +339,7 @@ static inline void __hyp_sve_save_host(void)
 	struct cpu_sve_state *sve_state = *host_data_ptr(sve_state);
 
 	sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
-	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl), SYS_ZCR_EL2);
 	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
 			 &sve_state->fpsr,
 			 true);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f43d845f3c4e..90ff79950912 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
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
+	write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl), SYS_ZCR_EL2);
 	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
 			    &sve_state->fpsr,
 			    true);

---
base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
change-id: 20240910-kvm-arm64-limit-guest-vl-d5fba0c7cc7b

Best regards,
-- 
Mark Brown <broonie@kernel.org>

