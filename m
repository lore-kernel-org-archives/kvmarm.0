Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F28231C9B;
	Fri,  4 Oct 2024 23:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728084018; cv=none; b=FNgAOZPQd/gld7kgTudVdyZU8lyh3+WGntLnY4xKJY5ciT27aSUrSmdsTRh22L0dIVqcU2w7h8/ykBmYePIXt6RQ5ODYsyH2bUDqu1lwy8GyUd/XgnSHA4xiMeY4Gmiafh8NBnSj7rWHePWW/bTwsk6nf0qD4ULdaSt6Wfk+czk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728084018; c=relaxed/simple;
	bh=B+4iUDEw9TYIVwLvNxtIxnldk76z5iKCVi04UblglX0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=tRqqnE/sYsHRMG3L/IxguYiAqcEXVnTq1DeZgNKUHr5R24RBhGOlRZFOS8anM8oV95rqUVn+nM2NYY69rF/X/yG7trZxq6uuSmyAeP1wxhYoIEZ2nFRKes3qjAKQULRbk+/d2frHOtGAJMVwFUJz75krcc297KeLnP6C9qYFKyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/QzDYNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/QzDYNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCA9C4CEC6;
	Fri,  4 Oct 2024 23:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728084017;
	bh=B+4iUDEw9TYIVwLvNxtIxnldk76z5iKCVi04UblglX0=;
	h=From:Date:Subject:To:Cc:From;
	b=l/QzDYNCQd+WcAHHEAagG146wy7AxW66s3O84md+Me5F5Kw3QRjGlM4eauiFD7/t9
	 zqlceXVUg7qlz44RJpugiPuhy3VbaE24sO0ngVIHFRW0d0RkXOHgO+nhct/7gWczu9
	 ci03kMkIhfewR1RleKEocHAHxMN5llaAsIET8RvpJyRz3B9oiYM1updyJnjyppFVO6
	 M/CT5J4h9dWo15tmgBSVOjysgZFI/u6GcS4IHYqlTFdZubGvcLpfuURRWr0vN5BblQ
	 nEAceWF6XMnxgZoxrR0VXQL0zzzDEtQotPBVkc9uds373DtNLFzfnbMaJijwVk7CY/
	 ygZBFtuPrSXwA==
From: Mark Brown <broonie@kernel.org>
Date: Sat, 05 Oct 2024 00:19:37 +0100
Subject: [PATCH] KVM: arm64: Expose S1PIE to guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241005-kvm-arm64-fix-s1pie-v1-1-5901f02de749@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAh4AGcC/x2MWwqAIBAArxL73YLaZtFVog/LrZbogYIE0d2TP
 odh5oHIQThCVzwQOEmU88igywKm1R0Lo/jMYJQhrRThlnZ0YbeEs9wY9SWMzvq2HmmsTEOQyyt
 wlv+1H973A6O8CH9lAAAA
X-Change-ID: 20241004-kvm-arm64-fix-s1pie-a6d85b4b3274
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-9b746
X-Developer-Signature: v=1; a=openpgp-sha256; l=1773; i=broonie@kernel.org;
 h=from:subject:message-id; bh=B+4iUDEw9TYIVwLvNxtIxnldk76z5iKCVi04UblglX0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBnAHguVdE8/fczOI8eVu3Gtw6ubFM8lfSIsMkdjqny
 We4dy7mJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZwB4LgAKCRAk1otyXVSH0FvVB/
 wP8b/onSWhqsc+HF62H78QAJSrpNISggmBlTvuLQ/uZhzEVks1nZZvbzIxilCvSzkLVb+um3XCZ8rh
 jo1FnRi/vdpFblhhRYSqidNv8WtvEuipFpnPX96hVgTlplltDqRxdtPK1DKtD6YpC6p8AiQbXJSRyS
 Cq0Ucc7jENUa8aOhcGkJaz0ZsZP5E4QOrhSVISXgdgPT41YKkMHPZEQUlOUKO7X3NOYDqLhakVBCDJ
 esvmu3uU3HBAdb45ZbDxs1J7kj0NkQDb1ArpHtH54N1xGZ54lBcR46ha1OTPU3gu10IX/M0m1NiGg3
 /1n0CAduaL1aC+X7+ImdEpm1Ce689k
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Prior to commit 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
we just exposed the santised view of ID_AA64MMFR3_EL1 to guests, meaning
that they saw both TCRX and S1PIE if present on the host machine. That
commit added VMM control over the contents of the register and exposed
S1POE but removed S1PIE, meaning that the extension is no longer visible
to guests. Reenable support for S1PIE with VMM control.

Fixes: 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dad88e31f9537fe02e28b117d6a740f15572e0ba..d48f89ad6aa7139078e7991ce6c8ebc4a0543551 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1550,7 +1550,8 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
 		break;
 	case SYS_ID_AA64MMFR3_EL1:
-		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE;
+		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
+			ID_AA64MMFR3_EL1_S1PIE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
@@ -2433,6 +2434,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR2_EL1_NV |
 					ID_AA64MMFR2_EL1_CCIDX)),
 	ID_WRITABLE(ID_AA64MMFR3_EL1, (ID_AA64MMFR3_EL1_TCRX	|
+				       ID_AA64MMFR3_EL1_S1PIE   |
 				       ID_AA64MMFR3_EL1_S1POE)),
 	ID_SANITISED(ID_AA64MMFR4_EL1),
 	ID_UNALLOCATED(7,5),

---
base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
change-id: 20241004-kvm-arm64-fix-s1pie-a6d85b4b3274

Best regards,
-- 
Mark Brown <broonie@kernel.org>

