Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDB5381B1A;
	Sun, 19 Jul 2026 23:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502646; cv=none; b=rC3/48cp580hRwzVSGHMPyHJlutkgSP7+OrqPQxwKWxcdOCoLOwsFhOkGX3mSB/Z1DdCJIPr3GmCxJy28G+BU1ApVVErlH5i6IafzJXL7buZEG8eYoqm+nHgwRmiK2iP/Pq5Sx6xPpp1tNBCW7vOmulTpmwV7ZXy0mGAAqX0Bmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502646; c=relaxed/simple;
	bh=01MOCCSmzfiDMZ4P33yBk6+tJ6PaDO0mQnR5AsHR3Mw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UZ74M/C+MoX/fb1E5bgCGg1OoY+bklMT5UyAt7u9nGkdKATZiDvHtAJGoqHlkXHyJ48jOqRsGH0N8qUq0p1WhAfVdOtfj75CfwumXOJd4ILeYt5hFStktGBelCKvr0k/kK9LDnjnMBP/bMzVn7obed23wfQsqLBapDFO3hwu8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfHDFrQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfHDFrQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3981F00A3A;
	Sun, 19 Jul 2026 23:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502645;
	bh=LBGo8J9fHQYp9Dr1R4CvmQH4U2pyd2XsXoly5P/hfh8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IfHDFrQBLNpytDktGMnouQN8B1XFyV+D+AvTPpuL1AknmQ/Ci1yEQf1yxgPxOo8iz
	 vXHeUEmy4NqNAdmCtDEJ6i5q+mIYqK1+7QZoKXzhKIHpO91nWWDeaLWk2Yo+DIywlb
	 w6G8tcwYa1h7nmeLeMvVMZzXO6ii057LkC9cbI7yx2VGqaKh8sFkii9zrHGea/SY8d
	 bNiBpcXbzTpnf+iO1mh5tTEjlW5+Klud2QuT5Kxb75I+wiq5/Orq7pYZ6gyaau72Rj
	 6wP320xoiZdrgQHOSSgNW9gL4HlbP+3d53WxyKuhnb+ibM+o/VNRvvqCQAe+s/+A7r
	 tEHikMQoNUQzg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:38 +0100
Subject: [PATCH v13 11/32] KVM: arm64: Remove special case for FP state
 loading from ZCR_EL2 traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-11-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3261; i=broonie@kernel.org;
 h=from:subject:message-id; bh=01MOCCSmzfiDMZ4P33yBk6+tJ6PaDO0mQnR5AsHR3Mw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVkwVVmjUITqV+2fMkyW3FbqdCcZlHZbvTxH/
 gMFed0EwvOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZMAAKCRAk1otyXVSH
 0AdyB/9fjpYwqxCrDAwM14AF8+P6b1/+CNObcTxTKwn07ZLl68QIk+6o8eGvdh28nPIRGmww+cb
 MKbQJkFS2P0ga0f4v5qX1YOlMCFRt6ZU9V6rKkUQGWMYVBN89ZHzKXTIpX1js7zTq9xrs0zOLWs
 NEVXnyOozKzghDsdLaf8xjBadaHoGzqUb9LchV/86GGjxdOdajY66xxJNDJYpyGYhcltjH8Rme1
 e3F/mUAELIwvDhwbdnfCCVay5O7zdEvIkrtj0gyt4KHHPS+SatqTxwm923tnYblATk94CY19ZEv
 ri+md7EkG78lofrPA6FDRP3Uio3mKUim4JgvSpqXGr607oI0
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As part of adding the nested virtualisation support commit 0cfc85b8f5cf3
("KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap") added code
which handles access to ZCR_EL2 from a guest as a SVE access trap.
While the reasoning for this was not specifically articulated in the
commit log it was part of the lazy switching mechanism that we used to
have for ZCR_ELx.  Since commit 59419f10045bc ("KVM: arm64: Eagerly
switch ZCR_EL{1,2}") this mechanism has been removed.  We now switch
ZCR_EL2 in the hypervisor when transitioning between guest and host,
meaning that we no longer need the special casing.

Remove the redundant special casing, this simplifies the code and will
make the implementation of SME support (which architecturally follows a
similar pattern to SVE) easier.  Accesses to ZCR_EL2 from a nested EL2
will use the standard system register access handling path which works
with the in memory copy, and if the FP state is not yet loaded any
floating point operations will cause an access trap which we handle by
loading the state.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ----
 arch/arm64/kvm/hyp/vhe/switch.c         | 27 ---------------------------
 2 files changed, 31 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 18131e395e24..b4680baffc6e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -601,10 +601,6 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		if (guest_hyp_fpsimd_traps_enabled(vcpu))
 			return false;
 		break;
-	case ESR_ELx_EC_SYS64:
-		if (WARN_ON_ONCE(!is_hyp_ctxt(vcpu)))
-			return false;
-		fallthrough;
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)
 			return false;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index bbe9cebd3d9d..625fe81a20b1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -458,30 +458,6 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
-static bool kvm_hyp_handle_zcr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
-{
-	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
-
-	if (!vcpu_has_nv(vcpu))
-		return false;
-
-	if (sysreg != SYS_ZCR_EL2)
-		return false;
-
-	if (guest_owns_fp_regs())
-		return false;
-
-	/*
-	 * ZCR_EL2 traps are handled in the slow path, with the expectation
-	 * that the guest's FP context has already been loaded onto the CPU.
-	 *
-	 * Load the guest's FP context and unconditionally forward to the
-	 * slow path for handling (i.e. return false).
-	 */
-	kvm_hyp_handle_fpsimd(vcpu, exit_code);
-	return false;
-}
-
 static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_tlbi_el2(vcpu, exit_code))
@@ -493,9 +469,6 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
 		return true;
 
-	if (kvm_hyp_handle_zcr_el2(vcpu, exit_code))
-		return true;
-
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 

-- 
2.47.3

