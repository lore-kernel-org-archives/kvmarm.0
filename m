Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F467B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 20:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D294AC433D6;
	Thu, 27 Oct 2022 20:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666904091;
	bh=+pTnUy/mTIc+OeLTV3Ks3EjJ1S8TA0xkhfJ8yhGCzU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIC2640IYVv15RcqrQMHfIQSN0XKIN+vyC076MvYKzkDUlHrqKtpDE40OkoKjjhD0
	 iT/UwbmdWpSKo7iPHv9uNFMftHUvbcEz/i5GMrsXGf8Dcd18CQy4KEgDCjewV7GS9K
	 hkUgJRvkWFLfRJ+Z9z7LV2gpNHhw3HOi6OOuE0dAn2ydRuSM7K7CZzECKdRGKUTQQM
	 qRP1Z4Jdfqc2GKPMhl73d9ddk8giI4C/jQQs+EvwN5CJWlNLFjmrUeo3Skkt98G8oE
	 Xqv79AKYeK/gtiSnswsmVNnRZwZQXf0lCQUV0pFwCsMUHfW5Ca97d832bTHVr62gHb
	 2sdgm5XxJfyvQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 2/2] KVM: arm: Refuse to enable KVM on systems with FEAT_SME but not FEAT_FGT
Date: Thu, 27 Oct 2022 21:52:46 +0100
Message-Id: <20221027205246.812586-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221027205246.812586-1-broonie@kernel.org>
References: <20221027205246.812586-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1620; i=broonie@kernel.org; h=from:subject; bh=+pTnUy/mTIc+OeLTV3Ks3EjJ1S8TA0xkhfJ8yhGCzU0=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjWu+eqllgJ302OsXNofBTqSr/EO5cloDdca11cBSB IEpZkouJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1rvngAKCRAk1otyXVSH0LjRCA CBLgMJwF7VjgdS1unHbRyI/pof7SOn9L7zSZlISKoveyLz9E2WKRAqPmVObUyaQB6ZloQCerSAqSo0 rfIuHOZXSPbt+UnrQrF3lUGpEIuzK5y093FwSbp9ud4OE29P+NYnbna/9eeMFp1oexmkOH0ebLTgbe ONr5k9gtf3DHuoPJ3XtTHT0OaGuXj2/crgpFfqLtDtCg2egNSycOiupcJhBT7/i0R2SqvXe2rHmm6R 3R6aDp+Uwc6ICNgZmZbpbtIn4ZEqvogeV9/L2TOpD1E5mexnZnpeW43zQtyaAYGXilVedwmz3MWiV/ GaUnXJP1jhK55BeqMwcFdysPQp53vi
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

The architecture requires that any system which implements SME also has
fine grained traps since SME is a v9.2 feature, meaning that v8.7 must be
implemented, and FGT is mandatory from v8.6. Virtualisation support for
SME relies on fine grained traps to control access to SMPRI_EL1 and in
nVHE mode to TPIDR2_EL0, without traps SMPRI_EL1.Priority and TPIDR2_EL0
can be used as side channels even if SME support is not exposed to the
guest.

Reported-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/arm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..4662407ee789 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2183,6 +2183,21 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	/*
+	 * SME without fine grained traps is an architecturally
+	 * invalid configuration since SME is a v9.2 feature and FGT
+	 * is required from v8.6 but virtual platforms have been
+	 * encountered which don't respect this. Without FGT we can't
+	 * trap access to TPIDR2_EL0 in nVHE mode or SMPRI_EL1 in any
+	 * mode, making this conditional in the code would lead to
+	 * side channels on these out of spec systems.
+	 */
+	if (cpus_have_final_cap(ARM64_SME) &&
+	    !cpus_have_final_cap(ARM64_HAS_FGT)) {
+		kvm_err("KVM disabled since system has SME without FGT\n");
+		return -ENODEV;
+	}
+
 	if (kvm_get_mode() == KVM_MODE_NONE) {
 		kvm_info("KVM disabled from command line\n");
 		return -ENODEV;
-- 
2.30.2

