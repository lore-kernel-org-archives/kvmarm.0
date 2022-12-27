Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E1528FA
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 14:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AECEC43392;
	Tue, 27 Dec 2022 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672151652;
	bh=0VmPixv/z9MoX7dbPQe6Ks2ec3GEJnabG7fqOP9O8EU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MetYWfq4dijiRiamm3h2fWX6aSVLc3XMJBVhdkJbW52Q5zKsmImob1jtFsQdnA0PK
	 8+6joeeGf8/xa/1YQWSRvmrso9ne1ID76SvU7Kxu4O9EZCUK8AGYO+KXKj+hEh3mWx
	 4yCmuRMpkK6ricVcEJlO8Qccd4PRH8Qogkfr91VZEkT5SiS0Kuxq19lI7ej53kNeT/
	 zHklPLp49f+ITgH6kJAkRrDzBbazr6arzsW+HTVOiYC3zeO0x9CYXwY81NnWvCUfHe
	 WNPVjFFMJG1o7AN/tEjMk3GGMtzRob8VQM44e8ATR/a4qJ8VKeO7Y+pwVw3CyFU9BJ
	 FE8sgGXgCeW+A==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 27 Dec 2022 14:33:39 +0000
Subject:
 [PATCH 2/3] KVM: arm64: Restructure check for SVE support in FP trap handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id:
 <20221214-kvm-arm64-sme-context-switch-v1-2-383b4699de06@kernel.org>
References:
 <20221214-kvm-arm64-sme-context-switch-v1-0-383b4699de06@kernel.org>
In-Reply-To:
 <20221214-kvm-arm64-sme-context-switch-v1-0-383b4699de06@kernel.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-7ab1d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1296; i=broonie@kernel.org;
 h=from:subject:message-id; bh=0VmPixv/z9MoX7dbPQe6Ks2ec3GEJnabG7fqOP9O8EU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjqwJbtUGSKmaVpocHwkyMsGn5Kc/N1KwOsVsjL+9v
 uss1GyWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY6sCWwAKCRAk1otyXVSH0ObpB/
 9o5V9dqtOgOLPlcmYP4Izi6mlT9RNEQqK2LkHEGBVDWvUT8vmT+0dACkjYZo61ew1K2Xx/MkuWin0i
 CLJaSSVkZjJXyoZcCseLKmaTfup0wDTsrtxB2UlRQFyt7n3bOU1COngpPHpoEYlq920K6GTxRclRBJ
 SgXEQQcQURk9Pqi0HTVIN3ecSGFCqPCfGp4AkTJh6XWtyz0SQ+DsrMSO9HTu5MYejaUhwneaeTHeFq
 qjhn5FOJnhTD1HcytsJNf6fYXwcxfvOzD8o04EjQoRCxHE+XXSvGLacbzyUu0Tu+3FdQNm09QhzsPn
 vbxPTSQ8SQgEofwKvvPljGSgoqmaBq
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

We share the same handler for general floating point and SVE traps with a
check to make sure we don't handle any SVE traps if the system doesn't
have SVE support. Since we will be adding SME support and wishing to handle
that along with other FP related traps rewrite the check to be more scalable
and a bit clearer too.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 3330d1b76bdd..009f4ce6c691 100644
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
