Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A22E441610;
	Thu,  9 Jul 2026 18:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622462; cv=none; b=sR6KzHKYIgrDHohIiCDQqhMJhEcJjiUkP8XMTNAp8rB6/rOC2m4u5PAe1aQ5cNF2RAVUbEFKE3Zh0zC4zcpx3nlA3t+OtKGTdXEGBFOxKvmFXUilDJ8z57dvOpbcecqpRVqY0yWAvjSAa2DmORDMU9RAzpzpTyYa7BuqcxwcBUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622462; c=relaxed/simple;
	bh=zkAz4EpB+oD/CW01W7HnqzjEzUv3OlXONmLnbiTh4s0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uMoqzVM5SUrCvoTtQsGqX6zZFCbLk7x5naP3oSlMhEOMYt2R4+qq8cCAwDt4aTCJMHHa19XBTzibceFAIsurOKS2qDI8eG7uRNwHQ1vqTJwDRyg6xb6wPr08TDLS5HbrPKir+vvdGjGS6SmTBkhthZJ0gGXrJp69FOhV9Nr2rEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5rhxUX+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5rhxUX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CE41F00A3A;
	Thu,  9 Jul 2026 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622460;
	bh=Hf3ZnwbaPwB7JWA6xLw/d7mljky+WZ0YaL8vLXxrCY0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L5rhxUX+nsrBajnjExeDBc2fTwO6wA7PYtjLR+rxXbgC4FNRZhXsenOevMrN6N0Yv
	 PYxr4wbp4HghyqX0LCkSJ09OQrLiMVftug4jAbTG56/bV8bxbK0DR76J1ceoJfH9RD
	 bAbNcUV98/JUN+dnEyQ1Rbyzl6T08DJqovnbjFNl8UhAvHyDCsa+eR5lcGsjv9Hbp/
	 ZklTydpEmNZqDF82uFA6YIHi9RHXt4jpvVHtT3e4aotJ2i3KbEoRAlD6TPx8PHp0Z+
	 gx/JWOyzryMiLqNieX+vARgfYp2bTHhSdnbgdRLJLxXsvr8RlsPAPPxscsTfQG8o5e
	 XP4GopOyQu7cQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:33 +0100
Subject: [PATCH v12 12/29] KVM: arm64: Factor SVE code out of
 fpsimd_lazy_switch_to_host()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-12-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2931; i=broonie@kernel.org;
 h=from:subject:message-id; bh=zkAz4EpB+oD/CW01W7HnqzjEzUv3OlXONmLnbiTh4s0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+rzBz3N89BPQyzmP/17vU4/T3AWJcfrSuhZ/
 JFYXNl0QY+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q8wAKCRAk1otyXVSH
 0LLAB/9PDxD2EnCQVkTX9BSFw4Z/rLLypJJ1H37bC7t2tQINmcPe1g+gvX2b31saVOqihuJIuZE
 d8HnWZ3cwTNGUASY96kURWvxgxQOo1tjSGxBBm+W8VlbbJFScB5K/bUu04HBWcqS9NMsvLz1Nol
 YfKgsEqeLAHRQt2ZUMNgd2t8kKlrWH01TU5VJlj4l/BFA02+MIsXJZZlUIA8m/j3YQ9PmyTOj67
 tsd8/0Tc4yWpeFvO8y+zjExEr+Qc65X1crRItdsT37BxRGSuJtgHtttOyLZc3W+8yRMhYDgHK62
 FjAug+GTVapgPtkQzZXNF9rmv3KYdxptrqw4v9Vc2pj2LrIo
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Since the function will grow as a result of adding SME support move the
SVE code out of fpsimd_lazy_switch_to_host(). No functional change, just
code motion.

Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 48 ++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 33729e218c0a..e444f0a94dcf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -519,11 +519,11 @@ static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
+static inline void sve_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	u64 zcr_el1, zcr_el2;
 
-	if (!guest_owns_fp_regs())
+	if (!vcpu_has_sve(vcpu))
 		return;
 
 	/*
@@ -534,29 +534,35 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 	 * synchronization event, we don't need an ISB here to avoid taking
 	 * traps for anything that was exposed to the guest.
 	 */
-	if (vcpu_has_sve(vcpu)) {
-		zcr_el1 = read_sysreg_el1(SYS_ZCR);
-		__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
+	zcr_el1 = read_sysreg_el1(SYS_ZCR);
+	__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
 
-		/*
-		 * The guest's state is always saved using the guest's max VL.
-		 * Ensure that the host has the guest's max VL active such that
-		 * the host can save the guest's state lazily, but don't
-		 * artificially restrict the host to the guest's max VL.
-		 */
-		if (has_vhe()) {
-			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
-			write_sysreg_el2(zcr_el2, SYS_ZCR);
-		} else {
-			zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
-			write_sysreg_el2(zcr_el2, SYS_ZCR);
-
-			zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
-			write_sysreg_el1(zcr_el1, SYS_ZCR);
-		}
+	/*
+	 * The guest's state is always saved using the guest's max VL.
+	 * Ensure that the host has the guest's max VL active such
+	 * that the host can save the guest's state lazily, but don't
+	 * artificially restrict the host to the guest's max VL.
+	 */
+	if (has_vhe()) {
+		zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+		write_sysreg_el2(zcr_el2, SYS_ZCR);
+	} else {
+		zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
+		write_sysreg_el2(zcr_el2, SYS_ZCR);
+
+		zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
+		write_sysreg_el1(zcr_el1, SYS_ZCR);
 	}
 }
 
+static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	if (!guest_owns_fp_regs())
+		return;
+
+	sve_lazy_switch_to_host(vcpu);
+}
+
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);

-- 
2.47.3

