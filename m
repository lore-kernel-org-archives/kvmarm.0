Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB24619D882;
	Mon, 10 Feb 2025 21:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223228; cv=none; b=MtyOMKm/mPJFHEaesDpvSdN1RX0XR/iarThu1bGDChwAL9OabNXi7ikCSOBQlvAJLGoUK7FZrc6iFi6P3IuL1JBj6IJ0YJlehi2EMa3PoqSSr2oJEa1U6XWkOh7J2j4neJbTWhemth8tNNfmkASwonNYILDkK04baTe37s8NCps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223228; c=relaxed/simple;
	bh=1drrGjPU44nrH4vEhvtFt2+xQt61WJAY+SI+N/d+RYI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=J0ofohVkBDxVayMIRdLFGe0DCoD2JFbs7FBdeWNYEijp/pDNRJm4yPuKWpjBjDZmROXgClTXi3E6My5LeB30H5d1Tny4f6dywWwAvpOOEj8l8aGldcdMj+DO0mv96bjzIghicXW5v4DIumXz9Qp68zaMGxGkG1XBEXsN947fCYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmG2C0je; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmG2C0je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4E3C4CED1;
	Mon, 10 Feb 2025 21:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739223227;
	bh=1drrGjPU44nrH4vEhvtFt2+xQt61WJAY+SI+N/d+RYI=;
	h=From:Date:Subject:To:Cc:From;
	b=mmG2C0jeXE/CmSjuTtgvhykEJM34pFG7DAzLJHNLh8v+OoLq0J4WFolOo4zcbd3o/
	 ouefM9vIw85T+xWG2N67yQFZftsZ2mo2hufZ3Hj9fBzWaIYUab6QYSpVwOrgJNjFL9
	 tDSUyIF2vIWbqkErpzUQlR9rcFke9DGiYXzekLvpTZwEB30yN47RWMrBnRQ4JDT5zN
	 0L9BK4dnHz/q24yJPrNiKNSGMQ8TNIY+TzUOEWbdJTUsCiOlujdD3n4qFRlKlKa/oK
	 fHoJz8aJpJDaZgwomMKm5pWiyadmVAJAu0WUCtgavX4Tll802OXKyeLzh9M3GE2tkY
	 aW41wjqNyqHOA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 10 Feb 2025 21:33:32 +0000
Subject: [PATCH v6] KVM: arm64: Fix confusion in documentation for pKVM SME
 assert
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250210-kvm-arm64-sme-assert-v6-1-cc26c46d1b43@kernel.org>
X-B4-Tracking: v=1; b=H4sIAKtwqmcC/4XOTWrDMBAF4KsEraugnxlZyqr3KF3I1jgRqe0iB
 dESfPfIWSQpxnT5Bt735soypUiZHXZXlqjEHKexBvO2Y93Jj0fiMdTMlFAgjAB+LgP3aTDA80D
 c59q/cPShQQxA1htWq9+J+vhzZz8+az7FfJnS732lyOX6D1gklxyDsxpsEKK372dKI33tp3Rki
 1jUq4IbiloU0E62QmjVw0rRT6XRYkPRVbHGOUAg7Nr1L/BU3KYCVdGdC30jQ2vsWsGHIpXcUrA
 qzmFnQ5BCYftHmef5BiTHWX7RAQAA
X-Change-ID: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>, Mark Brown <broonie@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3413; i=broonie@kernel.org;
 h=from:subject:message-id; bh=1drrGjPU44nrH4vEhvtFt2+xQt61WJAY+SI+N/d+RYI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBnqnC43KKyMdIxyNNobIHVoI2JQC7uPgVNQ/dl5F3p
 CqbB6wOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ6pwuAAKCRAk1otyXVSH0A53B/
 4r8V5baaTij1dC0zc+elLFiunWYoPKygp7SljVQVt7tJ6OZ7KAXuWorppwOIG53GLBGoSTmLXWpFfu
 /+cw93KAqqZylfxwmY7gM4UTWb8IelfkUgdiq3kZUz7YaZZMGD3NHr2WUdJZ7ImUHkvyrnC0XIq8++
 vzhkfUlhmU+8x8pAn3+XNTDhnlAI/aEGtlLl/+E0oZrWUZWevnVW8PRPvKeij/VHtBt8ZJaDfkXpWb
 JrCj8ZrKAkg4JA8wUPD/wrmB5Y9YdTc4xP7l+8HiEW/hFr/1KTJ00REz/nLlOppMxDM2biQrwPgigg
 TVDtfubygHXOum7KtekJbAsH6sbibu
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
This has been sent with v6.10 with only positive review comments after
the first revision, if there is some issue with the change please share
it.

To: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
To: James Morse <james.morse@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
---
Changes in v6:
- Rebase onto v6.14-rc1.
- Link to v5: https://lore.kernel.org/r/20241210-kvm-arm64-sme-assert-v5-1-995c8dd1025b@kernel.org

Changes in v5:
- Rebase onto v6.13-rc1.
- Link to v4: https://lore.kernel.org/r/20240930-kvm-arm64-sme-assert-v4-1-3c9df71db688@kernel.org

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
index 4d3d1a2eb157047b4b2488e9c4ffaabc6f5a0818..f3455641e9c8a65470cdeb9d7daba7d59d78748e 100644
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
base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
change-id: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

