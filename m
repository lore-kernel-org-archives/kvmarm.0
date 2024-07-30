Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640C363D;
	Tue, 30 Jul 2024 13:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722346403; cv=none; b=hqn9I4kx73xc2oZ2x8kRJQmGK3A3a+xmnKweSc2KFNdf3fncv4Y3UgtZflPF+44C/zUNxouzG0jHNRCCNM3PQW+2/jlxQGZye9rlulxy/x1pQmaTXieo0dIAqftJMLhVKatg9hsk5G51FDliYRO4AedDaLaDML98zxgMjvaYJ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722346403; c=relaxed/simple;
	bh=OzCJBlJRtJE62n4s3JpmBfVWloZEiZIoA/XCH81Aiog=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JcQ1Yya/CnBT0rf0v0U/WY/mKjOYerDAbptZCSt0IEOk34zxz80fFV0yGt1S+qYOqe1tZ+EgZ0/eXfhTh0svijXl5hoA71PYjMip1UwGeO40y/BgY41YC3j5ZO312L6H6e+aHrqz+CtfXUug11iaaG+ooCd45vBBA5NYIp1Yofg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gMZO/WkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gMZO/WkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE728C32782;
	Tue, 30 Jul 2024 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722346403;
	bh=OzCJBlJRtJE62n4s3JpmBfVWloZEiZIoA/XCH81Aiog=;
	h=From:Date:Subject:To:Cc:From;
	b=gMZO/WkWBoJwenk/iVd8EKuGmkkHC0dVVvC+6XjTB6pgjgS4WYnrjZpM/1SAQOcYu
	 Ojw5vJyqQCP4dz2dIcFkbcpkRM3cSReOsyCyFiU4aXpv2L+QmSLNl8e4+kbxqImy4b
	 0CDY79I3cdcZFMblfZ53cWShw0yObb0S4F/IOQePgtPg3LoAhOduJoWl0HwxPy2+bG
	 7Zv0d5qE5nS7N0hozi72GEFXHORxLBROMm0ELD1kyfLWkEawmm37vq/tOCARNqgJEf
	 zA5EykYmXKJlWu7GD670IB7xkysWX+uIsy0wLxmqq1qk77Rkinshiv/vaD3he3wZMv
	 nGoBP70pKMNvw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 30 Jul 2024 14:33:03 +0100
Subject: [PATCH v3] KVM: arm64: Fix confusion in documentation for pKVM SME
 assert
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240730-kvm-arm64-sme-assert-v3-1-8699454e5cb8@kernel.org>
X-B4-Tracking: v=1; b=H4sIAI7rqGYC/4XNTQ6CMBCG4auQrh3TnykWV97DuKh2gAYB05JGQ
 7i7hZUujMt3ku+ZmUUKniI7FjMLlHz045BD7Qp2a+3QEHiXm0kukZccoUs92NCXCLEnsDHvJ9D
 WHbR2SMaWLE8fgWr/3NjzJXfr4zSG1/YlifX6B0wCBGhXGYXGcV6bU0dhoPt+DA1bxSQ/Ff1Dk
 auCqhJXzpWs8UtZluUN/eGRuv8AAAA=
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=2488; i=broonie@kernel.org;
 h=from:subject:message-id; bh=OzCJBlJRtJE62n4s3JpmBfVWloZEiZIoA/XCH81Aiog=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmqOufdC7tv79b9MVzhVsrXtHEDRlNaY6Xjev9x7yb
 bsn+o06JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZqjrnwAKCRAk1otyXVSH0Pd5B/
 sEc0A3kbk2sDKyyxHoZzXfkXtbf5Xo7CfPJTOquLQ17eBMd9GRvv7ItBTPcRiJALI/43QjZICIgEhK
 DoxBkeqKyI5n7pe/566ubkwgxa7+q62YipbxNaQhbJ3EFQh+wS7ly+KyKNVUy2oPTG26+5n0LfzbvG
 54wv/uIWtNrjdCJnP1imw5P15deAN+FVNChQX3FrxUtKC9cCN4Z92QOl2h7VOQS51Kb4BKdD+EObEj
 jOL2kkQi16kpzdOIkRIAnqKqYy2+VOpgouvHMgx7H1kRb4Pxm80IyIEBxor8PBYdAZDPzzcXUwPfQU
 lbIPmdAKJMugiwijHxPOJftI0xPoMh
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
index c53e5b14038d..8eca6b338bb2 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -92,11 +92,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
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
base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
change-id: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

