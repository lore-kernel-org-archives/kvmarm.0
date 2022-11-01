Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A117E
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 11:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B722FC43140;
	Tue,  1 Nov 2022 11:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667302370;
	bh=6lYSPti6YfReqlMvmIWCVKfzCTO/O5AiezSpe9b5syg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XekLVaaYZ4S/8GnKYD0wD7qYALCihH7gcdm0ndW3NIA7T/ejxidt35e4UbK/TM0oT
	 xbRPae6uvKCR0RUPjxFiuT8se+d0OnwLRzrd9VMxIRCGr0es2GiBDWSJLwLW0e8/WN
	 g6TjsRv6zqa5HvjH49o3IpPwr2faHCfRvK1DObRiTu7FT3IPwN3PSonTp5tfIC4EWO
	 xdQULumB3sdEbRYISVaDVnaIYwzDq3gav9ukM2QX+LOvFyDWLXewuToWNo7wb2F2zp
	 APrnJkgKl8u/nBTyjkP5+/2Uxx4IjnzkVXxDBDvI5F21XuxKw0RFxmltyeafMCJoeS
	 jvjeMWHvZ9L3w==
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
Subject: [PATCH v2 1/2] arm64: booting: Document our requirements for fine grained traps with SME
Date: Tue,  1 Nov 2022 11:27:14 +0000
Message-Id: <20221101112716.52035-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221101112716.52035-1-broonie@kernel.org>
References: <20221101112716.52035-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1215; i=broonie@kernel.org; h=from:subject; bh=6lYSPti6YfReqlMvmIWCVKfzCTO/O5AiezSpe9b5syg=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjYQKS5ICf+T6IOSFSxxnAzK4hPsjDs7TrdXs6Jp74 sBGSBhuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2ECkgAKCRAk1otyXVSH0NlTB/ wPd/HF0VWjFzLBLaAKs13uZRe9YvPKR1mOsHYT+DpA2ZE5TYGI+8/U7OD6I+PwJMSj4IIxNsGyYCeW xtLNnVk/sxvsmdfqqIppxhGZqhGONL084HG8ldNul3lE91H6tF13gHgnBM345tcmxWA4RX+fbMGerO ZYghzYV3sBV203/5+5dAHeodXRUKnlHvKqgyJ0UK2pPVfYP2Szm3fEXAow+NnbP95ITOqOY9syPidS 5UqRhMI4XzrnEiHY5XJGAeKJuKUvPMCotJFiNRHd+y8TzVhJAUYbyUdKFE+sL8evP7ShuNCvHeE3Ge fS2iWCNsMa3JUYzOn97JSov+ok9umN
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

With SME we require that fine grained traps on access to TPIDR2_EL0 and
SMPRI_EL1 are disabled but did not document that fact. Add the relevant
register bits.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/arm64/booting.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
index 8aefa1001ae5..8c324ad638de 100644
--- a/Documentation/arm64/booting.rst
+++ b/Documentation/arm64/booting.rst
@@ -340,6 +340,14 @@ Before jumping into the kernel, the following conditions must be met:
     - SMCR_EL2.LEN must be initialised to the same value for all CPUs the
       kernel will execute on.
 
+    - HWFGRTR_EL2.nTPIDR2_EL0 (bit 55) must be initialised to 0b01.
+
+    - HWFGWTR_EL2.nTPIDR2_EL0 (bit 55) must be initialised to 0b01.
+
+    - HWFGRTR_EL2.nSMPRI_EL1 (bit 54) must be initialised to 0b01.
+
+    - HWFGWTR_EL2.nSMPRI_EL1 (bit 54) must be initialised to 0b01.
+
   For CPUs with the Scalable Matrix Extension FA64 feature (FEAT_SME_FA64)
 
   - If EL3 is present:
-- 
2.30.2

