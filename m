Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D1041D10A;
	Fri, 31 Jul 2026 12:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501465; cv=none; b=Ot+1UYMJQk86ACRPWVflLOdyWN3MfO++0yvdYJGDGYJNUrUc0NQCxYjqW+1Wnibe31UE4fUvOjfSpGWxuzJMdoiy8JbidSUlOY+hZoexySy7hkFeVV0Rxm5OqmfR9LnZzboAd12KQJ7Mj/DwNyHOU2moTIj91trqE5cFZCAEO6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501465; c=relaxed/simple;
	bh=bEpjQNbOqRXEgxmuuFHddb+wqn5p6+xc/jGJ7dQCByg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rlGzBCkru6yjHz4IW/oLLfRasIGYSdu/POrqhR5rqaQrmF4R7dGzbk+a7v6YNNGu+Y30DgQNs6uTAakl4nZ9+RE6X392p9yPkfOU7tOV7aA6vblIMx2ZvhAuodm91F61HKeR1dVzR4F/KpTcH5XBjAjQ0xHORcNcnADP+3ZZ6JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvZuRBse; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvZuRBse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C167C1F000E9;
	Fri, 31 Jul 2026 12:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501463;
	bh=PurQYqXf08AEX6gtFWKWTzYSPvMtTxS5SqC4IO0OrWI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IvZuRBseiMZeZid3Ez4Wg8ouliH2Y/c/7A6HfLiMYOAecPVvp4XKerZbET645nS8/
	 b15FXl+MkqVuI5FAprVQyL8Kih5Pg7z5/kiv8VFlm9hNF4E6yo65ufRdgftdyoMsdR
	 kZm0hdkW4V5Wm4vy1h0U2cQQDNl5A2IdUKOSFR2uYGtE+Lgyp2AmVRKThLw0Dug8XU
	 h8REnHXy7gwZREmAMfjeLboT8coC1j7IsyZKU0IYdu8uPxr4lSQg8gzVUWyE0k/15r
	 QNkSeasQrp3Z1reMb07TKfjuKycqUOOBbaFpp0bPUMKNuTZorOGHrhdYbfVA6/qWYi
	 F1wnto981QXLg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 13:25:42 +0100
Subject: [PATCH v17 04/14] KVM: arm64: Ensure GCS memory effects are
 visible
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-arm64-gcs-v17-4-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2294; i=broonie@kernel.org;
 h=from:subject:message-id; bh=bEpjQNbOqRXEgxmuuFHddb+wqn5p6+xc/jGJ7dQCByg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbJb+R01OOsal+xbQZ4zitFjmYGaROWyMm1zFz
 nTLuGw1HoeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamyW/gAKCRAk1otyXVSH
 0EVJB/45IHwz21v1tmIL8Qxbj/4drDYdtDlyAC/PUcC1mGWxzUZgOjqeIbfn5TmFt7itKiZFqZ0
 AP64owXE404SDC82O+AZNn8pd3cKMREZeIy4KmY9D3abJMJXvKouvpDh9DigD+JJ5m9QDOOt8eE
 jqhossDi99eBF5dZgx0iwHsw/fPulOaIc/VTYrgtIdKettyCIIbd+GxsyGTlGpGEIozM8h2esDn
 jMlOwDcp6bteGJZizKF/W34PhZtC+VK9k6WSLrwKdGKGMQIPuboONr2ikEKTB64fDkyv78rf+Ea
 Sgy1yHC1TV6YGpqIS+Pgd4IZKfjn4SxQtx/hC4rGIvNo2S1Y
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to allow efficient implementation of GCS implementations are
permitted to do GCS specific caching, with barriers implicit in stack
switch operations and GCSB DSYNC as an explicit barrier.  Since we do
not use GCS in the hypervisor or host kernel the hypervisor cannot rely
on any barriers being present in vCPU context switches other than those
it explicitly inserts.  Add explicit barriers when loading and saving
vCPU state.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/switch.c   | 13 +++++++++++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 14 ++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7318e3e6a5f3..fe8727bf2833 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -301,6 +301,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	dsb(nsh);
 
+	/*
+	 * Ensure any GCS memory effects are visible to this CPU.
+	 */
+	if (ctxt_has_gcs(guest_ctxt))
+		gcsb_dsync();
+
 	__kvm_adjust_pc(vcpu);
 
 	/*
@@ -345,6 +351,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	dsb(nsh);
 
+	/*
+	 * Ensure any GCS memory effects from the outgoing vCPU are
+	 * visible elsewhere.
+	 */
+	if (ctxt_has_gcs(guest_ctxt))
+		gcsb_dsync();
+
 	__deactivate_traps(vcpu);
 	__load_host_stage2();
 
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 2431c18f5792..4594992b008c 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -239,6 +239,13 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 	if (vcpu_has_nv(vcpu))
 		dsb(nsh);
 
+	/*
+	 * Ensure any GCS memory effects are visible to the incoming
+	 * vCPU.
+	 */
+	if (ctxt_has_gcs(guest_ctxt))
+		gcsb_dsync();
+
 	/*
 	 * Load guest EL1 and user state
 	 *
@@ -299,5 +306,12 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
 
+	/*
+	 * Ensure any GCS memory effects from the outgoing vCPU are
+	 * visible elsewhere.
+	 */
+	if (ctxt_has_gcs(guest_ctxt))
+		gcsb_dsync();
+
 	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
 }

-- 
2.47.3

