Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947471C01
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28467C43140;
	Sat, 12 Nov 2022 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266278;
	bh=0syKUcI+2B2tD4tFfEA15/8QN3gSt7/4BPz+VWR3zes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRAyaLacb679ka0lDxePdRrfr0VlNMxayb7jOIe7AuCjbSfyVyQQJwtfgrCAV8sBz
	 ogHD3Rcq34lIJsYzq1cIREu+YvIpFF93Q41whr3+3Ml+a41W6yp9yQztrD5akNMhqz
	 tV1in5dYkjPwBx4VWc573jE2mqG/j4r1wY7EunVMrzCl27hWr5ja+P6PRLIDCyq/qP
	 xPTeWbhvhcjTCEGJ7wTqHb88GFjgZ4uqz162MwJQKi5LT9NfOZPAK0oQC/fUDnttK2
	 KH8faPJuHyVCD4tF6n11RANwShHKa5SG+Zix/8li7zjVotTjXSO2iLCNket6tKRBq/
	 iYJpiR+r/lZ0A==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 06/14] arm64/hyp-stub: Enable access to ALLINT
Date: Sat, 12 Nov 2022 15:17:00 +0000
Message-Id: <20221112151708.175147-7-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1041; i=broonie@kernel.org; h=from:subject; bh=0syKUcI+2B2tD4tFfEA15/8QN3gSt7/4BPz+VWR3zes=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jrpTGe27p+Rp8FnHy47ni/l138ihq9e6U2X4lC p6nLsoaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+46wAKCRAk1otyXVSH0JaFB/ 0VCXLhnsP6oUrDauY2b36rjBLziXABA97WjGpB8Sn4XklLv5TdbwQr7B1b6dC1850n7XdmTa68miLe uWcuaeb0STdYDR5nYF7qivCeUf44H87mYeg0Ib8xAU+d9YWDhc08qywHbln8pXl9YmkdSexBA9DLl3 c8qbkASYpDY5GKUUTYP7od1RerxzTOcPerGj+LF+yKT+ORc8dN51bGthyWemTTEpXCtchKIp0gwXnZ v3QLf9bZmuhlH1vJSsLkc+TXGu62QzCmcjUtKlvFYwtqA+T0qKgHuS4iC/eMZWm3F8xwh/ftqioHE5 hRAcAB7lXDxfbQQ76gNjF7gKAl+kDs
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

In order to use NMIs we need to ensure that traps are disabled for it so
update HCRX_EL2 to ensure that TALLINT is not set when we detect support
for NMIs.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/hyp-stub.S | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 2ee18c860f2a..4e0b06467973 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -151,6 +151,18 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 
 .Lskip_sme:
 
+	// NMIs
+	__check_override id_aa64pfr1 ID_AA64PFR1_EL1_NMI_SHIFT 4 .Linit_nmi .Lskip_nmi
+.Linit_nmi:
+	mrs	x1, id_aa64mmfr1_el1		// HCRX_EL2 present?
+	ubfx	x1, x1, #ID_AA64MMFR1_EL1_HCX_SHIFT, #4
+	cbz	x1, .Lskip_nmi
+
+	mrs_s	x1, SYS_HCRX_EL2
+	and	x1, x1, #~HCRX_EL2_TALLINT_MASK	// Don't trap ALLINT
+	msr_s	SYS_HCRX_EL2, x1
+.Lskip_nmi:
+
 	// nVHE? No way! Give me the real thing!
 	// Sanity check: MMU *must* be off
 	mrs	x1, sctlr_el2
-- 
2.30.2

