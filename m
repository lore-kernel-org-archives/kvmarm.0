Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67003BA3E
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 17:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC044C4339E;
	Tue,  7 Mar 2023 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678210651;
	bh=BoVyJdO3TVFcyKTW5XD2bSSMDKj5ELJjrXB+vgQLOtY=;
	h=From:Subject:Date:To:Cc:From;
	b=tFe0L8p4xaSWrtmlanE29FisqsJcsW7euZPr+F57NVlfP+33/V809c+tPlP/TTEUT
	 yVbpHA7Hz0AUvl2YP7yTuUxddB2Cc0tu0gLrx+FfiMTzFxasVZ+UddQQymkFn6ITjd
	 IVWAYF3txjyajb4T+7+OsnAjexZs+y4Bysj2CXfUz7gejxg5GqSTKW9gPl7Fsa2VLK
	 L0RHa6NqLQoI9zZdicoS+jsMPBlWbXD5+ZHEf3fq05O8UUh3b7+scigW90pAF/pZxU
	 G9oYssvbk6SoP0M1RuRpONWsFhEQpvMaQATr8yd2J4SFpNYoF2aKfkeA2neaMMn79Z
	 KD368QsZmpojw==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/3] KVM: arm64: Floating point documentation updates
 and code tweaks
Date: Tue, 07 Mar 2023 17:37:13 +0000
Message-Id: <20221214-kvm-arm64-sme-context-switch-v2-0-57ba0082e9ff@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEl2B2QC/42OTQ6DIBCFr2JYd6qgNdpV79G4QByUWKEZCLUx3
 r3oCbr8Xt7fxjySQc/u2cYIo/HG2QTikjE1STsimCExE4UQXPAK5riApKWuwC8IytmAawD/MUF
 NcCvFoFBL3TecpYpeeoSepFXTUXLmcu0IbArlyhEerjehNut54tklnowPjr7np8gP9c/5yKGAs
 in7qm7bAYv6MSNZfF0djazb9/0HEAMGUO8AAAA=
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=1452; i=broonie@kernel.org;
 h=from:subject:message-id; bh=BoVyJdO3TVFcyKTW5XD2bSSMDKj5ELJjrXB+vgQLOtY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkB3ZV1ZiqthNUWO0NgY0qchFZ5rfAFB8r2oat/dy5
 ejePoX6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZAd2VQAKCRAk1otyXVSH0HSQB/
 0Yf7UkCCfQuANbuaT36UA6E1oBSlm8BjwCslrPxdCZVIAHfJsjc2luLql2BpKyd/qlqOdw+hksFIrP
 O0mikZRZS3t+Hs6D4KXUyj/8QSPkht/Ovma5YcurNA6VJYhUYR3MsAEv0VFb/Fb+jqK84qV40f8zuM
 t4fdXe1xWTpgHMf9n7jgpiDTCAB70KSfxElicjCTHYEwslnm9fUJCD8cTNC4y0jkxYZ7mBZ+ePxXp+
 DrIDjXPjXfaH/IIr84F8Awfp74znDFyHJY45tWzP6qdEeGgUdq1o0t6bW9ZbMJIhOI9ShCOUA9MJ/O
 T/lpqHcE+vAsCIiebwGF9P7H1nkWqV
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

This series has some improvements to the documentation and code for the
KVM floating point code, the main one being that it documents that the
current behaviour where we disable streaming mode and ZA prior to
running guests as being the intended behaviour. There's a more detailed
discussion of that change in the patch commit log, but briefly we need
to disable streaming mode in order to avoid EL1 triggering SME traps to
itself due to executing instructions which should be valid.

Support for SME in guests is still in progress, due to the introduction
of new register state in SME2 it interacts with the pending SME2 support
series so I was hoping to get that merged first.

Changes in v2:
- Rebased onto v6.3-rc1.
- Small clarifications and tweaks.
- Link to v1: https://lore.kernel.org/r/20221214-kvm-arm64-sme-context-switch-v1-0-383b4699de06@kernel.org

---
Mark Brown (3):
      KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
      KVM: arm64: Restructure check for SVE support in FP trap handler
      KVM: arm64: Clarify host SME state management

 arch/arm64/kvm/fpsimd.c                 | 26 +++++++++++++++++---------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++++--
 2 files changed, 27 insertions(+), 11 deletions(-)
---
base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
change-id: 20221214-kvm-arm64-sme-context-switch-532dcefafb81

Best regards,
-- 
Mark Brown <broonie@kernel.org>

