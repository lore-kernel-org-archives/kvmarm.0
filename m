Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58766168488;
	Mon, 30 Sep 2024 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727726540; cv=none; b=JJlJzS3jt00wGbY7zcHv21dd1unu0X6P75rOtgHFDnMI53jmIe6fQnPJ+pwMvzHIOE/MYNYI3GcMSwftA7atEFsY6e/AJgEBJINlEfyLMBZBqHAT+X0BSLK1rBq3b+IGaiwuRMWCNsIxkB3xviIV3MzQitfvj7+ixM8shUt3mUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727726540; c=relaxed/simple;
	bh=9QLOa/TQi7lR+XJ+LawxAWx/A8C/LVBvDC8G9OxcET8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=iRj8syNE4KVPCfz91NzIwf5oTFW4KtsnoSEiqUNOdWYq9r/UWkrpRDiMn49f3qSE87DwOf0nYg4DafM/suyGmPhUS6Qcreen28aQS8mDTBymNsBCAqEpXH77Q89onIPQTU1ReYbqbYsZt/Z/32yttbsPqm+lF6RZ6gxMIFTfpnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQ2YWLsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQ2YWLsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF62AC4CECD;
	Mon, 30 Sep 2024 20:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727726539;
	bh=9QLOa/TQi7lR+XJ+LawxAWx/A8C/LVBvDC8G9OxcET8=;
	h=From:Date:Subject:To:Cc:From;
	b=QQ2YWLsX3ueDajhEnXyMWoBBGAX23cIRKnhaTUGB1yHqVLXg/BLicPTYZp+muqT1y
	 XSTfV6IuLURDetyTT2n0hhTbSCjEV9+av8PqJbz6KV6zAWzMuji/O4GeTjK7pMoA/i
	 hGi8TAwQv6AL/l90pDrbv30sZwIUcaYSqqhQUXauAJ0BBiRlrxUmodTueOLixHQjNA
	 um6CXzBsc0BQxznWInFhfJV17upuwhyd05Rr0RZ5H9sF4KVR0jJbuRYxwYroT4BWy+
	 qyRDiTtY8NNPQ1aAoLYh7FA3aQBfn6JX39jNpDBDXDY0aw+kb2Y4XUpT7mJIpoEmi/
	 lW1Q+hVqXLEOQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 30 Sep 2024 21:02:04 +0100
Subject: [PATCH v4] KVM: arm64: Fix confusion in documentation for pKVM SME
 assert
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240930-kvm-arm64-sme-assert-v4-1-3c9df71db688@kernel.org>
X-B4-Tracking: v=1; b=H4sIALsD+2YC/4XOQQ6CMBAF0KuQrq0p7RSKK+9hXBQ6QIOAaUmjI
 dzdwkaNIS7/JP/9mYlHZ9GTUzITh8F6Ow4xwCEhVauHBqk1MRPOOLCMAe1CT7XrM6C+R6p97E9
 UapNLaQCVzkis3h3W9rGxl2vMrfXT6J7bSkjX6x8wpDSl0hRKgDKM1ercoRvwdhxdQ1Yx8E9F7
 ih8VUAUacmY4DX8KOKt5ILtKCIqKisKkICyKr9/WZblBbGLZ+NFAQAA
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=openpgp-sha256; l=2717; i=broonie@kernel.org;
 h=from:subject:message-id; bh=9QLOa/TQi7lR+XJ+LawxAWx/A8C/LVBvDC8G9OxcET8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBm+wPHrpL2ZXNqc4NnavNhLe4f/lNGtPo60qn5Z9gM
 GpYr7+CJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZvsDxwAKCRAk1otyXVSH0D/yB/
 wNGk1Zcr4S98KVGltp4VROk5qXQlS19eOBb7ijfYZNcEfOkmheZpc1maxdJh+Y+f45R9r7JvTtdYsA
 DH13NrRsDvjh/LGNISFR9EXst+La55VJOSpDSKVZ22ckOn3EYr8kh5ahPp6djQbeQONlPMDv0pTzKt
 eFb27+s6icmzDJeb0SSiDDkv+KGqvVQLPW86qOZ5Ev/4NG4UxMxDk+67DAjyeT9ScPMAIpUZjwzbgz
 oTkszWm/AP6vOLENMc/tOqAGjB3U+B/sQ9Vnd05SVm7Y8IPd4iFzSaQAM8wtz71vqNqR3GUnAuVxmQ
 ClA5ag7kC5Ehp8sD9C79iTMZnfwcT/
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As raised in the review comments for the original patch the assert and
comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
disabled in protected mode") are bogus. The comments says that we check
that we do not have SME enabled for a pKVM guest but the assert actually
checks to see if the host has anything set in SVCR which is unrelated to
the guest features or state, regardless of if those guests are protected
or not. This check is also made in the hypervisor, it will refuse to run
a guest if the check fails, so it appears that the assert here is
intended to improve diagnostics.

Update the comment to reflect the check in the code, and to clarify that
we do actually enforce this in the hypervisor. While we're here also
update to use a WARN_ON_ONCE() to avoid log spam if this triggers.

Fixes: afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are disabled in protected mode")
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
This has gone more than a kernel release with only positive review
comments...
---
Changes in v4:
- Rebase onto v6.12-rc1
- Link to v3: https://lore.kernel.org/r/20240730-kvm-arm64-sme-assert-v3-1-8699454e5cb8@kernel.org

Changes in v3:
- Rebase onto v6.11-rc1.
- Link to v2: https://lore.kernel.org/r/20240605-kvm-arm64-sme-assert-v2-1-54391b0032f4@kernel.org

Changes in v2:
- Commit message tweaks.
- Change the assert to WARN_ON_ONCE().
- Link to v1: https://lore.kernel.org/r/20240604-kvm-arm64-sme-assert-v1-1-5d98348d00f8@kernel.org
---
 arch/arm64/kvm/fpsimd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ea5484ce1f3b..5fb9b3fc61ec 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -93,11 +93,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * If normal guests gain SME support, maintain this behavior for pKVM
-	 * guests, which don't support SME.
+	 * The pKVM hypervisor does not yet understand how to save or
+	 * restore SME state for the host so double check that if we
+	 * are running with pKVM we have disabled SME.  The hypervisor
+	 * enforces this when the guest is run, this check is for
+	 * clearer diagnostics.
 	 */
-	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
-		read_sysreg_s(SYS_SVCR));
+	WARN_ON_ONCE(is_protected_kvm_enabled() && system_supports_sme() &&
+		     read_sysreg_s(SYS_SVCR));
 }
 
 /*

---
base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
change-id: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

