Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B50D1EE03B;
	Tue, 25 Mar 2025 18:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928567; cv=none; b=PL9e0rGgXxtPcDvuJSHRW+ey884z9zNG501TNl3Vi5I9ItZfrifirjIn4AqA8a7jDcs9trI/rwH0LpadW7eoSw5Kj4o3sICbTin0Gxuwee91JmtoDj6EPc40v3fDIjllyJRek9O+6NfJzRmpLXZW/zI+lTbLmXbWs69rAL+Nxho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928567; c=relaxed/simple;
	bh=0wZD1ab5TO+w2Ej5vIOOKImo8bpRJRJoaeHESF6d4s4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h0hOFHV5NGJ3VbBakG7irrReGL6ScX1w4ucBlswsnbNjXPvWsd82M+Kw3k4FnknSdE4SrTGqZBs2jsB+1Hs9M9WDmybOmOeQewchJEr3AOhvF+hwc4YdvgdjcVZgZxN4BFg4ysdDI0fFs2d3nvN54yIGaWuRmoOyfebZioQjXo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQ3BM6xZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQ3BM6xZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B756C4CEED;
	Tue, 25 Mar 2025 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928567;
	bh=0wZD1ab5TO+w2Ej5vIOOKImo8bpRJRJoaeHESF6d4s4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uQ3BM6xZepRTGPPK2Qde1EkIB7IwgpIVmiZzx1dxkSPnuvwyy+gtW8WzvZeZ9i8MJ
	 zUm1638yX1w0yU9O2BvKzRmVJdnbo+sFJZFru1L9r5Xw2HXwtRDD8TRp+IH8z/8n5b
	 m1sNBTGVLsI1zoZTKZS2262+P7xYd20vbmOyaeyl9O/knN/3LOnr0ZOiPgx9ZMQycp
	 zX4kQ0NvhFJ17uZmEIygSg9/FlVmNRQ6yllxmirvaBzpcCGS0PKJFqiI1MupZ4Nwv9
	 2nT7oF1CK8RBluc7EPO7uTTiIorbtsuwimpCwIP+bRNj4JcuTeXvM594svAzBUjIoQ
	 46iqXoLzxM46w==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 25 Mar 2025 18:48:15 +0000
Subject: [PATCH 6.1 01/12] KVM: arm64: Discard any SVE state when entering
 KVM guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250325-stable-sve-6-1-v1-1-83259d427d84@kernel.org>
References: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
In-Reply-To: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3615; i=broonie@kernel.org;
 h=from:subject:message-id; bh=0wZD1ab5TO+w2Ej5vIOOKImo8bpRJRJoaeHESF6d4s4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn4vqmXOmzyfYfFmo1l4WAEnJzOI3rteuXYec1pLdd
 ewvqq7qJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+L6pgAKCRAk1otyXVSH0E5cB/
 4ifaIngkyoUUP5qxoc9RuZTmxVgeC+XqbQNlO0NdZ3NvpJRsSojOptus30VHnBgvJx+2g4BiE0AulL
 BtBrMr6JnF690NmTMjjdyKUkTThSsQ+uGexsNK2davGm096nvzayXyzH3li0ZspDdXBqPHeWyk38hy
 oNSiyEX3oRjA2ouYbG5NzE+5P2TyjvdnBquGJzU54CrOAmoAnhN3essfZopVY1cBsQGecosfHs9ThC
 KCg9hXRO5ET/+HqKsF+GDLM8oMOB/epK38rIkso/kDn7sAdaQTr1Ps8WYcMTns+q5e2vw6dDsAp6dT
 Mcpje4+NHagHHv5KkFai9GIsInibZ+
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

[ Upstream commit 93ae6b01bafee8fa385aa25ee7ebdb40057f6abe ]

Since 8383741ab2e773a99 (KVM: arm64: Get rid of host SVE tracking/saving)
KVM has not tracked the host SVE state, relying on the fact that we
currently disable SVE whenever we perform a syscall. This may not be true
in future since performance optimisation may result in us keeping SVE
enabled in order to avoid needing to take access traps to reenable it.
Handle this by clearing TIF_SVE and converting the stored task state to
FPSIMD format when preparing to run the guest.  This is done with a new
call fpsimd_kvm_prepare() to keep the direct state manipulation
functions internal to fpsimd.c.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-2-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport to v6.1 ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  1 +
 arch/arm64/kernel/fpsimd.c      | 23 +++++++++++++++++++++++
 arch/arm64/kvm/fpsimd.c         |  3 ++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 930b0e6c94622a0ce446577b397ff9ba3f2f60e8..3544dfcc67a1eccc12bdff22347e40c378f4ca6b 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -56,6 +56,7 @@ extern void fpsimd_signal_preserve_current_state(void);
 extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
+extern void fpsimd_kvm_prepare(void);
 
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 43afe07c74fdf86b8f4497058db40a58158b9bd8..1dc4254a99f25289278b83965946e09674ad4e75 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1643,6 +1643,29 @@ void fpsimd_signal_preserve_current_state(void)
 		sve_to_fpsimd(current);
 }
 
+/*
+ * Called by KVM when entering the guest.
+ */
+void fpsimd_kvm_prepare(void)
+{
+	if (!system_supports_sve())
+		return;
+
+	/*
+	 * KVM does not save host SVE state since we can only enter
+	 * the guest from a syscall so the ABI means that only the
+	 * non-saved SVE state needs to be saved.  If we have left
+	 * SVE enabled for performance reasons then update the task
+	 * state to be FPSIMD only.
+	 */
+	get_cpu_fpsimd_context();
+
+	if (test_and_clear_thread_flag(TIF_SVE))
+		sve_to_fpsimd(current);
+
+	put_cpu_fpsimd_context();
+}
+
 /*
  * Associate current's FPSIMD context with this cpu
  * The caller must have ownership of the cpu FPSIMD context before calling
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ec8e4494873d412382a795691220fe55d229858e..51ca78b31b95241bb8186a473d1bf5ccd50a16f0 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -75,11 +75,12 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(!current->mm);
-	BUG_ON(test_thread_flag(TIF_SVE));
 
 	if (!system_supports_fpsimd())
 		return;
 
+	fpsimd_kvm_prepare();
+
 	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);

-- 
2.39.5

