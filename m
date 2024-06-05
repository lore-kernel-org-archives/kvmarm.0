Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E49F9CD;
	Wed,  5 Jun 2024 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717611103; cv=none; b=Flw6KJlXCvfSnZdX/pPnhEP1Xq+trLfzB6d3OVpke+yfUoZK/Qu6Pg7s3lBWMFAcPSSWdTuL8gyy5CNs3/DXGgqq/r7G6u3221XAZv42VgI2plVZuvhm4visGIeGQij7cAmhS1PrC8EdCTqrhgEvkS225hWE8vG5N1PRaOyH4Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717611103; c=relaxed/simple;
	bh=f3jHF3DQLeniMwdJnPArbXhm6vAFBvlZF/ASACcvDG0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=oQS9MXJUNgtHypJYPMWXwXLmOH9ckgKzGtuzn39JJHttsV+3Z8edchS6MhBaenu+uoWzi5HnEyKJ4A5SumYuYtsbJKoI2ESACf2FX5rSfm3Dk7IntMhA8Kvh1tjh273x7eddv/foyrNH6iZpTt3nwJa7gPYc/80mBWub9XfkUYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EI/h+pc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EI/h+pc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5909C2BD11;
	Wed,  5 Jun 2024 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717611103;
	bh=f3jHF3DQLeniMwdJnPArbXhm6vAFBvlZF/ASACcvDG0=;
	h=From:Date:Subject:To:Cc:From;
	b=EI/h+pc/Rg+KltPi3ot0C9varPE+iPv6iQZ69G28l0NCIk0brWw1+DIaW/trDWkul
	 8/QL1nBwGhmKDoUz9d5kvlLmNO5/tkdUfrBgqrAux2x6nyam3RRzj+5L10VscqbHf9
	 YphVm66TICtmys6XX5hTet+trQOQmPiuHO5n+1xtJJxp0oI8Yckln0LZ6GDbl1lfa7
	 ScgoIEUtCM3cnsOzdY2+7oT2ORx/8C9o1AxayJZNEZlE3VtCwUePdWDyBA9FxZGfyU
	 GLK07x7ujHGC7+ghIJYj07p9G/596GF5hxxEV4nJjVJPiX8Qdt04ippVtPUFMcWpFx
	 I337GdXWH7bZg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 05 Jun 2024 19:11:11 +0100
Subject: [PATCH v2] KVM: arm64: Fix confusion in documentation for pKVM SME
 assert
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240605-kvm-arm64-sme-assert-v2-1-54391b0032f4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD6qYGYC/4WNQQ7CIBBFr9LM2jEUAdGV9zBdEJm2pLaYoSGah
 ruLvYDL95P3/gaJOFCCa7MBUw4pxKWCPDTwGN0yEAZfGaSQShihcMozOp6NwjQTulT9FbXzZ62
 9IusMVPXF1If3nr13lceQ1sif/SW3v/VPMLfYovYXe1LWC9Hb20S80PMYeYCulPIFvQoHiLkAA
 AA=
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=2300; i=broonie@kernel.org;
 h=from:subject:message-id; bh=f3jHF3DQLeniMwdJnPArbXhm6vAFBvlZF/ASACcvDG0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYKpb0eDhF689/ZULNIMjIg3Jlmh0IS4Dk4yvWVWF
 Sya7rKOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmCqWwAKCRAk1otyXVSH0FGTB/
 40EvVWN5zHhCC9uLx/WVX+6lq5NuBFkNPwNYx74uaUnVph5pxMAS3ZQ3/1iYTu8yQ6gAyKP1vasUUC
 uYDf9VvvrBBaNOUBxtwtpYPL+p2ug0E6Xgb5ihWPYL9rEHeICLDiyD1c9kuDBoLfV1opkJ37khTevq
 I5kszGj2C09Is8FqtEK4iHzwBXPM+5Fr8XCvH0N2nmBtFTZSSquHLFmJm7Z9jyvs5bMVaDMMyIaWZB
 KiGJGES70vn19yJl5NzEZ0RGg6U+srohuNBiI5qHtL2vdrPZYrkhT9jz4Z4w3lZ9Wr2FCzmcT5BXW0
 PJW5lfa9yUWANqSI+m3skccILb5EaJ
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
Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Commit message tweaks.
- Change the assert to WARN_ON_ONCE().
- Link to v1: https://lore.kernel.org/r/20240604-kvm-arm64-sme-assert-v1-1-5d98348d00f8@kernel.org
---
 arch/arm64/kvm/fpsimd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 521b32868d0d..820769567080 100644
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
base-commit: afb91f5f8ad7af172d993a34fde1947892408f53
change-id: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6

Best regards,
-- 
Mark Brown <broonie@kernel.org>

