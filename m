Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14AABA42
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 17:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D89C433EF;
	Tue,  7 Mar 2023 17:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678210653;
	bh=x22sJhiaAKgC3e22vpI6rgIDRactCQlxUy+3uW+4NbU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kq+XOuuU6z/dBICeAMrVGNjsSMuwO05WWO4bhqONFYaSGHxV9Igc4wYY9KNyVl93s
	 fT7Xadbz0RXgEEGR6w8stjq7AFM0N6nfBmCitUGqunq+yEJ1UCrR1OJMbawQqPacEf
	 xk14ai2NmNkIWt621lHmSMgQEyMXjFxiFvuDMMOP/buIXUTTut0HD2iSXSB24IeRWX
	 fOROgN+1IPVQTS6vOjpGFDpCoDWR4dwgzUr5xtjDiLl/QJpzrcSKtb9V03wz9aMtNP
	 q64rrsqOnPgRoGcCZPWz8CqC4dXszsFJXKWphtwZLtJWidfDVN84jhVCJ4ATZhOL9K
	 tXAqRpjVEDPsg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 07 Mar 2023 17:37:14 +0000
Subject: [PATCH v2 1/3] KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221214-kvm-arm64-sme-context-switch-v2-1-57ba0082e9ff@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1080; i=broonie@kernel.org;
 h=from:subject:message-id; bh=x22sJhiaAKgC3e22vpI6rgIDRactCQlxUy+3uW+4NbU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkB3ZWLxFY9O9s2NrvFEI+zEd3fQgVAvCi9wnkjHdj
 EVD7cHmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZAd2VgAKCRAk1otyXVSH0AyACA
 CCJvuacL9tm8DWLDCwZmAPD+UzQkRrkBQJMm6PXaDubwFUCnZv/zZCGBCeJrmA5niabOODjSO2PFya
 eHf4NufVGFbgM9sxmrx/XxDEfTGiZnZiLO0Tit/Wcj2cBVyX4UnpV5lcN7zcXrrEMyP4Q57DRi8+Re
 E+L3xV5HMfOYNTr2W2hvIaFVXQa5OKvdU217wWGQw99hzs+BCe6KxJ5+CiQ+7PTItbxvy6mMyCItJS
 ANu4+ji2Yuz8JTSE/hTwy3gtkW8YfUimwyD40PLmyFEZaym0tYaK9XyNpjiFFH80d8EppajNIB76ao
 u4+NEs3f0QikJwFiZ+KprfJcvCo8fv
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In kvm_arch_vcpu_load_fp() we unconditionally set the current FP state
to FP_STATE_HOST_OWNED, this will be overridden to FP_STATE_NONE if
TIF_FOREIGN_FPSTATE is set but the check is deferred until
kvm_arch_vcpu_ctxflush_fp() where we are no longer preemptable. Add a
comment to this effect to help avoid people being concerned about the
lack of a check and discover where the check is done.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 1279949599b5..3fd0ce6a3500 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -81,6 +81,11 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 
 	fpsimd_kvm_prepare();
 
+	/*
+	 * We will check TIF_FOREIGN_FPSTATE just before entering the
+	 * guest in kvm_arch_vcpu_ctxflush_fp() and override this to
+	 * FP_STATE_FREE if the flag set.
+	 */
 	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);

-- 
2.30.2

