Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE571C01
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9558C4347C;
	Sat, 12 Nov 2022 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266280;
	bh=dBv/8WFqvl+x92t2p/3qrkiszszzeY2izSKz5+WDkYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEKj8U6cAFWqexEy3HcZ0bJPLppy9iba3p2uGOJmdLIbIYhOwpUm+ZIUQfUytVHDl
	 jUmeGTuyjwk6CoKcWvAaBRAGj6SQuqPXyvyMAb5Ys1fyY1wqafh0hXWaOQou9k80Sh
	 SG/3LHzkwoNmlTQudA9bw4WxQ9vLkcCC2/WEYmfbwbWAvM+pZpsZ3tP/FhenqzEcQF
	 +N2yABMSRQbDBjgVeCbdctWkiBmZYs85juhlIxdoVyXPMu87PwZNj6rmlulZk+mzTo
	 /kzxgmIWV9fmH7F5zAQt9XAgzvtc/psK4gNKiW4S/jmLnChBMUlA6fWJDi1jwkJ1sR
	 rcXsmHaWyn2Gg==
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
Subject: [PATCH v2 07/14] arm64/idreg: Add an override for FEAT_NMI
Date: Sat, 12 Nov 2022 15:17:01 +0000
Message-Id: <20221112151708.175147-8-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=771; i=broonie@kernel.org; h=from:subject; bh=dBv/8WFqvl+x92t2p/3qrkiszszzeY2izSKz5+WDkYI=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7js4wn/tRtJYWD2X3MrJ+T/x3CUScp8v13vu4q3 sSp5eluJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+47AAKCRAk1otyXVSH0OEdB/ 9ka05c1+0P1AxiR+1hBpPv6/Mx3568FYfn7eCysUoccydYREkWPXhMns4P2SshLs9+bLYHi+epxwRQ hjtRh3dBhRH4rgW6LspU26kHzSSw/O+/s9eBV/rDvfcaLU42M0cl98DHaTnDWAbQ06LesQk0BKSo4y ocT+n6tF9n/DeP526bEGAZzXiCq99coAgvF1L+D3CYcbLY8cWx2GQKk+eTnbltFYoqtqLg5emSpRRY VqbqlEHwqYXNGdY3MQbF+LznFBEvzgvUOTs8nCaQ2ETLpIhvhwWDdsT1DtyzjqkSQ0OqOAtVzBOrFL PLAmlkGeFn1xT6TjQitqbg13ixK8G5
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Add a named override for FEAT_NMI, allowing it to be explicitly disabled
in case of problems.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/idreg-override.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 95133765ed29..bb25aa3a414b 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -100,6 +100,7 @@ static const struct ftr_set_desc pfr1 __initconst = {
 	.fields		= {
 		FIELD("bt", ID_AA64PFR1_EL1_BT_SHIFT, NULL ),
 		FIELD("mte", ID_AA64PFR1_EL1_MTE_SHIFT, NULL),
+		FIELD("nmi", ID_AA64PFR1_EL1_NMI_SHIFT, NULL),
 		FIELD("sme", ID_AA64PFR1_EL1_SME_SHIFT, pfr1_sme_filter),
 		{}
 	},
-- 
2.30.2

