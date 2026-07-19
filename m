Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46A7381AE9;
	Sun, 19 Jul 2026 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502664; cv=none; b=LoifNvP07Ohnho7PGOV7EDTcv1razXpGtQ35e7ZdIQbctc3/et1tHCjJG2jCn3pgmspSvZGgmxln49FonBKr5/F+C9QW87RBYlkcQxDZ3AQ8AVQysCPMwBn8fgXInMVlJrG/B8bgfxMzsLdq8732wMGNTCZILxCsHRrBm6viNvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502664; c=relaxed/simple;
	bh=bJ6/1BPMmH6cmZPVFQnhedk6wX18ttIgJVNhwPNun9Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iNkcYvXsFF/BeEIAc2FvHdqhx0sMK1fv2+/S41Kn68a73JQMIE0GZTNf2W8/2bdpXlJs/tD47VhyujE6Agn6Ej3+gGRYt/4L364NUqMRF8XniSrm52ndtx5VLoNh8JGIExuXdiOAoEADZRSZ+NwzVIVTI0jw+SSjqnhZ+adyWYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glRgAns1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glRgAns1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914CC1F00ADF;
	Sun, 19 Jul 2026 23:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502662;
	bh=9uIaB06tZng9peZX4GAyF9EMCE3RvorRheB3h8LExDA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=glRgAns12r4ZtTb+IfvaIncB3CwZ8YtWt5cAQQi1og/rYhiVyWW01tUPMW4S+GdYO
	 Y/29w6lrklV3fHrCoYQHLO6H3wn4EV+x2rqhzixo5jSIC+8ZzB8wmmBwEfY0K9xcA1
	 fh5FwteBF8zc8E1WxwBh1PNz/8pbKxbaxXq86I1rQdQ+OUlG9wlsTsO62Ox6uNajO3
	 ZKHNr/Cz2dR3ie63Zirs/ctbqgD2H+D8MgcyCepuyCCtzllQwz4MbXlYcgrIRiHbDd
	 yqG+Om8RiJWWWF4EQ1fawxb108WcznoXZEfH/EwYEhl1JmJRAM1MGlj3kFt/qkusZv
	 FRIp0UrrG/+Cw==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:42 +0100
Subject: [PATCH v13 15/32] KVM: arm64: Factor SVE code out of
 fpsimd_lazy_switch_to_host()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-15-d9abd3ffa245@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2931; i=broonie@kernel.org;
 h=from:subject:message-id; bh=bJ6/1BPMmH6cmZPVFQnhedk6wX18ttIgJVNhwPNun9Q=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVkzHZ4fRCHElMqfCb5+rQ+Li82PCjHzy8RfL
 AW6xr2OGaKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZMwAKCRAk1otyXVSH
 0HJdB/9MAtlVIPjFw6KwuvU2d3bKxxeGEzGE+PLj2Jxi4YenzXTNyLkRRvrTSujosJY6u/vRjQ+
 6zDxvphe0kxQoQGbM4hd531iZYT34MLqIKyj4IY2zxCHJO6EE8Nm4Abhv4SEb6GuYdD/zGHoA1q
 7BwB7pD/11LyRyYQgs87Yic/LQI2SFTXwyKZAeopVQrcuqL0qJiYoVItpu0FhgO7yxLe6GPdAeP
 Av6teNKTLsokTL9QyrG2QBUEDO/qpSNKC1jI8W37ws+GLFECXhgbrJZpQoJs5BLwsYXwVxqnFfb
 L6SkEBdAvLxHesavtPF6ffpAK8RoXoPlgZx+iLjvGZlobFdz
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
index 35e8d952c7b6..ce586110c226 100644
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

