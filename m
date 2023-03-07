Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B40BA3F
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 17:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53B7C433D2;
	Tue,  7 Mar 2023 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678210655;
	bh=5mNE6xh0Vfj3pO5ruV10bLVEjBC+XJt6k3jtfc6Ylu4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=J83Ml6vU5OMK8NTdUonDwlDLEe6Hrxh/UyACaXwzyTyOHGSN/Hz/ok9dqNAgyiNzJ
	 kNtY5q4mkveZ+FdMdewnB6nFgYj2Q7AryFZ+QTLN6PougrlCrmk6S1irCbhlGQY/PU
	 r1XdpgONE+WqHmDYUvJWRG9uJC2hTIaEzr9heT2dEfb1VqGj3R3ymkrHcpAsNhpxok
	 YMTso1aVCPe6eXuXc24+YkmyqlNeOpy4L/Qjovqy6vpPAax6d1wh8efRWpqXrf1Jtj
	 sUY2+5Rq59kj38LizWVLYrQC/x2e/uxbRY67/IPfuffxy8lbvcQvaKOG7xOavvDv9U
	 WPDSedRzAk9bg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 07 Mar 2023 17:37:15 +0000
Subject: [PATCH v2 2/3] KVM: arm64: Restructure check for SVE support in FP
 trap handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221214-kvm-arm64-sme-context-switch-v2-2-57ba0082e9ff@kernel.org>
References: <20221214-kvm-arm64-sme-context-switch-v2-0-57ba0082e9ff@kernel.org>
In-Reply-To: <20221214-kvm-arm64-sme-context-switch-v2-0-57ba0082e9ff@kernel.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=1349; i=broonie@kernel.org;
 h=from:subject:message-id; bh=5mNE6xh0Vfj3pO5ruV10bLVEjBC+XJt6k3jtfc6Ylu4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkB3ZWUark9O/+vfZtTDUcy+VHMXKkKXZ+t8JYg+jZ
 Gpl3JZaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZAd2VgAKCRAk1otyXVSH0Ir9B/
 9b33tlJfKmIXeqJVbhi+lNnVaFLdolC5vX6lm1K0jwkPWYOtLzY4w0BMF6l1LBPnZcYkKMUIfFUynI
 NHsw7qPEkSj0ElIl7Y90RWIlfNk1c+hrSD0RecsASLZkmSueubKIrwOUAVu7aMoREUaWETRQQgVNkx
 rRMvP2ERg7YtJR5jK9TgesPpyLBjo1WFM6fU7eguio4rF4TIpyzHaKDxZouKsgn22qvycM0VwKEuwm
 StCsVQDZe493wgt2s1xPbEPubJqaHA/N5DWxS8bW/241o9QU1+xNqvI+h/2NSFUtDlbRxqzmd7Ef1q
 DrmgbUn3zGOfnZjx5I3K7lTiPSEX3S
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

We share the same handler for general floating point and SVE traps with a
check to make sure we don't handle any SVE traps if the system doesn't
have SVE support. Since we will be adding SME support and wishing to handle
that along with other FP related traps rewrite the check to be more scalable
and a bit clearer too, ensuring we don't misidentify SME traps as SVE ones.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..d29d2ebf9126 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -176,9 +176,17 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	sve_guest = vcpu_has_sve(vcpu);
 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
 
-	/* Don't handle SVE traps for non-SVE vcpus here: */
-	if (!sve_guest && esr_ec != ESR_ELx_EC_FP_ASIMD)
+	/* Only handle traps the vCPU can support here: */
+	switch (esr_ec) {
+	case ESR_ELx_EC_FP_ASIMD:
+		break;
+	case ESR_ELx_EC_SVE:
+		if (!sve_guest)
+			return false;
+		break;
+	default:
 		return false;
+	}
 
 	/* Valid trap.  Switch the context: */
 

-- 
2.30.2

